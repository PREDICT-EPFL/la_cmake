# LA CMake

This repository contains handy CMake helpers to easily and properly export/package a CMake project.

## Usage

Add this repository as a submodule in your project, i.e.
```
git submodule add https://github.com/PREDICT-EPFL/la_cmake.git
```

You then have to include `la_cmake/main.cmake` on top of your `CMakeLists.txt`. This package provides the following macros:

* `la_export_targets(<target> ...)`: exports the provided targets.
* `la_export_dependencies(<deps> ...)`: exports the provided dependencies, i.e. the library including your package don't have to explicitly `find_package` the dependency.
* `la_package()`: generates and packages your CMake project (has to be called last).

## Example `CMakeLists.txt`
```cmake
cmake_minimum_required(VERSION 3.8)
include(la_cmake/main.cmake)
project(my_simple_project VERSION 1.0.0)

# find dependencies
find_package(Eigen3 3.3 REQUIRED NO_MODULE)

# add my library
add_library(${PROJECT_NAME} STATIC my_library.cpp)
target_include_directories(${PROJECT_NAME} PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/>
  $<INSTALL_INTERFACE:include>
)
target_link_libraries(${PROJECT_NAME} PUBLIC Eigen3::Eigen)

# install header files
install(
  DIRECTORY include/
  DESTINATION include
)

# install target
install(
  TARGETS ${PROJECT_NAME}
  EXPORT ${PROJECT_NAME}Targets
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  RUNTIME DESTINATION bin
  INCLUDES DESTINATION include
)
# export targets
la_export_targets(${PROJECT_NAME}Targets)
# add Eigen3 as a dependency
la_export_dependencies(Eigen3)

# package the project such that we can find_package it
la_package()
```