//
//  DKPromise+Testing.m
//  DKPromise
//
//  Created by 丁侃 on 2020/5/22.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise+Testing.h"

@implementation DKPromise (Testing)

+(dispatch_group_t)dispatchGroup{
    static dispatch_group_t gDispatchGroup;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gDispatchGroup = dispatch_group_create();
    });
    
    return gDispatchGroup;
}

@end
