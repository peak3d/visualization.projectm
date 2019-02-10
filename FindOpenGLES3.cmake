# - Try to find OPENGLES3
# Once done this will define
#
#  OPENGLES3_FOUND        - system has OPENGLES3
#  OPENGLES3_INCLUDE_DIR  - the GLES2 include directory
#  OPENGLES3_LIBRARIES    - Link these to use OPENGLES3

find_package(PkgConfig)
if(PKG_CONFIG_FOUND)
  pkg_check_modules(OPENGLES3 glesv3)
endif(PKG_CONFIG_FOUND)

if(NOT OPENGLES3_FOUND)
  if("${CORE_SYSTEM_NAME}" STREQUAL "ios")
    find_library(OPENGLES3_gl_LIBRARY NAMES OpenGLES PATHS ${CMAKE_OSX_SYSROOT}/System/Library PATH_SUFFIXES Frameworks NO_DEFAULT_PATH)
    set(OPENGLES3_INCLUDE_DIR ${OPENGLES3_gl_LIBRARY}/Headers)
    set(OPENGLES3_egl_LIBRARY ${OPENGLES3_gl_LIBRARY})
  else()
    find_path(OPENGLES3_INCLUDE_DIR GLES3/gl3.h)
    find_library(OPENGLES3_gl_LIBRARY NAMES GLESv3)
    find_library(OPENGLES3_egl_LIBRARY NAMES EGL)
  endif()

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(OPENGLES3 DEFAULT_MSG
    OPENGLES3_INCLUDE_DIR OPENGLES3_gl_LIBRARY OPENGLES3_egl_LIBRARY)

  set(OPENGLES3_LIBRARIES ${OPENGLES3_gl_LIBRARY} ${OPENGLES3_egl_LIBRARY})
endif(NOT OPENGLES3_FOUND)

mark_as_advanced(
  OPENGLES3_INCLUDE_DIR
  OPENGLES3_LIBRARIES
  OPENGLES3_gl_LIBRARY
  OPENGLES3_egl_LIBRARY
)
