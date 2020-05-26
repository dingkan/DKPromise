//
//  DKPromise+All.m
//  DKPromise
//
//  Created by 丁侃 on 2020/5/23.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise+All.h"
#import "DKPromise+Testing.h"
#import "DKPromisePrivate.h"
#import "DKPromise+Async.h"

@implementation DKPromise (All)


+(DKPromise <NSArray *>*)all:(NSArray *)promises {
    return [self onQueue:DKPromise.defaultDispatchQueue all:promises];
}

//如果数组中有error则直接执行异常回调，不在执行
+(DKPromise <NSArray *>*)onQueue:(dispatch_queue_t)queue
                             all:(NSArray *)promises {
    NSParameterAssert(queue);
    NSParameterAssert(promises);
    
    if (promises.count == 0) {
        return [[DKPromise alloc]initWithResolution:@[]];
    }
    
    NSMutableArray *allPromise = [promises mutableCopy];
    
    return [DKPromise onQueue:queue async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
       
        //数据筛选
        for (int i = 0; i < allPromise.count; i ++) {
            id value = allPromise[i];
            if ([value isKindOfClass:[DKPromise class]]) {
                continue;
            }else if ([value isKindOfClass:[NSError class]]){
                reject(value);
            }else{
                [allPromise replaceObjectAtIndex:i withObject:[[DKPromise alloc] initWithResolution:value]];
            }
        }
        
        //执行所有promise
        for (DKPromise *promise in allPromise) {
            [promise observeOnQueue:queue fulfill:^(id  _Nullable value) {
               
                //等待所有处理都为fulfill状态
                for (DKPromise *inPromise in allPromise) {
                    if (!inPromise.isFulFilled) {
                        return;
                    }
                }
                
                //如果多次调用，只有第一次调用会影响结果
                fulfill([promises valueForKey:NSStringFromSelector(@selector(value))]);
                
            } reject:^(NSError * _Nonnull error) {
                
                //只要有一个错误回调，就直接抛出
                reject(error);
                
            }];
        }
        
        
    }];
    
}

@end

@implementation DKPromise(DotSyntax_AllAdditions)

+(DKPromise <NSArray *>*(^)(NSArray *))all{
    return ^(NSArray <DKPromise *>*promises){
        return [self all:promises];
    };
}

+(DKPromise <NSArray *>*(^)(dispatch_queue_t, NSArray *))allOn{
    return ^(dispatch_queue_t queue, NSArray *promises){
        return [self onQueue:queue all:promises];
    };
}

@end
