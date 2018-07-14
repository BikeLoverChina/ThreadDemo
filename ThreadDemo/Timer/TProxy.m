//
//  TProxy.m
//  ThreadDemo
//
//  Created by YangWenjun on 2018/7/13.
//  Copyright © 2018年 YangWenjun. All rights reserved.
//

#import "TProxy.h"

@implementation TProxy
+ (instancetype)proxyWithTarget:(id)target
{
    MJProxy *proxy = [[MJProxy alloc] init];
    proxy.target = target;
    return proxy;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.target;
}
@end
