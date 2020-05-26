//
//  DKPromise+Await.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/26.
//  Copyright © 2020 丁侃. All rights reserved.
//

//等到传进来的promise的异步回调执行完毕后，返回结果
#import "DKPromise.h"

NS_ASSUME_NONNULL_BEGIN
id __nullable DKPromiseAwait(DKPromise *promise,
                             NSError **outError) NS_SWIFT_UNAVAILABLE("");


NS_ASSUME_NONNULL_END
