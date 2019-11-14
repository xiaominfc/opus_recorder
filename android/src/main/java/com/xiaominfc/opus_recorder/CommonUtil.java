package com.xiaominfc.opus_recorder;

import android.os.Environment;
import java.io.File;

public class CommonUtil {

	final static String PARENTDIRNAME = "OPUS_RECORD";

	public static boolean checkSDCard() {
		if (android.os.Environment.getExternalStorageState().equals(android.os.Environment.MEDIA_MOUNTED)) {
			return true;
		}
		return false;
	}

	public static String getAudioSavePath(int idNum) {
		String path = getSavePath() + idNum  + "_" + System.currentTimeMillis() + ".audio";
		File file = new File(path);
		File parent = file.getParentFile();
		if (parent != null && !parent.exists()) {
			parent.mkdirs();
		}
		return path;
	}

	public static String getSavePath() {
		String path;
		String subFolder = "audios";
		if (CommonUtil.checkSDCard()) {
			path = Environment.getExternalStorageDirectory().toString()
				+ File.separator + PARENTDIRNAME  + File.separator + subFolder
				+ File.separator;

		} else {
			path = Environment.getDataDirectory().toString() + File.separator
				+ PARENTDIRNAME + File.separator + subFolder + File.separator;
		}
		return path;
	}
}
