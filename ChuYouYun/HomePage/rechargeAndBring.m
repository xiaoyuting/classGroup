//
//  rechargeAndBring.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/27.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "rechargeAndBring.h"
#import "TopUpViewController.h"
#import "AppDelegate.h"
#import "RechanrgViewController.h"
#import "SYG.h"

@interface rechargeAndBring ()
{
    BOOL who;
}
@end

@implementation rechargeAndBring


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
}

-(id)initWithRechargeAndBring:(BOOL)isWho
{
    self = [super init];
    
    if (self) {
        
        who = isWho;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNav];
    self.navigationItem.title = self.selfTitle;
    if (who == 0) {
        self.selfTitle = @"提现";
        self.btnTitle = @"立即提现";
    }else{
        self.selfTitle = @"充值";
        self.btnTitle = @"立即充值";
    }

    [self.rAndB setTitle:self.btnTitle forState:0];
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    if (who == 0) {
        
        WZLabel.text = @"提现";
        
    }else {
        
        WZLabel.text = @"充值";
    }
    
    [WZLabel setTextColor:BasidColor];
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    _numberText.delegate = self;
    [_numberText becomeFirstResponder];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rAndBClick:(id)sender {
//    self.navigationItem.title = self.selfTitle;
//    if (who == 0) {
//        
//    }else
//    {
//        Alipay *pay = [[Alipay alloc]initWithOrder:@"00" Cname:@"元充值" ctitle:@"元充值" Cprice:self.numberText.text];
//        [pay reloadAlipay];
//    }
    if (who == 0) {
        if (_numberText.text.length > 0) {
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"暂时还不支持" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入提现金额" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];

        }
        
    } else {
        if (_numberText.text.length > 0 ) {//说明可以充值进入下个界面
//            TopUpViewController *topUpVC = [[TopUpViewController alloc] init];
//            topUpVC.moneyString = _numberText.text;
//            [self.navigationController pushViewController:topUpVC animated:YES];
            
            RechanrgViewController *rechanrgVC = [[RechanrgViewController alloc] init];
            rechanrgVC.navigationController.navigationBarHidden =YES;
            
            [self.navigationController pushViewController:rechanrgVC animated:YES];
            
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入充值金额" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
    }

}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark --- 体现的网络请求





@end
