from flask import Blueprint

from app.helpers.content import Content
from app.helpers.excel import Excel

recommendations_endpoint = Blueprint("recommendations", __name__)


@recommendations_endpoint.route("/generate-json", methods=["GET"])
def generate_groomed_recommendations():
    return Content.get_json(Excel.groom_content())


@recommendations_endpoint.route("/get-recommendation", methods=["POST"])
def get_recommendation():
    pass
