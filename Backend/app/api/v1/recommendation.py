from flask import Blueprint, request

from app.helpers.content import Content
from app.helpers.excel import Excel

recommendations_endpoint = Blueprint("recommendations", __name__)


@recommendations_endpoint.route("/", methods=["GET"])
def hello_world():
    return Content.get_json(Excel.groom_content())
