//
//  WJMMViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/1/21.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "WJMMViewController.h"
#import "findOfEmailViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "TesttingPhoneCode.h"
#import "RegisterToPhoneViewController.h"
#import "PhoneMd.h"
#import "SenUIDAndPDViewController.h"
#import "RegisterToPhoneViewController.h"
#import "MyHttpRequest.h"
#import "MZTimerLabel.h"
#import "YXZHViewController.h"
#import "ZHCGViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD+Add.h"
#import "UIView+Utils.h"

@interface WJMMViewController ()

@property (strong ,nonatomic)UITextField *phoneField;

@property (strong ,nonatomic)UITextField *YZMField;

@property (strong ,nonatomic)UITextField *XMMField;

@property (strong ,nonatomic)UIView *waitView;

@property (strong ,nonatomic)UILabel *waitLabel;

@end

@implementation WJMMViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    if ([self.typeStr isEqualToString:@"123"]) {
        AppDelegate *app = [AppDelegate delegate];
        rootViewController * nv = (rootViewController *)app.window.rootViewController;
        [nv isHiddenCustomTabBarByBoolean:YES];
    }

    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    if ([self.typeStr isEqualToString:@"123"]) {
        AppDelegate *app = [AppDelegate delegate];
        rootViewController * nv = (rootViewController *)app.window.rootViewController;
        [nv isHiddenCustomTabBarByBoolean:NO];
    }

    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initer];
    [self addPhone];
}

- (void)initer {
    NSLog(@"%@",self.typeStr);
    
    self.view.backgroundColor = [UIColor colorWithRed:237.f / 255 green:237.f / 255 blue:237.f / 255 alpha:1];
    self.navigationItem.title = @"找回密码";
}

- (void)addPhone {
    
    
    //添加View
    UIView *NavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    NavView.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [self.view addSubview:NavView];
    
    //添加按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(18, 30, 14, 23)];
    [backButton setImage:[UIImage imageNamed:@"ArrowWJ"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [NavView addSubview:backButton];

    //添加
    UILabel *ZCLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 50, 25, 100, 30)];
    ZCLabel.textAlignment = NSTextAlignmentCenter;
    ZCLabel.text = @"找回密码";
    ZCLabel.textColor = [UIColor whiteColor];
    ZCLabel.font = [UIFont systemFontOfSize:20];
    [NavView addSubview:ZCLabel];
    
    //添加输入文本框
    //添加呢称
    _phoneField = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, MainScreenWidth, 50)];
    _phoneField.placeholder = @"手机号";
    _phoneField.backgroundColor = [UIColor whiteColor];
    _phoneField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    _phoneField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_phoneField];
    
    //添加发送验证码
    UIButton *YZMButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 100, 7 + 100, 80, 36)];
    [YZMButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [YZMButton addTarget:self action:@selector(YZMButton) forControlEvents:UIControlEventTouchUpInside];
    YZMButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [YZMButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    YZMButton.layer.cornerRadius = 3;
    YZMButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:YZMButton];

    //验证码
    _YZMField= [[UITextField alloc] initWithFrame:CGRectMake(0, 151, MainScreenWidth, 50)];
    _YZMField.placeholder = @"验证码";
    _YZMField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    _YZMField.leftViewMode = UITextFieldViewModeAlways;
    _YZMField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_YZMField];
    
    
    //添加新密码
    _XMMField = [[UITextField alloc] initWithFrame:CGRectMake(0, 202, MainScreenWidth, 50)];
    _XMMField.placeholder = @"请输入6-12位字符的新密码";
    _XMMField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    _XMMField.leftViewMode = UITextFieldViewModeAlways;
    _XMMField.backgroundColor = [UIColor whiteColor];
    _XMMField.secureTextEntry = YES;//密码形式
    [self.view addSubview:_XMMField];
    
    
    //添加手机注册
    UIButton *SJButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 100, 260, 100, 30)];
    [SJButton setTitle:@"邮箱找回" forState:UIControlStateNormal];
    [SJButton setTitleColor:[UIColor colorWithRed:31.f / 255 green:65.f / 255 blue:192.f / 255 alpha:1] forState:UIControlStateNormal];
    SJButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [SJButton addTarget:self action:@selector(SJButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:SJButton];
    
    //提交
    UIButton *TJButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 300, MainScreenWidth - 40, 45)];
    [TJButton setTitle:@"提交" forState:UIControlStateNormal];
    [TJButton addTarget:self action:@selector(TJButton) forControlEvents:UIControlEventTouchUpInside];
    TJButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    TJButton.layer.cornerRadius = 4;
    [self.view addSubview:TJButton];

}

- (void)SJButton:(UIButton *)button {
    
    YXZHViewController *YXZHVC = [[YXZHViewController alloc] init];
    YXZHVC.typeStr = self.typeStr;
    [self.navigationController pushViewController:YXZHVC animated:YES];
}

- (void)YZMButton {
    if (_phoneField.text.length == 0) {
        [MBProgressHUD showError:@"请输入手机号" toView:self.view];
        return;
    }
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:self.phoneField.text forKey:@"phone"];
    self.PhoneStr = self.phoneField.text;
    [manager findPWDSendCode:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([msg isEqualToString:@"ok"]) {//成功
            [MBProgressHUD showSuccess:@"发送成功，请查收" toView:self.view];
        } else {
            [MBProgressHUD showSuccess:msg toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [MBProgressHUD showSuccess:@"请求失败，请检查网络" toView:self.view];
    }];

    
}


- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)TJButton {
    
    if (_phoneField.text.length == 0 || _phoneField.text.length != 11) {
        [MBProgressHUD showError:@"请输入手机号或正确的手机号" toView:self.view];
        return;
    }else if (_YZMField.text.length == 0){
        [MBProgressHUD showError:@"请输入验证码" toView:self.view];
        return;
    }else if (_XMMField.text.length == 0){
        [MBProgressHUD showError:@"请输入新密码" toView:self.view];
        return;
    }
    else {
        
        [self TJNetWork];
    }
}

//验证码
- (void)YZMButtonPressed {
    
    if (_phoneField.text.length == 0 || _phoneField.text.length != 11) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"请输入手机号或正确的手机号" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alter show];
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alter repeats:YES];
        return;
    }

    QKHTTPManager *manager = [QKHTTPManager manager];
    //    __block PhoneMd *p = [[PhoneMd alloc]init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:self.phoneField.text forKey:@"phone"];

    [self.view addSubview:_waitView];

    
    [manager phoneVerification:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *str = [responseObject objectForKey:@"msg"];
        if ([str isEqual:@"ok"]){
            [MBProgressHUD showSuccess:@"已发送,请查收" toView:self.view];
        } else {
            [MBProgressHUD showError:str toView:self.view];
        }
        [self performSelector:@selector(thenGo) withObject:nil afterDelay:2];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
    }];

}


- (void)TJNetWork {
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:self.phoneField.text forKey:@"phone"];
    self.PhoneStr = self.phoneField.text;
    [dic setObject:_YZMField.text forKey:@"code"];
    [dic setObject:_XMMField.text forKey:@"pwd"];
    [dic setObject:_XMMField.text forKey:@"repwd"];
    [manager TJPWDSendCode:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([msg isEqualToString:@"ok"]) {//成功
//            ZHCGViewController *ZHCGVC = [[ZHCGViewController alloc] init];
//            [self.navigationController pushViewController:ZHCGVC animated:YES];
            [MBProgressHUD showSuccess:@"找回成功" toView:self.view];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



-(void)thenGo
{
    [UIView animateWithDuration:0.3 animations:^{
        _waitView.alpha =0;
    }];
}


//键盘消失
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}



@end
