//
//  DKPromise+Then.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/23.
//  Copyright © 2020 丁侃. All rights reserved.
//  链式穿件添加 promise 监听fulfill回调通知下一个

#import "DKPromise.h"

NS_ASSUME_NONNULL_BEGIN

@interface DKPromise<Value> (Then)

typedef id __nullable (^DKPromiseThenWorkBlock)(Value __nullable value) NS_SWIFT_UNAVAILABLE("");

-(DKPromise *)then:(DKPromiseThenWorkBlock)work NS_SWIFT_UNAVAILABLE("");

-(DKPromise *)onQueue:(dispatch_queue_t)queue
                 then:(DKPromiseThenWorkBlock)work NS_SWIFT_UNAVAILABLE("");

@end

@interface DKPromise<Value>(DotSyntax_ThenAdditions)
-(DKPromise *(^)(DKPromiseThenWorkBlock))then;

-(DKPromise *(^)(dispatch_queue_t, DKPromiseThenWorkBlock))thenOn;

@end

NS_ASSUME_NONNULL_END
