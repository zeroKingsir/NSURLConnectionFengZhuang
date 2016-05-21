//
//  ELNHttpRequest.m
//
//
//  Created by G.Z on 16/1/5.
//  Copyright (c) 2016年 G.Z. All rights reserved.
//

#import "ELNHttpRequest.h"

@interface ELNHttpRequest ()<NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (nonatomic, strong)NSURLConnection *connection;

@property (nonatomic, strong)NSMutableData *data;

@property (nonatomic, copy)MyRequestBlock block;
//【注意】需要添加一个block属性 记录传递过来的block 在数据请求成功或者失败的代理方法中调用

@end

@implementation ELNHttpRequest

- (void)requestWithUrl:(NSString *)url andRequestBlock:(MyRequestBlock)requestBlock{

    [self sendAsyncTwo:url andBlcok:requestBlock];
    
    
}
#pragma mark -- 异步请求方式二 （数据分片段传输）

- (void)sendAsyncTwo:(NSString *)url andBlcok:(MyRequestBlock)block{
    
    //该方法内部 实现的是异步加载 数据进行分片传输 传输的过程 需要通过代理方法进行监控
    
    self.block = block;
    //给block属性赋值
    
    //1.生成NSURL
    
    NSURL *URL = [NSURL URLWithString:url];
    
    
    //2.生成请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //3.初始化用于连接的connection对象
    
    _connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    //delegate 对应的协议 是第二个 不带data的
    
    
    //4.开始进行数据请求
    [_connection start];
    
}


#pragma mark --  Data delegate

//1.收到响应时 调用的方法 （该方法只调用一次）
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    //如果该方法被调用 说明请求成功 数据准备开始传递回来
    //_data在这个地方初始化 开辟空间 为接收数据做好准备
    
    
    //如果_data不为空 存在 则将上一次请求的数据清空掉
    //如果为空  直接创建
    
    if(_data){
        
        //清空上一次请求的数据
        
        _data.length = 0;
        
    }else{
        
        //创建
        _data = [[NSMutableData alloc]init];
        
    }
    
}

//2.数据开始分片进行传输 由于数据存在若干片 因此一下这个方法会被多次调用

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    //由于参数data只是数据的某一个片段 需要将每次传回来的片段拼接到_data中保存起来
    
    NSLog(@"%@",data);
    
    [_data appendData:data];
    //拼接片段
    
}

#pragma mark -- delegte （connection）

//1.当所有的数据片段全部发送完毕 连接应该断开 该方法被调用
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    //如果该方法调用 说明所有的数据都已经在_data中 应该在该方法内部进行数据解析
  
    //如果是希望数据的解析放在外部实现 那么在这个地方直接将_data返回
    
    //反之 将block中数据的参数由NSData类型 变成id类型 采用这种形式
    
    
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:&error];
    
    self.block(object, nil);
    //将解析结束的数据回调
    
    
}

//2.请求失败 或者数据传输时断网了 以下该方法会被调用
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    //请求出错了 应该给予相应提示
    NSLog(@"%@",error.localizedDescription);
    
    self.block(nil, error);
    //将错误信息回调
    
}



@end
