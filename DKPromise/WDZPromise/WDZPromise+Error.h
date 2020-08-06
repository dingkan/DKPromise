//
//  WDZPromise+Error.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/27.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "WDZPromise.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *WDZPromiseErrorDomain;

typedef enum : NSUInteger {
    WDZPromiseErrorCodeTimeout = 0,
    WDZPromiseErrorCodeValicationFailtrue = 1
} WDZPromiseErrorCode;


BOOL WDZPromiseErrorIsTimeOut(NSError *error) NS_SWIFT_UNAVAILABLE(""){
    return error.domain == WDZPromiseErrorDomain && error.code == WDZPromiseErrorCodeTimeout;
}

BOOL WDZPromiseErrorIsValicationFailtrue(NSError *error)NS_SWIFT_UNAVAILABLE(""){
    return error.domain == WDZPromiseErrorDomain && error.code == WDZPromiseErrorCodeValicationFailtrue;
}


NS_ASSUME_NONNULL_END
