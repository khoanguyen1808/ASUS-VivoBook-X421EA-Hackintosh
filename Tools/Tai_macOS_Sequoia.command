#!/bin/bash
set -e
BASE="/Volumes/USB_KHOA"
mkdir -p "$BASE/macOS_Download"
cd "$BASE/macOS_Download"

echo "=================================================================="
echo "  TRÌNH TẢI MACOS SEQUOIA 15.8.2 (24H232) CHÍNH THỨC TỪ APPLE CDN"
echo "  Dành cho dự án Hackintosh ASUS VivoBook S14 S433EA (i5-1135G7)"
echo "=================================================================="
echo ""
echo "Chọn phương thức tải:"
echo "  1) Tải bộ cài đầy đủ InstallAssistant.pkg (~14.5 GB - Cài đặt Offline không cần mạng)"
echo "  2) Tải bộ cài Recovery BaseSystem.dmg (~700 MB qua công cụ OpenCore macrecovery)"
echo ""
read -p "Nhập lựa chọn của bạn (1 hoặc 2): " choice

if [ "$choice" = "1" ]; then
  URL="https://swcdn.apple.com/content/downloads/31/10/142-50013-A_0GMSQ8FVZX/kpmee5466o6dmojjdqw34x6ckj6b332of6/InstallAssistant.pkg"
  echo "Đang tải macOS Sequoia 15.8.2 (24H232) InstallAssistant.pkg vào $BASE/macOS_Download/InstallAssistant.pkg ..."
  curl -L -C - "$URL" -o "$BASE/macOS_Download/InstallAssistant-Sequoia-15.8.2.pkg"
  echo "Hoàn tất! Tệp đã lưu tại: $BASE/macOS_Download/InstallAssistant-Sequoia-15.8.2.pkg"
elif [ "$choice" = "2" ]; then
  echo "Đang tải macOS Sequoia Recovery (BaseSystem.dmg & BaseSystem.chunklist) vào $BASE/com.apple.recovery.boot ..."
  mkdir -p "$BASE/com.apple.recovery.boot"
  python3 "$BASE/Tools/macrecovery/macrecovery.py" -b Mac-5F9802EFE386AA28 -m 00000000000000000 download -o "$BASE/com.apple.recovery.boot"
  echo "Hoàn tất! Phân vùng Recovery đã sẵn sàng tại: $BASE/com.apple.recovery.boot"
else
  echo "Lựa chọn không hợp lệ."
fi
