//
//  DKPromise+Catch.m
//  DKPromise
//
//  Created by 丁侃 on 2020/5/23.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise+Catch.h"
#import "DKPromisePrivate.h"

@implementation DKPromise (Catch)

-(DKPromise *)catch:(DKPromiseCatchWorkBlock)reject{
    return [self onQueue:DKPromise.defaultDispatchQueue catch:reject];
}

-(DKPromise *)onQueue:(dispatch_queue_t)queue
                catch:(DKPromiseCatchWorkBlock)reject {
    NSParameterAssert(queue);
    NSParameterAssert(reject);
    
    return [self chainOnQueue:queue chainedFulFill:nil chainedReject:^id(NSError *error){
        !reject?:reject(error);
        return error;
    }];
}
@end


@implementation DKPromise (DotSyntax_CatchAdditions)

-(DKPromise *(^)(DKPromiseCatchWorkBlock))catch{
    return ^(DKPromiseCatchWorkBlock catch){
        return [self catch:catch];
    };
}

-(DKPromise *(^)(dispatch_queue_t, DKPromiseCatchWorkBlock))catchOn{
    return ^(dispatch_queue_t queue, DKPromiseCatchWorkBlock catch){
        return [self onQueue:queue catch:catch];
    };
}

@end
