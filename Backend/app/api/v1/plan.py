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

    @staticmethod
    def has_user_been_below_or_above_target_or_hypo_last_24_hrs(email):
        twenty_four_hours_in_millis = 1000 * 60 * 60 * 24
        time_threshold = Content.current_time_in_millis() - twenty_four_hours_in_millis

        # TODO define hypo and outside target, as I need to query past BG values
        bg_query = {"$gt": 15, "$lt": 7}
        query = {"email": email, "time": {"$gt": time_threshold}, "plan": {"bg_level": bg_query}}
        hazardous_bg_plans = list(mongo.db.plans.find(query))
        return len(hazardous_bg_plans) > 0


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
