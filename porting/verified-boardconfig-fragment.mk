# HTC One M9+ htc_hiau_ml_tuhl — evidence-backed BoardConfig fragment.
# This file is intentionally NOT named BoardConfig.mk and is NOT a complete build config.
# It must be reviewed against the final Android 9 device tree before use.

TARGET_BOARD_PLATFORM := mt6795
TARGET_BOOTLOADER_BOARD_NAME := htc_hiau_ml_tuhl
TARGET_NO_BOOTLOADER := true

TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 := armeabi-v7a
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi

TARGET_USERIMAGES_USE_EXT4 := true
BOARD_BOOTIMAGE_PARTITION_SIZE := 33554432
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 33554432
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 4949278720
BOARD_USERDATAIMAGE_PARTITION_SIZE := 25107103744

# Inferred from the supplied live boot header.
BOARD_KERNEL_BASE := 0x40078000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x03f88000
BOARD_SECOND_OFFSET := 0x00e88000
BOARD_TAGS_OFFSET := 0x0df88000
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2

# Kernel image layout from the supplied stock boot image.
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb

# Unknown or not yet verified: do NOT fill by copying the old Android 5.1 tree.
# BOARD_FLASH_BLOCK_SIZE
# TARGET_KERNEL_SOURCE / TARGET_KERNEL_CONFIG for the exact 3.10.72 device build
# BOARD_MKBOOTIMG_ARGS details beyond the verified offsets
# SELinux policy directories / BOARD_VENDORIMAGE_PARTITION_SIZE
# active htc_pid and panel
# complete partition map and mount flags
