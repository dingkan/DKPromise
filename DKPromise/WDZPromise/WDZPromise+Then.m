//
//  WDZPromise+Then.m
//  DKPromise
//
//  Created by 丁侃 on 2020/5/27.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "WDZPromise+Then.h"
#import "WDZPromise+Private.h"

@implementation WDZPromise (Then)

-(WDZPromise *)then:(WDZPromiseThenWorkBlock)work{
    return [self onQueue:WDZPromise.defaultDispatchQueue then:work];
}

-(WDZPromise *)onQueue:(dispatch_queue_t)queue
                  then:(WDZPromiseThenWorkBlock)work{
    NSParameterAssert(queue);
    NSParameterAssert(work);
    
    return [self chainOnQueue:queue chainFulfill:work chainReject:nil];
}
@end
