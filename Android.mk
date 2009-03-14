LOCAL_PATH := $(call my-dir)

GST_PLUGINS_BASE_TOP := $(LOCAL_PATH)

include $(CLEAR_VARS)

include $(GST_PLUGINS_BASE_TOP)/gst-libs/gst/tag/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst-libs/gst/audio/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst-libs/gst/video/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst-libs/gst/riff/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst-libs/gst/pbutils/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst-libs/gst/rtp/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst-libs/gst/rtsp/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst/ffmpegcolorspace/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst/videoscale/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst/videotestsrc/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst/audiotestsrc/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst/playback/Android.mk
