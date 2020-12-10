#!/bin/bash

base_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $base_dir
echo "Starting CasparCG server in $(pwd)"

RET=5
while [ $RET -eq 5 ]
do
  LD_LIBRARY_PATH=lib bin/casparcg "$@"
  RET=$?
done
