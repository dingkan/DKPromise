//
//  DKPromise+Validate.m
//  DKPromise
//
//  Created by 丁侃 on 2020/5/27.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise+Validate.h"
#import "DKPromisePrivate.h"

@implementation DKPromise (Validate)


-(DKPromise *)validate:(DKPromiseValidateWorkBlock)predicate NS_SWIFT_UNAVAILABLE(""){
    return [self onQueue:DKPromise.defaultDispatchQueue validate:predicate];
}

-(DKPromise *)onQueue:(dispatch_queue_t)queue
             validate:(DKPromiseValidateWorkBlock)predicate  NS_SWIFT_UNAVAILABLE(""){
    NSParameterAssert(queue);
    NSParameterAssert(predicate);
    
    DKPromiseChainedFulfillBlock chainFulfill = ^id(id value){
        return predicate(value) ? value : [NSError errorWithDomain:DKPromiseErrorDomain code:DKPromiseErrorCodeValidationFailure userInfo:nil];
    };
    
    return [self chainOnQueue:queue chainedFulFill:chainFulfill chainedReject:nil];
}
@end


@implementation DKPromise(DotSyntax_ValidateAdditions)

-(DKPromise *(^)(DKPromiseValidateWorkBlock))predicate{
    return ^(DKPromiseValidateWorkBlock work){
        return [self validate:work];
    };
}

-(DKPromise *(^)(dispatch_queue_t, DKPromiseValidateWorkBlock))onPredicate{
    return ^(dispatch_queue_t queue, DKPromiseValidateWorkBlock work){
        return [self onQueue:queue validate:work];
    };
}

@end
