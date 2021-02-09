# base image
FROM postgres:12-alpine
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD postgres
ENV POSTGRES_DB hosts

# run create.sql on init
ADD init.sql /docker-entrypoint-initdb.d
