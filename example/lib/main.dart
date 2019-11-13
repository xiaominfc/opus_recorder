import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:opus_recorder/opus_recorder.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class RecordInfo {
  final String filePath;
  final double time;

  RecordInfo(this.filePath,this.time);

}

class _MyAppState extends State<MyApp> implements OpusRecorderInf{
  String _platformVersion = 'Unknown';

  List<RecordInfo> infos = List();

  @override
  void initState() {
    super.initState();
    OpusRecorder().registeInf(this);
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await OpusRecorder.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }
  
  void OnRecordFinished(String filePath, double time){
    infos.add(RecordInfo(filePath,time));
    setState((){});
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: ListView.builder(
                itemCount: infos.length,
                itemBuilder: (BuildContext context, int index) {
                  RecordInfo info = infos[index];
                  return GestureDetector(
                      child:ListTile(title: Text(info.filePath)),
                      onTap:(){
                        OpusRecorder.playFile(info.filePath);
                      });
                }
            ),
        ),
        floatingActionButton:GestureDetector(
          onLongPressStart:(LongPressStartDetails details){
            print("onLongPressStart");
            OpusRecorder.startRecord();
          },
          onLongPressEnd:(LongPressEndDetails details){
            print("onLongPressEnd");
            OpusRecorder.stopRecord();
          },
          child:FloatingActionButton(child:Icon(Icons.add))
        )
      ),
    );
  }
}
