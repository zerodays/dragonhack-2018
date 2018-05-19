import image_helpers
import requests
from flask import Flask, request

app = Flask(__name__)


@app.route('/recognize', methods=['POST'])
def recognize():
    # print(request.data)
    image = image_helpers.image_to_base64('../sample_images/IMG_20180519_123741.jpg')

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
    print(r.json())
    return request.data


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
