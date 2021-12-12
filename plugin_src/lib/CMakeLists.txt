set(BUILD_STATIC_LIBS ON)

#
## SAMP SDK
#
add_library(samp-sdk STATIC
	"samp-sdk/amxplugin.cpp"
	"samp-sdk/amxplugin2.cpp"
)

if(UNIX)
	target_sources(samp-sdk PUBLIC "samp-sdk/amx/getch.c")
endif()

target_include_directories(samp-sdk PUBLIC "./samp-sdk" "./samp-sdk/amx")

#
## SAMP GDK
#
add_library(SAMPGDK STATIC
	"samp-gdk/sampgdk.c"
)
target_link_libraries(SAMPGDK PUBLIC samp-sdk)
target_include_directories(SAMPGDK PUBLIC "./samp-sdk" "./samp-gdk")

#
## RakNet
#
add_library(RakNet STATIC
	"raknet/BitStream.cpp"
)
target_include_directories(RakNet PUBLIC "./raknet")