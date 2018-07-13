//
//  SemaphoreDemo.m
//  ThreadDemo
//
//  Created by YangWenjun on 2018/7/9.
//  Copyright © 2018年 YangWenjun. All rights reserved.
//

#import "SemaphoreDemo.h"

@interface SemaphoreDemo()
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@end

@implementation SemaphoreDemo

- (instancetype)init
{
    if (self = [super init]) {
        self.semaphore = dispatch_semaphore_create(5);
        [self test];
    }
    return self;
}

- (void)test
{
    for (int index=0; index<20; index++) {
        [[[NSThread alloc] initWithTarget:self selector:@selector(log) object:nil] start];
    }
}

- (void)log
{
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@" %s : %@", __func__, [NSThread currentThread]);
    sleep(2);
    dispatch_semaphore_signal(self.semaphore);
}

@end
