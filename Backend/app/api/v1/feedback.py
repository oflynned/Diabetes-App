from flask import Blueprint

from app.app import mongo

feedback_endpoint = Blueprint("feedback", __name__)


@feedback_endpoint.route("/create", methods=["POST"])
def create_feedback():
    pass


@feedback_endpoint.route("/get", method=["POST"])
def get_feedback():
    pass
