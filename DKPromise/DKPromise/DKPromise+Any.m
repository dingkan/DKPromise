//
//  DKPromise+Any.m
//  DKPromise
//
//  Created by 丁侃 on 2020/5/26.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise+Any.h"
#import "DKPromisePrivate.h"
#import "DKPromise+Async.h"
#import "DKPromise+Testing.h"

@implementation DKPromise (Any)

static NSArray *DKPromiseCombineValuesAndErrors(NSArray <DKPromise *>* promises){
    NSMutableArray *combineValuesAndErrors = [NSMutableArray array];
    for (DKPromise *promise in promises) {
        if (promise.isFulFilled) {
            [combineValuesAndErrors addObject:promise.value ?: [NSNull null]];
            continue;
        }
        
        if (promise.isRejected) {
            [combineValuesAndErrors addObject:promise.error];
            continue;
        }
        
        assert(!promise.isPending);
    }
    
    return combineValuesAndErrors;
}


+(DKPromise <NSArray *>*)any:(NSArray *)promises NS_SWIFT_UNAVAILABLE(""){
    return [self onQueue:DKPromise.defaultDispatchQueue any:promises];
}

+(DKPromise <NSArray *>*)onQueue:(dispatch_queue_t)queue
                             any:(NSArray *)promises NS_SWIFT_UNAVAILABLE(""){
    NSParameterAssert(queue);
    NSParameterAssert(promises);
    
    if (promises.count == 0) {
        return [[DKPromise alloc] initWithResolution:@[]];
    }
    
    NSMutableArray *allPromise = [promises mutableCopy];
    return [DKPromise onQueue:queue async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
       
        //筛选数据
        for (int i = 0; i < allPromise.count; i ++) {
            id promise = allPromise[i];
            if ([promise isKindOfClass:[DKPromise class]]) {
                continue;
            }else{
                [allPromise replaceObjectAtIndex:i withObject:[[DKPromise alloc] initWithResolution:promise]];
            }
        }
        
        for (DKPromise *promise in allPromise) {
            [promise observeOnQueue:queue fulfill:^(id  _Nullable value) {
               
                for (DKPromise *inPromise in allPromise) {
                    if (inPromise.isPending) {
                        return;
                    }
                }
                
                fulfill(DKPromiseCombineValuesAndErrors(promises));
                
            } reject:^(NSError * _Nonnull error) {
                BOOL atLeastOneIsFulfill = NO;
                for (DKPromise *promise in promises) {
                    if (promise.isPending) {
                        return;
                    }
                    
                    if (promise.isFulFilled) {
                        atLeastOneIsFulfill = YES;
                    }
                }
                
                if (atLeastOneIsFulfill) {
                    fulfill(DKPromiseCombineValuesAndErrors(promises));
                }else{
                    reject(error);
                }
            }];
        }
        
    }];
    
}
@end


@implementation DKPromise(DotSyntax_AnyAdditions)

+(DKPromise <NSArray *>*(^)(NSArray *))any{
    return ^(NSArray *promises){
        return [self any:promises];
    };
}

+(DKPromise <NSArray *>*(^)(dispatch_queue_t, NSArray *))onAny{
    return ^(dispatch_queue_t queue, NSArray *promises){
        return [self onQueue:queue any:promises];
    };
}

@end
