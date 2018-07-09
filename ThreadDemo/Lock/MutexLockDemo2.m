//
//  MutexLockDemo2.m
//  ThreadDemo
//
//  Created by YangWenjun on 2018/7/9.
//  Copyright © 2018年 YangWenjun. All rights reserved.
//

#import "MutexLockDemo2.h"
#import <pthread.h>

@interface MutexLockDemo2 ()

@property (nonatomic, assign) pthread_mutex_t mutex;

@end

@implementation MutexLockDemo2

- (instancetype)init
{
    if (self=[super init]) {
        [self initMutexLock:&_mutex];
        [self testDemo];
    }
    return self;
}

// 递归锁：允许同一个线程对一把锁进行重复加锁
- (void)initMutexLock:(pthread_mutex_t *)mutex
{
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init(mutex, &attr);
    pthread_mutexattr_destroy(&attr);
}

/*
 线程1 testDemo(+-)
       testDemo(+-)
        testDemo(+-)
 线程2 testDemo(等待线程1完毕)
 */
- (void)testDemo
{
    pthread_mutex_lock(&_mutex);
    
    static int total = 0;
    if (total < 10) {
        NSLog(@"== %@ ==", @(total));
        total += 1;
        [self testDemo];
    }
    
    pthread_mutex_unlock(&_mutex);
}

- (void)dealloc
{
    pthread_mutex_destroy(&_mutex);
}

@end
