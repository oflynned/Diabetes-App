from flask import Flask
from flask_pymongo import PyMongo
import os

frontend_dir = os.path.abspath("../templates")
static_dir = os.path.abspath("../static/")

app = Flask(__name__, template_folder=frontend_dir, static_folder=static_dir)
app.config["MONGO_DBNAME"] = "diabetesplus"
app.config["MONGO_URI"] = "mongodb://localhost:27017/diabetesplus"
app.debug = True

mongo = PyMongo(app)