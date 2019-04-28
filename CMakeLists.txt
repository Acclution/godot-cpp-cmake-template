project(godot_cpp_cmake_template)
cmake_minimum_required(VERSION 3.13)

set(BUILD_PATH ${CMAKE_SOURCE_DIR}/bin)

if(CMAKE_BUILD_TYPE STREQUAL "")
	set(CMAKE_BUILD_TYPE Debug)
endif()

if(CMAKE_BUILD_TYPE MATCHES Debug)
	add_definitions(-D_DEBUG)
else()
	add_definitions(-DNDEBUG)
endif(CMAKE_BUILD_TYPE MATCHES Debug)

find_program(CCACHE_FOUND ccache)
if(CCACHE_FOUND)
	#set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
	#set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ccache)
endif(CCACHE_FOUND)

# Add the cmake directory to the module path
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake)

# Change the output directory based on platform
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${BUILD_PATH}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${BUILD_PATH}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${BUILD_PATH}")
SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "${BUILD_PATH}")
SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "${BUILD_PATH}")
SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG "${BUILD_PATH}")
SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE "${BUILD_PATH}")
SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG "${BUILD_PATH}")
SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${BUILD_PATH}")

if(ANDROID)
	add_definitions(-DANDROID)
endif()

set(PROJECT_COMPILE_FLAGS )
set(PROJECT_LINKER_FLAGS )

if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
	# using Visual Studio C++
	set(PROJECT_COMPILE_FLAGS "/EHsc /WX") # /GF /MP /W4

	#set(PROJECT_LINKER_FLAGS "/DYNAMICBASE /NXCOMPAT /LARGEADDRESSAWARE")

	if(CMAKE_BUILD_TYPE MATCHES Debug)
		set(PROJECT_COMPILE_FLAGS "${PROJECT_COMPILE_FLAGS} /MDd") # /Od /RTC1 /Zi
	else()
		set(PROJECT_COMPILE_FLAGS "${PROJECT_COMPILE_FLAGS} /MD /O2") # /Oy /GL /Gy
		STRING(REGEX REPLACE "/RTC(su|[1su])" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
		string(REPLACE "/RTC1" "" CMAKE_CXX_FLAGS_DEBUG ${CMAKE_CXX_FLAGS_DEBUG})
	endif(CMAKE_BUILD_TYPE MATCHES Debug)

	add_definitions(-DWIN32_LEAN_AND_MEAN -D_CRT_SECURE_NO_WARNINGS)

	#if(CMAKE_CXX_FLAGS MATCHES "/W[0-4]")
	#	string(REGEX REPLACE "/W[0-4]" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
	#endif()

else()

#elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
	# using Clang
#elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
	# using GCC and maybe MinGW?

	set(PROJECT_COMPILE_FLAGS "-g -Wall -pedantic -pedantic-errors -Wextra -Waggregate-return -Wcast-align -Wwrite-strings")
	set(PROJECT_COMPILE_FLAGS "${PROJECT_COMPILE_FLAGS} -Wchar-subscripts -Wcomment -Wconversion -Wdisabled-optimization -Werror")
	set(PROJECT_COMPILE_FLAGS "${PROJECT_COMPILE_FLAGS} -Wfloat-equal -Wformat -Wformat=2 -Wformat-security -Wformat-y2k")
	set(PROJECT_COMPILE_FLAGS "${PROJECT_COMPILE_FLAGS} -Wimport  -Winit-self -Winline -Winvalid-pch -Wfatal-errors")
	set(PROJECT_COMPILE_FLAGS "${PROJECT_COMPILE_FLAGS} -Wlong-long -Wmissing-braces -Wmissing-field-initializers -Wmissing-format-attribute")
	set(PROJECT_COMPILE_FLAGS "${PROJECT_COMPILE_FLAGS} -Wmissing-include-dirs -Wmissing-noreturn -Wpacked -Wparentheses -Wpointer-arith")
	set(PROJECT_COMPILE_FLAGS "${PROJECT_COMPILE_FLAGS} -Wredundant-decls -Wreturn-type -Wsequence-point -Wshadow -Wsign-compare -Wstack-protector")
	set(PROJECT_COMPILE_FLAGS "${PROJECT_COMPILE_FLAGS} -Wstrict-aliasing -Wstrict-aliasing=2 -Wswitch -Wswitch-default -Wtrigraphs")
	set(PROJECT_COMPILE_FLAGS "${PROJECT_COMPILE_FLAGS} -Wuninitialized -Wunknown-pragmas -Wunreachable-code -Wunused -Wunused-function -Wunused-label")
	set(PROJECT_COMPILE_FLAGS "${PROJECT_COMPILE_FLAGS} -Wunused-parameter -Wunused-value -Wunused-variable -Wvariadic-macros -Wvolatile-register-var -Wno-gnu")

	# -Wcast-qual

	set(PROJECT_LINKER_FLAGS "${PROJECT_LINKER_FLAGS} -static-libgcc -static-libstdc++ -Wl,-R,'$$ORIGIN'")

	if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
		set(PROJECT_COMPILE_FLAGS "${PROJECT_COMPILE_FLAGS} -Wno-non-virtual-dtor -Wno-aggregate-return -Wno-stack-protector -Wno-inline")
	else()
		#set(PROJECT_COMPILE_FLAGS "${PROJECT_COMPILE_FLAGS} -Wimplicit")
		set(PROJECT_LINKER_FLAGS "${PROJECT_LINKER_FLAGS} --no-undefined -static-libgcc -static-libstdc++")
	endif()

	if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
		add_definitions(-DCLANG)
	endif()

	if(CMAKE_BUILD_TYPE MATCHES Debug)
		set(PROJECT_COMPILE_FLAGS "${PROJECT_COMPILE_FLAGS} -fno-omit-frame-pointer -O0 -g2")
	else()
		set(PROJECT_COMPILE_FLAGS "${PROJECT_COMPILE_FLAGS} -O3")
	endif(CMAKE_BUILD_TYPE MATCHES Debug)

	if(ANDROID)
		set(PROJECT_LINKER_FLAGS "${PROJECT_LINKER_FLAGS} -ldl")
	endif()
endif()

find_package(Godot REQUIRED)
find_package(GodotCPP REQUIRED)

find_package(EASTL)
if(EASTL_FOUND)
	#add_definitions(-DUSE_EASTL)
endif()

file(GLOB_RECURSE SCRIPT_SOURCES src/*.c**)
file(GLOB_RECURSE SCRIPT_HEADERS src/*.h**)

add_library(${PROJECT_NAME} SHARED ${SCRIPT_SOURCES} ${SCRIPT_HEADERS})
target_link_libraries(${PROJECT_NAME}
	${GODOT_CPP_LIBRARY}
)

target_include_directories(${PROJECT_NAME}
	PRIVATE
	${CMAKE_SOURCE_DIR}/Code
)

target_include_directories(${PROJECT_NAME}
	SYSTEM PUBLIC
	${GODOT_INCLUDE_DIR}
	${GODOT_CPP_INCLUDE_DIR}
)

set_property(TARGET ${PROJECT_NAME} APPEND_STRING PROPERTY COMPILE_FLAGS ${PROJECT_COMPILE_FLAGS})
set_property(TARGET ${PROJECT_NAME} APPEND_STRING PROPERTY LINK_FLAGS ${PROJECT_LINKER_FLAGS})

set_target_properties(${PROJECT_NAME} PROPERTIES
	CXX_STANDARD 17
	CXX_EXTENSIONS OFF
	CXX_STANDARD_REQUIRED ON
)

set(BITS 32)
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
	set(BITS 64)
endif(CMAKE_SIZEOF_VOID_P EQUAL 8)

string(TOLOWER ${CMAKE_SYSTEM_NAME} SYSTEM_NAME)
string(TOLOWER ${CMAKE_BUILD_TYPE} BUILD_TYPE)

if(ANDROID)
	set(SYSTEM_NAME ${SYSTEM_NAME}.${ANDROID_ABI})
endif()

set_property(TARGET ${PROJECT_NAME} PROPERTY OUTPUT_NAME "${PROJECT_NAME}.${SYSTEM_NAME}.${BUILD_TYPE}.${BITS}")

if(MSVC)
	target_compile_options(${PROJECT_NAME} PRIVATE /std:c++14)
	target_compile_definitions(${PROJECT_NAME} PRIVATE WIN32_LEAN_AND_MEAN _CRT_SECURE_NO_WARNINGS)
endif()
