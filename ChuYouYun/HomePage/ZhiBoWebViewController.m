//
//  ZhiBoWebViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/5/26.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "ZhiBoWebViewController.h"
#import "SYG.h"
#import "UIWebView+WebView___Category.h"

#import "AppDelegate.h"
#import "rootViewController.h"


@interface ZhiBoWebViewController ()<UIWebViewDelegate>

@end

@implementation ZhiBoWebViewController



-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNav];
    [self addWebView];
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
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25, MainScreenWidth - 100, 30)];
    WZLabel.text = @"在线播放";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    //添加横线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:button];
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addWebView {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    [self.view addSubview:webView];
    webView.delegate = self;
    
    [webView setUserInteractionEnabled:YES];//是否支持交互
    [webView setOpaque:YES];//opaque是不透明的意思
    [webView setScalesPageToFit:YES];//自适应
    
    [webView setNeedsLayout];
    [webView layoutIfNeeded];
    
    NSURL *url = nil;
    NSLog(@"%@",_url);
    url = [NSURL URLWithString:_url];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

@end
