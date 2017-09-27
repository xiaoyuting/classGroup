//
//  CourseViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/29.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "CourseViewController.h"
#import "MySpecialViewController.h"
#import "MyCrouseViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"

@interface CourseViewController ()
{
    MySpecialViewController *ms;
    MyCrouseViewController *mc;
}
@property (strong ,nonatomic)UIView *moveView;

@end

@implementation CourseViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
     _lineView.frame = CGRectMake(50, 30 + 4, 84, 1);
    _lineView.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    _lineView.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
     SYGView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 12, 22)];
    [backButton setImage:[UIImage imageNamed:@"iconfont-FH"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"我的收藏";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];


    ms = [[MySpecialViewController alloc]init];
    mc = [[MyCrouseViewController alloc]init];
    ms.view.frame = CGRectMake(0, 0, self.tView.frame.size.width, self.tView.frame.size.height);
    [self.tView addSubview:ms.view];
    [self addChildViewController:ms];
    [self titleSet];
    NSLog(@"----%@",NSStringFromCGRect(_lineView.frame));
//    _lineView.frame = CGRectMake(50, 30 + 4, 84, 2);
    
    
    
    //创建相同大小的滑条
    UIView *moveView = [[UIView alloc] initWithFrame:CGRectMake(50, 34 + 64, 84, 1)];
    moveView.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [self.view addSubview:moveView];
    _moveView = moveView;
}

- (void)titleSet {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:44.f / 255 green:132.f / 255 blue:214.f / 255 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    
    
}


- (IBAction)changeBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:
        {
            self.mySpecial.titleLabel.textColor = [UIColor colorWithRed:44.f / 255 green:122.f / 255 blue:255.f / 255 alpha:1];
            self.myCourse.titleLabel.textColor = [UIColor blackColor];
            [UIView animateWithDuration:0.1 animations:^{
//                _moveView.center = CGPointMake(self.mySpecial.frame.origin.x+42 , 30 + 4 + 64);
                _moveView.frame = CGRectMake(self.mySpecial.frame.origin.x, 98, 84, 1);
                NSLog(@"123");
                NSLog(@"%@",NSStringFromCGRect(_lineView.frame));
                
                
            }];
            [self.tView addSubview:ms.view];
            [self addChildViewController:ms];
        }
            break;
        case 1:
        {
            self.mySpecial.titleLabel.textColor = [UIColor blackColor];
            self.myCourse.titleLabel.textColor = [UIColor colorWithRed:44.f / 255 green:122.f / 255 blue:255.f / 255 alpha:1];
            [UIView animateWithDuration:0.1 animations:^{
                _moveView.frame = CGRectMake(self.myCourse.frame.origin.x, 98, 84, 1);
//                 _moveView.center = CGPointMake( self.myCourse.frame.origin.x+42 , 30 + 4 + 64);
            }];
            mc.view.frame = CGRectMake(0, 0, self.tView.frame.size.width, self.tView.frame.size.height);
            [self.tView addSubview:mc.view];
            [self addChildViewController:mc];
        }
            break;
        default:
            break;
    }
    
}


- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
