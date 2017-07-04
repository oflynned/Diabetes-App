from flask import Blueprint, request

from app.app import mongo

plan_endpoint = Blueprint("plan", __name__)


# TODO
# POST {"email": "...", "plan": [...]}
def create_plan():
    pass


def get_plan():
    pass


# POST {"email": "..."}
# RETURN {"result": <boolean>}
def has_user_been_below_or_above_target_or_hypo_last_24_hrs():
    pass
