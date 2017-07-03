from flask import Blueprint, request
from bson.objectid import ObjectId

from app.helpers.content import Content
from app.app import mongo

user_endpoint = Blueprint("user", __name__)


@user_endpoint.route("/create", methods=["POST"])
def create_user():
    data = request.json
    user_email = data["email"]
    user_password = data["password"]

    # TODO password hash
    new_user = {"email": user_email, "password": user_password}

    if not does_user_exist(user_email):
        mongo.db.users.save(new_user)
        return Content.get_json({"success": True})
    else:
        return Content.get_json({"success": False, "reason": "user already exists"})


@user_endpoint.route("/get", methods=["POST"])
def get_user():
    data = request.json
    user_email = data["email"]
    user_details = mongo.db.users.find({"email": user_email})

    return Content.get_json(user_details[0])


@user_endpoint.route("/delete", methods=["DELETE"])
def delete_user():
    data = request.json
    email = data["email"]
    user = list(mongo.db.users.find({"email": email}))[0]


@user_endpoint.route("/edit", methods=["POST"])
def edit_user():
    pass


@user_endpoint.route("/reset-password", methods=["POST"])
def reset_password():
    pass


@user_endpoint.route("/validate", methods=["POST"])
def validate_user():
    pass


def does_user_exist(email):
    results = list(mongo.db.users.find({"email": email}))
    return len(results) > 0


def has_user_been_below_or_above_target_or_hypo():
    pass
