//
//  DKPromise+Async.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/23.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise.h"

NS_ASSUME_NONNULL_BEGIN


@interface DKPromise<Value> (Async)

typedef void(^DKPromiseFulFillBlock)(Value __nullable value) NS_SWIFT_UNAVAILABLE("");

typedef void(^DKPromiseRejcetBlock)(NSError *error) NS_SWIFT_UNAVAILABLE("");

typedef void(^DKPromiseAysncWorkBlock)(DKPromiseFulFillBlock fulfill, DKPromiseRejcetBlock reject) NS_SWIFT_UNAVAILABLE("");

+(instancetype)async:(DKPromiseAysncWorkBlock)work NS_SWIFT_UNAVAILABLE("");

+(instancetype)onQueue:(dispatch_queue_t)queue
            async:(DKPromiseAysncWorkBlock)work NS_SWIFT_UNAVAILABLE("");

@end

@interface DKPromise<Value> (DotSyntax_AsyncAdditions)


+(DKPromise *(^)(DKPromiseAysncWorkBlock))async;

+(DKPromise *(^)(dispatch_queue_t queue, DKPromiseAysncWorkBlock work))asyncOn;

@end

NS_ASSUME_NONNULL_END
