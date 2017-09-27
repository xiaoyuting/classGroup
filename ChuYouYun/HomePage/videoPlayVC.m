//
//  videoPlayVC.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/4.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4,4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕


#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕

#define iPhone6PlusBIG ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus放大版屏幕
#define SPACE (self.view.frame.size.width-30*4)/4 //间隙
#import "videoPlayVC.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "playCommentVC.h"
#import "playNoteVC.h"
#import "playQuestonVC.h"
#import "Helper.h"
#import "MyHttpRequest.h"
#import "UMSocial.h"
#import "ZhiyiHTTPRequest.h"

@interface videoPlayVC ()<UIScrollViewDelegate,UIWebViewDelegate,UIAlertViewDelegate>
{
    UIScrollView * _scrollView;
    UIImageView * _arrowImageView;
    UIImageView * imageView;
    UIView * bgView;
    UIButton * collectBtn;
    UIWebView * _webView;
    UIActivityIndicatorView * activity;
    CGRect rect;
    UIScrollView *scrollView;
    UIImageView * view;
    UIButton * button;
    UILabel * label;
    UIButton * Mbtn;
    UIImageView * imageView2;
    playNoteVC * nvc;
    playQuestonVC * qvc;
    playCommentVC * cvc;
}
@end

@implementation videoPlayVC
- (id)initWithMemberId:(NSString *)MemberId
{
    if (self=[super init]) {
        _nid = MemberId;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app._allowRotation = YES;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    self.navigationController.navigationBar.hidden = YES;
    [super viewWillAppear:animated];
    
    UIDevice *device = [UIDevice currentDevice]; //Get the device object
    [device beginGeneratingDeviceOrientationNotifications]; //Tell it to start monitoring the accelerometer for orientation
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; //Get the notification centre for the app
    [nc addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:device];
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    self.navigationController.navigationBar.hidden = NO;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
}
// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

// 支持横竖屏显示
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIDevice *device = [UIDevice currentDevice]; //Get the device object
    [device beginGeneratingDeviceOrientationNotifications]; //Tell it to start monitoring the accelerometer for orientation
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; //Get the notification centre for the app
    [nc addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:device];


    rect = [UIScreen mainScreen].applicationFrame;
    self.view.backgroundColor = [UIColor whiteColor];
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height-116+82)];
    scrollView.contentSize = CGSizeMake(rect.size.width, rect.size.height+168);
    [self.view addSubview:scrollView];

    //隐藏系统导航条
    NSString * str = _playVideoAddress;
    NSLog(@"GG%@",str);
    view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];

    NSLayoutConstraint *myConstraint =[NSLayoutConstraint
                                   constraintWithItem:scrollView
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:_collectStr
                                   attribute:NSLayoutAttributeHeight
                                   multiplier:0
                                   constant:200];
    [self.view addConstraint: myConstraint];

    UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, rect.size.height-28, rect.size.width, 48)];
    barView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:barView];
    
    float by = (MainScreenWidth-240)/4;
    
    UIButton *learning = [UIButton buttonWithType:UIButtonTypeSystem];
    learning.frame = CGRectMake(by, 0, 120, 48);
    [learning setBackgroundImage:[UIImage imageNamed:@"learding.png"] forState:0];
    [learning addTarget:self action:@selector(learningClick) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:learning];
    UIButton *collection = [UIButton buttonWithType:UIButtonTypeSystem];
    collection.frame = CGRectMake(by*3+120, 0, 120, 48);
    [collection setBackgroundImage:[UIImage imageNamed:@"addSC.png"] forState:0];
    [collection addTarget:self action:@selector(collectionClick) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:collection];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake((rect.size.width-1)/2, 0, 1, 48)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [barView addSubview:lineView];
    
    view.backgroundColor = [UIColor whiteColor];
    view.userInteractionEnabled = YES;
    view.image = [UIImage imageNamed:@"options.png"];
    [self.view insertSubview:view atIndex:1];
    [self.view addSubview:view];

    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, 32, 44, 22);
    [button setImage:[UIImage imageNamed:@"Arrow000"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];

    label = [[UILabel alloc]initWithFrame:CGRectMake(MainScreenWidth/2-70, 28, 150, 30)];
    label.text = _playVideoTitle;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    [view addSubview:label];

    //创建分享按钮
    Mbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Mbtn.frame = CGRectMake(MainScreenWidth/2+90,36 , 31, 15);
    [Mbtn setImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
    [Mbtn addTarget:self action:@selector(shareBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:Mbtn];
    [self requestData];
    //创建收藏按钮
    collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(MainScreenWidth-30, 35, 20, 17);
    [collectBtn addTarget:self action:@selector(collectionBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:collectBtn];

    //利用webview播放视频
    if (iPhone5o5Co5S) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight-370)];
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
        [_webView setDelegate:self];
        NSLog(@"++++++++++++%@",str);
        [_webView loadRequest:request];
        _webView.backgroundColor = [UIColor redColor];
        [scrollView addSubview:_webView];
       
    
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, MainScreenHeight-370+64, MainScreenWidth, 40)];
        [scrollView addSubview:bgView];
    
        imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height)];
        imageView2.image = [UIImage imageNamed:@"options.png"];
        [bgView addSubview:imageView2];
    
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 35, 50, 5)];
        _arrowImageView.image = [UIImage imageNamed:@"arrow88.png"];
        [bgView addSubview:_arrowImageView];
    
    }
    
    else if (iPhone4SOriPhone4)
    {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight-300)];
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
        [_webView setDelegate:self];
        NSLog(@"++++++++++++%@",str);
        [_webView loadRequest:request];
        _webView.backgroundColor = [UIColor redColor];
        [scrollView addSubview:_webView];
        
        
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, MainScreenHeight-290+64, MainScreenWidth, 40)];
        [scrollView addSubview:bgView];
        
        imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height)];
        imageView2.image = [UIImage imageNamed:@"options.png"];
        [bgView addSubview:imageView2];
        
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 35, 50, 5)];
        _arrowImageView.image = [UIImage imageNamed:@"arrow88.png"];
        [bgView addSubview:_arrowImageView];
    
    }
    
    else if (iPhone6)
    {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight-390)];
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
        [scrollView addSubview:_webView];
        [_webView loadRequest:request];
    
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, MainScreenHeight-390+64, MainScreenWidth, 40)];
        [scrollView addSubview:bgView];
    
        imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height)];
        imageView2.image = [UIImage imageNamed:@"options.png"];
        [bgView addSubview:imageView2];
    
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(52, 35, 50, 5)];
        _arrowImageView.image = [UIImage imageNamed:@"arrow88.png"];
        [bgView addSubview:_arrowImageView];
    
    }
    else if(iPhone6Plus)
    {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight-410)];
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
        [scrollView addSubview:_webView];
        [_webView loadRequest:request];
    
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, MainScreenHeight-410+64, MainScreenWidth, 40)];
        [scrollView addSubview:bgView];
    
        imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height)];
        imageView2.image = [UIImage imageNamed:@"options.png"];
        [bgView addSubview:imageView2];
    
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(61, 35, 50, 5)];
        _arrowImageView.image = [UIImage imageNamed:@"arrow88.png"];
        [bgView addSubview:_arrowImageView];
    }
    for (int i=0; i<3; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
    
        btn.frame = CGRectMake(SPACE+(SPACE+50)*i, (40-36)/2, 50, 36);
        
        btn.tag = 10080+i;
        btn.selected = NO;
        if (i==0) {
            [btn setTitle:@"笔记" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
        }
        else if(i==1)
        {
                [btn setTitle:@"提问" forState:UIControlStateNormal];
        }
        else if(i==2)
        {
            [btn setTitle:@"点评" forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
    }
    if (iPhone6) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+MainScreenHeight-350, MainScreenWidth, 290+116+168)];
    }
    else if(iPhone5o5Co5S)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+MainScreenHeight-330, MainScreenWidth, 270+116+168)];
    }
    else if(iPhone6Plus)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+MainScreenHeight-370, MainScreenWidth, 310+116+168)];
    }else if (iPhone4SOriPhone4)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+MainScreenHeight-250, MainScreenWidth, 270+168)];
    }

    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView.contentSize = CGSizeMake(MainScreenWidth*3, 0);
    [scrollView addSubview:_scrollView];

    nvc = [[playNoteVC alloc]initWithId:_nid];
    nvc.view.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [self addChildViewController:nvc];
    [_scrollView addSubview:nvc.view];

    qvc = [[playQuestonVC alloc]initWithId:_nid];
    qvc.view.frame = CGRectMake(MainScreenWidth, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [self addChildViewController:qvc];
    [_scrollView addSubview:qvc.view];

    cvc = [[playCommentVC alloc]initWithId:_nid];
    cvc.view.frame = CGRectMake(MainScreenWidth*2, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [self addChildViewController:cvc];
    [_scrollView addSubview:cvc.view];
}
-(void)learningClick{
    [self settleUserDate];
}
-(void)collectionClick{
    [self addShopingCar];
//    [self buyClass];
}

//购买课程
- (void)buyClass {
    
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:@"" forKey:@"vids"];
    NSLog(@"%@",dic);
    
    [manager settleUserShopingCar:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"^^%@",responseObject);
        NSString *msg = [responseObject objectForKey:@"msg"];
        if (![msg isEqual:@"ok"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"购买成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];
            
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

    
    
}


-(void)addShopingCar
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:@"420591e976ca09540022e8c51d16ca73" forKey:@"oauth_token"];
    [dic setObject:@"99928518802affe98359b9646cdaca3b" forKey:@"oauth_token_secret"];
    [dic setObject:_nid forKey:@"id"];
    [manager addToShopingCar:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"++++%@",responseObject);
        NSString *msg = [responseObject objectForKey:@"msg"];
        
        if (![msg isEqual:@"ok"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    //应该先判断是否已经收藏此课程
    ZhiyiHTTPRequest *manager1 = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic1 setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic1 setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [manager1 UserShopingCar:dic1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"---1^---%@",responseObject);
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {
            ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
            [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
            [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
            [dic setObject:_nid forKey:@"id"];
            NSLog(@"((%@",_nid);
            [manager addToShopingCar:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"---^---%@",responseObject);
                NSString *msg = [responseObject objectForKey:@"msg"];
                if (![msg isEqual:@"ok"]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"加入成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
            
        } else {
            
            NSArray *array = responseObject[@"data"];
            for (int i = 0 ; i < array.count ; i ++) {
                NSString *key = array[i][@"id"];
                if (_nid == key) {
                    //说明已经收藏过了。
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"已经收藏了" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                    return ;
                }
                
            }
            
            ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
            [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
            [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
            [dic setObject:_nid forKey:@"id"];
            NSLog(@"((%@",_nid);
            [manager addToShopingCar:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"---^---%@",responseObject);
                NSString *msg = [responseObject objectForKey:@"msg"];
                if (![msg isEqual:@"ok"]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"加入成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)settleUserDate
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:@"420591e976ca09540022e8c51d16ca73" forKey:@"oauth_token"];
    [dic setObject:@"99928518802affe98359b9646cdaca3b" forKey:@"oauth_token_secret"];
    [dic setObject:_nid forKey:@"vids"];
    [manager settleUserShopingCar:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        if (![msg isEqual:@"ok"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)orientationChanged:(NSNotification *)note  {
    UIDeviceOrientation o = [[UIDevice currentDevice] orientation];
    switch (o) {
        case UIDeviceOrientationPortrait:            // Device oriented vertically, home button on the bottom
            [self  layouts];
            break;
        case UIDeviceOrientationLandscapeLeft:
        {// Device oriented horizontally, home button on the right
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
            [self layoutsOfLR];
            
            
        }
            break;
        case UIDeviceOrientationLandscapeRight:      // Device oriented horizontally, home button on the left
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
            
            [self layoutsOfLR];
            break;
        default:
            break;
    }
}
-(void)layouts
{
    scrollView.frame=CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-116+82);
    scrollView.contentSize = CGSizeMake(rect.size.width, rect.size.height+168);
    view.frame=CGRectMake(0, 0, MainScreenWidth, 64);
    
    button.frame = CGRectMake(15, 32, 44, 22);
    
    
    label.frame=CGRectMake(MainScreenWidth/2-70, 28, 140, 30);
    //创建分享按钮
    Mbtn.frame = CGRectMake(MainScreenWidth/2+80,36 , 31, 15);
    //创建收藏按钮
    collectBtn.frame = CGRectMake(MainScreenWidth-30, 35, 20, 17);
    if (iPhone4SOriPhone4||iPhone5o5Co5S) {
        _webView.frame=CGRectMake(0, 64, MainScreenWidth, MainScreenHeight-370);
        bgView.frame=CGRectMake(0, MainScreenHeight-370+64, MainScreenWidth, 40);
        imageView2.frame=CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height);
        _arrowImageView.frame=CGRectMake(40, 35, 50, 5);
    }
    else if (iPhone6)
    {
        _webView.frame=CGRectMake(0, 64, MainScreenWidth, MainScreenHeight-390);
        bgView.frame=CGRectMake(0, MainScreenHeight-370+64, MainScreenWidth, 40);
        imageView2.frame=CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height);
        _arrowImageView.frame=CGRectMake(40, 35, 50, 5);
    }
    else if(iPhone6Plus)
    {
        _webView.frame=CGRectMake(0, 64, MainScreenWidth, MainScreenHeight-410);
        bgView.frame=CGRectMake(0, MainScreenHeight-370+64, MainScreenWidth, 40);
        imageView2.frame=CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height);
        _arrowImageView.frame=CGRectMake(40, 35, 50, 5);
    }
    for (int i=0; i<3; i++) {
        UIButton * btn = (UIButton *)[bgView viewWithTag:10080+i];
        btn.frame = CGRectMake(SPACE+(SPACE+48)*i, (40-36)/2, 30, 36);
    }
    if (iPhone6) {
        _scrollView.frame=CGRectMake(0, 64+MainScreenHeight-350, MainScreenWidth, 290+116+82);
    }
    else if(iPhone5o5Co5S)
    {
        _scrollView.frame=CGRectMake(0, 64+MainScreenHeight-330, MainScreenWidth, 270+116+82);
    }
    else if(iPhone6Plus)
    {
        _scrollView.frame=CGRectMake(0, 64+MainScreenHeight-370, MainScreenWidth, 310+116+82);
    }
    _scrollView.contentSize = CGSizeMake(MainScreenWidth*3, 0);
    [scrollView addSubview:_scrollView];
    nvc.view.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    qvc.view.frame = CGRectMake(MainScreenWidth, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    cvc.view.frame = CGRectMake(MainScreenWidth*2, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
}
-(void)layoutsOfLR
{
    scrollView.frame=CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
    scrollView.contentSize = CGSizeMake(0, 0) ;
    view.frame=CGRectMake(0, 0, MainScreenWidth, 64);
    
    button.frame = CGRectMake(15, 32, 44, 22);
    
    
    label.frame=CGRectMake(MainScreenWidth/2-70, 28, 140, 30);
    //创建分享按钮
    Mbtn.frame = CGRectMake(MainScreenWidth-80,36 , 31, 15);
    //创建收藏按钮
    collectBtn.frame = CGRectMake(MainScreenWidth-30, 35, 20, 17);
    if (iPhone4SOriPhone4||iPhone5o5Co5S) {
        _webView.frame=CGRectMake(0, 64, MainScreenWidth, MainScreenHeight);
        bgView.frame=CGRectMake(0, MainScreenHeight-370+64, MainScreenWidth, 40);
        imageView2.frame=CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height);
        _arrowImageView.frame=CGRectMake(40, 35, 50, 5);
    }
    else if (iPhone6)
    {
        _webView.frame=CGRectMake(0, 64, MainScreenWidth, MainScreenHeight);
        bgView.frame=CGRectMake(0, MainScreenHeight-370+64, MainScreenWidth, 40);
        imageView2.frame=CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height);
        _arrowImageView.frame=CGRectMake(40, 35, 50, 5);
    }
    else if(iPhone6Plus)
    {
        _webView.frame=CGRectMake(0, 64, MainScreenWidth, MainScreenHeight);
        bgView.frame=CGRectMake(0, MainScreenHeight-370+64, MainScreenWidth, 40);
        imageView2.frame=CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height);
        _arrowImageView.frame=CGRectMake(40, 35, 50, 5);
    }
    for (int i=0; i<3; i++) {
        UIButton * btn = (UIButton *)[bgView viewWithTag:10080+i];
        btn.frame = CGRectMake(SPACE+(SPACE+48)*i, (40-36)/2, 30, 36);
    }

    
    [_scrollView removeFromSuperview];
    nvc.view.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    qvc.view.frame = CGRectMake(MainScreenWidth, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    cvc.view.frame = CGRectMake(MainScreenWidth*2, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
}
- (void)btnClick:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    

    switch (btn.tag) {
        case 10080:
            if (iPhone4SOriPhone4||iPhone5o5Co5S) {
                _arrowImageView.frame = CGRectMake(49, 35, 50, 5);
            }
            else if (iPhone6)
            {
                _arrowImageView.frame = CGRectMake(61, 35, 50, 5);
            }
            else if(iPhone6Plus)
            {
                _arrowImageView.frame = CGRectMake(71, 35, 50, 5);

            }
            
            _scrollView.contentOffset = CGPointMake(0, 0);
            break;
            case 10081:
            if (iPhone4SOriPhone4||iPhone5o5Co5S) {
                _arrowImageView.frame = CGRectMake(136+9, 35, 50, 5);

            }
            else if(iPhone6)
            {
                _arrowImageView.frame = CGRectMake(165+9, 35, 50, 5);
            }
            else if(iPhone6Plus)
            {
                _arrowImageView.frame = CGRectMake(183+9, 35, 50, 5);

            }
            _scrollView.contentOffset = CGPointMake(MainScreenWidth, 0);
            break;
            case 10082:
            if (iPhone4SOriPhone4||iPhone5o5Co5S) {
                _arrowImageView.frame = CGRectMake(235+9, 35, 50, 5);

            }
            else if(iPhone6)
            {
                 _arrowImageView.frame = CGRectMake(276+9, 35, 50, 5);
            }
            else if (iPhone6Plus)
            {
                _arrowImageView.frame = CGRectMake(305+9, 35, 50, 5);

            }
            _scrollView.contentOffset = CGPointMake(MainScreenWidth*2, 0);
            break;
        default:
            break;
    }
    int p=_arrowImageView.frame.origin.x;
    if (iPhone4SOriPhone4||iPhone5o5Co5S) {
        switch (p) {
            case 40:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
            case 136:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
                break;
            case 235:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
            }
                
            default:
                break;
    }
    }
    
    else if(iPhone6)
    {
        switch (p) {
            case 52:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
            case 165:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
                break;
            case 276:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
            }
                
            default:
                break;

    }
    }
    else if(iPhone6Plus)
    {
        switch (p) {
            case 62:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
            case 183:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
                break;
            case 305:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
            }
                
            default:
                break;
                
        }

    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==_scrollView) {
        CGPoint point = scrollView.contentOffset;
        if (point.x==0) {
            if (iPhone4SOriPhone4||iPhone5o5Co5S) {
                _arrowImageView.frame = CGRectMake(40, 35, 50, 5);
            }
            else if(iPhone6)
            {
                _arrowImageView.frame = CGRectMake(52, 35, 50, 5);

            }
            else if (iPhone6Plus)
            {
                _arrowImageView.frame = CGRectMake(62, 35, 50, 5);

            }
            
            _scrollView.contentOffset = CGPointMake(0, 0);
        }
        else if(point.x==MainScreenWidth)
        {
            if (iPhone4SOriPhone4||iPhone5o5Co5S) {
                _arrowImageView.frame = CGRectMake(136, 35, 50, 5);
            }
            else if (iPhone6)
            {
                    _arrowImageView.frame = CGRectMake(165, 35, 50, 5);
            }
            else if(iPhone6Plus)
            {
                _arrowImageView.frame = CGRectMake(183, 35, 50, 5);

            }
            
            _scrollView.contentOffset = CGPointMake(MainScreenWidth, 0);
        }
        else if(point.x==MainScreenWidth*2)
        {
            if (iPhone4SOriPhone4||iPhone5o5Co5S) {
                _arrowImageView.frame = CGRectMake(235, 35, 50, 5);

            }
            else if(iPhone6)
            {
                _arrowImageView.frame = CGRectMake(276, 35, 50, 5);

            }
            else if(iPhone6Plus)
            {
                _arrowImageView.frame = CGRectMake(305, 35, 50, 5);

            }
            _scrollView.contentOffset = CGPointMake(MainScreenWidth*2, 0);
        }
    }
    int p = _arrowImageView.frame.origin.x;
    if (iPhone4SOriPhone4||iPhone5o5Co5S) {
        switch (p) {
            case 40:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
            case 136:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
                break;
            case 235:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
            }
                
            default:
                break;
        }

    }
    else if (iPhone6)
    {
        switch (p) {
            case 52:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
            case 165:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
                break;
            case 276:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
            }
                
            default:
                break;
        }

    }
    else if (iPhone6Plus)
    {
        switch (p) {
            case 62:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
            case 183:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
                break;
            case 305:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
            }
                
            default:
                break;
        }

    }
}

- (void)requestData
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_nid forKey:@"id"];
    [manager getClassDetail:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {
            
        } else {
            _collectStr = [responseObject objectForKey:@"data"][@"iscollect"];
            NSLog(@"-_collectStr------%@",_collectStr);
            if ([_collectStr intValue]==1) {
                [collectBtn setImage:[UIImage imageNamed:@"Like.png"] forState:UIControlStateNormal];
            }
            else
            {
                [collectBtn setImage:[UIImage imageNamed:@"Like_pressed.png"] forState:UIControlStateNormal];
            }
            

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)collectionBtn
{
    if ([_collectStr intValue]==1) {
        QKHTTPManager * manager = [QKHTTPManager manager];
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:@"2" forKey:@"sctype"];
        [dic setValue:@"0" forKey:@"type"];
        [dic setValue:_nid forKey:@"source_id"];
        [manager collect:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"----%@",responseObject);
            [collectBtn setImage:[UIImage imageNamed:@"Like_pressed.png"] forState:UIControlStateNormal];
            [self requestData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    else
    {
        QKHTTPManager * manager1 =[QKHTTPManager manager];
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:@"2" forKey:@"sctype"];
        [dic setValue:@"1" forKey:@"type"];
        [dic setValue:_nid forKey:@"source_id"];
        [manager1 collect:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"----%@",responseObject);
            [collectBtn setImage:[UIImage imageNamed:@"Like.png"] forState:UIControlStateNormal];
            [self requestData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }

}
//友盟574e8829e0f55a12f8001790

- (void)shareBtn
{
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"574e8829e0f55a12f8001790"
                                      shareText:[NSString stringWithFormat:@"我正在出右云课堂app观看—%@视频地址%@",_playVideoTitle,_playVideoAddress]
                                     shareImage:[UIImage imageNamed:@"chuyou.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToQQ,UMShareToDouban, UMShareToWechatTimeline,nil]
                                       delegate:self];
    
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
