//
//  DKPromiseError.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/22.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//NS_REFINED_FOR_SWIFT宏指令是Xcode 7.0 新出的参考Xcode 7.0 release note，用它所标记的方法和变量在Objective-C中可以正常使用，但bridge到Swift语言时，编译器会在名称前加上__，注意是双下划线。
FOUNDATION_EXTERN NSErrorDomain const DKPromiseErrorDomain NS_REFINED_FOR_SWIFT;

typedef NS_ENUM(NSInteger, DKPromiseErrorCode){
    DKPromiseErrorCodeTimeout = 1,
    DKPromiseErrorCodeValidationFailure = 2,
} NS_REFINED_FOR_SWIFT;

NS_INLINE BOOL DKPromiseErrorIsTimeout(NSError *error) NS_SWIFT_UNAVAILABLE(""){
    return error.domain == DKPromiseErrorDomain && error.code == DKPromiseErrorCodeTimeout;
}

NS_INLINE BOOL DKPromiseErrorIsValidationFailure(NSError *error) NS_SWIFT_UNAVAILABLE(""){
    return error.domain == DKPromiseErrorDomain && error.code == DKPromiseErrorCodeValidationFailure;
}


NS_ASSUME_NONNULL_END
