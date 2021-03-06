#import "OpusRecorderPlugin.h"


#define MODE_NORMAL 1
#define MODE_IN_CALL 2


@interface OpusRecorderPlugin()
@property (nonatomic, strong) FlutterMethodChannel* channel;
@end

@implementation OpusRecorderPlugin

//@synthesize channel;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"opus_recorder"
            binaryMessenger:[registrar messenger]];
  OpusRecorderPlugin* instance = [[OpusRecorderPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
  instance.channel = channel;
  [RecorderManager sharedManager].delegate = instance;
  
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }else if([@"startRecord" isEqualToString:call.method]) {
      [[RecorderManager sharedManager] startRecording];
  }else if([@"stopRecord" isEqualToString:call.method]) {
      [[RecorderManager sharedManager] stopRecording];
  }else if([@"playFile" isEqualToString:call.method]) {
      NSLog(@"playFile:%@",call.arguments[0]);
      //[[PlayerManager sharedManager] playingFileName:call.arguments[0]];
      [[PlayerManager sharedManager]playAudioWithFileName:call.arguments[0] delegate:self];
  }else if([@"playFileWithMode" isEqualToString:call.method]) {
      NSString *path = call.arguments[0];
      int mode = [call.arguments[1] intValue];
      if(mode == MODE_IN_CALL) {
          [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
      }else {
          [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
      }
      [[PlayerManager sharedManager]playAudioWithFileName:path delegate:self];
  }
  else {
    result(FlutterMethodNotImplemented);
  }
}

#pragma mark RecordingDelegate
- (void)recordingFinishedWithFileName:(NSString *)filePath time:(NSTimeInterval)interval {
    NSLog(filePath);
    [_channel invokeMethod:@"finishedRecord" arguments:@[filePath, [NSNumber numberWithDouble:interval] ]];
}

- (void)playingStoped {
    NSLog(@"playingStoped");
}

@end
