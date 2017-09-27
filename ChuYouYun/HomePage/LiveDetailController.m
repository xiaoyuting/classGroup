//
//  LiveDetailController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/3/29.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "LiveDetailController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "MJRefresh.h"
#import "SYG.h"
#import "ZhiyiHTTPRequest.h"


@interface LiveDetailController ()

@end

@implementation LiveDetailController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"options.png"] forBarMetrics:UIBarMetricsDefault];
    
//    if (_payV) {
//        [_payV removeFromSuperview];
//    }
//    [self requestData];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = NO;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
}


@end
