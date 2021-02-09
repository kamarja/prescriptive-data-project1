#!/bin/sh

echo "Waiting for postgres..."

while ! nc -z postgres 5432; do
  sleep 0.1
done

echo "PostgreSQL started"

echo "Setting up flask environment"
python add-to-db.py

echo "Starting Vue"
cd vue-frontend
http-server dist &

echo "Starting gunicorn"
cd /usr/src/app
gunicorn -b 0.0.0.0:5000 manage:app &
echo "Starting nginx server"
nginx -g 'daemon off;'
