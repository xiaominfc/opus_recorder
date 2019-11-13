//
//  Encapsulator.h
//  OggSpeex
//
//  Created by Jiang Chuncheng on 6/25/13.
//  Copyright (c) 2013 Sense Force. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "opusfile.h"

#define FRAME_SIZE 960 // PCM音频8khz*20ms -> 8000*0.02=160

@class EncapsulatingOperation;

@protocol EncapsulatingDelegate <NSObject>

- (void)encapsulatingOver;

@end

@interface Encapsulator : NSObject {
    
    NSMutableData *bufferData;  //用于ogg文件输出
    NSMutableData *tempData;    //用于输入的pcm切割剩余
    NSMutableArray *pcmDatas;
    NSOperationQueue *operationQueue;
    EncapsulatingOperation *encapsulationOperation;
    NSString *mFileName;
    BOOL moreDataInputing, isCanceled; //moreDataInputing是否继续封装；isCanceled，是否强制停止封装
    id<EncapsulatingDelegate> delegate;
    
}


@property (assign) BOOL moreDataInputing, isCanceled;
@property (readonly, retain) NSString *mFileName;

@property (nonatomic, weak) id<EncapsulatingDelegate> delegete;


+ (NSString *)defaultFileName;

//生成对象
- (id)initWithFileName:(NSString *)filename;

- (void)resetWithFileName:(NSString *)filename;

- (NSMutableData *)getBufferData;

- (NSMutableArray *)getPCMDatas;


//输入新PCM数据。注意数据同步
- (void)inputPCMDataFromBuffer:(Byte *)buffer size:(UInt32)dataSize;

//停止封装。是否强制结束未完成的封装
- (void)stopEncapsulating:(BOOL)forceCancel;

//为即将开始的封装做准备，包括写入ogg的头
- (void)prepareForEncapsulating;

@end

@interface EncapsulatingOperation : NSOperation {
    Encapsulator *mParent;
}

@property (nonatomic, retain) Encapsulator *mParent;

//初始化NSOperation
- (id)initWithParent:(Encapsulator *)parent;


@end
