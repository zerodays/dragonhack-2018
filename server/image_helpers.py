import base64


def image_to_base64(image_path):
    with open(image_path, 'rb') as f:
        encoded = base64.b64encode(f.read())
        encoded = encoded.decode('utf-8')
    return str(encoded)
