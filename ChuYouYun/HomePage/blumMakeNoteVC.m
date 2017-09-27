//
//  blumMakeNoteVC.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/25.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//
#define kRGB(R,G,B)       [UIColor colorWithRed:R/255.f green:G/255.f blue:254/255.f alpha:1];
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4,4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕


#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕
#import "blumMakeNoteVC.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "PlaceholderTextView.h"
#import "MyHttpRequest.h"
@interface blumMakeNoteVC ()<UITextViewDelegate>
{
    PlaceholderTextView *view1;
    PlaceholderTextView * view2;
}


@end

@implementation blumMakeNoteVC
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    self.navigationController.navigationBar.hidden = YES;
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    self.navigationController.navigationBar.hidden = NO;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, MainScreenWidth, 44)];
    view.backgroundColor = [UIColor whiteColor];
    view.userInteractionEnabled = YES;
    view.image = [UIImage imageNamed:@"options.png"];
    [self.view addSubview:view];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, 12, 44, 22);
    [button setImage:[UIImage imageNamed:@"Arrow000"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(MainScreenWidth/2-60, 8, 130, 30)];
    label.text = @"记笔记";
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    [view addSubview:label];
    
    //提交
    UIButton * commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(MainScreenWidth-50, 16, 32, 16);
    [commitBtn setImage:[UIImage imageNamed:@"提交.png"] forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:commitBtn];
    
    //自定义textView
    view1=[[PlaceholderTextView alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 40)];
    view1.placeholder=@"请输入笔记标题...";
    view1.font=[UIFont boldSystemFontOfSize:17];
    view1.placeholderFont=[UIFont boldSystemFontOfSize:13];
    view1.layer.borderWidth=0.3;
    view1.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [self.view addSubview:view1];
    
    if (iPhone5o5Co5S) {
        view2=[[PlaceholderTextView alloc] initWithFrame:CGRectMake(0, 102, MainScreenWidth, 200)];
    }
    else if(iPhone6)
    {
        view2=[[PlaceholderTextView alloc] initWithFrame:CGRectMake(0, 102, MainScreenWidth, 270)];
    }
    else if(iPhone6Plus)
    {
        view2=[[PlaceholderTextView alloc] initWithFrame:CGRectMake(0, 102, MainScreenWidth, 340)];
    }
    
    view2.placeholder=@"请输入笔记内容...";
    view2.font=[UIFont boldSystemFontOfSize:17];
    view2.placeholderFont=[UIFont boldSystemFontOfSize:13];
    view2.layer.borderWidth=0.3;
    view2.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [self.view addSubview:view2];
}

#pragma -----记笔记
- (void)commitBtn
{
    if (view1.text.length==0) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"请输入标题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
        return;
    }
    else if(view2.text.length==0)
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"请输入内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
        return;
        
    }
    else{
        QKHTTPManager * manager = [QKHTTPManager manager];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
        [dic setValue:_blumID forKey:@"kzid"];
        [dic setValue:view1.text forKey:@"title"];
        [dic setValue:view2.text forKey:@"content"];
        [dic setValue:@"1" forKey:@"kztype"];
        [dic setValue:@"1" forKey:@"is_open"];
        [manager AddNote:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"提交成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [alter show];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"提问失败，请重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];
        }];
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
