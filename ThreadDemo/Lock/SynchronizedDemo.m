//
//  SynchronizedDemo.m
//  ThreadDemo
//
//  Created by YangWenjun on 2018/7/10.
//  Copyright © 2018年 YangWenjun. All rights reserved.
//

#import "SynchronizedDemo.h"

@implementation SynchronizedDemo

- (instancetype)init
{
    if (self = [super init]) {
        [self startSaleTicket];
    }
    return self;
}

- (void)saleTicket
{
    @synchronized (self) {
        NSLog(@"====");
        [super saleTicket];
    }
}

@end
