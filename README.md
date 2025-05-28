# Remap Right Command Key to F18 on macOS

Remapping the **Right Command** key (`⌘`) to the **F18** key on macOS using a custom script and `hidutil`. 

## Step-by-Step Instructions

### 1. Enable the Remapping

```bash
# Download the script
curl -O https://raw.githubusercontent.com/amane1234/Macbook-R-command-to-F18/refs/heads/main/Keyremapper.sh

# Make it executable
chmod +x Keyremapper.sh

# Run it (will auto-sudo)
./Keyremapper.sh

# Remove it
rm Keyremapper.sh
```

### 2. Verify the Remapping after reboot.

After running the commands above and reboot, the **Right Command** key will now act as **F18**. You can test this by pressing the Right Command key and checking if your system recognizes it as the F18 key (e.g., using a key event tester or a keyboard shortcut that utilizes F18).

### 3. Disable the Remapping (If Needed)

If you ever need to **disable** the remapping, run the following commands to remove the process:

```bash
sudo rm /Library/LaunchAgents/userkeymapping.plist
rm /Users/Shared/bin/userkeymapping
```
---

### Notes:

- The **Right Command** key has a `HIDKeyboardModifierMappingSrc` value of `0x7000000e7`, and **F18** has a `HIDKeyboardModifierMappingDst` value of `0x70000006d`. You can change these values in the script to remap different keys as needed.
- The script uses **LaunchAgents** to make the remapping persist after a reboot.
  
---

## Customize Your Key Remap

If you'd like to modify the remapping or remap other keys, you can use the [HIDUtil Generator](https://hidutil-generator.netlify.app) to create custom key mappings.


Source : https://juil.dev/mac-right-command-to-hangul/
