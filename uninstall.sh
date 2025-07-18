#!/bin/bash

# Autocut Service Uninstallation Script

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
    echo -e "${BLUE}  Autocut Service Uninstallation${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_header

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    print_error "Homebrew is not installed. Cannot uninstall autocut service."
    exit 1
fi

# Stop the service if it's running
print_status "Stopping autocut service..."
brew services stop autocut 2>/dev/null || true

# Uninstall the formula
print_status "Uninstalling autocut..."
brew uninstall autocut 2>/dev/null || true

# Remove log files
print_status "Removing log files..."
rm -f /usr/local/var/log/autocut.log
rm -f /usr/local/var/log/autocut.error.log
rm -f /opt/homebrew/var/log/autocut.log
rm -f /opt/homebrew/var/log/autocut.error.log

print_status "Uninstallation complete!"
echo ""
print_status "Autocut service has been removed from your system." 