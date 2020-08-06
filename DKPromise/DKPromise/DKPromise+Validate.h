//
//  DKPromise+Validate.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/27.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise.h"

NS_ASSUME_NONNULL_BEGIN

@interface DKPromise<Value> (Validate)

typedef BOOL(^DKPromiseValidateWorkBlock)(Value __nullable value) NS_SWIFT_UNAVAILABLE("");

-(DKPromise *)validate:(DKPromiseValidateWorkBlock)predicate NS_SWIFT_UNAVAILABLE("");

-(DKPromise *)onQueue:(dispatch_queue_t)queue
        validate:(DKPromiseValidateWorkBlock)predicate  NS_SWIFT_UNAVAILABLE("");


@end

@interface DKPromise<Value>(DotSyntax_ValidateAdditions)


-(DKPromise *(^)(DKPromiseValidateWorkBlock))predicate;

-(DKPromise *(^)(dispatch_queue_t, DKPromiseValidateWorkBlock))onPredicate;
@end

NS_ASSUME_NONNULL_END
