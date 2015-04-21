#! /bin/bash

LIB_DIR=lib

# Install all npm packages and dependencies.
npm install

# Install and update Bourbon and SASS.
mkdir -p $LIB_DIR
cd $LIB_DIR
sudo gem install sass
sudo gem install bourbon
bourbon install

exit 0
