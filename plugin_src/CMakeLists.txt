cmake_minimum_required (VERSION 3.22.1)

project ("hood-plugin")

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)
set(CMAKE_C_STANDARD 11)
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

add_compile_definitions(
	HAVE_STDINT_H=1
	$<$<BOOL:MSVC>:_CRT_SECURE_NO_WARNINGS=1>
	SAMPGDK_AMALGAMATION=1
)

add_subdirectory(lib)

add_library(hood-plugin SHARED
	"lib/samp-gdk/sampgdk.c"
	"src/exports.def" "src/main.cpp" "src/main.hpp"
  "src/raknet/CRakServer.hpp" "src/raknet/CRakServer.cpp" "src/raknet/RakUtil.hpp"  "src/natives/Weapons.cpp" "src/natives/Natives.hpp" "src/natives/Natives.cpp" "src/Player.hpp" "src/Player.cpp")
target_link_libraries(hood-plugin PRIVATE samp-sdk RakNet)
target_include_directories(hood-plugin PRIVATE "./lib")
#target_precompile_headers(hood-plugin PRIVATE "src/pch.h")
target_compile_features(hood-plugin PRIVATE cxx_std_20)
set_target_properties(hood-plugin
	PROPERTIES
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../plugins
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../plugins
)