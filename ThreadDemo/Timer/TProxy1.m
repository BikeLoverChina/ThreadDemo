//
//  TProxy1.m
//  ThreadDemo
//
//  Created by YangWenjun on 2018/7/13.
//  Copyright © 2018年 YangWenjun. All rights reserved.
//

#import "TProxy1.h"

@implementation TProxy1
+ (instancetype)proxyWithTarget:(id)target
{
    // NSProxy对象不需要调用init，因为它本来就没有init方法
    TProxy1 *proxy = [TProxy1 alloc];
    proxy.target = target;
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:self.target];
}
@end
