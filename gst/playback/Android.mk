LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= 		\
	gstplayback.c 		\
	gstplaybin.c 		\
	gstplaybin2.c 		\
	gstplaysink.c 		\
	gstplaybasebin.c 	\
	gstplay-enum.c 		\
	gstfactorylists.c 	\
	gstscreenshot.c 	\
	gststreaminfo.c 	\
	gststreamselector.c	\
	android/gstplay-marshal.c


LOCAL_SHARED_LIBRARIES := 	\
	libgstreamer-0.10	\
	libgstbase-0.10		\
	libgstpbutils-0.10	\
	libglib-2.0		\
	libgthread-2.0		\
	libgmodule-2.0		\
	libgobject-2.0

LOCAL_MODULE:= libgstplaybin

LOCAL_C_INCLUDES := 			\
	$(LOCAL_PATH)			\
	$(LOCAL_PATH)/android		\
	$(GST_PLUGINS_BASE_TOP)		\
	$(GST_PLUGINS_BASE_TOP)/android	\
	$(GST_PLUGINS_BASE_TOP)/gst-libs\
	$(GST_PLUGINS_BASE_TOP)/gst-libs/gst/pbutils/android \
	external/liboil			\
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
	external/glib/gthread

LOCAL_CFLAGS := \
	-DHAVE_CONFIG_H	

include $(BUILD_PLUGIN_LIBRARY)

###### DECODEBIN2

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= 		\
	gstdecodebin2.c		\
	gsturidecodebin.c	\
	gstfactorylists.c	\
	gstplay-enum.c		\
	android/gstplay-marshal.c

LOCAL_SHARED_LIBRARIES := 	\
	libgstreamer-0.10	\
	libgstbase-0.10		\
	libgstpbutils-0.10	\
	libglib-2.0		\
	libgthread-2.0		\
	libgmodule-2.0		\
	libgobject-2.0

LOCAL_MODULE:= libgstdecodebin2

LOCAL_C_INCLUDES := 			\
	$(LOCAL_PATH)			\
	$(LOCAL_PATH)/android		\
	$(GST_PLUGINS_BASE_TOP)		\
	$(GST_PLUGINS_BASE_TOP)/android	\
	$(GST_PLUGINS_BASE_TOP)/gst-libs\
	$(GST_PLUGINS_BASE_TOP)/gst-libs/gst/pbutils/android \
	external/liboil			\
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
	external/glib/gthread

LOCAL_CFLAGS := \
	-DHAVE_CONFIG_H	

include $(BUILD_PLUGIN_LIBRARY)
