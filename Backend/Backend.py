from flask import Flask, jsonify
from flask_pymongo import PyMongo

app = Flask(__name__)
app.config["MONGO_DBNAME"] = "diabetes"
app.config["MONGO_URI"] = "mongodb://localhost:27017/diabetes"
app.debug = True
mongo = PyMongo(app)


@app.route('/api/v1/', methods=["GET"])
def hello_world():
    return jsonify({"success": True})


if __name__ == '__main__':
    app.run(host='127.0.0.1', port=3000)

