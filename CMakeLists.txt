project(visualization.projectm)

cmake_minimum_required(VERSION 2.6)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR})
if(PACKAGE_CONFIG_PATH)
  set(ENV{PKG_CONFIG_PATH} ${PACKAGE_CONFIG_PATH})
endif()

find_package(Kodi REQUIRED)
find_package(p8-platform REQUIRED)

find_package(ProjectM REQUIRED)

add_definitions(-DHAS_SDL_OPENGL)

set(INCLUDES ${KODI_INCLUDE_DIR}
             ${p8-platform_INCLUDE_DIRS}
             ${PROJECTM_INCLUDE_DIRS})

if(CORE_SYSTEM_NAME STREQUAL "linux")
  set(DEPLIBS -Wl,--whole-archive ${PROJECTM_LIBS} -Wl,--no-whole-archive
              ${extra_libs})
else()
  set(DEPLIBS ${PROJECTM_LIBS}
              ${extra_libs})
endif()

if(APP_RENDER_SYSTEM STREQUAL "gl" OR NOT APP_RENDER_SYSTEM)
  find_package(OpenGL)
  if(OPENGL_FOUND)
    set(DEPLIBS ${DEPLIBS} ${OPENGL_LIBRARIES})
    set(APP_RENDER_SYSTEM gl)
  endif()
endif()

if(APP_RENDER_SYSTEM STREQUAL "gles" OR NOT APP_RENDER_SYSTEM)
  find_package(OpenGLES3)
  if(OPENGLES3_FOUND)
    set(DEPLIBS ${DEPLIBS} ${OPENGLES3_LIBRARIES})
    set(APP_RENDER_SYSTEM gles)
  endif()
endif()

if(NOT APP_RENDER_SYSTEM)
  message(FATAL_ERROR "No rendering API found. Bailing")
endif()

set(PM_SOURCES src/Main.cpp)

include_directories(${INCLUDES})

set(PM_CUSTOM_DATA ${PROJECTM_DATA})
build_addon(visualization.projectm PM DEPLIBS)

include(CPack)
