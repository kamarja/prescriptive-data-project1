import os

from flask import Blueprint, jsonify, request
from project.api.models import Host
from project import db

hosts_blueprint = Blueprint('hosts', __name__)


@hosts_blueprint.route('/hosts', methods=['GET', 'POST'])
def all_hosts():
    response_object = dict()
    response_object['hosts'] = [host.to_json() for host in Host.query.all()]
    return jsonify(response_object)


@hosts_blueprint.route('/hosts/ping', methods=['GET'])
def ping():
    return jsonify({
        'status': 'success',
        'message': 'pong!',
        'container_id': os.uname()[1]
    })


if __name__ == '__main__':
    app.run()
