//
//  Promise+Finally.m
//  DKPromise
//
//  Created by 丁侃 on 2017/5/17.
//  Copyright © 2017年 丁侃. All rights reserved.
//

#import "Promise.h"

@implementation Promise (Finally)
- (void (^)(dispatch_block_t))finally{

    __weak Promise* wself = self;
    
    return ^(dispatch_block_t runBlock){
    
        __weak Promise *newPromise = nil;
        
        newPromise = [Promise promise:^(resolveHandle resolve, rejectedHandle reject) {
            resolve(wself);
        }];
        
        newPromise.thenBlock = ^id(id value) {
            runBlock();
            return nil;
        };
        
        newPromise.catchBlock = ^(NSError *error) {
            runBlock();
        };
        
    };
    
}
@end
