from project.api.models import Host
from project import db
import socket

host_ip = socket.gethostbyname(socket.gethostname())
Host.query.filter_by(ip_address=ip_address).delete()
db.session.commit()
