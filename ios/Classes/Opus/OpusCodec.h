//
//  OpusCodec.h
//  TeamTalk
//
//  Created by xiaominfc on 29/08/2017.
//  Copyright © 2017 MoguIM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpusCodec : NSObject

- (void)open:(int)quality;
- (NSData *)encode:(short *)pcmBuffer length:(int)lengthOfShorts;
- (int)decode:(Byte *)encodedBytes length:(int)lengthOfBytes output:(short *)decoded;
- (void)close;

@end
