//
//  DKPromise.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/22.
//  Copyright © 2020 丁侃. All rights reserved.
//
/**
   1.每个promise都处于主线程
   2.所有读取数据都必须枷锁
   3.fulfill成功后的处理
       3.1 value -?-> NSError
                           -YES->(reject)
                           -NO-> 1.必须枷锁   2.修改pending状态   3. 通知所有observer处理  4.清空observer   5.group-leave
   4.reject处理
       4.1 value -?-> NSError
                           -NO-> 跑出异常
                           -YES->  通fulfill
   5.所有初始化方法必须执行group_enter
   6.dealloc  ->   如果是pendding 状态 则必须group_leave(enter & leave同对出现)
   7.pending进来的对象， object -> object -> object 一层层持有对象
   8. _observers 存储的是FBLPromiseObserver 类型的block对象 。
       8.1 判断当前的promise对象的state状态
           8.1.1  如果是pendding状态 则将block添加给当前promise的observers里
                   8.1.1.2判断block将要传进来的state状态类型，如果是成功或者失败处理，则将值传递
           8.1.2  如果是执行状态，则将当前promise的value传递出去
*/
#import "DKPromiseError.h"

//NS_REFINED_FOR_SWIFT宏指令是Xcode 7.0 新出的参考Xcode 7.0 release note，用它所标记的方法和变量在Objective-C中可以正常使用，但bridge到Swift语言时，编译器会在名称前加上__，注意是双下划线。
NS_ASSUME_NONNULL_BEGIN

@interface DKPromise<__covariant Value> : NSObject

//default is main
@property (class) dispatch_queue_t defaultDispatchQueue NS_REFINED_FOR_SWIFT;

+(instancetype)pendingPromise NS_REFINED_FOR_SWIFT;

+(instancetype)resolvedWith:(nullable id)resolution NS_REFINED_FOR_SWIFT;

-(void)fulfill:(nullable Value)value NS_REFINED_FOR_SWIFT;

-(void)reject:(NSError *)error NS_REFINED_FOR_SWIFT;

@end


@interface DKPromise<Value>(DotSyntaxAdditions)

+(instancetype(^)(void))pending NS_SWIFT_UNAVAILABLE("");

+(instancetype(^)(id __nullable))resloved NS_SWIFT_UNAVAILABLE("");

@end

NS_ASSUME_NONNULL_END
