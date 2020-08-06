//
//  WDZPromise+Then.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/27.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "WDZPromise.h"

NS_ASSUME_NONNULL_BEGIN


@interface WDZPromise<Value> (Then)
typedef id __nullable (^WDZPromiseThenWorkBlock)(Value __nullable value);

-(WDZPromise *)then:(WDZPromiseThenWorkBlock)work;

-(WDZPromise *)onQueue:(dispatch_queue_t)queue
                  then:(WDZPromiseThenWorkBlock)work;

@end

NS_ASSUME_NONNULL_END
