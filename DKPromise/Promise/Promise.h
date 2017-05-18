//
//  Promise.h
//  DKPromise
//
//  Created by 丁侃 on 2017/5/17.
//  Copyright © 2017年 丁侃. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 状态
 1.执行中
 2.执行完成
 3.执行失败
 */
typedef enum : NSUInteger {
    PromiseStatePending,
    PromiseStateFulFilled,
    PromiseStateRegected,
} PromiseState;

typedef enum : NSUInteger {
    PromiseErrorCodeNull,
    PromiseErrorCodeRuntime,
    PromiseErrorCodeRejected,
} PromiseErrorCode;

typedef id(^runHandle)(id value);
//执行完成block
typedef void(^resolveHandle)(id value);
//执行失败block
typedef void(^rejectedHandle)(NSError *error);

typedef void(^promiseHandle)(resolveHandle,rejectedHandle);




@protocol PromiseEnable <NSObject>

@property (nonatomic) promiseHandle promise;

@end


@interface Promise : NSObject

@property (nonatomic) id value;

@property (nonatomic, copy) NSError *error;

//状态机
@property (nonatomic, assign) PromiseState state;

@property (nonatomic, strong) Promise *depPromise;

@property (nonatomic, copy) resolveHandle resolveBlock;

@property (nonatomic, copy) rejectedHandle rejectedBlock;

@property (nonatomic, copy) promiseHandle promiseBlock;

@property (nonatomic, copy) rejectedHandle catchBlock;

@property (nonatomic, copy) runHandle thenBlock;

@property (nonatomic, strong) id strongSelf;

-(instancetype)initWithPromiseBlock:(promiseHandle)promiseBlock;

+(Promise *)promise:(promiseHandle)handle;
+(Promise *)timer:(NSTimeInterval)timer;
+(Promise *)resolve:(id)value;
+(Promise *)reject:(id)value;

-(void)resolve:(id)value;
-(void)rejecte:(NSError *)error;
@end


@interface Promise (Error)
+(NSError *)errorWithExpection:(NSException *)expection;
+(NSError *)errorWtihRejected:(NSString *)rejected;
+(NSError *)errorWithValue:(id)value;
@end



@interface Promise (Then)
- (Promise *(^)(runHandle))then;
@end


@interface Promise (Catch)
- (Promise *(^)(rejectedHandle))catch;
@end


@interface Promise (Finally)
- (void (^)(dispatch_block_t))finally;
@end
