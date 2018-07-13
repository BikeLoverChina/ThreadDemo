//
//  BarrierLockDemo.m
//  ThreadDemo
//
//  Created by YangWenjun on 2018/7/13.
//  Copyright © 2018年 YangWenjun. All rights reserved.
//

#import "BarrierLockDemo.h"
#import <pthread.h>

@interface BarrierLockDemo ()

@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation BarrierLockDemo

- (instancetype)init
{
    if (self = [super init]) {
        self.queue = dispatch_queue_create("rw_queue", DISPATCH_QUEUE_CONCURRENT
                                           );
        [self test];
    }
    return self;
}

- (void)test {
    for (int index = 0; index < 10; index++) {
        [self read];
        [self read];
        [self read];
        [self write];
    }
}


- (void)read {
    dispatch_async(self.queue, ^{
        sleep(1);
        NSLog(@"read");
    });
}

- (void)write {
    dispatch_barrier_async(self.queue, ^{
        sleep(1);
        NSLog(@"write");
    });
}

@end
