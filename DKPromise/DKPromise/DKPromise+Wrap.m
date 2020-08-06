//
//  DKPromise+Wrap.m
//  DKPromise
//
//  Created by 丁侃 on 2020/5/27.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise+Wrap.h"
#import "DKPromisePrivate.h"
#import "DKPromise+Async.h"

@implementation DKPromise (Wrap)
+(DKPromise <NSNumber *>*)wrapCompletion:(void(^)(DKPromiseCompletion))work{
    return [self onQueue:DKPromise.defaultDispatchQueue wrapCompletion:work];
}

+(DKPromise <NSNumber *>*)onQueue:(dispatch_queue_t)queue
      wrapCompletion:(void(^)(DKPromiseCompletion))work{
    NSParameterAssert(queue);
    NSParameterAssert(work);
    
    return [self onQueue:queue async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        work(^{
            fulfill(nil);
        });
    }];
}


+(DKPromise <NSNumber *>*)wrapObjectCompletion:(void(^)(DKPromiseObjectCompletion))work{
    return [self onQueue:DKPromise.defaultDispatchQueue wrapObjectCompletion:work];
}

+(DKPromise <NSNumber *>*)onQueue:(dispatch_queue_t)queue
      wrapObjectCompletion:(void(^)(DKPromiseObjectCompletion))work{
    NSParameterAssert(queue);
    NSParameterAssert(work);
    
    return [self onQueue:queue async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        work(^(id __nullable value){
            
            fulfill(value);
            
        });
    }];
}

+(DKPromise <NSNumber *>*)wrapErrorCompletion:(void(^)(DKPromiseErrorCompletion))work{
    return [self onQueue:DKPromise.defaultDispatchQueue wrapErrorCompletion:work];
}

+(DKPromise <NSNumber *>*)onQueue:(dispatch_queue_t)queue
      wrapErrorCompletion:(void(^)(DKPromiseErrorCompletion))work{
    NSParameterAssert(queue);
    NSParameterAssert(work);
    
    return [self onQueue:queue async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        work(^(NSError *__nullable error){
            
            if (error) {
                reject(error);
            }else{
                fulfill(nil);
            }
            
        });
    }];
}

+(DKPromise <NSNumber *>*)wrapObjectOrErrorCompletion:(void(^)(DKPromiseErrorOrObjectCompletion))work{
    return [self onQueue:DKPromise.defaultDispatchQueue wrapObjectOrErrorCompletion:work];
}

+(DKPromise <NSNumber *>*)onQueue:(dispatch_queue_t)queue
      wrapObjectOrErrorCompletion:(void(^)(DKPromiseErrorOrObjectCompletion))work{
    NSParameterAssert(queue);
    NSParameterAssert(work);
    
    return [self onQueue:queue async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        work(^(id __nullable value, NSError *__nullable error){
            
            if (error) {
                reject(error);
            }else{
                fulfill(value);
            }
            
        });
    }];
}


+(DKPromise <NSNumber *>*)wrapErrorOrObjectCompletion:(void(^)(DKPromiseErrorOrObjectCompletion))work{
    return [self onQueue:DKPromise.defaultDispatchQueue wrapErrorOrObjectCompletion:work];
}

+(DKPromise <NSNumber *>*)onQueue:(dispatch_queue_t)queue
      wrapErrorOrObjectCompletion:(void(^)(DKPromiseErrorOrObjectCompletion))work{
    NSParameterAssert(queue);
    NSParameterAssert(work);
    
    return [self onQueue:queue async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        work(^(NSError *__nullable error, id __nullable value){
            
            if (error) {
                reject(error);
            }else{
                fulfill(value);
            }
            
        });
    }];
}


+(DKPromise <NSNumber *>*)wrap2ObjectOrErrorCompletion:(void(^)(DKPromise2ObjectOrErrorCompletion))work{
    return [self onQueue:DKPromise.defaultDispatchQueue wrap2ObjectOrErrorCompletion:work];
}

+(DKPromise <NSNumber *>*)onQueue:(dispatch_queue_t)queue
      wrap2ObjectOrErrorCompletion:(void(^)(DKPromise2ObjectOrErrorCompletion))work{
    NSParameterAssert(queue);
    NSParameterAssert(work);
    
    return [self onQueue:queue async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        work(^(id __nullable value1, id __nullable value2, NSError *__nullable error){
            
            if (error) {
                reject(error);
            }else{
                fulfill(@[value1, value2]);
            }
            
        });
    }];
}



+(DKPromise <NSNumber *>*)wrapBOOlCompletion:(void(^)(DKPromiseBoolCompletion))work{
    return [self onQueue:DKPromise.defaultDispatchQueue wrapBOOlCompletion:work];
}

+(DKPromise <NSNumber *>*)onQueue:(dispatch_queue_t)queue
             wrapBOOlCompletion:(void(^)(DKPromiseBoolCompletion))work{
    NSParameterAssert(queue);
    NSParameterAssert(work);
    
    return [self onQueue:queue async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        
        work(^(BOOL value){
            
            fulfill(@(value));
            
        });
        
    }];
}


+(DKPromise <NSNumber *>*)wrapBoolOrErrorCompletion:(void(^)(DKPromiseBOOLOrErrorCompletion))work{
    return [self onQueue:DKPromise.defaultDispatchQueue wrapBoolOrErrorCompletion:work];
}

+(DKPromise <NSNumber *>*)onQueue:(dispatch_queue_t)queue
      wrapBoolOrErrorCompletion:(void(^)(DKPromiseBOOLOrErrorCompletion))work{
    NSParameterAssert(queue);
    NSParameterAssert(work);
    
    return [self onQueue:queue async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        work(^(BOOL value, NSError *__nullable error){
            
            if (error) {
                reject(error);
            }else{
                fulfill(@(value));
            }
            
        });
    }];
}




+(DKPromise <NSNumber *>*)wrapIntegerCompletion:(void(^)(DKPromiseIntegerCompletion))work{
    return [self onQueue:DKPromise.defaultDispatchQueue wrapIntegerCompletion:work];
}

+(DKPromise <NSNumber *>*)onQueue:(dispatch_queue_t)queue
             wrapIntegerCompletion:(void(^)(DKPromiseIntegerCompletion))work{
    NSParameterAssert(queue);
    NSParameterAssert(work);
    
    return [self onQueue:queue async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        
        work(^(NSInteger value){
            
            fulfill(@(value));
            
        });
        
    }];
}

+(DKPromise <NSNumber *>*)wrapIntegerOrErrorCompletion:(void(^)(DKPromiseIntegerOrErrorCompletion))work{
    return [self onQueue:DKPromise.defaultDispatchQueue wrapIntegerOrErrorCompletion:work];
}


+(DKPromise <NSNumber *>*)onQueue:(dispatch_queue_t)queue
             wrapIntegerOrErrorCompletion:(void(^)(DKPromiseIntegerOrErrorCompletion))work{
    NSParameterAssert(queue);
    NSParameterAssert(work);
    
    return [self onQueue:queue async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        
        work(^(NSInteger value, NSError *__nullable error){
            
                 if (error) {
                     reject(error);
                 }else{
                     fulfill(@(value));
                 }
            
        });
        
    }];
}

+(DKPromise <NSNumber *>*)wrapDoubleCompletion:(void(^)(DKPromiseDoubleCompletion))work{
    return [self onQueue:DKPromise.defaultDispatchQueue wrapDoubleCompletion:work];
}

+(DKPromise <NSNumber *>*)onQueue:(dispatch_queue_t)queue
             wrapDoubleCompletion:(void(^)(DKPromiseDoubleCompletion))work{
    NSParameterAssert(queue);
    NSParameterAssert(work);
    
    return [self onQueue:queue async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        
        work(^(double value){
            
            fulfill(@(value));
            
        });
        
    }];
}

+(DKPromise <NSNumber *>*)wrapDoubelOrErrorCompletion:(void(^)(DKPromiseDoubleOrErrorCompletion))work{
    return [self onQueue:DKPromise.defaultDispatchQueue wrapDoubleOrErrorCompletion:work];
}

+(DKPromise <NSNumber *>*)onQueue:(dispatch_queue_t)queue
      wrapDoubleOrErrorCompletion:(void(^)(DKPromiseDoubleOrErrorCompletion))work{
    NSParameterAssert(queue);
    NSParameterAssert(work);
    
    return [self onQueue:queue async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        work(^(double value, NSError *__nullable error){
            
            if (error) {
                reject(error);
            }else{
                fulfill(@(value));
            }
            
        });
    }];
}

@end

@implementation DKPromise(DotSyntax_WrapAdditions)


+ (DKPromise * (^)(void (^)(DKPromiseCompletion)))wrapCompletion {
  return ^(void (^work)(DKPromiseCompletion)) {
    return [self wrapCompletion:work];
  };
}

+ (DKPromise * (^)(dispatch_queue_t, void (^)(DKPromiseCompletion)))wrapCompletionOn {
  return ^(dispatch_queue_t queue, void (^work)(DKPromiseCompletion)) {
    return [self onQueue:queue wrapCompletion:work];
  };
}

+ (DKPromise * (^)(void (^)(DKPromiseObjectCompletion)))wrapObjectCompletion {
  return ^(void (^work)(DKPromiseObjectCompletion)) {
    return [self wrapObjectCompletion:work];
  };
}

+ (DKPromise * (^)(dispatch_queue_t, void (^)(DKPromiseObjectCompletion)))wrapObjectCompletionOn {
  return ^(dispatch_queue_t queue, void (^work)(DKPromiseObjectCompletion)) {
    return [self onQueue:queue wrapObjectCompletion:work];
  };
}

+ (DKPromise * (^)(void (^)(DKPromiseErrorCompletion)))wrapErrorCompletion {
  return ^(void (^work)(DKPromiseErrorCompletion)) {
    return [self wrapErrorCompletion:work];
  };
}

+ (DKPromise * (^)(dispatch_queue_t, void (^)(DKPromiseErrorCompletion)))wrapErrorCompletionOn {
  return ^(dispatch_queue_t queue, void (^work)(DKPromiseErrorCompletion)) {
    return [self onQueue:queue wrapErrorCompletion:work];
  };
}

+ (DKPromise * (^)(void (^)(DKPromiseObjectOrErrorCompletion)))wrapObjectOrErrorCompletion {
  return ^(void (^work)(DKPromiseObjectOrErrorCompletion)) {
    return [self wrapObjectOrErrorCompletion:work];
  };
}

+ (DKPromise * (^)(dispatch_queue_t,
                    void (^)(DKPromiseObjectOrErrorCompletion)))wrapObjectOrErrorCompletionOn {
  return ^(dispatch_queue_t queue, void (^work)(DKPromiseObjectOrErrorCompletion)) {
    return [self onQueue:queue wrapObjectOrErrorCompletion:work];
  };
}

+ (DKPromise * (^)(void (^)(DKPromiseErrorOrObjectCompletion)))wrapErrorOrObjectCompletion {
  return ^(void (^work)(DKPromiseErrorOrObjectCompletion)) {
    return [self wrapErrorOrObjectCompletion:work];
  };
}

+ (DKPromise * (^)(dispatch_queue_t,
                    void (^)(DKPromiseErrorOrObjectCompletion)))wrapErrorOrObjectCompletionOn {
  return ^(dispatch_queue_t queue, void (^work)(DKPromiseErrorOrObjectCompletion)) {
    return [self onQueue:queue wrapErrorOrObjectCompletion:work];
  };
}

+ (DKPromise<NSArray *> * (^)(void (^)(DKPromise2ObjectOrErrorCompletion)))
    wrap2ObjectsOrErrorCompletion {
  return ^(void (^work)(DKPromise2ObjectOrErrorCompletion)) {
    return [self wrap2ObjectOrErrorCompletion:work];
  };
}

+ (DKPromise<NSArray *> * (^)(dispatch_queue_t, void (^)(DKPromise2ObjectOrErrorCompletion)))
    wrap2ObjectsOrErrorCompletionOn {
  return ^(dispatch_queue_t queue, void (^work)(DKPromise2ObjectOrErrorCompletion)) {
    return [self onQueue:queue wrap2ObjectOrErrorCompletion:work];
  };
}

+ (DKPromise<NSNumber *> * (^)(void (^)(DKPromiseBoolCompletion)))wrapBoolCompletion {
  return ^(void (^work)(DKPromiseBoolCompletion)) {
    return [self wrapBOOlCompletion:work];
  };
}

+ (DKPromise<NSNumber *> * (^)(dispatch_queue_t,
                                void (^)(DKPromiseBoolCompletion)))wrapBoolCompletionOn {
  return ^(dispatch_queue_t queue, void (^work)(DKPromiseBoolCompletion)) {
    return [self onQueue:queue wrapBOOlCompletion:work];
  };
}

+ (DKPromise<NSNumber *> * (^)(void (^)(DKPromiseBOOLOrErrorCompletion)))
    wrapBoolOrErrorCompletion {
  return ^(void (^work)(DKPromiseBOOLOrErrorCompletion)) {
    return [self wrapBoolOrErrorCompletion:work];
  };
}

+ (DKPromise<NSNumber *> * (^)(dispatch_queue_t, void (^)(DKPromiseBOOLOrErrorCompletion)))
    wrapBoolOrErrorCompletionOn {
  return ^(dispatch_queue_t queue, void (^work)(DKPromiseBOOLOrErrorCompletion)) {
    return [self onQueue:queue wrapBoolOrErrorCompletion:work];
  };
}

+ (DKPromise<NSNumber *> * (^)(void (^)(DKPromiseIntegerCompletion)))wrapIntegerCompletion {
  return ^(void (^work)(DKPromiseIntegerCompletion)) {
    return [self wrapIntegerCompletion:work];
  };
}

+ (DKPromise<NSNumber *> * (^)(dispatch_queue_t,
                                void (^)(DKPromiseIntegerCompletion)))wrapIntegerCompletionOn {
  return ^(dispatch_queue_t queue, void (^work)(DKPromiseIntegerCompletion)) {
    return [self onQueue:queue wrapIntegerCompletion:work];
  };
}

+ (DKPromise<NSNumber *> * (^)(void (^)(DKPromiseIntegerOrErrorCompletion)))
    wrapIntegerOrErrorCompletion {
  return ^(void (^work)(DKPromiseIntegerOrErrorCompletion)) {
    return [self wrapIntegerOrErrorCompletion:work];
  };
}

+ (DKPromise<NSNumber *> * (^)(dispatch_queue_t, void (^)(DKPromiseIntegerOrErrorCompletion)))
    wrapIntegerOrErrorCompletionOn {
  return ^(dispatch_queue_t queue, void (^work)(DKPromiseIntegerOrErrorCompletion)) {
    return [self onQueue:queue wrapIntegerOrErrorCompletion:work];
  };
}

+ (DKPromise<NSNumber *> * (^)(void (^)(DKPromiseDoubleCompletion)))wrapDoubleCompletion {
  return ^(void (^work)(DKPromiseDoubleCompletion)) {
    return [self wrapDoubleCompletion:work];
  };
}

+ (DKPromise<NSNumber *> * (^)(dispatch_queue_t,
                                void (^)(DKPromiseDoubleCompletion)))wrapDoubleCompletionOn {
  return ^(dispatch_queue_t queue, void (^work)(DKPromiseDoubleCompletion)) {
      return [self onQueue:queue wrapDoubleCompletion:work];
  };
}

+ (DKPromise<NSNumber *> * (^)(void (^)(DKPromiseDoubleOrErrorCompletion)))
    wrapDoubleOrErrorCompletion {
  return ^(void (^work)(DKPromiseDoubleOrErrorCompletion)) {
    return [self wrapDoubelOrErrorCompletion:work];
  };
}

+ (DKPromise<NSNumber *> * (^)(dispatch_queue_t, void (^)(DKPromiseDoubleOrErrorCompletion)))
    wrapDoubleOrErrorCompletionOn {
  return ^(dispatch_queue_t queue, void (^work)(DKPromiseDoubleOrErrorCompletion)) {
    return [self onQueue:queue wrapDoubleOrErrorCompletion:work];
  };
}


@end
