//
//  OpusCodec.m
//  TeamTalk
//
//  Created by xiaominfc on 29/08/2017.
//  Copyright © 2017 MoguIM. All rights reserved.
//



#import "OpusCodec.h"
#include "opus.h"

#define FRAME_SIZE 960
#define SAMPLE_RATE 16000
#define CHANNELS 1
#define APPLICATION OPUS_APPLICATION_AUDIO
#define BITRATE 64000
#define MAX_FRAME_SIZE 6*960
#define MAX_PACKET_SIZE (3*1276)

@interface OpusCodec() {
    OpusEncoder *encoder;
    OpusDecoder *decoder;
}

@end

@implementation OpusCodec

-(instancetype)init {
    self = [super init];
    if(self) {
        [self initCoder];
    }
    return self;
}

-(void) initCoder
{
    
    [self initEncoder];
    int err;
    decoder = opus_decoder_create(SAMPLE_RATE, CHANNELS, &err);
    
    if (err<0)
    {
        NSLog(@"create decoder failed");
     //   fprintf(stderr, "failed to create decoder: %s\n", opus_strerror(err));
     //   return EXIT_FAILURE;
    }
    
    //err = opus_decoder_init(decoder, SAMPLE_RATE,CHANNELS);
//    if(OPUS_OK != err) {
//        NSLog(@"opus_decoder_init failed");
//    }
    
}

-(void) initEncoder
{
    int err;
    encoder = opus_encoder_create(SAMPLE_RATE, CHANNELS, APPLICATION, &err);
    if (err<0)
    {
        NSLog(@"create encoder failed");
        //   fprintf(stderr, "failed to create an encoder: %s\n", opus_strerror(err));
        //   return EXIT_FAILURE;
    }
    err = opus_encoder_ctl(encoder, OPUS_SET_BITRATE(BITRATE));
#ifdef OPUS_SET_LSB_DEPTH
    err = opus_encoder_ctl(encoder, OPUS_SET_LSB_DEPTH(16));
    if (err != OPUS_OK) {
        
    }
#endif
    
    opus_int32 lookahead;
    err = opus_encoder_ctl(encoder, OPUS_GET_LOOKAHEAD(&lookahead));
    if (err != OPUS_OK) {
        
    }
}


- (void)open:(int)quality
{
    
}



- (NSData *)encode:(short *)pcmBuffer length:(int)lengthOfShorts
{
    unsigned char cbits[MAX_PACKET_SIZE];
    int nbBytes = opus_encode(encoder, pcmBuffer, lengthOfShorts, cbits, MAX_PACKET_SIZE);
    NSMutableData *decodedData = [NSMutableData dataWithCapacity:28];
    [decodedData appendBytes:cbits length:nbBytes];
    return decodedData;
}

-(int)decode:(Byte *)encodedBytes length:(int)lengthOfBytes output:(short *)decoded
{
    int frame_size = opus_decode(decoder, (const unsigned char *)encodedBytes, lengthOfBytes, decoded, MAX_FRAME_SIZE, 0);
    //NSLog(@"frame_size:%d",frame_size);
    return frame_size;
}


- (void)close
{
    opus_encoder_destroy(encoder);
    opus_decoder_destroy(decoder);
}


@end
