//
//  VideoRoomViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/3.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "VideoRoomViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"


@interface VideoRoomViewController ()

@end

@implementation VideoRoomViewController

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
//    [self addScrollView];
    [self addInfoView];
    
    
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
    [backButton setImage:[UIImage imageNamed:@"点评返回@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"视频空间";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
    
    //添加横线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:button];
    
}

- (void)addInfoView {
    
    UILabel *reminL = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 80,MainScreenWidth - 2 * SpaceBaside, 60)];
    reminL.text = @"您可以填写并提交扩广或缩减视频空间额申请，我们的工作人员将在收到申请的一个工作日内审核您的申请并及时与您联系，请耐心等待，谢谢";
    reminL.numberOfLines = 3;
    reminL.font = Font(14);
    [self.view addSubview:reminL];
    
    //内存 文本
    UILabel *RAM = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 180,MainScreenWidth - 2 * SpaceBaside, 30)];
    RAM.text = @"当前空间：88GB";
    RAM.font = Font(16);
    RAM.textColor = [UIColor grayColor];
    [self.view addSubview:RAM];
    
    
    UILabel *RAMRe = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 230,MainScreenWidth - 2 * SpaceBaside, 30)];
    RAMRe.text = @"修改空间：100GB";
    RAMRe.font = Font(16);
    RAMRe.textColor = [UIColor grayColor];
    [self.view addSubview:RAMRe];
    
    
    //按钮
    UIButton *videoButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, 300, MainScreenWidth - 2 * SpaceBaside, 40)];
    videoButton.layer.cornerRadius = 5;
    videoButton.backgroundColor = BasidColor;
    [videoButton setTitle:@"提交申请" forState:UIControlStateNormal];
    [self.view addSubview:videoButton];
    
    
}


#pragma mark -- 事件监听
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
