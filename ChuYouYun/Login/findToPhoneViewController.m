//
//  findToPhoneViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/7.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "findToPhoneViewController.h"
#import "findOfEmailViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "TesttingPhoneCode.h"

@interface findToPhoneViewController ()

@end

@implementation findToPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)toEmail:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)backClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)nextClick:(id)sender
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:self.phoneNumber.text forKey:@"phone"];
    self.PhoneStr = self.phoneNumber.text;
    [manager findPWDSendCode:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([msg isEqualToString:@"ok"])
        {
            TesttingPhoneCode *fe =  [[UIStoryboard storyboardWithName:@"UserLoginViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"testC"];
            fe.phoneStr =self.phoneNumber.text;
            [self presentViewController:fe animated:YES completion:nil];
        }
        else
        {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"返回重试" otherButtonTitles:nil, nil];
        [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



@end
