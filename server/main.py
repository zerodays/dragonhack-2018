import requests
import uuid
from flask import Flask, request, send_from_directory
import recognition
import json
import time
from PIL import Image
import datetime
from collections import defaultdict
import base64
import os.path


app = Flask(__name__)

MONTHS = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
RECEIPTS_FILE = "receipts.txt"
API_KEY = ''


def image_to_base64(image_path):
    with open(image_path, 'rb') as f:
        encoded = base64.b64encode(f.read())
        encoded = encoded.decode('utf-8')
    return str(encoded)


def ocr_image(image):
    url = 'https://vision.googleapis.com/v1/images:annotate?key={}'.format(API_KEY)
    data = {
        'requests': [
            {
                'image': {
                    'content': image,
                },
                'features': [
                    {
                        'type': 'TEXT_DETECTION',
                    },
                ],
                'imageContext': {
                    'languageHints': [
                        'sl'
                    ]
                }
            }
        ]
    }
    r = requests.post(url, json=data)
    return r.json()


@app.route('/recognize', methods=['POST'])
def recognize():
    # Save image
    upload_id = str(uuid.uuid4())
    filename = f'images/{upload_id}.jpg'
    request.files['file'].save(filename)

    # Rotate image if needed
    picture = Image.open(filename)
    if picture.size[0] > picture.size[1]:
        picture.rotate(-90).save(filename)

    # Recognize text from image
    image = image_to_base64(filename)
    data = ocr_image(image)

    receipt_price = recognition.get_price_from_text(data)
    receipt_vendor = recognition.get_vendor_name_from_text(data)

    curr_time = time.time()

    # Prepare the data for json
    json_data_raw = {
        'vendor': receipt_vendor,
        'price': receipt_price,
        'id': upload_id,
        'time': curr_time,
        'lat': request.args.get('lat'),
        'lon': request.args.get('lon'),
    }

    # Check if file exists - if not, make a template file
    if not os.path.exists(RECEIPTS_FILE) or os.path.getsize(RECEIPTS_FILE) == 0:
        with open(RECEIPTS_FILE, "w") as init_f:
            basic_json = {
                'receipts': [],
            }
            json.dump(basic_json, init_f)

    # Read the old data from the file and modify the json
    with open(RECEIPTS_FILE, "r") as f:
        existing_json = json.loads(f.read())
        existing_json['receipts'].append(json_data_raw)

    # Dump the new json into the file
    with open(RECEIPTS_FILE, "w") as f:
        json.dump(existing_json, f)

    # Return the json data
    return history()


@app.route('/history')
def history():
    with open(RECEIPTS_FILE, 'r') as f:
        data = json.loads(f.read())

    data['receipts'] = data['receipts'][-30:]

    return json.dumps(data, ensure_ascii=False)



@app.route('/statistics')
def statistics():
    with open(RECEIPTS_FILE, 'r') as f:
        data = json.loads(f.read())

    data = data['receipts']

    stats = dict()
    for d in data:
        date = datetime.date.fromtimestamp(int(d['time']))
        if (date.year, date.month) not in stats:
            weekdays_dict = dict()
            for i in range(7):
                weekdays_dict[str(i)] = 0.0

            stats[(date.year, date.month)] = {
                'total': 0.0,
                'vendors': defaultdict(int),
                'weekdays': weekdays_dict,
            }

        stats[(date.year, date.month)]['total'] += d['price']
        stats[(date.year, date.month)]['weekdays'][str(date.weekday())] += d['price']
        stats[(date.year, date.month)]['vendors'][d['vendor']] += d['price']

    keys = list(stats.keys())
    keys.sort(reverse=True)

    res = []
    for key in keys:
        res.append({
            'total': round(stats[key]['total'], 2),
            'vendors': stats[key]['vendors'],
            'weekdays': stats[key]['weekdays'],
            'year': key[0],
            'month': MONTHS[key[1] - 1],
        })

    for r in res:
        organized_vendors = {}
        for index, key in enumerate(sorted(r['vendors'].keys(), key=lambda x: r['vendors'][x], reverse=True)):
            if index < 4:
                organized_vendors[key] = round(r['vendors'][key], 2)
            else:
                if 'Others' not in organized_vendors:
                    organized_vendors['Others'] = 0.0
                organized_vendors['Others'] += r['vendors'][key]
        for key in r['weekdays'].keys():
            r['weekdays'][key] = round(r['weekdays'][key], 2)
        for key in organized_vendors.keys():
            organized_vendors[key] = round(organized_vendors[key], 2)
        r['vendors'] = organized_vendors

    return json.dumps({'statistics': res}, ensure_ascii=False)


@app.route('/delete')
def delete_upload():
    to_delete = str(request.args.get('id'))
    print(to_delete)
    with open(RECEIPTS_FILE, 'r') as f:
        data = json.loads(f.read())

    delete_index = None
    for index, receipt in enumerate(data['receipts']):
        if receipt['id'] == to_delete:
            delete_index = index
            break
    data['receipts'].pop(delete_index)

    with open(RECEIPTS_FILE, "w") as f:
        json.dump(data, f)

    return 'neki je podeletal'


@app.route('/<path:filename>')
def server_image(filename):
    return send_from_directory('images', filename)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
