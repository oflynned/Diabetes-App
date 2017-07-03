from flask import Blueprint, request

from app.helpers.content import Content
from app.helpers.excel import Excel

import json

recommendations_endpoint = Blueprint("recommendations", __name__)


@recommendations_endpoint.route("/generate-json", methods=["GET"])
def generate_groomed_recommendations():
    return Content.get_json(Excel.groom_content())


# POST
# {
# "method": [mdi, pump], "epoch": [before, after], "planning": [planned, unplanned],
# "exercise_type": [aerobic, anaerobic, mixed], "exercise_intensity": [mild, moderate, intense, extremely_intense],
# "exercise_duration": [0, 1, 2, 3], "bg_level": <float>, "meal_timing": [before, after]
# }

# RETURN [suggestion]
@recommendations_endpoint.route("/get-recommendation", methods=["POST"])
def get_recommendation():
    data = request.json
    method = data["method"]
    epoch = data["epoch"]
    planning = data["planning"]

    exercise_type = data["exercise_type"]
    exercise_intensity = data["exercise_intensity"]
    exercise_duration = data["exercise_duration"]
    exercise_meal_timing = data["before_after_meal"] if "before_after_meal" in data else None
    exercise_bg_level = data["bg_level"] if "bg_level" in data else -1

    json_file = Excel.get_file_by_filter(method, epoch, planning)
    full_suggestions = Excel.get_suggestions_from_file(json_file)

    suggestions = []

    for item in full_suggestions:
        is_exercise_type = exercise_type == item["exercise_type"]
        is_exercise_intensity = exercise_intensity in item["exercise_intensity"]
        is_exercise_duration = exercise_duration in item["exercise_duration"]

        if is_exercise_type and is_exercise_intensity and is_exercise_duration:
            suggestions = item["exercise_suggestions"]

    groomed_suggestions = []

    # we should groom the suggestions for the parameters passed for meal etc
    for suggestion in suggestions:
        if exercise_meal_timing is not None:
            meal_timing = suggestion["before_after_meal"]
            if exercise_meal_timing == meal_timing or meal_timing == "always":
                groomed_suggestions.append(suggestion["exercise_suggestion"])

        if exercise_bg_level is not -1:
            pass

    return Content.get_json(groomed_suggestions)


@recommendations_endpoint.route("/get-all", methods=["GET"])
def get_all_recommendations():
    return Content.get_json(Excel.get_suggestions_from_file("mdi_before_unplanned.json"))
