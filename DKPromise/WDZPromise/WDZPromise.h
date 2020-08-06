//
//  WDZPromise.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/27.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface WDZPromise<__covariant Value> : NSObject

@property (class) dispatch_queue_t defaultDispatchQueue NS_REFINED_FOR_SWIFT;

+(instancetype)pendingPromise NS_REFINED_FOR_SWIFT;

+(instancetype)resolveWith:(nullable id)resolution NS_REFINED_FOR_SWIFT;

-(void)fulfill:(__nullable id)value NS_REFINED_FOR_SWIFT;

-(void)reject:(NSError *)error NS_REFINED_FOR_SWIFT;

@end

NS_ASSUME_NONNULL_END
