from flask import Blueprint

from app.app import mongo

feedback_endpoint = Blueprint("feedback", __name__)


@feedback_endpoint.route("/create", methods=["POST"])
def create_feedback():
    pass


@feedback_endpoint.route("/get", methods=["POST"])
def get_past_feedback():
    pass
