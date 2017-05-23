import os
from flask import Flask, jsonify, render_template
from flask import send_from_directory,request, redirect, url_for
from flask_pymongo import PyMongo

from werkzeug.utils import secure_filename


UPLOAD_FOLDER = 'uploads'
ALLOWED_EXTENSIONS = set(['xls', 'xlsx', 'csv'])

app = Flask(__name__)
app.config["MONGO_DBNAME"] = "diabetes"
app.config["MONGO_URI"] = "mongodb://localhost:27017/diabetes"
app.debug = True
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
mongo = PyMongo(app)

@app.route('/', methods=['GET', 'POST'])
def root():
    return render_template('index.html')

@app.route('/index')
def hello(name=None):
    return render_template('index.html', name=name)



def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS



@app.route('/upload', methods = ['POST'])
def upload():
    if 'inputFile' not in request.files:
        flash('No file part')
        return redirect(request.url)
    file = request.files['inputFile']
    if file.filename == '':
        flash('No selected file')
        return redirect(request.url)
    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
        return redirect(url_for('uploaded_file',filename=filename))

    return '''
    <!doctype html>
    <title>Upload new File</title>
    <h1>Upload new File</h1>
    <form method=post enctype=multipart/form-data>
      <p><input type=file name=inputFile>
         <input type=submit value=Upload>
    </form>
    '''
@app.route('/uploads/<filename>')
def uploaded_file(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'],
                               filename)

from werkzeug import SharedDataMiddleware
app.add_url_rule('/uploads/<filename>', 'uploaded_file',
                 build_only=True)
app.wsgi_app = SharedDataMiddleware(app.wsgi_app, {
    '/uploads':  app.config['UPLOAD_FOLDER']
})

@app.route('/api/v1/', methods=["GET"])
def hello_world():
    return jsonify({"success": True})


if __name__ == '__main__':
    app.run(host='127.0.0.1', port=3000,debug=True)

