LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

# TODO: mixerutils.c is removed, because it depends on gst-lib/gst/interface.
# We need add it later
LOCAL_SRC_FILES:= \
  	audio.c \
   	gstaudioclock.c \
   	multichannel.c \
  	gstaudiofilter.c \
   	gstaudiosink.c \
   	gstaudiosrc.c \
   	gstbaseaudiosink.c \
   	gstbaseaudiosrc.c \
   	gstringbuffer.c   \
    ./android/gst/audio/audio-enumtypes.c
        	
LOCAL_SHARED_LIBRARIES := \
    libgstreamer-0.10       \
    libgstbase-0.10         \
    libglib-2.0             \
    libgthread-2.0          \
    libgmodule-2.0          \
    libgobject-2.0


LOCAL_TOP_PATH := $(LOCAL_PATH)/./../../../..

LOCAL_MODULE:= libgstaudio-0.10

LOCAL_C_INCLUDES := \
    $(LOCAL_PATH)                       \
    $(LOCAL_PATH)/./../..               \
    $(LOCAL_PATH)/./../../..            \
    $(LOCAL_PATH)/./../../../android    \
    $(LOCAL_PATH)/android               \
    $(LOCAL_PATH)/android/gst/audio     \
    $(LOCAL_TOP_PATH)/gstreamer         \
    $(LOCAL_TOP_PATH)/gstreamer/android \
    $(LOCAL_TOP_PATH)/gstreamer/gst/android \
    $(LOCAL_TOP_PATH)/gstreamer/libs    \
    $(LOCAL_TOP_PATH)/gstreamer/gst	    \
    $(LOCAL_TOP_PATH)/glib              \
    $(LOCAL_TOP_PATH)/glib/android      \
    $(LOCAL_TOP_PATH)/glib/glib         \
    $(LOCAL_TOP_PATH)/glib/gmodule      \
    $(LOCAL_TOP_PATH)/glib/gobject      \
    $(LOCAL_TOP_PATH)/glib/gthread

LOCAL_CFLAGS := \
    -DHAVE_CONFIG_H	

include $(BUILD_SHARED_LIBRARY)
