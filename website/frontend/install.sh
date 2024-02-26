#!/bin/bash

./run.sh npx create-vite@latest ./app --template vue
sudo chown -R $USER:$USER ./website/frontend/app
./run.sh install
