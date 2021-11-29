import io
import json
import requests

from fdk import response


def handler(ctx, data: io.BytesIO=None):

    return response.Response(
        ctx, 
        response_data=json.dumps({"status": "Hello " + data + "!" }),
        headers={"Content-Type": "application/json"}
    )