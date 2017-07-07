from flask import Blueprint, request

from app.helpers.content import Content
from app.app import mongo

plan_endpoint = Blueprint("plan", __name__)


# POST { "email": "...", "time": <int>, "plan": { ... } }
# Note: schema should be standardised on device side
@plan_endpoint.route("/create", methods=["POST"])
def create_plan():
    data = request.json
    data["time"] = Content.current_time_in_millis()
    mongo.db.plans.save(data)
    return Content.get_json({"success": True})


# POST { "email": "..." }
@plan_endpoint.route("/get", methods=["POST"])
def get_plans():
    data = request.json
    email = data["email"]

    plans = list(mongo.db.plans.find({"email": email}))
    return Content.get_json(plans)
