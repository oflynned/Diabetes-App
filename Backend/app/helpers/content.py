from flask import Response
from bson import json_util


class Content:
    @staticmethod
    def get_json(data):
        return Response(
            json_util.dumps(data),
            mimetype='application/json'
        )
