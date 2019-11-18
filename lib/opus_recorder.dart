import 'dart:async';

import 'package:flutter/services.dart';


abstract class OpusRecorderInf {
  void OnRecordFinished(String filePath, double time);
}


class OpusRecorder {

  static final int MODE_NORMAL = 1;
  static final int MODE_IN_CALL = 2;
 
  static const MethodChannel _channel =
      const MethodChannel('opus_recorder');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future startRecord() async {
    return _channel.invokeMethod('startRecord');
  }

  static Future stopRecord() async {
    return _channel.invokeMethod('stopRecord');
  }

  static Future playFile(String filePath) async {
    return _channel.invokeMethod('playFile',[filePath]);
  }

  static Future playFileWithMode(String filePath, int mode) {
    // mode maybe MODE_NORMAL or MODE_IN_CALL 
    return _channel.invokeMethod('playFileWithMode',[filePath,mode]);
  }

  Future<dynamic> _handelCall(MethodCall methodCall) {
    print(methodCall.toString());
    if(methodCall.method == "finishedRecord") {
      if(currentInf != null) {
        currentInf.OnRecordFinished(methodCall.arguments[0],methodCall.arguments[1]);
      }
    }
    return Future.value(methodCall.method);
  }
  

  factory OpusRecorder() =>_getInstance();

  static OpusRecorder get instance => _getInstance();
  static OpusRecorder _instance;

  OpusRecorder._internal(){
     _channel.setMethodCallHandler(_handelCall);
  }

  OpusRecorderInf currentInf;
  void registeInf(OpusRecorderInf currentInf) {
    this.currentInf = currentInf;
  }

  static OpusRecorder _getInstance() {
    if(_instance == null) {
      _instance = OpusRecorder._internal();
    }
    return _instance;
  }

}
