from flask import Flask
from flask_pymongo import PyMongo
import os

from app.api.v1.recommendation import recommendations_endpoint
from app.api.v1.plan import plan_endpoint
from app.api.v1.feedback import feedback_endpoint
from app.api.v1.user import user_endpoint


frontend_dir = os.path.abspath("../templates/")
static_dir = os.path.abspath("../static/")

app = Flask(__name__, template_folder=frontend_dir, static_folder=static_dir)
app.debug = True

app.register_blueprint(recommendations_endpoint, url_prefix="/api/v1/recommendations")
app.register_blueprint(feedback_endpoint, url_prefix="/api/v1/feedback")
app.register_blueprint(plan_endpoint, url_prefix="/api/v1/plans")
app.register_blueprint(user_endpoint, url_prefix="/api/v1/user")

mongo = PyMongo(app)
