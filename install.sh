#!/bin/bash

SOURCE_PATH=$(pwd)
INSTALL_PATH=${INSTALL_PATH:-$HOME/Workspace}

mkdir -p ${INSTALL_PATH}/Sandbox
mkdir -p ${INSTALL_PATH}/Active
mkdir -p ${INSTALL_PATH}/Journal

# create link(s)
fileset=( create.sh )
for file in "${fileset[@]}"; do
	link=${INSTALL_PATH}/${file}

	rm -rf $link
	sudo ln ${SOURCE_PATH}/${file} $link
done
