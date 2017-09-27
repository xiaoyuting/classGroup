//
//  MyBankViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/28.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "MyBankViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "bankBaseClass.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "AmendBankViewController.h"
#import "SYG.h"


@interface MyBankViewController ()

@property (strong ,nonatomic)UIButton *addButton;

@end

@implementation MyBankViewController


-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNav];
    self.navigationItem.title = @"我的银行卡";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
    self.str = @"0";
    
    [self requestbankData];
    [self viewLoad];

    
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"我的银行卡";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    //添加功能
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 30, 50, 30)];
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(goSetBankcard) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:addButton];
    _addButton = addButton;
    
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:lineButton];
 
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)viewLoad
{
    //添加功能
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    [self.navigationItem setRightBarButtonItem:addItem];
    [addButton addTarget:self action:@selector(goSetBankcard) forControlEvents:UIControlEventTouchUpInside];

}
-(void)requestbankData
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [manager requestBank:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"-----%@",responseObject);
        NSString *msg = [responseObject objectForKey:@"msg"];
        self.str = msg;
        _bankDic = responseObject[@"data"];
        
        bankBaseClass *bb = [[bankBaseClass alloc]initWithDictionary:[responseObject objectForKey:@"data"]];
        
        
        
        if ([_bankDic isEqual:[NSNull null]]) {//还没有添加银行卡的
            
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
            imageView.image = [UIImage imageNamed:@"银行卡@2x"];
            [self.view addSubview:imageView];
            
            _addButton.hidden = NO;

          
        } else {
            
            _addButton.hidden = YES;
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 60)];
            view.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:view];
            
            //添加银行图片
            UIButton *YHButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 20, 20)];
            [YHButton setBackgroundImage:[UIImage imageNamed:@"银行图标@2x"] forState:UIControlStateNormal];
            [view addSubview:YHButton];
            
            //添加分割线
            UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, MainScreenWidth, 1)];
            Label.backgroundColor = [UIColor colorWithRed:207.f / 255 green:207.f / 255 blue:207.f / 255 alpha:1];
            [view addSubview:Label];
            
            UILabel *bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, MainScreenWidth - 30, 25)];
            bankLabel.textAlignment = NSTextAlignmentLeft;
            NSString *banString = [NSString stringWithFormat:@"%@",_bankDic[@"accounttype"]];
            bankLabel.text = banString;
            [view addSubview:bankLabel];
            
            UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, MainScreenWidth - 30, 30)];
            numLabel.textAlignment = NSTextAlignmentLeft;
            NSLog(@"%@",_bankDic);
            NSString *numString = [NSString stringWithFormat:@"%@",_bankDic[@"account"]];
            numLabel.text = numString;
            [view addSubview:numLabel];
            
            //添加相同大小的按钮
            UIButton *bankButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 60)];
            bankButton.backgroundColor = [UIColor clearColor];
            [bankButton addTarget:self action:@selector(amendBank) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:bankButton];
            
        }

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"SHIBAI");
    }];
}
-(void)goSetBankcard
{
    if ([_bankDic isEqual:[NSNull null]]) {//没有添加银行卡的
        //跳转到添加银行界面
        AmendBankViewController *amendBankVC = [[AmendBankViewController alloc] init];
        amendBankVC.dic = _bankDic;
        [self.navigationController pushViewController:amendBankVC animated:YES];
    } else {//已经添加银行卡了
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"已添加" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];
        
    }
}
- (IBAction)setBankCard:(id)sender
{
//    AddBankViewController *a = [[AddBankViewController alloc]init];
//    [self.navigationController pushViewController:a animated:YES];
}


- (void)amendBank {
    AmendBankViewController *amendBankVC = [[AmendBankViewController alloc] init];
    amendBankVC.dic = _bankDic;
    amendBankVC.addOrAmend = @"123";
    [self.navigationController pushViewController:amendBankVC animated:YES];
}


- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}

@end
