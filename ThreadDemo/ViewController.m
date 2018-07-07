//
//  ViewController.m
//  ThreadDemo
//
//  Created by YangWenjun on 2018/7/7.
//  Copyright © 2018年 YangWenjun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self lock];
}

/**
 dispatch_async dispatch_sync 用来控制是否要开启新的线程
 队列的类型决定了任务执行的方式(并发、串行)
  1.串行
  2.并发
  3.主队列(串行队列)
 */
// 1.gcd常用函数
- (void)gcdDemo
{
    // 同步
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_sync(queue, ^{
        NSLog(@"同步 %@", [NSThread currentThread]);
    });
    NSLog(@"========");
    // 异步
    dispatch_async(queue, ^{
        NSLog(@"异步 %@", [NSThread currentThread]);
    });
    NSLog(@"*****");
}

// 2.并发、串行队列
- (void)asyncSeriesQueue
{
    //    dispatch_queue_t golbalQueue = dispatch_get_global_queue(0, 0);
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        for (int index = 0; index < 5; index++) {
            NSLog(@"异步线程1 %@", [NSThread currentThread]);
        }
    });
    
    
    NSLog(@"========");
    // 异步
    dispatch_async(serialQueue, ^{
        for (int index = 0; index < 5; index++) {
            NSLog(@"异步线程2 %@", [NSThread currentThread]);
        }
    });
    NSLog(@"*****");
}

// 3.死锁
- (void)lock
{
    // 
    dispatch_queue_t queue = dispatch_get_main_queue();
    NSLog(@"任务1");
    dispatch_sync(queue, ^{
        NSLog(@"任务2");
    });
    NSLog(@"任务3");
}

@end
