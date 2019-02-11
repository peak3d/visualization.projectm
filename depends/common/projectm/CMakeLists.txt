project(projectm)

cmake_minimum_required(VERSION 3.3)

find_package(Kodi REQUIRED) # for APP_RENDER_SYSTEM definition
find_package(SDL2)

if(APP_RENDER_SYSTEM STREQUAL "gl" OR NOT APP_RENDER_SYSTEM)
  find_package(OpenGL)
  if(OPENGL_FOUND)
    set(APP_RENDER_SYSTEM gl)
  endif()
endif()

if(APP_RENDER_SYSTEM STREQUAL "gles" OR NOT APP_RENDER_SYSTEM)
  find_package(OpenGLES3)
  if(OPENGLES3_FOUND)
    set(APP_RENDER_SYSTEM gles)
  endif()
endif()

if(NOT APP_RENDER_SYSTEM)
  message(FATAL_ERROR "No rendering API found. Bailing")
endif()

if(APP_RENDER_SYSTEM STREQUAL "gles")
  set(PROJECTM_CONFIG "--enable-gles")
endif()
if(SDL2_FOUND)
  list(APPEND PROJECTM_CONFIG "--enable-sdl")
endif()

include(ExternalProject)
externalproject_add(projectm
                    SOURCE_DIR ${CMAKE_SOURCE_DIR}
                    CONFIGURE_COMMAND cd <SOURCE_DIR> && autoreconf -vif && CXXFLAGS=-I${OUTPUT_DIR}/include CFLAGS=-I${OUTPUT_DIR}/include LDFLAGS=-L${OUTPUT_DIR}/lib ./configure --disable-shared --prefix=${OUTPUT_DIR} --with-pic ${PROJECTM_CONFIG}
                    BUILD_COMMAND make
                    INSTALL_COMMAND ""
                    BUILD_IN_SOURCE 1)

install(CODE "execute_process(COMMAND make install WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})")
