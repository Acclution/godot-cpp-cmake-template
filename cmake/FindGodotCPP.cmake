# FindGodotCpp

# Look for the header file.
find_path(GODOT_CPP_GEN_INCLUDE_DIR NAMES Reference.hpp
	PATHS
	~/.local/include/godot-cpp/gen
	/usr/local/include/godot-cpp/gen
	/usr/local/godot-cpp/gen
	/usr/include/godot-cpp/gen
	/usr/godot-cpp/gen
	"$ENV{GODOT_CPP_PATH}/include/gen"
)

find_path(GODOT_CPP_CORE_INCLUDE_DIR NAMES Godot.hpp
	PATHS
	~/.local/include/godot-cpp/core
	/usr/local/include/godot-cpp/core
	/usr/local/godot-cpp/core
	/usr/include/godot-cpp/core
	/usr/godot-cpp/core
	"$ENV{GODOT_CPP_PATH}/include/core"
)

set(GODOT_CPP_INCLUDE_DIR
	${GODOT_CPP_GEN_INCLUDE_DIR}/..
	${GODOT_CPP_GEN_INCLUDE_DIR}
	${GODOT_CPP_CORE_INCLUDE_DIR}
)

# Look for the library.
set(LIB_NAME_RELEASE libgodot-cpp.linux.release.64.a)
set(LIB_NAME_DEBUG libgodot-cpp.linux.debug.64.a)

if(ANDROID)
	string(TOLOWER ${CMAKE_SYSTEM_NAME} SYSTEM_NAME)

	set(SYSTEM_NAME ${SYSTEM_NAME}.${ANDROID_ABI})

	set(LIB_NAME_RELEASE libgodot-cpp.${SYSTEM_NAME}.release.a)
	set(LIB_NAME_DEBUG libgodot-cpp.${SYSTEM_NAME}.debug.a)
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
	set(LIB_NAME_RELEASE godot-cpp.windows.release.64.lib)
	set(LIB_NAME_DEBUG godot-cpp.windows.debug.64.lib)
endif()

find_file(GODOT_CPP_LIBRARY_RELEASE NAMES ${LIB_NAME_RELEASE}
	PATHS
	~/.local/lib
	/usr/local/lib
	/usr/local
	/usr/lib
	/usr
	"$ENV{GODOT_CPP_PATH}/bin"
)

find_file(GODOT_CPP_LIBRARY_DEBUG NAMES ${LIB_NAME_DEBUG}
	PATHS
	~/.local/lib
	/usr/local/lib
	/usr/local
	/usr/lib
	/usr
	"$ENV{GODOT_CPP_PATH}/bin"
)

if(CMAKE_BUILD_TYPE MATCHES Debug)
	set(GODOT_CPP_LIBRARY ${GODOT_CPP_LIBRARY_DEBUG})
	message(STATUS "GodotCPP using debug library ${LIB_NAME_DEBUG}")
else()
	set(GODOT_CPP_LIBRARY ${GODOT_CPP_LIBRARY_RELEASE})
	message(STATUS "GodotCPP using release library  ${LIB_NAME_RELEASE}")
endif(CMAKE_BUILD_TYPE MATCHES Debug)

# handle the QUIETLY and REQUIRED arguments and set EXPAT_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(GodotCPP
								  REQUIRED_VARS GODOT_CPP_LIBRARY GODOT_CPP_GEN_INCLUDE_DIR GODOT_CPP_CORE_INCLUDE_DIR)

mark_as_advanced(GODOT_CPP_LIBRARY GODOT_CPP_INCLUDE_DIR)
