# start from base image
FROM ubuntu:18.04

LABEL maintainer="Prakhar Srivastav <prakhar@prakhar.me>"

# install system-wide dependencies for python and node
# apt-get is the package manager to install dependencies onto ubuntu
# yqq flag is used to suppress the output and assumes yes to all questions
RUN apt-get -yqq update
RUN apt-get -yqq install python3-pip python3-dev curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash
RUN apt-get install -yq nodejs

# copy our application code to a new volume in the container /opt/flask-app
ADD flask-app /opt/flask-app
# set the working directory to /opt/flask-app
WORKDIR /opt/flask-app 

# fetch app specific dependencies
# run build command as defined in package.json file
RUN npm install
RUN npm run build
# install python dependencies
RUN pip3 install -r requirements.txt

# expose port
EXPOSE 5000

# start app
CMD [ "python3", "./app.py" ]
