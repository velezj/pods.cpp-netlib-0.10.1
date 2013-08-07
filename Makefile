# Default pod makefile distributed with pods version: 12.09.21

default_target: all

# Default to a less-verbose build.  If you want all the gory compiler output,
# run "make VERBOSE=1"
$(VERBOSE).SILENT:

# Figure out where to build the software.
#   Use BUILD_PREFIX if it was passed in.
#   If not, search up to four parent directories for a 'build' directory.
#   Otherwise, use ./build.
ifeq "$(BUILD_PREFIX)" ""
BUILD_PREFIX:=$(shell for pfx in ./ .. ../.. ../../.. ../../../..; do d=`pwd`/$$pfx/build;\
               if [ -d $$d ]; then echo $$d; exit 0; fi; done; echo `pwd`/build)
endif
# create the build directory if needed, and normalize its path name
BUILD_PREFIX:=$(shell mkdir -p $(BUILD_PREFIX) && cd $(BUILD_PREFIX) && echo `pwd`)

# Default to a release build.  If you want to enable debugging flags, run
# "make BUILD_TYPE=Debug"
ifeq "$(BUILD_TYPE)" ""
BUILD_TYPE="Release"
endif

all: pod-build/Makefile
	$(MAKE) -C pod-build all install

	$(MAKE) create-pkconfig

pod-build/Makefile:
	$(MAKE) configure

.PHONY: configure
configure: cpp-netlib-0.10.1/CMakeLists.txt
	@echo "\nBUILD_PREFIX: $(BUILD_PREFIX)\n\n"

	# create the temporary build directory if needed
	@mkdir -p pod-build

	# run CMake to generate and configure the build scripts
	@cd pod-build && cmake -DCMAKE_INSTALL_PREFIX=$(BUILD_PREFIX) \
		   -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) ..

cpp-netlib-0.10.1/CMakeLists.txt:
	$(MAKE) cpp-netlib-fetch-and-make
	@echo "\n Fetched cpp-netlib source \n"

cpp-netlib-fetch-and-make:

	wget -O cpp-netlib-0.10.1.tar.gz "http://commondatastorage.googleapis.com/cpp-netlib-downloads%2F0.10.1%2Fcpp-netlib-0.10.1.tar.gz"

	@tar xzf cpp-netlib-0.10.1.tar.gz

	touch cpp-netlib-0.10.1/CMakeLists.txt

create-pkconfig:

	sed s@PREFIX@$(BUILD_PREFIX)@ cppnetlib-uri-0.10.1.pc > $(BUILD_PREFIX)/lib/pkgconfig/cppnetlib-uri-0.10.1.pc
	sed s@PREFIX@$(BUILD_PREFIX)@ cppnetlib-server-parsers-0.10.1.pc > $(BUILD_PREFIX)/lib/pkgconfig/cppnetlib-server-parsers-0.10.1.pc
	sed s@PREFIX@$(BUILD_PREFIX)@ cppnetlib-client-connections-0.10.1.pc > $(BUILD_PREFIX)/lib/pkgconfig/cppnetlib-client-connections-0.10.1.pc

	echo $(BUILD_PREFIX)/lib/pkgconfig/cppnetlib-uri-0.10.1.pc >> pod-build/install_manifest.txt
	echo $(BUILD_PREFIX)/lib/pkgconfig/cppnetlib-server-parsers-0.10.1.pc >> pod-build/install_manifest.txt
	echo $(BUILD_PREFIX)/lib/pkgconfig/cppnetlib-client-connections-0.10.1.pc >> pod-build/install_manifest.txt



clean:
	-if [ -e pod-build/install_manifest.txt ]; then rm -f `cat pod-build/install_manifest.txt`; fi
	-if [ -d pod-build ]; then $(MAKE) -C pod-build clean; rm -rf pod-build; fi
	-if [ -d cpp-netlib-0.10.1 ]; then rm -rf cpp-netlib-0.10.1; fi

# other (custom) targets are passed through to the cmake-generated Makefile 
%::
	$(MAKE) -C pod-build $@
