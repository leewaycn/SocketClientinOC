//
//  SocketPacketData.m
//  MyClient
//
//  Created by leemac on 2021/5/16.
//  Copyright © 2021 gongwenkai. All rights reserved.
//

#import "SocketPacketData.h"

static int HEAD_LEN = 4+4+4+4;

@implementation SocketPacketHead

-(id)init{
    self = [super init];
    if (self) {
        self.on = false;
    }
    return self;
}

-(void)Deserialize:(SocketByteBuffer *)buf{
    _magic = [buf getInt];// buf.getInt();
    _len = [buf getInt];// buf.getInt();
    _op = [buf getInt];//buf.getInt();
    _param = [buf getInt];//buf.getInt();
}
@end



@implementation SocketPacketData



-(int)getM_magic{
    return m_magic;
}
-(void)setM_magic:(int)magic{
    m_magic = magic;
}
-(int)getM_param{
    return m_param;
}
-(void)setM_param:(int)param{
    m_param = param;
}

-(void)PacketData:(int)op{
    m_op = op;
            m_row = m_col = 0;
            m_map = new HashMap<String,String>();
            m_array = new Vector<String>();
            INVALID_STRING_VAL = new String("");
            m_byte_buf = new ArrayList<byte[]>();
}

-(BOOL)IsPacketValid;

-(void)setOp:(int)op;

-(int)getOp;
-(void)setParam:(int)param;
-(int)getParam;
-(void)MakeTestPacket:(int)param;

-(void)MakeQueryCommandPacket:(int)param;
-(void)ShowPacket;
-(void)setPacketHeadLen:(int)len;
-(void)SerializeHead:(SocketByteBuffer*)buf;
-(void)DeserializeHead:(SocketPacketHead*)packet_head;
-(void)SerializeBody:(SocketByteBuffer*)buf;
-(void)DeserializeBody:(SocketByteBuffer*)buf;
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
