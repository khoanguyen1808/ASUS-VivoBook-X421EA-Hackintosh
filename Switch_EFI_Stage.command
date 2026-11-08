#!/bin/bash
set -e

# Detect EFI mountpoint
if [ -d "/Volumes/EFI/EFI/OC" ]; then
    REAL_OC="/Volumes/EFI/EFI/OC"
elif [ -d "$HOME/Desktop/hackintosh/EFI/OC" ]; then
    REAL_OC="$HOME/Desktop/hackintosh/EFI/OC"
else
    # Try mounting EFI partition
    EFI_DEV=$(diskutil list | grep "EFI EFI" | head -n1 | awk '{print $NF}' || echo "")
    if [ -n "$EFI_DEV" ]; then
        diskutil mount "$EFI_DEV" || sudo diskutil mount "$EFI_DEV" || true
    fi
    REAL_OC="/Volumes/EFI/EFI/OC"
fi

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
OCVALIDATE_BIN="$SCRIPT_DIR/Tools/ocvalidate"
if [ ! -f "$OCVALIDATE_BIN" ]; then
    OCVALIDATE_BIN=$(find /Volumes -name "ocvalidate" 2>/dev/null | head -n1 || echo "")
fi

echo "=================================================================="
echo "  [EN] SWITCH OPENCORE CONFIG.PLIST STAGE ON /Volumes/EFI"
echo "  [VI] CHUYEN GIAI DOAN CONFIG.PLIST TRUC TIEP TREN /Volumes/EFI"
echo "=================================================================="
echo "  1) Stage 1: Core NVMe + USB Mouse + Keyboard (Initial Install)"
echo "              [Vao macOS + SSD NVMe Micron 2210 + Chuot USB + Phim PS/2]"
echo "  2) Stage 2: Intel AX201 Wi-Fi (itlwm.kext)"
echo "              [Cai dat Wi-Fi Intel AX201]"
echo "  3) Stage 3: Intel Iris Xe Graphics (1536MB VRAM - WhateverXe)"
echo "              [Cai dat GPU Intel Iris Xe]"
echo "  4) Stage 4: Full Trackpad ASUE140C + Audio ALC256 + Battery"
echo "              [Cai dat Trackpad + Audio ALC256 + Pin]"
echo "=================================================================="
read -p "Select stage / Chon giai doan (1, 2, 3, 4): " st

case "$st" in
  1) SRC="$REAL_OC/config-Stage1-Core-NVMe-Mouse-Keyboard.plist" ;;
  2) SRC="$REAL_OC/config-Stage2-WiFi.plist" ;;
  3) SRC="$REAL_OC/config-Stage3-GPU-IrisXe.plist" ;;
  4) SRC="$REAL_OC/config-Stage4-Full-Trackpad-Audio-Battery.plist" ;;
  *) echo "Invalid selection! / Lua chon khong hop le!"; exit 1 ;;
esac

if [ ! -f "$SRC" ]; then
    echo "Error: Config stage file not found at: $SRC"
    exit 1
fi

cp "$SRC" "$REAL_OC/config.plist"
dot_clean -m "/Volumes/EFI" 2>/dev/null || true

if [ -x "$OCVALIDATE_BIN" ]; then
    "$OCVALIDATE_BIN" "$REAL_OC/config.plist"
fi

echo "-> [SUCCESS] Activated Stage $st at: $REAL_OC/config.plist"
echo "-> [THANH CONG] Da kich hoat Giai doan $st tai $REAL_OC/config.plist!"
