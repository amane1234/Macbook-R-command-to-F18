#!/bin/zsh

# Suppress zsh warning during sudo execution
export BASH_SILENCE_DEPRECATION_WARNING=1

# Ensure script runs with root privileges
if [[ $EUID -ne 0 ]]; then
    exec sudo -p "This script requires admin privileges. Please enter your password: " "$0" "$@"
    exit $?
fi

# Define paths for maintainability
BIN_DIR="/Users/Shared/bin"
SCRIPT_PATH="$BIN_DIR/userkeymapping"
PLIST_SOURCE="$BIN_DIR/userkeymapping.plist"
PLIST_TARGET="/Library/LaunchAgents/userkeymapping.plist"

# Create bin directory with proper permissions
echo "Creating directory: $BIN_DIR"
mkdir -p "$BIN_DIR" || { echo "❌ Failed to create directory" >&2; exit 1; }
chmod 755 "$BIN_DIR" || { echo "❌ Failed to set directory permissions" >&2; exit 1; }

# Create executable script
echo "Creating keyboard mapping script"
cat > "$SCRIPT_PATH" <<'EOF'
#!/bin/sh
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x7000000e7,"HIDKeyboardModifierMappingDst":0x70000006d}]}'
EOF

chmod 755 "$SCRIPT_PATH" || { echo "❌ Failed to make script executable" >&2; exit 1; }

# Generate launch agent plist
echo "Creating launch agent"
cat > "$PLIST_SOURCE" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>userkeymapping</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/Shared/bin/userkeymapping</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

# Install and load launch agent
echo "Installing system service"
mv -f "$PLIST_SOURCE" "$PLIST_TARGET" || { echo "❌ Failed to install launch agent" >&2; exit 1; }
chown root "$PLIST_TARGET" || { echo "❌ Failed to set launch agent ownership" >&2; exit 1; }

# Load for all users
echo "Loading service:"
launchctl bootstrap system "$PLIST_TARGET" 2>&1 | sed 's/^/  /'

# Verify installation
echo -e "\nVerifying installation:"
if launchctl print system/userkeymapping &>/dev/null; then
    echo "✅ Service loaded successfully"
    echo "The right Command key (⌘) has been remapped to F18"
    echo "This change will persist across reboots"
else
    echo "❌ Service failed to load" >&2
    exit 1
fi
