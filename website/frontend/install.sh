#!/bin/bash

set -eu


./website/frontend/run.sh --- npx create-vite@latest ./app --template vue
sudo chown -R ${1:-$USER}:${2:-$USER} ./website/frontend/app
./website/frontend/run.sh install
