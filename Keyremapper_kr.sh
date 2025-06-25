#!/bin/bash

# Ensure script runs with root privileges
if [[ $EUID -ne 0 ]]; then
    exec sudo -p "이 스크립트는 루트 권한을 필요로 합니다, sudo 비밀번호를 입력해주세요: " "$0" "$@"
    exit $?
fi

# Define paths for maintainability
BIN_DIR="/Users/Shared/bin"
SCRIPT_PATH="$BIN_DIR/userkeymapping"
PLIST_SOURCE="$BIN_DIR/userkeymapping.plist"
PLIST_TARGET="/Library/LaunchAgents/userkeymapping.plist"

# Create bin directory with proper permissions
echo "Creating directory: $BIN_DIR"
mkdir -p "$BIN_DIR" || { echo "에러 : /Users/Shared/bin 디렉토리를 만드는데 실패" >&2; exit 1; }
chmod 755 "$BIN_DIR" || { echo "에러: /Users/Shared/bin 디렉토리의 권한 설정 실패" >&2; exit 1; }

# Create executable script
echo "Creating keyboard mapping script"
cat > "$SCRIPT_PATH" <<'EOF'
#!/bin/sh
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x7000000e7,"HIDKeyboardModifierMappingDst":0x70000006d}]}'
EOF

chmod 755 "$SCRIPT_PATH" || { echo "에러 : 스크립트를 755 권한으로 설정 실패" >&2; exit 1; }

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
mv -f "$PLIST_SOURCE" "$PLIST_TARGET" || { echo "에러 : launch agent 설치 실패" >&2; exit 1; }
chown root "$PLIST_TARGET" || { echo "에러 : launch agent 권한 오류" >&2; exit 1; }

# Load for all users
echo "Loading service:"
launchctl bootstrap system "$PLIST_TARGET" 2>&1 | sed 's/^/  /'

# Verify installation
echo -e "\nVerifying installation:"
if launchctl print system/userkeymapping &>/dev/null; then
    echo "설치 성공"
    echo "재부팅 후, 오른쪽 Command 키(⌘) 가 F18으로 설정됩니다"
    echo "삭제를 하지 않는 이상, 키 재설정은 유지 됩니다"
else
    echo "서비스 설치에 실패하였습니다" >&2
    exit 1
fi
