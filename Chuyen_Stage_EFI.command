#!/bin/bash
set -e
REAL_OC="/Volumes/EFI/EFI/OC"
USB_VOL="/Volumes/Install macOS Sequoia"

echo "=================================================================="
echo "  CHUYỂN GIAI ĐOẠN CONFIG.PLIST TRỰC TIẾP TRÊN /Volumes/EFI"
echo "=================================================================="
echo "  1) Giai đoạn 1: Vào macOS + SSD NVMe Micron 2210 + Chuột USB + Phím PS/2"
echo "  2) Giai đoạn 2: Cài đặt Wi-Fi Intel AX201 (itlwm.kext)"
echo "  3) Giai đoạn 3: Cài đặt GPU Intel Iris Xe 1536MB (WhateverXe 0.6.1)"
echo "  4) Giai đoạn 4: Cài đặt Trackpad ASUE140C + Audio ALC256 + Pin"
echo "=================================================================="
read -p "Nhập giai đoạn muốn kích hoạt (1, 2, 3 hoặc 4): " st

case "$st" in
  1) SRC="$REAL_OC/config-Stage1-Core-NVMe-Mouse-Keyboard.plist" ;;
  2) SRC="$REAL_OC/config-Stage2-WiFi.plist" ;;
  3) SRC="$REAL_OC/config-Stage3-GPU-IrisXe.plist" ;;
  4) SRC="$REAL_OC/config-Stage4-Full-Trackpad-Audio-Battery.plist" ;;
  *) echo "Lựa chọn không hợp lệ!"; exit 1 ;;
esac

cp "$SRC" "$REAL_OC/config.plist"
dot_clean -m "/Volumes/EFI" || true
"$USB_VOL/Tools/ocvalidate" "$REAL_OC/config.plist"
echo "-> Đã kích hoạt thành công Giai đoạn $st tại /Volumes/EFI/EFI/OC/config.plist!"
