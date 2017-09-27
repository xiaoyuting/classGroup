//
//  MyViewController.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/21.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width


#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4 4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕


#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕

#import "MyViewController.h"
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

#import "MyInstationViewController.h"
#import "MyLibraryViewController.h"

#import "SYG.h"

#import "AllOrderViewController.h"
#import "ExchangeViewController.h"
#import "MyLiveViewController.h"

#import "OrderPagerViewController.h"
#import "PersonInfoViewController.h"

#import "CollectMainViewController.h"
#import "MyAnswerMainViewController.h"


@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _number;
    CGRect rect;
    NSDictionary *userDic;
    UIImageView *_imageView;
    UILabel *numberlbl;
    UIButton *_headBtn;
    UIView *_childView;
}

@property (strong ,nonatomic)UIButton *msgButton;
@property (strong ,nonatomic)NSDictionary *SYGDic;

@property (strong ,nonatomic)NSDictionary *SYGBarDic;

@property (strong ,nonatomic)NSDictionary *MyMoneyDic;

@property (strong ,nonatomic)UIView *SYGNOView;

@property (strong ,nonatomic)NSString *balance;

@property (strong ,nonatomic)NSString *score;

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

@implementation MyViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
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
                 [self information];
            }else {
                [_DYView removeFromSuperview];
                [self reloadUserContent];
                [self information];
            }
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!_DYView) {
               
                [self requestbankData];
                [self getMyMoney];
                [self information];

            }
                [self information];
                [self getMessage];
                [self information];
        });
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    AppDelegate *app = [AppDelegate delegate];
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
     self.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.scrollView];
    self.scrollView.bounces = NO;
    self.scrollView.delaysContentTouches = YES;
    self.scrollView.canCancelContentTouches= NO;
    self.scrollView.userInteractionEnabled = YES;
    if (iPhone6 || iPhone6Plus) {
        self.scrollView.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight + 200);
    }else if (iPhone5o5Co5S){
         self.scrollView.contentSize = CGSizeMake(rect.size.width, rect.size.height + 260 + 40);
    }else if (iPhone4SOriPhone4) {
         self.scrollView.contentSize = CGSizeMake(rect.size.width, rect.size.height + 260 + 120);
    }else {
        
    }
    int lblX = (rect.size.width-200)/5;
        _bView = [[UIView alloc]initWithFrame:CGRectMake(0, -10, rect.size.width, 280)];
    _bView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:237.0/255.0 alpha:1];
    _bView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bView];
    UIImageView *bgIView =[[UIImageView alloc]initWithFrame:CGRectMake(_bView.frame.origin.x, _bView.frame.origin.y, _bView.frame.size.width, _bView.frame.size.height)];
    [bgIView setImage:[UIImage imageNamed:@"组-2@2x"]];
    _bView.userInteractionEnabled =YES;
    _bgIView = bgIView;
    [_bView addSubview:bgIView];
    UIButton *msg = [UIButton buttonWithType:0];
    msg.frame = CGRectMake(20, 24, 25, 25);
    [msg setBackgroundImage:[UIImage imageNamed:@"iconfont-bf-message@2x"] forState:0];
    [msg addTarget:self action:@selector(msgClick) forControlEvents:UIControlEventTouchUpInside];
    [bgIView addSubview:msg];
    _msgButton = msg;
    
    
    UIButton *settting =[UIButton buttonWithType:0];
    settting.frame = CGRectMake(rect.size.width-43, 24, 25, 25);
    [settting setBackgroundImage:[UIImage imageNamed:@"iconfont-shezhi@2x"] forState:0];
    [settting addTarget:self action:@selector(tosetting) forControlEvents:UIControlEventTouchUpInside];
    [bgIView addSubview:settting];
    
    _userName = [[UILabel alloc]initWithFrame:CGRectMake(0, 152, MainScreenWidth, 23)];
    _userName.textAlignment = NSTextAlignmentCenter;
    _userName.textColor = [UIColor whiteColor];
    [bgIView addSubview:_userName];

    _headBtn = [UIButton buttonWithType:0];
    _headBtn.frame = CGRectMake((rect.size.width-80)/2, 54, 80, 80);
    _headBtn.clipsToBounds = YES;
    _headBtn.layer.cornerRadius= 40;
//    [_headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_allInformation[@"data"][@"avatar_small"]] forState:0 placeholderImage:nil];
    [_headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[[_allInformation dictionaryValueForKey:@"data"] stringValueForKey:@"avatar_small"]] forState:0 placeholderImage:Image(@"站位图")];

    [_headBtn.layer setBorderWidth:2.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 255.0/255.0, 255.0/255.0, 255.0/255.0, 1 });
    [_headBtn.layer setBorderColor:colorref];//边框颜色
    [_bView addSubview:_headBtn];

    NSString *userInfo = [Passport filePath];
    userDic = [[NSDictionary alloc]initWithContentsOfFile:userInfo];
    _userName.text = [NSString stringWithFormat:@"%@", [[_allInformation dictionaryValueForKey:@"data"] stringValueForKey:@"uname"]];
   
    
//    NSLog(@"%@",[NSString stringWithFormat:@"%@",_allInformation[@"intr"][@"uname"]]);
    

    //添加用户简介
    _YHJJLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 170, MainScreenWidth - 100, 30)];

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
//    [self addHongBaoView];
    [self addOrderView];
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
    NSInteger Num = 3;
    for (int i = 0 ; i < Num; i ++) {
        
        NSString *GZString = [NSString stringWithFormat:@"%@",[[_SYGDic dictionaryValueForKey:@"data"] stringValueForKey:@"follow"]];
        NSString *FSString = [NSString stringWithFormat:@"%@",[[_SYGDic dictionaryValueForKey:@"data"] stringValueForKey:@"fans"]];
        NSString *XBString = [NSString stringWithFormat:@"%@",[[_SYGDic dictionaryValueForKey:@"data"] stringValueForKey:@"score"]];
        NSString *YHKString = [NSString stringWithFormat:@"%@",[[_SYGDic dictionaryValueForKey:@"data"] stringValueForKey:@"card"]];
        
        NSArray *SYG = nil;
        if ([_isWifi isEqualToString:@"123"]) {
            NSString *F = [NSString stringWithFormat:@"%@",_follow];
            NSString *Fan = [NSString stringWithFormat:@"%@",_fans];
            NSString *XB = [NSString stringWithFormat:@"%@",_score];
            NSString *YH = _card;
            
            SYG = @[F,Fan,XB,YH];
        }else {
            SYG = @[GZString,FSString,XBString,YHKString];
        }

        NSArray *GZArray = @[@"关注",@"粉丝",@"积分"];
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(30 + (MainScreenWidth - 60) / Num * i, 0, (MainScreenWidth - 60) / Num , 20);
        label.text = GZArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        [DYView addSubview:label];
        
        //添加数字
        UILabel *SZLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 + (MainScreenWidth - 60) / Num * i, 20, (MainScreenWidth - 60) / Num , 20)];
        SZLabel.font = [UIFont systemFontOfSize:14];
        SZLabel.text = SYG[i];
        [SZLabel setTextColor:[UIColor whiteColor]];
        SZLabel.textAlignment = NSTextAlignmentCenter;
        [DYView addSubview:SZLabel];
        
        //添加透明的按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30 + (MainScreenWidth - 60 ) / Num * i, 0, (MainScreenWidth - 60) / Num , 40)];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(GZFSButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + 100 * i;
        [DYView addSubview:button];
        
    }
    
    //添加分割线
    for (int i = 0; i < Num - 1; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30 + (MainScreenWidth - 60) / Num + (MainScreenWidth - 60) / Num * i, 0, 1, 35)];
        label.backgroundColor = [UIColor whiteColor];
        [DYView addSubview:label];
    }
}

- (void)addHongBaoView {
    _hongBaoView = [[UIView alloc] initWithFrame:CGRectMake(0, 270, MainScreenWidth, 90)];
    _hongBaoView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_hongBaoView];
    
    //添加线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 0.5, 0, 1, 90)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_hongBaoView addSubview:lineButton];
    
    NSArray *titleArray = @[@"红包集结令",@"全球智能"];
    NSArray *info = @[@"瓜分4万还剩3天",@"积分翻倍赚"];
    
    for (int i = 0 ; i < 2 ; i ++) {
        UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside + MainScreenWidth / 2 * i , 2 * SpaceBaside, 50, 50)];
        imageButton.backgroundColor = [UIColor redColor];
        imageButton.layer.cornerRadius = 25;
        [imageButton setBackgroundImage:Image(@"站位图") forState:UIControlStateNormal];
        imageButton.layer.masksToBounds = YES;
        [_hongBaoView addSubview:imageButton];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(70 + MainScreenWidth / 2 * i, 20, MainScreenWidth / 2 - 60, 20)];
        title.text = titleArray[i];
        title.font = Font(15);
        title.textColor = [UIColor orangeColor];
        [_hongBaoView addSubview:title];
        
        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(70 + MainScreenWidth / 2 * i, 50, MainScreenWidth / 2 - 60, 20)];
        content.text = info[i];
        content.font = Font(13);
        content.textColor = [UIColor grayColor];
        [_hongBaoView addSubview:content];
    }
}

- (void)addOrderView {//添加订单试图
    
    _orderView = [[UIView alloc] initWithFrame:CGRectMake(0, 270, MainScreenWidth, 110)];
    _orderView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_orderView];
    
    //添加我的订单
    UILabel *DD = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 100, 20)];
    DD.text = @"我的订单";
    [_orderView addSubview:DD];
    
    //添加按钮
    UIButton *allDD = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 150, SpaceBaside, 140, 20)];
    [allDD setTitle:@"查看全部" forState:UIControlStateNormal];
    [allDD setImage:Image(@"考试右@2x") forState:UIControlStateNormal];
    allDD.imageEdgeInsets =  UIEdgeInsetsMake(0,120,0,0);
    allDD.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    allDD.titleLabel.font = Font(15);
    [allDD setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [allDD addTarget:self action:@selector(allDDButton:) forControlEvents:UIControlEventTouchUpInside];
    allDD.tag = 10086;
    [_orderView addSubview:allDD];
    
    CGFloat ButtonW = MainScreenWidth / 5;
    CGFloat ButtonH = ButtonW + 20;
    NSArray *titleArray = @[@"待支付",@"已取消",@"已完成",@"申请退款",@"已退款"];
//    NSArray *image = @[@"待支付",@"已取消",@"付款完成",@"申请退款",@"已退款"];order_pay@3x
    NSArray *image = @[@"order_pay@3x",@"order_cancel@3x",@"order_finish@3x",@"order_apply@3x",@"order_refund@2x"];
    
    //确定View 的大小
    _orderView.frame = CGRectMake(0, 270, MainScreenWidth,50 + ButtonH + SpaceBaside - SpaceBaside);

    
    for (int i = 0 ; i < 5 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW * i, 40, ButtonW, ButtonH)];

        [button setImage:Image(image[i]) forState:UIControlStateNormal];
//        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        
        button.imageEdgeInsets =  UIEdgeInsetsMake(0,0,20,0);
//        button.titleEdgeInsets = UIEdgeInsetsMake(ButtonH / 2, -45, 0, 0);
        
        button.titleLabel.font = Font(14);
        button.tag = 10087 + i;
        [button setTitleColor:BlackNotColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(allDDButton:) forControlEvents:UIControlEventTouchUpInside];
        [_orderView addSubview:button];
        
        //添加title
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, ButtonW - 10, ButtonW, 20)];
        title.text = titleArray[i];
        title.font = Font(14);
        title.textAlignment = NSTextAlignmentCenter;
        [button addSubview:title];
        
    }
}

- (void)allDDButton:(UIButton *)button {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    
    NSInteger Tag = button.tag;
//    AllOrderViewController *allOrderVc = [[AllOrderViewController alloc] init];
//    [self.navigationController pushViewController:allOrderVc animated:YES];
//    
//    allOrderVc.typeStr = [NSString stringWithFormat:@"%ld",Tag - 10086];
    
    
        OrderPagerViewController *orderVc = [[OrderPagerViewController alloc] init];
        [self.navigationController pushViewController:orderVc animated:YES];
    
        orderVc.typeStr = [NSString stringWithFormat:@"%ld",Tag - 10086];
    

}


- (void)addMYView {
    
    //添加整个View
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_orderView.frame) + SpaceBaside, MainScreenWidth, MainScreenHeight - 60 + 100)];
    SYGView.backgroundColor = [UIColor colorWithRed:245.f / 255 green:246.f / 255 blue:247.f / 255 alpha:1];
    SYGView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:SYGView];
    SYGView.userInteractionEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    
    CGFloat Bwidth = 45;
    CGFloat width = MainScreenWidth / 4 ;
    CGFloat spare = (MainScreenWidth / 4 - Bwidth) / 4;
    NSLog(@"%f",width - 160);
    NSArray *SYGArray = @[@"我的直播",@"我的课程",@"我的笔记",@"我的收藏",@"我的问答",@"我的文库",@"我的下载",@"我的机构",@"我的优惠券",@"学习记录",@"兑换记录"];
    for (int i = 0 ; i < SYGArray.count ; i ++) {
        NSArray *TBArray = @[@"live@3x",@"course@3x",@"notes@3x",@"collect@3x",@"q&a@3x",@"library@3x",@"download@3x",@"org@3x",@"conpons@3x",@"study@3x",@"record@3x"];
        UIButton *TBButton = [[UIButton alloc] initWithFrame:CGRectMake((width - Bwidth) / 2 +width * (i % 4) , 130 * (i / 4) + 30 , Bwidth, Bwidth)];
        [TBButton setBackgroundImage:[UIImage imageNamed:TBArray[i]] forState:UIControlStateNormal];
        [SYGView addSubview:TBButton];

        //添加文字
        UILabel *WZLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * (i % 4) ,80 + 10 + (i / 4) * 130 ,width,20)];
        WZLabel.text = SYGArray[i];
        WZLabel.textAlignment = NSTextAlignmentCenter;
        WZLabel.font = [UIFont systemFontOfSize:13];
        [SYGView addSubview:WZLabel];
        
        //添加透明的按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width * (i % 4), 130 * (i / 4), width, 130)];
        button.backgroundColor = [UIColor clearColor];
        button.tag = i;
        [button addTarget:self action:@selector(SYGButtton:) forControlEvents:UIControlEventTouchUpInside];
        [SYGView addSubview:button];
        _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(button.frame) + CGRectGetMaxY(_orderView.frame));
    }
    
    
    //添加线
    for (int i = 1 ; i < 4 ; i ++) {
        UIButton *Sline = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 4 * i, 0, 1, 390)];
        Sline.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [SYGView addSubview:Sline];
        
        UIButton *Hline = [[UIButton alloc] initWithFrame:CGRectMake(0, 130 * i , MainScreenWidth,1)];
        if (i == 3) {
            Hline.frame = CGRectMake(0, 130 * i,MainScreenWidth / 4 * 3, 1);
        }
        Hline.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [SYGView addSubview:Hline];

        
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
            
            MyLiveViewController *ZJVC = [[MyLiveViewController alloc] init];
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
            
            CollectMainViewController *collectMainVc = [[CollectMainViewController alloc] init];
            [self.navigationController pushViewController:collectMainVc animated:YES];
            
        }
        if (button.tag == 10) {//说明是兑换记录
            
            ExchangeViewController *JYJLVC =  [[ExchangeViewController alloc] init];
            [self.navigationController pushViewController:JYJLVC animated:YES];
            
        }
        if (button.tag == 4) {//说明是问答
//            
//            MYWDViewController *MYWDVC = [[MYWDViewController alloc] init];
//            [self.navigationController pushViewController:MYWDVC animated:YES];
            
            
            MyAnswerMainViewController *answerMainVc = [[MyAnswerMainViewController alloc] init];
            [self.navigationController pushViewController:answerMainVc animated:YES];
            
        }
        if (button.tag == 6) {//说明是我的下载
            
            [self.navigationController setNavigationBarHidden:NO animated:NO];

            [self.navigationController pushViewController:[MyDownLoadViewController new] animated:YES];
        }
        
        if (button.tag == 9) {//观看记录
            
            LookRecodeViewController *lookVc = [[LookRecodeViewController alloc] init];
            [self.navigationController pushViewController:lookVc animated:YES];
        }

        if (button.tag == 8) {//我的优惠券
            
            DiscountViewController *CouponVc = [[DiscountViewController alloc] init];
            [self.navigationController pushViewController:CouponVc animated:YES];
        }
        if (button.tag == 7) {//我的机构
            
            MyInstationViewController *myInsnVc = [[MyInstationViewController alloc] init];
            [self.navigationController pushViewController:myInsnVc animated:YES];
        }
        if (button.tag == 5) {//我的文库
            
            MyLibraryViewController *myLibVc = [[MyLibraryViewController alloc] init];
            [self.navigationController pushViewController:myLibVc animated:YES];
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
    _score = [defaults objectForKey:@"score"];
    _card = [defaults objectForKey:@"card"];
    
    
    [manager reloadUserContent:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _XXDic = responseObject;
        
        NSLog(@"%@",responseObject);
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
        [defaults setObject:responseObject[@"data"][@"card"] forKey:@"card"];
        [defaults setObject:responseObject[@"data"][@"score"] forKey:@"score"];
        [defaults synchronize];
        
        
         _YHJJLabel.text = _XXDic[@"data"][@"intr"];
        _SYGDic = responseObject;
        [self addGZFSView];
//        [self addMYView];
        
        NSString *commentStr = responseObject[@"data"][@"no_read_comment"];
        NSString *messageStr = responseObject[@"data"][@"no_read_message"];
        NSString *notifyStr = responseObject[@"data"][@"no_read_notify"];
        NSInteger C = [commentStr integerValue];
        NSInteger M = [messageStr integerValue];
        NSInteger N = [notifyStr integerValue];
        if (C + M + N > 0) {//有消息没有读
            if (_msgButton.subviews.count == 1) {//说明第一次
                UIButton *HButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 3, 8, 8)];
                HButton.backgroundColor = [UIColor redColor];
                HButton.layer.cornerRadius = 4;
                [_msgButton addSubview:HButton];
                _HButton = HButton;
                _HButton.hidden = NO;
            } else {//说明已经纯在
                _HButton.hidden = NO;
            }
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
        set.score = _score;
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
    
    [_headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[[_allInformation dictionaryValueForKey:@"data"] stringValueForKey:@"avatar_big"]] forState:0 placeholderImage:nil];
    
//    _imageView =[[UIImageView alloc]init];
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:_allInformation[@"data"][@"avatar_original"]]];
    [_headBtn.layer setBorderWidth:2.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 255.0/255.0, 255.0/255.0, 255.0/255.0, 1 });
    [_headBtn.layer setBorderColor:colorref];//边框颜色
    [_bView addSubview:_headBtn];
    
    _userName.text = [NSString stringWithFormat:@"%@",[[_allInformation dictionaryValueForKey:@"data"] stringValueForKey:@"uname"]];
    _userName.textColor = [UIColor whiteColor];

    
}

- (void)GoToSetting {
//    personDataViewController *personVC = [[personDataViewController alloc] init];
//    personVC.allDict = _allInformation;
//    
//    [self.navigationController pushViewController:personVC animated:YES];
    
    PersonInfoViewController *infoVc = [[PersonInfoViewController alloc] init];
    infoVc.allDict = _allInformation;
    [self.navigationController pushViewController:infoVc animated:YES];
    
    
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
        NSLog(@"%@",responseObject);
        _allInformation = responseObject;
        
        //保存数据
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//        [defaults setObject:_allInformation[@"data"][@"avatar_small"] forKey:@"avatar_small"];
//        [defaults setObject:_allInformation[@"data"][@"uname"] forKey:@"WDC"];
        
        [defaults setObject:[[_allInformation dictionaryValueForKey:@"data"] stringValueForKey:@"avatar_small"] forKey:@"avatar_small"];
        [defaults setObject:[[_allInformation dictionaryValueForKey:@"data"] stringValueForKey:@"uname"] forKey:@"WDC"];
        
        [defaults synchronize];
//
        [self addImageAndButton];
        
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
            NSLog(@"%@",responseObject);
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
                if (_msgButton.subviews.count == 1) {//说明第一次
                    UIButton *HButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 3, 8, 8)];
                    HButton.backgroundColor = [UIColor redColor];
                    HButton.layer.cornerRadius = 4;
                    [_msgButton addSubview:HButton];
                    _HButton = HButton;
                    _HButton.hidden = NO;
                }
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
