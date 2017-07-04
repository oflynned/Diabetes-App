from flask import Blueprint, request

from app.app import mongo

feedback_endpoint = Blueprint("feedback", __name__)


# POST
# {
# "plan_id": <oid>, "was_successful": <boolean>,
#
# if unsuccessful -- need to get params
# "reason": {...}
# }
@feedback_endpoint.route("/create", methods=["POST"])
def create_feedback():
    data = request.json
    plan_id = data["plan_id"]
    success = data["was_successful"]

    if not success:
        reasons_for_failure = []
        for i, key in enumerate(data["reason"]):
            pass


@feedback_endpoint.route("/get", methods=["POST"])
def get_past_feedback():
    pass
