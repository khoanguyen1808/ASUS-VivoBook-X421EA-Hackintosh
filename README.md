# ASUS VivoBook X421EA / S433EA - OpenCore Hackintosh (macOS Sequoia 15.x)

[![macOS](https://img.shields.io/badge/macOS-Sequoia%2015.x-blue?logo=apple&logoColor=white)](https://www.apple.com/macos/sequoia/)
[![OpenCore](https://img.shields.io/badge/OpenCore-1.0.x-success?logo=apple)](https://github.com/acidanthera/OpenCorePkg)
[![Language](https://img.shields.io/badge/Language-English%20%7C%20Ti%E1%BA%BFng%20Vi%E1%BB%87t-informational)](#-ti%E1%BA%BFng-vi%E1%BB%87t-b%E1%BA%A3n-ti%E1%BA%BFng-vi%E1%BB%87t)

Complete OpenCore EFI configuration and Post-Install toolkit designed for **ASUS VivoBook (X421EA / S433EA)** running **macOS Sequoia 15.x**.

> 🌐 **Language Switch**: [Click here for Vietnamese Version (Bản Tiếng Việt)](README_VI.md)

---

## 💻 Hardware Specifications

| Component | Hardware Details | Status | Kext / Patch Applied |
| :--- | :--- | :---: | :--- |
| **Model** | ASUS VivoBook X421EA / S433EA | ✅ | MacBookPro16,2 SMBIOS |
| **Processor** | Intel Core 11th Gen (Tiger Lake) | ✅ | `CpuTscSync.kext` |
| **iGPU** | Intel Iris Xe Graphics (1536 MB VRAM) | ✅ | `WhateverXe.kext` + WhateverXe Graphics PKG |
| **Memory** | DDR4 Dual-Channel | ✅ | Native |
| **Storage** | Micron 2210 NVMe 512GB (`MTFDHBA512QFD`) | ✅ | `NVMeFix.kext` |
| **Audio** | Realtek ALC256 | ✅ | `AppleALC.kext` + `AsusSMC.kext` (Layout-ID 21/11) |
| **Wi-Fi** | Intel Wi-Fi 6 AX201 160MHz | ✅ | `itlwm.kext` + **HeliPort** app |
| **Bluetooth** | Intel AX201 Bluetooth | ⚠️ | `IntelBluetoothFirmware` (disabled during initial install) |
| **Trackpad** | ASUS I2C Precision Trackpad (`ASUE140C`) | ✅ | `VoodooI2C.kext` + `VoodooI2CHID.kext` |
| **Keyboard** | PS/2 Keyboard + Fn Hotkeys | ✅ | `VoodooPS2Controller.kext` + `BrightnessKeys.kext` |
| **Battery & Sensors**| Battery Status, Ambient Light Sensor | ✅ | `SMCBatteryManager`, `SMCLightSensor`, `AsusSMC` |
| **USB Ports** | Intel USB 3.1 xHCI Controller | ✅ | `USBToolBox.kext` + `UTBMap.kext` |

---

## 📁 Repository Structure

```
hackintosh/
├── EFI/
│   ├── BOOT/
│   │   └── BOOTx64.efi
│   └── OC/
│       ├── ACPI/                         # Custom SSDT patches for Tiger Lake
│       ├── Drivers/                      # OpenRuntime, HfsPlus, OpenCanopy...
│       ├── Kexts/                        # Fully verified kext collection for Sequoia
│       ├── Tools/
│       ├── config.plist                  # Active OpenCore configuration
│       ├── config-Stage1-Core-NVMe-Mouse-Keyboard.plist
│       ├── config-Stage2-WiFi.plist
│       ├── config-Stage3-GPU-IrisXe.plist
│       └── config-Stage4-Full-Trackpad-Audio-Battery.plist
├── Post-Install/
│   ├── HeliPort.dmg                      # Status bar Wi-Fi manager for itlwm
│   └── WhateverXe-Graphics/
│       └── WhateverXe-Graphics-0.3.2.pkg # Driver package for Iris Xe acceleration
├── Tools/
│   ├── GenSMBIOS-master/                 # Generate new Serial, MLB, and UUID
│   ├── MountEFI-master/                  # Mount EFI partition with one click
│   ├── ProperTree-master/                # OpenCore-compliant plist editor
│   ├── SSDTTime-master/                  # Dump DSDT & generate custom SSDTs
│   ├── macrecovery/                      # Download official macOS installers
│   ├── ocvalidate                        # Verify config.plist syntax
│   └── USBToolBox_Windows.exe            # Map USB ports on Windows
├── Switch_EFI_Stage.command              # Switch active config stage directly on EFI
├── Sync_NVMe_EFI_Clean_Windows.command   # Sync OpenCore to NVMe & resolve Windows conflicts
└── Hardware_Specs.txt                    # Full hardware PnP dump for ASUS X421EA
```

---

## 🚀 4-Stage Boot & Installation Strategy

Because macOS Sequoia on 11th Gen Tiger Lake requires staged kext loading to prevent installation kernel panics, this EFI uses a **4-stage progressive strategy**:

### 🔹 Stage 1: Core NVMe + USB Mouse + Keyboard (Initial Setup)
* **Config File**: `config-Stage1-Core-NVMe-Mouse-Keyboard.plist`
* **Features**: Micron 2210 NVMe SSD detection, PS/2 keyboard, USB external mouse. Wi-Fi, GPU acceleration, and I2C touch are turned off to ensure 100% stability during macOS installation.

### 🔹 Stage 2: Intel AX201 Wi-Fi
* **Config File**: `config-Stage2-WiFi.plist`
* **Features**: Enables `itlwm.kext`. Install the **HeliPort** app (from `Post-Install/HeliPort.dmg`) to connect to Wi-Fi networks.

### 🔹 Stage 3: Intel Iris Xe Graphics
* **Config File**: `config-Stage3-GPU-IrisXe.plist`
* **Features**: Enables `WhateverXe.kext`. Install `WhateverXe-Graphics-0.3.2.pkg` (from `Post-Install/WhateverXe-Graphics/`) to unlock Full QE/CI Hardware Acceleration (1536 MB VRAM).

### 🔹 Stage 4: Full Features
* **Config File**: `config-Stage4-Full-Trackpad-Audio-Battery.plist`
* **Features**: Multi-touch I2C Trackpad (`VoodooI2C` + `VoodooI2CHID`), Realtek ALC256 Audio (`AppleALC`), Battery status management (`AsusSMC`, `SMCBatteryManager`), and Fn brightness hotkeys.

---

## 🧩 ACPI & Kernel Patches (Mấy cái Patch)

### 1. ACPI DSDT Hotpatches
Located in `EFI/OC/config.plist` under `ACPI -> Patch`:
* **`Fix ASUS S433EA DSDT AE_NOT_FOUND on _SB.PC00.XHCI.RHUB.HS10 -> SS05`**: Prevents ACPI abort error during USB discovery on port HS10/SS05.
* **`Fix ASUS S433EA DSDT AE_NOT_FOUND on _SB.PC00.XHCI.RHUB.HS14 -> SS06`**: Fixes ACPI namespace lookup failure for HS14/SS06 on ASUS Tiger Lake motherboards.

### 2. Custom SSDT Tables
Located in `EFI/OC/ACPI/`:
* **`SSDT-ALS0.aml`**: Adds fake Ambient Light Sensor device for backlight and sleep management.
* **`SSDT-AWAC.aml`**: Disables AWAC clock and forces Legacy RTC on 10th/11th Gen Intel platforms.
* **`SSDT-EC-USBX.aml`**: Injects fake Embedded Controller (`EC`) and defines USB power properties for Sequoia.
* **`SSDT-GPIO.aml`**: Enables Intel Tiger Lake GPIO interrupt controller pin for native I2C Trackpad gestures.
* **`SSDT-PLUG.aml`**: Fixes CPU Power Management (`X86PlatformPlugin`).
* **`SSDT-PMC.aml`**: Restores native NVRAM support on Intel 400/500-series chipsets.
* **`SSDT-PNLF.aml`**: Backlight control fix for Tiger Lake Intel Iris Xe internal display.
* **`SSDT-RHUB.aml`**: Resets USB RHUB controller state for customized port mapping.
* **`SSDT-USBX.aml`**: Injects USB power parameters (`kUSBSleepPowerSupply`, `kUSBWakePowerSupply`).

### 3. Essential Kernel Extensions & Arguments
* **`WhateverXe.kext`**: Tailored Intel Iris Xe graphics driver port for macOS.
* **`AMFIPass.kext`**: Allows AMFI bypass on macOS Sequoia without disabling SIP completely.
* **`RestrictEvents.kext`**: Fixes memory display and model UI strings for modern macOS versions.
* **`NVMeFix.kext`**: Enhances power management and autonomous power state transitions on Micron NVMe SSDs.
* **`ECEnabler.kext`**: Reads battery status across non-standard ACPI Field lengths (> 8 bits).

---

## 🛠 Automation Utilities

### 1. Switch Stage Script (`Switch_EFI_Stage.command`)
Quickly switch the active config file on `/Volumes/EFI`:
```bash
./Switch_EFI_Stage.command
```
Select `1`, `2`, `3`, or `4`. The script replaces `config.plist` and verifies it using `ocvalidate`.

### 2. NVMe Migration Script (`Sync_NVMe_EFI_Clean_Windows.command`)
Once macOS is fully installed:
```bash
./Sync_NVMe_EFI_Clean_Windows.command
```
What it does:
1. Mounts internal NVMe EFI partition.
2. Backs up and removes conflicting `EFI/Microsoft` folder to `~/Windows_EFI_Backup`.
3. Copies OpenCore `EFI/BOOT` and `EFI/OC` to the NVMe drive.
4. Disables conflicting Bluetooth kexts during boot.
5. Blesses OpenCore into UEFI NVRAM.

---

## ⚠️ Important SMBIOS Note

The repository plists include sample `MacBookPro16,2` serial numbers. **Before signing into Apple ID / iCloud / iMessage**, generate your unique SMBIOS:
1. Run `Tools/GenSMBIOS-master/GenSMBIOS.command`.
2. Choose model: **`MacBookPro16,2`**.
3. Open `EFI/OC/config.plist` with **ProperTree** and update `PlatformInfo -> Generic`:
   * `SystemProductName`
   * `SystemSerialNumber`
   * `MLB`
   * `SystemUUID`

---

## 👥 Credits & Contributors (Người đóng góp)

Special thanks to all developers and open-source contributors who made Hackintosh on 11th Gen Intel possible:

| Author / Project | Contribution / Component | Link |
| :--- | :--- | :--- |
| **[Acidanthera](https://github.com/acidanthera)** | OpenCorePkg, Lilu, AppleALC, VirtualSMC, CpuTscSync, NVMeFix, RestrictEvents, BrightnessKeys | [GitHub](https://github.com/acidanthera) |
| **[OpenIntelWireless](https://github.com/OpenIntelWireless)** | `itlwm.kext` (Intel Wi-Fi driver) and `HeliPort` client | [GitHub](https://github.com/OpenIntelWireless) |
| **[VoodooI2C Team](https://github.com/VoodooI2C)** (Alexandred, hieplpvip, cholonam, benvs) | `VoodooI2C.kext` & `VoodooI2CHID.kext` (I2C Precision Trackpad) | [GitHub](https://github.com/VoodooI2C) |
| **[ChefKissInc](https://github.com/ChefKissInc)** | `WhateverXe.kext` & WhateverXe Graphics installer (Iris Xe acceleration) | [GitHub](https://github.com/ChefKissInc) |
| **[1Revenger1](https://github.com/1Revenger1)** | `ECEnabler.kext` (Embedded Controller Battery Fix) | [GitHub](https://github.com/1Revenger1/ECEnabler) |
| **[dhinakg](https://github.com/dhinakg)** | `USBToolBox` driver and mapping tools | [GitHub](https://github.com/dhinakg/USBToolBox) |
| **[blusseau](https://github.com/blusseau)** | `AsusSMC.kext` (ASUS Laptop SMC battery, sensors, Fn keys) | [GitHub](https://github.com/blusseau/AsusSMC) |
| **[CorpNewt](https://github.com/corpnewt)** | `GenSMBIOS`, `MountEFI`, `ProperTree`, `SSDTTime` utilities | [GitHub](https://github.com/corpnewt) |
| **[Dortania](https://dortania.github.io)** | OpenCore Install Guide & documentation | [Dortania Guides](https://dortania.github.io) |
| **Apple Inc.** | macOS operating system | [Apple](https://www.apple.com) |
