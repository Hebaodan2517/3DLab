cmake_minimum_required(VERSION 3.16)

#setup VCPKG environment

if(DEFINED ENV{VCPKG_ROOT} AND NOT DEFINED CMAKE_TOOLCHAIN_FILE)
  set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake"
      CACHE STRING "")
endif()
if(DEFINED ENV{VCPKG_DEFAULT_TRIPLET} AND NOT DEFINED VCPKG_TARGET_TRIPLET)
  set(VCPKG_TARGET_TRIPLET "$ENV{VCPKG_DEFAULT_TRIPLET}" CACHE STRING "")
endif()

message("CMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}")

project(imgui LANGUAGES CXX)


FILE(GLOB SOURCES_IMGUI "*.c" "*.cpp" "*.h" "*.hpp")

find_package(glfw3 CONFIG REQUIRED)

add_library(imgui STATIC ${SOURCES_IMGUI})
target_link_libraries(imgui PRIVATE glfw)
if(MSVC)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /Z7")
endif()

set_target_properties(imgui PROPERTIES
            		  CXX_STANDARD 17
            		  CXX_EXTENSIONS OFF)
