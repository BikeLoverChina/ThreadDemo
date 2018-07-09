//
//  OSUNFairLockDemo.m
//  ThreadDemo
//
//  Created by YangWenjun on 2018/7/9.
//  Copyright © 2018年 YangWenjun. All rights reserved.
//

#import "OSUNFairLockDemo.h"
#import <os/lock.h>

@interface OSUNFairLockDemo ()

@property (nonatomic, assign) os_unfair_lock  lock;

@end

@implementation OSUNFairLockDemo

- (instancetype)init
{
    if (self=[super init]) {
        _lock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}

- (void)saleTicket
{
    os_unfair_lock_lock(&_lock);
    
    [super saleTicket];
    
    os_unfair_lock_unlock(&_lock);
}

@end
