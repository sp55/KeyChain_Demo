//
//  ViewController.m
//  KeyChain_Demo
//
//  Created by admin on 16/6/21.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

//KeyChain的介绍
//http://www.jianshu.com/p/c087894b640d
//http://www.jianshu.com/p/fa87b6879b99
//http://www.jianshu.com/p/bf6b42470bba

//一句话 就是账号密码不保存在沙盒中 即使删除了App，资料依然保存在keychain中。


//开发过程中通常使用SSKeyChian
//下面是关于SSKeyChian的介绍
//http://blog.csdn.net/m18510011124/article/details/44096631

#import "ViewController.h"
#import "SSKeychain.h"
#import "SSKeychainQuery.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self text1];
    
    [self text2];
}
-(void)text2
{
//http://www.cnblogs.com/m4abcd/p/5242254.html
//一.添加一条钥匙    （这个钥匙的信息 由 服务名+账号+密码 组成）
    //先定义一下要用的东东
    
    NSString *serviceName= @"com.keychaintest.data";
    NSString *account = @"m4abcd";
    NSString *password = @"12345678";
    //加入钥匙串！
    if ([SSKeychain setPassword:password forService:serviceName account:account]) {
        NSLog(@"加入钥匙串 success !");
        
    }
//二.查询
//1.查询某service 下 count 的密码并且打印出来：
    
    NSLog(@"password=%@",[SSKeychain passwordForService:serviceName account:account]);
    
//2.查询service下所有钥匙:
    NSArray *keys = [SSKeychain accountsForService:serviceName];
    NSLog(@"keys=%@",keys);
//3.查询本appkeychain的所有钥匙
    
    NSArray *allkeys = [SSKeychain allAccounts];
    NSLog(@"allkeys=%@",allkeys);

//三.更新
    
    if ([SSKeychain setPassword:@"321321" forService:serviceName account:account]) {
        NSLog(@"更新set success!");
    }

    
//四.删除
    if([SSKeychain deletePasswordForService:serviceName account:account]){
        NSLog(@"删除delete success!");
     }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [SSKeychain setPassword:@"123" forService:@"test" account:@"user1"];
    [SSKeychain setPassword:@"124" forService:@"test" account:@"user2"];

    
    NSLog(@"%@",[[SSKeychain accountsForService:@"test"] objectAtIndex:1]);
    NSLog(@"%@",[[SSKeychain accountsForService:@"test"] lastObject]);

}


#pragma mark  - Text1
-(void)text1
{
//http://www.codingke.com/question/1986
//http://my.oschina.net/u/736617/blog/225822
    //保存一个UUID字符串
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
    [SSKeychain setPassword: [NSString stringWithFormat:@"%@", uuidStr]
                 forService:@"com.yourapp.yourcompany"account:@"user"];
    //从钥匙串读取UUID：
    NSString *retrieveuuid = [SSKeychain passwordForService:@"com.yourapp.yourcompany"account:@"user"];
    NSLog(@"从钥匙串读取UUID%@",retrieveuuid);
    
    
    
    //如果无法保存钥匙串，请使用SSKeychain.h中提供的错误代码，例如：
    NSError *error = nil;
    SSKeychainQuery *query = [[SSKeychainQuery alloc] init];
    query.service = @"com.yourapp.yourcompany";
    query.account = @"user";
    [query fetch:&error];
    
    if ([error code] == errSecItemNotFound) {
        NSLog(@"Password not found");
    } else if (error != nil) {
        NSLog(@"Some other error occurred: %@", [error localizedDescription]);
    }

}


@end
