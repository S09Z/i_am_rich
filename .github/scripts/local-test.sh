#!/bin/bash
# Local testing script that mimics GitHub Actions workflow
# Use this when act has issues with specific GitHub Actions

set -e  # Exit on error

echo "========================================="
echo "Local Flutter CI Test"
echo "========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print step headers
step() {
    echo ""
    echo -e "${GREEN}▶ $1${NC}"
    echo "---"
}

error() {
    echo ""
    echo -e "${RED}✗ $1${NC}"
    exit 1
}

success() {
    echo ""
    echo -e "${GREEN}✓ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    error "Flutter is not installed or not in PATH"
fi

# Print environment info
step "Environment Information"
echo "Flutter version:"
flutter --version
echo ""
echo "Dart version:"
dart --version
echo ""
echo "Current directory:"
pwd
echo ""

# Run flutter doctor
step "Flutter Doctor"
flutter doctor -v || warning "Flutter doctor found some issues (may be okay)"

# Get dependencies
step "Installing Dependencies"
flutter pub get || error "Failed to get dependencies"

# Verify formatting
step "Verifying Code Formatting"
# Check which format command is available
if command -v dart &> /dev/null && dart format --help &> /dev/null; then
    # Use dart format (newer Flutter versions 3.0+)
    if dart format --set-exit-if-changed .; then
        success "Code formatting is correct"
    else
        error "Code formatting check failed. Run: dart format ."
    fi
elif command -v flutter &> /dev/null && flutter format --help &> /dev/null 2>&1; then
    # Use flutter format (older Flutter versions)
    if flutter format --set-exit-if-changed .; then
        success "Code formatting is correct"
    else
        error "Code formatting check failed. Run: flutter format ."
    fi
else
    warning "Format command not found. Skipping formatting check."
fi

# Analyze code
step "Analyzing Code"
if flutter analyze; then
    success "Code analysis passed"
else
    error "Code analysis failed"
fi

# Run tests
step "Running Tests"
if flutter test; then
    success "All tests passed"
else
    error "Tests failed"
fi

# Check for outdated dependencies
step "Checking for Outdated Dependencies"
flutter pub outdated || warning "Some dependencies are outdated (this is informational)"

# Optional: Build APK (commented out by default as it takes time)
# Uncomment to test Android build locally
# step "Building Android APK"
# if flutter build apk --release; then
#     success "Android APK built successfully"
#     echo "APK location: build/app/outputs/flutter-apk/app-release.apk"
# else
#     error "Android build failed"
# fi

# Summary
echo ""
echo "========================================="
echo -e "${GREEN}✓ All checks passed!${NC}"
echo "========================================="
echo ""
echo "Your code is ready to push to GitHub!"
echo ""
