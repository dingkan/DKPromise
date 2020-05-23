//
//  DKPromise+Catch.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/23.
//  Copyright © 2020 丁侃. All rights reserved.
//   链式穿件添加 catch promise  监听reject回调

#import "DKPromise.h"

NS_ASSUME_NONNULL_BEGIN

@interface DKPromise<Value> (Catch)

typedef void(^DKPromiseCatchWorkBlock)(NSError *error) NS_SWIFT_UNAVAILABLE("");

-(DKPromise *)catch:(DKPromiseCatchWorkBlock)reject NS_SWIFT_UNAVAILABLE("");

-(DKPromise *)onQueue:(dispatch_queue_t)queue
                catch:(DKPromiseCatchWorkBlock)reject NS_SWIFT_UNAVAILABLE("");

@end

@interface DKPromise<Value>(DotSyntax_CatchAdditions)

-(DKPromise *(^)(DKPromiseCatchWorkBlock))catch;

-(DKPromise *(^)(dispatch_queue_t, DKPromiseCatchWorkBlock))catchOn;
@end

NS_ASSUME_NONNULL_END
