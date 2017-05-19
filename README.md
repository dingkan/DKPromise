# DKPromise

###什么是promise
	-1.promise是抽象异步处理对象以及对其进行各种操作的组件
	-2.promise起到代理作用,充当异步操作与回调函数之间的中介,使异步操作具备同步操作的接口
	-3.本质就是每一个异步任务立刻返回一个promise对象,由于是立刻返回所以采用同步操作的流程
	
###iOS实现Promise
	-1.基本思想:异步任务返回一个promise
	-2.promise对象的有限状态机
			*未完成(pending)
			*已完成(resolved)
			*失败(rejected)
	-3.promise对象执行结果有且只有2种
			*异步操作成功
			*异步操作失败
	-4.iOS通过KVO来监听状态机的变化
	
###使用
```
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
```
