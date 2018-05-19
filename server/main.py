import image_helpers
import requests
import uuid
from flask import Flask, request
import recognition

app = Flask(__name__)


@app.route('/recognize', methods=['POST'])
def recognize():
    id = str(uuid.uuid4())
    filename = f'images/{id}.jpg'

    request.files['file'].save(filename)

    image = image_helpers.image_to_base64(filename)
    # print(request.data)
    #image = image_helpers.image_to_base64('../sample_images/IMG_20180519_123749.jpg')

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


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
