from flask import Blueprint, request

from app.helpers.content import Content
from app.app import mongo

feedback_endpoint = Blueprint("feedback", __name__)


# POST { "plan_id": <oid>, "rating": [0 .. 4], "comment": <string> }
@feedback_endpoint.route("/create", methods=["POST"])
def create_feedback():
    data = request.json
    plan_id = data["plan_id"]
    rating = int(data["rating"])

    feedback = {"plan_id": plan_id, "rating": rating}

    if "comment" in data:
        feedback["comment"] = str(data["comment"])

    mongo.db.feedback.save(feedback)
    return Content.get_json({"success": True})


@feedback_endpoint.route("/get", methods=["POST"])
def get_past_feedback():
    data = request.json
    email = data["email"]

    aggregated_history_feedback = []

    # first find the user's plans
    exercise_plans = list(mongo.db.plans.find({"email": email}))

    return Content.get_json(exercise_plans)


# POST {"email": "..."}
# RETURN {"result": <boolean>}
def has_user_been_below_or_above_target_or_hypo_last_24_hrs():
    pass