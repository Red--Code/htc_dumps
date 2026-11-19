# HTC One M9+ Android 9 port preparation

**Target:** HTC One M9+ / M9pw, product codename `htc_hiau_ml_tuhl`, MT6795, HTC Europe firmware `2.30.401.1` (Android 6.0 / SDK 23).

**Status:** source and device data are being prepared. This repository does not yet contain a bootable ROM or a flashable ZIP. No image produced from the old kernel or old BoardConfig should be flashed.

## 1. Confirmed target identity and live layout

From the supplied phone properties, boot image and live partition-size readings:

- Product: `htc_hiau_ml_tuhl`; platform: MediaTek MT6795; 64-bit kernel and 32-bit app compatibility.
- Stock build fingerprint: `htc/hiau_ml_tuhl_htc_europe/htc_hiau_ml_tuhl:6.0/MRA58K/821792.1:user/release-keys`.
- Stock kernel: `3.10.72-00985-g797d1b3`, GCC 4.9.x-google, built 2016-10-18.
- Boot/recovery: 33,554,432 bytes each (32 MiB).
- System: 4,949,278,720 bytes (about 4.61 GiB).
- Userdata: 25,107,103,744 bytes (about 23.38 GiB).
- Boot header: 2048-byte page; base `0x40078000`; kernel offset `0x8000`; ramdisk offset `0x03f88000`; tags offset `0x0df88000`; command line `bootopt=64S3,32N2,64N2`.
- Stock kernel segment is gzip-compressed and contains three appended 40,897-byte DTBs.

The supplied boot backup is Magisk-patched. It is not a clean stock boot image.

## 2. Best available kernel source baseline

Repository: https://github.com/tbalden/android_kernel_htc_m9pw

- This is a full Linux kernel source tree specifically for HTC M9pw / M9+ and includes `arch/arm64/configs/hiau_ml_tuhl_defconfig`.
- Available branches `master` and `1.88` both identify Linux 3.10.61 in the kernel Makefile. The `1.88` branch has later maintenance commits (latest inspected commit 2018-01-09), but it is still 3.10.61.
- Its device configuration enables MT6795, ARM64, ARM compatibility, MT6630 combo/Wi-Fi, MAX1187X touchscreen, Android Binder, Ashmem, Android low-memory killer and SELinux.
- It is a valuable board-specific kernel baseline, but **not the exact installed 3.10.72 source**. It must not be used as an unchanged replacement kernel.

Historical device-tree prebuilt:
https://github.com/sabpprook/android_device_htc_hiau_ml_tuhl/tree/android-5.1

The exact-device tree contains an appended-DTB prebuilt whose gzip payload was extracted and inspected. Its kernel is `3.10.61-gae2b515`, built 2015-04-15 from a China CHS project path (`HIAUMLTUHL_ChinaOC_CHS_L50...`). It is not the user's Europe Android 6 kernel.

Official HTCdev M9+ kernel-source listings currently visible include Linux 3.10.61 / Android 5.0.2 packages, including EU firmware 1.85.401.5 and Asia/HK 1.81.708.2. No 3.10.72 / Android 6 M9+ source package was identified in the inspected listing:
https://www.htcdev.com/devcenter/downloads/P460

**Kernel blocker:** locate the exact HTC Europe Android 6 / 3.10.72 source package or reconstruct the vendor changes from a trustworthy matching source. A 3.10.61 source can be used for investigation and a possible porting base, but not assumed equivalent.

## 3. Exact-device Android tree baseline

- OmniROM Android 5.1 tree: https://github.com/sabpprook/android_device_htc_hiau_ml_tuhl/tree/android-5.1
- CyanogenMod 12.1 tree: https://github.com/xiaolu/android_device_htc_htc_hiau_ml_tuhl/tree/cm-12.1

These are useful references for product naming, init scripts and recovery layout. Their partition sizes are stale and must not be copied:
- old boot/recovery: 16 MiB; live device: 32 MiB;
- old system: 2,474,639,360 bytes; live device: 4,949,278,720 bytes;
- old userdata: 12,553,551,872 bytes; live device: 25,107,103,744 bytes.

Their prebuilt kernel is 3.10.61 and must not be packaged as the current 3.10.72 kernel.

## 4. DTB / display facts

The user's boot image contains three 40,897-byte FDTs. Their parsed properties are identical except `/htc_board_info/htc_pid` (0, 1 and 2). The common tree identifies:

- MT6795 / `mediatek,MT6795`
- `maxim,max1187x_tsc` touchscreen
- JDI and Tianma panel alternatives
- FPC fingerprint interrupt
- AK8789 hall sensor
- NXP PN544 NFC node

The actual active `htc_pid` and panel must be read from the running phone before selecting a DTB or building a replacement. The three DTBs must not be collapsed into one guessed configuration.

## 5. Vendor library baseline

Across the supplied partial library and hardware archives, 271 ELF shared objects were inspected (139 ARM32 and 132 ARM64), with 2,393 DT_NEEDED edges. Most archive-only unresolved dependencies are Android framework/runtime libraries and do not prove the device is missing those libraries.

Nine likely MTK/vendor-specific SONAMEs were not found in the supplied archives:
`lib3aIP.so`, `libcam3_utils.so`, `libmp4enc_sa.ca7.so`, `libmtkjpeg.so`, `libvc1dec_sa.ca7.so`, `libvcodec_oal.so`, `libvcodec_utility.so`, `libvp8dec_sa.ca7.so`, `libvp8enc_sa.ca7.so`.

They may still exist in the full stock `/system` partition. Camera/video compatibility is not closed until their stock locations and dependencies are checked.

## 6. Android 9 viability

The device is non-Treble (no `ro.treble.enabled` was reported). A generic GSI is therefore not the right shortcut; a device-specific non-Treble Android 9 / LineageOS 16 tree is required.

A 2019 web post advertises a Pie "Wannabe" repack, but identifies its kernel as Linux 3.4.x and does not provide a currently verifiable archive or checksum. It is not accepted as a valid M9pw Android 9 baseline. A contemporaneous /e/OS request for `htc_hiau_ml_tuhl` also reports no LineageOS support and only a discontinued Lollipop CleanSlate ROM. Treat the Pie claim as unverified.

The 3.10.61 source config already contains Binder, Ashmem and SELinux support, which is encouraging, but does not prove that its vendor HALs, radio, display, camera or Android 9 framework can be brought up.

## 7. Next technical gates

1. Obtain or reconstruct the correct HTC 3.10.72 kernel revision and matching config; compare its exported symbols and board drivers with the 3.10.61 baseline.
2. Read the active `htc_pid`, actual panel identity and current kernel config from the running phone.
3. Resolve the full vendor library set from the stock system, not only the partial archives.
4. Create a real LineageOS 16 device tree using the live partition sizes and full stock init/fstab chain; modernize recovery separately.
5. Build and boot-test a non-flashing image, then validate display/touch, storage, audio, Wi-Fi, Bluetooth, telephony, camera, fingerprint, NFC and encryption.
6. Only after recovery and bootloader constraints are demonstrated should a signed/recovery-installable package be considered.

## Safety constraints

- Do not flash the historical 3.10.61 kernel or the old BoardConfig.
- Do not repartition.
- Do not touch preloader, modem, radio, NVRAM, SECRO, calibration or other factory partitions.
- Keep a verified full backup and a known-good recovery path.
- Device currently has S-ON / bootloader-unlock status ambiguity; flashability is not yet established.
