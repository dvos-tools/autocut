#!/bin/bash

# Test Installation Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Installation Test${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_header

# Test 1: Check if autocut is installed
print_status "Testing autocut installation..."
if command -v autocut-setup &> /dev/null; then
    print_status "✅ autocut-setup is available"
else
    print_error "❌ autocut-setup not found"
    exit 1
fi

# Test 2: Check if service files exist
print_status "Testing service files..."
if [ -f "/usr/local/opt/autocut/libexec/dist/app.js" ]; then
    print_status "✅ Service files exist"
else
    print_warning "⚠️  Service files not found (may be development installation)"
fi

# Test 3: Check if config file exists
print_status "Testing configuration..."
if [ -f "/usr/local/opt/autocut/libexec/config.yml" ] || [ -f "config.yml" ]; then
    print_status "✅ Configuration file exists"
else
    print_warning "⚠️  Configuration file not found"
fi

# Test 4: Test service status
print_status "Testing service status..."
if brew services list | grep -q "autocut"; then
    print_status "✅ Service is registered"
    brew services list | grep autocut
else
    print_warning "⚠️  Service not found in brew services"
fi

# Test 5: Test setup script
print_status "Testing setup script..."
if autocut-setup --help &> /dev/null || autocut-setup &> /dev/null; then
    print_status "✅ Setup script works"
else
    print_error "❌ Setup script failed"
fi

# Test 6: Check log files
print_status "Testing log files..."
if [ -f "/usr/local/var/log/autocut.log" ]; then
    print_status "✅ Log files exist"
    echo "Recent logs:"
    tail -5 "/usr/local/var/log/autocut.log" 2>/dev/null || echo "No recent logs"
else
    print_warning "⚠️  Log files not found"
fi

print_status "Installation test complete!"
echo ""
print_status "To start the service: brew services start autocut"
print_status "To configure shortcuts: autocut-setup"
print_status "To view logs: tail -f /usr/local/var/log/autocut.log" 