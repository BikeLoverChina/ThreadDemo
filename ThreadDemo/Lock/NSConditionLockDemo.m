//
//  NSConditionLockDemo.m
//  ThreadDemo
//
//  Created by YangWenjun on 2018/7/9.
//  Copyright © 2018年 YangWenjun. All rights reserved.
//

#import "NSConditionLockDemo.h"

@interface NSConditionLockDemo ()
@property (nonatomic, strong) NSConditionLock *conditionLock;
@end

@implementation NSConditionLockDemo

- (instancetype)init
{
    if (self=[super init]) {
        self.conditionLock = [[NSConditionLock alloc] initWithCondition:1];
        [self test];
    }
    return self;
}

- (void)test
{
    [[[NSThread alloc] initWithTarget:self selector:@selector(_one) object:nil] start];
    [[[NSThread alloc] initWithTarget:self selector:@selector(_three) object:nil] start];
    [[[NSThread alloc] initWithTarget:self selector:@selector(_two) object:nil] start];
}

- (void)_one
{
    [self.conditionLock lockWhenCondition:1];
    NSLog(@"== %s ==", __func__);
    [self.conditionLock unlockWithCondition:2];
}

- (void)_two
{
    [self.conditionLock lockWhenCondition:2];
    NSLog(@"== %s ==", __func__);
    [self.conditionLock unlockWithCondition:3];
}

- (void)_three
{
    [self.conditionLock lockWhenCondition:3];
    NSLog(@"== %s ==", __func__);
    [self.conditionLock unlock];
}

@end
