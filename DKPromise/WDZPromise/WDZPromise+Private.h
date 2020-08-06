//
//  WDZPromise+Private.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/27.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "WDZPromise.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDZPromise<Value> (Private)

typedef void(^WDZPromiseFulfillBlock)(Value __nullable value);
typedef void(^WDZPromiseRejectBlock)(NSError *error);

typedef __nullable id(^ __nullable ChainPromiseFulfillBlock)(Value __nullable value);
typedef __nullable id(^ __nullable ChainPromiseRejectBlock)(NSError *error);

-(instancetype)initWithPending;

-(instancetype)initWithResolution:(nullable id)resolution;

-(void)observeOnQueue:(dispatch_queue_t)queue
            fulfill:(WDZPromiseFulfillBlock)fulfill
               reject:(WDZPromiseRejectBlock)reject;

-(WDZPromise *)chainOnQueue:(dispatch_queue_t)queue
            chainFulfill:(ChainPromiseFulfillBlock)fulfill
                chainReject:(ChainPromiseRejectBlock)reject;

@end

NS_ASSUME_NONNULL_END
