//
//  NSConditionDemo.m
//  ThreadDemo
//
//  Created by YangWenjun on 2018/7/9.
//  Copyright © 2018年 YangWenjun. All rights reserved.
//

#import "NSConditionDemo.h"

@interface NSConditionDemo ()
@property (nonatomic, strong) NSCondition *condition;
@property (nonatomic, strong) NSMutableArray *arrayM;
@end

@implementation NSConditionDemo

- (instancetype)init
{
    if (self=[super init]) {
        self.condition = [[NSCondition alloc] init];
        self.arrayM = [NSMutableArray array];
        
        [self test];
    }
    return self;
}

- (void)test
{
    [[[NSThread alloc] initWithTarget:self selector:@selector(_remove) object:nil] start];
    sleep(1.0);
    [[[NSThread alloc] initWithTarget:self selector:@selector(_add) object:nil] start];
}

- (void)_add
{
    [self.condition lock];
    [self.arrayM addObject:[[NSObject alloc] init]];
    NSLog(@"添加元素");
    [self.condition signal];
//    [self.condition broadcast];
    [self.condition unlock];
    
}

- (void)_remove
{
    NSLog(@"== %s ==", __func__);
    [self.condition lock];
    if (self.arrayM.count == 0) {
        [self.condition wait];
    }
    [self.arrayM removeLastObject];
    NSLog(@"删除元素");
    [self.condition unlock];
}

@end
