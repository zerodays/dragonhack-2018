import image_helpers
import requests
import uuid
from flask import Flask, request, send_from_directory
import recognition
import json
import time
from PIL import Image
import datetime
from collections import defaultdict

app = Flask(__name__)
receipts_file = "receipts.txt"

@app.route('/recognize', methods=['POST'])
def recognize():
    upload_id = str(uuid.uuid4())
    filename = f'images/{upload_id}.jpg'
    request.files['file'].save(filename)
    picture= Image.open(filename)
    picture.rotate(-90).save(filename)

    image = image_helpers.image_to_base64(filename)

    url = 'https://vision.googleapis.com/v1/images:annotate?key=AIzaSyCFA9NO1gfGYOaZuGGzFiCtFLH7fTBj-PE'
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
    data = r.json()

    receipt_price = recognition.get_price_from_text(data)
    '{:.2f}'.format(receipt_price)
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
    import os.path
    if not os.path.exists(receipts_file) or os.path.getsize(receipts_file) == 0:
        with open(receipts_file, "w") as init_f:
            basic_json = {
                'receipts': [],
            }
            json.dump(basic_json, init_f)

    # Read the old data from the file and modify the json
    with open(receipts_file, "r") as f:
        existing_json = json.loads(f.read())
        existing_json['receipts'].append(json_data_raw)

    # Dump the new json into the file
    with open(receipts_file, "w") as f:
        json.dump(existing_json, f)

    # Return the json data
    return history()

@app.route('/history')
def history():
    with open(receipts_file, 'r') as f:
        data = json.loads(f.read())

    data['receipts'] = data['receipts'][:30]

    return json.dumps(data)


vendors = ["spar", "deichmann", "mercator", "lidl", "tuš", "hofer", "interspar", "eurospin", "sariko", "gda", "dijaški dom vič"]
vendors = list(map(lambda x: x.capitalize(), vendors))

months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']

@app.route('/statistics')
def statistics():
    with open(receipts_file, 'r') as f:
        data = json.loads(f.read())

    data = data['receipts']

    stats = dict()
    for d in data:
        date = datetime.date.fromtimestamp(int(d['time']))
        if (date.year, date.month) not in stats:
            vendors_dict = dict()
            for vendor in vendors:
                vendors_dict[vendor] = 0.0
            vendors_dict['Others'] = 0.0

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
                'month': months[key[1] - 1],
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

    return json.dumps({'statistics': res})

@app.route('/<path:filename>')
def server_image(filename):
    return send_from_directory('images', filename)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
