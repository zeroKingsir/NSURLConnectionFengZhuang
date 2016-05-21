//
//  ViewController.m
//  NSURLConnectionFengZhuang
//
//  Created by G.Z on 16/5/21.
//  Copyright © 2016年 G.Z. All rights reserved.
//

#import "ViewController.h"
#import "ELNHttpRequest.h"
//导入封装好的网络类头文件

//#define URL @"http://10.0.8.8/sns/my/user_list.php"
#define URL @"http://admin.izhangchu.com:80/HandheldKitchen/api/home/tblHomepageVegetable!getHomeVegetableList.do?is_traditional=0&page=1&pageRecord=3&phonetype=1"

@interface ViewController ()<NSURLConnectionDataDelegate, NSURLConnectionDelegate>
//dataDelegate 主要是与数据的状态 比如是否开始接收 是否已经接收 有关系

//delegate 主要是与connection先关 比如是否开始建立连接 是否已经接收 是否请求失败 等等
@property (nonatomic, strong)NSURLConnection *connection;
//【注意】如果采用数据分片的异步请求形式 NSURLConnection对象需要抽象成一个属性

//原因：connection在完全接收到数据 连接断开之前 不能提前释放 否则数据没法接收

@property (nonatomic, strong)NSMutableData *data;
//接收发送的分片的数据 一定是一个可变的（接收到一个就拼接一个）数据的类型 二进制数据

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createBtn];
    
}
- (void)createBtn{

    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
    
    [btn setTitle:@"测试" forState:UIControlStateNormal];
    
    btn.backgroundColor = [UIColor purpleColor];
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    btn.center = self.view.center;
    
    [self.view addSubview:btn];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    ELNHttpRequest *request = [[ELNHttpRequest alloc]init];
    
    [request requestWithUrl:URL andRequestBlock:^(id data, NSError *error) {
        
        //数据回调之后的处理都写在这里
        NSLog(@"%@",data);
        
    }];
    
}


#pragma mark -- button点击事件

- (void)btnClick:(UIButton *)btn{
    
    NSLog(@"我就是为了测试而存在的 V587！！");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

