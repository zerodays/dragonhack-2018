#  Dragon Hack 2018
Dragon hack 2018 project that scans receipts using ocr and displays you monthly and weekly statistics for your finances.

## Server
1. Move to server directory
```
cd server
```

2. Create virtual env
```
python -m venv venv3
```

3. Activate it
    - bash
    ```
    source venv3/bin/activate
    ```

    - fish
    ```
    . venv3/bin/activate.fish
    ```

4. Install packages
```
pip install -r requirements.txt
```

5. Run server
```
python main.py
```

**Note:** We are using google for ocr and you need api key with vision api enabled. You should put your key into `API_KEY` variable located in file `server/main.py`.

## APP
We are using [flutter](https://flutter.io) framework for app and it's required to run the app.

1. Move to app directory
```
cd app
```

3. Get packages
```
flutter packages get
```

4. Run app
```
flutter run
```
