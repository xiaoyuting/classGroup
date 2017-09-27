//
//  DLViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/1/20.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4 4s屏幕


#import "DLViewController.h"
#import "blumViewController.h"
#import "rootViewController.h"

#import "UMSocial.h"
#import "MyHttpRequest.h"
#import "BaseClass.h"
#import "Data.h"
#import "ZhiyiHTTPRequest.h"
#import "RegisterViewController.h"
#import "FindPasswordViewController.h"
#import "findOfEmailViewController.h"
#import "Passport.h"
#import "EaseMob.h"
#import "MyViewController.h"
#import "ZCViewController.h"
#import "WJMMViewController.h"
#import "MyViewController.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "SJZCViewController.h"


@interface DLViewController ()<UMSocialUIDelegate>

{
    BaseClass *base;
}

@property (strong ,nonatomic)UITextField *NameField;

@property (strong ,nonatomic)UITextField *PassField;

@property (strong ,nonatomic)UIButton *backButton;

@property (strong ,nonatomic)NSString *loginType;
@property (strong ,nonatomic)NSString *UID;
@property (strong ,nonatomic)NSString *appToken;

@end

@implementation DLViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nameAndPassword:) name:UITextFieldTextDidChangeNotification object:nil];
    
    
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initer];
    [self NavButton];
    [self addInfo];

}

- (void)initer {
    self.view.backgroundColor = [UIColor colorWithRed:237.f / 255 green:237.f / 255 blue:237.f / 255 alpha:1];
    self.navigationItem.title = @"登录";
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)NavButton {
    
    //添加view
    UIView *NavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    NavView.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [self.view addSubview:NavView];
    
    //添加登录
    UILabel *DLLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 50, 25, 100, 30)];
    DLLabel.text = @"登录";
    DLLabel.textColor = [UIColor whiteColor];
    DLLabel.font = [UIFont systemFontOfSize:20];
    DLLabel.textAlignment = NSTextAlignmentCenter;
    [NavView addSubview:DLLabel];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50, 20, 40, 40)];
    [addButton addTarget:self action:@selector(addPressed) forControlEvents:UIControlEventTouchUpInside];
    [addButton setTitle:@"注册" forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [NavView addSubview:addButton];
    
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 25, 30, 30)];
    [_backButton setImage:[UIImage imageNamed:@"dlgb"] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [NavView addSubview:_backButton];
    
    if (self.typeStr) {
        _backButton.hidden = NO;
        [_backButton addTarget:self action:@selector(goHomeVc) forControlEvents:UIControlEventTouchUpInside];
    }else {
        _backButton.hidden = NO;
    }
    

}

//退出登录界面
- (void)backPressed {
    
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)goHomeVc {
    MyViewController *myVC = [[MyViewController alloc] init];
    [self.navigationController pushViewController:myVC animated:YES];
}

//注册
- (void)addPressed {
    NSLog(@"1215151");
    ZCViewController *ZCVC = [[ZCViewController alloc] init];
    if (_backButton.hidden == YES) {//退出账号的
        ZCVC.type = @"123";
    }
    
    if ([_typeStr integerValue] == 123) {
        ZCVC.type = @"123";
    }
    
    [self.navigationController pushViewController:ZCVC animated:YES];
    
}

//用户名和密码限制长度为20
- (void)nameAndPassword:(NSNotification *)Not {
    NSLog(@"%@",Not.userInfo);
    if (_NameField.text.length >= 20) {

         self.NameField.text = [self.NameField.text substringToIndex:20];
        
    }
    if (_PassField.text.length >= 20) {

         self.PassField.text = [self.PassField.text substringToIndex:20];
    }
    
}




- (void)addInfo {
    
    //添加输入文本框
    UITextField *NameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 70, MainScreenWidth, 50)];
    NameField.placeholder = @"已注册邮箱/手机";
    NameField.backgroundColor = [UIColor whiteColor];
    NameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 0)];
    NameField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:NameField];
    _NameField = NameField;
    
    //添加输入图标
    UIButton *nameButton = [[UIButton alloc] initWithFrame:CGRectMake(17, 86 , 13, 18)];
    [nameButton setBackgroundImage:[UIImage imageNamed:@"iconfont-shouji@2x"] forState:UIControlStateNormal];
    [self.view addSubview:nameButton];

    //添加密码文本框
    UITextField *PassField = [[UITextField alloc] initWithFrame:CGRectMake(0, 121, MainScreenWidth , 50)];
    PassField.placeholder = @"密码";
    PassField.backgroundColor = [UIColor whiteColor];
    PassField.secureTextEntry = YES;//密码形式
    PassField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 0)];
    PassField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:PassField];
    _PassField = PassField;
    
    
    //添加密码图标
    UIButton *MMButton = [[UIButton alloc] initWithFrame:CGRectMake(17, 121 + 16, 13, 18)];
    [MMButton setBackgroundImage:[UIImage imageNamed:@"iconfont-mima@2x"] forState:UIControlStateNormal];
    [self.view addSubview:MMButton];
    
    
    //添加登录按钮
    UIButton *DLButton = [UIButton buttonWithType:UIButtonTypeSystem];
    DLButton.frame = CGRectMake(20, 210, MainScreenWidth - 40, 45);
    [DLButton setTitle:@"登录" forState:UIControlStateNormal];
    [DLButton addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
    DLButton.tag = 10;
    DLButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [DLButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    DLButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    DLButton.layer.cornerRadius = 4;
    [self.view addSubview:DLButton];
    
    //添加忘记密码按钮
    UIButton *WJButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 50, CGRectGetMaxY(DLButton.frame) + 30, 100, 20)];
    [WJButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    WJButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [WJButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [WJButton addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
    WJButton.tag = 20;
    [self.view addSubview:WJButton];
    

    if (self.typeStr) {//说明是从退出账号过来的
        UIButton *YKButton = [[UIButton alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(DLButton.frame) + 30, 100, 20)];
        [YKButton setTitle:@"游客登录" forState:UIControlStateNormal];
        YKButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [YKButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [YKButton addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
        YKButton.tag = 30;
        [self.view addSubview:YKButton];

        //设置忘记密码的位置
        WJButton.frame = CGRectMake(MainScreenWidth - 150, CGRectGetMaxY(DLButton.frame) + 30, 100, 20);
    }
    
    if (iPhone4SOriPhone4) {
        
        //添加横线
        UIButton *ZButton = [[UIButton alloc] initWithFrame:CGRectMake(0,MainScreenHeight / 5 * 3 + 50, MainScreenWidth / 2 - 60, 1)];
        ZButton.backgroundColor = [UIColor colorWithRed:223.f / 255 green:223.f / 255 blue:223.f / 255 alpha:1];
        [self.view addSubview:ZButton];
        
        UIButton *YButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 + 60,MainScreenHeight / 5 * 3 + 50, MainScreenWidth / 2 - 60, 1)];
        YButton.backgroundColor = [UIColor colorWithRed:223.f / 255 green:223.f / 255 blue:223.f / 255 alpha:1];
        [self.view addSubview:YButton];
        
        //添加第三方登录
        UILabel *SFLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 60, MainScreenHeight / 5 * 3 - 15 + 50, 120, 30)];
        SFLabel.text = @"第三方登录";
        SFLabel.textColor = [UIColor colorWithRed:200.f / 255 green:200.f / 255 blue:200.f / 255 alpha:1];
        SFLabel.font = [UIFont systemFontOfSize:14];
        SFLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:SFLabel];
        
        //添加三方登录按钮
        NSArray *SFArray = @[@"webo",@"qq@2x",@"weixin@2x"];
        for (int i = 0 ; i < 3; i ++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 7 + MainScreenWidth / 7  * 2 * i, MainScreenHeight / 5 * 3 + 100, MainScreenWidth / 7, MainScreenWidth / 7)];
            [button setBackgroundImage:[UIImage imageNamed:SFArray[i]] forState:UIControlStateNormal];
            button.tag = i;
            button.layer.cornerRadius = MainScreenWidth / 7 / 2;
            [button addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
        }
        
    }else {
        
        //添加横线
        UIButton *ZButton = [[UIButton alloc] initWithFrame:CGRectMake(0,MainScreenHeight / 5 * 3 + 50, MainScreenWidth / 2 - 60, 1)];
        ZButton.backgroundColor = [UIColor colorWithRed:223.f / 255 green:223.f / 255 blue:223.f / 255 alpha:1];
        [self.view addSubview:ZButton];
        
        UIButton *YButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 + 60,MainScreenHeight / 5 * 3 + 50, MainScreenWidth / 2 - 60, 1)];
        YButton.backgroundColor = [UIColor colorWithRed:223.f / 255 green:223.f / 255 blue:223.f / 255 alpha:1];
        [self.view addSubview:YButton];
        
        //添加第三方登录
        UILabel *SFLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 60, MainScreenHeight / 5 * 3 - 15 + 50, 120, 30)];
        SFLabel.text = @"第三方登录";
        SFLabel.textColor = [UIColor colorWithRed:200.f / 255 green:200.f / 255 blue:200.f / 255 alpha:1];
        SFLabel.font = [UIFont systemFontOfSize:14];
        SFLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:SFLabel];

        //添加三方登录按钮
        NSArray *SFArray = @[@"webo@2x",@"qq@2x",@"weixin@2x"];
        for (int i = 0 ; i < 3; i ++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 7 + MainScreenWidth / 7  * 2 * i, MainScreenHeight / 5 * 3 + 100, MainScreenWidth / 7, MainScreenWidth / 7)];
            [button setBackgroundImage:[UIImage imageNamed:SFArray[i]] forState:UIControlStateNormal];
            button.tag = i;
            button.layer.cornerRadius = MainScreenWidth / 7 / 2;
            [button addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
        }
    }
}

- (void)SYGButton:(UIButton *)button {
    
    if (button.tag == 10) {//登录
        [self Login];
    }
    if (button.tag == 20) {//忘记密码
        [self WJMM];
    }
    if (button.tag == 30) {//游客登录
        [self addYKDL];
    }
    if (button.tag == 0) {//新浪
        [self Sina];
    }
    if (button.tag == 1) {//扣扣
        [self Tencent];
    }
    if (button.tag == 2) {//微信
        [self WeChat];
    }
    
}

- (void)Login {
    
    if ([_NameField.text isEqual:@""] || _PassField.text.length < 6) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"账号或密码不正确" message:nil delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self.NameField resignFirstResponder];
    [self.PassField resignFirstResponder];
    [self LoginRequset];
}

- (void)WJMM {
    
    WJMMViewController *WJMMVC = [[WJMMViewController alloc] init];
    
    WJMMVC.typeStr = self.typeStr;
    
    [self.navigationController pushViewController:WJMMVC animated:YES];
}

- (void)addYKDL {
    
    MyViewController *myVC = [[MyViewController alloc] init];
    
    [self.navigationController pushViewController:myVC animated:YES];
}

- (void)Sina {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
//    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //          获取微博用户名、uid、token等
        
        NSLog(@"-----%@",response);
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            _UID = snsAccount.openId;
            _appToken = snsAccount.unionId;
            
            [self loginWithSNSAccount:snsAccount loginType:@"sina"];
        }});
}



- (void)Tencent {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        
        NSLog(@"%@",response);
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            _UID = snsAccount.openId;
            _appToken = snsAccount.unionId;
            
            [self loginWithSNSAccount:snsAccount loginType:@"tencent"];
        }});
}

- (void)WeChat {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        NSLog(@"----%@",response);
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            _UID = snsAccount.openId;
            _appToken = snsAccount.unionId;
            
            NSLog(@"%@",_UID);
            
            [self loginWithSNSAccount:snsAccount loginType:@"weixin"];
        }});
    
    
}

- (void)loginWithSNSAccount:(UMSocialAccountEntity *)snsAccount loginType:(NSString *)type
{
    ZhiyiHTTPRequest * manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    /*
     if ([snsAccount.platformName isEqualToString:UMShareToSina]) {
     //新浪平台的特殊处理
     }
     if ([snsAccount.platformName isEqualToString:UMShareToTencent]) {
     //腾讯微博平台的特殊处理
     }
     if ([snsAccount.platformName isEqualToString:UMShareToQQ] || [snsAccount.platformName isEqualToString:UMShareToQzone]) {
     //qq/空间平台的特殊处理
     }
     if ([snsAccount.platformName isEqualToString:UMShareToRenren]) {
     //人人平台的特殊处理
     }
     */
    NSLog(@">>>%@",snsAccount);
    [dic setValue:snsAccount.unionId forKey:@"app_token"];
    [dic setValue:type forKey:@"app_login_type"];
    [[NSUserDefaults standardUserDefaults]setObject:type forKey:@"loginType"];
    
    
    [manager userLoginOfThirdParty:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        NSLog(@"%@",operation);
        NSLog(@"%@",responseObject[@"msg"]);
        _loginType = type;
        if ([responseObject[@"code"] integerValue] != 0) {//没有绑定
            [self type_regis];
            return ;
        }
        
        base = [BaseClass modelObjectWithDictionary:responseObject];
        [[NSUserDefaults standardUserDefaults]setObject:base.data.oauthToken forKey:@"oauthToken"];
        [[NSUserDefaults standardUserDefaults]setObject:base.data.oauthTokenSecret forKey:@"oauthTokenSecret"];
        [[NSUserDefaults standardUserDefaults]setObject:base.data.uid forKey:@"User_id"];
        [[NSUserDefaults standardUserDefaults]setObject:base.data.userface forKey:@"userface"];
        if (base.code == 0) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [Passport userDataWithSavelocality:base.data];
            });
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:@"8001" password:@"111111" completion:^(NSDictionary *loginInfo, EMError *error) {
                if (!error) {
                    // 设置自动登录
                    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                }
            } onQueue:nil];
            rootViewController *blum = [[rootViewController alloc]init];
            self.view.window.rootViewController = blum;
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登陆错误" message:base.msg delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)LoginRequset {
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setValue:self.NameField.text forKey:@"uname"];
    [dic setValue: self.PassField.text forKey:@"upwd"];
    [manager userLogin:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",operation);
        base = [BaseClass modelObjectWithDictionary:responseObject];
        [[NSUserDefaults standardUserDefaults]setObject:base.data.oauthToken forKey:@"oauthToken"];
        [[NSUserDefaults standardUserDefaults]setObject:base.data.oauthTokenSecret forKey:@"oauthTokenSecret"];
        [[NSUserDefaults standardUserDefaults]setObject:base.data.uid forKey:@"User_id"];
        [[NSUserDefaults standardUserDefaults]setObject:base.data.userface forKey:@"userface"];
        if (base.code == 0) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [Passport userDataWithSavelocality:base.data];
            });
            
//            rootViewController *blum = [[rootViewController alloc]init];
//            self.view.window.rootViewController = blum;
            
            //MyViewController * more = [[MyViewController alloc]init];
            //self.view.window.rootViewController = more;
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
            NSLog(@"%@",self.typeStr);
            if ([self.typeStr isEqualToString:@"123"]) {//从设置页面过来
                MyViewController *myVC = [[MyViewController alloc] init];
                [self.navigationController pushViewController:myVC animated:YES];
                
            } else {
                 [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            
            //在登录成功的地方将数据保存下来
            [[NSUserDefaults standardUserDefaults]setObject:self.NameField.text forKey:@"uname"];
            [[NSUserDefaults standardUserDefaults]setObject:self.PassField.text forKey:@"upwd"];
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"账号或密码不正确" message:base.msg delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",operation);
    }];

    
}


//移除警告框
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}


- (void)type_regis {
    SJZCViewController *phoneVc = [[SJZCViewController alloc] init];
    if (_backButton.hidden == YES) {//退出账号的
        phoneVc.type = @"123";
    }
    phoneVc.loginType = _loginType;
    phoneVc.UID = _UID;
    phoneVc.appToken = _appToken;
    NSLog(@"%@",_appToken);
    [self.navigationController pushViewController:phoneVc animated:YES];
    
}

@end
