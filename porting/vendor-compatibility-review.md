# HTC M9+ legacy vendor compatibility review

## Stock software interface

Verified from the supplied Europe stock build 2.30.401.1 / Android 6.0 / SDK 23:
- Product tree: htc_hiau_ml_tuhl; MT6795; 64-bit primary ABI with ARM32 secondary ABI.
- Legacy MediaTek branch string: alps-mp-m0.mp5.tc7sp.
- Legacy RIL entry: rild.libpath=mtk-ril.so; rild.libargs=-d /dev/ttyC0.
- Connectivity: MT6630 combo chip; Wi-Fi and Bluetooth use the MTK connectivity stack.
- Graphics: PowerVR G6200 userspace stack, MTK gralloc/HWC and ion/M4U memory interfaces.
- Security: Trustonic TEE support is enabled by the stock properties; Gatekeeper and keystore HALs are present in the captured vendor inventory.
- Camera: MTK camera HAL plus HTC/MTK camera service and helper libraries; multiple 32/64-bit components.

## Android 9 adaptation areas

1. **RIL and telephony:** the stock image uses the legacy MTK rild + mtk-ril.so interface and modem node. The CM14.1 common MT6795 tree provides a legacy RIL integration reference, but the exact HTC radio stack and HTC's dual-SIM / LTE properties must be kept. Verify voice, SMS, data, IMS/VoLTE and emergency calls separately.
2. **Graphics and memory:** the existing PowerVR G6200 stack uses MTK gralloc/HWC and ion/M4U helpers. Android 9 graphics framework compatibility, framebuffer/HWC behavior, and memory allocator ABI are high-risk. Do not substitute a different MT6795 phone's display stack.
3. **Camera and codecs:** captured archives do not yet close the dependency chains for lib3aIP.so, libcam3_utils.so, libmp4enc_sa.ca7.so, libmtkjpeg.so, libvc1dec_sa.ca7.so, libvcodec_oal.so, libvcodec_utility.so, libvp8dec_sa.ca7.so and libvp8enc_sa.ca7.so. Some could be in the uncaptured portion of stock /system. Camera must remain an open gate until these providers and their 32/64-bit dependencies are verified.
4. **Audio:** stock MTK audio HALs and HTC acoustic/audio customizations coexist. Preserve policy, mixer paths, calibration and tuning files from the Europe firmware; Android 9's audio policy XML conversion needs explicit testing.
5. **Sensors, fingerprint and NFC:** keep the HTC MAX1187X touch, FPC/Synaptics fingerprint, AK8789 hall and PN544 NFC variants from the actual selected DTB. HALs and their input/sysfs paths need validation against the running phone.
6. **TEE, keystore and SELinux:** Trustonic, Gatekeeper, keystore and proprietary secure services may depend on matching kernel interfaces and firmware. Never replace or repartition secure partitions to work around a HAL failure. Bring SELinux up permissive only for controlled diagnostic builds, then produce enforcing policy before release.

## Important implementation rule

The handset predates Treble and uses system-partition vendor libraries. Do not invent a vendor partition or blindly copy a modern Treble device layout. Android 9's framework-side HAL expectations must be reconciled with the old MTK binary interfaces in this same system partition.

## What this review does not prove

This is an interface inventory, not a compatibility certification. It does not establish that the Android 6 vendor binaries load on Android 9, that the modem works, or that camera, fingerprint, NFC, audio or GPU acceleration will work. Full stock /system extraction and runtime validation are still required.
