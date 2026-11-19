# HTC One M9+ stock boot and vendor baseline

This report is derived from the user's supplied HTC One M9+ stock-related archives and boot backup. No binary vendor blobs are redistributed here.

## Boot image

- Boot backup size: 33,554,432 bytes (32 MiB)
- Page size: 2048 bytes
- Kernel segment: 7,357,362 bytes; load address `0x40080000`
- Ramdisk segment: 2,267,932 bytes; load address `0x44000000`
- Second-stage size: 0
- Tags address: `0x4e000000`
- Header command line: `bootopt=64S3,32N2,64N2`
- Common MTK base inferred from addresses: `0x40078000`
- Relative offsets: kernel `0x8000`, ramdisk `0x03f88000`, second `0x00e88000`, tags `0x0df88000`
- Decompressed kernel version: **3.10.72-00985-g797d1b3**, GCC 4.9.x-google, Tue Oct 18 17:32:43 CST 2016

The base/offset/page-size tuple matches the MT6795 X500 LineageOS 16.0 reference BoardConfig. It validates common MTK boot-image layout conventions only; it does not make X500's kernel or board settings usable on the HTC.

## Magisk status

The ramdisk includes `.backup/.magisk`, `.backup/init.xz`, and `overlay.d/sbin/magisk.xz`. Therefore the supplied TWRP boot backup is Magisk-patched, not an untouched stock boot image. The original static AArch64 Android 23 init binary was recovered from `.backup/init.xz` (991,600 bytes). Do not treat the current ramdisk `/init` as stock.

## Device trees

Three raw FDTs are appended to the kernel segment. All are 40,897 bytes and contain 1,121 parsed properties. Their only differing parsed property is `/htc_board_info/htc_pid`, with values 0, 1 and 2. All identify `MT6795` / `mediatek,MT6795`.

Device-specific data includes `maxim,max1187x_tsc` touch controller, JDI and Tianma panel choices, a fingerprint interrupt node (`fpc,fpc_irq`), an AK8789 hall sensor, and an NXP PN544 NFC node. The active panel/touch configuration must be matched to the actual phone before changing DTB content.

## Ramdisk and partition facts

The stock fstab identifies system, userdata, cache, protect1/protect2, apppreload, cota, carrier, devlog, fataldevlog, persist, nvram, proinfo, lk, para, boot, recovery, logo, expdb, secro, seccfg, tee1 and tee2. The primary by-name path is `/dev/block/platform/mtk-msdc.0/11230000.MSDC0/by-name/`.

The MT6795 init import chain includes HTC project, USB, storage and modem scripts. `init.modem.rc` is explicitly marked as the final import; preserve that ordering if converting the legacy init setup.

## Vendor dependency inventory

Across the first 60-library report and the extra-library/hardware archives, 271 ELF shared objects were inspected (139 ELF32 / 132 ELF64), with 2,393 `DT_NEEDED` entries. Archive-only resolution leaves 1,866 dependency edges / 85 unique ABI+SONAME pairs unresolved. Most are ordinary Android platform libraries (bionic, binder, UI, media, ICU, crypto, etc.) expected from the Android framework/system build, not evidence of missing device blobs.

Nine likely MTK/vendor-specific SONAMEs are still absent from all supplied archives:

- `lib3aIP.so` (32/64-bit)
- `libcam3_utils.so` (32/64-bit)
- `libmp4enc_sa.ca7.so` (32-bit)
- `libmtkjpeg.so` (32/64-bit)
- `libvc1dec_sa.ca7.so` (32-bit)
- `libvcodec_oal.so` (32-bit)
- `libvcodec_utility.so` (32/64-bit)
- `libvp8dec_sa.ca7.so` (32-bit)
- `libvp8enc_sa.ca7.so` (32-bit)

This is an archive-level result only. These may exist in uncollected portions of the stock `/system` image. Camera and codec dependency closure is not complete until their providers are located or deliberately replaced.

The triple Gatekeeper `libMcGatekeeper.so` SONAME aliases appear in both ABIs. Inspect symlink/loader layout before changing them; this may be intentional HTC/MTK naming, not a duplicate-linker error.

## Scope and limitations

This is a source/build preparation report, not a ROM. It does not prove Android 9 bootability, full vendor dependency closure, radio/camera compatibility, or flashability on an S-ON device. Do not flash these extracted files. No preloader, modem, NVRAM or calibration data is included in this report.
