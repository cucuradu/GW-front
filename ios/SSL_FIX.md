# SSL Certificate Fix for CocoaPods

## Problem

CocoaPods pod install is failing with SSL certificate verification error:
```
SSL_connect returned=1 errno=0 state=error: certificate verify failed (unable to get local issuer certificate)
```

This is a system-level issue with Ruby/OpenSSL certificate trust.

## Solutions

### Solution 1: Update Ruby Certificates (Recommended)

```bash
# Update homebrew Ruby's certificates
/opt/homebrew/opt/ruby/bin/gem update --system
/opt/homebrew/opt/ruby/bin/gem install --user-install rubygems-update
/opt/homebrew/opt/ruby/bin/update_rubygems
```

Then try pod install again:
```bash
cd /Users/radu.cucu/Documents/Python/GW/GWfrontend/ios
pod install
```

### Solution 2: Install Certificates from Homebrew OpenSSL

```bash
# Link OpenSSL certificates
export SSL_CERT_FILE=/opt/homebrew/etc/ca-certificates/cert.pem

# Or try this path
export SSL_CERT_FILE=/opt/homebrew/etc/openssl@3/cert.pem

# Then run pod install
cd /Users/radu.cucu/Documents/Python/GW/GWfrontend/ios
pod install
```

### Solution 3: Use System Ruby Instead

If Homebrew Ruby has certificate issues, try system Ruby:

```bash
# Uninstall Homebrew cocoapods
brew uninstall cocoapods ruby

# Install with system Ruby gem
sudo gem install -n /usr/local/bin cocoapods

# Then try pod install
cd /Users/radu.cucu/Documents/Python/GW/GWfrontend/ios
pod install
```

### Solution 4: Disable SSL Verification (NOT RECOMMENDED - Security Risk)

Last resort only for testing:

```bash
# Create ~/.gemrc with SSL verification disabled
echo ":ssl_verify_mode: 0" > ~/.gemrc

# Try pod install
cd /Users/radu.cucu/Documents/Python/GW/GWfrontend/ios
pod install

# IMPORTANT: Remove this after installation
rm ~/.gemrc
```

### Solution 5: Manual OpenSSL Certificate Installation

```bash
# Download and install certificates manually
cd /tmp
curl -O https://curl.se/ca/cacert.pem
sudo mkdir -p /opt/homebrew/etc/ca-certificates
sudo cp cacert.pem /opt/homebrew/etc/ca-certificates/cert.pem

# Set environment variable
export SSL_CERT_FILE=/opt/homebrew/etc/ca-certificates/cert.pem

# Add to ~/.zshrc to make permanent
echo 'export SSL_CERT_FILE=/opt/homebrew/etc/ca-certificates/cert.pem' >> ~/.zshrc

# Try pod install
cd /Users/radu.cucu/Documents/Python/GW/GWfrontend/ios
pod install
```

## Verification

After success, you should see:
```
Analyzing dependencies
Downloading dependencies
Installing...
Generating Pods project
```

And the following files/folders will be created:
- `Podfile.lock`
- `Pods/` directory
- `Runner.xcworkspace`

## Next Steps After Successful Pod Install

Once pod install succeeds, you can build the iOS app:

```bash
# Using VS Code's Flutter extension, or:
cd /Users/radu.cucu/Documents/Python/GW/GWfrontend

# Generate app icons
flutter pub run flutter_launcher_icons

# Build for iOS
flutter build ios --no-codesign

# Run on simulator
flutter run -d iPhone
```
