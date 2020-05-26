//
//  DKPromise+Any.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/26.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise.h"

//只要promises中有一个promise是fulfill成功回调的，就执行fulfill异步回调，如果所有异步都是rehject，则会走reject回调返回所以结果

NS_ASSUME_NONNULL_BEGIN

@interface DKPromise<Value> (Any)

+(DKPromise <NSArray *>*)any:(NSArray *)promises NS_SWIFT_UNAVAILABLE("");

+(DKPromise <NSArray *>*)onQueue:(dispatch_queue_t)queue
                             any:(NSArray *)promises NS_SWIFT_UNAVAILABLE("");

@end

@interface DKPromise<Value> (DotSyntax_AnyAdditions)


+(DKPromise <NSArray *>*(^)(NSArray *))any;
+(DKPromise <NSArray *>*(^)(dispatch_queue_t, NSArray *))onAny;

@end

NS_ASSUME_NONNULL_END
