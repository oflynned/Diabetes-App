from flask import Blueprint, request

from app.helpers.content import Content
from app.helpers.excel import Excel

import json

recommendations_endpoint = Blueprint("recommendations", __name__)


@recommendations_endpoint.route("/generate-json", methods=["GET"])
def generate_groomed_recommendations():
    return Content.get_json(Excel.groom_content())


# POST {"method": [mdi, pump], "epoch": [before, after], "planning": [planned, unplanned]}
# RETURN [{<suggestion>}, {...}, ...]
@recommendations_endpoint.route("/get-recommendation", methods=["POST"])
def get_recommendation():
    data = request.json
    method = data["method"]
    epoch = data["epoch"]
    planning = data["planning"]

    json_file = Excel.get_file_by_filter(method, epoch, planning)

    return Content.get_json(Excel.get_suggestions_from_file(json_file, method, epoch, planning))
