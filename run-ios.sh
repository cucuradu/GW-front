#!/bin/bash
# Helper script to build and run the iOS app on simulator
# Use this instead of 'flutter run' due to Flutter framework codesigning issues

set -e

SIMULATOR_ID="15282981-2724-48DB-94BB-CD048C8B0A7D"  # iPhone 15
BUNDLE_ID="com.example.gwfront"

echo "🔨 Building iOS app with Xcode..."
cd ios
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination "platform=iOS Simulator,id=$SIMULATOR_ID" \
  build

echo "📦 Installing app on simulator..."
xcrun simctl install "$SIMULATOR_ID" \
  ~/Library/Developer/Xcode/DerivedData/Runner-*/Build/Products/Debug-iphonesimulator/Runner.app

echo "🚀 Launching app..."
xcrun simctl launch "$SIMULATOR_ID" "$BUNDLE_ID"

echo "✅ App launched successfully!"
