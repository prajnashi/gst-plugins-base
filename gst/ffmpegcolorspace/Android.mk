LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= \
    gstffmpeg.c \
    gstffmpegcolorspace.c \
    gstffmpegcodecmap.c \
    dsputil.c \
    mem.c \
    utils.c \
    imgconvert.c
        	
LOCAL_SHARED_LIBRARIES := \
    libgstreamer-0.10       \
    libgstbase-0.10         \
    libglib-2.0             \
    libgthread-2.0          \
    libgmodule-2.0          \
    libgobject-2.0


LOCAL_TOP_PATH := $(LOCAL_PATH)/./../../..

LOCAL_MODULE:= libgstffmpegcolorspace


LOCAL_C_INCLUDES := \
    $(LOCAL_PATH)                       \
    $(LOCAL_PATH)/./../..               \
    $(LOCAL_PATH)/./../../..            \
    $(LOCAL_PATH)/./../../android       \
    $(LOCAL_TOP_PATH)/liboil            \
    $(LOCAL_TOP_PATH)/gstreamer         \
    $(LOCAL_TOP_PATH)/gstreamer/android \
    $(LOCAL_TOP_PATH)/gstreamer/libs    \
    $(LOCAL_TOP_PATH)/gstreamer/gst	    \
    $(LOCAL_TOP_PATH)/gstreamer/gst/android	    \
    $(LOCAL_TOP_PATH)/glib              \
    $(LOCAL_TOP_PATH)/glib/glib         \
    $(LOCAL_TOP_PATH)/glib/android      \
    $(LOCAL_TOP_PATH)/glib/gmodule      \
    $(LOCAL_TOP_PATH)/glib/gobject      \
    $(LOCAL_TOP_PATH)/glib/gthread

LOCAL_CFLAGS := \
    -DHAVE_CONFIG_H	

include $(BUILD_SHARED_LIBRARY)
