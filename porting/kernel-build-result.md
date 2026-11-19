# HTC M9pw reference kernel build result

## Result

GitHub Actions run: https://github.com/Red--Code/htc_dumps/actions/runs/44486275637
Artifact: htc-m9pw-reference-kernel-smoke-build-v5 (text report only)

**The reference kernel build completed successfully.** This is a reproducible compile result for the exact-device public source tree, not a boot test and not a flashable candidate.

## Reproducible source and toolchain

- Kernel repository: https://github.com/tbalden/android_kernel_htc_m9pw
- Branch: 1.88
- Commit: 76b4b8fc6cdbeb724ce6537ba32147f203b1d38a
- Config: hiau_ml_tuhl_defconfig
- Toolchain: Linaro GCC 4.9.4 (aarch64-elf-gcc), toolchain commit 1d616e144fe3253c7ab2694cbca9d296ef2825fb
- Host: Ubuntu 24.04 GitHub runner; legacy DTC compiled with HOSTCFLAGS=-fcommon

## Compiled target

- Target: arch/arm64/boot/Image.gz-dtb
- Output size: 6,941,557 bytes
- SHA-256: 8191c87d4c6e894ca335850223b17d86f9caf300cfd3fa5e196ff3e91fa2619d
- Kernel version string: Linux 3.10.61-gea92418
- Build timestamp: 2026-11-19 08:19:59 UTC
- hiau_ml.dtb: 35,807 bytes
- hiau_ml-XB.dtb: 35,807 bytes
- hiau_ml-XC.dtb: 35,807 bytes

## Configuration flags confirmed

- CONFIG_ARCH_MT6795=y
- CONFIG_BUILD_ARM64_APPENDED_DTB_IMAGE=y
- CONFIG_MTK_PLATFORM="mt6795"
- CONFIG_MTK_COMBO_CHIP_MT6630=y
- CONFIG_TOUCHSCREEN_MAX1187X=y
- CONFIG_ANDROID_BINDER_IPC=y
- CONFIG_ASHMEM=y
- CONFIG_SECURITY_SELINUX=y

## Build-system-only workarounds

The public branch has legacy include path omissions for three subdrivers. The CI workflow appends include directories for the existing headers in:
- drivers/misc/fpr_Synaptics/vfsSpiDrv.h
- drivers/misc/mediatek/gud/mt6795/gud/build_tag.h
- drivers/misc/mediatek/jpeg/mt6795/jpeg_cmdq.h

No driver source code or header contents were changed; only the compiler's include search paths were corrected in the temporary CI checkout. These corrections are documented so the source tree can later be patched cleanly.

## Why this is not a phone kernel yet

The device currently runs Linux 3.10.72-00985-g797d1b3, built for the HTC Europe Android 6.0 firmware. This reference source builds Linux 3.10.61-gea92418 from an older HTC M9pw baseline. It is a different kernel revision and configuration lineage. The build proves that the source tree and toolchain work; it does not prove binary compatibility with the installed bootloader, stock ramdisk, vendor modules, radio or hardware calibration. Do not flash this output.

The next kernel gate is to locate the exact 3.10.72 source or reconstruct/forward-port the HTC changes into a source tree that can be verified against the existing 3.10.72 modules and device tree. Active htc_pid and display panel must also be recorded from the running handset.
