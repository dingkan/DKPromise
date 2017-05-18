//
//  ViewController.m
//  DKPromise
//
//  Created by 丁侃 on 2017/5/17.
//  Copyright © 2017年 丁侃. All rights reserved.
//

#import "ViewController.h"
#import "Promise.h"
#import "AFNetworking.h"

@interface ViewController ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test1];
    
}

- (void)test1{
    
    
    __weak typeof(self)wself = self;
    [Promise promise:^(resolveHandle resolve, rejectedHandle reject) {
        
        //1.请求一/异步操作
        [wself.manager GET:@"http://wap.js.10086.cn/bigdata/v3/IOS201609.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //2.抛出请求回调数据
            resolve(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
        
    }].then(^id(id data){
        
        //3.数据处理
        NSDictionary *temp = (NSDictionary *)data[@"size"];
        
        return temp;
        
    }).then(^id(id data){
        
        //4.数据处理
        NSLog(@"%@",data);
        
        return data;
        
    }).then(^ id(id data){
        
        
        //5.依赖上步请求参数的异步操作/请求
        [wself.manager GET:@"http://wap.js.10086.cn/bigdata/v3/IOS201609.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        return nil;
    }).finally(^{
        
        //6.最后处理
        NSLog(@"--end---");
        
    });
}

-(AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer.timeoutInterval = 10;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"text/plain", @"application/json", @"text/json", @"text/javascript", @"text/html", @"image/png", nil];
    }
    return _manager;
}

@end
