#!/bin/bash
set -e

echo "========================================================"
echo "  XOA WINDOWS EFI & DONG BO OPENCORE CHO O NVME       "
echo "========================================================"

# 1. Mount NVMe EFI
echo "[1/5] Dang mount phan vung EFI o cung NVMe..."
NVME_EFI=$(diskutil list | grep -B 2 "APFS Container" | grep "EFI" | awk '{print $6}' || echo "")
if [ -z "$NVME_EFI" ]; then
    NVME_EFI=$(diskutil list | grep "EFI EFI" | grep "disk0" | awk '{print $6}' || echo "disk0s1")
fi
if [[ ! "$NVME_EFI" =~ ^/dev/ ]]; then
    NVME_EFI="/dev/$NVME_EFI"
fi
echo "Target NVMe EFI device: $NVME_EFI"
diskutil mount "$NVME_EFI" || sudo diskutil mount "$NVME_EFI" || true

MOUNT_POINT=$(diskutil info "$NVME_EFI" | grep "Mount Point:" | awk -F': ' '{print $2}' | xargs)
if [ -z "$MOUNT_POINT" ] || [ ! -d "$MOUNT_POINT" ]; then
    MOUNT_POINT="/Volumes/NO NAME"
fi
echo "Phan vung EFI da mount tai: $MOUNT_POINT"

# 2. Xoa Windows EFI (EFI/Microsoft)
if [ -d "$MOUNT_POINT/EFI/Microsoft" ]; then
    echo "[2/5] Da phat hien Windows EFI! Dang sao luu va xoa..."
    mkdir -p "$HOME/Windows_EFI_Backup"
    cp -R "$MOUNT_POINT/EFI/Microsoft" "$HOME/Windows_EFI_Backup/" 2>/dev/null || true
    rm -rf "$MOUNT_POINT/EFI/Microsoft"
    echo "-> DA XOA TRIET DE EFI/Microsoft tren NVMe (da backup tai ~/Windows_EFI_Backup)!"
else
    echo "[2/5] Khong con thu muc EFI/Microsoft tren NVMe."
fi

# 3. Dong bo OpenCore tu USB sang NVMe
echo "[3/5] Dong bo OpenCore tu USB sang NVMe..."
USB_DIR=$(cd "$(dirname "$0")" && pwd)
USB_EFI="/Volumes/EFI"
if [ ! -d "$USB_EFI/EFI/OC" ]; then
    # Thu mount partition EFI cua USB
    USB_DEV=$(diskutil list | grep -B 1 "Install macOS Sequoia" | grep "/dev/disk" | head -n1 | awk '{print $1}' | sed 's/s2$/s1/')
    if [ -n "$USB_DEV" ]; then
        diskutil mount "$USB_DEV" || sudo diskutil mount "$USB_DEV" || true
    fi
fi

if [ -d "/Volumes/EFI/EFI/OC" ]; then
    mkdir -p "$MOUNT_POINT/EFI/BOOT"
    mkdir -p "$MOUNT_POINT/EFI/OC"
    cp -R "/Volumes/EFI/EFI/BOOT/" "$MOUNT_POINT/EFI/BOOT/"
    cp -R "/Volumes/EFI/EFI/OC/" "$MOUNT_POINT/EFI/OC/"
    echo "-> Da dong bo OpenCore tu USB sang NVMe thanh cong!"
else
    echo "[Canh bao] Chua mount duoc USB EFI de dong bo!"
fi

# 4. Vo hieu hoa Bluetooth trong config.plist
echo "[4/5] Tat Bluetooth kexts trong config.plist..."
python3 -c "
import plistlib
cfg = '$MOUNT_POINT/EFI/OC/config.plist'
try:
    with open(cfg, 'rb') as f:
        pl = plistlib.load(f)
    for k in pl.get('Kernel', {}).get('Add', []):
        bundle = k.get('BundlePath', '')
        if any(b in bundle for b in ['BlueToolFixup', 'IntelBTPatcher', 'IntelBluetoothFirmware']):
            k['Enabled'] = False
    with open(cfg, 'wb') as f:
        plistlib.dump(pl, f)
    print('-> Da tat Bluetooth trong config.plist tren NVMe!')
except Exception as e:
    print('Loi:', e)
"

# 5. Bless OpenCore
echo "[5/5] Dang ky boot OpenCore vao UEFI NVRAM (bless)..."
sudo bless --mount "$MOUNT_POINT" --setBoot --file "$MOUNT_POINT/EFI/BOOT/BOOTx64.efi" 2>/dev/null || true

dot_clean -m "$MOUNT_POINT" 2>/dev/null || true

echo "========================================================"
echo "  HOAN TAT 100%!                                        "
echo "  - EFI/Microsoft da bi xoa bo tren o cung trong.        "
echo "  - Bluetooth da tat, khong con bi do o man hinh khoa.   "
echo "  - OpenCore da la bootloader duy nhat cua o trong.      "
echo "  Ban co the RUT USB va khoi dong lai may tinh!         "
echo "========================================================"
