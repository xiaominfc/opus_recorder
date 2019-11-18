# opus_recorder

移植过来用于录制播放opus格式音频的flutter插件


## run

```

cd ${project_path}/example 
flutter run

```

## 引用


### 必要权限android
```
 <uses-permission android:name="android.permission.RECORD_AUDIO"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"></uses-permission>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"></uses-permission>

```

### 必要权限ios

```
<key>NSMicrophoneUsageDescription</key>
	<string>请求使用麦克风</string>
```


### ps

android上引用时会报个资源引用的冲突跟着报错改过来就行具体可以对比看example的改动
