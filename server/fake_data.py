import json
from random import randint, uniform
import uuid
from datetime import datetime
from shutil import copyfile


receipts_file = "receipts.txt"

vendors = ["spar", "deichmann", "mercator", "lidl", "tuš", "hofer", "interspar", "eurospin", "sariko", "gda", "dijaški dom vič"]
vendors = list(map(lambda x: x.title(), vendors))

with open(receipts_file, "r") as f:
    data = json.loads(f.read())

receipts = data['receipts']

for month in range(1, 6):
    if month == 5:
        max_day = 20
    else:
        max_day = 29
    for day in range(1, max_day):
        repetitions = randint(1, 3)
        for i in range(repetitions):
            vendor_index = randint(0, len(vendors) -1)
            vendor = vendors[vendor_index]
            price = round(uniform(0.5, 50), 2)
            pk = str(uuid.uuid4())
            time = datetime(year=2018, month=month, day=day, hour=12).timestamp()
            lat = str(uniform(45.896604, 46.252366))
            lon = str(uniform(14.246861, 15.125117))

        receipts.append({
            'vendor': vendor,
            'price': price,
            'id': pk,
            'time': time,
            'lat': lat,
            'lon': lon,
        })
        copyfile('fake_image.jpg', 'images/{}.jpg'.format(pk))

receipts.sort(key=lambda x: x['time'])

data['receipts'] = receipts

with open(receipts_file, "w") as f:
    json.dump(data, f)

