LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

# We can't use samiparse because we don't have proper libxml2
# *BUT* this was fixed in git (it uses gregex from newer glib)
#SAMIPARSE_SOURCES = samiparse.c samiparse.h
SAMIPARSE_SOURCES = 

LOCAL_SRC_FILES:= 			\
	gsttcpplugin.c 			\
	gsttcp.c 			\
	gstmultifdsink.c  		\
	gsttcpclientsrc.c 		\
	gsttcpclientsink.c 		\
	gsttcpserversrc.c 		\
	gsttcpserversink.c 		\
	android/gsttcp-enumtypes.c	\
	android/gsttcp-marshal.c


LOCAL_SHARED_LIBRARIES := 	\
	libgstreamer-0.10	\
	libgstbase-0.10		\
	libglib-2.0		\
	libgthread-2.0		\
	libgmodule-2.0		\
	libgobject-2.0		\
	libgstdataprotocol-0.10

LOCAL_MODULE:= libgsttcp

LOCAL_C_INCLUDES := 			\
	$(LOCAL_PATH)			\
	$(LOCAL_PATH)/android		\
	$(GST_PLUGINS_BASE_TOP)		\
	$(GST_PLUGINS_BASE_TOP)/android	\
	$(GST_PLUGINS_BASE_TOP)/gst-libs\
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
