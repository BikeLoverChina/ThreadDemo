//
//  PThreadRWLockDemo.m
//  ThreadDemo
//
//  Created by YangWenjun on 2018/7/10.
//  Copyright © 2018年 YangWenjun. All rights reserved.
//

#import "PThreadRWLockDemo.h"
#import <pthread.h>

@interface PThreadRWLockDemo()
@property (nonatomic, assign) pthread_rwlock_t lock;
@end

@implementation PThreadRWLockDemo

- (instancetype)init
{
    if (self = [super init]) {
        pthread_rwlock_init(&_lock, NULL);
        [self test];
    }
    return self;
}

- (void)test
{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    for (int index=0; index<10; index++) {
        dispatch_async(queue, ^{
            [self read];
        });
        
        dispatch_async(queue, ^{
            [self write];
        });
    }
}

- (void)read
{
    pthread_rwlock_rdlock(&_lock);
    sleep(2);
    NSLog(@"%s", __func__);
    pthread_rwlock_unlock(&_lock);
}

- (void)write
{
    pthread_rwlock_wrlock(&_lock);
    sleep(2);
    NSLog(@"%s", __func__);
    pthread_rwlock_unlock(&_lock);
}

@end
