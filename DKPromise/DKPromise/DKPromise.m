//
//  DKPromise.m
//  DKPromise
//
//  Created by 丁侃 on 2020/5/22.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise.h"
#import "DKPromise+Testing.h"
#import "DKPromisePrivate.h"

typedef NS_ENUM(NSInteger, DKPromiseState){
    DKPromiseStatePending = 0,
    DKPromiseStateFulFill = 1,
    DKPromiseStateReject = 2,
};

typedef void(^DKPromiseObserver)(DKPromiseState state, id __nullable resolution);

static dispatch_queue_t gDKPromiseDefaultDispatchQueue;

@implementation DKPromise
{
    DKPromiseState _state;
    
    id __nullable _value;
    
    NSError * __nullable _error;
    
    NSMutableArray * __nullable _pendingObjects;
    
    NSMutableArray <DKPromiseObserver>* _observers;
}

+(void)initialize{
    if (self == [DKPromise class]) {
        gDKPromiseDefaultDispatchQueue = dispatch_get_main_queue();
    }
}

+(dispatch_queue_t)defaultDispatchQueue{
    @synchronized (self) {
        return gDKPromiseDefaultDispatchQueue;
    }
}

+(void)setDefaultDispatchQueue:(dispatch_queue_t)queue{
    NSParameterAssert(queue);
    
    @synchronized (self) {
        gDKPromiseDefaultDispatchQueue = queue;
    }
}

+(instancetype)pendingPromise{
    return [[self alloc]initPending];
}

+(instancetype)resolvedWith:(nullable id)resolution{
    return [[self alloc] initWithResolution:resolution];
}

-(void)fulfill:(nullable id)value{
    if ([value isKindOfClass:[NSError class]]) {
        [self reject:value];
    }else{
        @synchronized (self) {
            if (_state == DKPromiseStatePending) {
                _state = DKPromiseStateFulFill;
                _value = value;
                
                _pendingObjects = nil;
                
                for (DKPromiseObserver observer in _observers) {
                    !observer?:observer(_state, _value);
                }
                
                _observers = nil;
                
                dispatch_group_leave(DKPromise.dispatchGroup);
            }
        }
    }
}

-(void)reject:(NSError *)error{
    
    NSAssert([error isKindOfClass:[NSError class]], @"Invalid error type.");
    
    if (![error isKindOfClass:[NSError class]]) {
        @throw error;
    }
    
    @synchronized (self) {
        if (_state == DKPromiseStatePending) {
            _state = DKPromiseStateReject;
            _error = error;
            _pendingObjects = nil;
            for (DKPromiseObserver observer in _observers) {
                !observer?:observer(_state, _error);
            }
            _observers = nil;
            dispatch_group_leave(DKPromise.dispatchGroup);
        }
    }
}

#pragma private
-(instancetype)initPending{
    if (self = [super init]) {
        dispatch_group_enter(DKPromise.dispatchGroup);
    }
    return self;
}

-(instancetype)initWithResolution:(nullable id)resolution{
    if (self = [super init]) {
        if ([resolution isKindOfClass: [NSError class]]) {
            _state = DKPromiseStateReject;
            _error = (NSError *)resolution;
        }else{
            _state = DKPromiseStateFulFill;
            _value = resolution;
        }
    }
    return self;
}

-(void)dealloc{
    if (_state == DKPromiseStatePending) {
        dispatch_group_leave(DKPromise.dispatchGroup);
    }
}

-(BOOL)isPending{
    @synchronized (self) {
        return _state == DKPromiseStatePending;
    }
}

-(BOOL)isFulFilled{
    @synchronized (self) {
        return _state == DKPromiseStateFulFill;
    }
}

-(BOOL)isRejected{
    @synchronized (self) {
        return _state == DKPromiseStateReject;
    }
}

-(nullable id)value{
    @synchronized (self) {
        return _value;
    }
}

-(NSError *__nullable)error{
    @synchronized (self) {
        return _error;
    }
}

/**
 核心，执行
 */
-(void)observeOnQueue:(dispatch_queue_t)queue
              fulfill:(DKPromiseOnFulFillBlock)onFulFill
               reject:(DKPromiseOnRejectBlock)onReject{
    NSParameterAssert(queue);
    NSParameterAssert(onReject);
    NSParameterAssert(onFulFill);
    
    @synchronized (self) {
        switch (_state) {
            case DKPromiseStatePending:
            {
                //监听队列
                if (!_observers) {
                    _observers = [NSMutableArray array];
                }
                
                [_observers addObject:^(DKPromiseState state, id __nullable resolution){
                    dispatch_group_async(DKPromise.dispatchGroup, queue, ^{
                       
                        switch (state) {
                            case DKPromiseStatePending:
                                break;
                            case DKPromiseStateFulFill:
                                onFulFill(resolution);
                                break;
                            case DKPromiseStateReject:
                                onReject(resolution);
                                break;
                            default:
                                break;
                        }
                        
                    });
                }];
                
            }
                break;
            case DKPromiseStateFulFill:
            {
                dispatch_group_async(DKPromise.dispatchGroup, queue, ^{
                    onFulFill(self->_value);
                });
            }
                break;
            
            case DKPromiseStateReject:
            {
                dispatch_group_async(DKPromise.dispatchGroup, queue, ^{
                    onReject(self->_error);
                });
            }
                break;
            default:
                break;
        }
    }
}


//链式传递处理
-(DKPromise *)chainOnQueue:(dispatch_queue_t)queue
            chainedFulFill:(DKPromiseChainedFulfillBlock)chainedFulFill
             chainedReject:(DKPromiseChainedRejectBlock)chainedReject{
    NSParameterAssert(queue);
    
    DKPromise *promise = [[DKPromise alloc]initPending];
    __auto_type resolver = ^(id __nullable value){
        if ([value isKindOfClass:[DKPromise class]]) {
            [(DKPromise *)value observeOnQueue:queue fulfill:^(id  _Nullable value) {
                [promise fulfill:value];
            } reject:^(NSError *error) {
                [promise reject:error];
            }];
        }else{
            [promise fulfill:value];
        }
    };
    
    [self observeOnQueue:queue fulfill:^(id  _Nullable value) {
        value = chainedFulFill ? chainedFulFill(value) : value;
        resolver(value);
    } reject:^(NSError *error) {
        id value = chainedReject ? chainedReject(error) : error;
        resolver(value);
    }];
    
    return promise;
    
}
              
#pragma NSObject
-(NSString *)description{

    if (self.isFulFilled) {
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


@implementation DKPromise (DotSyntaxAdditions)

+(instancetype  _Nonnull (^)(void))pending{
    return ^(void){
        return [self pendingPromise];
    };
}

+(instancetype  _Nonnull (^)(id _Nullable))resloved{
    return ^(id resolution){
        return [self resolvedWith:resolution];
    };
}

@end
