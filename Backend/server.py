import json
import os

import xlrd
from bson.json_util import dumps

from flask import Flask, request, jsonify
from flask import redirect
from flask import render_template
from flask_pymongo import PyMongo

from pymongo import MongoClient
from werkzeug.utils import secure_filename

# uploads folder
UPLOAD_FOLDER = "./uploads/"
# currently allowed extensions
ALLOWED_EXTENSIONS = {'xls', 'xlsx', 'csv'}

app = Flask(__name__)
app.config["MONGO_DBNAME"] = "diabetes"
app.config["MONGO_URI"] = "mongodb://localhost:27017/diabetes"
app.debug = True
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
mongo = PyMongo(app)

client = MongoClient()
db = client.Diabetes


@app.route('/', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        if ('exercise') not in request.files:
            return redirect(request.url)
        exer = request.files['exercise']
        sugg = request.files['suggestion']
        if (sugg.filename == '') and (exer.filename == ''):
            return redirect(request.url)
        if (exer and allowed_file(exer.filename)) or (sugg and allowed_file(sugg.filename)):
            if exer and allowed_file(exer.filename):
                rez_e = request.get_array(field_name='exercise')

                db.exercise.drop()
                result_e = db.exercise.insert_one({"result": rez_e})

            if sugg and allowed_file(sugg.filename):
                filename = secure_filename(sugg.filename)
                rez_s = request.get_array(field_name='suggestion')
                book = xlrd.open_workbook(UPLOAD_FOLDER + sugg.filename)
                print("The number of worksheets are ", book.nsheets)
                sheet = book.sheet_by_index(0)
                for j in range(0, 20):
                    for i in range(0, 20):
                        print("%s" % sheet.cell_value(i, j))

                str1 = ''.join(str(e) for e in rez_s)
                # save_data(UPLOAD_FOLDER + sugg.filename, str1)
                db.suggestion.drop()
                result_s = db.suggestion.insert_one({"result": rez_s})
            return render_template('index.html')
        return render_template('index.html')
    return render_template('index.html')


@app.route('/api/exercise', methods=['GET'])
def api_exercise():
    online_api = db.exercise.find()
    online_api = dumps(online_api)
    return online_api


@app.route('/api/suggestion', methods=['GET'])
def api_suggestion():
    wb = xlrd.open_workbook(UPLOAD_FOLDER + 'app_sug_2.xlsx')
    sheetNames = wb.sheet_names()

    resultnew = []
    resultnewnew = []

    for x in range(0, wb.nsheets):
        sheet = wb.sheet_by_index(x)
        for y in range(0, sheet.nrows):
            resultnew.append(json.dumps(filter(None, sheet.row_values(y))))

        resulttemp = [json.loads(i) for i in resultnew]
        resultnewnew.append(resulttemp)
        resultnew = []

    data = {}
    data2 = []
    data3 = {}
    for x in range(0, len(resultnewnew)):
        for y in range(0, len(resultnewnew[x])):
            # print "row" ,len(resultnewnew[x][y])
            for z in range(0, len(resultnewnew[x][y])):
                # print "value",resultnewnew[x][y][z]
                if (resultnewnew[x][y][z] == resultnewnew[0][1][0]):
                    if (resultnewnew[x][y][z] == ('Aerobic ') or ('Mixed ') or ('Anaerobic ')):
                        data[sheetNames[x]] = {resultnewnew[x][y][z]: resultnewnew[x][y + 1][z],
                                               resultnewnew[x][y][z + 1]: resultnewnew[x][y + 1][z + 1],
                                               resultnewnew[x][y][z + 2]: resultnewnew[x][y + 1][z + 2],
                                               resultnewnew[x][y][z + 3]: resultnewnew[x][y + 1][z + 3]}

                data2.append(data)
                # data = []

    print(data2)
    print(type(data))

    z = json.dumps(data2)
    return z


@app.route('/index')
def hello(name=None):
    return render_template('index.html', name=name)


# function to check for allowed file names
def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


# post function called to upload file
@app.route('/upload', methods=['POST', 'GET'])
def upload():
    if request.method == 'POST':
        if 'inputFile' not in request.files:
            return redirect(request.url)
        file = request.files['inputFile']
        if file.filename == '':
            return redirect(request.url)

        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            return jsonify({"result": filename, "path": UPLOAD_FOLDER})
        return render_template('index.html')
    return render_template('index.html')


@app.route('/api/v1/', methods=["GET"])
def hello_world():
    return jsonify({"success": True})


if __name__ == '__main__':
    app.secret_key = 'super secret key'

    app.run(host='127.0.0.1', port=3000, debug=True)
