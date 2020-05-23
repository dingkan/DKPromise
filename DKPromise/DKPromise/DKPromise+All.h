//
//  DKPromise+All.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/23.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise.h"

NS_ASSUME_NONNULL_BEGIN

@interface DKPromise (All)

+(DKPromise <NSArray *>*)all:(NSArray *)promises NS_SWIFT_UNAVAILABLE("");

+(DKPromise <NSArray *>*)onQueue:(dispatch_queue_t)queue
                             all:(NSArray *)promises NS_SWIFT_UNAVAILABLE("");

@end

NS_ASSUME_NONNULL_END
