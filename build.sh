#!/bin/bash

# Exit on error
set -e

echo "Installing Flutter..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:`pwd`/flutter/bin"

echo "Configuring Flutter for web..."
flutter config --enable-web

echo "Getting dependencies..."
flutter pub get

echo "Building web app..."
flutter build web --release

echo "Build complete! Output in build/web/"
