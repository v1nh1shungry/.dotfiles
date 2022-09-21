cmake_minimum_required(VERSION 3.1...3.24)
project(
  AsynctaskProjectInitProjectName
  VERSION 0.1.0
  LANGUAGES CXX)

find_program(CCACHE_PROGRAM ccache)
if(CCACHE_PROGRAM)
  set(CMAKE_CXX_COMPILER_LAUNCHER "${CCACHE_PROGRAM}")
endif()

add_executable(AsynctaskProjectInitProjectName src/main.cpp)
target_compile_features(AsynctaskProjectInitProjectName PUBLIC cxx_std_23)
target_compile_options(AsynctaskProjectInitProjectName PRIVATE -Wall -Wextra)
