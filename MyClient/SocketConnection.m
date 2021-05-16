//
//  SocketConnection.m
//  MyClient
//
//  Created by leemac on 2021/5/16.
//  Copyright © 2021 gongwenkai. All rights reserved.
//

#import "SocketConnection.h"

@implementation SocketConnection


-(id)init{
    self = [super init];
    if (self) {
        m_bValid = NO;
        m_buf = [[SocketByteBuffer alloc]init];
        m_head = [[SocketPacketHead alloc]init];
    }
    return self;
}
-(void)Connection:(SocketMessageHandler *)handler{
    m_bValid = NO;
    m_buf = [[SocketByteBuffer alloc]init];
    m_head = [[SocketPacketHead alloc]init];
    [self SetPacketLisnter:handler];
    
    
    
}

-(void)ConnectionWS:(int)socket{
    
    m_bValid = NO;
    m_buf = [[SocketByteBuffer alloc]init];
    m_head = [[SocketPacketHead alloc]init];
//    [self setso:handler];
    [self setSocket:socket];
    
}

-(void)setSocket:(int)mSock{
    m_sock = mSock;
    
//    m_output = m_sock.get
    memset(m_output, 0, 1024*10*10);
    memset(m_input, 0, 1024*10*10);
    m_bValid = YES;
}

-(BOOL)IsValid{
    return m_bValid;
}


-(int)start:(NSString *)server_addr :(int)port{
    if (false== [self initWith:server_addr :port]) {
        
        return -1;
    }
    if (false==[self setSocketOP:m_sock]) {
        return -2;
    }
    m_bValid = YES;
    return 0;
}
-(void)sendPacket:(SocketPacketData*)packet{
    if (YES== m_bValid) {
        
        [packet ShowPacket];
        SocketByteBuffer *data  = [[SocketByteBuffer alloc]init];
        [packet SerializeBody:data];
        [packet setPacketHeadLen:data.getBufSize];
        
        SocketByteBuffer *head  = [[SocketByteBuffer alloc]init];//
        [head initWithBuf_len:32];
        [packet SerializeHead:head];
        
        @try {
            
            
//            char *buf[1024] = {0};
//            const char *p1 = (char*)buf;
//            p1 = [msg cStringUsingEncoding:NSUTF8StringEncoding];
            send(m_sock, head.getBytes, 0, head.getBufSize);
            send(m_sock, [data getBytes], 0, data.getBufSize);
            
        } @catch (NSException *exception) {
            NSLog(@"sendPacket:::%@",exception);
        } @finally {
            
        }
        
    }
}

-(void)Recv{
    
}

-(BOOL)initWith:(NSString *)server_addrString :(int)port{
    
    __block BOOL _initb;
    int server_socket = socket(AF_INET, SOCK_STREAM, 0);
    if (server_socket == -1) {
        NSLog(@"创建失败");
        
        _initb = NO;
    }else{
        //绑定地址和端口
        struct sockaddr_in server_addr;
        server_addr.sin_len = sizeof(struct sockaddr_in);
        server_addr.sin_family = AF_INET;
        server_addr.sin_port = htons(port);
        const char *addr = [ server_addrString UTF8String];
        
        server_addr.sin_addr.s_addr = inet_addr(addr );// inet_addr("127.0.0.1");
        bzero(&(server_addr.sin_zero), 8);
        
        
        //接受客户端的链接
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_sync(queue, ^{
            //创建新的socket
            int aResult = connect(server_socket, (struct sockaddr*)&server_addr, sizeof(struct sockaddr_in));
            if (aResult == -1) {
                NSLog(@"链接失败");
                _initb = NO;
            }else{
//                self.server_socket = server_socket;
                m_sock = server_socket;
//                [self acceptFromServer];
                
                _initb = YES;
            }
        });
        
        
    }

    return _initb;
    
    
}

-(BOOL)setSocketOP:(int)mSock{

    @try {
//        setsockopt(mSock, SQL_SO, <#int#>, <#const void *#>, <#socklen_t#>)
        int reuseOn = 1;

        int  status = setsockopt(mSock, SOL_SOCKET, SO_REUSEADDR, &reuseOn, sizeof(reuseOn));
            
        m_bValid = YES;
    } @catch (NSException *exception) {
        NSLog(@"setSocketOP:%@",exception);
        m_bValid = false;
    } @finally {
        
        return m_bValid;
    }
}
@end
