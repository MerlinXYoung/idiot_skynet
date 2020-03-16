cmake_minimum_required(VERSION 3.15)
project(IDIOT)

list(APPEND CMAKE_PREFIX_PATH /usr/local/protobuf)
# find_package(PkgConfig REQUIRED)
find_package(Protobuf 3.0 REQUIRED)
message(STATUS "protoc:${Protobuf_PROTOC_EXECUTABLE}")
string(REPLACE "/protoc" "" Protobuf_BIN_PATH ${Protobuf_PROTOC_EXECUTABLE})
message(STATUS "protoc:${Protobuf_BIN_PATH}")

set(SKYNET_PATH ${CMAKE_CURRENT_SOURCE_DIR}/skynet)
set(SKYNET_TARGET ${SKYNET_PATH}/skynet 
${SKYNET_PATH}/cservice/gate.so ${SKYNET_PATH}/cservice/harbor.so 
${SKYNET_PATH}/cservice/logger.so ${SKYNET_PATH}/cservice/snlua.so 
${SKYNET_PATH}/luaclib/bson.so ${SKYNET_PATH}/luaclib/client.so 
${SKYNET_PATH}/luaclib/lpeg.so ${SKYNET_PATH}/luaclib/md5.so 
${SKYNET_PATH}/luaclib/skynet.so ${SKYNET_PATH}/luaclib/sproto.so
)
add_custom_command(OUTPUT ${SKYNET_TARGET}
    COMMAND make linux -j8
    WORKING_DIRECTORY ${SKYNET_PATH}
    )
add_custom_target(SKYENT ALL
    DEPENDS ${SKYNET_TARGET})

set(LUADIR ${SKYNET_PATH}/3rd/lua)
set(LUACLIB ${CMAKE_CURRENT_SOURCE_DIR}/luaclib)
set(THIREDS ${CMAKE_CURRENT_SOURCE_DIR}/3rd)

# add_custom_command(OUTPUT ${LUACLIB}/cjson.so
#     COMMAND 
# )
include_directories(${LUADIR})
set(CJSON_SRCS ${THIREDS}/lua-cjson/lua_cjson.c 
${THIREDS}/lua-cjson/strbuf.c 
${THIREDS}/lua-cjson/fpconv.c
)
add_library(cjson SHARED ${CJSON_SRCS})
set_target_properties(cjson PROPERTIES 
    RUNTIME_OUTPUT_DIRECTORY ${LUACLIB}
    LIBRARY_OUTPUT_DIRECTORY ${LUACLIB}
    PREFIX ""
)
# add_dependencies(cjson ${SKYNET} )

set(LFS_SRCS ${THIREDS}/luafilesystem/src/lfs.c )
add_library(lfs SHARED ${LFS_SRCS})
set_target_properties(lfs PROPERTIES 
    RUNTIME_OUTPUT_DIRECTORY ${LUACLIB}
    LIBRARY_OUTPUT_DIRECTORY ${LUACLIB}
    PREFIX ""
    )

    # add_dependencies(lfs ${SKYNET})
add_custom_command(OUTPUT ${LUACLIB}/protobuf.so
    # COMMAND export C_INCLUDE_PATH="$ENV{C_INCLUDE_PATH}:${LUADIR}"
    COMMAND chmod a+x ./build_pbc.sh
    COMMAND ./build_pbc.sh 
    # COMMAND make -j8 
    # COMMAND make -C binding -j8
    # COMMAND make -C binding/lua53 -j8
    COMMAND cp pbc/binding/lua53/protobuf.so ${LUACLIB}/
    WORKING_DIRECTORY ${THIREDS}
    # DEPENDS ${SKYNET_TARGET}
)

add_custom_target(PBC ALL 
    DEPENDS  ${LUACLIB}/protobuf.so
)




