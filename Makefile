# =============================================================================
# Configuration Section
# =============================================================================

# Compiler selection with fallback
ifndef CXX
    ifneq (, $(shell which arm-linux-gnueabihf-g++))
        CXX = arm-linux-gnueabihf-g++
        PLATFORM = embedded
    else
        CXX = g++
        PLATFORM = native
    endif
endif

# Build configuration
BUILD_TYPE ?= release
BUILD_DIR  = build
BIN_DIR    = bin

# Target executables
TARGET_CLIENT = client.run
TARGET_SERVER = server.run

# Directory structure
CLIENT_DIR = Client
SERVER_DIR = Server

# Source files
CLIENT_SOURCES = $(wildcard $(CLIENT_DIR)/*.cpp)
SERVER_SOURCES = $(wildcard $(SERVER_DIR)/*.cpp)

# Object files
CLIENT_OBJS = $(patsubst $(CLIENT_DIR)/%.cpp,$(BUILD_DIR)/client/%.o,$(CLIENT_SOURCES))
SERVER_OBJS = $(patsubst $(SERVER_DIR)/%.cpp,$(BUILD_DIR)/server/%.o,$(SERVER_SOURCES))

# Include directories
INCLUDE_DIRS = -I$(CLIENT_DIR) -I$(SERVER_DIR)

# =============================================================================
# Compiler Flags
# =============================================================================

# Common flags
CXXFLAGS_BASE = -Wall -Wextra -Wpedantic -std=c++11 -MMD -MP

# Debug flags
CXXFLAGS_DEBUG = -g -DDEBUG -O0

# Release flags
CXXFLAGS_RELEASE = -Os -DNDEBUG

# Platform-specific flags
ifeq ($(PLATFORM),embedded)
    CXXFLAGS_PLATFORM = -static -march=armv7-a -mtune=cortex-a8
    LDFLAGS_PLATFORM = -static
else
    CXXFLAGS_PLATFORM = 
    LDFLAGS_PLATFORM = 
endif

# Set flags based on build type
ifeq ($(BUILD_TYPE),debug)
    CXXFLAGS = $(CXXFLAGS_BASE) $(CXXFLAGS_DEBUG) $(CXXFLAGS_PLATFORM) $(INCLUDE_DIRS)
else
    CXXFLAGS = $(CXXFLAGS_BASE) $(CXXFLAGS_RELEASE) $(CXXFLAGS_PLATFORM) $(INCLUDE_DIRS)
endif

LDFLAGS = $(LDFLAGS_PLATFORM)

# =============================================================================
# Build Rules
# =============================================================================

# Default target
all: info $(BIN_DIR)/$(TARGET_CLIENT) $(BIN_DIR)/$(TARGET_SERVER)
	@echo "✅ Build Completed Successfully"
	@echo "📦 Binaries Located In : $(BIN_DIR)/"

# Info display
info:
	@echo "🚀 Starting Build Process ..."
	@echo "🔧 Platform : $(PLATFORM)"
	@echo "🔧 Compiler : $(CXX)"
	@echo "🔧 Build Type : $(BUILD_TYPE)"
	@echo "🔧 Build Directory : $(BUILD_DIR)"

# Client executable
$(BIN_DIR)/$(TARGET_CLIENT): $(CLIENT_OBJS) | $(BIN_DIR)
	@echo "🔨 Linking Client ..."
	$(CXX) $(CLIENT_OBJS) -o $@ $(LDFLAGS)

# Server executable
$(BIN_DIR)/$(TARGET_SERVER): $(SERVER_OBJS) | $(BIN_DIR)
	@echo "🔨 Linking Server ..."
	$(CXX) $(SERVER_OBJS) -o $@ $(LDFLAGS)

# Client object files
$(BUILD_DIR)/client/%.o: $(CLIENT_DIR)/%.cpp | $(BUILD_DIR)/client
	@echo "📝 Compiling $<..."
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Server object files
$(BUILD_DIR)/server/%.o: $(SERVER_DIR)/%.cpp | $(BUILD_DIR)/server
	@echo "📝 Compiling $<..."
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Create directories
$(BUILD_DIR)/client:
	@mkdir -p $@

$(BUILD_DIR)/server:
	@mkdir -p $@

$(BUILD_DIR):
	@mkdir -p $@

$(BIN_DIR):
	@mkdir -p $@

# =============================================================================
# Utility Targets
# =============================================================================

# Clean build artifacts
clean:
	@echo "🧹 Cleaning Build Artifacts ..."
	@rm -rf $(BUILD_DIR) $(BIN_DIR)
	@echo "✅ Clean Completed"

# Run targets
run-server: $(BIN_DIR)/$(TARGET_SERVER)
	@echo "🚀 Starting Server ..."
	@cd $(BIN_DIR) && ./$(TARGET_SERVER)

run-client: $(BIN_DIR)/$(TARGET_CLIENT)
	@echo "🚀 Starting Client ..."
	@cd $(BIN_DIR) && ./$(TARGET_CLIENT)

# Build for debug
debug:
	@$(MAKE) BUILD_TYPE=debug

# Build for release
release:
	@$(MAKE) BUILD_TYPE=release

# Show build information
info-detailed:
	@echo "=== Build Information ==="
	@echo "Compiler : $(CXX)"
	@echo "Platform : $(PLATFORM)"
	@echo "Build Type : $(BUILD_TYPE)"
	@echo "Build Dir : $(BUILD_DIR)"
	@echo "Bin Dir : $(BIN_DIR)"
	@echo "Client Sources : $(CLIENT_SOURCES)"
	@echo "Server Sources : $(SERVER_SOURCES)"
	@echo "Compiler Flags : $(CXXFLAGS)"
	@echo "Linker Flags : $(LDFLAGS)"

# Dependency files
-include $(CLIENT_OBJS:.o=.d)
-include $(SERVER_OBJS:.o=.d)

# Help target
help:
	@echo "Available targets:"
	@echo "  all           - Build both client and server (default)"
	@echo "  debug         - Build with debug symbols"
	@echo "  release       - Build optimized release version"
	@echo "  clean         - Remove all build artifacts"
	@echo "  run-server    - Build and run the server"
	@echo "  run-client    - Build and run the client"
	@echo "  info-detailed - Show detailed build information"
	@echo "  help          - Show this help message"
	@echo ""
	@echo "Environment variables:"
	@echo "  CXX         - Compiler to use (default: auto-detected)"
	@echo "  BUILD_TYPE  - Build type: debug or release (default: release)"

.PHONY: all clean run-server run-client debug release info info-detailed help
