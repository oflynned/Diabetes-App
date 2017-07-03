from flask import Blueprint, request
from passlib.apps import custom_app_context

from app.app import mongo
from app.helpers.content import Content

user_endpoint = Blueprint("user", __name__)


@user_endpoint.route("/create", methods=["POST"])
def create_user():
    data = request.json
    email = data["email"]
    password = data["password"]
    password_hash = custom_app_context.hash(password)

    new_user = {"email": email, "password": password_hash, "validated": False}

    if not does_user_exist(email):
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


@user_endpoint.route("/login", methods=["POST"])
def login():
    data = request.json
    email = data["email"]
    provided_password = data["password"]
    hash = custom_app_context.hash(provided_password)

    user = list(mongo.db.users.find({"email": email}))[0]
    if custom_app_context.verify(user["password"], hash):
        return Content.get_json({"success": True})
    else:
        return Content.get_json({"success": False})


@user_endpoint.route("/delete", methods=["DELETE"])
def delete_user():
    data = request.json
    email = data["email"]
    mongo.db.users.remove({"email": email})
    return Content.get_json({"success": True})


@user_endpoint.route("/reset-password", methods=["POST"])
def reset_password():
    data = request.json
    email = data["email"]
    new_password = data["new_password"]

    if does_user_exist(email):
        user = list(mongo.db.users.find({"email": email}))[0]
        user["password"] = custom_app_context.hash(new_password)
        mongo.db.users.save(user)

        return Content.get_json({"success": True})
    else:
        return Content.get_json({"success": False, "reason": "user doesn't exist"})


@user_endpoint.route("/validate", methods=["POST"])
def validate_user():
    data = request.json
    email = data["email"]

    if does_user_exist(email):
        user = list(mongo.db.users.find({"email": email}))[0]
        user["validated"] = True
        mongo.db.users.save(user)
        return Content.get_json({"success": True})
    else:
        return Content.get_json({"success": False, "reason": "user doesn't exist"})


def is_user_validated(email):
    user = list(mongo.db.users.find({"email": email}))[0]
    return user["validated"]


def does_user_exist(email):
    results = list(mongo.db.users.find({"email": email}))
    return len(results) > 0


def has_user_been_below_or_above_target_or_hypo():
    pass
