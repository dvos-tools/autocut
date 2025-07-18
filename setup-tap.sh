#!/bin/bash

# Setup Homebrew Tap Script

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
    echo -e "${BLUE}  Homebrew Tap Setup${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_header

# Get GitHub username
echo -n "Enter your GitHub username: "
read GITHUB_USERNAME

if [ -z "$GITHUB_USERNAME" ]; then
    print_error "GitHub username is required"
    exit 1
fi

# Update files with GitHub username
print_status "Updating files with GitHub username..."

# Update the tap formula
sed -i.bak "s/yourusername/$GITHUB_USERNAME/g" homebrew-tap/Formula/autocut.rb
sed -i.bak "s/yourusername/$GITHUB_USERNAME/g" homebrew-tap/README.md

# Update the main formula
sed -i.bak "s/yourusername/$GITHUB_USERNAME/g" Formula/autocut.rb

# Update GitHub Actions workflow
sed -i.bak "s/yourusername/$GITHUB_USERNAME/g" .github/workflows/release.yml

# Update README files
sed -i.bak "s/yourusername/$GITHUB_USERNAME/g" README.md

# Remove backup files
find . -name "*.bak" -delete

print_status "Files updated successfully!"
echo ""
print_status "Next steps:"
echo ""
echo "1. Create a new GitHub repository named 'homebrew-autocut':"
echo "   https://github.com/new"
echo "   Repository name: homebrew-autocut"
echo "   Description: Homebrew tap for autocut"
echo "   Make it public"
echo ""
echo "2. Push the tap files to the new repository:"
echo "   cd homebrew-tap"
echo "   git init"
echo "   git add ."
echo "   git commit -m 'Initial commit'"
echo "   git branch -M main"
echo "   git remote add origin https://github.com/$GITHUB_USERNAME/homebrew-autocut.git"
echo "   git push -u origin main"
echo ""
echo "3. Set up GitHub repository secrets:"
echo "   Go to your main autocut repository settings"
echo "   Add secret: TAP_TOKEN (Personal Access Token with repo access)"
echo ""
echo "4. Test the installation:"
echo "   brew tap $GITHUB_USERNAME/autocut"
echo "   brew install autocut"
echo ""
print_status "Setup complete!" 