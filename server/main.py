import image_helpers
import requests

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
           ]
       }
   ]
}

r = requests.post(url, json=data)
print(r.json())
