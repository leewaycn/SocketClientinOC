//
//  SocketByteBuffer.h
//  MyClient
//
//  Created by leemac on 2021/5/16.
//  Copyright © 2021 gongwenkai. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>
NS_ASSUME_NONNULL_BEGIN

//ByteBuffer
static int START_POS = 0;
static int BUF_LEN = 1024*10*10;

//static NSString *SOCKET_ENCODING = NSUTF8StringEncoding;

@interface SocketByteBuffer : NSObject


-(void)initWithBuf_len:(int)buf_len;

-(void)isNULL;

-(void)putArray:(Byte[]) bytes len:(int)len;

-(BOOL)CheckPutWithLen:(int)len;

-(void)sendBySocket:(int)socket;


-(Byte*)getBytes;
-(int)getBufSize;

-(int)getMaxSize;
-(int)getWritePos;
-(int)getReadPos;

-(void)clean;

-(void)ResetReadPos;

-(int)putShort:(short)val;
-(short)getShort;

-(int)putInt:(int)val;
-(int)getInt;
-(int)putLong:(long)x;
-(long)getLong;

-(int)putChar:(char)ch;
-(char)getChar;
-(int)putFloat:(float)f;
-(float)getFloat;
-(int)putDouble:(double)val;
-(double)getDouble;
-(int)putString:(NSString*)str;
-(NSString*)getString;

-(void)putByteArray:(Byte*)s len:(NSInteger)len;
-(Byte *)getByteArray;


-(int)CheckWriteValid:(int)len;
-(int)CheckReadValid:(int)len;




@end

NS_ASSUME_NONNULL_END
