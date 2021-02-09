# base image
FROM python:3.8.1-slim

# install netcat
RUN apt-get update && \
    apt-get -y install netcat nginx curl xz-utils iputils-ping procps net-tools net-tools && \
    apt-get clean

# Setup frontend environment
RUN curl -O https://nodejs.org/dist/v14.15.4/node-v14.15.4-linux-x64.tar.xz
RUN tar -xf node-v14.15.4-linux-x64.tar.xz
RUN mkdir -p /usr/local/ && mv node-v14.15.4-linux-x64 /usr/local/
RUN ln -s /usr/local/node-v14.15.4-linux-x64/bin/node /usr/bin/node && \
    ln -s /usr/local/node-v14.15.4-linux-x64/bin/npm /usr/bin/npm && \
    ln -s /usr/local/node-v14.15.4-linux-x64/bin/npx /usr/bin/npx

RUN npm install vue 

# setup nginx 
RUN useradd nginx

# set working directory
WORKDIR /usr/src/app

# add and install requirements
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./pd-hostmanager.conf  /etc/nginx/sites-available/default
COPY ./requirements.txt /usr/src/app/requirements.txt
RUN pip install -r requirements.txt

# add entrypoint.sh
COPY ./entrypoint.sh /usr/src/app/entrypoint.sh
RUN chmod +x /usr/src/app/entrypoint.sh

# add app
COPY . /usr/src/app

# vue environment
COPY ./vue-frontend/package*.json /usr/src/app/vue-frontend/
RUN npm install -g http-server
RUN ln -s /usr/local/node-v14.15.4-linux-x64/bin/http-server /usr/bin/http-server
RUN cd /usr/src/app/vue-frontend && npm install && ROOT_API=http://localhost:5001 npm run build && cd /usr/src/app

EXPOSE 8080 80 5001 5000

# run server
CMD ["/usr/src/app/entrypoint.sh"]
#CMD ["ping", "8.8.8.8"]
