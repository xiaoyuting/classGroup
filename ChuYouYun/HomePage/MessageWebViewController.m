//
//  MessageWebViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/3/14.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "MessageWebViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "UIButton+WebCache.h"
#import "PhotosView.h"
#import "EJTableViewCell.h"
#import "Passport.h"
#import "ZhiyiHTTPRequest.h"
#import "MyHttpRequest.h"


@interface MessageWebViewController ()<UIWebViewDelegate>

@property (strong ,nonatomic)UIWebView *webView;

@end

@implementation MessageWebViewController


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
    [self interFace];
    [self addNav];
    [self addWebView];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
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
    WZLabel.text = @"资讯详情";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:lineButton];
    
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 网络试图
- (void)addWebView {
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    [_webView setUserInteractionEnabled:YES];//是否支持交互
    _webView.delegate=self;
    [_webView setOpaque:YES];//opaque是不透明的意思
    [_webView setScalesPageToFit:YES];//自适应
    
    NSString *oneStr = @"app=classroom&mod=Topic&act=view&id=";
    NSString *twoStr = [NSString stringWithFormat:@"%@",_ID];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",basidUrl,oneStr,twoStr];
    NSLog(@"----%@",urlStr);
    
    NSURL *url = [NSURL URLWithString:urlStr];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:_webView];
}


@end
