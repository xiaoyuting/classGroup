//
//  GLMyViewController.m
//  dafengche
//
//  Created by IOS on 16/11/9.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "GLMyViewController.h"
#import "UIButton+WebCache.h"
#import "CourseCell.h"
#import "msgViewController.h"
#import "settingViewController.h"
#import "MyShoppingCarViewController.h"
#import "CourseViewController.h"
#import "QuestionsAndAnswersViewController.h"
#import "NoteViewController.h"
#import "AttentionViewController.h"
#import "MyMsgViewController.h"
#import "receiveCommandViewController.h"
#import "FansViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "Passport.h"
#import "CData.h"
#import "MJRefresh.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "questionViewController.h"
#import "NoteViewController.h"
#import "UIImage+WebP.h"
#import "MyBuyCell.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "XZViewController.h"
#import "ZJViewController.h"
#import "KCViewController.h"
#import "PXViewController.h"
#import "UserLoginViewController.h"
#import "MYinfoTool.h"
#import "DLViewController.h"
#import "SYGBJViewController.h"
#import "MyBankViewController.h"
#import "myRemainingViewController.h"
#import "YEViewController.h"
#import "GZViewController.h"
#import "FSViewController.h"
#import "GWCViewController.h"
#import "SCViewController.h"
#import "personDataViewController.h"
#import "SCViewController.h"
#import "MYWDViewController.h"
#import "GLReachabilityView.h"
#import "JYJLViewController.h"
#include "MyDownLoadViewController.h"
#import "LookRecodeViewController.h"
#import "MyCouponViewController.h"
#import "DiscountViewController.h"
#import "SYG.h"

@interface GLMyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _number;
    CGRect rect;
    NSDictionary *userDic;
    UIImageView *_imageView;
    UILabel *numberlbl;
    UIButton *_headBtn;
    UIView *_childView;
}

@property (strong ,nonatomic)NSDictionary *SYGDic;

@property (strong ,nonatomic)NSDictionary *SYGBarDic;

@property (strong ,nonatomic)NSDictionary *MyMoneyDic;

@property (strong ,nonatomic)UIView *SYGNOView;

@property (strong ,nonatomic)NSString *balance;

@property (strong ,nonatomic)NSString *account;

@property (strong ,nonatomic)NSString *collect_album;

@property (strong ,nonatomic)NSString *collect_video;

@property (strong ,nonatomic)NSString *fans;

@property (strong ,nonatomic)NSString *follow;

@property (strong ,nonatomic)NSString *note;

@property (strong ,nonatomic)NSString *videocont;

@property (strong ,nonatomic)NSString *wdcont;

@property (strong ,nonatomic)NSString *JJStr;

@property (strong ,nonatomic)NSString *card;

@property (strong ,nonatomic)UILabel *YHJJLabel;

@property (strong ,nonatomic)NSDictionary *XXDic;

@property (strong ,nonatomic)UIView *DYView;

@property (strong ,nonatomic)NSString *TXString;

@property (strong ,nonatomic)NSString *NameString;

@property (strong ,nonatomic)NSString *isWifi;//来监听是否有网的时候的状态

@property (strong ,nonatomic)UIButton *HButton;//红点显示按钮


@end

@implementation GLMyViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
    
    
    //判断是否登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        
        
        
    }else {//已经登录
        
        //移除没有登录情况下的界面
        [_SYGNOView removeFromSuperview];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (!_DYView) {
                [self reloadUserContent];
            }else {
                [_DYView removeFromSuperview];
                [self reloadUserContent];
            }
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!_DYView) {
                
                [self requestbankData];
                [self getMyMoney];
                
            }
            [self information];
            [self getMessage];
        });
        
        
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [GLReachabilityView isConnectionAvailable];
    self.navigationItem.title = @"个人主页";
    rect = [UIScreen mainScreen].applicationFrame;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userFace:) name:@"userFace" object:nil];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width,MainScreenHeight - 49)];
    self.scrollView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:237.0/255.0 alpha:1];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    self.scrollView.bounces = NO;
    self.scrollView.delaysContentTouches = YES;
    self.scrollView.canCancelContentTouches= NO;
    self.scrollView.userInteractionEnabled = YES;
    if (iPhone6 || iPhone6Plus) {
        self.scrollView.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight);
    }else if (iPhone5o5Co5S){
        self.scrollView.contentSize = CGSizeMake(rect.size.width, rect.size.height + 260 + 40);
    }else if (iPhone4SOriPhone4) {
        self.scrollView.contentSize = CGSizeMake(rect.size.width, rect.size.height + 260 + 120);
    }else {
        
    }
    
    
    //int lblX = (rect.size.width-200)/5;
    _bView = [[UIView alloc]initWithFrame:CGRectMake(0, -10, rect.size.width, 160)];
    _bView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:237.0/255.0 alpha:1];
    _bView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bView];
    UIImageView *bgIView =[[UIImageView alloc]initWithFrame:CGRectMake(_bView.frame.origin.x, _bView.frame.origin.y, _bView.frame.size.width, _bView.frame.size.height)];
    [bgIView setImage:[UIImage imageNamed:@"组-2@2x"]];
    _bView.userInteractionEnabled =YES;
    _bgIView = bgIView;
    [_bView addSubview:bgIView];
    //信息按钮
    UIButton *msg = [UIButton buttonWithType:0];
    msg.frame = CGRectMake(20, 24, 25, 25);
    [msg setBackgroundImage:[UIImage imageNamed:@"iconfont-bf-message@2x"] forState:0];
    [msg addTarget:self action:@selector(msgClick) forControlEvents:UIControlEventTouchUpInside];
    [bgIView addSubview:msg];
    //设置按钮
    UIButton *settting =[UIButton buttonWithType:0];
    settting.frame = CGRectMake(rect.size.width-43, 24, 25, 25);
    [settting setBackgroundImage:[UIImage imageNamed:@"iconfont-shezhi@2x"] forState:0];
    [settting addTarget:self action:@selector(tosetting) forControlEvents:UIControlEventTouchUpInside];
    [bgIView addSubview:settting];
    

    
    _headBtn = [UIButton buttonWithType:0];
    _headBtn.frame = CGRectMake((rect.size.width-60)/2, 24, 60, 60);
    _headBtn.clipsToBounds = YES;
    _headBtn.layer.cornerRadius= 30;
    [_headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_allInformation[@"data"][@"avatar_small"]] forState:0 placeholderImage:nil];
    
    [_headBtn.layer setBorderWidth:2.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 255.0/255.0, 255.0/255.0, 255.0/255.0, 1 });
    [_headBtn.layer setBorderColor:colorref];//边框颜色
    [_bView addSubview:_headBtn];
    
    _userName = [[UILabel alloc]initWithFrame:CGRectMake(0, _headBtn.current_y_h+20, MainScreenWidth, 20)];
    _userName.textAlignment = NSTextAlignmentCenter;
    _userName.textColor = [UIColor cyanColor];
    [bgIView addSubview:_userName];
    NSString *userInfo = [Passport filePath];
    userDic = [[NSDictionary alloc]initWithContentsOfFile:userInfo];
    _userName.text = [NSString stringWithFormat:@"%@",_allInformation[@"data"][@"uname"]];
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@",_allInformation[@"intr"][@"uname"]]);
    
    //添加用户简介
    _YHJJLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, _userName.current_y_h, MainScreenWidth - 100, 20)];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    //    _collect_album = [defaults objectForKey:@"collect_album"];
    //    _collect_video = [defaults objectForKey:@"collect_video"];
    //    _fans = [defaults objectForKey:@"fans"];
    //    _follow = [defaults objectForKey:@"follow"];
    //    _note = [defaults objectForKey:@"note"];
    //    _videocont = [defaults objectForKey:@"videocont"];
    //    _wdcont = [defaults objectForKey:@"wdcont"];
    _JJStr = [defaults objectForKey:@"intr"];
    NSLog(@"%@",_JJStr);
    
    if (_JJStr == nil) {
        _YHJJLabel.text = @"用户很懒，并没有留下什么";
    }else {
        _YHJJLabel.text = _JJStr;
    }
    
    _YHJJLabel.font = [UIFont systemFontOfSize:13];
    _YHJJLabel.textAlignment = NSTextAlignmentCenter;
    [_YHJJLabel setTextColor:[UIColor whiteColor]];
    [_bView addSubview:_YHJJLabel];
    
    
    
    
    //添加下面的view
    [self addMYView];
    
    bgIView.userInteractionEnabled  = YES;
    
    
    
    //判断是否登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        
        [self addNOLoginView];
        
        
        
    }else {//已经登录
        
        [self addBarView];
        
    }
    
}

- (void)addSYGScrollView {
    
    
}

- (void)addNOLoginView {
    
    //添加试图
    _SYGNOView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 300)];
    _SYGNOView.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [_SYGNOView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"默认背景-2@2x"]]];
    [_bView addSubview:_SYGNOView];
    
    
    //添加头像
    
    UIButton *SYGButton = [UIButton buttonWithType:UIButtonTypeCustom];
    SYGButton.frame = CGRectMake(MainScreenWidth / 2 - 40, 110, 80, 80);
    SYGButton.backgroundColor = [UIColor whiteColor];
    [SYGButton setBackgroundImage:[UIImage imageNamed:@"未登录头像.jpg"] forState:UIControlStateNormal];
    SYGButton.layer.cornerRadius = 40;
    SYGButton.layer.masksToBounds = YES;
    [_SYGNOView addSubview:SYGButton];
    
    //添加登录按钮
    UIButton *LoginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    LoginButton.frame = CGRectMake(MainScreenWidth / 2 - 60, 220, 120, 40);
    LoginButton.backgroundColor = [UIColor whiteColor];
    LoginButton.layer.cornerRadius = 5;
    [LoginButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [LoginButton setTitle:@"登  录" forState:UIControlStateNormal];
    [LoginButton addTarget:self action:@selector(loginButton) forControlEvents:UIControlEventTouchUpInside];
    [_SYGNOView addSubview:LoginButton];
    
    
    
    
    
}

- (void)loginButton {//登录按钮
    
    DLViewController *DLVC = [[DLViewController alloc] init];
    UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
    [self.navigationController presentViewController:Nav animated:YES completion:nil];
    
}

- (void)addBarView {
    
    [self.scrollView addSubview:_bView];
    
}

- (void)addGZFSView {
    
    //将这些全部添加View上面
    UIView *DYView = [[UIView alloc] initWithFrame:CGRectMake(0, 220, MainScreenWidth, 40)];
    DYView.backgroundColor = [UIColor clearColor];
    [_bgIView addSubview:DYView];
    _DYView = DYView;
    
    //添加关注和粉丝
    for (int i = 0 ; i < 4; i ++) {
        NSString *GZString = [NSString stringWithFormat:@"%@",_SYGDic[@"data"][@"follow"]];
        NSString *FSString = [NSString stringWithFormat:@"%@",_SYGDic[@"data"][@"fans"]];
        
        NSString *XBString = [NSString stringWithFormat:@"%@",_SYGDic[@"data"][@"balance"]];
        NSString *YHKString = [NSString stringWithFormat:@"%@",_SYGDic[@"data"][@"card"]];
        
        NSArray *SYG = nil;
        if ([_isWifi isEqualToString:@"123"]) {
            NSString *F = [NSString stringWithFormat:@"%@",_follow];
            NSString *Fan = [NSString stringWithFormat:@"%@",_fans];
            NSString *XB = [NSString stringWithFormat:@"%@",_balance];
            NSString *YH = _card;
            
            SYG = @[F,Fan,XB,YH];
        }else {
            SYG = @[GZString,FSString,XBString,YHKString];
        }
        
        NSArray *GZArray = @[@"关注",@"粉丝",@"元",@"银行卡"];
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(30 + (MainScreenWidth - 60) / 4 * i, 0, (MainScreenWidth - 60) / 4 , 20);
        label.text = GZArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        [self.scrollView  addSubview:label];
        
        //添加数字
        UILabel *SZLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 + (MainScreenWidth - 60) / 4 * i, 20, (MainScreenWidth - 60) / 4 , 20)];
        SZLabel.font = [UIFont systemFontOfSize:14];
        SZLabel.text = SYG[i];
        [SZLabel setTextColor:[UIColor whiteColor]];
        SZLabel.textAlignment = NSTextAlignmentCenter;
        [self.scrollView  addSubview:SZLabel];
        
    }
    
    //添加分割线
    for (int i = 0; i < 3; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30 + (MainScreenWidth - 60) / 4 + (MainScreenWidth - 60) / 4 *i, 0, 1, 35)];
        label.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:label];
    }
    
    //    UILabel *GKLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 0.5, 190, 1, 12)];
    //    GKLabel.backgroundColor = [UIColor whiteColor];
    //    [_bgIView addSubview:GKLabel];
    
    
    //添加两个按钮
    UIButton *GZButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, (MainScreenWidth - 60) / 4, 40)];
    GZButton.backgroundColor = [UIColor clearColor];
    [GZButton addTarget:self action:@selector(GZFSButton:) forControlEvents:UIControlEventTouchUpInside];
    GZButton.tag = 100;
    [DYView addSubview:GZButton];
    
    UIButton *FSButton = [[UIButton alloc] initWithFrame:CGRectMake(30 + (MainScreenWidth - 60 ) / 4  , 0, (MainScreenWidth - 60) / 4, 40)];
    FSButton.backgroundColor = [UIColor clearColor];
    [FSButton addTarget:self action:@selector(GZFSButton:) forControlEvents:UIControlEventTouchUpInside];
    FSButton.tag = 200;
    [DYView addSubview:FSButton];
    
    UIButton *XBButton = [[UIButton alloc] initWithFrame:CGRectMake(30 + (MainScreenWidth - 60 ) / 4 * 2  , 0, (MainScreenWidth - 60) / 4, 40)];
    XBButton.backgroundColor = [UIColor clearColor];
    [XBButton addTarget:self action:@selector(GZFSButton:) forControlEvents:UIControlEventTouchUpInside];
    XBButton.tag = 300;
    [DYView addSubview:XBButton];
    
    UIButton *YHKButton = [[UIButton alloc] initWithFrame:CGRectMake(30 + (MainScreenWidth - 60 ) / 4 * 3  , 0, (MainScreenWidth - 60) / 4, 40)];
    YHKButton.backgroundColor = [UIColor clearColor];
    [YHKButton addTarget:self action:@selector(GZFSButton:) forControlEvents:UIControlEventTouchUpInside];
    YHKButton.tag = 400;
    [DYView addSubview:YHKButton];
    
    
    
}

- (void)addMYView {
    
    //添加整个View
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 270, MainScreenWidth, MainScreenHeight - 60)];
    SYGView.backgroundColor = [UIColor colorWithRed:245.f / 255 green:246.f / 255 blue:247.f / 255 alpha:1];
    SYGView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:SYGView];
    SYGView.userInteractionEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    //    if (MainScreenHeight > 560 ) {
    //
    //    }else {
    //         _scrollView.contentSize = CGSizeMake(MainScreenWidth, 300 + 260);
    //    }
    
    CGFloat Bwidth = 35;
    CGFloat width = MainScreenWidth / 3 ;
    CGFloat spare = (MainScreenWidth / 3 - Bwidth) / 2;
    NSLog(@"%f",width - 160);
    
    NSArray *SYGArray = @[@"我的专辑",@"我的课程",@"我的笔记",@"我的收藏",@"我的订单",@"我的问答",@"我的下载",@"观看记录",@"我的优惠券"];
    for (int i = 0 ; i < SYGArray.count ; i ++) {
        
        NSArray *TBArray = @[@"iconfont-zhuanji-copy@2x",@"iconfont-baomingkechengdisc@2x",@"iconfont-biji@2x",@"iconfont-shoucang@2x",@"我的购物车@2x",@"iconfont-navwenda@2x",@"iconfont-navwenda@2x",@"iconfont-navwenda@2x",@"iconfont-navwenda@2x"];
        UIButton *TBButton = [[UIButton alloc] initWithFrame:CGRectMake(spare +MainScreenWidth / 3 * (i % 3) , 130 * (i / 3) + 50 , Bwidth, Bwidth)];
        [TBButton setBackgroundImage:[UIImage imageNamed:TBArray[i]] forState:UIControlStateNormal];
        [SYGView addSubview:TBButton];
        
        //添加文字
        UILabel *WZLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * (i % 3) ,80 + 20 + (i / 3) * 130 ,width,20)];
        WZLabel.text = SYGArray[i];
        WZLabel.textAlignment = NSTextAlignmentCenter;
        WZLabel.font = [UIFont systemFontOfSize:12];
        [SYGView addSubview:WZLabel];
        
        //添加透明的按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width * (i % 3), 130 * (i / 3), width, 130)];
        button.backgroundColor = [UIColor clearColor];
        button.tag = i;
        [button addTarget:self action:@selector(SYGButtton:) forControlEvents:UIControlEventTouchUpInside];
        [SYGView addSubview:button];
        
        
        
    }
    
    
}


- (void)GZFSButton:(UIButton *)button {
    
    if (button.tag == 100) {//关注
        
        GZViewController *GZVC = [[GZViewController alloc] init];
        [self.navigationController pushViewController:GZVC animated:YES];
        
        
    }
    if (button.tag == 200) {//粉丝
        
        FSViewController *FSVC = [[FSViewController alloc] init];
        [self.navigationController pushViewController:FSVC animated:YES];
    }
    
    if (button.tag == 300) {//余额
        
        YEViewController *YEVC = [[YEViewController alloc] init];
        [self.navigationController pushViewController:YEVC animated:YES];
    }
    
    if (button.tag == 400) {//银行卡
        
        MyBankViewController *b = [[MyBankViewController alloc]init];
        [self.navigationController pushViewController:b animated:YES];    }
    
    
}


- (void)SYGButtton:(UIButton *)button {
    
    NSLog(@"%ld",button.tag);
    NSLog(@"你好");
    
    //判断是否登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        
        
    }else {//已经登录
        
        if (button.tag == 0) {//说明是专辑
            
            ZJViewController *ZJVC = [[ZJViewController alloc] init];
            [self.navigationController pushViewController:ZJVC animated:YES];
            
        }
        if (button.tag == 1) {//说明是课程
            
            KCViewController *KCVC = [[KCViewController alloc] init];
            [self.navigationController pushViewController:KCVC animated:YES];
            
        }
        if (button.tag == 2) {//说明是笔记
            
            SYGBJViewController *SYGBJVC = [[SYGBJViewController alloc] init];
            [self.navigationController pushViewController:SYGBJVC animated:YES];
            
            
        }
        if (button.tag == 3) {//说明是收藏
            
            SCViewController *SCVC = [[SCViewController alloc] init];
            [self.navigationController pushViewController:SCVC animated:YES];
            
        }
        if (button.tag == 4) {//说明是购物车
            
            //            GWCViewController *GWCVC = [[GWCViewController alloc] init];
            //            [self.navigationController pushViewController:GWCVC animated:YES];
            JYJLViewController *JYJLVC =  [[JYJLViewController alloc] init];
            [self.navigationController pushViewController:JYJLVC animated:YES];
            
            
            
        }
        if (button.tag == 5) {//说明是问答
            
            MYWDViewController *MYWDVC = [[MYWDViewController alloc] init];
            [self.navigationController pushViewController:MYWDVC animated:YES];
            
        }
        if (button.tag == 6) {//说明是我的下载
            
            [self.navigationController setNavigationBarHidden:NO animated:NO];
            
            [self.navigationController pushViewController:[MyDownLoadViewController new] animated:YES];
        }
        
        if (button.tag == 7) {//观看记录
            
            LookRecodeViewController *lookVc = [[LookRecodeViewController alloc] init];
            [self.navigationController pushViewController:lookVc animated:YES];
        }
        
        if (button.tag == 8) {//我的优惠券
            
            DiscountViewController *CouponVc = [[DiscountViewController alloc] init];
            [self.navigationController pushViewController:CouponVc animated:YES];
        }
    }
    
    
}



-(void)userFace:(NSNotification *)info
{
    UIImage *image = [UIImage imageWithData:[info.userInfo objectForKey:@"userFace"]];
    [_headBtn setBackgroundImage:image forState:0];
    [_headBtn sd_setBackgroundImageWithURL:[[NSUserDefaults standardUserDefaults]objectForKey:@"small" ] forState:0];
    _imageView.image = image;
}
-(void)reloadUserContent
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    _collect_album = [defaults objectForKey:@"collect_album"];
    _collect_video = [defaults objectForKey:@"collect_video"];
    _fans = [defaults objectForKey:@"fans"];
    _follow = [defaults objectForKey:@"follow"];
    _note = [defaults objectForKey:@"note"];
    _videocont = [defaults objectForKey:@"videocont"];
    _wdcont = [defaults objectForKey:@"wdcont"];
    _JJStr = [defaults objectForKey:@"intr"];
    _balance = [defaults objectForKey:@"balance"];
    _card = [defaults objectForKey:@"card"];
    
    
    [manager reloadUserContent:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _XXDic = responseObject;
        //保存数据
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        [defaults setObject:responseObject[@"data"][@"collect_album"] forKey:@"collect_album"];
        [defaults setObject:responseObject[@"data"][@"collect_video"] forKey:@"collect_video"];
        [defaults setObject:responseObject[@"data"][@"fans"] forKey:@"fans"];
        [defaults setObject:responseObject[@"data"][@"follow"] forKey:@"follow"];
        [defaults setObject:responseObject[@"data"][@"note"] forKey:@"note"];
        [defaults setObject:responseObject[@"data"][@"videocont"] forKey:@"videocont"];
        [defaults setObject:responseObject[@"data"][@"wdcont"] forKey:@"wdcont"];
        [defaults setObject:responseObject[@"data"][@"intr"] forKey:@"intr"];
        [defaults setObject:responseObject[@"data"][@"balance"] forKey:@"balance"];
        [defaults setObject:responseObject[@"data"][@"card"] forKey:@"card"];
        [defaults synchronize];
        
        
        _YHJJLabel.text = _XXDic[@"data"][@"intr"];
        _SYGDic = responseObject;
        [self addGZFSView];
        [self addMYView];
        
        NSString *commentStr = responseObject[@"data"][@"no_read_comment"];
        NSString *messageStr = responseObject[@"data"][@"no_read_message"];
        NSString *notifyStr = responseObject[@"data"][@"no_read_notify"];
        NSInteger C = [commentStr integerValue];
        NSInteger M = [messageStr integerValue];
        NSInteger N = [notifyStr integerValue];
        if (C + M + N > 0) {//有消息没有读
            UIButton *HButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 25, 8, 8)];
            HButton.backgroundColor = [UIColor redColor];
            HButton.layer.cornerRadius = 4;
            [self.view addSubview:HButton];
            _HButton = HButton;
            _HButton.hidden = NO;
            
        }else {
            _HButton.hidden = YES;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"你好好");
        //这里给个状态告诉方法是否 （现在是有网还是没有网）
        _isWifi = @"123";
        [self addGZFSView];
        [self addMYView];
        
    }];
    
}

- (void)msgClick
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录
        //提示去登录
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        
    }else {//已经登录
        
        msgViewController *msg = [[msgViewController alloc]init];
        msg.XXDic = _XXDic;
        NSLog(@"%@",_XXDic);
        [self.navigationController pushViewController:msg animated:YES];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}


- (void)tosetting
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        //去登录
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        
    }else {//已经登录
        
        settingViewController *set = [[settingViewController alloc]initWithUserFace:_imageView.image userName:[userDic objectForKey:@"uname"]];
        [self.navigationController pushViewController:set animated:YES];
        
        
    }
    
}
- (void)toShoppingCar
{
    MyShoppingCarViewController *s = [[MyShoppingCarViewController alloc]init];
    [self.navigationController pushViewController:s animated:YES];
}


- (void)addImageAndButton {
    
    _headBtn = [UIButton buttonWithType:0];
    _headBtn.frame = CGRectMake((rect.size.width-80)/2, 54, 80, 80);
    _headBtn.clipsToBounds = YES;
    _headBtn.layer.cornerRadius= 40;
    //添加时间
    [_headBtn addTarget:self action:@selector(GoToSetting) forControlEvents:UIControlEventTouchUpInside];
    
    [_headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_allInformation[@"data"][@"avatar_big"]] forState:0 placeholderImage:nil];
    //    _imageView =[[UIImageView alloc]init];
    //    [_imageView sd_setImageWithURL:[NSURL URLWithString:_allInformation[@"data"][@"avatar_original"]]];
    [_headBtn.layer setBorderWidth:2.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 255.0/255.0, 255.0/255.0, 255.0/255.0, 1 });
    [_headBtn.layer setBorderColor:colorref];//边框颜色
    [_bView addSubview:_headBtn];
    
    _userName.text = [NSString stringWithFormat:@"%@",_allInformation[@"data"][@"uname"]];
    _userName.textColor = [UIColor whiteColor];
    
    
}

- (void)GoToSetting {
    personDataViewController *personVC = [[personDataViewController alloc] init];
    personVC.allDict = _allInformation;
    
    [self.navigationController pushViewController:personVC animated:YES];
}

- (void)information {//获取到用户的资料
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"User_id"] forKey:@"user_id"];
    
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *avatar_small = [defaults objectForKey:@"avatar_small"];//根据键值取出name
    NSString *uname = [defaults objectForKey:@"WDC"];
    
    [manager userShow:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _allInformation = responseObject;
        
        //保存数据
        //        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        //        [defaults setObject:_allInformation[@"data"][@"avatar_small"] forKey:@"avatar_small"];
        //        [defaults setObject:_allInformation[@"data"][@"uname"] forKey:@"WDC"];
        //        [defaults synchronize];
        //
        //        [self addImageAndButton];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"石远刚");
        [self addImageAndButton];
        [_headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:avatar_small] forState:0 placeholderImage:nil];
        _userName.text = [NSString stringWithFormat:@"%@",uname];
    }];
    
    
}

//获取银行卡
-(void)requestbankData
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    _account = [defaults objectForKey:@"account"];
    if (_balance != nil) {
        
        //        [self addBarView];
    }else {
        
        [manager requestBank:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            _SYGBarDic = responseObject;
            
            //            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            //            [defaults setObject:responseObject[@"data"][@"account"] forKey:@"account"];
            //            [defaults synchronize];
            
            
            //            [self addBarView];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"SHIBAI");
        }];
        
    }
    
    
}

- (void)getMyMoney {
    
    ZhiyiHTTPRequest *manager =[ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    _balance = [defaults objectForKey:@"balance"];
    NSLog(@"%@",_balance);
    if (_balance != nil) {//有数据
        
        [self addBarView];
    }else {
        
        [manager reloadUserbalance:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            _MyMoneyDic = responseObject[@"data"];
            
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            //            [defaults setObject:responseObject[@"data"][@"balance"] forKey:@"balance"];
            [defaults synchronize];
            
            
            [self addBarView];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    }
    
    
    
}

- (void)getMessage {
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    
    //
    //    if (_fans != nil) {//有数据
    //        [self addGZFSView];
    //        [self addMYView];
    //
    //
    //    }else {
    
    [manager reloadUserContent:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _XXDic = responseObject;
        //            //保存数据
        //            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        //            [defaults setObject:responseObject[@"data"][@"collect_album"] forKey:@"collect_album"];
        //            [defaults setObject:responseObject[@"data"][@"collect_video"] forKey:@"collect_video"];
        //            [defaults setObject:responseObject[@"data"][@"fans"] forKey:@"fans"];
        //            [defaults setObject:responseObject[@"data"][@"follow"] forKey:@"follow"];
        //            [defaults setObject:responseObject[@"data"][@"note"] forKey:@"note"];
        //            [defaults setObject:responseObject[@"data"][@"videocont"] forKey:@"videocont"];
        //            [defaults setObject:responseObject[@"data"][@"wdcont"] forKey:@"wdcont"];
        //            [defaults setObject:responseObject[@"data"][@"intr"] forKey:@"intr"];
        //            [defaults synchronize];
        
        
        
        //            _SYGDic = responseObject;
        //            [self addGZFSView];
        //            [self addMYView];
        //
        NSString *commentStr = responseObject[@"data"][@"no_read_comment"];
        NSString *messageStr = responseObject[@"data"][@"no_read_message"];
        NSString *notifyStr = responseObject[@"data"][@"no_read_notify"];
        NSInteger C = [commentStr integerValue];
        NSInteger M = [messageStr integerValue];
        NSInteger N = [notifyStr integerValue];
        if (C + M + N > 0) {//有消息没有读
            UIButton *HButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 25, 8, 8)];
            HButton.backgroundColor = [UIColor redColor];
            HButton.layer.cornerRadius = 4;
            [self.view addSubview:HButton];
            _HButton = HButton;
            _HButton.hidden = NO;
        }else {
            _HButton.hidden = YES;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    //
    //
    //    }
    
}



@end
