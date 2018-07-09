//
//  ViewController.m
//  ThreadDemo
//
//  Created by YangWenjun on 2018/7/7.
//  Copyright © 2018年 YangWenjun. All rights reserved.
//

#import "ViewController.h"
#import "OSSpinLockDemo.h"
#import "OSUNFairLockDemo.h"
#import "MutexLockDemo.h"
#import "MutexLockDemo2.h"
#import "MutexLockDemo3.h"
#import "NSLockDemo.h"
#import "NSConditionDemo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self lockTest];
}

#pragma mark- Thread

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
    // 产生死锁
//    dispatch_queue_t queue = dispatch_get_main_queue();
//    NSLog(@"任务1");
//    dispatch_sync(queue, ^{
//        NSLog(@"任务2");
//    });
//    NSLog(@"任务3");
    
    // 未产生死锁
//    dispatch_queue_t queue = dispatch_get_main_queue();
//    NSLog(@"任务1");
//    dispatch_async(queue, ^{
//        NSLog(@"任务2");
//    });
//    NSLog(@"任务3");
    
    // 产生死锁
//    NSLog(@"任务1");
//    dispatch_queue_t queue = dispatch_queue_create("SeriesQueue", DISPATCH_QUEUE_SERIAL);
//    dispatch_async(queue, ^{
//        NSLog(@"任务2");
//        dispatch_sync(queue, ^{ // 如果在不同的队列不会产生死锁
//            NSLog(@"任务3");
//        });
//        NSLog(@"任务4");
//    });
//    NSLog(@"任务5");
    
    // 未产生死锁
//    NSLog(@"任务1");
//    dispatch_queue_t queue = dispatch_queue_create("SeriesQueue", DISPATCH_QUEUE_SERIAL);
//    dispatch_queue_t queue1 = dispatch_queue_create("ConcurRentQueue", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queue, ^{
//        NSLog(@"任务2");
//        dispatch_sync(queue1, ^{
//            NSLog(@"任务3");
//        });
//        NSLog(@"任务4");
//    });
//    NSLog(@"任务5");
    
    // 未产生死锁
    NSLog(@"任务1");
    dispatch_queue_t queue = dispatch_queue_create("SeriesQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"任务2");
        dispatch_sync(queue, ^{
            NSLog(@"任务3");
        });
        NSLog(@"任务4");
    });
    NSLog(@"任务5");
}

// 4.延迟执行
- (void)gcdDelay
{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
       NSLog(@"任务1");
//        [self performSelector:@selector(test) withObject:nil withObject:nil];
        // 子线程未开启Runloop,performSelector:withObject:afterDelay:本质往Runloop中添加定时器
        [self performSelector:@selector(test) withObject:nil afterDelay:0.3];
        NSLog(@"任务3");
        // 手动开启Runloop可以解决问题
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];

    });
}

// 5.threadDelay
- (void)threadDelay
{
    
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"任务1");
        // 解决方案
//        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }];
    [thread start];
    // start后线程退出，performSelector失败
    [self performSelector:@selector(test) onThread:thread withObject:nil waitUntilDone:YES];
}

- (void)test
{
    NSLog(@"任务2");
}

// 6.线程组
- (void)groupAsync
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("my_queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(group, queue, ^{
        for (int index = 0; index < 5; index++) {
            NSLog(@"任务1-%@", [NSThread currentThread]);
        }
    });

    dispatch_group_async(group, queue, ^{
        for (int index = 0; index < 5; index++) {
            NSLog(@"任务2-%@", [NSThread currentThread]);
        }
    });
    
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        for (int index = 0; index < 5; index++) {
//            NSLog(@"任务3-%@", [NSThread currentThread]);
//        }
//    });
    
    dispatch_group_notify(group, queue, ^{
        for (int index = 0; index < 5; index++) {
            NSLog(@"任务3-%@", [NSThread currentThread]);
        }
    });
    dispatch_group_notify(group, queue, ^{
        for (int index = 0; index < 5; index++) {
            NSLog(@"任务4-%@", [NSThread currentThread]);
        }
    });
}

#pragma mark- Lock
- (void)lockTest
{
    // OSSpinLock
//    OSSpinLockDemo *spinLock = [[OSSpinLockDemo alloc] init];
//    [spinLock startSaleTicket];
    
    // OSUNFairLock
//    OSUNFairLockDemo *fairLock = [[OSUNFairLockDemo alloc] init];
//    [fairLock startSaleTicket];
    
    // MutexLock
//    MutexLockDemo *mutex = [[MutexLockDemo alloc] init];
//    [mutex startSaleTicket];
    
//    MutexLockDemo2 *mutex2 = [[MutexLockDemo2 alloc] init];
    
//    MutexLockDemo3 *mutex3 = [[MutexLockDemo3 alloc] init];
    
    // NSLock
//    NSLockDemo *lock = [[NSLockDemo alloc] init];
    
    // NSConditionLock
    NSConditionDemo *condition = [[NSConditionDemo alloc] init];
}

@end
