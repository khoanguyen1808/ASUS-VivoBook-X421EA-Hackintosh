<p align="center">
  <h1 align="center">💻 ASUS VivoBook X421EA / S433EA - OpenCore Hackintosh</h1>
  <p align="center"><b>Bộ cài đặt OpenCore EFI & Công cụ hậu kỳ hoàn chỉnh cho macOS Sequoia 15.x trên Intel Gen 11 Tiger Lake</b></p>
</p>

<p align="center">
  <a href="README.md"><img src="https://img.shields.io/badge/Language-English-blue?style=for-the-badge&logo=googletranslate&logoColor=white" alt="English" /></a>
  <a href="README_VI.md"><img src="https://img.shields.io/badge/Ngôn%20ngữ-Tiếng%20Việt-red?style=for-the-badge&logo=googletranslate&logoColor=white" alt="Tiếng Việt" /></a>
</p>

<p align="center">
  <a href="https://www.apple.com/os/macos/"><img src="https://img.shields.io/badge/macOS-Sequoia%2015.x-black?style=flat-square&logo=apple&logoColor=white" alt="macOS Sequoia" /></a>
  <a href="https://github.com/acidanthera/OpenCorePkg"><img src="https://img.shields.io/badge/OpenCore-1.0.x-0969da?style=flat-square&logo=apple" alt="OpenCore" /></a>
  <a href="https://github.com/ChefKissInc/WhateverGreen"><img src="https://img.shields.io/badge/GPU-Iris%20Xe%201536MB%20(QE%2FCI)-success?style=flat-square&logo=intel" alt="Iris Xe" /></a>
  <a href="https://github.com/khoanguyen1808/ASUS-VivoBook-X421EA-Hackintosh/stargazers"><img src="https://img.shields.io/github/stars/khoanguyen1808/ASUS-VivoBook-X421EA-Hackintosh?style=flat-square&color=yellow" alt="Stars" /></a>
  <a href="https://github.com/khoanguyen1808/ASUS-VivoBook-X421EA-Hackintosh/network/members"><img src="https://img.shields.io/github/forks/khoanguyen1808/ASUS-VivoBook-X421EA-Hackintosh?style=flat-square&color=orange" alt="Forks" /></a>
  <a href="https://github.com/khoanguyen1808/ASUS-VivoBook-X421EA-Hackintosh/issues"><img src="https://img.shields.io/github/issues/khoanguyen1808/ASUS-VivoBook-X421EA-Hackintosh?style=flat-square" alt="Issues" /></a>
</p>

---

## 🌟 Điểm nổi bật & Lý do chọn bộ EFI này?

* ⚡ **Tăng tốc đồ họa Intel Iris Xe (Full QE/CI)**: Kích hoạt mượt mà 1536 MB VRAM trên chip Intel 11th Gen Tiger Lake nhờ bản vá `WhateverXe` chuyên dụng.
* 🛡️ **Chiến lược Boot 4 giai đoạn tiến trình**: Ngăn chặn triệt để lỗi Kernel Panic trong quá trình cài đặt mới macOS Sequoia.
* 🤖 **Tích hợp các tập lệnh tự động hóa cao**:
  * `Switch_EFI_Stage.command`: Chuyển đổi giai đoạn cấu hình chỉ với 1 cú click trực tiếp trên phân vùng EFI.
  * `Sync_NVMe_EFI_Clean_Windows.command`: Tự động xóa xung đột bootloader Windows (`EFI/Microsoft`), đồng bộ OpenCore sang SSD NVMe nội bộ, tắt Bluetooth gây đơ màn hình khóa, và nạp OpenCore vào UEFI NVRAM (`bless`).
* 🚀 **Tối ưu sẵn cho macOS Sequoia 15.x**: Tương thích hoàn toàn với `AMFIPass.kext` và `RestrictEvents.kext`.

---

## 💻 Cấu hình phần cứng & Tình trạng hoạt động

| Thành phần | Chi tiết phần cứng | Tình trạng | Kext / Bản vá (Patch) áp dụng |
| :--- | :--- | :---: | :--- |
| **Model** | ASUS VivoBook X421EA / S433EA | ✅ Hoạt động tốt | SMBIOS MacBookPro16,2 |
| **CPU** | Intel Core Gen 11 (Tiger Lake) | ✅ Hoạt động tốt | `CpuTscSync.kext` |
| **iGPU** | Intel Iris Xe Graphics (1536 MB VRAM) | ✅ Hoạt động tốt | `WhateverXe.kext` + WhateverXe Graphics PKG |
| **RAM** | DDR4 Dual-Channel | ✅ Hoạt động tốt | Nhận diện gốc (Native) |
| **Ổ cứng** | Micron 2210 NVMe 512GB (`MTFDHBA512QFD`) | ✅ Hoạt động tốt | `NVMeFix.kext` |
| **Audio** | Realtek ALC256 (Loa ngoài, Tai nghe, Mic) | ✅ Hoạt động tốt | `AppleALC.kext` + `AsusSMC.kext` (Layout-ID 21/11) |
| **Wi-Fi** | Intel Wi-Fi 6 AX201 160MHz | ✅ Hoạt động tốt | `itlwm.kext` + ứng dụng **HeliPort** |
| **Bluetooth** | Intel AX201 Bluetooth | ⚠️ Tạm thời tắt | `IntelBluetoothFirmware` (tắt trong lúc cài đặt để tránh đơ máy) |
| **Trackpad** | ASUS I2C Precision Trackpad (`ASUE140C`) | ✅ Hoạt động tốt | `VoodooI2C.kext` + `VoodooI2CHID.kext` + `SSDT-GPIO` |
| **Bàn phím** | PS/2 Keyboard + Phím chức năng Fn | ✅ Hoạt động tốt | `VoodooPS2Controller.kext` + `BrightnessKeys.kext` |
| **Pin & Cảm biến**| Quản lý pin, sạc, cảm biến ánh sáng ALS | ✅ Hoạt động tốt | `SMCBatteryManager`, `SMCLightSensor`, `AsusSMC` |
| **Cổng USB** | Intel USB 3.1 xHCI Controller | ✅ Hoạt động tốt | `USBToolBox.kext` + `UTBMap.kext` |
| **Độ sáng màn hình**| Thanh trượt độ sáng & Phím tắt Fn | ✅ Hoạt động tốt | `SSDT-PNLF.aml` |

---

## ⚙️ Cài đặt BIOS khuyến nghị (BIOS Settings)

Khởi động lại máy, bấm liên tục phím `F2` hoặc `Delete` để vào BIOS Setup:

### 🔴 Tắt (Disable)
* **Fast Boot**
* **Secure Boot**
* **Intel Platform Trust Technology (PTT)**
* **VMD / Intel RST Storage Controller** *(Bắt buộc chuyển sang chế độ AHCI / NVMe Native)*
* **Wake on LAN / Network Stack**

### 🟢 Bật (Enable)
* **VT-x**
* **VT-d**
* **Above 4G Decoding**
* **USB Legacy Support**
* **DVMT Pre-Allocated: 64MB hoặc cao hơn**

---

## 📁 Cấu trúc thư mục

```
ASUS-VivoBook-X421EA-Hackintosh/
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

## 🚀 Quy trình boot 4 giai đoạn an toàn (4-Stage Boot Strategy)

Do macOS Sequoia trên chip Intel 11th Gen (Tiger Lake) cần các bản vá đặc thù, quy trình được tối ưu hóa thành 4 giai đoạn tuần tự:

```mermaid
flowchart LR
    A["Giai đoạn 1<br/>Cài đặt gốc & NVMe"] --> B["Giai đoạn 2<br/>Wi-Fi AX201"]
    B --> C["Giai đoạn 3<br/>Đồ họa Iris Xe 1536MB"]
    C --> D["Giai đoạn 4<br/>Trackpad, Audio, Pin"]
```

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

## ❓ Câu hỏi thường gặp & Khắc phục sự cố (FAQ)

<details>
<summary><b>1. Treo ở logo Apple hoặc dòng chữ Verbose khi đang cài đặt?</b></summary>
Chuyển lại về <b>Giai đoạn 1</b> bằng script <code>./Switch_EFI_Stage.command</code>. Giai đoạn 1 tắt các kext đồ họa nặng để bộ cài đặt boot mượt mà 100%.
</details>

<details>
<summary><b>2. Đơ màn hình khóa macOS sau khi đồng bộ sang ổ NVMe?</b></summary>
Chạy script <code>./Sync_NVMe_EFI_Clean_Windows.command</code>. Script sẽ tự động tắt kext Bluetooth Intel (<code>IntelBTPatcher</code>, <code>BlueToolFixup</code>) - nguyên nhân chính gây đứng hình ở màn hình Login trên Sequoia.
</details>

<details>
<summary><b>3. Không thấy danh sách mạng Wi-Fi quét ra?</b></summary>
Đảm bảo đã kích hoạt <b>Giai đoạn 2</b> trở lên, sau đó mở ứng dụng <b>HeliPort</b> nằm trong thư mục <code>Post-Install/HeliPort.dmg</code>. Kext <code>itlwm</code> kết nối Wi-Fi thông qua ứng dụng này.
</details>

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

---

## ⭐ Ủng hộ dự án

Nếu bộ cài đặt EFI này giúp bạn cài đặt và chạy thành công macOS Sequoia trên chiếc ASUS VivoBook, hãy nhấn **Star ⭐** để lan tỏa dự án đến cộng đồng Hackintosh nhé!
