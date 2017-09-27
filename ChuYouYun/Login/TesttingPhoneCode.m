//
//  TesttingPhoneCode.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/7.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "TesttingPhoneCode.h"
#import "ZhiyiHTTPRequest.h"
#import "findToPhoneViewController.h"
#import "alterPasswordViewController.h"
#import "ChangePasswordVC.h"


@interface TesttingPhoneCode ()

@end

@implementation TesttingPhoneCode

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)again:(id)sender
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:self.phoneStr forKey:@"phone"];
    [manager findPWDSendCode:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([msg isEqualToString:@"ok"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"已发送，请查收" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"返回重试" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (IBAction)backclick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextClick:(id)sender
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:self.phoneStr forKey:@"phone"];
    [dic setObject:self.phoneCode.text forKey:@"code"];
    self.codeStr = self.phoneCode.text;
    NSLog(@"%@",dic);
    [manager testingFindPWDCode:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@   %@",[responseObject objectForKey:@"msg"],responseObject);
        NSString *code = [responseObject objectForKey:@"msg"];
        if ([code isEqualToString:@"ok"])
        {
            ChangePasswordVC *change =[[ChangePasswordVC alloc]init];
            change.phoneStr =self.phoneStr;
            change.codeStr =self.phoneCode.text;
            
            [self presentViewController:change animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:[responseObject objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
