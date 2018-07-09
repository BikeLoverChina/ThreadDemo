//
//  MutexLockDemo3.m
//  ThreadDemo
//
//  Created by YangWenjun on 2018/7/9.
//  Copyright © 2018年 YangWenjun. All rights reserved.
//

#import "MutexLockDemo3.h"
#import <pthread.h>

@interface MutexLockDemo3 ()
@property (nonatomic, assign) pthread_mutex_t mutex;
@property (nonatomic, assign) pthread_cond_t cond;
@property (nonatomic, strong) NSMutableArray *arrayM;
@end

@implementation MutexLockDemo3

- (instancetype)init
{
    if (self=[super init]) {
        [self initMutexLock:&_mutex];
        pthread_cond_init(&_cond, nil);
        self.arrayM = [NSMutableArray array];
        
        [self test];
    }
    return self;
}

- (void)initMutexLock:(pthread_mutex_t *)mutex
{
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init(mutex, &attr);
    pthread_mutexattr_destroy(&attr);
}

- (void)test
{
    [[[NSThread alloc] initWithTarget:self selector:@selector(_remove) object:nil] start];
    sleep(1.0);
    [[[NSThread alloc] initWithTarget:self selector:@selector(_add) object:nil] start];
}

- (void)_add
{
    pthread_mutex_lock(&_mutex);
    [self.arrayM addObject:[[NSObject alloc] init]];
    NSLog(@"添加元素");
    pthread_cond_signal(&_cond);
    pthread_mutex_unlock(&_mutex);
}

- (void)_remove
{
    NSLog(@"== %s ==", __func__);
    pthread_mutex_lock(&_mutex);
    if (self.arrayM.count == 0) {
        pthread_cond_wait(&_cond, &_mutex);
    }
    [self.arrayM removeLastObject];
    NSLog(@"删除元素");
    pthread_mutex_unlock(&_mutex);
}

- (void)dealloc
{
    pthread_mutex_destroy(&_mutex);
    pthread_cond_destroy(&_cond);
}

@end
