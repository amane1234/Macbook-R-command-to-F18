# Remap Right Command Key to F18 on macOS

Remapping the **Right Command** key (`⌘`) to the **F18** key on macOS using a custom script and `hidutil`. 

## Step-by-Step Instructions

### 1. Enable the Remapping

To remap the Right Command key to F18, open the **Terminal** and run the following commands.

```bash
mkdir -p /Users/Shared/bin

echo '''#!/bin/sh
hidutil property --set '{\"UserKeyMapping\":[{\"HIDKeyboardModifierMappingSrc\":0x7000000e7,\"HIDKeyboardModifierMappingDst\":0x70000006d}]}''' > /Users/Shared/bin/userkeymapping

chmod 755 /Users/Shared/bin/userkeymapping

sudo cat << EOF > /Users/Shared/bin/userkeymapping.plist
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

sudo mv /Users/Shared/bin/userkeymapping.plist /Library/LaunchAgents/userkeymapping.plist

sudo chown root /Library/LaunchAgents/userkeymapping.plist

sudo launchctl load /Library/LaunchAgents/userkeymapping.plist
```

### 2. Verify the Remapping

After running the commands above, the **Right Command** key will now act as **F18**. You can test this by pressing the Right Command key and checking if your system recognizes it as the F18 key (e.g., using a key event tester or a keyboard shortcut that utilizes F18).

### 3. Disable the Remapping (If Needed)

If you ever need to **disable** the remapping, run the following commands to reverse the process:

```bash
# Unload the LaunchAgent
sudo launchctl remove userkeymapping

# Remove the plist file and the script
sudo rm /Library/LaunchAgents/userkeymapping.plist
sudo rm /Users/Shared/bin/userkeymapping
```

---

### Notes:

- The **Right Command** key has a `HIDKeyboardModifierMappingSrc` value of `0x7000000e7`, and **F18** has a `HIDKeyboardModifierMappingDst` value of `0x70000006d`. You can change these values in the script to remap different keys as needed.
- The script uses **LaunchAgents** to make the remapping persist after a reboot.
  
---

## Customize Your Key Remap

If you'd like to modify the remapping or remap other keys, you can use the [HIDUtil Generator](https://hidutil-generator.netlify.app) to create custom key mappings.
