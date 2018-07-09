//
//  OSSpinLockDemo.m
//  ThreadDemo
//
//  Created by YangWenjun on 2018/7/9.
//  Copyright © 2018年 YangWenjun. All rights reserved.
//

#import "OSSpinLockDemo.h"
#import <libkern/OSAtomic.h>

@interface OSSpinLockDemo ()

//@property (nonatomic, assign) OSSpinLock lock;

@end

@implementation OSSpinLockDemo

- (void)saleTicket
{
    static OSSpinLock lock = OS_SPINLOCK_INIT;
    OSSpinLockLock(&lock);
    
    [super saleTicket];
    
    OSSpinLockUnlock(&lock);
}

@end
