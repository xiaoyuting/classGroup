//
//  ZCViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/1/20.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "ZCViewController.h"
#import "UMSocial.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"
#import "MBProgressHUD+Add.h"

#import "RegisterToPhoneViewController.h"
#import "ReMD.h"
#import "Passport.h"
#import "checkEmailViewController.h"
#import "RegisterToPhoneViewController.h"
#import "rootViewController.h"
#import "BaseClass.h"
#import "SJZCViewController.h"
#import "MyViewController.h"
#import "AppDelegate.h"
#import "UIView+Utils.h"
#import "XYViewController.h"



@interface ZCViewController ()

{
    BaseClass *base;
    UIImageView *_imgV ;
    int _tempnum;
}

@property (strong ,nonatomic)UITextField *EmailField;

@property (strong ,nonatomic)UITextField *NameField;

@property (strong ,nonatomic)UITextField *PassField;

@end

@implementation ZCViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    if ([self.type isEqualToString:@"123"]) {
        AppDelegate *app = [AppDelegate delegate];
        rootViewController * nv = (rootViewController *)app.window.rootViewController;
        [nv isHiddenCustomTabBarByBoolean:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    if ([self.type isEqualToString:@"123"]) {
        AppDelegate *app = [AppDelegate delegate];
        rootViewController * nv = (rootViewController *)app.window.rootViewController;
        [nv isHiddenCustomTabBarByBoolean:NO];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initer];
    [self addInfor];
}

- (void)initer {
    
    NSLog(@"%@",self.type);
    self.view.backgroundColor = [UIColor colorWithRed:237.f / 255 green:237.f / 255 blue:237.f / 255 alpha:1];
    self.navigationItem.title = @"注册";
}

- (void)addInfor {
    
    //添加View
    UIView *NavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    NavView.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [self.view addSubview:NavView];
    
    //添加按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 55, 50)];
    [backButton setImage:[UIImage imageNamed:@"ZCZC"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [NavView addSubview:backButton];

    //添加
    UILabel *ZCLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 50, 25, 100, 30)];
    ZCLabel.textAlignment = NSTextAlignmentCenter;
    ZCLabel.text = @"注册";
    ZCLabel.textColor = [UIColor whiteColor];
    ZCLabel.font = [UIFont systemFontOfSize:20];
    [NavView addSubview:ZCLabel];
    
    //添加登录按钮
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50, 20, 40, 40)];
    [addButton addTarget:self action:@selector(addPressed) forControlEvents:UIControlEventTouchUpInside];
    [addButton setTitle:@"登录" forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [NavView addSubview:addButton];
    
    //添加邮箱
    _EmailField = [[UITextField alloc] initWithFrame:CGRectMake(0, 151, MainScreenWidth, 50)];
    _EmailField.placeholder = @"邮箱";
    _EmailField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    _EmailField.leftViewMode = UITextFieldViewModeAlways;
    _EmailField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_EmailField];
    
    //添加呢称
    _NameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, MainScreenWidth, 50)];
    _NameField.placeholder = @"昵称";
    _NameField.backgroundColor = [UIColor whiteColor];
    _NameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    _NameField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_NameField];
    
    //添加密码
    _PassField = [[UITextField alloc] initWithFrame:CGRectMake(0, 202, MainScreenWidth, 50)];
    _PassField.placeholder = @"密码";
    _PassField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    _PassField.leftViewMode = UITextFieldViewModeAlways;
    _PassField.backgroundColor = [UIColor whiteColor];
    _PassField.secureTextEntry = YES;//密码形式
    [self.view addSubview:_PassField];
    
    
    //添加按钮
    
    UIButton *TJButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 300, MainScreenWidth - 40, 45)];
    [TJButton setTitle:@"提交" forState:UIControlStateNormal];
    [TJButton addTarget:self action:@selector(TJButton:) forControlEvents:UIControlEventTouchUpInside];
    TJButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    TJButton.layer.cornerRadius = 4;
    [self.view addSubview:TJButton];
    
    //服务协议
    _imgV = [[UIImageView alloc]initWithFrame:CGRectMake(TJButton.current_x, TJButton.current_y_h +20, 15, 15)];
    [self.view addSubview:_imgV];
    _imgV.image = [UIImage imageNamed:@"gl未选中"];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(_imgV.current_x_w +3, _imgV.current_y, 86, 15)];
    [self.view addSubview:lab];
    lab.text = @"我已阅读并同意";
    lab.textColor = [UIColor grayColor];
    lab.font = [UIFont systemFontOfSize:12];
    lab.textAlignment = NSTextAlignmentLeft;
    
    UIButton *FWbtn = [[UIButton alloc]initWithFrame:CGRectMake(lab.current_x_w, lab.current_y, 200, 15)];
    [self.view addSubview:FWbtn];
    [FWbtn setTitle:@"《云课堂服务协议》" forState:UIControlStateNormal];
    [FWbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    FWbtn.titleLabel.font = [UIFont systemFontOfSize:12];
    FWbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    FWbtn.backgroundColor = [UIColor redColor];
    FWbtn.alpha = 0.8;
    [FWbtn addTarget:self action:@selector(XYView) forControlEvents:UIControlEventTouchUpInside];

    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(TJButton.current_x, TJButton.current_y_h +20, 100, 15)];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    _tempnum = 1;
    
    //添加手机注册
    UIButton *SJButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 100, 260, 100, 30)];
    [SJButton setTitle:@"手机注册" forState:UIControlStateNormal];
    [SJButton setTitleColor:[UIColor colorWithRed:33.f / 255 green:87.f / 255 blue:198.f / 255 alpha:1] forState:UIControlStateNormal];
    SJButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [SJButton addTarget:self action:@selector(SJButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SJButton];
}

-(void)XYView{

    [self.navigationController pushViewController:[XYViewController new] animated:YES];
    
}

-(void)sure{

    if (_tempnum == 0) {
        _imgV.image = [UIImage imageNamed:@"gl未选中"];
        _tempnum = 1;
    }else{
    
        _imgV.image = [UIImage imageNamed:@"gl选中"];
        _tempnum = 0;
    }
}

- (void)backPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)addPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}
//手机注册
- (void)SJButton:(UIButton *)button {
    
    SJZCViewController *SJZCVC = [[SJZCViewController alloc] init];
    
    if ([_type isEqualToString:@"123"]) {
        SJZCVC.type = @"123";
    }
    [self.navigationController pushViewController:SJZCVC animated:YES];
}

- (void)TJButton:(UIButton *)button {
    if (_tempnum == 1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请先同意《云课堂服务协议》" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (self.EmailField.text.length == 0 || self.NameField.text.length == 0 || self.PassField.text.length == 0) {
        [MBProgressHUD showError:@"请提交所需完善资料" toView:self.view];
        return;
    }
    
    [self.EmailField resignFirstResponder];
    [self.NameField resignFirstResponder];
    [self.PassField resignFirstResponder];
    
    QKHTTPManager *manager = [QKHTTPManager manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:self.EmailField.text forKey:@"login"];
    [dic setValue:self.NameField.text forKey:@"uname"];
    [dic setValue:self.PassField.text forKey:@"password"];
    [dic setValue:@"1" forKey:@"type"];
    
    [manager registUser:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([msg isEqual:@"ok"]) {
            [self performSelector:@selector(thenGo) withObject:nil afterDelay:0.2];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"出错啦" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"register   %@",error);
    }];

    
}



-(void)thenGo
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setValue:self.EmailField.text forKey:@"uname"];
    [dic setValue: self.PassField.text forKey:@"upwd"];
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

            //应该直接到我的主界面
            MyViewController *myVC = [[MyViewController alloc] init];
//            [self.navigationController pushViewController:myVC animated:YES];
            if ([_type isEqualToString:@"123"]) {
                 [self.navigationController pushViewController:myVC animated:YES];
            } else {
                 [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            
            
        }else
        {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登陆错误" message:base.msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([textField.text isEqual:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"用户信息不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];
    }
    return YES;
}


- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
