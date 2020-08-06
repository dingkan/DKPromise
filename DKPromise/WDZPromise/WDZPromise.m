//
//  WDZPromise.m
//  DKPromise
//
//  Created by 丁侃 on 2020/5/27.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "WDZPromise.h"
#import "WDZPromise+Testing.h"
#import "WDZPromise+Private.h"

typedef enum : NSUInteger {
    WDZPromisePending = 0,
    WDZPromiseFulfill,
    WDZPromiseReject,
} WDZPromiseState;

typedef void(^WDZPromiseObserver)(WDZPromiseState state, id __nullable resolution);

static dispatch_queue_t gWDZPromiseDefaultQueue;

@implementation WDZPromise
{
    WDZPromiseState _state;//有限状态机
    
    id _value;
    NSError *_error;
    
    NSMutableArray<WDZPromiseObserver> *_observers;
    
    NSMutableArray *_pendingObjects;
    
}

+(void)initialize{
    if ([self isKindOfClass:[WDZPromise class]]) {
        gWDZPromiseDefaultQueue = dispatch_get_main_queue();
    }
}

+(dispatch_queue_t)defaultDispatchQueue{
    @synchronized (self) {
        return gWDZPromiseDefaultQueue;
    }
}

+(void)setDefaultDispatchQueue:(dispatch_queue_t)defaultDispatchQueue{
    NSParameterAssert(defaultDispatchQueue);
    
    @synchronized (self) {
        gWDZPromiseDefaultQueue = defaultDispatchQueue;
    }
}

/**
 1.判断value类型，error -> reject
 2.初始化状态，赋值value 便利所有监听者 执行
 */
#pragma public
-(void)fulfill:(__nullable id)value NS_REFINED_FOR_SWIFT{
    if ([value isKindOfClass:[NSError class]]) {
        [self reject:value];
    }else{
        @synchronized (self) {
            _state = WDZPromiseFulfill;
            _value = value;
            
            _pendingObjects = nil;
            
            for (WDZPromiseObserver observer  in _observers) {
                !observer?:observer(_state, _value);
            }
            
            _observers = nil;
            
            dispatch_group_leave(WDZPromise.defaultGroup);
        }
    }
}

-(void)reject:(NSError *)error NS_REFINED_FOR_SWIFT{
    NSAssert([error isKindOfClass:[NSError class]], @"Invalid error type.");
    
    if (![error isKindOfClass:[NSError class]]) {
        @throw error;
    }
    
    @synchronized (self) {
        _state = WDZPromiseReject;
        _error = error;
        
        _pendingObjects = nil;
        
        for (WDZPromiseObserver observer in _observers) {
            !observer?:observer(_state, _error);
        }
        
        _observers = nil;
        
        dispatch_group_leave(WDZPromise.defaultGroup);
    }
    
}

-(void)observeOnQueue:(dispatch_queue_t)queue
            fulfill:(WDZPromiseFulfillBlock)fulfill
               reject:(WDZPromiseRejectBlock)reject{
    NSParameterAssert(queue);
    NSParameterAssert(fulfill);
    NSParameterAssert(reject);
    @synchronized (self) {
        switch (_state) {
            case WDZPromisePending:
            {
                if (!_observers) {
                    _observers = [NSMutableArray array];
                }
                
                [_observers addObject:^(WDZPromiseState state, id __nullable resolution){
                   
                    dispatch_async(WDZPromise.defaultDispatchQueue, ^{
                        switch (state) {
                            case WDZPromisePending:
                                break;
                            case WDZPromiseFulfill:
                                !fulfill?:fulfill(resolution);
                                break;
                            case WDZPromiseReject:
                                !reject?:reject(resolution);
                                break;
                            default:
                                break;
                        }
                    });
                    
                }];
                
            }
                break;
            case WDZPromiseFulfill:
            {
                
                dispatch_async(WDZPromise.defaultDispatchQueue, ^{

                    !fulfill?:fulfill(self->_value);
                });
            }
                break;
            case WDZPromiseReject:
            {
                dispatch_async(WDZPromise.defaultDispatchQueue, ^{

                    !reject?:reject(self->_error);
                });
            }
                break;
            default:
                break;
        }
    }
}

-(WDZPromise *)chainOnQueue:(dispatch_queue_t)queue
            chainFulfill:(ChainPromiseFulfillBlock)fulfill
                chainReject:(ChainPromiseRejectBlock)reject{
    WDZPromise *promise = [WDZPromise pendingPromise];
    
    __auto_type resolver = ^(id __nullable value){
        if ([value isKindOfClass:[WDZPromise class]]) {
            [(WDZPromise *)value observeOnQueue:queue fulfill:^(id  _Nullable value) {
                fulfill(value);
            } reject:^(NSError * _Nonnull error) {
                reject(error);
            }];
        }else{
            fulfill(value);
        }
    };
    
    [self observeOnQueue:queue fulfill:^(id  _Nullable value) {
        value = fulfill ? fulfill(value) : value;
        resolver(value);
    } reject:^(NSError * _Nonnull error) {
        id value = reject ? reject(error) : error;
        resolver(value);
    }];
    
    return promise;
}

+(instancetype)pendingPromise NS_REFINED_FOR_SWIFT{
    return [[self alloc]initWithPending];
}

+(instancetype)resolveWith:(nullable id)resolution NS_REFINED_FOR_SWIFT{
    return [[self alloc]initWithResolution:resolution];
}

#pragma private
-(instancetype)initWithPending{
    if (self = [super init]) {
        _state = WDZPromisePending;
        dispatch_group_enter(WDZPromise.defaultGroup);
    }
    return self;
}

-(instancetype)initWithResolution:(nullable id)resolution{
    if (self = [super init]) {
        if ([resolution isKindOfClass:[NSError class]]) {
            _state = WDZPromiseReject;
            _error = (NSError *)resolution;
        }else{
            _state = WDZPromiseFulfill;
            _value = resolution;
        }
    }
    return self;
}

-(BOOL)isPending{
    @synchronized (self) {
        return self.isPending;
    }
}

-(BOOL)isFulfilled{
    @synchronized (self) {
        return self.isFulfilled;
    }
}

-(BOOL)isRejected{
    @synchronized (self) {
        return self.isRejected;
    }
}

-(id)value{
    @synchronized (self) {
        return _value;
    }
}

-(NSError *)error{
    @synchronized (self) {
        return _error;
    }
}

#pragma NSObject
-(NSString *)description{

    if (self.isFulfilled) {
      return [NSString stringWithFormat:@"<%@ %p> Fulfilled: %@", NSStringFromClass([self class]),
                                        self, self.value];
    }
    if (self.isRejected) {
      return [NSString stringWithFormat:@"<%@ %p> Rejected: %@", NSStringFromClass([self class]),
                                        self, self.error];
    }
    return [NSString stringWithFormat:@"<%@ %p> Pending", NSStringFromClass([self class]), self];
}

@end
