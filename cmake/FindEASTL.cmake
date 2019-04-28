# FindEASTL

# Look for the header files.
find_path(EASTL_MAIN_INCLUDE_DIR NAMES EASTL/version.h
	PATHS
	/usr/local/include
	/usr/local
	/usr/include
	/usr
)

find_path(EASTL_BASE_INCLUDE_DIR NAMES EABase/version.h
	PATHS
	/usr/local/include
	/usr/local
	/usr/include
	/usr
)

set(EASTL_INCLUDE_DIR
	${EASTL_MAIN_INCLUDE_DIR}
	${EASTL_BASE_INCLUDE_DIR}
)

find_file(EASTL_LIBRARY NAMES EASTL
	PATHS
	/usr/local/lib
	/usr/local
	/usr/lib
	/usr
)

# handle the QUIETLY and REQUIRED arguments and set EXPAT_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(EASTL
								  REQUIRED_VARS EASTL_LIBRARY EASTL_MAIN_INCLUDE_DIR EASTL_BASE_INCLUDE_DIR)

mark_as_advanced(EASTL_LIBRARY EASTL_INCLUDE_DIR)
