cmake_minimum_required(VERSION 3.12)
project(ShuntingYardCppTest)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set the path to the Ada shared library and header
set(SHUNTINGYARD_LIB_DIR ${CMAKE_SOURCE_DIR}/../ada_shunting_algorithim/lib)
set(SHUNTINGYARD_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/../ada_shunting_algorithim/config)

# Add the source
add_executable(shunting_test src/main.cpp)

# Include the Ada header so C++ can see the extern "C" declarations
target_include_directories(shunting_test PRIVATE ${SHUNTINGYARD_INCLUDE_DIR})

# Link against the Ada shared library
target_link_libraries(shunting_test PRIVATE
    ${SHUNTINGYARD_LIB_DIR}/libShuntingyardalgorithm.so
)

# Optionally, add the rpath so the binary knows where to find the .so at runtime
set_target_properties(shunting_test PROPERTIES
    BUILD_RPATH ${SHUNTINGYARD_LIB_DIR}
    INSTALL_RPATH ${SHUNTINGYARD_LIB_DIR}
    INSTALL_RPATH_USE_LINK_PATH TRUE
)

# Install step if needed
# install(TARGETS shunting_test RUNTIME DESTINATION bin)