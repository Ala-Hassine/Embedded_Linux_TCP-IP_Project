# Default to native compiler
CXX ?= g++
# Uncomment below for cross-compilation after installing the toolchain
# CXX = arm-linux-gnueabihf-g++

CXXFLAGS 		= -Wall -Wextra -Wpedantic -std=c++11 -Os
TARGET_CLIENT 	= client.run
TARGET_SERVER 	= server.run

# Directory paths
CLIENT_DIR = Client
SERVER_DIR = Server

# Source files
CLIENT_SOURCES = $(CLIENT_DIR)/main_client.cpp $(CLIENT_DIR)/client.cpp
SERVER_SOURCES = $(SERVER_DIR)/main_server.cpp $(SERVER_DIR)/server.cpp

all: $(TARGET_CLIENT) $(TARGET_SERVER)
	@echo "... Build Completed Successfully ..."
	@echo "Compiler Used : $(CXX)"

$(TARGET_CLIENT): $(CLIENT_SOURCES) $(CLIENT_DIR)/client.h
	@echo "Building Client With $(CXX) ..."
	$(CXX) $(CXXFLAGS) -o $(TARGET_CLIENT) $(CLIENT_SOURCES)

$(TARGET_SERVER): $(SERVER_SOURCES) $(SERVER_DIR)/server.h
	@echo "Building Server With $(CXX) ..."
	$(CXX) $(CXXFLAGS) -o $(TARGET_SERVER) $(SERVER_SOURCES)

clean:
	@echo "... Cleaning Build Files ..."
	@rm -f $(TARGET_CLIENT) $(TARGET_SERVER)

run-server: $(TARGET_SERVER)
	@echo "Starting Server ..."
	./$(TARGET_SERVER)

run-client: $(TARGET_CLIENT)
	@echo "Starting Client ..."
	./$(TARGET_CLIENT)

# Check if cross-compiler exists
check-cross:
	@which arm-linux-gnueabihf-g++ > /dev/null && echo "Cross-Compiler Is Installed" || echo "Cross-Compiler Not Found ... Using Native Compiler"

.PHONY: all clean run-server run-client check-cross
