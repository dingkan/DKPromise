//
//  DKPromise+Recover.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/26.
//  Copyright © 2020 丁侃. All rights reserved.
//

//创建返回一个pormise， 如果上一个promise执行了失败回调

#import "DKPromise.h"

NS_ASSUME_NONNULL_BEGIN

typedef id __nullable(^DKPromiseRecoverWorkBlock)(NSError *error) NS_SWIFT_UNAVAILABLE("");

@interface DKPromise<Value> (Recover)

-(DKPromise *)recover:(DKPromiseRecoverWorkBlock)work NS_SWIFT_UNAVAILABLE("");

-(DKPromise *)onQueue:(dispatch_queue_t)queue
              recover:(DKPromiseRecoverWorkBlock)work NS_SWIFT_UNAVAILABLE("");

@end

@interface DKPromise<Value> (DotSyntax_RecoverAdditions)

-(DKPromise *(^)(DKPromiseRecoverWorkBlock))recover;

-(DKPromise *(^)(dispatch_queue_t, DKPromiseRecoverWorkBlock))onRecover;
@end

NS_ASSUME_NONNULL_END
