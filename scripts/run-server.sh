#!/bin/bash

cd /website
npm install

rm -rf /website/build /website/dcos-docs
rsync -az --exclude=.git --exclude=tmp /dcos-docs/ /website/dcos-docs/

while true; do
  rsync -az --exclude=.git --exclude=tmp /dcos-docs/ /website/dcos-docs/
  sleep 2
done &

npm start
