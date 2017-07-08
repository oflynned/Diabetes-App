from flask import Blueprint, request

from app.helpers.content import Content
from app.app import mongo

plan_endpoint = Blueprint("plan", __name__)


class Plan:
    @staticmethod
    def create_plan(data):
        plan_object = {"email": data["email"], "time": Content.current_time_in_millis()}

        # remove the email key as it's now popped to the parent level
        data.pop("email")
        plan_object["plan"] = data
        mongo.db.plans.save(plan_object)


# POST { "email": "..." }
@plan_endpoint.route("/get", methods=["POST"])
def get_plans():
    data = request.json
    email = data["email"]
    plans = list(mongo.db.plans.find({"email": email}))
    return Content.get_json(plans)


@plan_endpoint.route("/get-all", methods=["GET"])
def get_all_plans():
    return Content.get_json(list(mongo.db.plans.find()))
