//
//  DKPromise+always.m
//  DKPromise
//
//  Created by 丁侃 on 2020/5/26.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise+always.h"
#import "DKPromisePrivate.h"

@implementation DKPromise (always)
-(DKPromise *)always:(DKPromiseAlwaysWorkBlock)work NS_SWIFT_UNAVAILABLE(""){
    return [self onQueue:DKPromise.defaultDispatchQueue always:work];
}

-(DKPromise *)onQueue:(dispatch_queue_t)queue
               always:(DKPromiseAlwaysWorkBlock)work NS_SWIFT_UNAVAILABLE(""){
    NSParameterAssert(queue);
    NSParameterAssert(work);
    
    return [self chainOnQueue:queue chainedFulFill:^id(id value){
        work();
        return value;
    }chainedReject:^id(NSError *error){
        work();
        return error;
    }];
    
}
@end


@implementation DKPromise(DotSyntax_alwaysAdditions)

-(DKPromise *(^)(DKPromiseAlwaysWorkBlock))always{
    return ^(DKPromiseAlwaysWorkBlock work){
        return [self always:work];
    };
}

-(DKPromise *(^)(dispatch_queue_t, DKPromiseAlwaysWorkBlock))onAlways{
    return ^(dispatch_queue_t queue, DKPromiseAlwaysWorkBlock work){
        return [self onQueue:queue always:work];
    };
}

@end


