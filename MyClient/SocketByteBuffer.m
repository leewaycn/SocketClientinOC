//
//  SocketByteBuffer.m
//  MyClient
//
//  Created by leemac on 2021/5/16.
//  Copyright © 2021 gongwenkai. All rights reserved.
//

#import "SocketByteBuffer.h"

@implementation SocketByteBuffer
{
    int m_max_len;
//    Byte m_buf[10000];
    Byte *m_buf;
    
    int m_read_pos,m_write_pos;
    int m_tail_pos;
}


-(void)initWithBuf_len:(int)buf_len{
    m_read_pos = m_write_pos = START_POS;

    if (buf_len>0) {
        m_max_len = buf_len;
    }else{
        m_max_len = BUF_LEN;
    }
    
    m_tail_pos = m_max_len;
    
//    m_buf = Byte [m_max_len];
    
    memset(m_buf, 0, m_max_len);
    
}

-(void)isNULL{
    if (&m_buf == NULL) {
        NSLog(@"%s: im null",__func__);
    }
}

-(void)putArray:(Byte[]) bytes len:(int)len{
    memset(m_buf, 0, sizeof(char) * len);
    [self CheckPutWithLen:len];
    for (NSInteger i = m_write_pos; i<len+m_write_pos; i++) {
        m_buf[i] = bytes[i-m_write_pos];
    }
    m_write_pos +=len;
    
}
- (void)bytesplit2byte:(Byte[])src orc:(Byte[])orc begin:(NSInteger)begin count:(NSInteger)count{
    memset(orc, 0, sizeof(char)*count);
    for (NSInteger i = begin; i < begin+count; i++){
        orc[i-begin] = src[i];
    }
}


//————————————————
//版权声明：本文为CSDN博主「Erice_e」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
//原文链接：https://blog.csdn.net/Erice_e/article/details/52093824

-(BOOL)CheckPutWithLen:(int)len{
    
    if (m_tail_pos-m_write_pos<=len) {
        int new_len = sizeof(m_buf)+BUF_LEN;
        Byte *tmp = NULL;
        memset(m_buf, 0, new_len);
        [self bytesplit2byte:tmp orc:m_buf begin:0 count:m_write_pos];
        m_tail_pos = new_len;
        m_buf = tmp;
    }
    
    return true;
}

 

-(void)sendBySocket:(int)socket{
    
    char *buf[1024] = {0};
    const char *p1 = (char*)buf;
    p1 = [@"" cStringUsingEncoding:NSUTF8StringEncoding];
    
    send(socket, m_buf, m_write_pos, 0);
//    send(socket, p1, 1024, 0);
}


-(Byte*)getBytes{
    return m_buf;
}
-(int)getBufSize{
    return m_write_pos;
}

-(int)getMaxSize{
    return m_max_len;
}
-(int)getWritePos{
    return m_write_pos;
}
-(int)getReadPos{
    return m_read_pos;
}

-(void)clean{
    m_read_pos= m_write_pos= START_POS;
}

-(void)ResetReadPos{
    m_read_pos = START_POS;
}

-(int)putShort:(short)val{
    if (0 != [self CheckWriteValid:sizeof(short)/8]) {
        return -1;
    }else{
        m_buf[m_write_pos+1] =(Byte)(val>>8);
        m_buf[m_write_pos+0] = (Byte)(val>>0);
        m_write_pos+=2;
    }
    return 0;
}
-(short)getShort{
    if (0 != [self CheckReadValid:sizeof(short)/8]) {
        NSLog(@"-getShort---11");
        return -1;
    }
    short val = (short)((m_buf[m_read_pos+1]<<8  | m_buf[m_read_pos+0] )& 0xff );
    m_read_pos+=2;
    return val;
}

-(int)putInt:(int)val{
    if (0 != [self CheckWriteValid:sizeof(int)/8]) {
        return -1;
    }else{
        m_buf[m_write_pos+3] =(Byte)(val>>24);
        m_buf[m_write_pos+2] = (Byte)(val>>16);
        m_buf[m_write_pos+1] =(Byte)(val>>8);
        m_buf[m_write_pos+0] = (Byte)(val>>0);
        m_write_pos+=4;
    }
    return 0;
}
-(int)getInt{
    if (0 != [self CheckReadValid:sizeof(int)/8]) {
        NSLog(@"-getShort---11");
        return -1;
    }
    short val = (short)(    ((m_buf[m_read_pos+3] & 0xff)<<24)
                          | ((m_buf[m_read_pos+2] & 0xff)<<16)
                          | ((m_buf[m_read_pos+1] & 0xff)<<8)
                          | ((m_buf[m_read_pos+0] )& 0xff ));
    m_read_pos+=4;
    return val;
}
-(int)putLong:(long)val{
    if (0 != [self CheckWriteValid:sizeof(long)/8]) {
        return -1;
    }else{
        m_buf[m_write_pos+7] =(Byte)(val>>56);
        m_buf[m_write_pos+6] = (Byte)(val>>48);
        m_buf[m_write_pos+5] =(Byte)(val>>40);
        m_buf[m_write_pos+4] = (Byte)(val>>32);
        m_buf[m_write_pos+3] =(Byte)(val>>24);
        m_buf[m_write_pos+2] = (Byte)(val>>16);
        m_buf[m_write_pos+1] =(Byte)(val>>8);
        m_buf[m_write_pos+0] = (Byte)(val>>0);
        m_write_pos+= 8;
    }
    return 0;
}
-(long)getLong{
    if (0 != [self CheckReadValid:sizeof(long)/8]) {
        NSLog(@"-getShort---11");
        return -1;
    }
    short val = (short)(  ((long)(m_buf[m_read_pos+7] & 0xff)<<56)
                        | ((long)(m_buf[m_read_pos+6] & 0xff)<<48)
                        | ((long)(m_buf[m_read_pos+5] & 0xff)<<40)
                        | ((long)(m_buf[m_read_pos+4] & 0xff)<<32)
                        | ((long)(m_buf[m_read_pos+3] & 0xff)<<24)
                        | ((long)(m_buf[m_read_pos+2] & 0xff)<<16)
                        | ((long)(m_buf[m_read_pos+1] & 0xff)<<8)
                        | ((long)(m_buf[m_read_pos+0] )& 0xff ));
    m_read_pos+=4;
    return val;
}

-(int)putChar:(char)ch{
    if (0 != [self CheckWriteValid:2]) {
        return -1;
    }
    int temp = (int)ch;
    for (int i = 0; i<2; i++) {
        m_buf[m_write_pos+i] = (Byte)(temp & 0xff);
        temp= temp>>8;
    }
    m_write_pos+=2;
    
    return 0;
    
}
-(char)getChar{
    if (0 != [self CheckReadValid:2]) {
        return -1;
    }
    int s= 0;
    if (m_buf[m_read_pos+1]>0) {
        s+= m_buf[m_read_pos+1];
    }else{
        s += 256 + m_buf[m_read_pos+0];
    }
    s *= 256;
    if (m_buf[m_read_pos+0]>0) {
        s+= m_buf[m_read_pos+1];
    }else{
        s+= m_buf[m_read_pos+1];
    }
    char ch = (char)s;
    m_read_pos +=2;
    return ch;
}
-(NSData *)floatToByte:(float)f{
    float wTemp=f;
    char sBuf1[4];
    char* temp;
    memset(sBuf1,0,sizeof(sBuf1));
    temp=(char*)(&wTemp);
    sBuf1[0] = temp[0] ;
    sBuf1[1] = temp[1];
    sBuf1[2] = temp[2];
    sBuf1[3] = temp[3];
    for (int i=0; i<sizeof(sBuf1); i++) {
        NSLog(@"sbff----%X",sBuf1[i]);
    }
    NSData *data = [NSData dataWithBytes:sBuf1 length:sizeof(sBuf1)];
    return data;
}

-(NSData *)DoubleToByte:(double)f{
    double wTemp=f;
    char sBuf1[8];
    char* temp;
    memset(sBuf1,0,sizeof(sBuf1));
    temp=(char*)(&wTemp);
    sBuf1[0] = temp[0] ;
    sBuf1[1] = temp[1];
    sBuf1[2] = temp[2];
    sBuf1[3] = temp[3];
    sBuf1[4] = temp[4];
    sBuf1[5] = temp[5];
    sBuf1[6] = temp[6];
    sBuf1[7] = temp[7];
    
    for (int i=0; i<sizeof(sBuf1); i++) {
        NSLog(@"sbff----%X",sBuf1[i]);
    }
    NSData *data = [NSData dataWithBytes:sBuf1 length:sizeof(sBuf1)];
    return data;
}

//————————————————
//版权声明：本文为CSDN博主「密蒙」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
//原文链接：https://blog.csdn.net/FL550172771/article/details/77369918

-(int)putFloat:(float)val{
    if (0 != [self CheckWriteValid:sizeof(float)/8]) {
        return -1;
    }
       
    NSData *data = [self floatToByte:val];
    void * sBuf1;
    [data getBytes:sBuf1 range:NSMakeRange(0, 4) ];
    NSLog(@"%d",&sBuf1);
    Byte *byp = sBuf1;
    
//    char sBuf1a[4];
////    char* temp;
//    memset(sBuf1a,0,sizeof(sBuf1a));
//    sBuf1a[0] = byp[0] ;
//    sBuf1a[1] = byp[1];
//    sBuf1a[2] = byp[2];
//    sBuf1a[3] = byp[3];
    
    m_buf[m_write_pos+3] = byp[3] ;// (Byte)(byp>>24);
    m_buf[m_write_pos+2] = byp[2] ;// (Byte)(byp>>16);
    m_buf[m_write_pos+1] =byp[1] ;// (Byte)(byp>>8);
    m_buf[m_write_pos+0] =byp[0] ;//  (Byte)(byp>>0);
    
    m_write_pos+= 8;
    
    return 0;
}

-(float)getFloat{
    if (0 != [self CheckReadValid:sizeof(float)/8]) {
        return -1;
    }
    
    int l;
    l = m_buf[m_read_pos + 0];
    l &= 0xff;
    l |= ((long) m_buf[m_read_pos + 1] << 8);
    l &= 0xffff;
    l |= ((long) m_buf[m_read_pos + 2] << 16);
    l &= 0xffffff;
    l |= ((long) m_buf[m_read_pos + 3] << 24);
    
    Byte *b = nil;
    memset(b, 0, 4);
    b[0] = m_buf[m_read_pos + 0];
    b[1] = m_buf[m_read_pos + 1] << 8;
    b[2] = m_buf[m_read_pos + 2] << 16;
    b[3] = m_buf[m_read_pos + 3] << 24;
    
    char sBuf[4];
     sBuf[0]=b[0];
     sBuf[1]=b[1];
     sBuf[2]=b[2];
     sBuf[3]=b[3];
     float *w=(float *)(&sBuf);
//     return *w;
//    ————————————————
//    版权声明：本文为CSDN博主「密蒙」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
//    原文链接：https://blog.csdn.net/FL550172771/article/details/77369918
//
//    float val =  Float.intBitsToFloat(l);
    
    m_read_pos += 4;
    
    return *w;
}
-(int)putDouble:(double)val{
    if (0 != [self CheckWriteValid:sizeof(double)/8]) {
        return -1;
    }
       
    NSData *data = [self DoubleToByte:val];
    void * sBuf1;
    [data getBytes:sBuf1 range:NSMakeRange(0, 8) ];
    NSLog(@"%d",&sBuf1);
    Byte *byp = sBuf1;
    
//    char sBuf1a[4];
////    char* temp;
//    memset(sBuf1a,0,sizeof(sBuf1a));
//    sBuf1a[0] = byp[0] ;
//    sBuf1a[1] = byp[1];
//    sBuf1a[2] = byp[2];
//    sBuf1a[3] = byp[3];
    m_buf[m_write_pos+7] = byp[7] ;// (Byte)(byp>>24);
    m_buf[m_write_pos+6] = byp[6] ;// (Byte)(byp>>24);
    m_buf[m_write_pos+5] = byp[5] ;// (Byte)(byp>>24);
    m_buf[m_write_pos+4] = byp[4] ;// (Byte)(byp>>24);
    m_buf[m_write_pos+3] = byp[3] ;// (Byte)(byp>>24);
    m_buf[m_write_pos+2] = byp[2] ;// (Byte)(byp>>16);
    m_buf[m_write_pos+1] =byp[1] ;// (Byte)(byp>>8);
    m_buf[m_write_pos+0] =byp[0] ;//  (Byte)(byp>>0);
    
    m_write_pos+= 16;
    
    return 0;
}
-(double)getDouble{
    if (0 != [self CheckReadValid:sizeof(double)/8]) {
        return -1;
    }
    
    int l;
    l = m_buf[m_read_pos + 0];
    l &= 0xff;
    l |= ((long) m_buf[m_read_pos + 1] << 8);
    l &= 0xffff;
    l |= ((long) m_buf[m_read_pos + 2] << 16);
    l &= 0xffffff;
    l |= ((long) m_buf[m_read_pos + 3] << 24);
    
    Byte *b = nil;
    memset(b, 0, 8);
    b[0] = (long)m_buf[m_read_pos + 0];
    b[1] = (long)m_buf[m_read_pos + 1] << 8;
    b[2] = (long)m_buf[m_read_pos + 2] << 16;
    b[3] = (long)m_buf[m_read_pos + 3] << 24;
    b[4] = (long)m_buf[m_read_pos + 4] << 32;
    b[5] = (long)m_buf[m_read_pos + 5] << 40;
    b[6] = (long)m_buf[m_read_pos + 6] << 48;
    b[7] =(long) m_buf[m_read_pos + 7] << 56;
    
    char sBuf[8];
     sBuf[0]=b[0];
     sBuf[1]=b[1];
     sBuf[2]=b[2];
     sBuf[3]=b[3];
    sBuf[4]=b[4];
    sBuf[5]=b[5];
    sBuf[6]=b[6];
    sBuf[7]=b[7];
    
     double *w=(double *)(&sBuf);
//     return *w;
//    ————————————————
//    版权声明：本文为CSDN博主「密蒙」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
//    原文链接：https://blog.csdn.net/FL550172771/article/details/77369918
//
//    float val =  Float.intBitsToFloat(l);
    
    m_read_pos += 8;
    
    return *w;
}
-(int)putString:(NSString*)str{
    NSInteger len = 0;
//            try {
//                len = str.getBytes(SOCKET_ENCODING).length;
//            } catch (UnsupportedEncodingException e) {
//                // TODO Auto-generated catch block
//                e.printStackTrace();
//            }
    len = [str dataUsingEncoding:NSUTF8StringEncoding].length;
//            if(0 != CheckWriteValid(len + Integer.SIZE/8))
//            {
//                return -1;
//            }
    if (0 != [self CheckWriteValid:len+ sizeof(NSInteger)/8]) {
        return -1;
    }
    NSLog(@"putString == %ld",len);
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//            //putInt(len);
//            try {
//                putByteArray(str.getBytes(SOCKET_ENCODING));
//            } catch (UnsupportedEncodingException e) {
//                // TODO Auto-generated catch block
//                e.printStackTrace();
//            }
//
    
    Byte *bytes = (Byte *)[data bytes];
    [self putByteArray:bytes len:data.length];
//    [self putArray:bytes len:len];
    return 0;
// return 0;
}
-(NSString*)getString{
    NSString *string = @"";
    return string;
}

-(void)putByteArray:(Byte*)s len:(NSInteger)len{
    
//    this.putInt(s.length);
//            System.arraycopy(s, 0, m_buf, m_write_pos, s.length);
//            m_write_pos += s.length;
//    //        for(int i = 0; i < s.length; ++i)
//    //        {
//    //            m_buf[m_write_pos] = s[i];
//    //            ++m_write_pos;
//    //        }
    
     [self putInt:len];
    [self bytesplit2byte:s orc:m_buf begin:m_write_pos count:len];
    m_write_pos += len;
    
}

-(Byte *)getByteArray{
//    int len = getInt();
//    //        System.out.println("getByteArray的len长度="+len);
//            byte c[] = new byte[len];
//
//            System.arraycopy(m_buf,m_read_pos, c,0,len);
//            m_read_pos += len;
//    //        for(int i = 0; i < len; ++i)
//    //        {
//    //            c[i]=m_buf[m_read_pos];
//    //            ++m_read_pos;
//    //        }
//    //
//    return c;
    
    NSInteger len = [self getInt];
    Byte *c = NULL;
    memset(c, 0, len);
    [self bytesplit2byte:c orc:m_buf begin:m_read_pos count:len];
    m_read_pos += len;
    return c;
}

-(int)CheckWriteValid:(int)len{
    if (len <= 0) {
        return -1;
    }
    if (m_write_pos + len > m_tail_pos-1) {
        return -1;
    }
    return 0;
}
-(int)CheckReadValid:(int)len{
    if (len<= 0) {
        return -1;
    }
    if (m_read_pos + len > m_write_pos) {
        return -1;
    }
    return 0;;
}


@end
