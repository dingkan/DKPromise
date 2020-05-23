//
//  DKPromise+Async.m
//  DKPromise
//
//  Created by 丁侃 on 2020/5/23.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise+Async.h"
#import "DKPromise+Testing.h"
#import "DKPromisePrivate.h"

@implementation DKPromise (Async)

+(instancetype)async:(DKPromiseAysncWorkBlock)work {
    return [self onQueue:DKPromise.defaultDispatchQueue async:work];
}

+(instancetype)onQueue:(dispatch_queue_t)queue
                 async:(DKPromiseAysncWorkBlock)work {
    
    NSParameterAssert(queue);
    NSParameterAssert(work);
    
    DKPromise *promise = [DKPromise pendingPromise];
    
    dispatch_group_async(DKPromise.dispatchGroup, queue, ^{
       
        !work?:work(
             ^(id __nullable value){
                    
                //判断下一个传过来的值
            if ([value isKindOfClass:[DKPromise class]]) {
                
                [(DKPromise *)value observeOnQueue:queue fulfill:^(id  _Nullable value) {
                    [promise fulfill:value];
                } reject:^(NSError * _Nonnull error) {
                    [promise reject:error];
                }];
                
            }else{
                [promise fulfill:value];
            }
            
                },
             ^(NSError *error){
                [promise reject:error];
                }
             );
        
    });
    
    return promise;
}
@end

@implementation DKPromise (DotSyntax_AsyncAdditions)

+(DKPromise *(^)(DKPromiseAysncWorkBlock))async{
    return ^(DKPromiseAysncWorkBlock work){
        return [self async:work];
    };
}

+(DKPromise *(^)(dispatch_queue_t queue, DKPromiseAysncWorkBlock work))asyncOn{
    return ^(dispatch_queue_t queue, DKPromiseAysncWorkBlock work){
        return [self onQueue:queue async:work];
    };
}

@end
