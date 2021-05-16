//
//  SocketPacketListener.m
//  MyClient
//
//  Created by leemac on 2021/5/16.
//  Copyright © 2021 gongwenkai. All rights reserved.
//

#import "SocketPacketListener.h"

@implementation SocketPacketListener




-(void)SetPacketLisnter:(SocketMessageHandler*)handler{
    m_handler = handler;
}

-(void)OnPacketArrived:(SocketPacketData*)packet{
    [m_handler OnPacketArrived:packet];
}


@end
