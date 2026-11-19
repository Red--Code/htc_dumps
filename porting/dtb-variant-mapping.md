# HTC M9pw historical kernel device-tree variant mapping

Source: [tbalden/android_kernel_htc_m9pw, branch 1.88](https://github.com/tbalden/android_kernel_htc_m9pw/tree/1.88/arch/arm64/boot/dts).

The source defines three board DTBs and the Makefile includes all three in the appended multi-DTB image:

| DTB source | `htc_board_info` value | Match in supplied boot |
|---|---:|---|
| `hiau_ml.dts` | `htc_pid,htc_sku1 = <0x0 0x0>` | Corresponds to first of three DTBs |
| `hiau_ml-XB.dts` | `htc_pid,htc_sku1 = <0x0 0x1>` | Corresponds to second of three DTBs |
| `hiau_ml-XC.dts` | `htc_pid,htc_sku1 = <0x0 0x2>` | Corresponds to third of three DTBs |

All three use:
- `mt6795.dtsi`
- `cust_eint.dtsi`
- `htc_features.dtsi`
- `mt6795-touch-hiau_ml.dtsi`

The shared touch include describes a MAX1187X touchscreen, 1440×2560 coordinates, and several panel/touch configurations. The candidate panel strings include JDI and Tianma. The base DTS also describes PN544 NFC, an HTC MCU / sensor interface, and the AK8789 hall sensor.

The user-supplied boot image contains three 40,897-byte FDTs whose only parsed difference is the HTC PID/SKU cell. This is a strong structural match to the public kernel source. It does **not** tell us which of the three variants the bootloader selects on this particular phone. The active value and actual panel still need to be read from the running device using `scripts/capture-runtime-facts.sh`.

Do not choose one DTB by guesswork or remove the other two from a test build. Preserve the multi-DTB selection behavior until the bootloader selection mechanism is understood.
