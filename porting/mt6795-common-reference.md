# MT6795 Android device-tree and HAL reference

## Candidate common tree

Repository: https://github.com/MTK-Dev/android_device_mediatek_mt6795-common
Branch: cm-14.1
Latest inspected commit: 801ac1399ae0eddc447c44c27a8982ab9a10929a (2017-01-01)

This is a shared MT6795 platform tree used by the MTK-Dev Allview X2 Xtreme and BLU Pure XL devices. It targets CyanogenMod 14.1 / Android 7.1, not Android 9. It is not an HTC M9+ device tree and must not be copied wholesale.

Useful reference components:
- BoardConfigCommon.mk: ARM64 plus ARM32 secondary ABI, Cortex-A53, 64-bit Binder, MTK hardware flags, HWC/OpenGL, MTK Wi-Fi private command library, appended Image.gz-dtb layout and kernel image offsets.
- mt6795.mk: MTK RIL integration, audio packages and policy configuration, GPS/APN config, codec configs, libion, filesystem tools, Wi-Fi, and permission XML.
- sepolicy/ and seccomp/: evidence that MT6795-derived CM14.1 builds required platform-specific SELinux and seccomp policy.
- ril/: legacy MTK RIL integration reference.

Useful downstream device examples:
- https://github.com/MTK-Dev/android_device_allview_x2xtreme/tree/cm-14.1
- https://github.com/MTK-Dev/android_device_blu_purexl/tree/cm-14.1
- LeEco X500 MT6795 LineageOS 14.1 device tree: https://github.com/WisniaPL/x500-device-tree

The X500 page reports that its Nougat port used the same MT6795 / PowerVR G6200 class and achieved working RIL, audio, Wi-Fi, Bluetooth and GPS, with camera issues remaining. This is useful as proof that the SoC family had non-stock Nougat support, but is not direct evidence for HTC hardware or for Pie.

## How this informs this device

Use the shared tree only to understand the Android-side MediaTek interfaces and required build flags. The HTC M9+ must retain its own HTC init scripts, board properties and mount/fstab chain; HTC display, touch, fingerprint, NFC, audio, sensor and camera hardware configuration; exact stock proprietary binaries and firmware; and 3-way HTC DTB selection and correct htc_pid.

Do not import the Allview, BLU or LeEco partition values, panel setup, camera files, radio firmware, GPIOs or init files into this product. Their hardware differs.

## Android 9 gap

The common MT6795 tree is CM14.1-era (Android 7.1). The exact-device HTC kernel and historical trees are Android 5.1-era and Linux 3.10.61. The handset's own baseline is Android 6.0 and Linux 3.10.72. No verified MT6795 Android 9 common device tree or M9+ Pie branch has been located in the repositories inspected so far.

Therefore, LineageOS 16 requires an explicit port of the legacy MTK HAL/RIL integration and vendor policies onto the Android 9 framework. Merely adding HTC blobs to a LineageOS 16 checkout is not sufficient.
