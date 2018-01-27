THEOS_DEVICE_IP = 192.168.31.126
ARCHS = armv7 armv7s arm64
TARGET = iphone:latest:9.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = JustJump
JustJump_FILES = Tweak.xm
JustJump_LDFLAGS = -lsimulatetouch 

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 WeChat"
