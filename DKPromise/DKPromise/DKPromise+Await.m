//
//  DKPromise+Await.m
//  DKPromise
//
//  Created by 丁侃 on 2020/5/26.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise+Await.h"
#import "DKPromisePrivate.h"

id __nullable DKPromiseAwait(DKPromise *promise,
                             NSError **outError) NS_SWIFT_UNAVAILABLE(""){
    
    assert(promise);
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.dingkan.promise.Await", DISPATCH_QUEUE_CONCURRENT);
    });
    
    dispatch_semaphore_t semaphone = dispatch_semaphore_create(0);
    id __block resolution;
    NSError __block *blockError;
    
    [promise chainOnQueue:queue chainedFulFill:^id(id value){
        resolution = value;
        dispatch_semaphore_signal(semaphone);
        return value;
    }chainedReject:^id(NSError *error){
        blockError = error;
        dispatch_semaphore_signal(semaphone);
        return error;
    }];
    
    dispatch_semaphore_wait(semaphone, DISPATCH_TIME_FOREVER);
    
    if (outError) {
        *outError = blockError;
    }
    return resolution;
}

