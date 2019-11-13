
package com.xiaominfc.opus_recorder;

import android.media.AudioFormat;
import android.media.AudioRecord;
import android.os.Message;
import top.oply.opuslib.OpusRecorder;

public class AudioRecordHandler implements Runnable {

    private volatile boolean isRecording;
    private final Object mutex = new Object();
    private static final int frequency = 8000;
    private static final int audioEncoding = AudioFormat.ENCODING_PCM_16BIT;
    private static final float MAX_SOUND_RECORD_TIME = 60.0f;
    public static int packagesize = 160;// 320
    private String fileName = null;
    private float recordTime = 0;
    private long startTime = 0;
    private long endTime = 0;
    private long maxVolumeStart = 0;
    private long maxVolumeEnd = 0;
    private static AudioRecord recordInstance = null;
    private OpusRecorder opusRecorder;

    public AudioRecordHandler(String fileName) {
        super();
        this.fileName = fileName;
    }

    public void run() {
        try {
            synchronized (mutex) {
                while (!this.isRecording) {
                    try {
                        mutex.wait();
                    } catch (InterruptedException e) {
                        throw new IllegalStateException("Wait() interrupted!", e);
                    }
                }
            }
            try {


                OpusRecorder.getInstance().startRecording(this.fileName);
                recordTime = 0;
                startTime = System.currentTimeMillis();
                maxVolumeStart = System.currentTimeMillis();
                while (this.isRecording) {
                    endTime = System.currentTimeMillis();
                    recordTime = (float) ((endTime - startTime) / 1000.0f);
                    if (recordTime >= MAX_SOUND_RECORD_TIME) {
                           //MessageActivity.getUiHandler().sendEmptyMessage(
                           //     HandlerConstant.RECORD_AUDIO_TOO_LONG);
                        break;
                    }
                    maxVolumeEnd = System.currentTimeMillis();
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                OpusRecorder.getInstance().stopRecording();
                if (recordInstance != null) {
                    recordInstance.stop();
                    recordInstance.release();
                    recordInstance = null;
                } else {
                }
            }
        }catch (Exception e){

        }

    }

    private void setMaxVolume(short[] buffer, int readLen) {
        try {
            if (maxVolumeEnd - maxVolumeStart < 100) {
                return;
            }
            maxVolumeStart = maxVolumeEnd;
            int max = 0;
            for (int i = 0; i < readLen; i++) {
                if (Math.abs(buffer[i]) > max) {
                    max = Math.abs(buffer[i]);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public float getRecordTime() {
        return recordTime;
    }

    public void setRecordTime(float len) {
        recordTime = len;
    }

    public void setRecording(boolean isRec) {
        synchronized (mutex) {
            this.isRecording = isRec;
            if (this.isRecording) {
                mutex.notify();
            }
        }
    }

    public boolean isRecording() {
        synchronized (mutex) {
            return isRecording;
        }
    }
}
