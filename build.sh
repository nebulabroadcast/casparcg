#!/bin/bash

base_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
GIT_HASH=$(git rev-parse --verify --short HEAD)

echo $GIT_HASH

function error_exit {
    printf "\n\033[0;31mInstallation failed\033[0m\n"
    cd ${base_dir}
    exit 1
}

function finished {
    printf "\n\033[0;92mInstallation completed\033[0m\n"
    cd ${base_dir}
    exit 0
}

if [ ! -d $base_dir/support ]; then
    mkdir $base_dir/support
fi

if [ ! -f $base_dir/support/boost.tar.gz ]; then
    wget https://repo.imm.cz/boost.tar.gz -O $base_dir/support/boost.tar.gz
fi

if [ ! -f $base_dir/support/cef.tar.gz ]; then
    wget https://repo.imm.cz/cef.tar.gz -O $base_dir/support/cef.tar.gz
fi

if [ -d $base_dir/build ]; then
    rm -rf $base_dir/build
fi

mkdir $base_dir/build

docker rmi nebulabroadcast/casparcg

docker build -t nebulabroadcast/casparcg-base $base_dir/base || error_exit
docker build -t nebulabroadcast/casparcg \
  --build-arg CC \
  --build-arg CXX \
  --build-arg PROC_COUNT \
  --build-arg IMAGE_BASE \
  --build-arg GIT_HASH \
  $base_dir || error_exit

echo
echo "Build successful"
echo

tempContainer=$(docker create nebulabroadcast/casparcg)
echo "Extracting from the build container..."
docker cp $tempContainer:/build/staging $base_dir/build/casparcg
docker rm -v $tempContainer


echo "Creating dist archive..."
if [ -f $base_dir/casparcg.tar.gz ]; then
    rm $base_dir/casparcg.tar.gz
fi

cd $base_dir/build
tar -zcvf $base_dir/casparcg.tar.gz ./casparcg
echo ""

finished
