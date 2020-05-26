//
//  DKPromise+Retry.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/26.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise.h"

NS_ASSUME_NONNULL_BEGIN

NSInteger const DKPromiseRetryDefaultAttemptsCount NS_REFINED_FOR_SWIFT;
NSInteger const DKPromiseRetryDefaultDelayInterval NS_REFINED_FOR_SWIFT;

typedef id __nullable(^DKPromiseRetryWorkBlock)(void) NS_SWIFT_UNAVAILABLE("");
typedef BOOL(^DKPromiseRetryPredicateBlock)(NSInteger, NSError *) NS_SWIFT_UNAVAILABLE("");

@interface DKPromise<Value> (Retry)

+(DKPromise *)retry:(DKPromiseRetryWorkBlock)work;


+(DKPromise *)onQueue:(dispatch_queue_t)queue
                retry:(DKPromiseRetryWorkBlock)work;
;
+(DKPromise *)attempts:(NSInteger)count
                 retry:(DKPromiseRetryWorkBlock)work;
;

+(DKPromise *)onQueue:(dispatch_queue_t)queue
             attempts:(NSInteger)count
                retry:(DKPromiseRetryWorkBlock)work;
;

+(DKPromise *)attempts:(NSInteger)count
                delay:(NSTimeInterval)interval
                condition:(nullable DKPromiseRetryPredicateBlock)predicate
                 retry:(DKPromiseRetryWorkBlock)work;;

+(DKPromise *)onQueue:(dispatch_queue_t)queue
                attempts:(NSInteger)count
                delay:(NSTimeInterval)interval
                condition:(nullable DKPromiseRetryPredicateBlock)predicate
                retry:(DKPromiseRetryWorkBlock)work;
@end

@interface DKPromise<Value>(DotSyntax_RetryAdditions)

+(DKPromise *(^)(DKPromiseRetryWorkBlock))onRetry;

+(DKPromise *(^)(dispatch_queue_t,DKPromiseRetryWorkBlock))againRetry;

+(DKPromise *(^)(NSInteger, NSTimeInterval, DKPromiseRetryPredicateBlock, DKPromiseRetryWorkBlock))againOnRetry;

+(DKPromise *(^)(dispatch_queue_t, NSInteger, NSTimeInterval, DKPromiseRetryPredicateBlock, DKPromiseRetryWorkBlock))againOnAgainRetry;
@end

NS_ASSUME_NONNULL_END
