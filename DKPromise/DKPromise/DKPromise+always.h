//
//  DKPromise+always.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/26.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise.h"

NS_ASSUME_NONNULL_BEGIN

@interface DKPromise<Value> (always)

typedef void(^DKPromiseAlwaysWorkBlock)(void) NS_SWIFT_UNAVAILABLE("");

-(DKPromise *)always:(DKPromiseAlwaysWorkBlock)work NS_SWIFT_UNAVAILABLE("");

-(DKPromise *)onQueue:(dispatch_queue_t)queue
               always:(DKPromiseAlwaysWorkBlock)work NS_SWIFT_UNAVAILABLE("");
@end

@interface DKPromise<Value> (DotSyntax_alwaysAdditions)

-(DKPromise *(^)(DKPromiseAlwaysWorkBlock))always;

-(DKPromise *(^)(dispatch_queue_t, DKPromiseAlwaysWorkBlock))onAlways;
@end

NS_ASSUME_NONNULL_END
