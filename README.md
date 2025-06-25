# 오른쪽 커맨드키를 F18키로 변경

맥os 상, **오른쪽 커맨드** 키 (`⌘`) 를 **F18** 키로 설정하는 스크립트 입니다. `hidutil` 을 사용합니다

## 설치 방법

### 1. 스크립트를 다운로드 + 적용법

밑 bash에 적혀있는 줄을 복사후, Terminal 앱에 붙여넣기 합니다.

```bash
# 스크립트 다운
curl -O https://raw.githubusercontent.com/amane1234/Macbook-R-command-to-F18/refs/heads/main/Keyremapper_kr.sh

# 스크립트 실행 권한 부여
chmod +x Keyremapper_kr.sh

# 실행 (sudo 비밀번호가 필요합니다)
./Keyremapper_kr.sh

# 사용 후 삭제
rm Keyremapper_kr.sh
```

### 2. 재부팅 이후, 키 설정이 제대로 되었는지 확인 합니다

스크립트를 설치 후 재부팅을 합니다. 그 이후 오른쪽 커맨드키가 F18 키로 정상적으로 리맵핑이 되었는지 확인합니다.

Macos에 있는 기본 키보드앱을 사용해서 확인 할 수 있습니다. 

(재부팅이 필요한 동작입니다)

### 3. 리맵핑된 오른쪽 커맨드키를 한/영 전환키로 사용하는법

맥OS의 시스템 설정 > 키보드 > 키보드 단축키 > 입력 소스 > 입력 메뉴에서 다음 소스 선택을 더블 클릭 한 후,

오른쪽 커맨드키(이 시점에서는 F18키로 리맵핑되어있음)를 누르면 완료 됩니다.

### 4. 삭제 방법

키보드 리맵핑을 비활성화, 삭제 하고 싶다면 

밑 bash에 적혀있는 줄을 복사후, Terminal 앱에 붙여넣기 합니다.


```bash
sudo rm /Library/LaunchAgents/userkeymapping.plist
rm /Users/Shared/bin/userkeymapping
```
---




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

### Source:

코드를 밑의 블로그에서 가져와 약간의 변형과 개량을 했습니다

작동방식(hidutil 을 사용해서 0x7000000e7 를 0x70000006d 으로 재배치)은 완전히 똑같습니다.

- https://juil.dev/mac-right-command-to-hangul/
  
---
