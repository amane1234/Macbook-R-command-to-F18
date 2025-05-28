#!/bin/bash

# Ensure script runs with root privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Try: sudo $0" >&2
    exit 1
fi

# Define paths for maintainability
BIN_DIR="/Users/Shared/bin"
SCRIPT_PATH="$BIN_DIR/userkeymapping"
PLIST_SOURCE="$BIN_DIR/userkeymapping.plist"
PLIST_TARGET="/Library/LaunchAgents/userkeymapping.plist"

# Create bin directory with proper permissions
mkdir -p "$BIN_DIR" || { echo "Failed to create $BIN_DIR" >&2; exit 1; }
chmod 755 "$BIN_DIR" || { echo "Failed to set permissions for $BIN_DIR" >&2; exit 1; }

# Create executable script using heredoc
cat > "$SCRIPT_PATH" <<'EOF'
#!/bin/sh
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x7000000e7,"HIDKeyboardModifierMappingDst":0x70000006d}]}'
EOF

chmod 755 "$SCRIPT_PATH" || { echo "Failed to make script executable" >&2; exit 1; }

# Generate launch agent plist
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
mv -f "$PLIST_SOURCE" "$PLIST_TARGET" || { echo "Failed to move plist" >&2; exit 1; }
chown root "$PLIST_TARGET" || { echo "Failed to set plist ownership" >&2; exit 1; }

# Load for all users with richer error reporting
echo "Loading launch agent with bootstrap:"
launchctl bootstrap system "$PLIST_TARGET" 2>&1 | sed 's/^/  /'

# Verify installation
echo -e "\nInstallation complete. Current status:"
launchctl print system/userkeymapping 2>&1 | grep -E 'state|pid'
