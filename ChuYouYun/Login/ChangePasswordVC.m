//
//  ChangePasswordVC.m
//  ChuYouYun
//
//  Created by Johnbenjamin on 15/5/22.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"
#import "UserLoginViewController.h"

@interface ChangePasswordVC ()

@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)compelteBtn:(id)sender
{
    if (![self.passwordTxt.text isEqual:self.surePasswordTxt.text]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"两次密码输入不一致" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic =[[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:self.phoneStr forKey:@"phone"];
    [dic setObject:self.codeStr forKey:@"code"];
    [dic setObject:self.passwordTxt.text forKey:@"pwd"];
    [dic setObject:self.surePasswordTxt.text forKey:@"repwd"];
    NSLog(@"%@",dic);
    
    [manager resetPassword:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *msg = [responseObject objectForKey:@"msg"];
        NSLog(@"%@   %@",responseObject,msg);
        if ([msg isEqualToString:@"ok"])
        {
            UserLoginViewController *login = [[UIStoryboard storyboardWithName:@"UserLoginViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"login"];
            [self presentViewController:login animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (IBAction)backBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
