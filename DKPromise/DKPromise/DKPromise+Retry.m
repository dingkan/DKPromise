//
//  DKPromise+Retry.m
//  DKPromise
//
//  Created by 丁侃 on 2020/5/26.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise+Retry.h"
#import "DKPromisePrivate.h"

NSInteger const DKPromiseRetryDefaultAttemptsCount = 1;
NSInteger const DKPromiseRetryDefaultDelayInterval = 0.1;

static void DKPRomiseRetryAttempt(DKPromise *promise, dispatch_queue_t queue, NSInteger count,
                                  NSTimeInterval interval, DKPromiseRetryPredicateBlock predicate,
                                  DKPromiseRetryWorkBlock work){
    
    __auto_type retrier = ^(id __nullable value){
        
        if ([value isKindOfClass:[NSError class]]) {
            
            if (count < 0 || (predicate && !predicate(count, value))) {
                [promise reject:value];
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    DKPRomiseRetryAttempt(promise, queue, count - 1, interval, predicate, work);
                });
            }
            
        }else{
            [promise fulfill:value];
        }
        
    };
    
    id value = work();
    if ([value isKindOfClass:[DKPromise class]]) {
        [(DKPromise *)value observeOnQueue:queue fulfill:retrier reject:retrier];
    }else{
        retrier(value);
    }
}


@implementation DKPromise (Retry)

+(DKPromise *)retry:(DKPromiseRetryWorkBlock)work{
    
    return [self onQueue:DKPromise.defaultDispatchQueue attempts:DKPromiseRetryDefaultAttemptsCount delay:DKPromiseRetryDefaultDelayInterval condition:nil retry:work];
    
}


+(DKPromise *)onQueue:(dispatch_queue_t)queue
                retry:(DKPromiseRetryWorkBlock)work{
    
    return [self onQueue:queue attempts:DKPromiseRetryDefaultAttemptsCount delay:DKPromiseRetryDefaultDelayInterval condition:nil retry:work];
    
}

+(DKPromise *)attempts:(NSInteger)count
                retry:(DKPromiseRetryWorkBlock)work{
    
    return [self onQueue:DKPromise.defaultDispatchQueue attempts:DKPromiseRetryDefaultAttemptsCount delay:DKPromiseRetryDefaultDelayInterval condition:nil retry:work];
    
}

+(DKPromise *)onQueue:(dispatch_queue_t)queue
             attempts:(NSInteger)count
                retry:(DKPromiseRetryWorkBlock)work{
    
    return [self onQueue:queue attempts:count delay:DKPromiseRetryDefaultDelayInterval condition:nil retry:work];
    
}

+(DKPromise *)attempts:(NSInteger)count
                delay:(NSTimeInterval)interval
                condition:(nullable DKPromiseRetryPredicateBlock)predicate
                retry:(DKPromiseRetryWorkBlock)work{
    return [self onQueue:DKPromise.defaultDispatchQueue attempts:count delay:interval condition:predicate retry:work];
}

+(DKPromise *)onQueue:(dispatch_queue_t)queue
                attempts:(NSInteger)count
                delay:(NSTimeInterval)interval
                condition:(nullable DKPromiseRetryPredicateBlock)predicate
                retry:(DKPromiseRetryWorkBlock)work{
    NSParameterAssert(queue);
    NSParameterAssert(work);
    
    DKPromise *promise = [[DKPromise alloc]initPending];
    DKPRomiseRetryAttempt(promise, queue, count, interval, predicate, work);
    return promise;
}

@end


@implementation DKPromise(DotSyntax_RetryAdditions)

+(DKPromise *(^)(DKPromiseRetryWorkBlock))onRetry{
    return ^(DKPromiseRetryWorkBlock work){
        return [self retry:work];
    };
}

+(DKPromise *(^)(dispatch_queue_t,DKPromiseRetryWorkBlock))againRetry{
    return ^(dispatch_queue_t queue, DKPromiseRetryWorkBlock work){
        return [self onQueue:queue retry:work];
    };
}

+(DKPromise *(^)(NSInteger, NSTimeInterval, DKPromiseRetryPredicateBlock, DKPromiseRetryWorkBlock))againOnRetry{
    return ^(NSInteger count, NSTimeInterval interval, DKPromiseRetryPredicateBlock predicate, DKPromiseRetryWorkBlock work){
        return [self attempts:count delay:interval condition:predicate retry:work];
    };
}

+(DKPromise *(^)(dispatch_queue_t, NSInteger, NSTimeInterval, DKPromiseRetryPredicateBlock, DKPromiseRetryWorkBlock))againOnAgainRetry{
    return ^(dispatch_queue_t queue, NSInteger count, NSTimeInterval interval, DKPromiseRetryPredicateBlock predicate, DKPromiseRetryWorkBlock work){
        return [self onQueue:queue attempts:count delay:interval condition:predicate retry:work];
    };
}


@end
