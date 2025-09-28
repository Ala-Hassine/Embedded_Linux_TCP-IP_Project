# Embedded_Linux_TCP-IP_Project

This Project Involves Developing Network-Enabled Applications On Embedded Devices Running A Linux Operating System.

# Default build (auto-detects platform)
make

# Build with debug symbols
make debug

# Build optimized release
make release

# Clean and rebuild
make clean all

# Run server
make run-server

# Run client (in another terminal)
make run-client

# Show detailed build info
make info-detailed

# Get help
make help

# Force native compilation
CXX=g++ make

# Force cross-compilation (if installed)
CXX=arm-linux-gnueabihf-g++ make

---

## Features of this Automated Makefile:

1. **Auto-detection**: Automatically detects if cross-compiler is available
2. **Build directories**: Organizes objects in `build/` and binaries in `bin/`
3. **Dependency tracking**: Uses `-MMD -MP` for automatic dependency management
4. **Multiple build types**: Support for debug and release builds
5. **Platform-specific flags**: Different flags for native vs embedded
6. **Directory creation**: Automatically creates necessary directories
7. **Colorful output**: Clear, emoji-enhanced build messages
8. **Help system**: Comprehensive help target
9. **Incremental builds**: Only rebuilds changed files
10. **Flexible configuration**: Environment variable overrides

---
