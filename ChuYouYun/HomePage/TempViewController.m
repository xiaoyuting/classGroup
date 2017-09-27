//
//  TempViewController.m
//  dafengche
//
//  Created by IOS on 16/10/18.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "TempViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "PaiKeViewController.h"
#import "ManageAddressViewController.h"
#import "AreaViewController.h"

#import "VideoRoomViewController.h"
#import "DomainNameViewController.h"
#import "FinanceViewController.h"
#import "GLMyViewController.h"
#import "LiveViewController.h"
#import "PopView.h"
#import "teacherViewController.h"
#import "LiveViewController.h"

#import "MyLiveViewController.h"
#import "ZiXunViewController.h"

#import "blumViewController.h"

#import "GLZFViewController.h"
#import "StoresViewController.h"

#import "GLZXViewController.h"

#import "GLLiveViewController.h"




@interface TempViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSArray *lookArray;

@property (strong ,nonatomic)UIScrollView *headScrollow;

@end

@implementation TempViewController

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
    //[self addscrollow];
    //[self addTableView];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(156, 100, 80, 20)];
    [btn setTitle:@"支付" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goPaiKe) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(156, 140, 160, 20)];
    [btn1 setTitle:@"管理收货地址" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(goManageAddress) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(156, 180, 160, 20)];
    [btn2 setTitle:@"地区" forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    [btn2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(area) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(60, 180, 160, 20)];
    [btn3 setTitle:@"视频空间" forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    [btn3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(Video) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *btn4 = [[UIButton alloc]initWithFrame:CGRectMake(60, 230, 160, 20)];
    [btn4 setTitle:@"独立域名" forState:UIControlStateNormal];
    [self.view addSubview:btn4];
    [btn4 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(Name) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn5 = [[UIButton alloc]initWithFrame:CGRectMake(60, 260, 160, 20)];
    [btn5 setTitle:@"独立财务账户" forState:UIControlStateNormal];
    [self.view addSubview:btn5];
    [btn5 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(Money) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn6 = [[UIButton alloc]initWithFrame:CGRectMake(60, 390, 160, 20)];
    [btn6 setTitle:@"商城" forState:UIControlStateNormal];
    [self.view addSubview:btn6];
    [btn6 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn6 addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *btn7 = [[UIButton alloc]initWithFrame:CGRectMake(60, 430, 160, 20)];
//    [btn7 setTitle:@"个人中心" forState:UIControlStateNormal];
//    [self.view addSubview:btn7];
//    [btn7 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
////    [btn7 addTarget:self action:@selector(gomy) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *btn8 = [[UIButton alloc]initWithFrame:CGRectMake(60, 460, 160, 20)];
//    [btn8 setTitle:@"下载" forState:UIControlStateNormal];
//    [self.view addSubview:btn8];
//    [btn8 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
   // [btn8 addTarget:self action:@selector(goLive) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn9 = [[UIButton alloc]initWithFrame:CGRectMake(60, 510, 160, 20)];
    [btn9 setTitle:@"直播列表" forState:UIControlStateNormal];
    [self.view addSubview:btn9];
    [btn9 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn9 addTarget:self action:@selector(goMyLive) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn10 = [[UIButton alloc]initWithFrame:CGRectMake(60, 540, 160, 20)];
    [btn10 setTitle:@"讲师列表" forState:UIControlStateNormal];
    [self.view addSubview:btn10];
    [btn10 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn10 addTarget:self action:@selector(goteacher) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn11 = [[UIButton alloc]initWithFrame:CGRectMake(60, 580, 160, 20)];
    [btn11 setTitle:@"live" forState:UIControlStateNormal];
    [self.view addSubview:btn11];
    [btn11 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn11 addTarget:self action:@selector(goZXList) forControlEvents:UIControlEventTouchUpInside];

}

-(void)goZXList{
    
    [self.navigationController pushViewController:[GLLiveViewController new] animated:YES];
}

-(void)goteacher{

    [self.navigationController pushViewController:[teacherViewController new] animated:YES];
}

-(void)goMyLive{

    [self.navigationController pushViewController:[LiveViewController new] animated:YES];

}
-(void)goLive{

    [self.navigationController pushViewController:[blumViewController new] animated:YES];
}

-(void)gomy{

    [self.navigationController pushViewController:[GLMyViewController new] animated:YES];
}
-(void)popView{

    StoresViewController *PView = [[StoresViewController alloc]init];
    
    [self.navigationController pushViewController:PView animated:YES];
    
}

- (void)Money {
    
    FinanceViewController *financeVc = [[FinanceViewController alloc] init];
    [self.navigationController pushViewController:financeVc animated:YES];
}

- (void)Name {
    DomainNameViewController *domainNameVc = [[DomainNameViewController alloc] init];
    [self.navigationController pushViewController:domainNameVc animated:YES];
    
}

- (void)Video {
    
    VideoRoomViewController *videoRoomVc = [[VideoRoomViewController alloc] init];
    [self.navigationController pushViewController:videoRoomVc animated:YES];
}

-(void)area{

    [self.navigationController pushViewController:[AreaViewController new] animated:YES];
}
-(void)goManageAddress{

    [self.navigationController pushViewController:[ManageAddressViewController new] animated:YES];
    
}
-(void)addscrollow{

    _headScrollow = [[UIScrollView alloc]initWithFrame:CGRectMake(0,66, MainScreenWidth,44*MainScreenHeight/667)];
    _headScrollow.contentSize = CGSizeMake(MainScreenWidth*4, _headScrollow.bounds.size.height);
    _headScrollow.delegate = self;
    _headScrollow.alwaysBounceVertical = NO;
    _headScrollow.pagingEnabled = YES;
    _headScrollow.backgroundColor = [UIColor whiteColor];
    //同时单方向滚动
    _headScrollow.directionalLockEnabled = YES;
    _headScrollow.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:_headScrollow];
}
-(void)goPaiKe{

    [self.navigationController pushViewController:[GLZFViewController new] animated:YES];
}
- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 12, 22)];
    [backButton setImage:[UIImage imageNamed:@"iconfont-FH"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"临时页面";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
    UIButton *SXButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 30, 32, 20, 20)];
    [SXButton setBackgroundImage:[UIImage imageNamed:@"资讯分类@2x"] forState:UIControlStateNormal];
    [SXButton addTarget:self action:@selector(ShopCateButton) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:SXButton];
}
//分类
-(void)ShopCateButton{
    
    NSLog(@"分类");
}
- (void)backPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
