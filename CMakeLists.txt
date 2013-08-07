cmake_minimum_required(VERSION 2.6.0)

# pull in the pods macros. See cmake/pods.cmake for documentation
set(POD_NAME cpp-netlib)
include(cmake/pods.cmake)

#add_subdirectory( cpp-netlib-0.10.1 )

find_package( Threads )

if (CMAKE_BUILD_TYPE MATCHES Debug)
    add_definitions(-DBOOST_NETWORK_DEBUG)
endif()

set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")
add_definitions(-DBOOST_NETWORK_ENABLE_HTTPS)


#add_subdirectory(cpp-netlib-0.10.1/libs/network/src)
#add_subdirectory(libs/network/test)
#add_subdirectory(libs/mime/test)
#add_subdirectory(libs/network/example)

include_directories( cpp-netlib-0.10.1 )

set(CPP-NETLIB_URI_SRCS cpp-netlib-0.10.1/libs/network/src/uri/uri.cpp 
			cpp-netlib-0.10.1/libs/network/src/uri/schemes.cpp)
add_library(cppnetlib-uri ${CPP-NETLIB_URI_SRCS})

set(CPP-NETLIB_HTTP_SERVER_SRCS cpp-netlib-0.10.1/libs/network/src/server_request_parsers_impl.cpp)
add_library(cppnetlib-server-parsers ${CPP-NETLIB_HTTP_SERVER_SRCS})

set(CPP-NETLIB_HTTP_CLIENT_SRCS cpp-netlib-0.10.1/libs/network/src/client.cpp)
add_library(cppnetlib-client-connections ${CPP-NETLIB_HTTP_CLIENT_SRCS})


# These are the libraries explicitly in the libs/network/src subdir
# And so here we add the pods packages used explicitly
pods_use_pkg_config_packages( cppnetlib-uri
			      boost-1.54.0
			      boost-1.54.0-unit-test-framework
			      boost-1.54.0-system
			      boost-1.54.0-regex
			      boost-1.54.0-date-time
			      boost-1.54.0-thread
			      boost-1.54.0-filesystem
			      boost-1.54.0-program-options
			      boost-1.54.0-chrono
			      openssl-1.0.1e )

pods_use_pkg_config_packages( cppnetlib-server-parsers
			      boost-1.54.0
			      boost-1.54.0-unit-test-framework
			      boost-1.54.0-system
			      boost-1.54.0-regex
			      boost-1.54.0-date-time
			      boost-1.54.0-thread
			      boost-1.54.0-filesystem
			      boost-1.54.0-program-options
			      boost-1.54.0-chrono
			      openssl-1.0.1e )

pods_use_pkg_config_packages( cppnetlib-client-connections
			      boost-1.54.0
			      boost-1.54.0-unit-test-framework
			      boost-1.54.0-system
			      boost-1.54.0-regex
			      boost-1.54.0-date-time
			      boost-1.54.0-thread
			      boost-1.54.0-filesystem
			      boost-1.54.0-program-options
			      boost-1.54.0-chrono
			      openssl-1.0.1e )




enable_testing()
