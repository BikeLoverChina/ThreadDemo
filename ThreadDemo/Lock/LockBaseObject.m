//
//  LockBaseObject.m
//  ThreadDemo
//
//  Created by YangWenjun on 2018/7/9.
//  Copyright © 2018年 YangWenjun. All rights reserved.
//

#import "LockBaseObject.h"

@interface LockBaseObject ()

@property (nonatomic, assign) NSInteger totalTickets;

@end

@implementation LockBaseObject

- (void)startSaleTicket
{
    self.totalTickets = 15;
    
//    for (int index=0; index<10; index++) {
//        [[[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil] start];
//    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        for (int index = 0; index < 5; index++) {
            [self saleTicket];
        }
    });

    dispatch_async(queue, ^{
        for (int index = 0; index < 5; index++) {
            [self saleTicket];
        }
    });

    dispatch_async(queue, ^{
        for (int index = 0; index < 5; index++) {
            [self saleTicket];
        }
    });
}

- (void)saleTicket
{
    NSInteger oldTicketCount = self.totalTickets;
    sleep(.2);
//    sleep(600);
    oldTicketCount = oldTicketCount - 1;
    self.totalTickets = oldTicketCount;
    NSLog(@"剩余票数 %@ -- %@", @(self.totalTickets), [NSThread currentThread]);
}

@end
