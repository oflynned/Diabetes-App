import os
from flask import Flask,flash, jsonify, render_template
from flask import send_from_directory,request, redirect, url_for
from flask_pymongo import PyMongo
from flask import Response
import json
from werkzeug.utils import secure_filename
from pymongo import MongoClient
from bson import ObjectId
from bson import json_util
from bson import Binary, Code
from bson.json_util import dumps
from bson.json_util import loads
import flask_excel as excel



import requests
from flask import Flask, request, jsonify

#uploads folder
UPLOAD_FOLDER = 'uploads'
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
        rez = request.get_array(field_name='file')
        result = db.exercise.insert_one({"result":rez})
        return render_template('index.html')

    return render_template('index.html')

@app.route('/api', methods = ['GET'])
def api_hello():
    online_users = db.exercise.find()
    online_users = dumps(online_users)
    return  online_users


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


