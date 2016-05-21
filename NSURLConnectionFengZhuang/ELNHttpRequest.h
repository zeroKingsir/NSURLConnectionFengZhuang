//
//  ELNHttpRequest.h
//
//
//  Created by G.Z on 16/1/5.
//  Copyright (c) 2016年 G.Z. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^MyRequestBlock)(id data, NSError *error);
//用于数据回调的block data数据 error错误信息

@interface ELNHttpRequest : NSObject

- (void)requestWithUrl:(NSString *)url andRequestBlock:(MyRequestBlock)requestBlock;
//声明一个接口 由外部将请求的地址 以及回调的block传进来 在方法内部实现数据的请求

@end




