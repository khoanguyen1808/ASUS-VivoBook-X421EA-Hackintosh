# ASUS VivoBook X421EA / S433EA - OpenCore Hackintosh (macOS Sequoia 15.x)

Bộ cài đặt EFI OpenCore và công cụ hậu kỳ (Post-Install) hoàn chỉnh dành cho **ASUS VivoBook (X421EA / S433EA)** chạy hệ điều hành **macOS Sequoia 15.x**.

---

## 💻 Cấu hình phần cứng (Hardware Specifications)

| Thành phần | Chi tiết phần cứng | Tình trạng | Kext / Patch sử dụng |
| :--- | :--- | :---: | :--- |
| **Model** | ASUS VivoBook X421EA_S433EA | ✅ | MacBookPro16,2 SMBIOS |
| **CPU** | Intel Core 11th Gen (Tiger Lake) | ✅ | `CpuTscSync.kext` |
| **iGPU** | Intel Iris Xe Graphics (1536 MB VRAM) | ✅ | `WhateverXe.kext` + WhateverXe Graphics PKG |
| **RAM** | DDR4 Dual-Channel | ✅ | Native |
| **Ổ cứng** | Micron 2210 NVMe 512GB (`MTFDHBA512QFD`) | ✅ | `NVMeFix.kext` |
| **Audio** | Realtek ALC256 | ✅ | `AppleALC.kext` + `AsusSMC.kext` (Layout-ID 21/11) |
| **Wi-Fi** | Intel Wi-Fi 6 AX201 160MHz | ✅ | `itlwm.kext` + ứng dụng **HeliPort** |
| **Bluetooth** | Intel AX201 Bluetooth | ⚠️ | `IntelBluetoothFirmware` (khuyên tắt lúc cài đặt) |
| **Trackpad** | ASUS I2C Precision Trackpad (`ASUE140C`) | ✅ | `VoodooI2C.kext` + `VoodooI2CHID.kext` |
| **Bàn phím** | PS/2 Keyboard + Phím chức năng Fn | ✅ | `VoodooPS2Controller.kext` + `BrightnessKeys.kext` |
| **Pin & Cảm biến** | ASUS Battery Management & Ambient Light | ✅ | `SMCBatteryManager` + `SMCLightSensor` + `AsusSMC` |
| **USB Ports** | Intel USB 3.1 xHCI | ✅ | `USBToolBox.kext` + `UTBMap.kext` |

---

## 📁 Cấu trúc thư mục

```
hackingtosh/
├── EFI/
│   ├── BOOT/
│   │   └── BOOTx64.efi
│   └── OC/
│       ├── ACPI/                         # SSDT tinh chỉnh phần cứng Tiger Lake
│       ├── Drivers/                      # OpenRuntime, HfsPlus, OpenCanopy...
│       ├── Kexts/                        # Toàn bộ kext đã kiểm thử tương thích Sequoia
│       ├── Tools/
│       ├── config.plist                  # Cấu hình OpenCore đang kích hoạt
│       ├── config-Stage1-Core-NVMe-Mouse-Keyboard.plist
│       ├── config-Stage2-WiFi.plist
│       ├── config-Stage3-GPU-IrisXe.plist
│       └── config-Stage4-Full-Trackpad-Audio-Battery.plist
├── Post-Install/
│   ├── HeliPort.dmg                      # Ứng dụng quản lý kết nối Wi-Fi cho itlwm
│   └── WhateverXe-Graphics/
│       └── WhateverXe-Graphics-0.3.2.pkg # Gói cài đặt kích hoạt đồ họa Iris Xe
├── Tools/
│   ├── GenSMBIOS-master/                 # Sinh Serial, MLB, UUID mới
│   ├── MountEFI-master/                  # Công cụ mount nhanh phân vùng EFI
│   ├── ProperTree-master/                # Trình chỉnh sửa plist chuẩn OpenCore
│   ├── SSDTTime-master/                  # Dump và tạo SSDT chuẩn từ DSDT máy
│   ├── macrecovery/                      # Tải bộ cài macOS nguyên bản từ Apple
│   ├── ocvalidate                        # Kiểm tra cú pháp config.plist
│   └── USBToolBox_Windows.exe            # Map cổng USB trực tiếp từ Windows
├── Chuyen_Stage_EFI.command              # Script chuyển giai đoạn config.plist trực tiếp
├── Xoa_Windows_EFI_Va_Chuyen_NVMe.command# Script đồng bộ sang ổ NVMe và xóa xung đột
└── Hardware_Specs.txt                    # Toàn bộ thông số phần cứng dump chi tiết
```

---

## 🚀 Chiến lược cài đặt 4 giai đoạn (4-Stage Boot Strategy)

Do macOS Sequoia trên chip Intel 11th Gen (Tiger Lake) cần các bản vá đặc thù, quy trình được tối ưu hóa thành 4 giai đoạn an toàn:

### 🔹 Giai đoạn 1: Khởi động cơ bản & Cài đặt macOS
* File: `config-Stage1-Core-NVMe-Mouse-Keyboard.plist`
* Kích hoạt: Nhận diện SSD NVMe Micron 2210, bàn phím PS/2, chuột USB ngoài. Tắt toàn bộ kext đồ họa, Wi-Fi và I2C để bộ cài chạy ổn định 100% không bị kernel panic.

### 🔹 Giai đoạn 2: Kích hoạt Wi-Fi Intel AX201
* File: `config-Stage2-WiFi.plist`
* Kích hoạt: `itlwm.kext` để vào mạng thông qua ứng dụng **HeliPort** (nằm trong thư mục `Post-Install`).

### 🔹 Giai đoạn 3: Kích hoạt GPU Intel Iris Xe
* File: `config-Stage3-GPU-IrisXe.plist`
* Kích hoạt: `WhateverXe.kext` và cài đặt `WhateverXe-Graphics-0.3.2.pkg` để kích hoạt tăng tốc đồ họa (Full QE/CI Acceleration 1536MB).

### 🔹 Giai đoạn 4: Hoàn thiện toàn bộ hệ thống
* File: `config-Stage4-Full-Trackpad-Audio-Battery.plist`
* Kích hoạt: Trackpad cảm ứng đa điểm (`VoodooI2C`), Âm thanh ALC256 (`AppleALC`), Quản lý pin & phím Fn (`AsusSMC`).

---

## 🛠 Hướng dẫn sử dụng các tập lệnh tiện ích

### 1. Chuyển đổi giai đoạn nhanh (`Chuyen_Stage_EFI.command`)
Sau khi mount phân vùng EFI (`/Volumes/EFI`), mở Terminal và chạy:
```bash
./Chuyen_Stage_EFI.command
```
Nhập số `1`, `2`, `3` hoặc `4` tương ứng với giai đoạn bạn muốn kích hoạt. Script sẽ tự động sao chép file cấu hình tương ứng vào `config.plist` và kiểm tra tính hợp lệ bằng `ocvalidate`.

### 2. Đồng bộ OpenCore từ USB vào SSD trong máy (`Xoa_Windows_EFI_Va_Chuyen_NVMe.command`)
Sau khi cài đặt macOS hoàn tất và khởi động được vào hệ điều hành:
1. Cắm USB cài đặt vào máy.
2. Mở Terminal và chạy:
   ```bash
   ./Xoa_Windows_EFI_Va_Chuyen_NVMe.command
   ```
3. Script sẽ tự động:
   * Mount phân vùng EFI của ổ NVMe nội bộ.
   * Sao lưu thư mục `EFI/Microsoft` cũ vào `~/Windows_EFI_Backup` rồi xóa bỏ triệt để để tránh xung đột bootloader.
   * Đồng bộ toàn bộ `EFI/BOOT` và `EFI/OC` từ USB sang NVMe.
   * Tắt các kext Bluetooth gây treo màn hình khóa.
   * Đăng ký OpenCore vào UEFI NVRAM (`bless`).

---

## ⚠️ Lưu ý quan trọng về SMBIOS

Trước khi sử dụng lâu dài và đăng nhập Apple ID (iCloud, iMessage, FaceTime):
1. Chạy công cụ `Tools/GenSMBIOS-master/GenSMBIOS.command`.
2. Chọn loại Model: **`MacBookPro16,2`**.
3. Dùng **ProperTree** mở `EFI/OC/config.plist`, tìm đến mục `PlatformInfo` -> `Generic`.
4. Điền các giá trị mới sinh:
   * `SystemProductName`
   * `SystemSerialNumber`
   * `MLB`
   * `SystemUUID`
5. Lưu lại và khởi động lại máy.

---

## 📜 Bản quyền & Tham khảo
* [Acidanthera OpenCorePkg](https://github.com/acidanthera/OpenCorePkg)
* [WhateverXe Project](https://github.com/acidanthera/WhateverGreen)
* [OpenIntelWireless (itlwm)](https://github.com/OpenIntelWireless/itlwm)
* [VoodooI2C Project](https://github.com/VoodooI2C/VoodooI2C)
