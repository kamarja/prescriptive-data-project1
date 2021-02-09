#!/usr/bin/env bash

# check for python3

which virtualenv
if [ $? == 0 ]; then
  echo "found python3"
else
  brew install python3
fi

# check if virtualenv is installed
which virtualenv
if [ $? == 0 ]; then
  echo "great you are all set"
else
  pip3 install virtualenv
fi

#creating virtual environment
virtualenv -p python3 venv
