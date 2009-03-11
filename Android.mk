LOCAL_PATH := $(call my-dir)

GSTREAMER_TOP := $(LOCAL_PATH)

include $(CLEAR_VARS)

include $(GSTREAMER_TOP)/gst-libs/gst/tag/Android.mk
include $(GSTREAMER_TOP)/gst-libs/gst/audio/Android.mk
include $(GSTREAMER_TOP)/gst-libs/gst/video/Android.mk
include $(GSTREAMER_TOP)/gst-libs/gst/riff/Android.mk
include $(GSTREAMER_TOP)/gst/ffmpegcolorspace/Android.mk
include $(GSTREAMER_TOP)/gst/videoscale/Android.mk
include $(GSTREAMER_TOP)/gst/videotestsrc/Android.mk
include $(GSTREAMER_TOP)/gst/audiotestsrc/Android.mk

