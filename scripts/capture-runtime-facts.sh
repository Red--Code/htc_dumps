#!/usr/bin/env bash
# Read-only collector for the HTC One M9+.
# Run on a Linux PC with adb installed and the phone booted normally.
# No partitions are written and no modem/NVRAM/calibration data is read.

set -euo pipefail

command -v adb >/dev/null || {
    echo "adb is required" >&2
    exit 1
}

echo "Connect the phone with USB debugging enabled and grant root to su if prompted."
adb wait-for-device

adb shell su -c '
echo "=== build ==="
getprop ro.build.fingerprint
getprop ro.build.version.release
getprop ro.build.version.sdk
getprop ro.product.device
getprop ro.board.platform
getprop ro.hardware
echo

echo "=== running kernel ==="
uname -a
cat /proc/version
echo

echo "=== active HTC PID (hex bytes, big-endian DT cell) ==="
for f in /proc/device-tree/htc_board_info/htc_pid /sys/firmware/devicetree/base/htc_board_info/htc_pid; do
    if [ -r "$f" ]; then
        printf "%s: " "$f"
        od -An -tx1 -N4 "$f" | tr -d " \n"
        echo
    fi
done
echo

echo "=== selected display-related DT properties ==="
for root in /proc/device-tree /sys/firmware/devicetree/base; do
    [ -d "$root" ] || continue
    find "$root" -type f \( -name compatible -o -name panel -o -name panel_name -o -name lcm_name \) 2>/dev/null |
    while read -r f; do
        case "$f" in
            *display*|*panel*|*lcm*|*dsi*|*htc_board_info*)
                printf "%s: " "$f"
                tr "\000" " " < "$f" 2>/dev/null || true
                echo
                ;;
        esac
    done
    break
done
echo

echo "=== kernel config availability ==="
if [ -r /proc/config.gz ]; then
    zcat /proc/config.gz | grep -E "^(CONFIG_(ARCH_MT6795|ANDROID_BINDER_IPC|ASHMEM|SECURITY_SELINUX|TOUCHSCREEN_MAX1187X|MTK_COMBO_CHIP_MT6630|MTK_NFC)|# CONFIG_(IKCONFIG|ASHMEM|ANDROID_BINDER_IPC))" || true
else
    echo "/proc/config.gz unavailable (kernel may have IKCONFIG disabled)"
fi
echo

echo "=== partition sizes (selected safe inventory only) ==="
for p in boot recovery system userdata cache persist; do
    f="/dev/block/bootdevice/by-name/$p"
    if [ -e "$f" ]; then
        printf "%-10s " "$p"
        blockdev --getsize64 "$f" 2>/dev/null || true
    fi
done
'
