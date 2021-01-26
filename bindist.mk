# binary (aka. prebuilt) layout
#
# binaries are located in a tree from root with the auto-generated layout described in:
#
#  a) https://sites.google.com/a/broadcom.com/pierre_couillaud/ext/android-q-binary-build
# OR
#  b) $(TOP)/vendor/broadcom/bcm_platform/docs/Android-10_Build.pdf
#
# the presence of a "<device>-kernel" repo determines whether this is a build from google
# partner build or a "public" build generating the binaries in the pre-android build step.
#
BCHP_CHIP                 ?= 7216
BCM_DIST_FORCED_BINDIST   := y
BCM_DIST_KNLIMG_BINS      := y
LOCAL_DEVICE_BDIST_TARGET ?= inuvik

ifneq ($(wildcard device/broadcom/inuvik-kernel),)
BCM_BINDIST_BL_ROOT     := vendor/broadcom/prebuilts/bootloaders/${LOCAL_DEVICE_BDIST_TARGET}
BCM_BINDIST_LIBS_ROOT   := vendor/broadcom/prebuilts/nximg/${LOCAL_LINUX_VERSION_NODASH}/${LOCAL_DEVICE_BDIST_TARGET}
BCM_BINDIST_KNL_ROOT    := device/broadcom/inuvik-kernel/${LOCAL_LINUX_VERSION_NODASH}
BAS_BINARY_DRV_PATH     := vendor/broadcom/prebuilts/bas/${LOCAL_LINUX_VERSION_NODASH}/${LOCAL_DEVICE_BDIST_TARGET}
LOCAL_DEVICE_DTBO_IMAGE := device/broadcom/inuvik-kernel/${LOCAL_LINUX_VERSION_NODASH}/bcm.dtb
else
BCM_BINDIST_BL_ROOT     := bindist/bootloaders/${LOCAL_DEVICE_BDIST_TARGET}
BCM_BINDIST_LIBS_ROOT   := bindist/nximg/${LOCAL_LINUX_VERSION_NODASH}/${LOCAL_DEVICE_BDIST_TARGET}
BCM_BINDIST_KNL_ROOT    := bindist/kernel/${LOCAL_LINUX_VERSION_NODASH}/${LOCAL_DEVICE_BDIST_TARGET}
BAS_BINARY_DRV_PATH     := bindist/bas/${LOCAL_LINUX_VERSION_NODASH}/${LOCAL_DEVICE_BDIST_TARGET}
LOCAL_DEVICE_DTBO_IMAGE := ${BCM_BINDIST_KNL_ROOT}/bcm.dtb
endif

# adding implicit copy rules for the bootloaders for "dist" targets.
#
ifeq (${BCM_DIST_FORCED_BINDIST},y)
ifeq ($(LOCAL_DEVICE_BOOTLOADER_DEV),y)
$(OUT_DIR)/target/product/$(LOCAL_PRODUCT_OUT)/bootloader.dev.img: ${BCM_BINDIST_BL_ROOT}/bootloader.dev.img
	cp $< $@
endif
ifneq ($(LOCAL_DEVICE_BOOTLOADER_PROD),)
$(OUT_DIR)/target/product/$(LOCAL_PRODUCT_OUT)/bootloader.prod.img: ${BCM_BINDIST_BL_ROOT}/bootloader.prod.img
	cp $< $@
endif
endif

