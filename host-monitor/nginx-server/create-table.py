import subprocess
import os

POSTGRES_USER = os.environ.get('POSTGRES_USER').strip()
POSTGRES_PASSWORD = os.environ.get('POSTGRES_PASSWORD').strip()
POSTGRES_HOST = os.getenv('PG_HOST', 'postgres').strip()
DATABASE_URL = f'postgres://{POSTGRES_USER}:{POSTGRES_PASSWORD}@postgres:5432/hosts'

from sqlalchemy import create_engine
db_uri = 'postgresql://sample:postgres@postgres:5432/hosts'
db_uri = db_uri.replace('\n','')
engine = create_engine(db_uri)
print (engine.table_names())

def get_tables():
    print("Checking tables")
    return engine.table_names()

def shell_exec(cmd):
    proc = subprocess.Popen([cmd], stdout=subprocess.PIPE, shell=True)
    (out, err) = proc.communicate()
    response = out.decode("utf-8")
    return response

if __name__ == "__main__":
    table_list = get_tables()
    if len(table_list) > 0:
        print("Tables already created")
    else:
        print("Creating tables...")
        create_db = "python manage.py recreate_db"
        result = shell_exec(create_db)
        print(result)
