# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.14

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /Applications/CLion.app/Contents/bin/cmake/mac/bin/cmake

# The command to remove a file.
RM = /Applications/CLion.app/Contents/bin/cmake/mac/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/jay/Desktop/CPSC355

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/jay/Desktop/CPSC355/cmake-build-debug

# Include any dependencies generated for this target.
include CMakeFiles/CPSC355.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/CPSC355.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/CPSC355.dir/flags.make

CMakeFiles/CPSC355.dir/main.c.o: CMakeFiles/CPSC355.dir/flags.make
CMakeFiles/CPSC355.dir/main.c.o: ../main.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/jay/Desktop/CPSC355/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/CPSC355.dir/main.c.o"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/CPSC355.dir/main.c.o   -c /Users/jay/Desktop/CPSC355/main.c

CMakeFiles/CPSC355.dir/main.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/CPSC355.dir/main.c.i"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/jay/Desktop/CPSC355/main.c > CMakeFiles/CPSC355.dir/main.c.i

CMakeFiles/CPSC355.dir/main.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/CPSC355.dir/main.c.s"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/jay/Desktop/CPSC355/main.c -o CMakeFiles/CPSC355.dir/main.c.s

CMakeFiles/CPSC355.dir/print.c.o: CMakeFiles/CPSC355.dir/flags.make
CMakeFiles/CPSC355.dir/print.c.o: ../print.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/jay/Desktop/CPSC355/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building C object CMakeFiles/CPSC355.dir/print.c.o"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/CPSC355.dir/print.c.o   -c /Users/jay/Desktop/CPSC355/print.c

CMakeFiles/CPSC355.dir/print.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/CPSC355.dir/print.c.i"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/jay/Desktop/CPSC355/print.c > CMakeFiles/CPSC355.dir/print.c.i

CMakeFiles/CPSC355.dir/print.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/CPSC355.dir/print.c.s"
	/Library/Developer/CommandLineTools/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/jay/Desktop/CPSC355/print.c -o CMakeFiles/CPSC355.dir/print.c.s

# Object files for target CPSC355
CPSC355_OBJECTS = \
"CMakeFiles/CPSC355.dir/main.c.o" \
"CMakeFiles/CPSC355.dir/print.c.o"

# External object files for target CPSC355
CPSC355_EXTERNAL_OBJECTS =

CPSC355: CMakeFiles/CPSC355.dir/main.c.o
CPSC355: CMakeFiles/CPSC355.dir/print.c.o
CPSC355: CMakeFiles/CPSC355.dir/build.make
CPSC355: CMakeFiles/CPSC355.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/jay/Desktop/CPSC355/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking C executable CPSC355"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/CPSC355.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/CPSC355.dir/build: CPSC355

.PHONY : CMakeFiles/CPSC355.dir/build

CMakeFiles/CPSC355.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/CPSC355.dir/cmake_clean.cmake
.PHONY : CMakeFiles/CPSC355.dir/clean

CMakeFiles/CPSC355.dir/depend:
	cd /Users/jay/Desktop/CPSC355/cmake-build-debug && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/jay/Desktop/CPSC355 /Users/jay/Desktop/CPSC355 /Users/jay/Desktop/CPSC355/cmake-build-debug /Users/jay/Desktop/CPSC355/cmake-build-debug /Users/jay/Desktop/CPSC355/cmake-build-debug/CMakeFiles/CPSC355.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/CPSC355.dir/depend
