//
//  TestForPhoneViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/2.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "TestForPhoneViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "RegisterToPhoneViewController.h"
#import "PhoneMd.h"
#import "SenUIDAndPDViewController.h"
#import "RegisterToPhoneViewController.h"
#import "MyHttpRequest.h"
#import "MZTimerLabel.h"

@interface TestForPhoneViewController ()

@end

@implementation TestForPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _waitView.layer.cornerRadius =5;
    _waitView.layer.masksToBounds =YES;
}

- (IBAction)repetitiveClick:(id)sender
{
    QKHTTPManager *manager = [QKHTTPManager manager];
    //    __block PhoneMd *p = [[PhoneMd alloc]init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:self.phoneNum forKey:@"phone"];
    
    [manager phoneVerification:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [responseObject objectForKey:@"msg"];
        if ([str isEqual:@"ok"])
        {
            _waitView.alpha =0.8;
            _waitLabel.text =@"已发送,请查收";
        }
        else
        {
            _waitView.alpha =0.8;
            _waitLabel.text =@"请勿频繁请求";
        }
        [self performSelector:@selector(thenGo) withObject:nil afterDelay:2];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
    }];
}

-(void)thenGo
{
    [UIView animateWithDuration:0.3 animations:^{
        _waitView.alpha =0;
    }];
}

- (IBAction)backClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)next:(id)sender
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:self.phoneNum forKey:@"login"];
    [dic setObject:self.testingCode.text forKey:@"code"];
    [manager userTestingPhone:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"0"])
        {
//            RegisterToPhoneViewController *rVc = [[UIStoryboard storyboardWithName:@"UserLoginViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"send"];
//            [self presentViewController:rVc animated:YES completion:nil];
            
            SenUIDAndPDViewController *sVc = [[UIStoryboard storyboardWithName:@"UserLoginViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"send"];
            sVc.codeStr =self.testingCode.text;
            sVc.phoneStr =self.phoneNum;
            [self presentViewController:sVc animated:YES completion:nil];
        }
        else
        {
            NSString *msg = [responseObject objectForKey:@"msg"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"再试试吧" otherButtonTitles:nil, nil];
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
