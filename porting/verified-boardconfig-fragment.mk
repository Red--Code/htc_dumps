# HTC One M9+ (M9pw) htc_hiau_ml_tuhl — evidence-backed BoardConfig fragment.
# This file is intentionally NOT named BoardConfig.mk and is NOT a complete build config.
# It combines values observed from the live phone with architecture values from
# the exact-device historical tree. Review against LineageOS 16 build rules before use.

TARGET_BOARD_PLATFORM := mt6795
TARGET_NO_BOOTLOADER := true

# Exact-device tree used arm64 primary + armv7 secondary.
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_SMP := true

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic

TARGET_USERIMAGES_USE_EXT4 := true
BOARD_BOOTIMAGE_PARTITION_SIZE := 33554432
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 33554432
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 4949278720
BOARD_USERDATAIMAGE_PARTITION_SIZE := 25107103744

# Exact boot-header values from the supplied M9pw boot image.
BOARD_KERNEL_BASE := 0x40078000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_MKBOOTIMG_ARGS := --kernel_offset 0x00008000 --ramdisk_offset 0x03f88000 --tags_offset 0x0df88000
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb

# Not included until independently verified:
# BOARD_FLASH_BLOCK_SIZE
# exact 3.10.72 kernel source/config
# active htc_pid and panel variant
# complete mount/fstab and partition map
# Android 9 SELinux policy and vendor build config
# vendor partition (device is non-Treble; do not invent one)
