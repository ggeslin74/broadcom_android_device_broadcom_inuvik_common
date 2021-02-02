# R launch device profile configuration
#
HW_VENDOR_RAMDISK_SUPPORT  := y
LOCAL_LAUNCH_DEVICE        := R
LOCAL_LINUX_VERSION        := -5.4
LOCAL_LINUX_VERSION_NODASH := 5.4
LOCAL_DEVICE_BOOT          := 83886080 # 80M
LOCAL_DEVICE_USERDATA      := 5905580032  # 5632M
HAL_KM_SUB_VERSION         := 4.1
NX_ION_SUPPORT             ?= y
HAL_GR_VERSION             := 4.x
LOCAL_DEVICE_RECOVERY_INIT_NX := init.recovery.kmods.nx.rc
