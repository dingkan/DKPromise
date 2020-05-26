//
//  DKPromise+Race.m
//  DKPromise
//
//  Created by 丁侃 on 2020/5/26.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise+Race.h"
#import "DKPromise+Async.h"
#import "DKPromisePrivate.h"

@implementation DKPromise (Race)

+(instancetype)race:(NSArray *)promises NS_SWIFT_UNAVAILABLE(""){
    return [self onQueue:DKPromise.defaultDispatchQueue race:promises];
}

+(instancetype)onQueue:(dispatch_queue_t)queue
                  race:(NSArray *)promises NS_SWIFT_UNAVAILABLE(""){
    
    NSParameterAssert(queue);
    NSAssert(promises.count > 0, @"No promises to observer");
    
    NSMutableArray *allPromises = [promises mutableCopy];
    return [self onQueue:queue async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        for (id promise in allPromises) {
            if (![promise isKindOfClass:self]) {
                fulfill(promise);
                return;
            }
        }
        
        for (DKPromise *promise in allPromises) {
            [promise observeOnQueue:queue fulfill:fulfill reject:reject];
        }
    }];
}
@end


@implementation DKPromise(DotSyntax_RaceAdditions)

+(DKPromise *(^)(NSArray *))race{
    return ^(NSArray *promises){
        return [self race:promises];
    };
}

+(DKPromise *(^)(dispatch_queue_t, NSArray *))onRace{
    return ^(dispatch_queue_t queue, NSArray *promises){
        return [self onQueue:queue race:promises];
    };
}

@end
