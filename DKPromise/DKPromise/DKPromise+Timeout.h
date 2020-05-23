//
//  DKPromise+Timeout.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/23.
//  Copyright © 2020 丁侃. All rights reserved.
//  链式创建添加promise interval之后 如果异步炒作无相应，则执行跑出异常

#import "DKPromise.h"

NS_ASSUME_NONNULL_BEGIN

@interface DKPromise<Value> (Timeout)

-(DKPromise *)timeout:(NSTimeInterval)interval NS_SWIFT_UNAVAILABLE("");

-(DKPromise *)onQueue:(dispatch_queue_t)queue
              timeout:(NSTimeInterval)interval NS_SWIFT_UNAVAILABLE("");

@end

@interface DKPromise<Value> (Dotsyntax_TimeoutAdditions)


-(DKPromise *(^)(NSTimeInterval))timeout;

-(DKPromise *(^)(dispatch_queue_t, NSTimeInterval))timeoutOn;

@end

NS_ASSUME_NONNULL_END
