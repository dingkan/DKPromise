//
//  DKPromise+Do.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/23.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise.h"

NS_ASSUME_NONNULL_BEGIN

@interface DKPromise<Value> (Do)

typedef id __nullable(^DDKPromiseDoWorkBlock)(void) NS_SWIFT_UNAVAILABLE("");

+(instancetype)do:(DDKPromiseDoWorkBlock)work NS_SWIFT_UNAVAILABLE("");

+(instancetype)onQueue:(dispatch_queue_t)queue do:(DDKPromiseDoWorkBlock)work NS_SWIFT_UNAVAILABLE("");

@end

@interface DKPromise<Value> (DotSyntax_DoAdditions)

+(DKPromise *(^)(dispatch_queue_t, DDKPromiseDoWorkBlock))doOn;
@end

NS_ASSUME_NONNULL_END
