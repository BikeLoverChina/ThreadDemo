//
//  MutexLockDemo.m
//  ThreadDemo
//
//  Created by YangWenjun on 2018/7/9.
//  Copyright © 2018年 YangWenjun. All rights reserved.
//

#import "MutexLockDemo.h"
#import <pthread.h>

@interface MutexLockDemo ()

@property (nonatomic, assign) pthread_mutex_t mutex;

@end

@implementation MutexLockDemo

- (instancetype)init
{
    if (self=[super init]) {
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);
        pthread_mutex_init(&_mutex, &attr);
        pthread_mutexattr_destroy(&attr);
    }
    return self;
}

- (void)saleTicket
{
    pthread_mutex_lock(&_mutex);
    
    [super saleTicket];
    
    pthread_mutex_unlock(&_mutex);
}

- (void)dealloc
{
    pthread_mutex_destroy(&_mutex);
}
@end
