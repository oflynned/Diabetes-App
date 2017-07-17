from flask import Blueprint, request

from app.helpers.content import Content
from app.helpers.excel import Excel
from app.api.v1.plan import Plan

recommendations_endpoint = Blueprint("recommendations", __name__)


@recommendations_endpoint.route("/generate-json", methods=["GET"])
def generate_groomed_recommendations():
    return Content.get_json(Excel.groom_content())


# POST
#http://localhost/api/v1/recommendations/get
# {
# "method": [mdi, pump], "epoch": [before, after], "planning": [planned, unplanned],
# "exercise_type": [aerobic, anaerobic, mixed], "exercise_intensity": [mild, moderate, intense, extremely_intense],
# "meal_timing": [within_3_hrs_of_meal, more_than_3_hrs_after_meal], "exercise_genre": [gym, team, other]
# "exercise_duration": [0, 1, 2, 3]<float>, "bg_level": <float>
# }

# RETURN [suggestion, ...]
@recommendations_endpoint.route("/get", methods=["POST"])
def get_recommendation():
    data = request.json
    method = data["method"]
    epoch = data["epoch"]
    planning = data["planning"]
    email = data["email"]

    # we need the requester to be able to make a plan

    exercise_type = data["exercise_type"]
    exercise_intensity = data["exercise_intensity"]
    exercise_duration = data["exercise_duration"]
    exercise_meal_timing = data["meal_timing"]
    exercise_bg_level = data["bg_level"]
    exercise_genre = data["exercise_genre"]

    json_file = Excel.get_file_by_filter(method, epoch, planning)
    full_suggestions = Excel.get_suggestions_from_file(json_file)
    sheet_parameter_name = Excel.get_file_parameter_name(full_suggestions)
    suggestions = []

    # first get the coarse suggestion object from the type, intensity and duration
    for item in full_suggestions:
        is_exercise_type = exercise_type == item["exercise_type"]
        is_exercise_intensity = exercise_intensity in item["exercise_intensity"]
        is_exercise_duration = exercise_duration in item["exercise_duration"]

        print ("exercise duration", is_exercise_duration)

        if is_exercise_type and is_exercise_intensity and is_exercise_duration:
            suggestions = item["exercise_suggestions"]
            print ("suggestions", suggestions)

    groomed_suggestions = []

    # we should groom the suggestions for the parameters passed for meal etc
    # this for loop iterates over a known suggestion set, but not all suggestions in it may apply
    for suggestion in suggestions:
        if sheet_parameter_name is not None:
            # value of the parameter in rows given the 4th col
            # [always, bg<5, bg<7, bg>15, before_meal, after_meal, gym, team]
            param_value = suggestion[sheet_parameter_name]

            # check for the exercise genre
            if param_value == exercise_genre:
                groomed_suggestions.append(suggestion["exercise_suggestion"])

            if sheet_parameter_name == "before_after_meal" or "bg_below_or_above_target_hypo_last_24hrs":
                if exercise_meal_timing == param_value or param_value == "always":
                    groomed_suggestions.append(suggestion["exercise_suggestion"])
            elif sheet_parameter_name == "bg":
                if __get_bg_level_tag(exercise_bg_level, param_value) or param_value == "always":
                    groomed_suggestions.append(suggestion["exercise_suggestion"])

        else:
            groomed_suggestions.append(suggestion["exercise_suggestion"])


    # given a recommendation exists now, we can now return the suggestions
    if groomed_suggestions is not []:
        Plan.create_plan(data)
        #return groomed_suggestions
        print ("groomed_Stuff type - ", type(groomed_suggestions))
        print ("groomed_Stuff length- ", len(groomed_suggestions))
        return Content.get_json(groomed_suggestions)

    elif groomed_suggestions is []:

        return Content.get_json({"success": False})


def __get_bg_level_tag(reported_bg_level, tag):
    if tag is not "always":
        stripped_tag = str(tag).replace("bg", "")
        tag_sign = stripped_tag[:1]

        if tag_sign == "<":
            if reported_bg_level < 7 and tag == "bg<7":
                return True
            elif reported_bg_level < 5 and tag == "bg<5":
                return True
        elif tag_sign == ">":
            if reported_bg_level > 15 and tag == "bg>15":
                return True

    return False
