#!/bin/bash

set -e
set -u

find . -type f -name install.sh -exec bash {} \;
