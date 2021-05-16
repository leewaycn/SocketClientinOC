//
//  SocketMessageHandler.m
//  MyClient
//
//  Created by leemac on 2021/5/16.
//  Copyright © 2021 gongwenkai. All rights reserved.
//

#import "SocketMessageHandler.h"
#import <objc/runtime.h>

@implementation SocketMessageHandler
- (id)init{
    self = [super init];
    if (self) {
        m_op_map = [NSMutableDictionary dictionary];
    }
    return self;
}
-(void)addOp:(NSString*)op func:(NSString*)func{
    [m_op_map setValue:func forKey:op];
}
-(void)OnPacketArrived:(SocketPacketData*)packet{
    int op = packet.getOp;
    if (YES==[[m_op_map allKeys] containsObject:[NSString stringWithFormat:@"%d",op]]) {
        
        NSString *func = [m_op_map valueForKey:[NSString stringWithFormat:@"%d",op]];
        NSLog(@"func:%@",func);
     
        SEL sel = NSSelectorFromString(func);
        if ([self respondsToSelector: sel]) {
            [self performSelector:sel];
        }else{
            NSLog(@"方法没有实现");
        }
    }else{
        NSLog(@"没有这个op:%d",op);
    }
}



@end
