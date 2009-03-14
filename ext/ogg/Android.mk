LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= 		\
	gstogg.c 		\
	gstoggdemux.c 		\
	gstoggmux.c 		\
	gstogmparse.c 		\
	gstoggaviparse.c 	\
	gstoggparse.c

LOCAL_SHARED_LIBRARIES :=	\
	libgstreamer-0.10	\
	libgstaudio-0.10	\
	libgstbase-0.10		\
	libgstriff-0.10		\
	libgsttag-0.10		\
	libglib-2.0		\
	libgthread-2.0		\
	libgmodule-2.0		\
	libgobject-2.0		\
	libogg

LOCAL_MODULE:= libgstogg

LOCAL_PRELINK_MODULE := false 

LOCAL_C_INCLUDES := 			\
	$(LOCAL_PATH)			\
	$(GST_PLUGINS_BASE_TOP)		\
	$(GST_PLUGINS_BASE_TOP)/android	\
	$(GST_PLUGINS_BASE_TOP)/gst-libs\
	$(GST_PLUGINS_BASE_TOP)/gst-libs/gst/interfaces/android \
	external/gstreamer		\
	external/gstreamer/android 	\
	external/gstreamer/libs		\
	external/gstreamer/gst		\
	external/gstreamer/gst/android	\
	external/glib			\
	external/glib/glib		\
	external/glib/android	  	\
	external/glib/gmodule	  	\
	external/glib/gobject	  	\
	external/glib/gthread		\
	external/libogg/include

LOCAL_CFLAGS := \
	-DHAVE_CONFIG_H	

include $(BUILD_SHARED_LIBRARY)
