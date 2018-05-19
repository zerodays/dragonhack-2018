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

        # Split text
        if '.' in text:
            splited = text.split('.')
        else:
            splited = text.split(',')

        # Only one decimal separator will be in nunmber
        if len(splited) != 2:
            continue

        # Assume price is always with 2 decimal numbers and max 4 full numbers
        if len(splited[0]) > 4 or len(splited[1]) != 2:
            continue


        try:
            whole = int(splited[0])
            part = int(splited[1])
        except:
            continue

        price = whole + part / 100

        numbers.append((price, annotation))

    print('\n'.join(map(str, numbers)))


def get_vendor_name_from_text(dictionary):
    def is_close(orig_string, possible_strings, diff):
        return difflib.get_close_matches(orig_string, possible_strings, cutoff=diff)
    data = dictionary['responses'][0]['textAnnotations']
    receipt_text = data[0]['description'].split("\n")
    vendors = ["spar", "deichmann", "mercator", "lidl", "tuš", "hofer", "interspar", ""]
    possible_vendors = []
    for i in receipt_text[:20]:
        i = i.lower()
        possibilities = is_close(i.lower(), vendors, 0.8)
        if possibilities:
            possible_vendors += possibilities
    if len(possible_vendors) == 1:
        return possible_vendors[0]
    elif len(possible_vendors) > 0:
        possible_vendors = is_close(i.lower(), vendors, 1)
        return possible_vendors[0]
    else:
        return receipt_text[0]

if __name__ == '__main__':
    get_price_from_text(temp)
    get_vendor_name_from_text(temp)
