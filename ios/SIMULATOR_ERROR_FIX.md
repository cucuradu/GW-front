# Fix: Registering simulator runtime with CoreSimulator failed

This error usually happens when the CoreSimulator service is stuck or disk space is low.

## Solution 1: Restart Your Mac (Recommended)
The most effective fix is to simply **restart your computer**. This resets the CoreSimulator background services.
1. Restart your Mac.
2. Open Xcode.
3. Try installing the simulator again.

## Solution 2: Check Disk Space
iOS Simulators require **at least 10-15 GB** of free space to download and extract.
1. Check your free space.
2. If low, clear some space and try again.

## Solution 3: Clear Xcode Caches
If a restart doesn't work, the download might be corrupted.
Run these commands in your terminal to clear caches:

```bash
# Kill simulator processes
killall Simulator 2>/dev/null
sudo killall -9 com.apple.CoreSimulator.CoreSimulatorService 2>/dev/null

# Clear Xcode caches
rm -rf ~/Library/Caches/com.apple.dt.Xcode
rm -rf ~/Library/Developer/CoreSimulator/Caches

# Reset simulator service
xcrun simctl delete unavailable
```

Then open Xcode and try again.

## Solution 4: Manual Installation (Advanced)
If the automatic download keeps failing:
1. Go to [Apple Developer Downloads](https://developer.apple.com/download/all/) (requires login).
2. Search for "iOS 17.x Runtime" (or the version you want).
3. Download the `.dmg` file.
4. Install it via terminal:
   ```bash
   sudo xcode-select -s /Applications/Xcode.app
   xcrun simctl runtime add "/path/to/downloaded/runtime.dmg"
   ```
