cmake_minimum_required(VERSION 3.15)
project(IDIOT)
set(SKYNET_PATH ${CMAKE_CURRENT_SOURCE_DIR}/skynet)
set(SKYNET_TARGET ${SKYNET_PATH}/skynet 
${SKYNET_PATH}/luaclib/bson.so ${SKYNET_PATH}/luaclib/client.so 
${SKYNET_PATH}/luaclib/lpeg.so ${SKYNET_PATH}/luaclib/md5.so 
${SKYNET_PATH}/luaclib/skynet.so ${SKYNET_PATH}/luaclib/sproto.so
)
add_custom_command(OUTPUT ${SKYNET_TARGET}
    COMMAND make linux -j8
    WORKING_DIRECTORY ${SKYNET_PATH}
    )
add_custom_target(BUILD_SKYENT ALL
    DEPENDS ${SKYNET_TARGET})






