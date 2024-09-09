cmake_minimum_required(VERSION 3.12)
project(repro C)

find_package(BISON 3)

bison_target(parser rpcalc.y "${CMAKE_CURRENT_BINARY_DIR}/rpcalc.c")

add_library(repro STATIC "${BISON_parser_OUTPUTS}")
