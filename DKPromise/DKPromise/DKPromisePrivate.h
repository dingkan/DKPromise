//
//  DKPromisePrivate.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/23.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise.h"

NS_ASSUME_NONNULL_BEGIN

@interface DKPromise<Value>()

typedef void(^DKPromiseOnFulFillBlock)(Value __nullable value) NS_SWIFT_UNAVAILABLE("");
typedef void(^DKPromiseOnRejectBlock)(NSError *error) NS_SWIFT_UNAVAILABLE("");

typedef id __nullable (^ __nullable DKPromiseChainedFulfillBlock)(Value __nullable value) NS_SWIFT_UNAVAILABLE("");
typedef id __nullable (^ __nullable DKPromiseChainedRejectBlock)(NSError *error) NS_SWIFT_UNAVAILABLE("");

-(instancetype)initPending NS_SWIFT_UNAVAILABLE("");

-(instancetype)initWithResolution:(nullable id)resolution NS_SWIFT_UNAVAILABLE("");


-(void)observeOnQueue:(dispatch_queue_t)queue
              fulfill:(DKPromiseOnFulFillBlock)onFulFill
               reject:(DKPromiseOnRejectBlock)onReject NS_SWIFT_UNAVAILABLE("");

//链式传递处理
-(DKPromise *)chainOnQueue:(dispatch_queue_t)queue
            chainedFulFill:(DKPromiseChainedFulfillBlock)chainedFulFill
             chainedReject:(DKPromiseChainedRejectBlock)chainedReject;
@end


NS_ASSUME_NONNULL_END
