//
//  SocketPacketListener.h
//  MyClient
//
//  Created by leemac on 2021/5/16.
//  Copyright © 2021 gongwenkai. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>

#import "SocketMessageHandler.h"
#import "SocketPacketData.m"


NS_ASSUME_NONNULL_BEGIN

@interface SocketPacketListener : NSObject
{
    @private
    SocketMessageHandler *m_handler;
    
    
}


-(void)SetPacketLisnter:(SocketMessageHandler*)handler;

-(void)OnPacketArrived:(SocketPacketData*)packet;



@end

NS_ASSUME_NONNULL_END
