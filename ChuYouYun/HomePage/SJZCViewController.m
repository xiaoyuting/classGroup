//
//  SJZCViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/1/20.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "SJZCViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "RegisterToPhoneViewController.h"
#import "PhoneMd.h"
#import "SenUIDAndPDViewController.h"
#import "RegisterToPhoneViewController.h"
#import "MyHttpRequest.h"
#import "MZTimerLabel.h"
#import "MyViewController.h"
#import "BaseClass.h"
#import "ReMD.h"
#import "Passport.h"
#import "AppDelegate.h"
#import "UIView+Utils.h"
#import "MBProgressHUD+Add.h"

#import "XYViewController.h"



@interface SJZCViewController ()
{
    BaseClass *base;
    UIImageView *_imgV ;
    int _tempnum;
}

@property (strong ,nonatomic)UITextField *PhoneField;

@property (strong ,nonatomic)UITextField *NameField;

@property (strong ,nonatomic)UITextField *PassField;

//邀请码
//@property (strong ,nonatomic)UITextField *YQMField;


@property (strong ,nonatomic)UITextField *YZMField;

@property (strong ,nonatomic)UIView *waitView;

@property (strong ,nonatomic)UILabel *waitLabel;

@property (strong ,nonatomic)NSTimer *timer;

@property (assign ,nonatomic)NSInteger number;

@property (strong ,nonatomic)UIButton *YZMButton;

@end

@implementation SJZCViewController


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
    [self addPhone];

}

- (void)initer {
    self.view.backgroundColor = [UIColor colorWithRed:237.f / 255 green:237.f / 255 blue:237.f / 255 alpha:1];
    self.navigationItem.title = @"注册";
}

- (void)addPhone {
    
    
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
    
    //添加手机号
    _PhoneField = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, MainScreenWidth, 50)];
    _PhoneField.placeholder = @"请输入手机号";
    _PhoneField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    _PhoneField.leftViewMode = UITextFieldViewModeAlways;
    _PhoneField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_PhoneField];
    _PhoneField.userInteractionEnabled = YES;
    
    //添加发送验证码
    UIButton *YZMButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 100, 7 + 100, 80, 36)];
    [YZMButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [YZMButton addTarget:self action:@selector(YZMButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    YZMButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [YZMButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    YZMButton.layer.cornerRadius = 3;
    YZMButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:YZMButton];
    _YZMButton = YZMButton;
    
    //添加呢称
    _NameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 202, MainScreenWidth, 50)];
    _NameField.placeholder = @"请输入昵称";
    _NameField.backgroundColor = [UIColor whiteColor];
    _NameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    _NameField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_NameField];
    
    //添加验证码
    _YZMField = [[UITextField alloc] initWithFrame:CGRectMake(0, 151, MainScreenWidth, 50)];
    _YZMField.placeholder = @"请输入验证码";
    _YZMField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    _YZMField.leftViewMode = UITextFieldViewModeAlways;
    _YZMField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_YZMField];
    
    //添加密码
    _PassField = [[UITextField alloc] initWithFrame:CGRectMake(0, 253, MainScreenWidth, 50)];
    _PassField.placeholder = @"请输入密码";
    _PassField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    _PassField.leftViewMode = UITextFieldViewModeAlways;
    _PassField.backgroundColor = [UIColor whiteColor];
    _PassField.secureTextEntry = YES;//密码形式
    [self.view addSubview:_PassField];
    
//    //添加密码
//    _YQMField = [[UITextField alloc] initWithFrame:CGRectMake(0, 304, MainScreenWidth, 50)];
//    _YQMField.placeholder = @"请输入邀请码";
//    _YQMField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
//    _YQMField.leftViewMode = UITextFieldViewModeAlways;
//    _YQMField.backgroundColor = [UIColor whiteColor];
//    _YQMField.secureTextEntry = YES;//密码形式
//    [self.view addSubview:_YQMField];
    
    //添加按钮
    UIButton *TJButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 355, MainScreenWidth - 40, 45)];
    [TJButton setTitle:@"提交" forState:UIControlStateNormal];
    [TJButton addTarget:self action:@selector(TJButtonCilck) forControlEvents:UIControlEventTouchUpInside];
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
    
}
-(void)XYView{
    
    [self.navigationController pushViewController:[XYViewController new] animated:YES];
    
}
- (void)TJButtonCilck {
    
    if (_tempnum == 1) {
        [MBProgressHUD showError:@"请先同意《云课堂服务协议》" toView:self.view];
        return;
    }
    
    if (_PhoneField.text.length == 0 || _PhoneField.text.length != 11 ) {
        [MBProgressHUD showError:@"请输入手机号或正确的格式" toView:self.view];
        return;
    }else if (_YZMField.text.length == 0){
        [MBProgressHUD showError:@"请输入验证码" toView:self.view];
        return;
    }else if (_PassField.text.length == 0){
        [MBProgressHUD showError:@"请输入密码" toView:self.view];
        return;
    }    
    
    if (_loginType) {//第三方绑定
        [self loginWithType];
    } else {
        [self TJNetWork];
    }
    
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
}

- (void)YZMButtonPressed {

    if (_PhoneField.text.length == 0 || _PhoneField.text.length != 11 ) {
        [MBProgressHUD showError:@"请输入手机号或正确的格式" toView:self.view];
        return;
        
    } else {
        
        QKHTTPManager *manager = [QKHTTPManager manager];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:self.PhoneField.text forKey:@"phone"];
        
        [manager phoneVerification:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            NSLog(@"%@",responseObject[@"msg"]);
            NSString *str = [responseObject objectForKey:@"msg"];
            
            if ([str isEqual:@"ok"]){
                [MBProgressHUD showSuccess:@"已发送,请查收" toView:self.view];
                _number = 0;
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timePast) userInfo:nil repeats:YES];
                _YZMButton.enabled = NO;
                
            }else{
                [MBProgressHUD showError:str toView:self.view];
            }
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        }];
    }
}

- (void)timePast {
    
    _number ++;
    NSInteger endTime = 60 - _number;
    NSString *endString = [NSString stringWithFormat:@"%ld", endTime];
    NSString *MStr = [NSString stringWithFormat:@"%@S后重发",endString];
    [_YZMButton setTitle:MStr forState:UIControlStateNormal];
    
    if ([_YZMButton.titleLabel.text isEqualToString:@"0S后重发"]) {
        
        _YZMButton.enabled = YES;
        [_YZMButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_timer invalidate];
        _number = 0;
    }
}

-(void)thenGo
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _waitView.alpha =0;
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

- (void)TJNetWork {
    
    QKHTTPManager *manager = [QKHTTPManager manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    NSLog(@"-----%@",self.PhoneField.text);
    [dic setObject:self.PhoneField.text forKey:@"login"];
    [dic setObject:_NameField.text forKey:@"uname"];
    [dic setObject:_PassField.text forKey:@"password"];
    [dic setObject:@"2" forKey:@"type"];
    [dic setObject:_YZMField.text forKey:@"code"];
    
    [manager phoneZC:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *str = [responseObject objectForKey:@"msg"];
        if ([str isEqual:@"ok"]) {
            //注册成功
             base = [BaseClass modelObjectWithDictionary:responseObject];
            [[NSUserDefaults standardUserDefaults]setObject:base.data.oauthToken forKey:@"oauthToken"];
            [[NSUserDefaults standardUserDefaults]setObject:base.data.oauthTokenSecret forKey:@"oauthTokenSecret"];
            [[NSUserDefaults standardUserDefaults]setObject:base.data.uid forKey:@"User_id"];
            [[NSUserDefaults standardUserDefaults]setObject:base.data.userface forKey:@"userface"];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [Passport userDataWithSavelocality:base.data];
            });
            [MBProgressHUD showSuccess:@"注册成功" toView:self.view];
            MyViewController *myVC = [[MyViewController alloc] init];
           
            if ([_type isEqualToString:@"123"]) {
                //说明不是第一次
                 [self.navigationController pushViewController:myVC animated:YES];
            } else {//第一次
                 [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            
        } else{
            [MBProgressHUD showError:str toView:self.view];
        }
        [self performSelector:@selector(thenGo) withObject:nil afterDelay:2];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
}




#pragma mark --- 第三方登录

- (void)loginWithType {
    
    QKHTTPManager *manager = [QKHTTPManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.NameField.text forKey:@"uname"];
    [dict setValue:self.PassField.text forKey:@"password"];
    [dict setValue:_loginType forKey:@"type_oauth"];
    [dict setValue:@"2" forKey:@"type"];
    [dict setValue:_appToken forKey:@"type_uid"];
    [dict setObject:self.PhoneField.text forKey:@"login"];
    [dict setObject:_YZMField.text forKey:@"code"];
    
    NSLog(@"%@",_appToken);
    NSLog(@"%@",dict);
    

    
    [manager phoneZC:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",operation);
        NSString *msg = responseObject[@"msg"];
        if ([msg isEqualToString:@"ok"]) {//成功 登录
            
            base = [BaseClass modelObjectWithDictionary:responseObject];
            [[NSUserDefaults standardUserDefaults]setObject:base.data.oauthToken forKey:@"oauthToken"];
            [[NSUserDefaults standardUserDefaults]setObject:base.data.oauthTokenSecret forKey:@"oauthTokenSecret"];
            [[NSUserDefaults standardUserDefaults]setObject:base.data.uid forKey:@"User_id"];
            [[NSUserDefaults standardUserDefaults]setObject:base.data.userface forKey:@"userface"];
            //登录
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            if ([self.type isEqualToString:@"123"]) {//从设置页面过来
                MyViewController *myVC = [[MyViewController alloc] init];
                [self.navigationController pushViewController:myVC animated:YES];
            } else {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}





@end
