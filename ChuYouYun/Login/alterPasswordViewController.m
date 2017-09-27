//
//  alterPasswordViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/24.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "alterPasswordViewController.h"
#import "UserLoginViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "TesttingPhoneCode.h"
#import "findToPhoneViewController.h"

@interface alterPasswordViewController ()

@end

@implementation alterPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)backOb:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goHome:(id)sender
{
    if (![self.setPW.text isEqual:self.resetPW.text]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"两次密码输入不一致" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic =[[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:self.phoneStr forKey:@"phone"];
    [dic setObject:self.codeStr forKey:@"code"];
    [dic setObject:self.setPW.text forKey:@"pwd"];
    [dic setObject:self.resetPW.text forKey:@"repwd"];
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
