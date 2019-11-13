
package com.xiaominfc.opus_recorder;

import android.content.Context;
import android.media.AudioManager;
import top.oply.opuslib.OpusPlayer;

public class AudioPlayerHandler{
    private String currentPlayPath = null;
    private static AudioPlayerHandler instance = null;

    public static  AudioPlayerHandler getInstance() {
        if (null == instance) {
            synchronized(AudioPlayerHandler.class){
                instance = new AudioPlayerHandler();
            }
        }
        return instance;
    }


    //语音播放的模式
    public  void setAudioMode(int mode,Context ctx) {
        if (mode != AudioManager.MODE_NORMAL && mode != AudioManager.MODE_IN_CALL) {
            return;
        }
        AudioManager audioManager = (AudioManager) ctx.getSystemService(Context.AUDIO_SERVICE);
        audioManager.setMode(mode);
    }

    /**messagePop调用*/
    public int getAudioMode(Context ctx) {
        AudioManager audioManager = (AudioManager) ctx.getSystemService(Context.AUDIO_SERVICE);
        return audioManager.getMode();
    }

    public void clear(){
        if (isPlaying()){
            stopPlayer();
        }
        instance = null;
    }


    private AudioPlayerHandler() {
    }

    public interface AudioListener{
        public void onStop();
    }

    private AudioListener audioListener;

    public void setAudioListener(AudioListener audioListener) {
        this.audioListener = audioListener;
    }

    private void stopAnimation(){
        if(audioListener!=null){
            audioListener.onStop();
        }
    }

    public void stopPlayer() {
        try {
            OpusPlayer.getInstance().stop();
        } catch (Exception e) {
        }finally {
            stopAnimation();
        }
    }

    public boolean isPlaying() {
        return null != th;
    }

    public void startPlay(String filePath) {
        this.currentPlayPath = filePath;
        try {
            OpusPlayer.getInstance().play(filePath);

        } catch (Exception e) {
            stopAnimation();
        }
    }

    public String getCurrentPlayPath() {
        return currentPlayPath;
    }
}
