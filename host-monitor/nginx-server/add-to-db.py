from project.api.models import Host
from project import db
import socket
import os
from project import create_app
app = create_app()
app.app_context().push()

def get_uptime():
    with open('/proc/uptime', 'r') as f:
        uptime_seconds = float(f.readline().split()[0])
    return uptime_seconds

host_name = os.uname().nodename
uptime = str(get_uptime()/60/60) 
host_ip = socket.gethostbyname(socket.gethostname())
db.session.add(Host(ip_address=host_ip, host_name=host_name, uptime=uptime))
db.session.commit()


