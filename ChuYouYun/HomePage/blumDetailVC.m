//
//  blumDetailVC.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/12.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4 4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕


#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕

#define iPhone6PlusBIG ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus放大版屏幕
#define SPACE (self.view.frame.size.width-35*4)/4 //间隙
#define pKey @""

#import "blumDetailVC.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "Helper.h"
#import "blumNoteVC.h"
#import "blumQuestionVC.h"
#import "blumDetailMessageVC.h"
#import "blumCommentVC.h"
#import "blumCharacterVC.h"
#import "MyHttpRequest.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "ZhiyiHTTPRequest.h"
#import "RechanrgViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "MakeBlumNote.h"
#import "SYGNoteViewController.h"
#import "MakeBiumQuestion.h"
#import "DLViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UMSocial.h"
#import "WMPlayer.h"
#import "SYG.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD+Add.h"
#import "ZFDownloadManager.h"
#import "GLNetWorking.h"

@import MediaPlayer;


@interface blumDetailVC ()<UIScrollViewDelegate,UIWebViewDelegate,UMSocialUIDelegate,UIGestureRecognizerDelegate>

//@interface blumDetailVC ()<UIScrollViewDelegate,UIWebViewDelegate,UMSocialUIDelegate,WMPlayerDelegate>

{
    UIScrollView * _scrollView;
    UIImageView * _arrowImageView;
    UIImageView * imageView;
    UIView * bgView;
    UIScrollView * _imageScrollView;
    UIPageControl * _pageControl;
    NSTimer * timer;
    UIImageView * img;
    BOOL isFromStart;
    MBProgressHUD * HUD;
    CGRect rect;
    UIScrollView *bgScrollView;
    BOOL  isSecet;
    UIWebView *_webView;
    WMPlayer *wmPlayer;
    CGRect playerFrame;
    NSString *_videoAddress;
    
}

@property (strong ,nonatomic)UIButton *allButton;

@property (strong ,nonatomic)UIView *GDView;

@property (strong ,nonatomic)UIButton *ALButton;

@property (strong ,nonatomic)UIView *ALGDView;

@property (strong ,nonatomic)NSString *classID;

@property (strong ,nonatomic)NSString *LJStr;

@property (strong ,nonatomic)UIButton *DJbutton;

@property (strong ,nonatomic)NSString *addressStr;

@property (strong ,nonatomic)MPMoviePlayerController *player;

@property (strong ,nonatomic)NSTimer *timer;

@property (strong ,nonatomic)NSDictionary *SYGDic;

@property (strong ,nonatomic)NSFileHandle *writeHandle;

@property (strong ,nonatomic)UIImageView *imageView;

@property (assign ,nonatomic)NSInteger timeNum;

@property (strong ,nonatomic)UIButton *buyButton;

@end

@implementation blumDetailVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //视频播放结束通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    }
    return self;
}

- (void)videoFinished{
    if (videoRequest) {
        //isPlay = !isPlay;
        [videoRequest clearDelegatesAndCancel];
        videoRequest = nil;
    }
}

//从本地取出来
- (void)getVideo {
    
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:cachePath])
    {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if ([fileManager fileExistsAtPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"vedio_%@.mp4",_classID]]]) {
        
        NSString *HHH = [NSString stringWithFormat:@"vedio_%@.mp4",_classID];
        NSString *movePath =  [cachePath stringByAppendingPathComponent:HHH];
        
        NSLog(@"%@",cachePath);
        NSLog(@"%@",movePath);
        
        ///Users/ios/Library/Developer/CoreSimulator/Devices/340EE57E-6D91-4FEC-A855-4ABDAC7CAC7D/data/Containers/Data/Application/7AF753DD-A081-4C00-B2FA-CF158A952F6E/Library/Private Documents/Cache
        
        if (wmPlayer!=nil||wmPlayer.superview !=nil){
            [self releaseWMPlayer];
        }
        [_imageView removeFromSuperview];
        _imageView = nil;
        
        if (iPhone4SOriPhone4 || iPhone5o5Co5S || iPhone6 || iPhone6Plus) {
             playerFrame = CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 390);
        } else {//ipad适配
             playerFrame = CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - (bgView.frame.origin.y+bgView.frame.size.height));
        }

        wmPlayer = [[WMPlayer alloc] initWithFrame:playerFrame videoURLStr:movePath];
        NSLog(@"----%@",movePath);
//        wmPlayer.URLString = movePath;
        wmPlayer.closeBtn.hidden = YES;
        [self.view addSubview:wmPlayer];
        [wmPlayer.player play];
        
        //注册播放完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
        videoRequest = nil;
    }
}

- (void)downWithurl:(NSString *)urlStr {
    
    
    NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
    
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    
    //注册播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
    
    //下载完存储目录
    [request setDownloadDestinationPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"vedio_%@.mp4",_classID]]];
    //临时存储目录
    [request setTemporaryFileDownloadPath:[webPath stringByAppendingPathComponent:[NSString stringWithFormat:@"vedio_%@.mp4",_classID]]];
    [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setDouble:total forKey:@"file_length"];
        Recordull += size;//Recordull全局变量，记录已下载的文件的大小
        
    }];
    //断点续载
    [request setAllowResumeForFileDownloads:YES];
    [request startAsynchronous];
    videoRequest = request;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //注册播放完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
        
    }
    return self;
}

-(id)initWithMemberId:(NSString *)MemberId andTitle:(NSString *)title
{
    if (self=[super init]) {
        _cid = MemberId;
        _videoTitle=title;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [self requestData];
    [nv isHiddenCustomTabBarByBoolean:YES];
    [super viewWillAppear:animated];
    [self requestData2];
    [self getFreeTime];
    
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
}


-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
    [wmPlayer removeFromSuperview];
    wmPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        wmPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    wmPlayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    wmPlayer.playerLayer.frame =  CGRectMake(0,0, self.view.frame.size.height,self.view.frame.size.width);
    //在这里设置提醒试看试图的大小 （跟着视频大小的变化一起变化）
    _imageView.frame = CGRectMake(0,0, self.view.frame.size.height,self.view.frame.size.width);
    
    [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.view.frame.size.width-40);
        make.width.mas_equalTo(self.view.frame.size.height);
    }];
    
    [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wmPlayer).with.offset((-self.view.frame.size.height/2));
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(wmPlayer).with.offset(5);
        
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
    wmPlayer.isFullscreen = YES;
    wmPlayer.fullScreenBtn.selected = YES;
    [wmPlayer bringSubviewToFront:wmPlayer.bottomView];
    
}

-(void)toNormal{
    [wmPlayer removeFromSuperview];
    [UIView animateWithDuration:0.5f animations:^{
        wmPlayer.transform = CGAffineTransformIdentity;
        wmPlayer.frame =CGRectMake(playerFrame.origin.x, playerFrame.origin.y, playerFrame.size.width, playerFrame.size.height);
        //设置提醒试图的大小
        _imageView.frame = CGRectMake(0, 0, playerFrame.size.width, playerFrame.size.height);
        
        wmPlayer.playerLayer.frame =  wmPlayer.bounds;
        [self.view addSubview:wmPlayer];
        [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(wmPlayer).with.offset(0);
        }];
        [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(wmPlayer).with.offset(5);
        }];
        
    }completion:^(BOOL finished) {
        wmPlayer.isFullscreen = NO;
        wmPlayer.fullScreenBtn.selected = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
        
    }];
}


-(void)fullScreenBtnClick:(NSNotification *)notice{
    UIButton *fullScreenBtn = (UIButton *)[notice object];
    if (fullScreenBtn.isSelected) {//全屏显示
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        [self toNormal];
    }
}


/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange{
    if (wmPlayer==nil||wmPlayer.superview==nil){
        return;
    }
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            if (wmPlayer.isFullscreen) {
                [self toNormal];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            if (wmPlayer.isFullscreen == NO) {
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            if (wmPlayer.isFullscreen == NO) {
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
        }
            break;
        default:
            break;
    }
}


-(void)releaseWMPlayer{
    [wmPlayer.player.currentItem cancelPendingSeeks];
    [wmPlayer.player.currentItem.asset cancelLoading];
    
    [wmPlayer.player pause];
    [wmPlayer removeFromSuperview];
    [wmPlayer.playerLayer removeFromSuperlayer];
    [wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
    wmPlayer = nil;
    wmPlayer.player = nil;
    wmPlayer.currentItem = nil;
    
    wmPlayer.playOrPauseBtn = nil;
    wmPlayer.playerLayer = nil;
}

-(void)dealloc{
    [self releaseWMPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"player deallco");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isSecet = NO;
    
    rect = [UIScreen mainScreen].applicationFrame;
    self.view.backgroundColor = [UIColor whiteColor];
    _titleText = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 0, 30)];
    _titleText.backgroundColor = [UIColor clearColor];
    _titleText.textColor=[UIColor blackColor];
    [_titleText setFont:[UIFont systemFontOfSize:15]];
    [_titleText setText:_videoTitle];
    self.navigationItem.titleView=_titleText;
    
    
    //返回
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 22)];
    [backButton setImage:[UIImage imageNamed:@"iconfont-FH"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:back];
    
    UILabel *rightlab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 22)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightlab];
    //分类
    //添加分类按钮
    UIButton *FLButton = [UIButton buttonWithType:UIButtonTypeSystem];
    FLButton.frame = CGRectMake(15, 30, 20, 20);
    [FLButton setBackgroundImage:[UIImage imageNamed:@"fenleisyg"] forState:UIControlStateNormal];
    [FLButton setTitle:@"下载" forState:UIControlStateNormal];
    [FLButton addTarget:self action:@selector(calssifyClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *kind = [[UIBarButtonItem alloc] initWithCustomView:FLButton];
    
    self.navigationItem.leftBarButtonItems = @[back,right,kind];
    
    
    bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height-116+82 + 100)];
    bgScrollView.contentSize = CGSizeMake(rect.size.width, rect.size.height+168);
    [self.view addSubview:bgScrollView];
    
    UIButton *buyButton = [[UIButton alloc] init];
    [buyButton setBackgroundImage:[UIImage imageNamed:@"悬浮9"] forState:UIControlStateNormal];
    [self.view addSubview:buyButton];
    _buyButton = buyButton;
    
    UITapGestureRecognizer* singleRecognizer;
    //单击
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buyClick)];
    
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [buyButton addGestureRecognizer:singleRecognizer];
  
//    //长按
    UILongPressGestureRecognizer *longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longClick:)];
    longP.delegate = self;
    [buyButton addGestureRecognizer:longP];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetCLassID:) name:@"notificationClassID" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangeImage:) name:@"notificationName" object:nil];
    //添加箭头等
    if (iPhone4SOriPhone4) {
        
        playerFrame = CGRectMake(0, 64, self.view.frame.size.width, MainScreenWidth*3/5);

        bgView = [[UIView alloc]initWithFrame:CGRectMake(0,playerFrame.origin.y + playerFrame.size.height, MainScreenWidth, 40)];
        [bgScrollView addSubview:bgView];
        
        UIImageView * imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, bgView.bounds.size.width, bgView.bounds.size.height)];
        imageView2.image = [UIImage imageNamed:@"options.png"];
        [bgView addSubview:imageView2];
        
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(32, 35, 50, 5)];
        _arrowImageView.image = [UIImage imageNamed:@"尖角.png"];
        [bgView addSubview:_arrowImageView];
        
        buyButton.frame = CGRectMake(MainScreenWidth - 70, MainScreenHeight - 220 + 64, 40,40);
        
    }else if (iPhone5o5Co5S) {
        
        playerFrame = CGRectMake(0, 64, self.view.frame.size.width, MainScreenWidth*3/5);

        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, playerFrame.origin.y + playerFrame.size.height, MainScreenWidth, 40)];
        
        [bgScrollView addSubview:bgView];
        
        UIImageView * imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height)];
        
        imageView2.image = [UIImage imageNamed:@"options.png"];
        
        [bgView addSubview:imageView2];
        
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(32, 35, 50, 5)];
        _arrowImageView.image = [UIImage imageNamed:@"尖角.png"];
        [bgView addSubview:_arrowImageView];
        
        buyButton.frame = CGRectMake(MainScreenWidth - 70, MainScreenHeight - 290 + 64, 40,40);
    }
    else if(iPhone6)
    {
        playerFrame = CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 390);

        bgView = [[UIView alloc]initWithFrame:CGRectMake(0,playerFrame.origin.y + playerFrame.size.height, MainScreenWidth, 40)];
        [bgScrollView addSubview:bgView];
        
        UIImageView * imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height)];
        imageView2.image = [UIImage imageNamed:@"options.png"];
        [bgView addSubview:imageView2];
        
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(45, 35, 50, 5)];
        _arrowImageView.image = [UIImage imageNamed:@"尖角.png"];
        [bgView addSubview:_arrowImageView];
        
        //设置购买按钮的位置
        buyButton.frame = CGRectMake(MainScreenWidth - 70, MainScreenHeight - 310 + 64, 50,50);
        
    }
    else if(iPhone6Plus)
    {
        playerFrame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.width)*3/4);

        bgView = [[UIView alloc]initWithFrame:CGRectMake(0,playerFrame.origin.y + playerFrame.size.height, MainScreenWidth, 40)];
        [bgScrollView addSubview:bgView];
        
        UIImageView * imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height)];
        imageView2.image = [UIImage imageNamed:@"options.png"];
        [bgView addSubview:imageView2];
        

        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(58, 35, 50, 5)];
        _arrowImageView.image = [UIImage imageNamed:@"尖角.png"];
        [bgView addSubview:_arrowImageView];
        
        buyButton.frame = CGRectMake(MainScreenWidth - 60, MainScreenHeight - 310 + 64, 50,50);
        
    } else {//ipad 适配
        
        playerFrame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.width)*3/5);

        bgView = [[UIView alloc]initWithFrame:CGRectMake(0,playerFrame.origin.y + playerFrame.size.height, MainScreenWidth, 40)];
        [bgScrollView addSubview:bgView];
        
        UIImageView * imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height)];
        imageView2.image = [UIImage imageNamed:@"options.png"];
        [bgView addSubview:imageView2];
        
        
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(145, 35, 50, 5)];
        _arrowImageView.image = [UIImage imageNamed:@"尖角.png"];
        [bgView addSubview:_arrowImageView];
        
        buyButton.frame = CGRectMake(MainScreenWidth - 60,playerFrame.origin.y + playerFrame.size.height+50, 50,50);
        
    }
    
    for (int i=0; i< 3; i++) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btn.titleLabel.font = [UIFont systemFontOfSize:15];
        _btn.frame = CGRectMake(SPACE+(SPACE+50)*i, (40-36)/2, 50, 36);
        _btn.tag = 10080+i;
        _btn.selected = NO;
//        _btn.backgroundColor = [UIColor cyanColor];
        if (i==0) {
            [_btn setTitle:@"章节" forState:UIControlStateNormal];
            [_btn setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
        }
        else if (i==1)
        {
            [_btn setTitle:@"点评" forState:UIControlStateNormal];
        }
        else if (i==2)
        {
            [_btn setTitle:@"详情" forState:UIControlStateNormal];
        }

        [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:_btn];
    }
    
    if (iPhone6) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, bgView.frame.origin.y+bgView.frame.size.height, MainScreenWidth, MainScreenHeight-bgView.frame.origin.y+bgView.frame.size.height)];
    }
    else if(iPhone5o5Co5S)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,bgView.frame.origin.y+bgView.frame.size.height, MainScreenWidth, MainScreenHeight-bgView.frame.origin.y+bgView.frame.size.height)];
    }
    else if(iPhone6Plus)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,bgView.frame.origin.y+bgView.frame.size.height, MainScreenWidth,MainScreenHeight-bgView.frame.origin.y+bgView.frame.size.height)];
    }else if (iPhone4SOriPhone4)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,bgView.frame.origin.y+bgView.frame.size.height, MainScreenWidth, MainScreenHeight-bgView.frame.origin.y+bgView.frame.size.height)];
    }else {//ipad适配
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, bgView.frame.origin.y+bgView.frame.size.height, MainScreenWidth, MainScreenHeight-bgView.frame.origin.y+bgView.frame.size.height)];
        
    }
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView.contentSize = CGSizeMake(MainScreenWidth*3, 0);
    [bgScrollView addSubview:_scrollView];
    
    blumDetailMessageVC * bvc= [[blumDetailMessageVC alloc]initWithId:_cid andTitle:_videoTitle];
    bvc.view.frame = CGRectMake(MainScreenWidth * 2, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [self addChildViewController:bvc];
    [_scrollView addSubview:bvc.view];
    
    blumCommentVC  * cvc = [[blumCommentVC alloc]initWithId:_cid];
    cvc.view.frame = CGRectMake(MainScreenWidth, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [self addChildViewController:cvc];
    [_scrollView addSubview:cvc.view];
    
    blumCharacterVC * zvc = [[blumCharacterVC alloc]initWithId:_cid andTitle:_videoTitle];
    zvc.view.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [self addChildViewController:zvc];
    [_scrollView addSubview:zvc.view];
    
    [self addTimer];
    
}

- (void)GetCLassID:(NSNotification *)not {
    
    _classID = (NSString *)not.userInfo;
    NSLog(@"%@",_classID);
    
    
    //在这里调用视频缓存的方法
    
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:cachePath])
    {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if ([fileManager fileExistsAtPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"vedio_%@.mp4",_classID]]]) {
        [self getVideo];
        return;
    }
    
    [self loadClassData:_classID];
}
//下载视频的本地记录地址
//取出本地的
- (void)load{

    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:cachePath])
    {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if ([fileManager fileExistsAtPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"vedio_%@.mp4",_classID]]]) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"已存在下载列表" toView:self.view];
        return;
    }
    
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    
#pragma mark - 保存为dic.plist
    //把TestPlist文件加入
    
    NSString *plistPaths = [libPath stringByAppendingPathComponent:@"downLoadVideo.plist"];
    
    //建立文件管理
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //开始创建文件
    
    [fm createFileAtPath:plistPaths contents:nil attributes:nil];
    
    //创建一个数组
    
    NSArray *arr = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4", nil];
    
    //写入
    
    [arr writeToFile:plistPaths atomically:YES];
    
    //读取
    
    NSArray *arr1 = [NSArray arrayWithContentsOfFile:plistPaths];
    
    //打印
    
    NSLog(@"arr1is %@",arr1);
    
//    //获取完整路径
//    NSString *plistPath = [libPath stringByAppendingPathComponent:@"downLoad.plist"];
//    NSDictionary *Dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
//    NSLog(@"%@",Dic);
//    NSArray *keyA = [Dic allKeys];
//    for (NSString *key in keyA) {
//        if ([key isEqualToString:_classID]) {//说明有数据
//            return Dic[bulmId];
//        }
//    }
}

-(void)loadClassData:(NSString *)classID
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:classID forKey:@"id"];
    [manager getClassDetail:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject[@"data"][@"video_address"]);
        _videoAddress = responseObject[@"data"][@"video_address"];
        _addressStr = responseObject[@"data"][@"video_address"];
        
        NSURL *url = [NSURL URLWithString:_videoAddress];
        
        NSLog(@"=========000============%@",url);
        //在这里判断本地是否有视频
        
        NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
        NSFileManager *fileManager=[NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:cachePath])
        {
            [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        if (![fileManager fileExistsAtPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"vedio_%@.mp4",_classID]]]) {
            
            if ([_SYGDic[@"data"][@"is_buy"] integerValue]) {//购买了的
                
                //如果购买了就在这里进行缓存视频
                [self downWithurl:_videoAddress];
            }
            
        }
        
        
        if (iPhone4SOriPhone4||iPhone5o5Co5S) {
            
            if (wmPlayer!=nil||wmPlayer.superview !=nil){
                [self releaseWMPlayer];
            }
            [_imageView removeFromSuperview];
            _imageView = nil;
            
            //创建播放器
            playerFrame = CGRectMake(0, 64, self.view.frame.size.width, MainScreenWidth*3/5);
            wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:_videoAddress];
//            wmPlayer.URLString = _videoAddress;
            wmPlayer.closeBtn.hidden = YES;
//            wmPlayer.delegate = self;
            [self.view addSubview:wmPlayer];
            [wmPlayer.player play];
            
            //注册播放完成通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
            
        }
        else if (iPhone6)
        {
            if (wmPlayer!=nil||wmPlayer.superview !=nil){
                [self releaseWMPlayer];
            }
            [_imageView removeFromSuperview];
            _imageView = nil;
            //创建播放器
            playerFrame = CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 390);
            wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:_videoAddress];
//            wmPlayer.URLString = _videoAddress;
            wmPlayer.closeBtn.hidden = YES;
            [self.view addSubview:wmPlayer];
            [wmPlayer.player play];
            
            //注册播放完成通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
        }
        else if(iPhone6Plus)
        {
            
            if (wmPlayer!=nil||wmPlayer.superview !=nil){
                [self releaseWMPlayer];
            }
            
            if (_imageView != nil) {
                [_imageView removeFromSuperview];
            }
            [_imageView removeFromSuperview];
            _imageView = nil;
            
            //创建播放器
            playerFrame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.width)*3/4);
            wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:_videoAddress];
//            wmPlayer.URLString = _videoAddress;

            wmPlayer.closeBtn.hidden = YES;
            [self.view addSubview:wmPlayer];
            [wmPlayer.player play];
            
            //注册播放完成通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
        } else {//ipad适配
            
            if (wmPlayer!=nil||wmPlayer.superview !=nil){
                [self releaseWMPlayer];
            }
            
            if (_imageView != nil) {
                [_imageView removeFromSuperview];
            }
            [_imageView removeFromSuperview];
            _imageView = nil;
            
            //创建播放器
            playerFrame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.width)*3/5);
            wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:_videoAddress];
            //            wmPlayer.URLString = _videoAddress;
            
            wmPlayer.closeBtn.hidden = YES;
            [self.view addSubview:wmPlayer];
            [wmPlayer.player play];
            
            //注册播放完成通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
        }
        
        NSLog(@"----%@",_SYGDic);
        
        if ([_SYGDic[@"data"][@"is_buy"] integerValue]
            ) {//购买了的
            
            //如果购买了就在这里进行缓存视频
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            [NSURLConnection connectionWithRequest:request delegate:self];
            
            
        }else {//没有购买
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(HHHHH) userInfo:nil repeats:YES];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        if (wmPlayer!=nil||wmPlayer.superview !=nil){
            [self releaseWMPlayer];
        }
        
        if (_imageView != nil) {
            [_imageView removeFromSuperview];
        }
        [_imageView removeFromSuperview];
        _imageView = nil;
        
        //创建播放器
        playerFrame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.width)*3/4);
        
        if (iPhone4SOriPhone4 || iPhone5o5Co5S) {
            playerFrame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.width)*3/5);
        }
        
        wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:@""];
        wmPlayer.closeBtn.hidden = YES;
        [self.view addSubview:wmPlayer];
        [wmPlayer.player play];
        
        //注册播放完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
        
        
    }];
}
//获取Cache目录
-(void)dirCache{
    
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cacPath objectAtIndex:0];
    NSLog(@"app_home_lib_cache: %@",cachePath);
}

-(void)getFreeTime
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [manager getFreeTime:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"-----%@",responseObject);
        NSString *timeStr = responseObject[@"data"];
        _timeNum = [timeStr integerValue];
        NSString *msg = [responseObject objectForKey:@"msg"];
        if (![msg isEqual:@"ok"]) {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)HHHHH {
    
    //监听播放时间
    CMTime cmTime = wmPlayer.player.currentTime;
    float videoDurationSeconds = CMTimeGetSeconds(cmTime);
    NSLog(@"----%f",videoDurationSeconds);
    
    if (videoDurationSeconds  > _timeNum) {
        [wmPlayer.player pause];
        wmPlayer.playOrPauseBtn.selected = YES;//这句代码是暂停播放后播放按钮显示为暂停状态
        //        self.timer = nil;
        
        if (_imageView == nil || _imageView.subviews == nil) {
            
            //判断当前的播放器是小屏还是全屏
            if (wmPlayer.isFullscreen == YES) {//全屏
                _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenHeight, MainScreenWidth)];
            } else {//小屏
                _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, CGRectGetHeight(wmPlayer.frame))];
            }
            
            _imageView.image = [UIImage imageNamed:@"试看结束@2x"];
            [wmPlayer addSubview:_imageView];
            
            
        } else {
            
            
        }
        
        
    }
    
}


- (void)onChangeImage:(NSNotification*)sender
{
    //    self.resultOKNumbers = sender.object;
    self.userDic = sender.userInfo;
    NSLog(@"****%@",sender.userInfo);
    
}
//代理方法
-(void)learningClick{
    _scrollView.contentOffset = CGPointMake(0, 0);
    //     [_btn setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
    _btn.selected = YES;
}


- (void)hehe:(NSNotification *) not {
    NSLog(@"+++++%@",not.userInfo);
    _userDic = not.userInfo;
    
}
-(void)buyClick{
    
    //判断是否登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        
        [wmPlayer.player pause];
        
    }else {//已经登录
        
        [self SYGBuy];
        
    }
    
    
}


- (void)SYGBuy {
    
    //网络请求下自己账户中得金额
    ZhiyiHTTPRequest *manager =[ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [manager reloadUserbalance:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"////%@",responseObject);
        _moneyDic = [[NSMutableDictionary alloc]initWithDictionary:[responseObject objectForKey:@"data"]];
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([msg isEqual:@"ok"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您已经购买过此课程" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            //添加剩余的钱
            
            UILabel *SYLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, MainScreenWidth / 2, 20)];
            NSString *SYQString = [NSString stringWithFormat:@"%@",_moneyDic[@"balance"]];
            SYLabel.text = [NSString stringWithFormat:@"目前剩余%@元",SYQString];
            
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:SYLabel.text];
            [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:59.f / 255 green:140.f / 255 blue:255.f / 255 alpha:1] range:NSMakeRange(4, SYQString.length)];
            [SYLabel setAttributedText:noteStr] ;
            SYLabel.font = [UIFont systemFontOfSize:12];
            SYLabel.textAlignment = NSTextAlignmentCenter;
            [_buyView addSubview:SYLabel];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:_allView];
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(MissBuyView) forControlEvents:UIControlEventTouchUpInside];
    
    [_allView addSubview:_allButton];
    

    //创建个VIew
    _buyView = [[UIView alloc] init];
    _buyView.center = self.view.center;
    _buyView.bounds = CGRectMake(0, 0,MainScreenWidth / 2, 260);
    _buyView.backgroundColor = [UIColor colorWithRed:254.f / 255 green:255.f / 255 blue:255.f / 255 alpha:1];
    _buyView.layer.cornerRadius = 5;
    [_allView addSubview:_buyView];
    //view上面添加空间
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10,MainScreenWidth / 2 , 30)];
    topLabel.text = @"购买提示";
    topLabel.font = [UIFont systemFontOfSize:14];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [_buyView addSubview:topLabel];
    
    UILabel *needMoney = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, MainScreenWidth / 2, 20)];
    needMoney.font = [UIFont systemFontOfSize:12];
    needMoney.textAlignment = NSTextAlignmentCenter;
    needMoney.text = [NSString stringWithFormat:@"您所购买的专辑需要消耗%@元",_userDic[@"mzprice"][@"price"]];
    NSString *needSring = needMoney.text;
    NSString *JGString = [NSString stringWithFormat:@"%@",_userDic[@"mzprice"][@"price"]];
    
    NSMutableAttributedString *needStr = [[NSMutableAttributedString alloc] initWithString:needSring];
    [needStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:59.f / 255 green:140.f / 255 blue:255.f / 255 alpha:1] range:NSMakeRange(11, JGString.length)];
    [needMoney setAttributedText:needStr] ;
    [_buyView addSubview:needMoney];
    
    //添加几个按钮
    NSArray *titleString = @[@"购买",@"充值",@"取消"];
    for (int i = 0 ; i < 3; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10 , 110 + 35 * i + 10 * i , MainScreenWidth / 2 - 20, 35)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:titleString[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:145.f / 255 green:148.f / 255 blue:155.f / 255 alpha:1] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:232.f / 255 green:235.f / 255 blue:243.f / 255 alpha:1];
        button.layer.cornerRadius = 5;
        button.tag = i;
        [button addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
        [_buyView addSubview:button];
    }
    
    
}

- (void)miss {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(MainScreenWidth, 64, 60, 70);
        _allView.alpha = 0;
        _allButton.alpha = 0;
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_buyView removeFromSuperview];
        isSecet = NO;
        
    });
    
    
}

- (void)MissBuyView {
    
    [_allView removeFromSuperview];
    [_allButton removeFromSuperview];
    [_buyView removeFromSuperview];
}


- (void)pressed:(UIButton *)button {
    if (button.tag == 2) {//取消支付
        [_buyView removeFromSuperview];
        [_allView removeFromSuperview];
        
    }
    if (button.tag == 0) {//支付
        //应该跳转到支付界面
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_buyView removeFromSuperview];
        
        if ([_moneyDic[@"balance"] floatValue] < [_userDic[@"mzprice"][@"price"] floatValue]) {//说明余额不足
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"余额不足" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
        } else {// 说明可以购买 在这里调用结算的接口
            
            ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
            
            [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
            [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
            NSLog(@"%@",_userDic);
            NSString *ID = [NSString stringWithFormat:@"%@",_userDic[@"id"]];
            [dic setObject:ID forKey:@"id"];
            
            [manager buyAlbum:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"^^%@",responseObject);
                NSString *msg = [responseObject objectForKey:@"msg"];
                if (![msg isEqual:@"ok"]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alert repeats:YES];
                    
                }else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"购买成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    [alert show];
                    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alert repeats:YES];
                    
                    
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
        
        
    }
    if (button.tag == 1) {//充值
        //应该跳转到充值界面
        RechanrgViewController *rechanrgVC = [[RechanrgViewController alloc] init];
        rechanrgVC.navigationController.navigationBarHidden =YES;
        //这里在跳转之前必须把加在控制器上面的View先移除掉
        [_buyView removeFromSuperview];
        [_allView removeFromSuperview];
        //        _popWindow.alpha = 0;
        //        [_popWindow resignKeyWindow];
        
        [self.navigationController pushViewController:rechanrgVC animated:YES];
        
    }
}

-(void)addShopingCar
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:@"420591e976ca09540022e8c51d16ca73" forKey:@"oauth_token"];
    [dic setObject:@"99928518802affe98359b9646cdaca3b" forKey:@"oauth_token_secret"];
    [dic setObject:_cid forKey:@"vids"];
    [manager addToShopingCar:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        if (![msg isEqual:@"ok"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"加入购物车成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        //将windows移除
        [_buyView removeFromSuperview];
        [_popWindow removeFromSuperview];
        _popWindow.alpha = 0;
        [_popWindow resignKeyWindow];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)settleUserDate
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:@"420591e976ca09540022e8c51d16ca73" forKey:@"oauth_token"];
    [dic setObject:@"99928518802affe98359b9646cdaca3b" forKey:@"oauth_token_secret"];
    [dic setObject:_cid forKey:@"vids"];
    [manager settleUserShopingCar:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        if (![msg isEqual:@"ok"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
//请求数据
-(void)requestData2
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    //HUD.labelText = @"加载中...";
    //设置模式为进度框形的
    HUD.mode = MBProgressHUDModeDeterminate;
    [HUD showAnimated:YES whileExecutingBlock:^{
        float progress = 0.0f;
        while (progress < 1.0f) {
            progress += 0.01f;
            HUD.progress = progress;
            usleep(5000); //睡眠50000微秒＝50毫秒，一共循环100次睡眠时间为5秒
        }
    } completionBlock:^{
        [HUD removeFromSuperview];
        HUD = nil;
    }];
    
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_cid forKey:@"id"];
    //    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    //    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [manager albumDetail:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _dict=[responseObject objectForKey:@"data"];
        
        _imageArray = [[NSMutableArray alloc]initWithObjects:_dict[@"big_ids"],_dict[@"small_ids"],_dict[@"teaching_ids"], nil];
        for (int i=0; i<_imageArray.count; i++) {
            
            img = [[UIImageView alloc]initWithFrame:CGRectMake(_imageScrollView.frame.size.width*i, 0, _imageScrollView.frame.size.width, _imageScrollView.frame.size.height)];
            [img sd_setImageWithURL:[NSURL URLWithString:[_imageArray objectAtIndex:i]]];
            [_imageScrollView addSubview:img];
        }
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, _imageScrollView.frame.size.height+34, _imageScrollView.frame.size.width, 30)];
        _pageControl.backgroundColor = [UIColor blackColor];
        _pageControl.alpha = 0.5;
        _pageControl.numberOfPages = _imageArray.count;
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:14/255.0 green:116/255.0 blue:174/255.0 alpha:1];
        [bgScrollView addSubview:_pageControl];
        [self requestData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)addTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void)changeImage
{
    ++_pageControl.currentPage;
    CGFloat pageWidth = CGRectGetWidth(_imageScrollView.frame);
    if (isFromStart)
    {
        [_imageScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        _pageControl.currentPage = 0;
    }
    else
    {
        [_imageScrollView setContentOffset:CGPointMake(pageWidth*_pageControl.currentPage, _imageScrollView.bounds.origin.y)];
    }
    if (_pageControl.currentPage == _pageControl.numberOfPages - 1)
    {
        isFromStart = YES;
    }
    else
    {
        isFromStart = NO;
    }
}

-(void)backBtn
{
    //这里应该停止播放
    [wmPlayer.player pause];
    //停止timer
    [self.timer invalidate];
    [self releaseWMPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除通知（不然播放下一个视频的时候这个视频还会播放）
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
//收藏
-(void)likeBtn
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        //弹出试图 提醒没有登录并引导登录
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
    }else {//已经登录
        
        [self SYGLike];
        
    }
}

#define down ===============  x下载-==============
-(void)calssifyClick:(UIButton *)sender{

    if ([[GLNetWorking isConnectionAvailable] isEqualToString:@"3G"]) {
        //设置开关为YES状态
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *passWord = [user objectForKey:@"netRook"];
        // ZFDownloadManager *filedownmanage = [ZFDownloadManager sharedDownloadManager];
        
        if (![passWord isEqualToString:@"1"]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您正在使用2G/3G/4G,如果继续运营商可能会收取流量费用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [alert show];
                
            });
        }
    }
 }

-(void)downLoadVideo{

    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_classID forKey:@"id"];
    [manager getClassDetail:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"=========================================%@",responseObject);
        
        _videoAddress = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"video_address"]];
        
        NSString *imgUrl = responseObject[@"data"][@"cover"];
        NSURL *imagegurl = [NSURL URLWithString:imgUrl];
        NSData *data = [NSData dataWithContentsOfURL:imagegurl];
        UIImage *image = [[UIImage alloc] initWithData:data];
        
        NSURL *url = [NSURL URLWithString:_videoAddress];
        
        //此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
        NSString *name = [[NSURL URLWithString:_videoAddress] lastPathComponent];
        NSLog(@"======%@---%@",name,_videoAddress);
        if (!_videoAddress.length) {
            return ;
        }
        [[ZFDownloadManager sharedDownloadManager] downFileUrl:_videoAddress filename:name fileimage:image];
        // 设置最多同时下载个数（默认是3）
        [ZFDownloadManager sharedDownloadManager].maxCount = 1;
        
        
        NSLog(@"=========000============%@",url);
        //在这里判断本地是否有视频
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}
//根据被点击按钮的索引处理点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"clickedButtonAtIndex:%d",buttonIndex);
    if (buttonIndex) {
        [self downLoadVideo];
    }else
        return;
}
- (void)SYGLike {
    
    if ([_collectStr intValue]==1) {
        QKHTTPManager * manager = [QKHTTPManager manager];
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:@"1" forKey:@"sctype"];
        [dic setValue:@"0" forKey:@"type"];
        [dic setValue:_cid forKey:@"source_id"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
        NSLog(@"%@",dic);
        [manager collect:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"^^^^%@",responseObject);
            NSLog(@"%@",responseObject[@"msg"]);
            NSString *Msg = responseObject[@"msg"];
            
            if ([Msg isEqualToString:@"ok"] ) {//成功
                //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"取消收藏成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                //                [alert show];
                //                [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alert repeats:YES];
                
                UIButton *SYGLikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
                SYGLikeButton.frame = CGRectMake(0, 0, 20, 20);
                [SYGLikeButton setBackgroundImage:[UIImage imageNamed:@"空心五角星@2x"] forState:UIControlStateNormal];
                [SYGLikeButton addTarget:self action:@selector(likeBtn) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *likeButton = [[UIBarButtonItem alloc] initWithCustomView:SYGLikeButton];
                
                UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"石远刚更多@2x"]  style:UIBarButtonItemStylePlain target:self action:@selector(handleButtonEvent)];
                
                self.navigationItem.rightBarButtonItem = shareItem;
                shareItem.tag = 100;
                self.navigationItem.rightBarButtonItems = @[shareItem,likeButton];
                
                
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:Msg delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alert repeats:YES];
                
            }
            
            
            
            [self requestData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    else
    {
        QKHTTPManager * manager1 =[QKHTTPManager manager];
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:@"1" forKey:@"sctype"];
        [dic setValue:@"1" forKey:@"type"];
        [dic setValue:_cid forKey:@"source_id"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
        NSLog(@"%@",dic);
        
        [manager1 collect:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            NSLog(@"++++%@",responseObject[@"msg"]);
            NSString *Msg = responseObject[@"msg"];
            if ([Msg isEqualToString:@"ok"]) {//收藏成功
                
                //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"收藏成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                //                [alert show];
                //                [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alert repeats:YES];
                
                UIButton *SYGLikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
                SYGLikeButton.frame = CGRectMake(0, 0, 20, 20);
                [SYGLikeButton setBackgroundImage:[UIImage imageNamed:@"实心五角星@2x"] forState:UIControlStateNormal];
                [SYGLikeButton addTarget:self action:@selector(likeBtn) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *likeButton = [[UIBarButtonItem alloc] initWithCustomView:SYGLikeButton];
                
                UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"石远刚更多@2x"]  style:UIBarButtonItemStylePlain target:self action:@selector(handleButtonEvent)];
                
                self.navigationItem.rightBarButtonItem = shareItem;
                shareItem.tag = 100;
                self.navigationItem.rightBarButtonItems = @[shareItem,likeButton];
                
                
                
            }else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:Msg delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alert repeats:YES];
                
            }
            
            [self requestData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    
    
}


- (void)handleButtonEvent {//更多界面
    
    isSecet = !isSecet;
    
    if (isSecet == YES) {//创建
        
        [self addMoreView];
    }else {//移除
        [self removeMoreView];
    }
    
    
    
}

- (void)addMoreView {
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:_allView];
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
    
    [_allView addSubview:_allButton];
    
    
    
    _buyView = [[UIView alloc] init];
    _buyView.frame = CGRectMake(MainScreenWidth,64 ,100, 85);
    _buyView.backgroundColor = [UIColor colorWithRed:254.f / 255 green:255.f / 255 blue:255.f / 255 alpha:1];
    _buyView.layer.cornerRadius = 3;
    [_allView addSubview:_buyView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(MainScreenWidth - 100 ,64 ,100, 85);
        //在view上面添加东西
        NSArray *GDArray = @[@"课程笔记",@"课程分享@2x"];
        for (int i = 0 ; i < 2 ; i ++) {
            UIButton *button = [[UIButton alloc ] initWithFrame:CGRectMake(0, i * 40 + i * 5, 100, 40)];
            [button setBackgroundImage:[UIImage imageNamed:GDArray[i]] forState:UIControlStateNormal];
            button.layer.cornerRadius = 5;
            button.tag = 520 + i;
            [button addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [_buyView addSubview:button];
            
        }
        
    }];
    
    
}

- (void)removeMoreView {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(MainScreenWidth, 64, 100, 85);
        _allView.alpha = 0;
        _allButton.alpha = 0;
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_buyView removeFromSuperview];
        
    });
    
    
    
    
}

- (void)SYGButton:(UIButton *)button {
    
    NSLog(@"%@",button.titleLabel.text);
    
    [_allView removeFromSuperview];
    [_allButton removeFromSuperview];
    [_buyView removeFromSuperview];
    
    if (button.tag == 520) {//笔记
        NSLog(@"SYG");
        
        //这里应该停止播放
        [wmPlayer.player pause];
        //吧视频播放按钮显示为暂停状态
        wmPlayer.playOrPauseBtn.selected = YES;
        
        blumNoteVC *HH = [[blumNoteVC alloc] initWithId:_cid];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:HH];
        [self presentViewController:Nav animated:YES completion:nil];
        isSecet = NO;
        
        
    } else if (button.tag == 521){//分享
        
        //这里应该停止播放
        [wmPlayer.player pause];
        //吧视频播放按钮显示为暂停状态
        wmPlayer.playOrPauseBtn.selected = YES;
        
        isSecet = NO;
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"574e8829e0f55a12f8001790"
                                          shareText:[NSString stringWithFormat:@"我正在出右云课堂app观看—%@视频地址%@",_videoTitle,_addressStr]
                                         shareImage:[UIImage imageNamed:@"chuyou.png"]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToRenren,nil]
                                           delegate:self];
    }
}
//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}


- (void)requestData
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_cid forKey:@"id"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        
    } else {
        
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [manager albumDetail:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _SYGDic = responseObject;
        _collectStr = [responseObject objectForKey:@"data"][@"iscollect"];
        
        if ([_collectStr intValue]==1) {
            
            UIButton *SYGLikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            SYGLikeButton.frame = CGRectMake(0, 0, 20, 20);
            [SYGLikeButton setBackgroundImage:[UIImage imageNamed:@"实心五角星@2x"] forState:UIControlStateNormal];
            [SYGLikeButton addTarget:self action:@selector(likeBtn) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *likeButton = [[UIBarButtonItem alloc] initWithCustomView:SYGLikeButton];
            UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"石远刚更多@2x"]  style:UIBarButtonItemStylePlain target:self action:@selector(handleButtonEvent)];
            self.navigationItem.rightBarButtonItem = shareItem;
            shareItem.tag = 100;
            self.navigationItem.rightBarButtonItems = @[shareItem,likeButton];
            
        }
        else
        {
            
            UIButton *SYGLikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            SYGLikeButton.frame = CGRectMake(0, 0, 20, 20);
            [SYGLikeButton setBackgroundImage:[UIImage imageNamed:@"空心五角星@2x"] forState:UIControlStateNormal];
            [SYGLikeButton addTarget:self action:@selector(likeBtn) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *likeButton = [[UIBarButtonItem alloc] initWithCustomView:SYGLikeButton];
            
            UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"石远刚更多@2x"]  style:UIBarButtonItemStylePlain target:self action:@selector(handleButtonEvent)];
            self.navigationItem.rightBarButtonItem = shareItem;
            shareItem.tag = 100;
            self.navigationItem.rightBarButtonItems = @[shareItem,likeButton];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


-(void)btnClick:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    switch (btn.tag) {
        case 10080:
            _scrollView.contentOffset = CGPointMake(0, 0);
            if (iPhone4SOriPhone4||iPhone5o5Co5S) {
                _arrowImageView.frame = CGRectMake(btn.frame.origin.x, 35, 50, 5);
            }
            else if(iPhone6)
            {
                _arrowImageView.frame = CGRectMake(btn.frame.origin.x, 35, 50, 5);
            }
            else if (iPhone6Plus)
            {
                _arrowImageView.frame = CGRectMake(btn.frame.origin.x, 35, 50, 5);
            } else {
                 _arrowImageView.frame = CGRectMake(btn.frame.origin.x, 35, 50, 5);
            }
            
            break;
        case 10081:
            _scrollView.contentOffset = CGPointMake(MainScreenWidth, 0);
            if (iPhone4SOriPhone4||iPhone5o5Co5S) {
                _arrowImageView.frame = CGRectMake(btn.frame.origin.x, 35, 50, 5);
            }
            else if(iPhone6)
            {
                _arrowImageView.frame=CGRectMake(btn.frame.origin.x, 35, 50, 5);
            }
            else if(iPhone6Plus)
            {
                _arrowImageView.frame = CGRectMake(btn.frame.origin.x, 35, 50, 5);
            }else {
                 _arrowImageView.frame = CGRectMake(btn.frame.origin.x, 35, 50, 5);
            }
            
            break;
        case 10082:
            _scrollView.contentOffset = CGPointMake(MainScreenWidth*2, 0);
            if (iPhone4SOriPhone4||iPhone5o5Co5S) {
                _arrowImageView.frame = CGRectMake(btn.frame.origin.x, 35, 50, 5);
            }
            else if(iPhone6)
            {
                _arrowImageView.frame = CGRectMake(btn.frame.origin.x, 35, 50, 5);
            }
            else if (iPhone6Plus)
            {
                _arrowImageView.frame = CGRectMake(btn.frame.origin.x, 35, 50, 5);
            }else {
                 _arrowImageView.frame = CGRectMake(btn.frame.origin.x, 35, 50, 5);
            }
            
            break;
            
        default:
            break;
    }
    
    int p =_arrowImageView.frame.origin.x;
    if (iPhone4SOriPhone4||iPhone5o5Co5S) {
        switch (p) {
            case 32:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
            case 130:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
                break;
            case 220:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }
        
    }
    if (iPhone6)
    {
        switch (p) {
            case 45:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
            case 155:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
                break;
            case 260:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }
        
    }
    else if (iPhone6Plus)
    {
        switch (p) {
            case 58:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
            case 173:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
                break;
            case 290:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }
        
    } else {//ipad适配
        
        
        switch (p) {
            case 145:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
            case 350:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
                break;
            case 560:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }

    }
    
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==_imageScrollView) {
        CGPoint currentSize = scrollView.contentOffset;
        _pageControl.currentPage = currentSize.x/MainScreenWidth;
    }
    if (scrollView==_scrollView) {
        CGPoint point = scrollView.contentOffset;
        if (point.x==0) {
            _scrollView.contentOffset = CGPointMake(0, 0);
            if (iPhone4SOriPhone4||iPhone5o5Co5S) {
                _arrowImageView.frame = CGRectMake(32, 35, 50, 5);
            }
            else if(iPhone6)
            {
                _arrowImageView.frame = CGRectMake(45, 35, 50, 5);
            }
            else if (iPhone6Plus)
            {
                _arrowImageView.frame = CGRectMake(58, 35, 50, 5);
                
            }else {
                 _arrowImageView.frame = CGRectMake(58, 35, 50, 5);
            }
            
        }
        else if(point.x==MainScreenWidth)
        {
            _scrollView.contentOffset = CGPointMake(MainScreenWidth, 0);
            if (iPhone4SOriPhone4||iPhone5o5Co5S) {
                _arrowImageView.frame = CGRectMake(130, 35, 50, 5);
            }
            else if(iPhone6)
            {
                _arrowImageView.frame = CGRectMake(155, 35, 50, 5);
            }
            else if(iPhone6Plus)
            {
                _arrowImageView.frame = CGRectMake(173, 35, 50, 5);
                
            } else {
                
                _arrowImageView.frame = CGRectMake(173, 35, 50, 5);
            }
            
        }
        else if(point.x==MainScreenWidth*2)
        {
            _scrollView.contentOffset = CGPointMake(MainScreenWidth*2, 0);
            if (iPhone4SOriPhone4||iPhone5o5Co5S) {
                _arrowImageView.frame = CGRectMake(220, 35, 50, 5);
            }
            else if(iPhone6)
            {
                _arrowImageView.frame = CGRectMake(260, 35, 50, 5);
            }
            else if(iPhone6Plus)
            {
                _arrowImageView.frame = CGRectMake(290, 35, 50, 5);
                
            } else {
                 _arrowImageView.frame = CGRectMake(290, 35, 50, 5);
            }
            
        }
        
    }
    int p=_arrowImageView.frame.origin.x;
    if (iPhone4SOriPhone4||iPhone5o5Co5S) {
        switch (p) {
            case 32:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
                break;
            case 130:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
                break;
            case 220:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
                
            }
                break;
            default:
                break;
        }
        
    }
    else if(iPhone6)
    {
        switch (p) {
            case 45:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
                break;
            case 155:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
                break;
            case 260:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }
        
    }
    
    else if(iPhone6Plus)
    {
        switch (p) {
            case 58:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
                break;
            case 173:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
                break;
            case 290:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
                
            }
                break;
            default:
                break;
        }
        
    } else {//ipad适配
        
        switch (p) {
            case 58:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
                break;
            case 173:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
                break;
            case 290:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
                
            }
                break;
            default:
                break;
        }

        
    }
}

//创建btn用于 创建导航按钮时用
-(UIButton *)button:(NSString *)title image:(NSString *)image frame:(CGRect)frame
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    //设置字体大小
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setBackgroundImage:[Helper imageNamed:image cache:YES] forState:UIControlStateNormal];
    return button;
}
//创建导航条上的按钮
-(void)addItem:(NSString *)title position:(itemb)position image:(NSString *)image action:(SEL)action
{
    UIButton * button = [self button:title image:image frame:CGRectMake(0, 0, 44, 22)];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:button];
    if (position==Left_Itembb) {
        self.navigationItem.leftBarButtonItem = item;
    }else{
        self.navigationItem.rightBarButtonItem = item;
    }
}

//创建右侧按钮
-(void)additems:(NSString *)title position:(itemb)position image:(NSString *)image action:(SEL)action
{
    UIButton * button = [self button:title image:image frame:CGRectMake(0, 2, 20, 17)];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:button];
    if (position==Right_Itembb) {
        self.navigationItem.rightBarButtonItem = item;
    }else{
        self.navigationItem.leftBarButtonItem = item;
    }
    
}


//下载文件的代理方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    //文件路劲
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filepath = [caches stringByAppendingPathComponent:@"videos.zip"];
    
    //创建一个空的文件 到 沙盒中
    NSFileManager *mgr = [NSFileManager defaultManager];
    [mgr createFileAtPath:filepath contents:nil attributes:nil];
    
    //创建一个用来写数据的文件句柄
    self.writeHandle = [NSFileHandle fileHandleForWritingAtPath:filepath];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    //移动到文件最后面
    
    [self.writeHandle seekToEndOfFile];
    
    //将数据写入沙盒中
    
    [self.writeHandle writeData:data];
    
    
}

//数据接收完，关闭句柄对象
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //关闭文件
    [self.writeHandle closeFile];
    self.writeHandle = nil;
    
}

- (void)longClick:(UILongPressGestureRecognizer *)sender {

    CGPoint point = [sender locationInView:self.view];
    
    _buyButton.center = CGPointMake(point.x, point.y);
    
    
}


@end
