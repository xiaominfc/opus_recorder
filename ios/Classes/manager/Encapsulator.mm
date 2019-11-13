//
//  Encapsulator.m
//  OggSpeex
//
//  Created by Jiang Chuncheng on 6/25/13.
//  Copyright (c) 2013 Sense Force. All rights reserved.
//

#import "Encapsulator.h"
#import "OpusCodec.h"
#include "opusaudio.h"
#define NOTIFICATION_ENCAPSULTING_OVER @"EncapsulatingOver"

@implementation Encapsulator

@synthesize moreDataInputing,isCanceled;

@synthesize mFileName;
@synthesize delegete;


+ (NSString *)defaultFileName {
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *voiceDirectory = [documentsDirectory stringByAppendingPathComponent:@"voice"];
    if ( ! [[NSFileManager defaultManager] fileExistsAtPath:voiceDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:voiceDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return [voiceDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%f.audio", [[NSDate date] timeIntervalSince1970]]];
}

- (id)initWithFileName:(NSString *)filename {
    if (self = [super init]) {
        mFileName = [NSString stringWithString:filename];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filename]) {
            [fileManager removeItemAtPath:filename error:nil];
        }
        bufferData = [NSMutableData data];
        tempData = [NSMutableData data];
        pcmDatas = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(encapsulatingOver:) name:NOTIFICATION_ENCAPSULTING_OVER object:nil];
 //       int result = startRecording([filename cString]);
        operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)resetWithFileName:(NSString *)filename {
    for(NSOperation *operation in [operationQueue operations]) {
        [operation cancel];
    }
    mFileName = [NSString stringWithString:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filename]) {
        [fileManager removeItemAtPath:filename error:nil];
    }
    [bufferData setLength:0];
    [tempData setLength:0];
    [pcmDatas removeAllObjects];
}

- (NSMutableData *)getBufferData {
    return bufferData;
}

- (NSMutableArray *)getPCMDatas {
    @synchronized(pcmDatas) {
        return pcmDatas;
    }
}

- (void)prepareForEncapsulating {
    
    stopRecording();
    int result = startRecording([mFileName cString]);
    if(result >0) {
        
    }
    self.moreDataInputing = YES;
    self.isCanceled = NO;
    encapsulationOperation = [[EncapsulatingOperation alloc] initWithParent:self];
    if (operationQueue) {
        [operationQueue addOperation:encapsulationOperation];
    }
}

- (void)inputPCMDataFromBuffer:(Byte *)buffer size:(UInt32)dataSize {

    if (!self.moreDataInputing) {
        return;
    }
    
    int packetSize = FRAME_SIZE * 2;
    @synchronized(pcmDatas) {
        [tempData appendBytes:buffer length:dataSize];
        while ([tempData length] >= packetSize) {
            @autoreleasepool {
                NSData *pcmData = [NSData dataWithBytes:[tempData bytes] length:packetSize];
                [pcmDatas addObject:pcmData];
                Byte *dataPtr = (Byte *)[tempData bytes];
                dataPtr += packetSize;
                tempData = [NSMutableData dataWithBytesNoCopy:dataPtr length:[tempData length] - packetSize freeWhenDone:NO];

            }
        }
    }
}

- (void)stopEncapsulating:(BOOL)forceCancel {
    self.moreDataInputing = NO;
    if (!self.isCanceled) {
        self.isCanceled = forceCancel;
    }
}

- (void)encapsulatingOver:(NSNotification *)notification {
    if (self.delegete) {
        [self.delegete encapsulatingOver];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@implementation EncapsulatingOperation

@synthesize mParent;

//不停从bufferData中获取数据构建paket并且修改相关计数器
- (void)main {
    while ( ! self.mParent.isCanceled) {
        if ([[self.mParent getPCMDatas] count] > 0) {
            NSData *pcmData = [[self.mParent getPCMDatas] objectAtIndex:0];
            writeFrame((uint8_t *)[pcmData bytes], [pcmData length]);
            if ([[self.mParent getPCMDatas] count] > 0)
            {
                [[self.mParent getPCMDatas] removeObjectAtIndex:0];
            }
        }
        else {
            [NSThread sleepForTimeInterval:0.02];
            if ( ! [self.mParent moreDataInputing]) {
                break;
            }
        }

    }
    if ( ! [self.mParent isCanceled]) {
        stopRecording();
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ENCAPSULTING_OVER object:self userInfo:nil];
    }
}

//初始化NSOperation
- (id)initWithParent:(Encapsulator *)parent {
    if (self = [super init]) {
        self.mParent = parent;
    }
    return self;
}




@end
