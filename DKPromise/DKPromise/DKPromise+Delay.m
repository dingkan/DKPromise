//
//  DKPromise+Delay.m
//  DKPromise
//
//  Created by 丁侃 on 2020/5/26.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise+Delay.h"
#import "DKPromisePrivate.h"

@implementation DKPromise (Delay)

-(DKPromise *)delay:(NSTimeInterval)interval NS_SWIFT_UNAVAILABLE(""){
    return [self onQueue:DKPromise.defaultDispatchQueue delay:interval];
}

-(DKPromise *)onQueue:(dispatch_queue_t)queue
                delay:(NSTimeInterval)interval NS_SWIFT_UNAVAILABLE(""){
    NSParameterAssert(queue);
    NSParameterAssert(interval);
    
    DKPromise *promise = [[DKPromise alloc]initPending];
    
    [promise observeOnQueue:queue fulfill:^(id  _Nullable value) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [promise  fulfill:value];
        });
        
    } reject:^(NSError * _Nonnull error) {
        [promise reject:error];
    }];
    
    return promise;
}

@end

@implementation DKPromise(DotSyntax_DelayAdditions)

-(DKPromise *(^)(NSTimeInterval))delay{
    return ^(NSTimeInterval interval){
        return [self delay:interval];
    };
}

-(DKPromise *(^)(dispatch_queue_t, NSTimeInterval))onDelay{
    return ^(dispatch_queue_t queue, NSTimeInterval interval){
        return [self onQueue:queue delay:interval];
    };
}

@end
