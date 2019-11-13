import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opus_recorder/opus_recorder.dart';

void main() {
  const MethodChannel channel = MethodChannel('opus_recorder');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await OpusRecorder.platformVersion, '42');
  });
}
