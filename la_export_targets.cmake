#
# Export targets to downstream packages.
#
# Each export name must have been used to install targets using
# ``install(TARGETS ... EXPORT name ...)``.
# The ``install(EXPORT ...)`` invocation is handled by this macros.
#
# @public
#
macro(la_export_targets)
  if(_${PROJECT_NAME}_LA_PACKAGE)
    message(FATAL_ERROR
      "la_export_targets() must be called before la_package()")
  endif()

  if(${ARGC} GREATER 0)
    foreach(_arg ${ARGN})
      list(APPEND _LA_CMAKE_EXPORT_TARGETS "${_arg}")
    endforeach()
  endif()
endmacro()