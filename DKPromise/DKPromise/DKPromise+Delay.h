//
//  DKPromise+Delay.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/26.
//  Copyright © 2020 丁侃. All rights reserved.
//

// fulfill成功回调后延迟执行，失败回调直接返回

#import "DKPromise.h"

NS_ASSUME_NONNULL_BEGIN

@interface DKPromise<Value> (Delay)

-(DKPromise *)delay:(NSTimeInterval)interval NS_SWIFT_UNAVAILABLE("");

-(DKPromise *)onQueue:(dispatch_queue_t)queue
                delay:(NSTimeInterval)interval NS_SWIFT_UNAVAILABLE("");

@end

@interface DKPromise<Value>(DotSyntax_DelayAdditions)

-(DKPromise *(^)(NSTimeInterval))delay;

-(DKPromise *(^)(dispatch_queue_t, NSTimeInterval))onDelay;

@end

NS_ASSUME_NONNULL_END
