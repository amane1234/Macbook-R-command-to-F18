# Remap Right Command Key to F18 on macOS

Remapping the **Right Command** key (`⌘`) to the **F18** key on macOS using a custom script and `hidutil`. 

## Step-by-Step Instructions

1. Create a plist file:
   ```bash
   sudo nano ~/Library/LaunchAgents/com.local.keyremap.plist
   ```

2. Paste this:
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>Label</key>
       <string>com.local.keyremap</string>
       <key>ProgramArguments</key>
       <array>
           <string>/usr/bin/hidutil</string>
           <string>property</string>
           <string>--set</string>
           <string>{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000036,"HIDKeyboardModifierMappingDst":0x70000006F}]}</string>
       </array>
       <key>RunAtLoad</key>
       <true/>
   </dict>
   </plist>
   ```
3. Load the Launch Agent:
   ```bash
   sudo launchctl load ~/Library/LaunchAgents/com.local.keyremap.plist
   ```


### Disable the Remapping (If Needed)

If you ever need to **disable** the remapping, run the following commands to remove the process:

```bash
sudo launchctl remove com.local.keyremap.plist
sudo rm ~/Library/LaunchAgents/com.local.keyremap.plist
```

  
---

## Customize Your Key Remap

If you'd like to modify the remapping or remap other keys, you can use the [HIDUtil Generator](https://hidutil-generator.netlify.app) to create custom key mappings.
