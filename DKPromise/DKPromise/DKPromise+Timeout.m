//
//  DKPromise+Timeout.m
//  DKPromise
//
//  Created by 丁侃 on 2020/5/23.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise+Timeout.h"
#import "DKPromisePrivate.h"

@implementation DKPromise (Timeout)

-(DKPromise *)timeout:(NSTimeInterval)interval{
    return [self onQueue:DKPromise.defaultDispatchQueue timeout:interval];
}

-(DKPromise *)onQueue:(dispatch_queue_t)queue
              timeout:(NSTimeInterval)interval{
    NSParameterAssert(queue);
    
    DKPromise *promise = [[DKPromise alloc]initPending];
    
    [self observeOnQueue:queue fulfill:^(id  _Nullable value) {
        [promise fulfill:value];
    } reject:^(NSError * _Nonnull error) {
        [promise reject:error];
    }];
    
    typeof(self) __weak weakPromise = promise;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSError *error = [NSError errorWithDomain:DKPromiseErrorDomain code:DKPromiseErrorCodeTimeout userInfo:nil];
        [weakPromise reject:error];
    });
    return promise;
}
@end


@implementation DKPromise (Dotsyntax_TimeoutAdditions)

-(DKPromise *(^)(NSTimeInterval))timeout{
    return ^(NSTimeInterval interval){
        return [self timeout: interval];
    };
}


-(DKPromise *(^)(dispatch_queue_t, NSTimeInterval))timeoutOn{
    return ^(dispatch_queue_t queue, NSTimeInterval interval){
        return [self onQueue:queue timeout:interval];
    };
}


@end
