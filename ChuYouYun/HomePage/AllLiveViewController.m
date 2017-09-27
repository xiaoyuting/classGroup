//
//  AllLiveViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/3/13.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "AllLiveViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "MJRefresh.h"

#import "LiveViewController.h"
#import "TomorrowLiveViewController.h"


@interface AllLiveViewController ()<UIScrollViewDelegate>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)UILabel *titleText;
@property (strong ,nonatomic)UIScrollView *controllerSrcollView;
@property (strong ,nonatomic)UISegmentedControl *mainSegment;
@property (strong ,nonatomic)UIButton *seletedButton;

@property (strong ,nonatomic)UIButton *allOrderButton;
@property (strong ,nonatomic)UIButton *noPayButton;
@property (strong ,nonatomic)UIButton *canceledButton;
@property (strong ,nonatomic)UIButton *paidButton;
@property (strong ,nonatomic)UIButton *noRefundButton;
@property (strong ,nonatomic)UIButton *refundButton;

@end

@implementation AllLiveViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addNav];
//    [self addWZView];
    [self addControllerSrcollView];
}
- (void)interFace {
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加横线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:button];
    
    
    NSArray *titleArray = @[@"今日直播",@"明日直播"];
    _mainSegment = [[UISegmentedControl alloc] initWithItems:titleArray];
    _mainSegment.frame = CGRectMake(80,25,MainScreenWidth - 160, 30);
    _mainSegment.selectedSegmentIndex = 0;
    [_mainSegment setTintColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1]];
    [_mainSegment addTarget:self action:@selector(mainChange:) forControlEvents:UIControlEventValueChanged];
    [SYGView addSubview:_mainSegment];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addWZView {
    UIView *WZView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, MainScreenWidth, 50)];
    WZView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:WZView];

}

- (void)mainChange:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            _controllerSrcollView.contentOffset = CGPointMake(0, 0);
            break;
        case 1:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth, 0);
            break;
        case 2:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 2, 0);
            break;
            
        default:
            break;
    }
    
}


- (void)addControllerSrcollView {
    
    _controllerSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64,  MainScreenWidth, MainScreenHeight * 3 + 500)];
    _controllerSrcollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _controllerSrcollView.pagingEnabled = YES;
    _controllerSrcollView.scrollEnabled = YES;
    _controllerSrcollView.delegate = self;
    _controllerSrcollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * 2,0);
    [self.view addSubview:_controllerSrcollView];
    _controllerSrcollView.backgroundColor = [UIColor redColor];
    
    LiveViewController * liveVc= [[LiveViewController alloc]init];
    liveVc.view.frame = CGRectMake(0, -64, MainScreenWidth, MainScreenHeight);
    [self addChildViewController:liveVc];
    [_controllerSrcollView addSubview:liveVc.view];
    
    TomorrowLiveViewController * tomoVc = [[TomorrowLiveViewController alloc]init];
    tomoVc.view.frame = CGRectMake(MainScreenWidth, -64, MainScreenWidth, MainScreenHeight * 2 + 500);
    [self addChildViewController:tomoVc];
    [_controllerSrcollView addSubview:tomoVc.view];
    
}



#pragma mark --- 滚动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //要吧之前的按钮设置为未选中 不然颜色不会变
    self.seletedButton.selected = NO;
    
    if (_controllerSrcollView == scrollView) {
        CGPoint point = scrollView.contentOffset;
        if (point.x == 0) {
            _controllerSrcollView.contentOffset = CGPointMake(0, 0);
            
            _mainSegment.selectedSegmentIndex = 0;

        } else if(point.x == MainScreenWidth) {
            
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth, 0);
            _mainSegment.selectedSegmentIndex = 1;
        }
        
    }
    
}


@end
