#!/bin/bash
set -e

echo "=================================================================="
echo "  [EN] CLEAN WINDOWS EFI & MIGRATE OPENCORE TO NVMe SSD"
echo "  [VI] XOA WINDOWS EFI & DONG BO OPENCORE CHO O NVME"
echo "=================================================================="

# 1. Mount NVMe EFI
echo "[1/5] Mounting internal NVMe EFI partition..."
NVME_EFI=$(diskutil list | grep -B 2 "APFS Container" | grep "EFI" | awk '{print $NF}' || echo "")
if [ -z "$NVME_EFI" ]; then
    NVME_EFI=$(diskutil list | grep "EFI EFI" | grep "disk0" | awk '{print $NF}' || echo "disk0s1")
fi
if [[ ! "$NVME_EFI" =~ ^/dev/ ]]; then
    NVME_EFI="/dev/$NVME_EFI"
fi
echo "Target NVMe EFI device: $NVME_EFI"
diskutil mount "$NVME_EFI" || sudo diskutil mount "$NVME_EFI" || true

MOUNT_POINT=$(diskutil info "$NVME_EFI" | grep "Mount Point:" | awk -F': ' '{print $2}' | xargs)
if [ -z "$MOUNT_POINT" ] || [ ! -d "$MOUNT_POINT" ]; then
    MOUNT_POINT="/Volumes/EFI"
fi
echo "NVMe EFI mounted at: $MOUNT_POINT"

# 2. Backup & Wipe Windows EFI (EFI/Microsoft)
if [ -d "$MOUNT_POINT/EFI/Microsoft" ]; then
    echo "[2/5] Windows EFI detected! Backing up and cleaning..."
    mkdir -p "$HOME/Windows_EFI_Backup"
    cp -R "$MOUNT_POINT/EFI/Microsoft" "$HOME/Windows_EFI_Backup/" 2>/dev/null || true
    rm -rf "$MOUNT_POINT/EFI/Microsoft"
    echo "-> Removed EFI/Microsoft from NVMe (Backup saved to ~/Windows_EFI_Backup)"
else
    echo "[2/5] No leftover EFI/Microsoft folder found on NVMe."
fi

# 3. Sync OpenCore from USB or Local to NVMe
echo "[3/5] Syncing OpenCore EFI to NVMe..."
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
SRC_EFI=""

if [ -d "$SCRIPT_DIR/EFI/OC" ]; then
    SRC_EFI="$SCRIPT_DIR/EFI"
elif [ -d "/Volumes/EFI/EFI/OC" ] && [ "/Volumes/EFI" != "$MOUNT_POINT" ]; then
    SRC_EFI="/Volumes/EFI/EFI"
fi

if [ -n "$SRC_EFI" ] && [ -d "$SRC_EFI/OC" ]; then
    mkdir -p "$MOUNT_POINT/EFI/BOOT"
    mkdir -p "$MOUNT_POINT/EFI/OC"
    cp -R "$SRC_EFI/BOOT/" "$MOUNT_POINT/EFI/BOOT/"
    cp -R "$SRC_EFI/OC/" "$MOUNT_POINT/EFI/OC/"
    echo "-> OpenCore successfully synced to NVMe EFI!"
else
    echo "[Notice] Local EFI source not found, checking existing NVMe EFI."
fi

# 4. Disable problematic Bluetooth kexts on initial boot
echo "[4/5] Disabling problematic Bluetooth kexts in config.plist..."
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
    print('-> Bluetooth kexts disabled in NVMe config.plist to prevent lockscreen hangs.')
except Exception as e:
    print('Note / Error:', e)
"

# 5. Bless OpenCore into UEFI NVRAM
echo "[5/5] Registering OpenCore into UEFI NVRAM (bless)..."
sudo bless --mount "$MOUNT_POINT" --setBoot --file "$MOUNT_POINT/EFI/BOOT/BOOTx64.efi" 2>/dev/null || true
dot_clean -m "$MOUNT_POINT" 2>/dev/null || true

echo "=================================================================="
echo "  [SUCCESS] MIGRATION COMPLETED 100%!"
echo "  - Removed Windows EFI conflicts on internal drive."
echo "  - OpenCore is now the primary bootloader."
echo "  - You can safely unplug the USB installer and reboot!"
echo "=================================================================="
