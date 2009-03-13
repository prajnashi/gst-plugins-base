LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= 		\
	video.c 		\
	gstvideosink.c 		\
	gstvideofilter.c 	\
	./android/gst/video/video-enumtypes.c

LOCAL_SHARED_LIBRARIES :=	\
	libgstreamer-0.10	\
	libgstbase-0.10		\
	libglib-2.0		\
	libgthread-2.0		\
	libgmodule-2.0		\
	libgobject-2.0

LOCAL_MODULE:= libgstvideo-0.10

LOCAL_C_INCLUDES := 			\
	$(GST_PLUGINS_BASE_TOP)		\
	$(GST_PLUGINS_BASE_TOP)/android	\
	$(LOCAL_PATH)			\
	$(LOCAL_PATH)/android		\
	$(LOCAL_PATH)/android/gst/video	\
	external/gstreamer		\
	external/gstreamer/android 	\
	external/gstreamer/gst/android 	\
	external/gstreamer/libs		\
	external/gstreamer/gst		\
	external/glib			\
	external/glib/android	  	\
	external/glib/glib		\
	external/glib/gmodule	  	\
	external/glib/gobject	  	\
	external/glib/gthread

LOCAL_CFLAGS := \
	-DHAVE_CONFIG_H	

include $(BUILD_SHARED_LIBRARY)
