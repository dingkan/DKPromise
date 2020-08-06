//
//  WDZPromise+Testing.m
//  DKPromise
//
//  Created by 丁侃 on 2020/5/27.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "WDZPromise+Testing.h"

@implementation WDZPromise (Testing)

+(dispatch_group_t)defaultGroup{
    static dispatch_once_t onceToken;
    static dispatch_group_t gDefaultGroup;
    dispatch_once(&onceToken, ^{
        gDefaultGroup = dispatch_group_create();
    });
    return gDefaultGroup;
}

@end
