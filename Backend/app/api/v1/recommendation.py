from flask import Blueprint, request

from app.helpers.content import Content

recommendations_endpoint = Blueprint("recommendations", __name__)


@recommendations_endpoint.route("/", methods=["GET"])
def hello_world():
    return Content.get_json({"hello": "world"})
