//
//  DKPromise+Do.m
//  DKPromise
//
//  Created by 丁侃 on 2020/5/23.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise+Do.h"
#import "DKPromisePrivate.h"
#import "DKPromise+Testing.h"

@implementation DKPromise (Do)


+(instancetype)do:(DDKPromiseDoWorkBlock)work{
    return [self onQueue:DKPromise.defaultDispatchQueue do:work];
}

+(instancetype)onQueue:(dispatch_queue_t)queue do:(DDKPromiseDoWorkBlock)work{
    NSParameterAssert(queue);
    NSParameterAssert(work);
    
    DKPromise *promise = [DKPromise pendingPromise];
    
    dispatch_group_async(DKPromise.dispatchGroup, queue, ^{
       
        id value = work();
        
        if([value isKindOfClass:[DKPromise class]]){
            
            [(DKPromise *)value observeOnQueue:queue fulfill:^(id  _Nullable value) {
               
                [promise fulfill:value];
                
            } reject:^(NSError * _Nonnull error) {
                [promise reject:error];
            }];
            
        }else{
            [promise fulfill:value];
        }
        
        
    });
    
    return promise;
}
@end

@implementation DKPromise (DotSyntax_DoAdditions)

+(DKPromise *(^)(dispatch_queue_t, DDKPromiseDoWorkBlock))doOn{
    return ^(dispatch_queue_t queue, DDKPromiseDoWorkBlock work){
        return [self onQueue:queue do:work];
    };
}

@end
