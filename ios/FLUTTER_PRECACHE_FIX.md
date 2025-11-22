# Flutter Precache Required

## The Issue

Pod install downloaded all dependencies successfully but failed during post-install:

```
/Applications/flutter/bin/cache/artifacts/engine/ios/Flutter.xcframework must exist. 
If you're running pod install manually, make sure "flutter precache --ios" is executed first
```

## The Solution

Run these commands from your terminal:

```bash
# Navigate to project root
cd /Users/radu.cucu/Documents/Python/GW/GWfrontend

# Download Flutter iOS engine artifacts
flutter precache --ios

# Then retry pod install
cd ios
pod install
```

## What This Does

`flutter precache --ios` downloads the Flutter engine framework for iOS, which is required by CocoaPods to complete the integration.

This is a one-time download (~200MB) and will take a minute or two.

## After Successful Pod Install

You'll see:
```
Pod installation complete! There are X dependencies from the Podfile and Y total pods installed.
```

Then you can:
1. Generate iOS icons: `flutter pub run flutter_launcher_icons`
2. Run the app: `flutter run -d iPhone` (from VS Code or terminal)
3. Or open in Xcode: `open ios/Runner.xcworkspace`
