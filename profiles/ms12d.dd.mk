# Boot mem parameters
LOCAL_DEVICE_KERNEL_CMDLINE      := bmem=311m@2715m
LOCAL_DEVICE_KERNEL_CMDLINE      += bhpa=685m@2028m
LOCAL_DEVICE_KERNEL_CMDLINE      += rootwait init=/init ro
ifeq (${LOCAL_ANDROID_64BIT},y)
LOCAL_DEVICE_KERNEL_CMDLINE      += androidboot.selinux=permissive
endif

# profile specific properties settings (heap match bmem regions).
PRODUCT_PROPERTY_OVERRIDES += \
   ro.vendor.nx.dolby.ms=12 \
   ro.vendor.nx.trim.pip=0 \
   ro.vendor.nx.trim.pip.qr=1 \
   ro.vendor.nx.trim.mosaic=0 \
   ro.vendor.nx.trim.mtg=0 \
   ro.vendor.nx.trim.disp=0 \
   ro.vendor.nx.aud.clock_accuracy=0
