# Installing iOS Simulators

It appears that iOS Simulators are missing from your Xcode installation.

## How to Install

1. Open **Xcode**.
2. Go to the menu bar: **Xcode** -> **Settings...** (or Preferences).
3. Select the **Platforms** tab.
4. Look for **iOS** in the list.
5. Click the **Get** button (or the download icon) to install the iOS runtime (e.g., iOS 17.5).

## After Installation

1. **Restart Xcode** and the **Simulator** app.
2. Run `flutter devices` to verify the simulator is detected.
3. Try running your app again:
   ```bash
   flutter run -d iPhone
   ```
