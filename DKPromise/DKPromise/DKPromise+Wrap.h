//
//  DKPromise+Wrap.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/27.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise.h"

NS_ASSUME_NONNULL_BEGIN


@interface DKPromise<Value> (Wrap)

typedef void(^DKPromiseCompletion)(void) NS_SWIFT_UNAVAILABLE("");
typedef void(^DKPromiseObjectCompletion)(id __nullable) NS_SWIFT_UNAVAILABLE("");
typedef void(^DKPromiseErrorCompletion)(NSError *__nullable) NS_SWIFT_UNAVAILABLE("");
typedef void(^DKPromiseObjectOrErrorCompletion)(id __nullable, NSError *__nullable) NS_SWIFT_UNAVAILABLE("");
typedef void(^DKPromiseErrorOrObjectCompletion)(NSError *__nullable, id __nullable) NS_SWIFT_UNAVAILABLE("");
typedef void(^DKPromise2ObjectOrErrorCompletion)(id __nullable, id __nullable, NSError *__nullable) NS_SWIFT_UNAVAILABLE("");
typedef void(^DKPromiseBoolCompletion)(BOOL) NS_SWIFT_UNAVAILABLE("");
typedef void(^DKPromiseBOOLOrErrorCompletion)(BOOL, NSError *__nullable) NS_SWIFT_UNAVAILABLE("");
typedef void(^DKPromiseIntegerCompletion)(NSInteger) NS_SWIFT_UNAVAILABLE("");
typedef void(^DKPromiseIntegerOrErrorCompletion)(NSInteger, NSError *__nullable) NS_SWIFT_UNAVAILABLE("");
typedef void(^DKPromiseDoubleCompletion)(double) NS_SWIFT_UNAVAILABLE("");
typedef void(^DKPromiseDoubleOrErrorCompletion)(double, NSError *__nullable) NS_SWIFT_UNAVAILABLE("");


@end


@interface DKPromise<Value>(DotSyntax_WrapAdditions)
+ (DKPromise * (^)(void (^)(DKPromiseCompletion)))wrapCompletion;

+ (DKPromise * (^)(dispatch_queue_t, void (^)(DKPromiseCompletion)))wrapCompletionOn;

+ (DKPromise * (^)(void (^)(DKPromiseObjectCompletion)))wrapObjectCompletion;

+ (DKPromise * (^)(dispatch_queue_t, void (^)(DKPromiseObjectCompletion)))wrapObjectCompletionOn;

+ (DKPromise * (^)(void (^)(DKPromiseErrorCompletion)))wrapErrorCompletion;

+ (DKPromise * (^)(dispatch_queue_t, void (^)(DKPromiseErrorCompletion)))wrapErrorCompletionOn;

+ (DKPromise * (^)(void (^)(DKPromiseObjectOrErrorCompletion)))wrapObjectOrErrorCompletion;

+ (DKPromise * (^)(dispatch_queue_t,
                    void (^)(DKPromiseObjectOrErrorCompletion)))wrapObjectOrErrorCompletionOn;

+ (DKPromise * (^)(void (^)(DKPromiseErrorOrObjectCompletion)))wrapErrorOrObjectCompletion ;

+ (DKPromise * (^)(dispatch_queue_t,
                    void (^)(DKPromiseErrorOrObjectCompletion)))wrapErrorOrObjectCompletionOn;

+ (DKPromise<NSArray *> * (^)(void (^)(DKPromise2ObjectOrErrorCompletion)))
    wrap2ObjectsOrErrorCompletion ;

+ (DKPromise<NSArray *> * (^)(dispatch_queue_t, void (^)(DKPromise2ObjectOrErrorCompletion)))
    wrap2ObjectsOrErrorCompletionOn;

+ (DKPromise<NSNumber *> * (^)(void (^)(DKPromiseBoolCompletion)))wrapBoolCompletion ;

+ (DKPromise<NSNumber *> * (^)(dispatch_queue_t,
                                void (^)(DKPromiseBoolCompletion)))wrapBoolCompletionOn;

+ (DKPromise<NSNumber *> * (^)(void (^)(DKPromiseBOOLOrErrorCompletion)))
    wrapBoolOrErrorCompletion ;

+ (DKPromise<NSNumber *> * (^)(dispatch_queue_t, void (^)(DKPromiseBOOLOrErrorCompletion)))
    wrapBoolOrErrorCompletionOn ;

+ (DKPromise<NSNumber *> * (^)(void (^)(DKPromiseIntegerCompletion)))wrapIntegerCompletion;

+ (DKPromise<NSNumber *> * (^)(dispatch_queue_t,
                                void (^)(DKPromiseIntegerCompletion)))wrapIntegerCompletionOn ;

+ (DKPromise<NSNumber *> * (^)(void (^)(DKPromiseIntegerOrErrorCompletion)))
    wrapIntegerOrErrorCompletion ;

+ (DKPromise<NSNumber *> * (^)(dispatch_queue_t, void (^)(DKPromiseIntegerOrErrorCompletion)))
    wrapIntegerOrErrorCompletionOn;

+ (DKPromise<NSNumber *> * (^)(void (^)(DKPromiseDoubleCompletion)))wrapDoubleCompletion ;

+ (DKPromise<NSNumber *> * (^)(dispatch_queue_t,
                                void (^)(DKPromiseDoubleCompletion)))wrapDoubleCompletionOn;

+ (DKPromise<NSNumber *> * (^)(void (^)(DKPromiseDoubleOrErrorCompletion)))
    wrapDoubleOrErrorCompletion;

+ (DKPromise<NSNumber *> * (^)(dispatch_queue_t, void (^)(DKPromiseDoubleOrErrorCompletion)))
    wrapDoubleOrErrorCompletionOn;
@end

NS_ASSUME_NONNULL_END
