import difflib
import json
from collections import defaultdict


def get_price_from_text(dictionary):
    """
    Recognize price from text
    :param dictionary: dictionary returned from google api
    :return: price as float
    """
    data = dictionary['responses'][0]['textAnnotations']

    # Get main poly positions
    main_vertices = data[0]['boundingPoly']['vertices']
    min_x = min(map(lambda x: x['x'], main_vertices))
    max_x = max(map(lambda x: x['x'], main_vertices))
    min_y = min(map(lambda x: x['y'], main_vertices))
    max_y = max(map(lambda x: x['y'], main_vertices))

    eur_labels = []
    for annotation in data:
        text = annotation['description'].replace(' ', '')
        if 'EUR' not in text:
            continue

        vertices = annotation['boundingPoly']['vertices']
        absolute_x = min(map(lambda x: x['x'], vertices))
        absolute_y = min(map(lambda x: x['y'], vertices))

        eur_labels.append((absolute_x - min_x, absolute_y - min_y))

    occurances = defaultdict(int)

    numbers = []
    for annotation in data:
        text = annotation['description'].replace(' ', '')

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

        # Convert price to number
        try:
            whole = int(splited[0])
            part = int(splited[1])
        except:
            continue

        price = whole + part / 100

        if price == 0:
            continue

        occurances[price] += 1

        # Get position
        vertices = annotation['boundingPoly']['vertices']
        absolute_x = min(map(lambda x: x['x'], vertices))
        absolute_y = min(map(lambda x: x['y'], vertices))

        relative_x = (absolute_x - min_x) / (max_x - min_x)
        relative_y = (absolute_y - min_y) / (max_y - min_y)

        # Calculate position from eur
        absolute_x -= min_x
        absolute_y -= min_y

        distances_x = []
        distances_y = []
        for eur_label in eur_labels:
            distance_x = abs(absolute_x - eur_label[0])
            distance_y = abs(absolute_y - eur_label[1])

            distance_x /= (max_x - min_x)
            distance_y /= (max_y - min_y)

            score_x = 1.0 - distance_x
            score_y = 1.0 - distance_y

            distances_x.append(score_x)
            distances_y.append(score_y)

        height = max(map(lambda x: x['y'], vertices)) - min(map(lambda x: x['y'], vertices))

        res = {
            'price': price,
            'score_x': relative_x * 1.5,
            'score_y': relative_y * 1.2,
            'score_eur_x': max(distances_y),
            'score_eur_y': max(distances_y),
            'score_height': height,
        }

        numbers.append(res)

    # Append price and eur distance score
    max_price = max(map(lambda x: x['price'], numbers))
    max_y_distance = max(map(lambda x: x['score_eur_y'], numbers)) ** 2
    max_height = max(map(lambda x: x['score_height'], numbers))
    max_occurances = max(occurances.values())
    for d in numbers:
        d['score_price'] = (d['price'] / max_price) * 0.2

        d['score_eur_y'] **= 2
        d['score_eur_y'] /= max_y_distance

        d['score_height'] /= max_height
        d['score_height'] *= 1.3
        d['score_occurances'] = occurances[d['price']] / max_occurances

    # Calculate final score
    for d in numbers:
        d['score'] = d['score_x'] + d['score_y'] +  d['score_eur_x'] + d['score_eur_y'] + d['score_height'] + d['score_price'] + d['score_occurances']


    numbers.sort(key=lambda x: x['score'], reverse=True)

    return numbers[0]['price']


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
        data1_possible_vendors = []
        temp_possible_strings = [l for l in possible_strings]
        possible_strings += [j + " d.o.o." for j in temp_possible_strings]  # Add 'd.o.o.' to company names to check the possibility
        possible_strings += [j + " d.d." for j in temp_possible_strings]  # Add 'd.o.o.' to company names to check the possibility
        for i in data.split(" "):  # Checks the data if it contains something close enough to any of the vendor names
            i = i.lower()
            possibilities = difflib.get_close_matches(i, possible_strings, cutoff=diff)
            if possibilities:
                data1_possible_vendors += possibilities
        return list(set(w.rstrip(" d.o.o.").rstrip("d.o.o.").rstrip(" d.d.").rstrip("d.d.") for w in data1_possible_vendors))

    data = dictionary['responses'][0]['textAnnotations']
    receipt_text = data[0]['description'].split("\n")  # Get the actual receipt text

    vendors = ["spar", "deichmann", "mercator", "lidl", "tuš", "hofer", "interspar", "eurospin", "sariko", "gda",
               "dijaški dom vič"]
    possible_vendors = is_close(receipt_text[:20], vendors, 0.8)  # Get the possible vendors

    possible_vendors = list(set(possible_vendors))
    out = ""
    if len(possible_vendors) == 1:  # If only one vendor is found, return it
        out = possible_vendors[0]
    elif len(possible_vendors) > 0:  # If there is more than one vendor found, narrow down the search
        possible_vendors = list(set(is_close(receipt_text[:20], vendors, 1)))
        if possible_vendors:
            out = possible_vendors[0]
        else:  # If suddenly no vendors are found anymore
            possible_vendors = list(set(is_close(receipt_text[:20], vendors, 0.95)))
            if possible_vendors:
                out = possible_vendors[0]
            else:
                out = list(set(is_close(receipt_text[:20], vendors, 1)))[0]  # Return the first found vendor
    if not out:
        out = receipt_text[0]

    else:
        if "," in receipt_text[0]:
            out = receipt_text[0].split(",")[0]
        elif "d.o.o." in receipt_text[0]:
            out = ((receipt_text[0].split("d.o.o."))[0]).rstrip(" ")
        elif "d.d." in receipt_text[0]:
            out = ((receipt_text[0].split("d.d."))[0]).rstrip(" ")

    check_again = is_close(out, vendors, 0.85)
    if check_again:
        out = check_again[0]
    else:
        pass
    return out.capitalize()


if __name__ == '__main__':
    data = json.load(open('data3.txt'))
    get_price_from_text(data)
    get_vendor_name_from_text(data)
