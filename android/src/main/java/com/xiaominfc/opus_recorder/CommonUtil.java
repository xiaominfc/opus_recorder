package com.xiaominfc.opus_recorder;

import android.os.Environment;
import java.io.File;

import io.flutter.Log;

public class CommonUtil {

    public static final int FILE_SAVE_TYPE_AUDIO = 0X00014;

    /**
     * @Description 判断存储卡是否存在
     * @return
     */
    public static boolean checkSDCard() {
        if (android.os.Environment.getExternalStorageState().equals(
                android.os.Environment.MEDIA_MOUNTED)) {
            return true;
        }

        return false;
    }


    public static String getAudioSavePath(int userId) {
        String path = getSavePath(FILE_SAVE_TYPE_AUDIO) + userId  + "_" + System.currentTimeMillis() + ".audio";
        File file = new File(path);
        File parent = file.getParentFile();
        if (parent != null && !parent.exists()) {
            parent.mkdirs();
        }
        return path;
    }

    public static String getSavePath(int type) {
        String path;
        String folder = "audio";
        if (CommonUtil.checkSDCard()) {
            path = Environment.getExternalStorageDirectory().toString()
                    + File.separator + "MGJ-IM" + File.separator + folder
                    + File.separator;

        } else {
            path = Environment.getDataDirectory().toString() + File.separator
                    + "MGJ-IM" + File.separator + folder + File.separator;
        }
        return path;
    }




}
