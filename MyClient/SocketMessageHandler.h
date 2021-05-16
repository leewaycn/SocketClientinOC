//
//  SocketMessageHandler.h
//  MyClient
//
//  Created by leemac on 2021/5/16.
//  Copyright © 2021 gongwenkai. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>


#import "SocketPacketData.h"

@interface SocketMessageHandler : NSObject
{
    NSMutableDictionary <NSString * ,NSString*>* m_op_map;
    
}

-(void)addOp:(NSString*)op func:(NSString*)func;
-(void)OnPacketArrived:(SocketPacketData*)packet;


@end

 
