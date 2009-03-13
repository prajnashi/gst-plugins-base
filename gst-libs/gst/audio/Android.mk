LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

# FIXME: mixerutils.c is removed, because it depends on gst-lib/gst/interface.
# We need to add it later

LOCAL_SRC_FILES:= 			\
	audio.c 			\
	gstaudioclock.c 		\
	multichannel.c 			\
	gstaudiofilter.c 		\
	gstaudiosink.c 			\
	gstaudiosrc.c 			\
	gstbaseaudiosink.c 		\
	gstbaseaudiosrc.c 		\
	gstringbuffer.c   		\
	./android/gst/audio/audio-enumtypes.c

LOCAL_SHARED_LIBRARIES :=	\
	libgstreamer-0.10	\
	libgstbase-0.10		\
	libglib-2.0		\
	libgthread-2.0		\
	libgmodule-2.0		\
	libgobject-2.0

LOCAL_MODULE:= libgstaudio-0.10

LOCAL_C_INCLUDES := 			\
	$(LOCAL_PATH)			\
	$(GST_PLUGINS_BASE_TOP)		\
	$(GST_PLUGINS_BASE_TOP)/gst-libs\
	$(GST_PLUGINS_BASE_TOP)/android	\
	$(LOCAL_PATH)/android		\
	$(LOCAL_PATH)/android/gst/audio	\
	external/gstreamer		\
	external/gstreamer/android 	\
	external/gstreamer/gst/android 	\
	external/gstreamer/libs		\
	external/gstreamer/gst		\
	external/glib		  	\
	external/glib/android	  	\
	external/glib/glib		\
	external/glib/gmodule	  	\
	external/glib/gobject	  	\
	external/glib/gthread

LOCAL_CFLAGS := \
	-DHAVE_CONFIG_H	

include $(BUILD_SHARED_LIBRARY)
