#!/bin/bash

SOURCE_PATH=$(pwd)
INSTALL_PATH=${INSTALL_PATH:-$HOME/Workspace}
fileset=(create.sh workspace.functions)

mkdir -p ${INSTALL_PATH}/Sandbox
mkdir -p ${INSTALL_PATH}/Active
mkdir -p ${INSTALL_PATH}/Journal

# create links
for file in "${fileset[@]}"; do
	link=${INSTALL_PATH}/${file}

	rm -rf $link
	sudo ln ${SOURCE_PATH}/${file} $link
done
