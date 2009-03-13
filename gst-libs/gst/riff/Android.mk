LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= 	\
	riff.c 		\
	riff-media.c 	\
	riff-read.c

LOCAL_SHARED_LIBRARIES :=	\
	libgsttag-0.10		\
	libgstaudio-0.10	\
	libgstreamer-0.10	\
	libgstbase-0.10		\
	libglib-2.0		\
	libgthread-2.0		\
	libgmodule-2.0		\
	libgobject-2.0

LOCAL_MODULE:= libgstriff-0.10

LOCAL_C_INCLUDES := 				\
	$(LOCAL_PATH)				\
	$(GST_PLUGINS_BASE_TOP)			\
	$(GST_PLUGINS_BASE_TOP)/android		\
	$(GST_PLUGINS_BASE_TOP)/gst-libs	\
	$(GST_PLUGINS_BASE_TOP)/gst-libs/gst/audio/android	\
	external/gstreamer		 	\
	external/gstreamer/android 		\
	external/gstreamer/libs			\
	external/gstreamer/gst			\
	external/gstreamer/gst/android		\
	external/glib			  	\
	external/glib/glib		 	\
	external/glib/android	  		\
	external/glib/gmodule	  		\
	external/glib/gobject	  		\
	external/glib/gthread

LOCAL_CFLAGS := \
	-DHAVE_CONFIG_H	

include $(BUILD_SHARED_LIBRARY)
