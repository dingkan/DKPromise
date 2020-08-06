//
//  DKPromise+Testing.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/22.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise.h"


NS_ASSUME_NONNULL_BEGIN

BOOL DKWaitForPromisesWithTimeout(NSTimeInterval timeout) NS_REFINED_FOR_SWIFT;
@interface DKPromise<Value> (Testing)

@property (nonatomic, class, readonly) dispatch_group_t dispatchGroup NS_REFINED_FOR_SWIFT;

@property (nonatomic, readonly) BOOL isPending NS_REFINED_FOR_SWIFT;

@property (nonatomic, readonly) BOOL isFulFilled NS_REFINED_FOR_SWIFT;

@property (nonatomic, readonly) BOOL isRejected NS_REFINED_FOR_SWIFT;

@property (nonatomic, readonly, nullable) Value value NS_REFINED_FOR_SWIFT;

@property (nonatomic, readonly, nullable) NSError *error NS_REFINED_FOR_SWIFT;

@end


NS_ASSUME_NONNULL_END
