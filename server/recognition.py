from testing_vars import temp
import difflib

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
    receipt_text = data[0]['description'].split("\n")
    vendors = ["spar", "deichmann", "mercator", "lidl", "tus", "hofer", "interspar"]
    possible_vendors = []
    for i in receipt_text[:10]:
        i = i.lower()
        possibilities = difflib.get_close_matches(i, vendors, cutoff=0.8)
        if possibilities:
            possible_vendors += possibilities
    return possible_vendors

if __name__ == '__main__':
    get_price_from_text(temp)
    get_vendor_name_from_text(temp)
