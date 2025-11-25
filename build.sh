#!/bin/bash
# Exit on error
set -e

# Install Flutter
echo "Installing Flutter..."
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Run Flutter Doctor (optional, but good for debugging)
flutter doctor

# Enable web
flutter config --enable-web

# Get dependencies
echo "Getting dependencies..."
flutter pub get

# Build web
echo "Building web app..."
flutter build web --release --renderer kanvaskit

echo "Build complete!"
