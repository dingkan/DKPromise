//
//  Promise+Catch.m
//  DKPromise
//
//  Created by 丁侃 on 2017/5/17.
//  Copyright © 2017年 丁侃. All rights reserved.
//

#import "Promise.h"

@implementation Promise (Catch)
- (Promise *(^)(rejectedHandle))catch{

    __weak Promise* wself = self;
    
    return ^Promise*(rejectedHandle catchBlock){
        
        __weak Promise *newPromise = nil;
        
        newPromise = [Promise promise:^(resolveHandle resolve, rejectedHandle reject) {
            
            __strong Promise* sself = wself;
            
            resolve(sself);
            
        }];
        
        newPromise.catchBlock = catchBlock;
        return newPromise;
    };
    
    
}
@end
