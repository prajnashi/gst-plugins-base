LOCAL_PATH := $(call my-dir)

GST_PLUGINS_BASE_TOP := $(LOCAL_PATH)

include $(CLEAR_VARS)

# base libraries
include $(GST_PLUGINS_BASE_TOP)/gst-libs/gst/tag/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst-libs/gst/audio/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst-libs/gst/video/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst-libs/gst/riff/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst-libs/gst/pbutils/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst-libs/gst/rtp/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst-libs/gst/rtsp/Android.mk

# plugins without external dependencies
include $(GST_PLUGINS_BASE_TOP)/gst/audiotestsrc/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst/audioconvert/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst/audiorate/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst/audioresample/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst/ffmpegcolorspace/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst/gdp/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst/playback/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst/speexresample/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst/tcp/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst/typefind/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst/videoscale/Android.mk
include $(GST_PLUGINS_BASE_TOP)/gst/videotestsrc/Android.mk

