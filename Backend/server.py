import os
from flask import Flask,flash, jsonify, render_template
from flask import send_from_directory,request, redirect, url_for
from flask_pymongo import PyMongo
from flask import Response
import json
from werkzeug.utils import secure_filename
from pymongo import MongoClient
from bson.json_util import dumps
from bson.json_util import loads
import flask_excel as excel
import xlrd
import pandas as pd
import xlsxwriter
import pyexcel as pe
from pyexcel_xlsx import get_data
from pyexcel_xlsx import save_data
import ast



import requests
from flask import Flask, request, jsonify

#uploads folder
UPLOAD_FOLDER = "./uploads/"
#currently allowed extensions
ALLOWED_EXTENSIONS = set(['xls', 'xlsx', 'csv'])




app = Flask(__name__)
app.config["MONGO_DBNAME"] = "diabetes"
app.config["MONGO_URI"] = "mongodb://localhost:27017/diabetes"
app.debug = True
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
mongo = PyMongo(app)

client = MongoClient()
db = client.Diabetes
from datetime import datetime


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
                print "The number of worksheets are ", book.nsheets
                sheet = book.sheet_by_index(0)
                for j in range(0, 20):
                    for i in range(0, 20):
                        print "%s" % sheet.cell_value(i, j)



                str1 = ''.join(str(e) for e in rez_s)
                #save_data(UPLOAD_FOLDER + sugg.filename, str1)
                db.suggestion.drop()
                result_s = db.suggestion.insert_one({"result": rez_s})
            return render_template('index.html')
        return render_template('index.html')
    return render_template('index.html')

@app.route('/api/exercise', methods = ['GET'])
def api_exercise():
    online_api = db.exercise.find()
    online_api = dumps(online_api)
    return  online_api

@app.route('/api/suggestion', methods = ['GET'])
def api_suggestion():
    online_api = db.suggestion.find()
    online_api = dumps(online_api)

    wb = xlrd.open_workbook(UPLOAD_FOLDER + 'app_sug_2.xlsx')
    result = []
    result22 = []


    for x in range(0,wb.nsheets):
        sheet = wb.sheet_by_index(x)
        str_list = filter(None, sheet.row_values(1))
        str_list2 = filter(None, sheet.row_values(2))

        oldValue = json.dumps(str_list)
        oldValue2 = json.dumps(str_list2)

        result.append(oldValue)
        result22.append(oldValue2)

    workbook = xlrd.open_workbook(UPLOAD_FOLDER + 'app_sug_2.xlsx')
    for sheet in workbook.sheets():
        for row in range(sheet.nrows):
            for column in range(sheet.ncols):
                print "row: ", row ," column: ", column, "value: ", sheet.cell(row, column).value
                1+1

    result2 = [json.loads(y) for y in result]

    result32 = [json.loads(y) for y in result22]

    data= {}
    print result2[0]
    print result32[0]

    for x in range(0,len(result2[0])-1):
        data ['data'] = { result2[0][0]:result32[0][0],
                          result2[0][1]:result32[0][1],
                          result2[0][2]:result32[0][2],
                          result2[0][3]:result32[0][3],
                          result2[0][4]:result32[0][4]}
    s =json.dumps(data)

    return s



@app.route('/index')
def hello(name=None):
    return render_template('index.html', name=name)


#function to check for allowed file names
def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


#post function called to upload file
@app.route('/upload', methods = ['POST', 'GET'])
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
            return jsonify({"result": filename, "path":UPLOAD_FOLDER})
        return render_template('index.html')
    return render_template('index.html')



@app.route('/api/v1/', methods=["GET"])
def hello_world():
    return jsonify({"success": True})


if __name__ == '__main__':
    app.secret_key = 'super secret key'

    app.run(host='127.0.0.1', port=3000,debug=True)


