import image_helpers
import requests
import uuid
from flask import Flask, request, send_from_directory
import recognition
import json
import time
from PIL import Image

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

@app.route('/<path:filename>')
def server_image(filename):
    return send_from_directory('images', filename)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
