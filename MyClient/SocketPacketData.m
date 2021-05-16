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
    m_map = [NSMutableDictionary dictionary];//  new HashMap<String,String>();
    m_array = [NSMutableArray array];// new Vector<String>();
    INVALID_STRING_VAL =@"";// new String("");
    self.m_byte_buf = [NSMutableArray array ] ;//new ArrayList<byte[]>();
}

-(BOOL)IsPacketValid{
    return m_bResult;;
}

-(void)setOp:(int)op{
    m_op  = op;
}

-(int)getOp{
    return m_op;
}
-(void)setParam:(int)param{
    m_param = param;
}
-(int)getParam{
    return m_param;
}
-(void)MakeTestPacket:(int)param{
    m_param= param;
    [self addMapElement:@"adfasdf" :@"asdfsadfsadfsdf"];
    [self addMapElement:@"xiaopang" :@"xiao pang"];
    [self addMapElement:@"feifei" :@"feifei"];
    [self setCol:3];
    [self AddRow];
    [self setArrayValue:0 :0 val:@"xiao pang"];
    [self setArrayValue:0 :1 val:@"feifei"];
    [self setArrayValue:0 :2 val:@"ieo"];

    [self AddRow];
    
    [self setArrayValue:1 :0 val:@"project"];
    [self setArrayValue:1 :1 val:@"automation"];
    [self setArrayValue:1 :2 val:@"testpacket"];
    
}

-(void)MakeLoginPacket:(int)param{
    m_param = param;
    [self addMapElement:@"username" :@"58" ];
    [self addMapElement:@"pwd" :@"5dd8" ];
    [self   setCol:1];
    [self AddRow];
    [self setArrayValue:0 :0 val:@"请求验证登录"];
}
-(void)MakeQueryCommandPacket:(int)param{
    m_param = param;
    [self addMapElement:@"rid" :@"103" ];
    [self addMapElement:@"days" :@"30" ];
    [self addMapElement:@"status" :@"TIMEOUT" ];
    [self addMapElement:@"uid" :@"123" ];

    [self   setCol:1];
    [self AddRow];
    [self setArrayValue:0 :0 val:@"请求指令数据"];
}
-(void)ShowPacket{
    NSLog(@"magic+=%d",m_magic);
    NSLog(@"m_len+=%d",m_len);
    NSLog(@"m_op+=%d",m_op);
    NSLog(@"m_param+=%d",m_param);
    NSLog(@"dic = %@",m_map);
    NSLog(@"dim_arrayc = %@",m_array);
}
-(void)setPacketHeadLen:(int)len{
    m_len = len;
}
-(void)SerializeHead:(SocketByteBuffer*)buf{
    [buf putInt:m_magic];
    [buf putInt:m_len];
    [buf putInt:m_op];
    [buf putInt:m_param];
    
}
-(void)DeserializeHead:(SocketPacketHead*)packet_head{
    m_magic = packet_head.magic;
    m_len = packet_head.len;
    m_op = packet_head.op;
    m_param = packet_head.param;
    
}
-(void)SerializeBody:(SocketByteBuffer*)buf{
    
    int map_size  = (int)m_map.allKeys.count;
    [buf putInt:map_size];
    if (map_size>0) {
        for (NSString *key in m_map.allKeys) {
            
            NSString *value = m_map[key];
            
            [buf putString:key];
            [buf putString:value];
        }
    }
    
    [buf putInt:m_row];
    [buf putInt:m_col];
    if (m_row>0 && m_col > 0) {
        for (int i = 0; i< m_row; i++) {
            for (int j = 0 ; j<m_col; j++) {
                [buf putString:m_array[[self CalculPos:i :j]]];
            }
        }
    }
    
    [buf putInt:(int)self.m_byte_buf.count];
    for (int i = 0; i< self.m_byte_buf.count; i++) {
        NSData *data = self.m_byte_buf[i];
        Byte *b = (Byte*)[data bytes];
        
        [buf putByteArray:b len:data.length];
        
    }
    
    
}
-(void)DeserializeBody:(SocketByteBuffer*)buf{
 
    int map_size = buf.getInt;
    if (map_size>0) {
        for (int i = 0; i< map_size; i++) {
            NSString *key = buf.getString;
            NSString *value =buf.getString;
            [m_map setValue:value forKey:key];
        }
    }
    
    m_row = buf.getInt;
    m_col = buf.getInt;
    
    
    if (m_row >0 && m_col > 0) {
        for (int i = 0; i< m_row; i++) {
            for (int j = 0; j< m_col; j++) {
                NSString *val = buf.getString;
                [m_array addObject:val];
            }
        }
    }else{
        m_row = m_col = 0;
    }
    
    int buf_array_size = buf.getInt;
    for (int i = 0; i< buf_array_size; i++) {
        Byte *bute =  buf.getByteArray;
        NSData *data = [NSData dataWithBytes:bute length:sizeof(bute)];//Byte 2 Data
        
        [self.m_byte_buf addObject:data];
        
    }
    
}

/////////////////关于map的操作/////////////////////////////////////////////////////
-(void)addMapElement:(NSString*)key :(NSString*)val{
    
    [m_map setValue:val forKey:key];
}

-(NSString*)getMapString:(NSString*)key{
    return [m_map valueForKey:key];
}
-(BOOL)ContainKey:(NSString*)key{
    return [[m_map allKeys]containsObject:key];
}
-(int)getMapSize{
    return (int)[m_map allKeys].count;
}
-(void)AddByteArray:(Byte*)c{
//    Byte *bute =  buf.getByteArray;
    NSData *data = [NSData dataWithBytes:c length:sizeof(c)];//Byte 2 Data
    
    [self.m_byte_buf addObject:data];
}
-(int)GetByteArrayCount{
    return (int)self.m_byte_buf.count;
}
-(Byte*)GetByteArray:(int)pos{
    if (pos < self.m_byte_buf.count && pos>=0) {
        NSData *data = self.m_byte_buf[pos];
        Byte *b = NULL;
        [data getBytes:&b length:data.length];
        return b;
    }
    return nil;
}
-(int)getRow{
    return m_row;
}
-(int)getCol{
    return m_col;
}
-(int)setCol:(int)col{
//    m_col = col;
    int ret = -1;
    if (col >0 ) {
        [m_array removeAllObjects];
        m_row = 0;
        m_col = col;
        ret = 0;
    }
    return ret;
}
-(int)AddRow{
     
    int ret = -1;
    if (m_col > 0) {
        ret = m_row;
        ++m_row;
        for (int i = 0; i< m_col ; i++) {
            [m_array addObject:@""];
        }
    }
    
    return  ret;
    
}
-(int)setArrayValue:(int)row :(int)col val:(NSString*)val{
    
    if (false == [self IsPosValid:row :col]) {
        return -1;;
    }
    
    int pos  = [self CalculPos:row :col];
    m_array [pos] = val;
    
    return 0;
}
-(NSString*)getArrayValue:(int)row :(int)col  {
    
    if (false == [self IsPosValid:row :col]) {
        return INVALID_STRING_VAL;;
    }
    
    return m_array[[self CalculPos:row :col]];
    
}
    
-(BOOL)IsPosValid:(int)row : (int)col{
    if ( row< 0 || col <0) {
        return false;
    }
    if (row>= m_row || col >= m_col) {
        return false;
    }
    int pos = [self CalculPos:row :col];
    if (pos > m_array.count) {
        return false;
    }
    return true;
}
-(int)CalculPos:(int)row : (int)col{
    
    int pos = 0;
    
    if (row==0) {
        pos = col;
        
    }
    else{
        pos = row*m_col + col;
    }
    
    return pos;
}
-(BOOL)IsDataValid:(SocketByteBuffer*)buf{
    
    int min_packet_size = 12+4+(4+4) +4;
    return buf.getBufSize >= min_packet_size;
}


@end
