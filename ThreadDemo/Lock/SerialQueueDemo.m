//
//  SerialQueueDemo.m
//  ThreadDemo
//
//  Created by YangWenjun on 2018/7/9.
//  Copyright © 2018年 YangWenjun. All rights reserved.
//

#import "SerialQueueDemo.h"

@interface SerialQueueDemo ()
@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation SerialQueueDemo

- (instancetype)init
{
    if (self = [super init]) {
        self.queue = dispatch_queue_create("my_quque", DISPATCH_QUEUE_SERIAL);
        [self startSaleTicket];
    }
    return self;
}

- (void)saleTicket{
    
    dispatch_sync(self.queue, ^{
        [super saleTicket];
    });
}

@end
