import image_helpers
import requests
import uuid
from flask import Flask, request
import recognition
import json
import time

app = Flask(__name__)


@app.route('/recognize', methods=['POST'])
def recognize():
    id = str(uuid.uuid4())
    filename = f'images/{id}.jpg'

    request.files['file'].save(filename)

    image = image_helpers.image_to_base64(filename)
    # print(request.data)
    # image = image_helpers.image_to_base64('../sample_images/IMG_20180519_123749.jpg')

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

    print(recognition.get_price_from_text(r.json()))

    return 'dummy string'


@app.route('/test_upload')
def upload_test():
    # Load json into 'data'
    data = json.load(open('data3.txt'))

    # Obtain price and vendor name
    receipt_price = recognition.get_price_from_text(data)
    '{:.2f}'.format(receipt_price)
    receipt_vendor = recognition.get_vendor_name_from_text(data)

    # Get current time and generate a receipt ID (COPIED FROM ABOVE - REMOVE ONE OF THEM)
    id = str(uuid.uuid4())
    curr_time = time.time()

    # Prepare the data for json
    json_data_raw = {
        'vendor': receipt_vendor,
        'price': receipt_price,
        'id': id,
        'time': curr_time,
    }

    # Start file stuff
    receipts_file = "receipts.txt"

    # Check if file exists - if not, make a template file
    import os.path
    if not os.path.exists(receipts_file) or os.path.getsize(receipts_file) == 0:
        with open(receipts_file, "w") as init_f:
            basic_json = {
                'receipts': [],
                'total': 0.00,
            }
            json.dump(basic_json, init_f)

    # Read the old data from the file and modify the json
    with open(receipts_file, "r") as f:
        existing_json = json.loads(f.read())
        existing_json['receipts'].append(json_data_raw)

        new_total = float('{:.2f}'.format(existing_json['total'] + receipt_price))

        existing_json['total'] = new_total

    # Dump the new json into the file
    with open(receipts_file, "w") as f:
        json.dump(existing_json, f)

    # Return the json data
    return str(existing_json)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
