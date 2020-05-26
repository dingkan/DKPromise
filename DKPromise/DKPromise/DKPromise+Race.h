//
//  DKPromise+Race.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/26.
//  Copyright © 2020 丁侃. All rights reserved.
//

//判断promises 中是否有promise操作 如果存在非promise则之间返回。  如果都是promise，会让所有promise执行，最先异步操作结束的直接返回

#import "DKPromise.h"

NS_ASSUME_NONNULL_BEGIN

@interface DKPromise<Value> (Race)

+(instancetype)race:(NSArray *)promises NS_SWIFT_UNAVAILABLE("");

+(instancetype)onQueue:(dispatch_queue_t)queue
                  race:(NSArray *)promises NS_SWIFT_UNAVAILABLE("");

@end
@interface DKPromise<Value>(DotSyntax_RaceAdditions)

+(DKPromise *(^)(NSArray *))race;

+(DKPromise *(^)(dispatch_queue_t, NSArray *))onRace;
@end

NS_ASSUME_NONNULL_END
