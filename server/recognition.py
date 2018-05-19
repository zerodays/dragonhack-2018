from testing_vars import temp

def get_price_from_text(dictionary):
    """
    Recognize price from text
    :param dictionary: dictionary returned from google api
    :return: price as float
    """
    data = dictionary['responses'][0]['textAnnotations']
    numbers = []
    for annotation in data:
        text = annotation['description']

        # Price contains decimal separator
        if '.' not in text and ',' not in text:
            continue

        # There is probably only one decimal separator
        if '.' in text and ',' in text:
            continue

        if '.' in text:
            splited = text.split('.')
        else:
            splited = text.split(',')

def get_vendor_name_from_text(dictionary):
    data = dictionary['responses'][0]['textAnnotations']
    receipt_text = data[0]['description']
    vendors = ["spar", "deichmann", ""]

if __name__ == '__main__':
    get_price_from_text(temp)
    get_vendor_name_from_text(temp)
