from flask import Blueprint

from app.app import mongo

feedback_endpoint = Blueprint("feedback", __name__)


def create_feedback():
    pass


def get_feedback():
    pass
