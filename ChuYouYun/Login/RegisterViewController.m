//
//  RegisterViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/23.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserLoginViewController.h"
#import "UMSocial.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"
#import "RegisterToPhoneViewController.h"
#import "ReMD.h"
#import "Passport.h"
#import "checkEmailViewController.h"
#import "RegisterToPhoneViewController.h"
#import "rootViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.reBtn.layer setMasksToBounds:YES];
    [self.reBtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [self.reBtn.layer setBorderWidth:1.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
    [self.reBtn.layer setBorderColor:colorref];//边框颜色
    
    [self.reBtn.layer setMasksToBounds:YES];
    [self.reBtn.layer setCornerRadius:10.0];
    self.userName.delegate = self;
    self.UserPassword.delegate = self;
    self.email.delegate = self;
    self.email.tag = 1;
    
    _waitView.layer.cornerRadius =5;
    _waitView.layer.masksToBounds =YES;
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([textField.text isEqual:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"用户信息不能为空" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
    }
    return YES;
}
- (IBAction)backClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)registerClick:(id)sender
{
    [_activityView startAnimating];
    _waitView.alpha =0.8;
    
    [self.email resignFirstResponder];
    [self.userName resignFirstResponder];
    [self.UserPassword resignFirstResponder];
    
    QKHTTPManager *manager = [QKHTTPManager manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:self.email.text forKey:@"login"];
    [dic setValue:self.userName.text forKey:@"uname"];
    [dic setValue:self.UserPassword.text forKey:@"password"];
    [dic setValue:@"1" forKey:@"type"];
    
//    __block ReMD *re = [[ReMD alloc]init];
    [manager registUser:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([msg isEqual:@"ok"])
        {
            [self performSelector:@selector(thenGo) withObject:nil afterDelay:2];
            
//            NSFileManager *f = [NSFileManager defaultManager];
//            NSString* Path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)[0];
//            NSString *filePath = [Path stringByAppendingPathComponent:@"userInfo.plist"];
//            if([f fileExistsAtPath:filePath])
//            {
//                [f removeItemAtPath:filePath error:nil];
//            }
//            [Passport userDataWithSavelocality:re.data];
//            checkEmailViewController *cVc = [[UIStoryboard storyboardWithName:@"UserLoginViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"check"];
//            [self presentViewController:cVc animated:YES completion:nil];
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
    [dic setValue:self.email.text forKey:@"uname"];
    [dic setValue: self.UserPassword.text forKey:@"upwd"];
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

- (IBAction)toPhoneRe:(id)sender
{
    RegisterToPhoneViewController *rVc = [[UIStoryboard storyboardWithName:@"UserLoginViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"rePhone"];
    [self presentViewController:rVc animated:YES completion:nil];
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
