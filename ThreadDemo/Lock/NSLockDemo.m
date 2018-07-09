//
//  NSLockDemo.m
//  ThreadDemo
//
//  Created by YangWenjun on 2018/7/9.
//  Copyright © 2018年 YangWenjun. All rights reserved.
//

#import "NSLockDemo.h"

@interface NSLockDemo ()

@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) NSRecursiveLock *recurLock;

@end

@implementation NSLockDemo

- (instancetype)init
{
    if (self=[super init]) {
        self.lock = [[NSLock alloc] init];
        [self startSaleTicket];
    }
    return self;
}

- (void)saleTicket
{
    [self.lock lock];
    [super saleTicket];
    [self.lock unlock];
}

@end
