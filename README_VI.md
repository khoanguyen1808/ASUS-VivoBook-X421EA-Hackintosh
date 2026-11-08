# ASUS VivoBook X421EA / S433EA - OpenCore Hackintosh (macOS Sequoia 15.x)

[![macOS](https://img.shields.io/badge/macOS-Sequoia%2015.x-blue?logo=apple&logoColor=white)](https://www.apple.com/macos/sequoia/)
[![OpenCore](https://img.shields.io/badge/OpenCore-1.0.x-success?logo=apple)](https://github.com/acidanthera/OpenCorePkg)
[![Language](https://img.shields.io/badge/Language-English%20%7C%20Ti%E1%BA%BFng%20Vi%E1%BB%87t-informational)](README.md)

Bộ cài đặt EFI OpenCore và bộ công cụ hậu kỳ (Post-Install) hoàn chỉnh dành riêng cho **ASUS VivoBook (X421EA / S433EA)** chạy hệ điều hành **macOS Sequoia 15.x**.

> 🌐 **Chuyển đổi ngôn ngữ**: [Xem bản Tiếng Anh (English Version)](README.md)

---

## 💻 Cấu hình phần cứng (Hardware Specifications)

| Thành phần | Chi tiết phần cứng | Tình trạng | Kext / Bản vá (Patch) áp dụng |
| :--- | :--- | :---: | :--- |
| **Model** | ASUS VivoBook X421EA / S433EA | ✅ | SMBIOS MacBookPro16,2 |
| **CPU** | Intel Core Gen 11 (Tiger Lake) | ✅ | `CpuTscSync.kext` |
| **iGPU** | Intel Iris Xe Graphics (1536 MB VRAM) | ✅ | `WhateverXe.kext` + WhateverXe Graphics PKG |
| **RAM** | DDR4 Dual-Channel | ✅ | Nhận diện gốc (Native) |
| **Ổ cứng** | Micron 2210 NVMe 512GB (`MTFDHBA512QFD`) | ✅ | `NVMeFix.kext` |
| **Audio** | Realtek ALC256 | ✅ | `AppleALC.kext` + `AsusSMC.kext` (Layout-ID 21/11) |
| **Wi-Fi** | Intel Wi-Fi 6 AX201 160MHz | ✅ | `itlwm.kext` + ứng dụng **HeliPort** |
| **Bluetooth** | Intel AX201 Bluetooth | ⚠️ | `IntelBluetoothFirmware` (tạm tắt lúc cài đặt ban đầu) |
| **Trackpad** | ASUS I2C Precision Trackpad (`ASUE140C`) | ✅ | `VoodooI2C.kext` + `VoodooI2CHID.kext` |
| **Bàn phím** | PS/2 Keyboard + Phím chức năng Fn | ✅ | `VoodooPS2Controller.kext` + `BrightnessKeys.kext` |
| **Pin & Cảm biến**| Quản lý pin, cảm biến ánh sáng ALS | ✅ | `SMCBatteryManager`, `SMCLightSensor`, `AsusSMC` |
| **Cổng USB** | Intel USB 3.1 xHCI Controller | ✅ | `USBToolBox.kext` + `UTBMap.kext` |

---

## 📁 Cấu trúc thư mục

```
hackintosh/
├── EFI/
│   ├── BOOT/
│   │   └── BOOTx64.efi
│   └── OC/
│       ├── ACPI/                         # Các bản vá SSDT cho Tiger Lake
│       ├── Drivers/                      # OpenRuntime, HfsPlus, OpenCanopy...
│       ├── Kexts/                        # Bộ Kext hoàn chỉnh tương thích Sequoia
│       ├── Tools/
│       ├── config.plist                  # Cấu hình OpenCore đang chạy
│       ├── config-Stage1-Core-NVMe-Mouse-Keyboard.plist
│       ├── config-Stage2-WiFi.plist
│       ├── config-Stage3-GPU-IrisXe.plist
│       └── config-Stage4-Full-Trackpad-Audio-Battery.plist
├── Post-Install/
│   ├── HeliPort.dmg                      # Ứng dụng điều khiển Wi-Fi cho itlwm
│   └── WhateverXe-Graphics/
│       └── WhateverXe-Graphics-0.3.2.pkg # Gói cài đặt tăng tốc đồ họa Iris Xe
├── Tools/
│   ├── GenSMBIOS-master/                 # Sinh Serial, MLB, UUID mới
│   ├── MountEFI-master/                  # Mount nhanh phân vùng EFI
│   ├── ProperTree-master/                # Trình chỉnh sửa plist chuẩn OpenCore
│   ├── SSDTTime-master/                  # Dump DSDT & tạo SSDT chuẩn theo máy
│   ├── macrecovery/                      # Tải bộ cài macOS gốc từ Apple
│   ├── ocvalidate                        # Kiểm tra tính hợp lệ của config.plist
│   └── USBToolBox_Windows.exe            # Map cổng USB trực tiếp trên Windows
├── Switch_EFI_Stage.command              # Script chuyển giai đoạn cấu hình trực tiếp
├── Sync_NVMe_EFI_Clean_Windows.command   # Script đồng bộ sang ổ NVMe và dọn dẹp Windows EFI
└── Hardware_Specs.txt                    # Toàn bộ thông số phần cứng dump chi tiết
```

---

## 🚀 Quy trình boot 4 giai đoạn (4-Stage Boot Strategy)

Do macOS Sequoia trên chip Intel 11th Gen (Tiger Lake) cần các bản vá đặc thù, quy trình được tối ưu hóa thành 4 giai đoạn an toàn:

### 🔹 Giai đoạn 1: Khởi động cơ bản & Cài đặt macOS
* **File cấu hình**: `config-Stage1-Core-NVMe-Mouse-Keyboard.plist`
* **Tính năng**: Nhận diện SSD NVMe Micron 2210, bàn phím PS/2, chuột USB ngoài. Tắt toàn bộ kext đồ họa, Wi-Fi và I2C để bộ cài chạy ổn định 100% không bị kernel panic.

### 🔹 Giai đoạn 2: Kích hoạt Wi-Fi Intel AX201
* **File cấu hình**: `config-Stage2-WiFi.plist`
* **Tính năng**: Kích hoạt `itlwm.kext`. Cài đặt ứng dụng **HeliPort** (từ `Post-Install/HeliPort.dmg`) để kết nối mạng Wi-Fi.

### 🔹 Giai đoạn 3: Kích hoạt GPU Intel Iris Xe
* **File cấu hình**: `config-Stage3-GPU-IrisXe.plist`
* **Tính năng**: Kích hoạt `WhateverXe.kext`. Cài đặt `WhateverXe-Graphics-0.3.2.pkg` (từ `Post-Install/WhateverXe-Graphics/`) để kích hoạt tăng tốc đồ họa phần cứng Full QE/CI (1536 MB VRAM).

### 🔹 Giai đoạn 4: Hoàn thiện toàn bộ hệ thống
* **File cấu hình**: `config-Stage4-Full-Trackpad-Audio-Battery.plist`
* **Tính năng**: Kích hoạt Trackpad cảm ứng đa điểm (`VoodooI2C` + `VoodooI2CHID`), Âm thanh ALC256 (`AppleALC`), Quản lý pin & phím Fn (`AsusSMC`, `SMCBatteryManager`).

---

## 🧩 Chi tiết các bản vá ACPI & Kernel (Mấy cái Patch)

### 1. ACPI DSDT Hotpatches
Được cấu hình trong `EFI/OC/config.plist` tại mục `ACPI -> Patch`:
* **`Fix ASUS S433EA DSDT AE_NOT_FOUND on _SB.PC00.XHCI.RHUB.HS10 -> SS05`**: Sửa lỗi dừng ACPI khi hệ thống quét cổng USB HS10/SS05.
* **`Fix ASUS S433EA DSDT AE_NOT_FOUND on _SB.PC00.XHCI.RHUB.HS14 -> SS06`**: Khắc phục lỗi thiếu namespace ACPI trên bo mạch chủ ASUS Tiger Lake cho cổng HS14/SS06.

### 2. Các bảng SSDT tùy chỉnh
Nằm trong thư mục `EFI/OC/ACPI/`:
* **`SSDT-ALS0.aml`**: Tạo thiết bị Cảm biến ánh sáng giả lập (Ambient Light Sensor) để quản lý độ sáng và Sleep.
* **`SSDT-AWAC.aml`**: Vô hiệu hóa AWAC và ép sử dụng đồng hồ RTC truyền thống trên Intel Gen 10/11.
* **`SSDT-EC-USBX.aml`**: Giả lập bộ điều khiển nhúng (`EC`) và định nghĩa nguồn cấp USB cho macOS Sequoia.
* **`SSDT-GPIO.aml`**: Kích hoạt ngắt chân GPIO của Intel Tiger Lake để Trackpad I2C hoạt động mượt mà.
* **`SSDT-PLUG.aml`**: Kích hoạt tính năng quản lý năng lượng CPU gốc (`X86PlatformPlugin`).
* **`SSDT-PMC.aml`**: Khôi phục khả năng ghi NVRAM gốc cho chipset Intel 400/500-series.
* **`SSDT-PNLF.aml`**: Vá thanh điều khiển độ sáng màn hình cho iGPU Intel Iris Xe.
* **`SSDT-RHUB.aml`**: Reset trạng thái bộ điều khiển USB RHUB để nhận diện cổng chính xác.
* **`SSDT-USBX.aml`**: Bổ sung thông số dòng điện USB (`kUSBSleepPowerSupply`, `kUSBWakePowerSupply`).

### 3. Kexts và Kernel Arguments quan trọng
* **`WhateverXe.kext`**: Trình điều khiển đồ họa Intel Iris Xe dành cho macOS.
* **`AMFIPass.kext`**: Cho phép vượt qua kiểm tra AMFI trên macOS Sequoia mà không cần tắt hoàn toàn SIP.
* **`RestrictEvents.kext`**: Tinh chỉnh chuỗi hiển thị phần cứng và bộ nhớ trong phần Giới thiệu máy tính.
* **`NVMeFix.kext`**: Tối ưu hóa chuyển trạng thái năng lượng (APST) cho ổ cứng SSD Micron 2210.
* **`ECEnabler.kext`**: Đọc trạng thái pin trên các trường ACPI có độ dài phi chuẩn (> 8 bits).

---

## 🛠 Hướng dẫn sử dụng tập lệnh tự động

### 1. Chuyển đổi giai đoạn cấu hình (`Switch_EFI_Stage.command`)
Sau khi mount phân vùng EFI (`/Volumes/EFI`), mở Terminal và chạy:
```bash
./Switch_EFI_Stage.command
```
Nhập `1`, `2`, `3` hoặc `4`. Script sẽ thay thế `config.plist` và kiểm tra tính hợp lệ bằng `ocvalidate`.

### 2. Đồng bộ OpenCore vào ổ SSD trong máy (`Sync_NVMe_EFI_Clean_Windows.command`)
Sau khi cài đặt xong macOS và vào được Desktop:
```bash
./Sync_NVMe_EFI_Clean_Windows.command
```
Các bước script tự động thực hiện:
1. Mount phân vùng EFI của ổ NVMe nội bộ.
2. Sao lưu và xóa thư mục `EFI/Microsoft` cũ sang `~/Windows_EFI_Backup` để tránh xung đột bootloader.
3. Đồng bộ toàn bộ `EFI/BOOT` và `EFI/OC` sang ổ NVMe.
4. Tắt các kext Bluetooth gây treo màn hình khóa.
5. Đăng ký OpenCore vào UEFI NVRAM (`bless`).

---

## ⚠️ Lưu ý quan trọng về SMBIOS

Cấu hình mẫu đang để Serial mặc định của `MacBookPro16,2`. **Trước khi đăng nhập Apple ID / iCloud / iMessage**, bạn cần tạo bộ Serial riêng:
1. Chạy `Tools/GenSMBIOS-master/GenSMBIOS.command`.
2. Chọn loại Model: **`MacBookPro16,2`**.
3. Dùng **ProperTree** mở `EFI/OC/config.plist`, tìm đến mục `PlatformInfo` -> `Generic`.
4. Cập nhật các giá trị mới sinh:
   * `SystemProductName`
   * `SystemSerialNumber`
   * `MLB`
   * `SystemUUID`

---

## 👥 Danh sách người đóng góp & Bản quyền (Credits & Contributors)

Xin gửi lời cảm ơn chân thành đến các nhà phát triển và cộng đồng mã nguồn mở đã tạo nên các bản vá và công cụ cho Hackintosh:

| Tác giả / Dự án | Thành phần đóng góp | Đường dẫn |
| :--- | :--- | :--- |
| **[Acidanthera](https://github.com/acidanthera)** | OpenCorePkg, Lilu, AppleALC, VirtualSMC, CpuTscSync, NVMeFix, RestrictEvents, BrightnessKeys | [GitHub](https://github.com/acidanthera) |
| **[OpenIntelWireless](https://github.com/OpenIntelWireless)** | `itlwm.kext` (Driver Wi-Fi Intel) và ứng dụng `HeliPort` | [GitHub](https://github.com/OpenIntelWireless) |
| **[VoodooI2C Team](https://github.com/VoodooI2C)** (Alexandred, hieplpvip, cholonam, benvs) | `VoodooI2C.kext` & `VoodooI2CHID.kext` (Driver bàn rê cảm ứng I2C) | [GitHub](https://github.com/VoodooI2C) |
| **[ChefKissInc](https://github.com/ChefKissInc)** | `WhateverXe.kext` & bộ cài WhateverXe Graphics (Driver Iris Xe) | [GitHub](https://github.com/ChefKissInc) |
| **[1Revenger1](https://github.com/1Revenger1)** | `ECEnabler.kext` (Bản vá đọc Pin từ Embedded Controller) | [GitHub](https://github.com/1Revenger1/ECEnabler) |
| **[dhinakg](https://github.com/dhinakg)** | `USBToolBox` driver và công cụ map cổng USB | [GitHub](https://github.com/dhinakg/USBToolBox) |
| **[blusseau](https://github.com/blusseau)** | `AsusSMC.kext` (Quản lý pin laptop ASUS, cảm biến, phím Fn) | [GitHub](https://github.com/blusseau/AsusSMC) |
| **[CorpNewt](https://github.com/corpnewt)** | Bộ công cụ `GenSMBIOS`, `MountEFI`, `ProperTree`, `SSDTTime` | [GitHub](https://github.com/corpnewt) |
| **[Dortania](https://dortania.github.io)** | Tài liệu hướng dẫn OpenCore và các bản vá DSDT | [Dortania Guides](https://dortania.github.io) |
| **Apple Inc.** | Hệ điều hành macOS | [Apple](https://www.apple.com) |
