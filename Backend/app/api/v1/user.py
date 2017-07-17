from flask import Blueprint, request
from passlib.hash import sha256_crypt

from app.app import mongo
from app.helpers.content import Content

user_endpoint = Blueprint("user", __name__)

#http://localhost/api/v1/user/create
# POST {"email": "...", "password": "..."}
# RETURN {"success": <boolean>, "*reason": "..."}
@user_endpoint.route("/create", methods=["POST"])
def create_user():
    data = request.json
    email = data["email"]
    password = data["password"]
    password_hash = sha256_crypt.encrypt(password)

    new_user = {"email": email, "password": password_hash, "validated": False}

    if not __does_user_exist(email):
        mongo.db.users.save(new_user)
        return Content.get_json({"success": True})
    else:
        return Content.get_json({"success": False, "reason": "user already exists"})

# http://localhost/api/v1/user/get
# POST {"email": "..."}
# RETURN {"email": "...", "password": "...", "validated": <boolean>}
@user_endpoint.route("/get", methods=["POST"])
def get_user():
    data = request.json
    user_email = data["email"]
    user_details = mongo.db.users.find({"email": user_email})

    return Content.get_json(user_details[0])

# http://localhost/api/v1/user/get-all
# GET
# RETURN [{<user>}, {...}, ...]
@user_endpoint.route("/get-all", methods=["GET"])
def get_all_users():
    return Content.get_json(mongo.db.users.find())

# http://localhost/api/v1/user/login
# POST {"email": "...", "password": "..."}
# RETURN {"success": <boolean>}
@user_endpoint.route("/login", methods=["POST"])
def login():
    data = request.json
    email = data["email"]
    provided_password = data["password"]
    user_password_hash = list(mongo.db.users.find({"email": email}))[0]["password"]

    if sha256_crypt.verify(provided_password, user_password_hash):
        return Content.get_json({"success": True})
    else:
        return Content.get_json({"success": False})

# http://localhost/api/v1/user/delete
# POST {"email": "..."}
# RETURN {"success": <boolean>}
@user_endpoint.route("/delete", methods=["DELETE"])
def delete_user():
    data = request.json
    email = data["email"]
    mongo.db.users.remove({"email": email})
    return Content.get_json({"success": True})

# http://localhost/api/v1/user/reset-password
# POST {"email": "...", "new_password": "..."}
# RETURN {"success": <boolean>, "*reason": "..."}
@user_endpoint.route("/reset-password", methods=["POST"])
def reset_password():
    data = request.json
    email = data["email"]
    new_password = data["new_password"]

    if __does_user_exist(email):
        user = list(mongo.db.users.find({"email": email}))[0]
        user["password"] = sha256_crypt.encrypt(new_password)
        mongo.db.users.save(user)

        return Content.get_json({"success": True})
    else:
        return Content.get_json({"success": False, "reason": "user doesn't exist"})

# http://localhost/api/v1/user/validate
# POST {"email": "..."}
# RETURN {"success": <boolean>, "*reason": "..."}
@user_endpoint.route("/validate", methods=["POST"])
def validate_user():
    data = request.json
    email = data["email"]

    if __does_user_exist(email):
        user = list(mongo.db.users.find({"email": email}))[0]
        user["validated"] = True
        mongo.db.users.save(user)
        return Content.get_json({"success": True})
    else:
        return Content.get_json({"success": False, "reason": "user doesn't exist"})


def __is_user_validated(email):
    user = list(mongo.db.users.find({"email": email}))[0]
    return user["validated"]


def __does_user_exist(email):
    results = list(mongo.db.users.find({"email": email}))
    return len(results) > 0
