from flask import Response
from bson import json_util
import time


class Content:
    @staticmethod
    def get_json(data):
        return Response(
            json_util.dumps(data),
            mimetype='application/json'
        )

    @staticmethod
    def current_time_in_millis():
        return int(round(time.time() * 1000))