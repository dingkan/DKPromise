//
//  DKPromise+Recover.m
//  DKPromise
//
//  Created by 丁侃 on 2020/5/26.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise+Recover.h"
#import "DKPromisePrivate.h"

@implementation DKPromise (Recover)

-(DKPromise *)recover:(DKPromiseRecoverWorkBlock)work NS_SWIFT_UNAVAILABLE(""){
    return [self onQueue:DKPromise.defaultDispatchQueue recover:work];
}

-(DKPromise *)onQueue:(dispatch_queue_t)queue
              recover:(DKPromiseRecoverWorkBlock)work NS_SWIFT_UNAVAILABLE(""){
    NSParameterAssert(queue);
    NSParameterAssert(work);
    
    return [self chainOnQueue:queue chainedFulFill:nil chainedReject:^id(NSError *error){
        return work(error);
    }];
}
@end

@implementation DKPromise(DotSyntax_RecoverAdditions)

-(DKPromise *(^)(DKPromiseRecoverWorkBlock))recover{
    return ^(DKPromiseRecoverWorkBlock work){
        return [self recover:work];
    };
}

-(DKPromise *(^)(dispatch_queue_t, DKPromiseRecoverWorkBlock))onRecover{
    return ^(dispatch_queue_t queue, DKPromiseRecoverWorkBlock work){
        return [self onQueue:queue recover:work];
    };
}

@end
