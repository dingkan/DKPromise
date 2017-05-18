//
//  Promise.m
//  DKPromise
//
//  Created by 丁侃 on 2017/5/17.
//  Copyright © 2017年 丁侃. All rights reserved.
//

#import "Promise.h"

#define STATE_PROTECT  if (sself.state != PromiseStatePending) {return;}

@implementation Promise

+(Promise *)timer:(NSTimeInterval)timer{
    return [Promise promise:^(resolveHandle reslove, rejectedHandle reject) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timer * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            reslove(@{@"time":@(timer)});
        });
    }];
}

+(Promise *)resolve:(id)value{
    
    if ([value isKindOfClass:[Promise class]]) {
        return value;
    }else if ([value conformsToProtocol:@protocol(PromiseEnable)]){
        return [[Promise alloc]initWithPromiseBlock:^(resolveHandle reslove, rejectedHandle reject) {
            id<PromiseEnable>thenObjc = (id<PromiseEnable>)value;
            thenObjc.promise(reslove, reject);
        }];
    }else{
       return [[Promise alloc]initWithPromiseBlock:^(resolveHandle reslove, rejectedHandle reject) {
           reslove(value);
       }];
    }
}

+(Promise *)reject:(id)value{
    if ([value isKindOfClass:[Promise class]]) {
        return value;
    }else{
        return [[Promise alloc]initWithPromiseBlock:^(resolveHandle resolve, rejectedHandle reject) {
            reject([Promise errorWithValue:value]);
        }];
    }
}

-(void)resolve:(id)value{
    self.resolveBlock(value);
}

-(void)rejecte:(NSError *)error{
    self.rejectedBlock(error);
}

+(Promise *)promise:(promiseHandle)handle{
    return [[Promise alloc]initWithPromiseBlock:handle];
}

-(instancetype)initWithPromiseBlock:(promiseHandle)promiseBlock{
    if (self = [super init]) {
        
        [self initialize];
        
        self.promiseBlock = promiseBlock;
    }
    
    [self run];
    
    return self;
}

-(void)run{
    if (self.promiseBlock) {
        
        @try {
            self.promiseBlock(self.resolveBlock, self.rejectedBlock);
        } @catch (NSException *exception) {
            self.rejectedBlock([Promise errorWithExpection:exception]);
        }
        
    }
}

-(void)initialize{
    
    //默认初始状态
    self.state = PromiseStatePending;
    [self keepAlive];
    
    
    __weak typeof(self)wself = self;
    
    self.resolveBlock = ^(id value) {
        
        __strong typeof(self)sself = wself;
        
        if ([value isKindOfClass:[Promise class]]) {
            STATE_PROTECT
            
            if (((Promise *)value).state == PromiseStatePending) {
                sself.depPromise = value;
            }
            
            //通过KVO监听状态变化,让当前promise对象监听传入promise对象状态变化
            [value addObserver:sself forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
            
        }else{
            //如果传入对象不是promise对象则完成
            sself.value = value;
            sself.state = PromiseStateFulFilled;
            [sself releaseControl];
        }
    };
    
    
    self.rejectedBlock = ^(NSError *error) {
        __strong typeof(self)sself = wself;
        
        STATE_PROTECT
        
        [sself releaseControl];
        
        sself.error = error;
        
        sself.state = PromiseStateRegected;
        
    };
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"state"]) {
        
        //获取状态
        PromiseState newState = [change[NSKeyValueChangeNewKey] unsignedIntegerValue];
        
        if (newState == PromiseStateRegected) {
         
            //KVO需要移除
            [object removeObserver:self forKeyPath:keyPath];
            
            if (self.catchBlock) {
                self.catchBlock([(Promise *)object error]);
                self.resolveBlock(nil);
            }else{
                self.rejectedBlock([(Promise *)object error]);
            }
            
        }else if (newState == PromiseStateFulFilled){
            [object removeObserver:self forKeyPath:keyPath];
            
            @try {
                
                id value = nil;
                
                if (self.thenBlock) {
                    value = self.thenBlock([(Promise *)object value]);
                }else{
                    value = [(Promise *)object value];
                }
                
                self.thenBlock = nil;
                self.resolveBlock(value);
                
            } @catch (NSException *exception) {
                self.rejectedBlock([Promise errorWithExpection:exception]);
            } @finally {
            }
        }
    }
}

-(void)dealloc{
    self.state = self.state;
    self.depPromise = nil;
}

-(void)keepAlive{
    self.strongSelf = self;
}

-(void)releaseControl{
    self.strongSelf = nil;
}

@end
