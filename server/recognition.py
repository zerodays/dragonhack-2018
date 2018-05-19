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
    """
    Recognize receipt vendor from text
    :param dictionary: dictionary returned from google api
    :return: vendor as string (lowercase)
    """

    def is_close(data, possible_strings, diff):
        """
        Uses difflib to check if any of the stringsis close enough to any of the predetermined vendors
        """
        temp_possible_vendors = []
        possible_strings += [j + " d.o.o." for j in possible_strings]
        for i in data:  # Checks the data if it contains something close enough to any of the vendor names
            i = i.lower()
            possibilities = difflib.get_close_matches(i, possible_strings, cutoff=diff)
            if possibilities:
                temp_possible_vendors += possibilities
        return list(set(w.rstrip(" d.o.o.").rstrip("d.o.o.") for w in temp_possible_vendors))

    data = dictionary['responses'][0]['textAnnotations']
    receipt_text = data[0]['description'].split("\n")

    vendors = ["spar", "deichmann", "mercator", "lidl", "tuš", "hofer", "interspar", "eurospin", "sariko", "gda", "dijaški dom vič"]
    possible_vendors = is_close(receipt_text[:20], vendors, 0.8)

    possible_vendors = list(set(possible_vendors))
    if len(possible_vendors) == 1:  # If only one vendor is found, return it
        return possible_vendors[0]
    elif len(possible_vendors) > 0:  # If there is more than one vendor found, narrow down the search
        possible_vendors = list(set(is_close(receipt_text[:20], vendors, 1)))
        if possible_vendors:
            return possible_vendors[0]
        else:
            possible_vendors = list(set(is_close(receipt_text[:20], vendors, 0.95)))
            if possible_vendors:
                return possible_vendors[0]
            return list(set(is_close(receipt_text[:20], vendors, 1)))[0]
    else:
        return receipt_text[0]


if __name__ == '__main__':
    # get_price_from_text(temp)
    print(get_vendor_name_from_text(temp))
