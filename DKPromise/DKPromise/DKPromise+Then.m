//
//  DKPromise+Then.m
//  DKPromise
//
//  Created by 丁侃 on 2020/5/23.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise+Then.h"
#import "DKPromisePrivate.h"

@implementation DKPromise (Then)
-(DKPromise *)then:(DKPromiseThenWorkBlock)work{
    return [self onQueue:DKPromise.defaultDispatchQueue then:work];
}

-(DKPromise *)onQueue:(dispatch_queue_t)queue
                 then:(DKPromiseThenWorkBlock)work{
    NSParameterAssert(queue);
    NSParameterAssert(work);
    
    return [self chainOnQueue:queue chainedFulFill:work chainedReject:nil];
}
@end

@implementation DKPromise (DotSyntax_ThenAdditions)

-(DKPromise *(^)(DKPromiseThenWorkBlock))then{
    return ^(DKPromiseThenWorkBlock work){
        return [self then:work];
    };
}

-(DKPromise *(^)(dispatch_queue_t, DKPromiseThenWorkBlock))thenOn{
    return ^(dispatch_queue_t queue, DKPromiseThenWorkBlock work){
        return [self onQueue:queue then:work];
    };
}

@end
