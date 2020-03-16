#!/usr/bin/env bash 
SCRIPT_DIR=$(readlink -f $(dirname "$0"))
#echo $SCRIPT_DIR
ROOT_DIR=$(readlink -f ${SCRIPT_DIR}/..) 
LUA_DIR=${ROOT_DIR}/skynet/3rd/lua
export C_INCLUDE_PATH=${C_INCLUDE_PATH}:${LUA_DIR}
echo "C_INCLUDE_PATH->[${C_INCLUDE_PATH}]"
make -C pbc
make -C pbc/binding/lua53