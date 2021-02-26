# common profile for all inuvik variants.
#
LOCAL_ARM_AARCH64         := y
LOCAL_ARM_AARCH64_NOT_ABI_COMPATIBLE ?= y
NEXUS_PLATFORM            ?= 97216
BCHP_VER                  ?= B0
PLATFORM                  ?= 97216
V3D_SUPPORT               ?= y
LOCAL_DEVICE_HWCFG_TYPE   := vfat
LOCAL_DEVICE_PROPERTIES_LEGACY := n
LOCAL_CFG_PROFILE         ?= default
LOCAL_DEVICE_USE_AVB      := y
HW_SUPER_SUPPORT          := y
LOCAL_DEVICE_SEPOLICY_IOCTL ?= nvk
LOCAL_DEVICE_SEPOLICY_BLOCK_INSTANCE ?= device/broadcom/inuvik/sepolicy/treble/${LOCAL_DEVICE_SEPOLICY_IOCTL}
LOCAL_NEXUS_SPI_USE       := y
LOCAL_FSTAB_DEFINITION    ?= fstab.avb.abu
LOCAL_FS_INIT_SETUP       ?= init.fs.metaenc.rc

LOCAL_DEVICE_SAGE_DEV_N_PROD ?= y
LOCAL_DEVICE_BOOTLOADER_DEV ?= y
LOCAL_DEVICE_BOOTLOADER_PROD ?= ZB
include device/broadcom/common/kver.mk
include device/broadcom/inuvik-common/bindist.mk
include device/broadcom/common/nxvchk.mk

# enable user mode 32bit with kernel mode 64bit compatible mode.
LOCAL_ARM_AARCH64_COMPAT_32_BIT ?= y

LOCAL_DEVICE_FRAGMENT ?= ott
include device/broadcom/inuvik-common/fragments/${LOCAL_DEVICE_FRAGMENT}.mk

HW_HVD_REDUX              ?= y

# compile the rc's for the device.
LOCAL_DEVICE_RCS                 := device/broadcom/common/rcs/init.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.inuvik.rc
ifeq (${HW_VENDOR_RAMDISK_SUPPORT},y)
LOCAL_DEVICE_RCS                 += device/broadcom/common/rcs/init.ft.mmu.nx.eko.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.nx.rc
else
LOCAL_DEVICE_RCS                 += device/broadcom/common/rcs/init.ft.mmu.nx.v2.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.nx.rc
endif
LOCAL_DEVICE_RCS                 += device/broadcom/common/rcs/ueventd.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc
LOCAL_DEVICE_RCS                 += device/broadcom/common/rcs/${LOCAL_FS_INIT_SETUP}:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.fs.rc
LOCAL_DEVICE_RCS                 += device/broadcom/inuvik-common/rcs/init.block-zram.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.block.rc
LOCAL_DEVICE_RCS                 += device/broadcom/inuvik-common/rcs/init.bcm.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.bcm.usb.rc
LOCAL_DEVICE_RCS                 += device/broadcom/common/rcs/init.mem.tune.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.mem.tune.rc

LOCAL_DEVICE_RECOVERY_RCS        := device/broadcom/common/rcs/init.recovery.rc:root/init.recovery.inuvik.rc
LOCAL_DEVICE_RECOVERY_RCS        += device/broadcom/inuvik-common/rcs/init.block-zram.rc:root/init.recovery.block.rc
LOCAL_DEVICE_RECOVERY_RCS        += device/broadcom/inuvik-common/rcs/init.recovery.usb.rc:root/init.recovery.usb.rc
LOCAL_DEVICE_RECOVERY_RCS        += device/broadcom/common/rcs/ueventd.rc:root/ueventd.inuvik.rc

ifeq ($(LOCAL_DEVICE_FORCED_NAB),y)
LOCAL_DEVICE_FSTAB               := device/broadcom/inuvik-common/fstab/fstab.verity.early:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.inuvik
LOCAL_DEVICE_FSTAB               += device/broadcom/inuvik-common/fstab/fstab.verity.early:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.bcm
LOCAL_DEVICE_RECOVERY_FSTAB      := device/broadcom/common/recovery/fstab.default/recovery.fstab
else
LOCAL_DEVICE_FSTAB               := device/broadcom/inuvik-common/fstab/${LOCAL_FSTAB_DEFINITION}:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.bcm
LOCAL_DEVICE_FSTAB               += device/broadcom/inuvik-common/fstab/${LOCAL_FSTAB_DEFINITION}:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.inuvik
ifeq (${HW_VENDOR_RAMDISK_SUPPORT},y)
LOCAL_DEVICE_FSTAB               += device/broadcom/inuvik-common/fstab/${LOCAL_FSTAB_DEFINITION}:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.inuvik
else
LOCAL_DEVICE_FSTAB               += device/broadcom/inuvik-common/fstab/${LOCAL_FSTAB_DEFINITION}:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.inuvik
endif
LOCAL_DEVICE_RECOVERY_FSTAB      := device/broadcom/common/recovery/fstab.ab-u.f2fs-data/recovery.fstab
endif

# compile the media codecs for the device.
ifeq ($(LOCAL_ARM_TRUSTZONE_USE),y)
LOCAL_DEVICE_MEDIA               := device/broadcom/common/media/media_codecs_with_av1__no_legacy_enc__no_sec_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml
else
LOCAL_DEVICE_MEDIA               := device/broadcom/common/media/media_codecs_with_av1__no_legacy_enc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml
endif
LOCAL_DEVICE_MEDIA               += device/broadcom/common/media/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml
ifeq ($(HW_HVD_REDUX),y)
LOCAL_DEVICE_MEDIA               += device/broadcom/inuvik-common/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml
else
LOCAL_DEVICE_MEDIA               += device/broadcom/inuvik-common/media_codecs_performance_no_pip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml
endif

LOCAL_DEVICE_SEPOLICY_BLOCK      := device/broadcom/inuvik-common/sepolicy/block
LOCAL_DEVICE_SEPOLICY_BLOCK      += device/broadcom/inuvik-common/sepolicy/treble
LOCAL_DEVICE_SEPOLICY_BLOCK      += ${LOCAL_DEVICE_SEPOLICY_BLOCK_INSTANCE}
LOCAL_DEVICE_AON_GPIO     ?= device/broadcom/inuvik-common/gpio/aon_gpio.nvk.cfg:$(TARGET_COPY_OUT_VENDOR)/power/aon_gpio.cfg
LOCAL_DEVICE_GPT_Q_LAYOUT := y

V3D_VARIANT               := vc5
LOCAL_DEVICE_REFERENCE_BUILD := device/broadcom/inuvik/reference_build.mk
HW_AB_UPDATE_SUPPORT      ?= y
LOCAL_DEVICE_USE_VERITY   := y
LOCAL_DEVICE_RTS_MODE     ?= 2
LOCAL_DEVICE_BR_4_RTS     ?= 40
BOLT_IMG_TO_USE_OVERRIDE  := bolt-ba.bin
BROADCOM_WIFI_CHIPSET     := 4375b1
LOCAL_DEVICE_BT_CONFIG    := device/broadcom/inuvik-common/bluetooth/vnd_inuvik.txt
BROADCOM_DHD_SOURCE_PATH  := vendor/broadcom/drivers/bcmwlan
HW_WIFI_CLM_SUPPORT       := y
HW_WIFI_PREBUILTS_SUPPORT := y
ANDROID_ENABLE_BT         := uart
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/broadcom/inuvik-common/bluetooth/
LOCAL_DEVICE_POWER_GOV    ?= cs
LOCAL_SECDMA_SIZE_MB      := 32
ANDROID_ENABLE_DHD_SECDMA := n
ifeq ($(HW_HVD_REDUX),y)
LOCAL_HEAP_MAIN_SIZE_MB   ?= 148
LOCAL_HEAP_GFX_SIZE_MB    ?= 40
LOCAL_HEAP_CRR_SIZE_MB    ?= 80
else
LOCAL_HEAP_MAIN_SIZE_MB   ?= 112
LOCAL_HEAP_GFX_SIZE_MB    ?= 48
LOCAL_HEAP_CRR_SIZE_MB    ?= 64
endif


LOCAL_DEVICE_PAK_BINARY_DEV  := pak.7218.zd.bin
LOCAL_DEVICE_PAK_BINARY_PROD := pak.7218.zb.bin

# no legacy decoder (vp8, h263, mpeg4) in hardware v.1
HW_HVD_REVISION           := V
# 4k alignment required for raaga buffers
HW_RAAGA_ALIGNMENT        := 4096
# v3d mmu available.
HW_GPU_MMU_SUPPORT        := y
# dtu enabled.
HW_DTU_SUPPORT            := y
HW_DTU_SUPPORT_RECOVERY   := y
HW_DTU_MODE_SUPPORT       := all
# vulkan support.
HW_GPU_VULKAN_SUPPORT     := y

LOCAL_DEVICE_BGRCPKT_PLANES := 2
LOCAL_DEVICE_MKBOOTIMG_ARGS := --ramdisk_offset 0x42200000

# no encoder (for now).
HW_ENCODER_SUPPORT        := n

SVP_FW_SUPPORT ?= y
SVP_FW_SUPPORT_HVD := polaris
SVP_FW_SUPPORT_XPT := rave
SVP_FW_SUPPORT_DSP ?= def
SVP_FW_SUPPORT_DSP_EXT ?=

# kernel command line (temporary).
ifeq ($(LOCAL_ARM_TRUSTZONE_USE),y)
LOCAL_DEVICE_KERNEL_CMDLINE      := bmem=311m@2680m
LOCAL_DEVICE_KERNEL_CMDLINE      += bhpa=525m@2120m
else
ifeq ($(call nx_ver_major_gt_or_eq,20),true)
LOCAL_DEVICE_KERNEL_CMDLINE      += bhpa=1256m@1772m
else
LOCAL_DEVICE_KERNEL_CMDLINE      := bmem=311m@2645m
LOCAL_DEVICE_KERNEL_CMDLINE      += bhpa=615m@2028m
endif
endif
LOCAL_DEVICE_KERNEL_CMDLINE      += rootwait init=/init ro
ifeq (${LOCAL_ANDROID_64BIT},y)
LOCAL_DEVICE_KERNEL_CMDLINE      += androidboot.selinux=permissive
endif

LOCAL_DTBO_SUPPORT      := y

# baseline the common support.
$(call inherit-product, device/broadcom/common/bcm.mk)
$(call inherit-product, device/broadcom/common/api.mk)
PRODUCT_NAME                     := inuvik
PRODUCT_MODEL                    := inuvik
PRODUCT_BRAND                    := google
PRODUCT_DEVICE                   := inuvik

# additional setup per device.
PRODUCT_PROPERTY_OVERRIDES += \
   ro.opengles.version=196609 \
   \
   ro.vendor.nx.heap.video_secure=${LOCAL_HEAP_CRR_SIZE_MB}m \
   ro.vendor.nx.heap.drv_managed=0m \
   ro.vendor.nx.heap.gfx2=0m \
   ro.vendor.nx.heap.main=${LOCAL_HEAP_MAIN_SIZE_MB}m \
   ro.vendor.nx.heap.gfx=${LOCAL_HEAP_GFX_SIZE_MB}m \
   \
   ro.vendor.nx.capable.dtu=1 \
   ro.vendor.nx.dtu.all=0 \
   ro.vendor.nx.dtu.pbuf0.addr=0x0 \
   ro.vendor.nx.dtu.spbuf0.addr=0x0 \
   ro.vendor.nx.dtu.user.addr=0x0 \
   ro.vendor.nx.dtu.user.auto=1 \
   ro.vendor.nx.dtu.user.size=0x30000000 \
   \
   ro.vendor.nx.capable.cb=1 \
   ro.vendor.nx.capable.bg=1 \
   ro.sf.lcd_density=320 \
   ro.vendor.nx.hwc.twk.fbcomp=1 \
   \
   ro.vendor.nx.dhd.pcieix=1 \
   ro.vendor.nx.dhd.secdma.align=16m \
   \
   ro.vendor.nx.eth.irq_mode_mask=f:c \
   \
   ro.vendor.nx.capable.fe=1 \
   \
   ro.oem.key1=ATV00100020 \
   \
   persist.sys.zram_enabled=1 \
   ro.zram.mark_idle_delay_mins=20 \
   ro.zram.first_wb_delay_mins=1440 \
   ro.zram.periodic_wb_delay_hours=24

# non tunnel mode hdr (eg. YT vp9.2|av01, Prime HEVC)
PRODUCT_PROPERTY_OVERRIDES += \
   ro.vendor.nx.med.vd_hdr_vp9ntnl=1 \
   ro.vendor.nx.med.vd_hdr_hevcntnl=1 \
   ro.vendor.nx.med.vd_hdr_av01ntnl=1

ifeq ($(HW_HVD_REDUX),y)
PRODUCT_PROPERTY_OVERRIDES += \
   ro.vendor.nx.trim.pip=0 \
   ro.vendor.nx.trim.pip.qr=1 \
   ro.vendor.nx.trim.mosaic=0 \
   ro.vendor.nx.trim.mtg=0 \
   ro.vendor.nx.trim.disp=0
endif

ifneq (${LOCAL_SUBVAR_NRDP_STRICT},y)
PRODUCT_PROPERTY_OVERRIDES += \
   ro.vendor.nx.hwc.twk.feotf=0
endif

ifneq ($(LOCAL_CFG_PROFILE),default)
# last but not least, include device flavor profile.
include device/broadcom/inuvik-common/profiles/${LOCAL_CFG_PROFILE}.mk
endif
