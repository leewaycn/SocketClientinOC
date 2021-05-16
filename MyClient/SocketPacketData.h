//
//  SocketPacketData.h
//  MyClient
//
//  Created by leemac on 2021/5/16.
//  Copyright © 2021 gongwenkai. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#import "SocketByteBuffer.h"

 
@interface SocketPacketHead : NSObject
@property (nonatomic, assign) int magic;
@property (nonatomic, assign) int len;
@property (nonatomic, assign) int op;
@property (nonatomic, assign) int param;
@property (nonatomic, assign) BOOL on;


-(void)Deserialize:(SocketByteBuffer *)buf;


@end

@interface SocketPacketData : NSObject
{
    
    @public
    int m_row;
   int m_col;
    NSMutableDictionary *m_map;
    NSMutableArray *m_array;
    NSString *INVALID_STRING_VAL;
    
    
    @private
    BOOL m_bResult;
    int m_magic;
    int m_len;
    int m_op;
    int m_param;
    
}



@property (nonatomic, strong) NSMutableArray<NSData*>  * m_byte_buf;



-(int)getM_magic;
-(void)setM_magic:(int)magic;
-(int)getM_param;
-(void)setM_param:(int)param;

-(void)PacketData:(int)op;

-(BOOL)IsPacketValid;

-(void)setOp:(int)op;

-(int)getOp;
-(void)setParam:(int)param;
-(int)getParam;
-(void)MakeTestPacket:(int)param;

-(void)MakeLoginPacket:(int)param;
-(void)MakeQueryCommandPacket:(int)param;
-(void)ShowPacket;
-(void)setPacketHeadLen:(int)len;
-(void)SerializeHead:(SocketByteBuffer*)buf;
-(void)DeserializeHead:(SocketPacketHead*)packet_head;
-(void)SerializeBody:(SocketByteBuffer*)buf;
-(void)DeserializeBody:(SocketByteBuffer*)buf;

-(void)addMapElement:(NSString*)key :(NSString*)val;
-(NSString*)getMapString:(NSString*)key;
-(BOOL)ContainKey:(NSString*)key;
-(int)getMapSize;
-(void)AddByteArray:(Byte*)c;
-(int)GetByteArrayCount;
-(Byte*)GetByteArray:(int)pos;
-(int)getRow;
-(int)getCol;
-(void)setCol:(int)col;
-(int)AddRow;
-(int)setArrayValue:(int)row :(int)col val:(NSString*)val;
-(BOOL)IsPosValid:(int)row : (int)col;
-(int)CalculPos:(int)row : (int)col;
-(BOOL)IsDataValid:(SocketByteBuffer*)buf;



@end

 
