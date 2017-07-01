from flask import Flask
from flask_pymongo import PyMongo
import os

from app.api.v1.recommendation import recommendations_endpoint

frontend_dir = os.path.abspath("../templates/")
static_dir = os.path.abspath("../static/")

app = Flask(__name__, template_folder=frontend_dir, static_folder=static_dir)
app.debug = True

app.register_blueprint(recommendations_endpoint, url_prefix="/api/v1/recommendations")

mongo = PyMongo(app)
