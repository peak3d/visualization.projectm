project(visualization.projectm)

cmake_minimum_required(VERSION 3.3)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR})
if(PACKAGE_CONFIG_PATH)
  set(ENV{PKG_CONFIG_PATH} ${PACKAGE_CONFIG_PATH})
endif()

add_definitions(-DHAS_SDL_OPENGL)

find_package(Kodi REQUIRED)
find_package(p8-platform REQUIRED)
find_package(ProjectM 3.1.0 REQUIRED)
if(${PROJECTM_VERSION} LESS "3.1.0")
  message(FATAL_ERROR "Installed ProjectM Version ${PROJECTM_VERSION} not usable, minimum 3.1.0 is requried!")
endif()

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

set(PM_SOURCES src/Main.cpp)

include_directories(${INCLUDES})

set(PM_CUSTOM_DATA ${PROJECTM_DATA})
build_addon(visualization.projectm PM DEPLIBS)

include(CPack)
