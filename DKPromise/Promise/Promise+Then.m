//
//  Promise+Then.m
//  DKPromise
//
//  Created by 丁侃 on 2017/5/17.
//  Copyright © 2017年 丁侃. All rights reserved.
//

#import "Promise.h"

@implementation Promise (Then)
- (Promise *(^)(runHandle))then{

    __weak Promise* wself = self;
    
    return  ^Promise *(runHandle thenBlock){
        __weak Promise *newPromise = nil;
        
        newPromise = [Promise promise:^(resolveHandle resolve, rejectedHandle reject) {
            
            __strong Promise *sself = wself;
            
            resolve(sself);
            
        }];
        newPromise.thenBlock = thenBlock;
        return newPromise;
    };
    
}
@end
