# FindGodot

# Look for the header file.
find_path(GODOT_INCLUDE_DIR NAMES nativescript/godot_nativescript.h
	PATHS
	~/.local/include/godot
	/usr/local/include/godot
	/usr/local/godot
	/usr/include/godot
	/usr/godot
	"$ENV{GODOT_PATH}/modules/gdnative/include"
)

message(STATUS ${GODOT_INCLUDE_DIR})

# handle the QUIETLY and REQUIRED arguments and set EXPAT_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Godot
								  REQUIRED_VARS GODOT_INCLUDE_DIR)

mark_as_advanced(GODOT_INCLUDE_DIR)
