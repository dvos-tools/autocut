#!/bin/bash

# Autocut Service Installation Script

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
    echo -e "${BLUE}  Autocut Service Installation${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_header

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    print_error "Homebrew is not installed. Please install it first:"
    echo "Visit: https://brew.sh"
    exit 1
fi

# Check if Gum is installed
if ! command -v gum &> /dev/null; then
    print_status "Installing Gum..."
    brew install gum
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    print_status "Installing Node.js..."
    brew install node@18
fi

# Build the project
print_status "Building the project..."
npm install
npm run build

# Install as a service
print_status "Installing autocut as a service..."
brew install ./Formula/autocut.rb

# Start the service
print_status "Starting the service..."
brew services start autocut

print_status "Installation complete!"
echo ""
print_status "Next steps:"
echo "1. Configure your shortcuts: autocut-setup"
echo "2. Check service status: brew services list | grep autocut"
echo "3. View logs: tail -f /usr/local/var/log/autocut.log"
echo ""
print_status "For more information, see SERVICE-README.md" 