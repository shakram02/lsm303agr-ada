#!/usr/bin/env bash

set -xe
stty 115200 -F /dev/ttyACM1 raw -echo
cat /dev/ttyACM1