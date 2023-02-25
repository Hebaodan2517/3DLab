
cmake_minimum_required (VERSION 3.8)





#setup VCPKG environment

if(DEFINED ENV{VCPKG_ROOT} AND NOT DEFINED CMAKE_TOOLCHAIN_FILE)
  set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake"
      CACHE STRING "")
endif()
if(DEFINED ENV{VCPKG_DEFAULT_TRIPLET} AND NOT DEFINED VCPKG_TARGET_TRIPLET)
  set(VCPKG_TARGET_TRIPLET "$ENV{VCPKG_DEFAULT_TRIPLET}" CACHE STRING "")
endif()

message("CMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}")





#setup project

set(ProjectName "3DLab")

project (${ProjectName} VERSION 0.1
                        DESCRIPTION "点云实验平台"
                        LANGUAGES CXX)





#add source files

FILE(GLOB PROJECT_SOURCES "./src/*.c" "./src/*.cpp" "./src/inc/*.h" "./src/inc/*.hpp")

#aux_source_directory("./src" PROJECT_SOURCES)
add_executable(${ProjectName} ${PROJECT_SOURCES})
set_target_properties(${ProjectName} PROPERTIES
                        CXX_STANDARD 11
                        CXX_EXTENSIONS OFF)




#add include dir

include_directories("./src/inc/")
target_include_directories(${ProjectName} PRIVATE "./libs/")


#add libraries

add_subdirectory("libs/imgui/")
add_subdirectory("libs/glad")


find_package(glfw3 CONFIG REQUIRED)
find_package(glm CONFIG REQUIRED)
find_package(assimp CONFIG REQUIRED)

#link libraries

target_link_libraries(${ProjectName} PRIVATE glfw)
target_link_libraries(${ProjectName} PRIVATE glm::glm)
target_link_libraries(${ProjectName} PRIVATE assimp::assimp)
target_link_libraries(${ProjectName} PRIVATE glad)
target_link_libraries(${ProjectName} PRIVATE imgui)
