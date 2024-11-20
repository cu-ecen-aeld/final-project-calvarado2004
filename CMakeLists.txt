cmake_minimum_required(VERSION 3.10)
project(bme280_driver)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -I/home/carlos/final-project-calvarado2004/buildroot/output/build/linux-custom/include")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -I/home/carlos/final-project-calvarado2004/buildroot/output/host/aarch64-buildroot-linux-gnu/sysroot/usr/include")

# Add the path to the source file
add_executable(bme280_driver /home/carlos/final-project-calvarado2004/base_external/bme_driver/bme_driver.c)
