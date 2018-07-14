//
//  TimerViewController.m
//  ThreadDemo
//
//  Created by YangWenjun on 2018/7/13.
//  Copyright © 2018年 YangWenjun. All rights reserved.
//

#import "TimerViewController.h"
#import "TProxy.h"
#import "TProxy1.h"

@interface TimerViewController ()
@property (strong, nonatomic) CADisplayLink *link;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation TimerViewController

/*
 TProxy1直接继承自NSProxy,避免了查找方法阶段，相对于TProxy效率更高
 */
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self notDeallocTimer];
    [self deallockTimer1];
    [self deallockTimer2];
}

- (void)notDeallocTimer
{
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(linkTest)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTest) userInfo:nil repeats:YES];
}

- (void)deallockTimer1
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:[TProxy proxyWithTarget:self] selector:@selector(timerTest) userInfo:nil repeats:YES];

    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf timerTest];
    }];
    
    self.link = [CADisplayLink displayLinkWithTarget:[TProxy proxyWithTarget:self] selector:@selector(linkTest)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)deallockTimer2
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:[TProxy1 proxyWithTarget:self] selector:@selector(timerTest) userInfo:nil repeats:YES];
    
    self.link = [CADisplayLink displayLinkWithTarget:[TProxy1 proxyWithTarget:self] selector:@selector(linkTest)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)timerTest
{
    NSLog(@"%s", __func__);
}

- (void)linkTest
{
    NSLog(@"%s", __func__);
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    [self.link invalidate];
    [self.timer invalidate];
}

@end
