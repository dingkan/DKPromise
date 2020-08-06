//
//  WDZPromise+Testing.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/27.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "WDZPromise.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDZPromise<Value> (Testing)

@property (nonatomic, readonly, class) dispatch_group_t defaultGroup NS_SWIFT_UNAVAILABLE("");

@property (nonatomic, readonly) BOOL isPending NS_SWIFT_UNAVAILABLE("");

@property (nonatomic, readonly) BOOL isFulfilled NS_SWIFT_UNAVAILABLE("");

@property (nonatomic, readonly) BOOL isRejected NS_SWIFT_UNAVAILABLE("");

@property (nonatomic, readonly, nullable) Value value NS_SWIFT_UNAVAILABLE("");

@property (nonatomic, readonly, nullable) NSError *error NS_SWIFT_UNAVAILABLE("");
@end

NS_ASSUME_NONNULL_END
