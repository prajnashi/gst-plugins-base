/* GStreamer
 * Copyright (C) 1999,2000 Erik Walthinsen <omega@cse.ogi.edu>
 *                    2005 Wim Taymans <wim@fluendo.com>
 *
 * gstaudiosink.c: simple audio sink base class
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#include <string.h>

#include "gstaudiosink.h"

GST_DEBUG_CATEGORY_STATIC (gst_audiosink_debug);
#define GST_CAT_DEFAULT gst_audiosink_debug

#define GST_TYPE_AUDIORINGBUFFER  	 \
	(gst_audioringbuffer_get_type())
#define GST_AUDIORINGBUFFER(obj) 	 \
	(G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_AUDIORINGBUFFER,GstAudioRingBuffer))
#define GST_AUDIORINGBUFFER_CLASS(klass) \
	(G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_AUDIORINGBUFFER,GstAudioRingBufferClass))
#define GST_AUDIORINGBUFFER_GET_CLASS(obj) \
	(G_TYPE_INSTANCE_GET_CLASS ((obj), GST_TYPE_AUDIORINGBUFFER, GstAudioRingBufferClass))
#define GST_IS_AUDIORINGBUFFER(obj)  	 \
	(G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_AUDIORINGBUFFER))
#define GST_IS_AUDIORINGBUFFER_CLASS(obj)\
	(G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_AUDIORINGBUFFER))

typedef struct _GstAudioRingBuffer GstAudioRingBuffer;
typedef struct _GstAudioRingBufferClass GstAudioRingBufferClass;

#define GST_AUDIORINGBUFFER_GET_COND(buf) (((GstAudioRingBuffer *)buf)->cond)
#define GST_AUDIORINGBUFFER_WAIT(buf)     (g_cond_wait (GST_AUDIORINGBUFFER_GET_COND (buf), GST_GET_LOCK (buf)))
#define GST_AUDIORINGBUFFER_SIGNAL(buf)   (g_cond_signal (GST_AUDIORINGBUFFER_GET_COND (buf)))
#define GST_AUDIORINGBUFFER_BROADCAST(buf)(g_cond_broadcast (GST_AUDIORINGBUFFER_GET_COND (buf)))

struct _GstAudioRingBuffer
{
  GstRingBuffer object;

  gboolean running;
  gint queuedseg;

  GCond *cond;
};

struct _GstAudioRingBufferClass
{
  GstRingBufferClass parent_class;
};

static void gst_audioringbuffer_class_init (GstAudioRingBufferClass * klass);
static void gst_audioringbuffer_init (GstAudioRingBuffer * ringbuffer);
static void gst_audioringbuffer_dispose (GObject * object);
static void gst_audioringbuffer_finalize (GObject * object);

static GstRingBufferClass *ring_parent_class = NULL;

static gboolean gst_audioringbuffer_acquire (GstRingBuffer * buf,
    GstRingBufferSpec * spec);
static gboolean gst_audioringbuffer_release (GstRingBuffer * buf);
static gboolean gst_audioringbuffer_play (GstRingBuffer * buf);
static gboolean gst_audioringbuffer_stop (GstRingBuffer * buf);
static guint gst_audioringbuffer_delay (GstRingBuffer * buf);

/* ringbuffer abstract base class */
GType
gst_audioringbuffer_get_type (void)
{
  static GType ringbuffer_type = 0;

  if (!ringbuffer_type) {
    static const GTypeInfo ringbuffer_info = {
      sizeof (GstAudioRingBufferClass),
      NULL,
      NULL,
      (GClassInitFunc) gst_audioringbuffer_class_init,
      NULL,
      NULL,
      sizeof (GstAudioRingBuffer),
      0,
      (GInstanceInitFunc) gst_audioringbuffer_init,
      NULL
    };

    ringbuffer_type =
        g_type_register_static (GST_TYPE_RINGBUFFER, "GstAudioRingBuffer",
        &ringbuffer_info, 0);
  }
  return ringbuffer_type;
}

static void
gst_audioringbuffer_class_init (GstAudioRingBufferClass * klass)
{
  GObjectClass *gobject_class;
  GstObjectClass *gstobject_class;
  GstRingBufferClass *gstringbuffer_class;

  gobject_class = (GObjectClass *) klass;
  gstobject_class = (GstObjectClass *) klass;
  gstringbuffer_class = (GstRingBufferClass *) klass;

  ring_parent_class = g_type_class_ref (GST_TYPE_RINGBUFFER);

  gobject_class->dispose = GST_DEBUG_FUNCPTR (gst_audioringbuffer_dispose);
  gobject_class->finalize = GST_DEBUG_FUNCPTR (gst_audioringbuffer_finalize);

  gstringbuffer_class->acquire =
      GST_DEBUG_FUNCPTR (gst_audioringbuffer_acquire);
  gstringbuffer_class->release =
      GST_DEBUG_FUNCPTR (gst_audioringbuffer_release);
  gstringbuffer_class->play = GST_DEBUG_FUNCPTR (gst_audioringbuffer_play);
  gstringbuffer_class->resume = GST_DEBUG_FUNCPTR (gst_audioringbuffer_play);
  gstringbuffer_class->stop = GST_DEBUG_FUNCPTR (gst_audioringbuffer_stop);

  gstringbuffer_class->delay = GST_DEBUG_FUNCPTR (gst_audioringbuffer_delay);
}

typedef guint (*WriteFunc) (GstAudioSink * sink, gpointer data, guint length);

/* this internal thread does nothing else but write samples to the audio device.
 * It will write each segment in the ringbuffer and will update the play
 * pointer. 
 * The play/stop methods control the thread.
 */
static void
audioringbuffer_thread_func (GstRingBuffer * buf)
{
  GstAudioSink *sink;
  GstAudioSinkClass *csink;
  GstAudioRingBuffer *abuf = GST_AUDIORINGBUFFER (buf);
  WriteFunc writefunc;

  sink = GST_AUDIOSINK (GST_OBJECT_PARENT (buf));
  csink = GST_AUDIOSINK_GET_CLASS (sink);

  GST_DEBUG ("enter thread");

  writefunc = csink->write;
  if (writefunc == NULL)
    goto no_function;

  while (TRUE) {
    gint left, len;
    guint8 *readptr;
    gint readseg;

    if (gst_ringbuffer_prepare_read (buf, &readseg, &readptr, &len)) {
      gint written = 0;

      left = len;
      do {
        GST_DEBUG ("transfer %d bytes from segment %d", left, readseg);
        written = writefunc (sink, readptr + written, left);
        GST_DEBUG ("transfered %d bytes", written);
        if (written < 0 || written > left) {
          GST_WARNING ("error writing data (reason: %s), skipping segment\n",
              strerror (errno));
          break;
        }
        left -= written;
      } while (left > 0);

      /* clear written samples */
      gst_ringbuffer_clear (buf, readseg);

      /* we wrote one segment */
      gst_ringbuffer_advance (buf, 1);
    } else {
      GST_LOCK (abuf);
      if (!abuf->running)
        goto stop_running;
      GST_DEBUG ("signal wait");
      GST_AUDIORINGBUFFER_SIGNAL (buf);
      GST_DEBUG ("wait for action");
      GST_AUDIORINGBUFFER_WAIT (buf);
      GST_DEBUG ("got signal");
      if (!abuf->running)
        goto stop_running;
      GST_DEBUG ("continue running");
      GST_UNLOCK (abuf);
    }
  }
  GST_DEBUG ("exit thread");

  return;

  /* ERROR */
no_function:
  {
    GST_DEBUG ("no write function, exit thread");
    return;
  }
stop_running:
  {
    GST_UNLOCK (abuf);
    GST_DEBUG ("stop running, exit thread");
    return;
  }
}

static void
gst_audioringbuffer_init (GstAudioRingBuffer * ringbuffer)
{
  ringbuffer->running = TRUE;
  ringbuffer->queuedseg = 0;

  ringbuffer->cond = g_cond_new ();
}

static void
gst_audioringbuffer_dispose (GObject * object)
{
  G_OBJECT_CLASS (ring_parent_class)->dispose (object);
}

static void
gst_audioringbuffer_finalize (GObject * object)
{
  G_OBJECT_CLASS (ring_parent_class)->finalize (object);
}

static gboolean
gst_audioringbuffer_acquire (GstRingBuffer * buf, GstRingBufferSpec * spec)
{
  GstAudioSink *sink;
  GstAudioSinkClass *csink;
  gboolean result = FALSE;

  sink = GST_AUDIOSINK (GST_OBJECT_PARENT (buf));
  csink = GST_AUDIOSINK_GET_CLASS (sink);

  if (csink->open)
    result = csink->open (sink, spec);

  if (!result)
    goto could_not_open;

  /* allocate one more segment as we need some headroom */
  spec->segtotal++;

  buf->data = gst_buffer_new_and_alloc (spec->segtotal * spec->segsize);
  memset (GST_BUFFER_DATA (buf), 0, GST_BUFFER_SIZE (buf));

  sink->thread =
      g_thread_create ((GThreadFunc) audioringbuffer_thread_func, buf, TRUE,
      NULL);
  GST_AUDIORINGBUFFER_WAIT (buf);

  return result;

could_not_open:
  {
    return FALSE;
  }
}

/* function is called with LOCK */
static gboolean
gst_audioringbuffer_release (GstRingBuffer * buf)
{
  GstAudioSink *sink;
  GstAudioSinkClass *csink;
  GstAudioRingBuffer *abuf;
  gboolean result = FALSE;

  sink = GST_AUDIOSINK (GST_OBJECT_PARENT (buf));
  csink = GST_AUDIOSINK_GET_CLASS (sink);
  abuf = GST_AUDIORINGBUFFER (buf);

  abuf->running = FALSE;
  GST_AUDIORINGBUFFER_SIGNAL (buf);
  GST_UNLOCK (buf);

  /* join the thread */
  g_thread_join (sink->thread);

  GST_LOCK (buf);

  /* free the buffer */
  gst_buffer_unref (buf->data);

  if (csink->close)
    result = csink->close (sink);

  return result;
}

static gboolean
gst_audioringbuffer_play (GstRingBuffer * buf)
{
  GstAudioSink *sink;

  sink = GST_AUDIOSINK (GST_OBJECT_PARENT (buf));

  GST_DEBUG ("play, sending signal");
  GST_AUDIORINGBUFFER_SIGNAL (buf);

  return TRUE;
}

static gboolean
gst_audioringbuffer_stop (GstRingBuffer * buf)
{
  GstAudioSink *sink;
  GstAudioSinkClass *csink;

  sink = GST_AUDIOSINK (GST_OBJECT_PARENT (buf));
  csink = GST_AUDIOSINK_GET_CLASS (sink);

  /* unblock any pending writes to the audio device */
  if (csink->reset) {
    GST_DEBUG ("reset...");
    csink->reset (sink);
    GST_DEBUG ("reset done");
  }

  GST_DEBUG ("stop, waiting...");
  GST_AUDIORINGBUFFER_WAIT (buf);
  GST_DEBUG ("stoped");

  return TRUE;
}

static guint
gst_audioringbuffer_delay (GstRingBuffer * buf)
{
  GstAudioSink *sink;
  GstAudioSinkClass *csink;
  guint res = 0;

  sink = GST_AUDIOSINK (GST_OBJECT_PARENT (buf));
  csink = GST_AUDIOSINK_GET_CLASS (sink);

  if (csink->delay)
    res = csink->delay (sink);

  return res;
}

/* AudioSink signals and args */
enum
{
  /* FILL ME */
  LAST_SIGNAL
};

enum
{
  ARG_0,
};

#define _do_init(bla) \
    GST_DEBUG_CATEGORY_INIT (gst_audiosink_debug, "audiosink", 0, "audiosink element");

GST_BOILERPLATE_FULL (GstAudioSink, gst_audiosink, GstBaseAudioSink,
    GST_TYPE_BASEAUDIOSINK, _do_init);

static GstRingBuffer *gst_audiosink_create_ringbuffer (GstBaseAudioSink * sink);

static void
gst_audiosink_base_init (gpointer g_class)
{
}

static void
gst_audiosink_class_init (GstAudioSinkClass * klass)
{
  GObjectClass *gobject_class;
  GstElementClass *gstelement_class;
  GstBaseSinkClass *gstbasesink_class;
  GstBaseAudioSinkClass *gstbaseaudiosink_class;

  gobject_class = (GObjectClass *) klass;
  gstelement_class = (GstElementClass *) klass;
  gstbasesink_class = (GstBaseSinkClass *) klass;
  gstbaseaudiosink_class = (GstBaseAudioSinkClass *) klass;

  gstbaseaudiosink_class->create_ringbuffer =
      GST_DEBUG_FUNCPTR (gst_audiosink_create_ringbuffer);
}

static void
gst_audiosink_init (GstAudioSink * audiosink)
{
}

static GstRingBuffer *
gst_audiosink_create_ringbuffer (GstBaseAudioSink * sink)
{
  GstRingBuffer *buffer;

  GST_DEBUG ("creating ringbuffer");
  buffer = g_object_new (GST_TYPE_AUDIORINGBUFFER, NULL);
  GST_DEBUG ("created ringbuffer @%p", buffer);

  return buffer;
}