//
//  TProxy1.h
//  ThreadDemo
//
//  Created by YangWenjun on 2018/7/13.
//  Copyright © 2018年 YangWenjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TProxy1 : NSProxy
+ (instancetype)proxyWithTarget:(id)target;
@property (weak, nonatomic) id target;
@end
