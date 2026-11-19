# HTC One M9+ Android 9 port assessment

**Target:** HTC One M9+ Europe, `htc_hiau_ml_tuhl`  
**Goal:** Android 9 / LineageOS 16.0  
**Assessment date:** 2026-11-19  
**Status:** Research baseline only; no flashable build has been produced or validated.

## 1. Confirmed target facts

The target is the MediaTek MT6795 / Helio X10 variant, not the Qualcomm HTC One M9 (`himaul`). The user's stock system identifies as:

- Product/device: `htc_hiau_ml_tuhl`
- Platform: `mt6795` / `MT6795`
- ABI: ARM64 with 32-bit ARM compatibility
- Stock Android: 6.0, build `MRA58K/821792.1`
- Running kernel: `3.10.72-00985-g797d1b3`, ARM64, GCC 4.9
- Reported HTC source identifier: `HIAUMLTUHL_HTC_WWE_M60_CRC_Sense70_Stable_MR_487629`

Measured partition capacities from the running device (bytes):

| Partition | Bytes | MiB |
|---|---:|---:|
| boot | 33,554,432 | 32 |
| recovery | 33,554,432 | 32 |
| system | 4,949,278,720 | 4,720 |
| userdata | 25,107,103,744 | 23,936 |

Use these measured capacities as the source of truth when writing the HTC device configuration. Do not copy partition sizes from old public recovery trees.

## 2. Most useful Android 9 / MT6795 reference

The strongest reproducible platform reference found is the LeEco X500 (Le 1s), another MT6795 / Helio X10 device:

- Pie device tree: https://github.com/Le1s/android_device_leeco_x3/tree/lineage-16.0-pie
- Corresponding kernel: https://github.com/Le1s/android_kernel_leeco_x3/tree/android-9.x_entangled
- Kernel defconfig: `arch/arm64/configs/x500_defconfig`
- Device-tree BoardConfig: `BoardConfig.mk`
- Product config: `lineage_x3.mk`

The kernel Makefile on the Android 9 branch reports Linux **3.10.108**. Its defconfig selects `CONFIG_ARCH_MT6795=y`, ARM64, and ARM32 compatibility. The Pie device tree builds with Android 9 HIDL compatibility plumbing while retaining legacy/passthrough MTK HALs. It sets `PRODUCT_SHIPPING_API_LEVEL := 23`, which is useful evidence that an Android 6-era vendor baseline can be adapted to a Pie framework.

**Important limitation:** X500 is not the HTC M9+. Its kernel, device tree, display panel, camera, touch controller, sensors, modem integration and board-specific drivers are not drop-in compatible. The X500 kernel is a platform reference, not a candidate boot image for this phone.

The X500 Pie README is also a warning about integration quality. Its published status lists working Wi-Fi/hotspot, USB/Bluetooth tethering, charging, lights, sensors (with fingerprint excluded) and IR; it lists fingerprint and GPS problems, audio glitches, some video lag, and mobile-data instability. Those are X500's reported results, not predictions that each exact issue will occur on the HTC.

## 3. HTC-specific source and device-tree findings

Two old public HTC M9+ trees were found:

- https://github.com/xiaolu/android_device_htc_htc_hiau_ml_tuhl/tree/cm-12.1
- https://github.com/sabpprook/android_device_htc_hiau_ml_tuhl/tree/android-5.1

They are old CM12.1 / Omni recovery configurations, not an Android 9 device tree. They contain an old prebuilt kernel image and recovery files; they do not provide a current, verified Linux 3.10.72 source tree or a Pie port.

Their old BoardConfig files contain stale partition capacities. For example, the xiaolu tree specifies 16 MiB boot and recovery, while the current device measurements are 32 MiB each. Other old values do not match the current system/data capacities. These old partition constants must not be reused.

The HTC-specific tree does provide useful historical clues such as the target codename, MT6795 platform, ARM64/ARM32 ABI arrangement, and a boot base of `0x40078000` with 2048-byte pages. The exact current boot-header offsets, DTB selection, command line and ramdisk layout must be confirmed against the user's saved stock boot image rather than assumed from an old recovery configuration.

### Official HTC kernel-source listing

HTCDev's public source listing contains an HTC One M9+ Europe CRC source entry for firmware 1.85.401.5, Android 5.0.2, kernel **3.10.61** (497 MB). It does not establish that this archive matches the user's later Android 6.0 / 3.10.72 build.

Source listing: https://www.htcdev.com/devcenter/downloads/P460

The user's running kernel is 3.10.72. Until an exact matching 3.10.72 HTC source package or a verifiable patch path is found, the kernel source baseline remains an unresolved blocker. The X500 3.10.108 kernel cannot fill this gap by itself.

### HTC One X9 as a closer HTC/MTK kernel clue

A public device report for the HTC One X9 (`E56_ML_DTUL`, another HTC MT6795 device) records Android 6.0 and kernel `3.10.72-00874-gbb55c05`. The user's M9+ build is `3.10.72-00985-g797d1b3`. That makes the X9 a potentially closer HTC kernel-lineage reference than the Redmi Note 2, but it is a different board/device and the build IDs are not identical. Searches did not surface a verifiable public `android_kernel_htc_e56` source repository or source package. Do not treat the X9 kernel binary or its DTB as interchangeable with the M9+.

Device report: https://4pda.to/forum/index.php?showtopic=555928&st=140

### Same-version MT6795 kernel reference

A second kernel reference is available at:

- https://github.com/nofearnohappy/Kernel-3.10.72-new
- Kernel Makefile: `kernel-3.10/Makefile`
- Defconfig: `kernel-3.10/arch/arm64/configs/hermes_defconfig`

This repository's Makefile reports Linux **3.10.72**, and its README identifies the target as Xiaomi Redmi Note 2 (`hermes` / `hennesy`) on MT6795 with a Vanzo ALPS-MP-M0.MP11 vendor BSP. Its defconfig selects `CONFIG_ARCH_MT6795=y`, `CONFIG_MTK_PLATFORM="mt6795"`, and platform-specific camera, display, touch and sensor drivers.

This is a useful same-version, same-SoC comparison point for the HTC 3.10.72 kernel. It is still **not an HTC source drop**: its `hermes_defconfig`, panel dimensions, camera sensor list, touch controller and board-specific hardware settings are for Redmi Note 2. Its code can help identify common MTK kernel components, but HTC board support must be brought from HTC-specific source or reconstructed from verified stock artifacts.

## 4. Historical M9+ Pie ROM lead — not validated

A 2019 page advertises an unofficial beta called “Pixel Experience Android Pie 9.0 Wannabe” for HTC One M9+:

https://htc.officialsforums.com/custom-rom-htc-one-m9-plus-pixel-experience/

The post dates the build to 2019-04-24 and claims Wi-Fi, RIL, mobile data, GPS, camera/camcorder, Bluetooth, lights, sound/vibration and encryption work. However:

- The post calls it an **Unofficial Beta** and describes it as a “Wannabe” port.
- The download links are obfuscated through ouo.io and currently return HTTP 403 when followed from the research environment.
- No ROM binary, checksum, source tree, build instructions, device-tree commit or kernel source was obtained to verify the claims.
- The same page reports the ROM kernel as Linux **3.4.x**, which conflicts with the target's measured 3.10.72 kernel and needs explanation before it can be treated as a matching build.

This is a lead worth recovering for offline inspection if a trustworthy copy can be found, but it is **not** a safe or verified flash recommendation. Reliability is further weakened because the same generic “Wannabe” wording, identical working-feature claims and the same Linux 3.4.x info table also appear on unrelated HTC U Play and One M7 pages. Treat the M9+ post as an unverified repost/marketing page until an authentic binary, checksum and device-specific evidence are found.

## 5. Vendor baseline already inventoried

The existing blob-analysis workflow inspected 60 ELF libraries from `m9p-missing-libs.tar.gz`: 30 ARM32 and 30 AArch64. It recorded 493 `DT_NEEDED` entries. The reported 475 dependencies absent from that one archive do **not** mean they are missing from the phone; many are Android system libraries or may come from another vendor archive.

The additional stock hardware-blob archive previously supplied in the conversation contained camera, fingerprint, GPS, MTK audio, sensors, display/HWC/gralloc, PowerVR EGL/GLES and MT6630 Wi-Fi/Bluetooth material. The hardware blobs are a positive starting point, but dependency closure, library compatibility, init/property requirements, SELinux policy and HAL startup still need to be validated against Pie.

Existing analysis artifact: `htc-m9p-library-analysis.zip` (from workflow run 44465936879).

## 6. Recommended engineering path

1. **Recover or reconstruct the HTC kernel source.** Search for the source corresponding to the user's 3.10.72 build ID and firmware. Compare the official HTC 3.10.61 source with the same-version MT6795 Redmi kernel and the newer X500 Pie kernel to isolate common MTK code. None of these substitutes is exact HTC source. Keep the vendor kernel's board files, device tree, panel/touch/camera drivers and MTK modifications intact.
2. **Build an HTC device tree for LineageOS 16.0.** Start from the HTC-specific partition/device information, and borrow only framework/HIDL compatibility patterns from the X500 Pie tree. Do not import X500's `x500_defconfig`, partition sizes, panel settings, touch driver, camera configuration or modem setup as if they were HTC-specific.
3. **Reconcile the boot image.** Use the saved stock boot image and verified device data to establish the precise boot header, offsets, DTB/DTBO arrangement, kernel command line and ramdisk init imports. The existing boot partition is 32 MiB, not 16 MiB.
4. **Port the API-23 vendor stack carefully.** Inventory both 32-bit and 64-bit blobs, resolve every vendor dependency, adapt service definitions/HIDL wrappers, init rc files, properties and SELinux labels. Test display, camera, audio, sensors, fingerprint, Wi-Fi/BT, GNSS, and RIL separately.
5. **Build before flashing.** Produce repeatable unsigned test artifacts and inspect their contents and partition targets. Do not generate a normal OTA installer that writes firmware or unrelated partitions.
6. **Establish a recovery path before any device test.** The device is S-ON, and the earlier fastboot outputs were not consistent about unlock state. Do not assume arbitrary boot or recovery images can be flashed. Keep verified stock boot, recovery and data backups; never write preloader, modem/radio, NVRAM, calibration or other unrelated partitions.

## 8. Fresh analysis of the supplied boot backup and blobs

The 32 MiB `boot.emmc.win` backup was parsed directly. The kernel segment contains the exact running build string `3.10.72-00985-g797d1b3` (GCC 4.9.x-google; Tue Oct 18 17:32:43 CST 2016). The boot header reports 2048-byte pages, kernel load address `0x40080000`, ramdisk load address `0x44000000`, tags `0x4e000000`, and command line `bootopt=64S3,32N2,64N2`. Relative to base `0x40078000`, offsets are kernel `0x8000`, ramdisk `0x03f88000`, second `0x00e88000`, and tags `0x0df88000`. This exactly matches the MT6795 X500 Pie BoardConfig boot convention; it validates only the common MTK boot layout.

The backup ramdisk is **Magisk-patched**: it has `.backup/.magisk`, `.backup/init.xz` and `overlay.d/sbin/magisk.xz`. The original static AArch64 Android 23 init binary was recovered from `.backup/init.xz`; do not treat the current ramdisk `/init` as stock. The main MT6795 init imports HTC project/USB/storage scripts and explicitly imports `init.modem.rc` last.

Three 40,897-byte FDTs are appended after the compressed kernel. All three contain 1,121 parsed properties; their only parsed difference is `/htc_board_info/htc_pid` = 0, 1, or 2. The trees identify `maxim,max1187x_tsc` touch, JDI/Tianma panel variants, an FPC fingerprint interrupt, AK8789 hall sensor and NXP PN544 NFC. Preserve this HTC data rather than replacing it with the X500 DTB.

Including the separate extra-library and hardware archives, the combined vendor scan covers 271 ELF shared objects (139 ELF32, 132 ELF64) and 2,393 `DT_NEEDED` entries. There are 85 unique unresolved ABI/name pairs at archive-only scope, but most are standard Android platform libraries. Nine likely MTK/vendor-specific dependencies still do not appear in any supplied archive: `lib3aIP.so`, `libcam3_utils.so`, `libmp4enc_sa.ca7.so`, `libmtkjpeg.so`, `libvc1dec_sa.ca7.so`, `libvcodec_oal.so`, `libvcodec_utility.so`, `libvp8dec_sa.ca7.so`, and `libvp8enc_sa.ca7.so`. They may still exist in the uncollected portions of the original stock system image.

A text-only technical report was generated locally as `htc-m9p-stock-baseline-report.zip`. The new GitHub report is `docs/stock-boot-and-vendor-analysis.md`. No proprietary binary blobs were uploaded to the repository.

## 7. Current conclusion

**Android 9 on MT6795 is technically demonstrated by the X500 Pie port. A verified HTC One M9+ LineageOS 16.0 port is not yet established.**

The key blocker is now sharper: not the Android framework version or raw count of blobs, but the lack of a verified HTC-specific 3.10.72 kernel source/build path and a current HTC device tree. The historical M9+ Pie beta may provide a useful binary comparison, but it must be authenticated and inspected before relying on it.

No flashable build is claimed by this assessment.


## 9. Preliminary build inputs generated locally

A text-only report ZIP now includes:
- exact boot header and inferred mkbootimg offsets;
- full ramdisk CPIO file listing, extracted fstab, and init import ordering;
- the three-DTB comparison and hardware node summary;
- the combined vendor dependency report and nine likely vendor-specific unresolved SONAMEs;
- a **partial** proprietary path manifest assembled from the captured archives; and
- a verified boot/partition/ABI BoardConfig fragment.

The proprietary manifest is intentionally labelled partial: only paths present in the supplied subset archives are listed. It is not an authoritative full vendor extraction list. The BoardConfig file is also only a fragment and intentionally omits a kernel source/config until a matching HTC source path is established.
