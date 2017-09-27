//
//  RegisterToPhoneViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/2.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "RegisterToPhoneViewController.h"
#import "RegisterViewController.h"
#import "TestForPhoneViewController.h"
#import "MyHttpRequest.h"
#import "PhoneMd.h"
@interface RegisterToPhoneViewController ()

@end

@implementation RegisterToPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)backClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)RegisterToEmai:(id)sender
{
//    TestForPhoneViewController *r =  [[UIStoryboard storyboardWithName:@"UserLoginViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"testP"];
//    [self.navigationController pushViewController:r animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)next:(id)sender
{
    self.phoneNumber = self.phone.text;
    [self requestToTestingCodepage:YES];
}
-(void)requestToTestingCodepage:(BOOL)page
{
    QKHTTPManager *manager = [QKHTTPManager manager];
//    __block PhoneMd *p = [[PhoneMd alloc]init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:self.phoneNumber forKey:@"phone"];
    if (self.phoneNumber.length < 9)
    {
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:nil message:@"请填写正确手机号码" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [aler show];
        return;
    }
    [manager phoneVerification:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [responseObject objectForKey:@"msg"];
        if ([str isEqual:@"ok"]) {
            if (page == YES)
            {
                TestForPhoneViewController *rVc = [[UIStoryboard storyboardWithName:@"UserLoginViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"testP"];
                rVc.phoneNum =self.phone.text;
                [self presentViewController:rVc animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"短信已发送，请注意查收" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
            }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"phone %@",error);
    }];
}
- (void)alertViewCancel:(UIAlertView *)alertView
{
    TestForPhoneViewController *t = [[TestForPhoneViewController alloc]init];
    [self.navigationController pushViewController:t animated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view resignFirstResponder];
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
