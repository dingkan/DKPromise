//
//  Promise+Error.m
//  DKPromise
//
//  Created by 丁侃 on 2017/5/17.
//  Copyright © 2017年 丁侃. All rights reserved.
//

#import "Promise.h"

static NSString *ErrorDomain = @"PromiseErrorDomain";
@implementation Promise (Error)

+(NSError *)errorWithExpection:(NSException *)expection{
    return [NSError errorWithDomain:ErrorDomain code:PromiseErrorCodeRuntime userInfo:@{@"expection":expection}];
}

+(NSError *)errorWtihRejected:(NSString *)rejected{
    return [NSError errorWithDomain:ErrorDomain code:PromiseErrorCodeRejected userInfo:nil];
}

+(NSError *)errorWithValue:(id)value{
    return [NSError errorWithDomain:ErrorDomain code:PromiseErrorCodeRejected userInfo:@{@"value":value}];
}

@end
