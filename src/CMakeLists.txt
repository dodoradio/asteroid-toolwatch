add_library(asteroid-toolwatch main.cpp resources.qrc)
set_target_properties(asteroid-toolwatch PROPERTIES PREFIX "")

target_link_libraries(
	asteroid-toolwatch
	PUBLIC
		AsteroidApp
)

install(
	TARGETS asteroid-toolwatch
	DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
