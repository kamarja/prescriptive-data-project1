import datetime

from flask import current_app
from sqlalchemy.sql import func

from project import db

class Host(db.Model):

    __tablename__ = 'hosts'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    host_name = db.Column(db.String(255), nullable=False)
    ip_address = db.Column(db.String(255), nullable=False)
    uptime = db.Column(db.String(255), nullable=False)

    def __init__(self, host_name, ip_address, uptime):
        self.host_name = host_name
        self.ip_address = ip_address
        self.uptime = uptime

    def to_json(self):
        return {
            'id': self.id,
            'host_name': self.host_name,
            'ip_address': self.ip_address,
            'uptime': self.uptime
        }
