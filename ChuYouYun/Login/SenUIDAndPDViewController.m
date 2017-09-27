//
//  SenUIDAndPDViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/2.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "SenUIDAndPDViewController.h"
#import "MyHttpRequest.h"
#import "ReMD.h"
#import "Passport.h"
#import "RegisterToPhoneViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "rootViewController.h"

@interface SenUIDAndPDViewController ()

@end

@implementation SenUIDAndPDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _waitView.layer.cornerRadius =5;
    _waitView.layer.masksToBounds =YES;
    
}
- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)goLoginGo:(id)sender
{
    [_activityView startAnimating];
    _waitView.alpha =0.8;
    
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    
    QKHTTPManager *manager = [QKHTTPManager manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:self.phoneStr forKey:@"login"];
    [dic setValue:self.userName.text forKey:@"uname"];
    [dic setValue:self.password.text forKey:@"password"];
    [dic setValue:@"2" forKey:@"type"];
    [dic setValue:self.codeStr forKey:@"code"];
    
//    __block ReMD *re = [[ReMD alloc]init];
    [manager registUser:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([msg isEqual:@"ok"])
        {
            [self performSelector:@selector(thenGo) withObject:nil afterDelay:2];
            
        }
        else
        {
            _waitView.alpha =0;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"出错啦" message:msg delegate:nil cancelButtonTitle:@"返回重试" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"register   %@",error);
    }];
}

-(void)thenGo
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setValue:self.phoneStr forKey:@"uname"];
    [dic setValue: self.password.text forKey:@"upwd"];
    [manager userLogin:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        base = [BaseClass modelObjectWithDictionary:responseObject];
        [[NSUserDefaults standardUserDefaults]setObject:base.data.oauthToken forKey:@"oauthToken"];
        [[NSUserDefaults standardUserDefaults]setObject:base.data.oauthTokenSecret forKey:@"oauthTokenSecret"];
        [[NSUserDefaults standardUserDefaults]setObject:base.data.uid forKey:@"User_id"];
        [[NSUserDefaults standardUserDefaults]setObject:base.data.userface forKey:@"userface"];
        if (base.code == 0)
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [Passport userDataWithSavelocality:base.data];
            });
            
            rootViewController *blum = [[rootViewController alloc]init];
            self.view.window.rootViewController = blum;
            
        }else
        {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登陆错误" message:base.msg delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
