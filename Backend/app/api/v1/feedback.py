from flask import Blueprint, request

from app.helpers.content import Content
from app.app import mongo

feedback_endpoint = Blueprint("feedback", __name__)


##  POST { "plan_id": <oid>, "rating": [0 .. 4], "comment": <string>, "email": <string> }
@feedback_endpoint.route("/create", methods=["POST"])
def create_feedback():
    data = request.json
    plan_id = data["plan_id"]
    rating = int(data["rating"])
    email = str(data["email"])

    feedback = {"plan_id": plan_id, "rating": rating, "email": email}

    if "comment" in data:
        feedback["comment"] = str(data["comment"])

    mongo.db.feedback.save(feedback)
    return Content.get_json({"success": True})


# POST { "email": <string> }
@feedback_endpoint.route("/get", methods=["POST"])
def get_past_feedback():
    data = request.json
    email = data["email"]

    aggregated_history_feedback = []
    exercise_plans = list(mongo.db.plans.find({"email": email}))
    past_feedback = list(mongo.db.feedback.find({"email": email}))

    for plan in exercise_plans:
        for feedback in past_feedback:
            if str(plan["_id"]) == str(feedback["plan_id"]):
                aggregated_plan = plan
                aggregated_plan["feedback"] = feedback
                aggregated_plan["feedback"].pop("_id")
                aggregated_plan["feedback"].pop("plan_id")
                aggregated_plan["feedback"].pop("email")
                aggregated_history_feedback.append(aggregated_plan)

    return Content.get_json(aggregated_history_feedback)


@feedback_endpoint.route("/get-all", methods=["GET"])
def get_all_feedback():
    return Content.get_json(list(mongo.db.feedback.find()))
