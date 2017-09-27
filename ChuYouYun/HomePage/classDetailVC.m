
//
//  classDetailVC.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/28.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "classDetailVC.h"
#import "AppDelegate.h"
#import "BigWindCar.h"


#import "rootViewController.h"
#import "Helper.h"
#import "classDetailMessageVC.h"
#import "noteVC.h"
#import "questionVC.h"
#import "commentVC.h"
#import "videoPlayVC.h"
#import "MyHttpRequest.h"
#import "teacherList.h"
#import "ZhiyiHTTPRequest.h"
#import "videoPlayVC.h"
#import "MakeNoteVC.h"
#import "MakeQuestions.h"
#import "SYGNoteViewController.h"
#import "DLViewController.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"

#import "WMPlayer.h"

//支付
#import "AlipayViewController.h"
#import "ClassPayViewController.h"

#import "ClassCharaViewController.h"
#import "ZFDownloadManager.h"
#import "GLNetWorking.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD+Add.h"



@import MediaPlayer;
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4,4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕


#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕

#define iPhone6PlusBIG ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus放大版屏幕
#define SPACE (self.view.frame.size.width-35*4)/4 //间隙
#import "UIImageView+WebCache.h"
#import "SYG.h"
#import "ASIHTTPRequest.h"

@interface classDetailVC ()<UIScrollViewDelegate,UIWebViewDelegate,UMSocialUIDelegate,UIGestureRecognizerDelegate,AVAudioPlayerDelegate>
{
    UIScrollView * _scrollView;
    UIImageView * _arrowImageView;
    UIImageView * imageView;
    UIView * bgView;
    CGRect rect;
    NSDictionary *dict;
    BOOL isSecet;
    UIWebView * _webView;
    UIButton *_buyButton;
    WMPlayer *wmPlayer;
    CGRect playerFrame;
    BOOL isShouleVedio;//是否应该缓存视频
    //判断是否购买
    NSString *_buyMessage;
    BOOL isArgree;//同意支付协议
    
    BOOL isWebViewBig;//webView 是否放大
    BOOL isTextViewBig;
    
}

@property (strong ,nonatomic)UIView *allView;
@property (strong ,nonatomic)UIButton *allButton;
@property (strong ,nonatomic)UIView *buyView;
@property (strong ,nonatomic)NSString *playStr;
@property (strong ,nonatomic)UIButton *DJbutton;

@property (strong ,nonatomic)MPMoviePlayerController *player;
@property (strong ,nonatomic)NSTimer *timer;
@property (strong ,nonatomic)UIImageView *imageView;
@property (assign, nonatomic)NSInteger timeNum;
@property (strong ,nonatomic)UIView *downView;
@property (strong ,nonatomic)NSString *downTitleStr;

@property (strong ,nonatomic)UIView *allCounpView;
@property (strong ,nonatomic)UIButton *allCounpButton;
@property (strong ,nonatomic)UIView *counpView;
@property (strong ,nonatomic)UILabel *counpLabel;
@property (strong ,nonatomic)NSArray *counpArray;
@property (strong ,nonatomic)NSString *counpID;

@property (strong ,nonatomic)NSString *alipayStr;
@property (strong ,nonatomic)NSString *wxpayStr;

@property (strong ,nonatomic)NSMutableArray *addressArray;//存放视频地址的数组
@property (strong ,nonatomic)UIImageView *videoImageView;
@property (strong ,nonatomic)UIButton *videoPlayButton;


@property (strong ,nonatomic)UIAlertView *playAlertView;
@property (strong ,nonatomic)UIAlertView *downAlertView;

@property (strong ,nonatomic)NSDictionary *videoDict;
@property (strong ,nonatomic)NSString     *shareVideoUrl;


@property (strong ,nonatomic)UIWebView *webView;
@property (strong ,nonatomic)UITextView *textView;
@property (strong ,nonatomic)AVAudioPlayer *musicPlayer;

@property (strong ,nonatomic)NSDictionary *notifitonDic;//通知传过来的字典

@property (assign ,nonatomic)BOOL isNoWifiPlay;//是否在非wifi 下允许播放
@property (assign ,nonatomic)NSInteger isPlayNumber;//提醒的次数

@end

@implementation classDetailVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //视频播放结束通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    }
    return self;
}


- (void)videoFinished{
    if (videoRequest) {
        //        isPlay = !isPlay;
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
    if ([fileManager fileExistsAtPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"vedio_%@.mp4",_cid]]]) {
        
        NSString *HHH = [NSString stringWithFormat:@"vedio_%@.mp4",_cid];
        NSString *movePath =  [cachePath stringByAppendingPathComponent:HHH];
        
        NSLog(@"%@",cachePath);
        NSLog(@"%@",movePath);
        
        if (wmPlayer!=nil||wmPlayer.superview !=nil){
            [self releaseWMPlayer];
        }
        [_imageView removeFromSuperview];
        _imageView = nil;
        
        playerFrame = CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 390);
        
        wmPlayer = [[WMPlayer alloc] initWithFrame:playerFrame videoURLStr:movePath];
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
    
    //    playerFrame = CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 390);
    //    wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:urlStr];
    //    wmPlayer.closeBtn.hidden = YES;
    //    [self.view addSubview:wmPlayer];
    //    [wmPlayer.player play];
    
    //注册播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
    
    //下载完存储目录
    [request setDownloadDestinationPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"vedio_%@.mp4",_cid]]];
    //临时存储目录
    [request setTemporaryFileDownloadPath:[webPath stringByAppendingPathComponent:[NSString stringWithFormat:@"vedio_%@.mp4",_cid]]];
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



-(id)initWithMemberId:(NSString *)MemberId andPrice:(NSString *)price andTitle:(NSString *)title
{
    if (self=[super init]) {
        _cid = MemberId;
        _course_title = title;
        _price = price;
    }
    return self;
}

// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

// 支持横竖屏显示
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)checkVedio {
    NSLog(@"%@",_cid);
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
    NSLog(@"--%@",cachePath);
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:cachePath])
    {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if ([fileManager fileExistsAtPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"vedio_%@.mp4",_cid]]]) {
        [self getVideo];
        return;
    }
    
    [self addPlayer];
    
}



-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = NO;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    //是否应该缓存视频
    isShouleVedio = YES;
    
    [self requestData];
    [super viewWillAppear:animated];
    
    [self getFreeTime];
    
//    //收藏过来或者观看记录过来
//    if (![_isLoad isEqualToString:@"123"]) {
//            [self checkVedio];
//    }
    
//     [self checkVedio];
    
    //观看记录是的网络请求
    if (_video_address == nil) {
        [self getVideoUrl];
    }

    
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
    //隐藏
    self.navigationController.navigationBarHidden = YES;
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)getVideoUrl {
    QKHTTPManager * mananger = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_cid forKey:@"id"];
    [mananger getClassDetail:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"课程详情------%@",responseObject);
//        _dict = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"data"]];
//        NSLog(@"66----%@",_dict);
        _video_address = responseObject[@"data"][@"video_address"];
        NSLog(@"Url---%@",_video_address);
        [self addPlayer];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        
    }];

    
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
        wmPlayer.playerLayer.frame =  wmPlayer.bounds;
        
        //设置提醒试图的大小
        _imageView.frame = CGRectMake(0, 0, playerFrame.size.width, playerFrame.size.height);
        
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



- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(40, 25, MainScreenWidth - 80, 30)];
    WZLabel.text = _course_title;
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
}

-(void)goBuy{
    

    if ([_buyMessage integerValue] != 0) {//已经购买
        return;
    }
    
    // 这里应该判断是否已经登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
   
    }else {
        [self buyClass];
    }
}


//购买课程
- (void)buyClass {
    
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:_cid forKey:@"vids"];
    
    [manager settleUserShopingCar:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = [responseObject objectForKey:@"msg"];
        if (![msg isEqual:@"ok"]) {
            [MBProgressHUD showError:msg toView:self.view];
        } else {
            [MBProgressHUD showSuccess:@"购买成功" toView:self.view];
            [_buyButton setTitle:@"已经购买" forState:UIControlStateNormal];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //初始化数组
    _addressArray = [NSMutableArray array];
    
    isSecet = NO;
    _isPlayNumber = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    

    rect = [UIScreen mainScreen].applicationFrame;
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height + 100)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = CGSizeMake(rect.size.width, rect.size.height - 30);
    [self.view addSubview:scrollView];

    [self addNav];
    
    //添加箭头等
    if (iPhone4SOriPhone4) {
        
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, MainScreenHeight-290, MainScreenWidth, 40)];
        [scrollView addSubview:bgView];
        
        UIImageView * imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height)];
        imageView2.image = [UIImage imageNamed:@"options.png"];
        [bgView addSubview:imageView2];
        
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 35, 50, 5)];
        _arrowImageView.image = [UIImage imageNamed:@"尖角.png"];


        
    }else if (iPhone5o5Co5S) {
        
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, MainScreenHeight-370+54, MainScreenWidth, 40)];
        [scrollView addSubview:bgView];
        
        UIImageView * imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height)];
        imageView2.image = [UIImage imageNamed:@"options.png"];
        [bgView addSubview:imageView2];
        
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 35, 50, 5)];
        _arrowImageView.image = [UIImage imageNamed:@"尖角.png"];
        [bgView addSubview:_arrowImageView];

    }
    else if(iPhone6)
    {
        
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, MainScreenHeight-390 + 64, MainScreenWidth, 40)];
        [self.view addSubview:bgView];
        
        UIImageView * imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height)];
        imageView2.image = [UIImage imageNamed:@"options.png"];
        [bgView addSubview:imageView2];

        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 35, 50, 5)];
        _arrowImageView.image = [UIImage imageNamed:@"尖角.png"];
        [bgView addSubview:_arrowImageView];
        
        
    }
    else if(iPhone6Plus)
    {
       
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, MainScreenHeight-410+64, MainScreenWidth, 40)];
        [scrollView addSubview:bgView];
        
        UIImageView * imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height)];
        imageView2.image = [UIImage imageNamed:@"options.png"];
        [bgView addSubview:imageView2];
        
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(45, 35, 50, 5)];
        _arrowImageView.image = [UIImage imageNamed:@"尖角.png"];
        [bgView addSubview:_arrowImageView];


    } else {//ipad 适配
        
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, MainScreenHeight-410+64 + 20, MainScreenWidth, 40)];
        [scrollView addSubview:bgView];
        
        UIImageView * imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height)];
        imageView2.image = [UIImage imageNamed:@"options.png"];
        [bgView addSubview:imageView2];
        
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(210, 35, 50, 5)];
        _arrowImageView.image = [UIImage imageNamed:@"尖角.png"];
        [bgView addSubview:_arrowImageView];
        
    }
    for (int i = 0; i < 3; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.frame = CGRectMake(MainScreenWidth / 3 * i , 2, MainScreenWidth / 3, 36);
        btn.tag = 10080+i;
        btn.selected = NO;
        if (i == 0) {
            [btn setTitle:@"详情" forState:UIControlStateNormal];
            [btn setTitleColor:BasidColor forState:UIControlStateNormal];
        }

        else if(i == 2)
        {
            [btn setTitle:@"点评" forState:UIControlStateNormal];
        }
        
        else if (i == 1) {
            [btn setTitle:@"目录" forState:UIControlStateNormal];

        }
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
    }
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, bgView.frame.size.height+bgView.frame.origin.y, MainScreenWidth,MainScreenHeight-(bgView.frame.size.height+bgView.frame.origin.y))];
        _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView.contentSize = CGSizeMake(MainScreenWidth * 3, 0);
    [scrollView addSubview:_scrollView];
    
    
    ClassCharaViewController *classCharaVc = [[ClassCharaViewController alloc] initWithId:_cid andTitle:_course_title];
    classCharaVc.view.frame = CGRectMake(MainScreenWidth, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [self addChildViewController:classCharaVc];
    [_scrollView addSubview:classCharaVc.view];
    
    
    classDetailMessageVC * cvc = [[classDetailMessageVC alloc]initWithId:_cid andStudyB:_price andTitle:_course_title];
    cvc.view.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height );
    [self addChildViewController:cvc];
    [_scrollView addSubview:cvc.view];

    commentVC * cCVC= [[commentVC alloc]initWithId:_cid];
    cCVC.view.frame =CGRectMake(MainScreenWidth * 2, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [self addChildViewController:cCVC];
    [_scrollView addSubview:cCVC.view];
    
    //添加通知
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetClassAddress:) name:@"NotificationClassAddress" object:nil];
    
    [self addDownView];
    [self addPlayer];
    
}


- (void)GetClassAddress:(NSNotification *)Not {
    NSLog(@"%@",Not.userInfo);
    _videoDict = Not.userInfo;
    _video_address = Not.userInfo[@"video_address"];
    _shareVideoUrl = Not.userInfo[@"video_address"];
//    [_addressArray addObject:Not.userInfo[@"video_address"]];
    _downTitleStr = Not.userInfo[@"title"];
//    [self.timer invalidate];
//    self.timer = nil;
    [self.timer setFireDate:[NSDate distantFuture]];
    
    [self.timer setFireDate:[NSDate distantPast]];
    
    NSLog(@"-----%@",_video_address);
    NSLog(@"%@",_videoDict);
    
//    NSLog(@"%@",dict);
//    if ([_videoDict[@"is_free"] integerValue] == 1 || [_dict[@"is_play_all"] integerValue] != 0) {//购买了的
//        [_timer invalidate];
//        self.timer = nil;
//    }else {//没有购买
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(HHHHH) userInfo:nil repeats:YES];
//    }
//
//    
//    [self addPlayer];
    
    _notifitonDic = (NSDictionary *)Not.userInfo;
    NSLog(@"通知：----%@",_notifitonDic);
    _video_address = _notifitonDic[@"video_address"];
    NSLog(@"----%@",_video_address);
    
    //将之前的移除
    if (wmPlayer!=nil||wmPlayer.superview !=nil){
        [self releaseWMPlayer];
        [wmPlayer removeFromSuperview];
        
    }
    [_textView removeFromSuperview];
    [_webView removeFromSuperview];
    
    if ([_notifitonDic stringValueForKey:@"type"] == nil) {
        [MBProgressHUD showError:@"暂时不支持" toView:self.view];
        return;
    }
    
    if ([_notifitonDic[@"type"] integerValue] == 1) {//视频
        _video_address = _notifitonDic[@"video_address"];
        if ([_notifitonDic[@"is_free"] integerValue] == 1 || [_dict[@"is_play_all"] integerValue] != 0) {//购买了的
            [_timer invalidate];
            self.timer = nil;
        }else {//没有购买
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(HHHHH) userInfo:nil repeats:YES];
        }
        [self addPlayer];
    } else if ([_notifitonDic[@"type"] integerValue] == 2) {//音频
        _video_address = _notifitonDic[@"video_address"];
        if ([_notifitonDic[@"is_free"] integerValue] == 1 || [_dict[@"is_play_all"] integerValue] != 0) {//购买了的
        }else {//没有购买
            [MBProgressHUD showError:@"购买才能听此音频" toView:self.view];
            return;
        }
        
        [self addPlayer];
    } else if ([_notifitonDic[@"type"] integerValue] == 3) {//文本
        _video_address = _notifitonDic[@"video_address"];
        if ([_notifitonDic[@"is_free"] integerValue] == 1 || [_dict[@"is_play_all"] integerValue] != 0) {//购买了的
        }else {//没有购买
            [MBProgressHUD showError:@"购买才能看此文本" toView:self.view];
            return;
        }
        [self addTextView];
    } else if ([_notifitonDic[@"type"] integerValue] == 4) {//文档
        _video_address = _notifitonDic[@"video_address"];
        if ([_notifitonDic[@"is_free"] integerValue] == 1 || [_dict[@"is_play_all"] integerValue] != 0) {//购买了的
        }else {//没有购买
            [MBProgressHUD showError:@"购买才能看此文档" toView:self.view];
            return;
        }
        [self addWebView];
    }

    
}



- (void)addDownView {
    
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 50, MainScreenWidth, 50)];
    _downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downView];
    
    CGFloat ButtonW = MainScreenWidth / 4;
    CGFloat ButtonH = 50;
    NSArray *photoArray = @[@"likee@3x",@"share@2x",@"download@2x",@""];
    NSArray *titleArray = @[@"收藏",@"分享",@"下载",@""];
    for (int i = 0 ; i < 4 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW * i, 0, ButtonW, ButtonH)];

        
        if (i == 3) {
//            button.frame = CGRectMake(ButtonW * i, 10, ButtonW - 20, ButtonH - 20);
            [button setTitle:@"购买课程" forState:UIControlStateNormal];
            button.backgroundColor = BasidColor;
            button.titleLabel.font = Font(15);
            
        } else {
            [button setImage:Image(photoArray[i]) forState:UIControlStateNormal];
//            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            
//            button.imageEdgeInsets =  UIEdgeInsetsMake(5,0,4,0);
//            button.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 20);
        }

        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         button.tag = i * 100;
        
        if (i == 0) {
            _collectButton = button;
        } else if (i == 3) {
            _buyButton = button;
        }
        
        [button addTarget:self action:@selector(downViewButton:) forControlEvents:UIControlEventTouchUpInside];
        [_downView addSubview:button];
        
        
    }
    
}

- (void)downViewButton:(UIButton *)button {
    
    switch (button.tag) {
            case 0://收藏
            [self SYGCollect];
            break;
        case 100://分享
            [self shareButton];
            break;
        case 200://下载
            [self downButtonClick];
            break;
        case 300://购买
//            [self goBuy];
            [self buyClick];
            break;
            
        default:
            break;
    }
    
}


#pragma mark --- 添加视频播放器

- (void)addPlayer {
    
//    NSLog(@"--%@",dict);
//    NSURL *url = [NSURL URLWithString:_video_address];
    NSLog(@"----%@",_video_address);
    if ([_video_address isEqual:[NSNull null]]) {
        return;
    }
    //添加箭头等
    if (iPhone4SOriPhone4) {
        
        if (wmPlayer!=nil||wmPlayer.superview !=nil){
            [self releaseWMPlayer];
        }
        [_imageView removeFromSuperview];
        _imageView = nil;
        
        //创建播放器
        playerFrame = CGRectMake(0,64, self.view.frame.size.width, (self.view.frame.size.width)*3/5);
        wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:_video_address];
        wmPlayer.closeBtn.hidden = YES;
        [self.view addSubview:wmPlayer];
//        [wmPlayer.player play];
        [wmPlayer.player pause];
        wmPlayer.playOrPauseBtn.selected = YES;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 50, 50)];
        button.backgroundColor = [UIColor redColor];
        [button addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
        [wmPlayer addSubview:button];
        
    }else
        if (iPhone5o5Co5S) {
            
            
            if (wmPlayer!=nil||wmPlayer.superview !=nil){
                [self releaseWMPlayer];
            }
            [_imageView removeFromSuperview];
            _imageView = nil;
            
            //创建播放器
            playerFrame = CGRectMake(0, 64, MainScreenWidth, MainScreenWidth*3/5);
            
            wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:_video_address];
            wmPlayer.closeBtn.hidden = YES;
            [self.view addSubview:wmPlayer];
//            [wmPlayer.player play];
            [wmPlayer.player pause];
            wmPlayer.playOrPauseBtn.selected = YES;
            
        }
        else if(iPhone6)
        {
            
            if (wmPlayer!=nil||wmPlayer.superview !=nil){
                [self releaseWMPlayer];
            }
            [_imageView removeFromSuperview];
            _imageView = nil;
            //创建播放器
            playerFrame = CGRectMake(0, 64, self.view.frame.size.width, MainScreenHeight - 390);
            NSLog(@"%@",_video_address);
            if (_video_address == nil) {
                return;
            }
            wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:_video_address];
            wmPlayer.closeBtn.hidden = YES;
            [self.view addSubview:wmPlayer];
//            [wmPlayer.player play];
            [wmPlayer.player pause];
            wmPlayer.playOrPauseBtn.selected = YES;
            
        }
        else if(iPhone6Plus)
        {
            
            
            if (wmPlayer!=nil||wmPlayer.superview !=nil){
                [self releaseWMPlayer];
            }
            [_imageView removeFromSuperview];
            _imageView = nil;
            //创建播放器
            playerFrame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.width)*3/4);
            wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:_video_address];
            wmPlayer.closeBtn.hidden = YES;
            [self.view addSubview:wmPlayer];
//            [wmPlayer.player play];
            [wmPlayer.player pause];
            wmPlayer.playOrPauseBtn.selected = YES;
            
         }
        else {//ipad 适配
            
            if (wmPlayer!=nil||wmPlayer.superview !=nil){
                [self releaseWMPlayer];
            }
            [_imageView removeFromSuperview];
            _imageView = nil;
            //创建播放器
            playerFrame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.width)*3/4);
            wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:_video_address];
            wmPlayer.closeBtn.hidden = YES;
            [self.view addSubview:wmPlayer];
//            [wmPlayer.player play];
            [wmPlayer.player pause];
            wmPlayer.playOrPauseBtn.selected = YES;
        }
    //获取当前时间
    //判断是否购买
    
    
    if ([_notifitonDic[@"type"] integerValue] == 2) {//为音频
        if (wmPlayer.isFullscreen == YES) {//全屏
            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenHeight, MainScreenWidth)];
        } else {//小屏
            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, CGRectGetHeight(wmPlayer.frame))];
        }
        _imageView.image = [UIImage imageNamed:@"音频"];
        [wmPlayer addSubview:_imageView];
        _imageView.userInteractionEnabled = YES;
        [_imageView insertSubview:wmPlayer.bottomView atIndex:0];
    }

    
    
    //添加封面图
    UIImageView *videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, playerFrame.size.width, playerFrame.size.height)];
    videoImageView.backgroundColor = [UIColor redColor];
    [videoImageView sd_setImageWithURL:[NSURL URLWithString:_img] placeholderImage:Image(@"站位图")];
    [wmPlayer addSubview:videoImageView];
    videoImageView.userInteractionEnabled = YES;
    _videoImageView = videoImageView;
    
//    //添加播放的按钮
//    UIButton *playVideoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
//    playVideoButton.backgroundColor = [UIColor clearColor];
//    [playVideoButton setBackgroundImage:Image(@"点播播放") forState:UIControlStateNormal];
//    playVideoButton.center = videoImageView.center;
//    playVideoButton.layer.cornerRadius = 40;
//    playVideoButton.layer.masksToBounds = YES;
//    [playVideoButton addTarget:self action:@selector(playVideoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [videoImageView addSubview:playVideoButton];
//    _videoPlayButton = playVideoButton;
    
    //做网络判断
    if (![[GLNetWorking isConnectionAvailable] isEqualToString:@"wifi"]) {
        if (_isPlayNumber == 1) {//说明没有点允许手机网观看
            _playAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您现在使用的是运营商网络，继续使用可能会产生超额流量费用" delegate:self cancelButtonTitle:@"取消观看" otherButtonTitles:@"继续观看", nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_playAlertView show];
            });
        } else if (_isPlayNumber == 2) {//可以用手机网观看
             [self continuePlay];
        }
    } else {//wifi 下 直接观看
        [self continuePlay];
    }
    
    


    

    //注册播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
}



#pragma mark --- 添加视频播放器
//- (void)addPlayer {
//    //添加箭头等
//    if (iPhone4SOriPhone4) {
//        if (wmPlayer!=nil||wmPlayer.superview !=nil){
//            [self releaseWMPlayer];
//        }
//        [_imageView removeFromSuperview];
//        _imageView = nil;
//        //创建播放器
//        playerFrame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.width)*3/5);
//        wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:_video_address];
//        wmPlayer.closeBtn.hidden = YES;
//        [self.view addSubview:wmPlayer];
//        [wmPlayer.player play];
//    }else if (iPhone5o5Co5S) {
//        if (wmPlayer!=nil||wmPlayer.superview !=nil){
//            [self releaseWMPlayer];
//        }
//        [_imageView removeFromSuperview];
//        _imageView = nil;
//        //创建播放器
//        playerFrame = CGRectMake(0, 70, MainScreenWidth, MainScreenWidth*3/5);
//        wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:_video_address];
//        wmPlayer.closeBtn.hidden = YES;
//        [self.view addSubview:wmPlayer];
//        [wmPlayer.player play];
//    } else if(iPhone6) {
//        if (wmPlayer!=nil||wmPlayer.superview !=nil){
//            [self releaseWMPlayer];
//        }
//        [_imageView removeFromSuperview];
//        _imageView = nil;
//        //创建播放器
//        playerFrame = CGRectMake(0, 64, self.view.frame.size.width, MainScreenHeight - 390);
//        wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:_video_address];
//        wmPlayer.closeBtn.hidden = YES;
//        [self.view addSubview:wmPlayer];
//        [wmPlayer.player play];
//    } else if(iPhone6Plus){
//        if (wmPlayer!=nil||wmPlayer.superview !=nil){
//            [self releaseWMPlayer];
//        }
//        [_imageView removeFromSuperview];
//        _imageView = nil;
//        //创建播放器
//        playerFrame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.width)*3/4);
//        wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:_video_address];
//        wmPlayer.closeBtn.hidden = YES;
//        [self.view addSubview:wmPlayer];
//        [wmPlayer.player play];
//    }
//    
//    if ([_notifitonDic[@"type"] integerValue] == 2) {//为音频
//        if (wmPlayer.isFullscreen == YES) {//全屏
//            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenHeight, MainScreenWidth)];
//        } else {//小屏
//            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, CGRectGetHeight(wmPlayer.frame))];
//        }
//        _imageView.image = [UIImage imageNamed:@"音频"];
//        [wmPlayer addSubview:_imageView];
//        _imageView.userInteractionEnabled = YES;
//        [_imageView insertSubview:wmPlayer.bottomView atIndex:0];
//    }
//    
//    //获取当前时间
//    //判断是否购买
//    NSLog(@"%@",dict);
//    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getCurrentTime) userInfo:nil repeats:YES];
//    
//    //注册播放完成通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
//}

#pragma mark --- 添加音乐播放器
- (void)addMusicPlayer {
    //    NSString *urlStr = @"http://XXXXXX:8080/citystyle/accy/audio/296";
    NSURL *url = [[NSURL alloc]initWithString:_video_address];
    NSData * audioData = [NSData dataWithContentsOfURL:url];
    
    //将数据保存到本地指定位置
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.arm", docDirPath , @"temp"];
    NSLog(@"filePath ==== %@",filePath);
    [audioData writeToFile:filePath atomically:YES];
    
    //播放本地音乐
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    NSError *playError = nil;
    _musicPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:&playError];
    [_musicPlayer play];
    _musicPlayer.delegate = self;
}

#pragma mark ---- 添加webView

- (void)addWebView {
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth,MainScreenHeight / 2)];
    if (iPhone4SOriPhone4) {
        _webView.frame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.width)*3/5);
    } else if (iPhone5o5Co5S) {
        _webView.frame = CGRectMake(0, 70, MainScreenWidth, MainScreenWidth*3/5);
    } else if (iPhone6) {
        _webView.frame = CGRectMake(0, 64, self.view.frame.size.width, MainScreenHeight - 390);
    } else if (iPhone6Plus) {
        _webView.frame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.width)*3/4);
    }
    _webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_webView];
    
    
    [_webView setUserInteractionEnabled:YES];//是否支持交互
    _webView.delegate=self;
    [_webView setOpaque:YES];//opaque是不透明的意思
    [_webView setScalesPageToFit:YES];//自适应
    
    NSURL *url = nil;
    url = [NSURL URLWithString:_video_address];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    [MBProgressHUD showMessag:@"加载中....." toView:self.view];
    
    isWebViewBig = NO;
    //添加手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fakeTapGestureHandler:)];
    [tapGestureRecognizer setDelegate:self];
    [_webView.scrollView addGestureRecognizer:tapGestureRecognizer];
    
}

#pragma mark --- 添加文本显示
- (void)addTextView {
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    if (iPhone4SOriPhone4) {
        _textView.frame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.width)*3/5);
    } else if (iPhone5o5Co5S) {
        _textView.frame = CGRectMake(0, 70, MainScreenWidth, MainScreenWidth*3/5);
    } else if (iPhone6) {
        _textView.frame = CGRectMake(0, 64, self.view.frame.size.width, MainScreenHeight - 390);
    } else if (iPhone6Plus) {
        _textView.frame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.width)*3/4);
    }
    _textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_textView];
    
    NSString *textStr = [self filterHTML:_video_address];
    _textView.text = textStr;
    _textView.editable = NO;
    _textView.userInteractionEnabled = YES;
    isTextViewBig = NO;
    
    //添加收拾
    [_textView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textClick:)]];
    
    
}

#pragma mark ---- 手势代理

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint tapPoint = [touch locationInView:_webView];
    NSString *script = [NSString stringWithFormat:@"eleIdFromPoint(%f, %f)", tapPoint.x, tapPoint.y];
    if (touch.tapCount == 2) {
    }
    return YES;
}
#pragma mark ---- 手势
- (void)fakeTapGestureHandler:(UITapGestureRecognizer *)tap {
    
    isWebViewBig = !isWebViewBig;
    if (isWebViewBig == YES) {
        [UIView animateWithDuration:0.25 animations:^{
            _webView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
            //方法 隐藏导航栏
            self.navigationController.navigationBar.hidden = YES;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            if (iPhone4SOriPhone4) {
                _webView.frame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.width)*3/5);
            } else if (iPhone5o5Co5S) {
                _webView.frame = CGRectMake(0, 70, MainScreenWidth, MainScreenWidth*3/5);
            } else if (iPhone6) {
                _webView.frame = CGRectMake(0, 64, self.view.frame.size.width, MainScreenHeight - 390);
            } else if (iPhone6Plus) {
                _webView.frame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.width)*3/4);
            }
            self.navigationController.navigationBar.hidden = NO;
        }];
    }
}

//文本手势
- (void)textClick:(UITapGestureRecognizer *)tap {
    
    isTextViewBig = !isTextViewBig;
    if (isTextViewBig == YES) {
        [UIView animateWithDuration:0.25 animations:^{
            _textView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
            //方法 隐藏导航栏
            self.navigationController.navigationBar.hidden = YES;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            if (iPhone4SOriPhone4) {
                _textView.frame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.width)*3/5);
            } else if (iPhone5o5Co5S) {
                _textView.frame = CGRectMake(0, 70, MainScreenWidth, MainScreenWidth*3/5);
            } else if (iPhone6) {
                _textView.frame = CGRectMake(0, 64, self.view.frame.size.width, MainScreenHeight - 390);
            } else if (iPhone6Plus) {
                _textView.frame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.width)*3/4);
            }
            self.navigationController.navigationBar.hidden = NO;
        }];
    }
    
}




- (void)addPlayerButton {
    


}


#pragma mark --- UIWebViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showError:@"加载成功" toView:self.view];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showError:@"加载失败" toView:self.view];
}


#pragma mark --- 播放器

- (void)playVideoButtonClick:(UIButton *)button {
    
    if (![[GLNetWorking isConnectionAvailable] isEqualToString:@"wifi"]) {
        
        _playAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您现在使用的是运营商网络，继续使用可能会产生超额流量费用" delegate:self cancelButtonTitle:@"取消观看" otherButtonTitles:@"继续观看", nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_playAlertView show];
        });
    } else {//wifi 下 直接观看
        [self continuePlay];
    }
    
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

    if ([dict[@"is_play_all"] integerValue] != 0) {
        return;
    }
    if ([_videoDict[@"is_free"] integerValue] == 1) {//如果免费
        return;
    }
    //监听播放时间
    CMTime cmTime = wmPlayer.player.currentTime;
    float videoDurationSeconds = CMTimeGetSeconds(cmTime);
    
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
            
            wmPlayer.playOrPauseBtn.enabled = NO;
            wmPlayer.playOrPauseBtn.selected = NO;
            wmPlayer.progressSlider.enabled = NO;
            
            
        } else {
            NSLog(@"123");
        }
        
    } else {//时间还没有到的
        wmPlayer.playOrPauseBtn.enabled = YES;
//        wmPlayer.playOrPauseBtn.selected = NO;
        wmPlayer.progressSlider.enabled = YES;
        if (_imageView.subviews.count == 0) {
             [_imageView removeFromSuperview];
        }

    }

}


-(void)collectionClick{
    
    // 这里应该判断是否已经登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        
    }else {
        [self addShopingCar];
    }
}
-(void)addShopingCar
{
    //应该先判断是否购物车已经加入此课程
    ZhiyiHTTPRequest *manager1 = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic1 setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic1 setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [manager1 UserShopingCar:dic1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {
            ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
            [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
            [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
            [dic setObject:_cid forKey:@"id"];
            NSLog(@"((%@",_cid);
            [manager addToShopingCar:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *msg = [responseObject objectForKey:@"msg"];
                if (![msg isEqual:@"ok"]) {
                    [MBProgressHUD showError:msg toView:self.view];
                } else {
                    [MBProgressHUD showSuccess:@"加入成功" toView:self.view];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        
        } else {
            
            NSArray *array = responseObject[@"data"];
            for (int i = 0 ; i < array.count ; i ++) {
                NSString *key = array[i][@"id"];
                if (_cid == key) {
                    //说明已经收藏过了。
                    [MBProgressHUD showSuccess:@"已经收藏了" toView:self.view];
                    return ;
                }
                
            }
            
            ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
            [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
            [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
            [dic setObject:_cid forKey:@"id"];
            NSLog(@"((%@",_cid);
            [manager addToShopingCar:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *msg = [responseObject objectForKey:@"msg"];
                if (![msg isEqual:@"ok"]) {
                    [MBProgressHUD showError:msg toView:self.view];
                } else {
                    [MBProgressHUD showSuccess:@"加入成功" toView:self.view];
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
    [dic setObject:_cid forKey:@"vids"];
    [manager settleUserShopingCar:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        if (![msg isEqual:@"ok"]) {
            [MBProgressHUD showError:msg toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


-(void)btnClick:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    
    switch (btn.tag) {
        case 10080:
        {
            if (iPhone4SOriPhone4 || iPhone5o5Co5S)
            {
                 _arrowImageView.frame = CGRectMake(58, 35, 50, 5);
            }
            else if (iPhone6)
            {
                _arrowImageView.frame = CGRectMake(40, 35, 50, 5);
            }
            else if (iPhone6Plus)
            {
                _arrowImageView.frame = CGRectMake(90, 35, 50, 5);
            } else {
                 _arrowImageView.frame = CGRectMake(210, 35, 50, 5);
            }
           
            _scrollView.contentOffset = CGPointMake(0, 0);
            
            
            UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
            [btn setTitleColor:BasidColor forState:UIControlStateNormal];
            UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
            [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }
            break;
            case 10081:
        {
             if (iPhone4SOriPhone4 || iPhone5o5Co5S)
             {
                 _arrowImageView.frame = CGRectMake(180, 35, 50, 5);
             }
            else if(iPhone6)
            {
                _arrowImageView.frame = CGRectMake(450, 35, 50, 5);
            }
            else if(iPhone6Plus)
            {
                _arrowImageView.frame = CGRectMake(245, 35, 50, 5);
            } else {
                 _arrowImageView.frame = CGRectMake(480, 35, 50, 5);
                
            }
            _scrollView.contentOffset = CGPointMake(MainScreenWidth, 0);
            
            
            
            UIButton *btn =(UIButton *)[self.view viewWithTag:10080];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
            [btn1 setTitleColor:BasidColor forState:UIControlStateNormal];
            UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
            [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }
            break;
            
        case 10082:
        {
            if (iPhone4SOriPhone4 || iPhone5o5Co5S)
            {
                _arrowImageView.frame = CGRectMake(180, 35, 50, 5);
            }
            else if(iPhone6)
            {
                _arrowImageView.frame = CGRectMake(215, 35, 50, 5);
            }
            else if(iPhone6Plus)
            {
                _arrowImageView.frame = CGRectMake(245, 35, 50, 5);
            } else {
                _arrowImageView.frame = CGRectMake(480, 35, 50, 5);
                
            }
            _scrollView.contentOffset = CGPointMake(MainScreenWidth * 2, 0);
            
            UIButton *btn =(UIButton *)[self.view viewWithTag:10080];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
            [btn2 setTitleColor:BasidColor forState:UIControlStateNormal];
            
        }
            break;
          
        default:
            break;
            
    }
    _arrowImageView.frame = CGRectMake(btn.center.x - 25, 35, 50, 5);

    int p =_arrowImageView.frame.origin.x;
     if (iPhone4SOriPhone4 || iPhone5o5Co5S) {
    switch (p) {
        case 58:
        {
            UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
            [btn setTitleColor:BasidColor forState:UIControlStateNormal];
            UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
            break;
        case 180:
        {
            UIButton *btn =(UIButton *)[self.view viewWithTag:10080];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
            [btn1 setTitleColor:BasidColor forState:UIControlStateNormal];
         
        }
            break;
        case 270:
        {
            UIButton *btn =(UIButton *)[self.view viewWithTag:10080];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
            [btn1 setTitleColor:BasidColor forState:UIControlStateNormal];
            
        }
            break;

        
        default:
            break;
    }
     }
    
    else if (iPhone6)
    {
        switch (p) {
            case 78:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:BasidColor forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
            case 215:
            {
                UIButton *btn =(UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:BasidColor forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
            case 370:
            {
                UIButton *btn =(UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:BasidColor forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }

    }
    else if (iPhone6Plus)
    {
        switch (p) {
            case 90:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:BasidColor forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn3 =(UIButton *)[self.view viewWithTag:10083];
                [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
            case 245:
            {
                UIButton *btn =(UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:BasidColor forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn3 =(UIButton *)[self.view viewWithTag:10083];
                [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }

    } else {//ipad 适配
        
        switch (p) {
            case 210:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:BasidColor forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn3 =(UIButton *)[self.view viewWithTag:10083];
                [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
            case 480:
            {
                UIButton *btn =(UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:BasidColor forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn3 =(UIButton *)[self.view viewWithTag:10083];
                [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }

    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==_scrollView) {
        CGPoint point = scrollView.contentOffset;
        if (point.x==0) {
             if (iPhone4SOriPhone4 || iPhone5o5Co5S) {
            _arrowImageView.frame = CGRectMake(30, 35, 50, 5);
             }
            else if (iPhone6)
            {
                _arrowImageView.frame = CGRectMake(40, 35, 50, 5);
            }
            else if(iPhone6Plus)
            {
                _arrowImageView.frame = CGRectMake(90, 35, 50, 5);
            }
            _scrollView.contentOffset = CGPointMake(0, 0);
        }
        else if(point.x==MainScreenWidth)
        {
             if (iPhone4SOriPhone4 || iPhone5o5Co5S) {
            _arrowImageView.frame = CGRectMake(135, 35, 50, 5);
             }
            else if(iPhone6)
            {
                _arrowImageView.frame = CGRectMake(165, 35, 50, 5);

            }
            else if(iPhone6Plus)
            {
                _arrowImageView.frame = CGRectMake(245, 35, 50, 5);
            }
            _scrollView.contentOffset = CGPointMake(MainScreenWidth, 0);
        }else if (point.x==MainScreenWidth * 2) {
            
            if (iPhone4SOriPhone4 || iPhone5o5Co5S) {
                _arrowImageView.frame = CGRectMake(240, 35, 50, 5);
            }
            else if(iPhone6)
            {
                _arrowImageView.frame = CGRectMake(288, 35, 50, 5);
                
            }
            else if(iPhone6Plus)
            {
                _arrowImageView.frame = CGRectMake(245, 35, 50, 5);
            }
            _scrollView.contentOffset = CGPointMake(MainScreenWidth * 2, 0);
        }
    }
    int p =_arrowImageView.frame.origin.x;
    
    NSLog(@"%d",p);
    
     if (iPhone4SOriPhone4 || iPhone5o5Co5S) {
    switch (p) {
        case 30:
        {
            UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
            [btn setTitleColor:BasidColor forState:UIControlStateNormal];
            UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
            [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
            break;
        case 135:
        {
            UIButton *btn =(UIButton *)[self.view viewWithTag:10080];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
            [btn1 setTitleColor:BasidColor forState:UIControlStateNormal];
            UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
            [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
            break;
        case 240:
        {
            UIButton *btn =(UIButton *)[self.view viewWithTag:10080];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton *btn1 =(UIButton *)[self.view viewWithTag:10082];
            [btn1 setTitleColor:BasidColor forState:UIControlStateNormal];
            UIButton *btn2 =(UIButton *)[self.view viewWithTag:10081];
            [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
     }
    else if(iPhone6)
    {
        switch (p) {
            case 40:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:BasidColor forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
            case 165:
            {
                UIButton *btn =(UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:BasidColor forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
            case 288:
            {
                UIButton *btn =(UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10082];
                [btn1 setTitleColor:BasidColor forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10081];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }

    }
    else if(iPhone6Plus)
    {
        switch (p) {
            case 90:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:BasidColor forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
            case 245:
            {
                UIButton *btn =(UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:BasidColor forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }

    }

}


- (void)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
    [wmPlayer.player pause];
    [self releaseWMPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)requestData
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_cid forKey:@"id"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
    }else {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];

    }

   [manager getClassDetail:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"********%@",responseObject);
        //创建通知消息
        dict = responseObject[@"data"];
       _buyMessage = responseObject[@"data"][@"isBuy"];
       
       if ([_buyMessage integerValue ] == 0) {
           [_buyButton setTitle:@"购买课程" forState:UIControlStateNormal];
       } else {
           [_buyButton setTitle:@"已购买" forState:UIControlStateNormal];
       }

           
       //判断是否应该缓存这个视频
       if (![dict[@"is_play_all"] integerValue] == 0 ) {//购买了的
           
           if (isShouleVedio == YES) {
               if ([_video_address isEqual:[NSNull null]]) {
                   return ;
               }
               [self downWithurl:_video_address];
               isShouleVedio = NO;
           }
       }
       
       if (![dict[@"is_play_all"] integerValue] == 0  || [_videoDict[@"is_free"] integerValue] == 1) {//购买了的
           [_timer invalidate];
           self.timer = nil;
       }else {//没有购买
           
           self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(HHHHH) userInfo:nil repeats:YES];
       }

           
        _collectStr = [responseObject objectForKey:@"data"][@"iscollect"];
        NSLog(@"收场----%@",_collectStr);
        
        if ([_collectStr intValue] == 1) {//已经收藏
            [_collectButton  setImage:Image(@"likee_pressed@3x") forState:UIControlStateNormal];
        } else {//没有收场
             [_collectButton  setImage:Image(@"likee@3x") forState:UIControlStateNormal];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (wmPlayer!=nil||wmPlayer.superview !=nil){
            [self releaseWMPlayer];
        }
        [_imageView removeFromSuperview];
        _imageView = nil;

        if(iPhone6) {
            playerFrame = CGRectMake(0, 64 , MainScreenWidth, MainScreenHeight - 390);
        } else if(iPhone6Plus) {
            playerFrame = CGRectMake(0, 64 ,MainScreenWidth,MainScreenWidth*3/4);
        }else if (iPhone4SOriPhone4 || iPhone5o5Co5S) {
                playerFrame = CGRectMake(0, 64,MainScreenWidth, MainScreenWidth*3/5);
        }
        wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:_video_address];
        wmPlayer.closeBtn.hidden = YES;
        [self.view addSubview:wmPlayer];
        [wmPlayer.player play];
        [wmPlayer.player pause];
        wmPlayer.playOrPauseBtn.selected = YES;
    }];
}

//收藏
- (void)likeBtn
{
    //判断是否登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        
    }else {//已经登录
        
        [self SYGCollect];
        
    }

}


- (void)SYGCollect {
    
    if ([_collectStr intValue]==1) {
        QKHTTPManager * manager = [QKHTTPManager manager];
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:@"2" forKey:@"sctype"];
        [dic setValue:@"0" forKey:@"type"];
        [dic setValue:_cid forKey:@"source_id"];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] != nil) {
            [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
            [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
        } else {
            [MBProgressHUD showError:@"请先登陆" toView:self.view];
            return;
        }

        [manager collect:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"-------%@",responseObject);
            NSString *Msg = responseObject[@"msg"];
            
            if ([Msg isEqualToString:@"ok"]) {
                [_collectButton setImage:Image(@"likee@3x") forState:UIControlStateNormal];
                _collectStr = @"0";
            }else {
                [MBProgressHUD showError:Msg toView:self.view];
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    } else {
        QKHTTPManager * manager1 =[QKHTTPManager manager];
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:@"2" forKey:@"sctype"];
        [dic setValue:@"1" forKey:@"type"];
        [dic setValue:_cid forKey:@"source_id"];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] != nil) {
            [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
            [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
        } else {
            [MBProgressHUD showError:@"请先登陆" toView:self.view];
            return;
        }
        
        [manager1 collect:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"----%@",responseObject);
            NSString *Msg = responseObject[@"msg"];
            if ([Msg isEqualToString:@"ok"]) {
                [_collectButton setImage:Image(@"likee_pressed@3x") forState:UIControlStateNormal];
                 _collectStr = @"1";
            }else {
                [MBProgressHUD showError:Msg toView:self.view];
            }
            
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
    
    
    
    //创建个VIew
    _buyView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth, 64, 100, 85)];
    _buyView.backgroundColor = [UIColor colorWithRed:254.f / 255 green:255.f / 255 blue:255.f / 255 alpha:1];
    _buyView.layer.cornerRadius = 3;
    [_allView addSubview:_buyView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
    //改变位置 动画
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

- (void)miss {
    
    [UIView animateWithDuration:0.25 animations:^{

        _buyView.frame = CGRectMake(MainScreenWidth, 64, 100, 85);
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

- (void)SYGButton:(UIButton *)button {
    
    [_allView removeFromSuperview];
    [_allButton removeFromSuperview];
    [_buyView removeFromSuperview];

    
    if (button.tag == 520) {//笔记
        
        [wmPlayer.player pause];
//         wmPlayer.playOrPauseBtn.selected = YES;//这句代码是暂停播放后播放按钮显示为暂停状态
        
        noteVC *NOVC = [[noteVC alloc] initWithId:_cid isSelf:YES];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:NOVC];
        [self presentViewController:Nav animated:YES completion:nil];

        isSecet = NO;
        
        
    } else if (button.tag == 521){//分享
        
        [wmPlayer.player pause];
//         wmPlayer.playOrPauseBtn.selected = YES;//这句代码是暂停播放后播放按钮显示为暂停状态
        
        isSecet = NO;
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"574e8829e0f55a12f8001790"
                                          shareText:[NSString stringWithFormat:@"我正在出右云课堂app观看—%@视频地址%@",_videoTitle,_video_address]
                                         shareImage:[UIImage imageNamed:@"chuyou.png"]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToRenren,nil]
                                           delegate:self];

        
        
    }
    
    
}

- (void)shareButton {
    [wmPlayer.player pause];
    //         wmPlayer.playOrPauseBtn.selected = YES;//这句代码是暂停播放后播放按钮显示为暂停状态
    
    isSecet = NO;
    NSLog(@"%@  %@",_videoTitle,_shareVideoUrl);
//    if (_shareVideoUrl == nil) {
//        [MBProgressHUD showError:@"分享的视频地址为空" toView:self.view];
//        return;
//    }
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_img]];
    
//    NSString *shareUrl = [NSString stringWithFormat:@"http://www.igenwoxue.com/index.php?app=classroom&mod=Video&act=view&id=%@",_cid];
    
    NSString *str1 = @"app=classroom&mod=Video&act=view&id=";
    NSString *str2 = [NSString stringWithFormat:@"%@%@",str1,_cid];
    NSString *shareUrl = [NSString stringWithFormat:@"%@%@",basidUrl,str2];
    
    [UMSocialWechatHandler setWXAppId:@"wxbbb961a0b0bf577a" appSecret:@"eb43d9bc799c4f227eb3a56224dccc88" url:shareUrl];
    [UMSocialQQHandler setQQWithAppId:@"3997129963" appKey:@"Q6Q6hJa2Cs8EqtLt" url:shareUrl];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3997129963" secret:@"da07bcf6c9f30281e684f8abfd0b4fca" RedirectURL:shareUrl];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"574e8829e0f55a12f8001790"
                                      shareText:[NSString stringWithFormat:@"%@",_course_title]
                                     shareImage:imageView.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:self];


}



//移除警告框

- (void)removeAlert:(NSTimer*)theTimer//弹出框
{
}

#pragma mark --- 购买

-(void)buyClick{
    
    //判断是否登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        
        [wmPlayer.player pause];
        
    }else {//已经登录
        
//        [self SYGBuy];
        if ([_buyButton.titleLabel.text isEqualToString:@"已购买"]) {
            [MBProgressHUD showError:@"已经购买过了" toView:self.view];
            return;
        }
        
        ClassPayViewController *payVc = [[ClassPayViewController alloc] init];
        payVc.dict = dict;
        payVc.cid = _cid;
        payVc.typeStr = @"点播";
        [self.navigationController pushViewController:payVc animated:YES];
    }
}


- (void)SYGBuy {

    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:_allView];
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(MissBuyView) forControlEvents:UIControlEventTouchUpInside];
    
    [_allView addSubview:_allButton];
    
    
    //创建个VIew
    
    CGFloat BuyViewW = MainScreenWidth / 4 * 3;
    
    _buyView = [[UIView alloc] init];
    _buyView.center = self.view.center;
    _buyView.bounds = CGRectMake(0, 0,MainScreenWidth / 4 * 3, 250);
    _buyView.backgroundColor = [UIColor colorWithRed:254.f / 255 green:255.f / 255 blue:255.f / 255 alpha:1];
    _buyView.layer.cornerRadius = 5;
    [_allView addSubview:_buyView];
    //view上面添加空间
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,BuyViewW , 40)];
    topLabel.text = @"购买提示";
    topLabel.font = Font(18);
    topLabel.backgroundColor = BasidColor;
    topLabel.textColor = [UIColor whiteColor];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [_buyView addSubview:topLabel];
    
    UILabel *needMoney = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 50, MainScreenWidth / 2, 20)];
    needMoney.font = Font(15);
    needMoney.text = [NSString stringWithFormat:@"该课程需支付:%@",dict[@"mzprice"][@"price"]];
    [_buyView addSubview:needMoney];
    
    
    //使用优惠券
    UILabel *counpLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 80, BuyViewW - 40, 20)];
    counpLabel.text = @"使用优惠券：";
    counpLabel.font = Font(15);
    [_buyView addSubview:counpLabel];
    _counpLabel = counpLabel;
    
    //选择的按钮
    UIButton *counpButton = [[UIButton alloc] initWithFrame:CGRectMake(BuyViewW - 30, 80, 20, 20)];
    [counpButton setImage:Image(@"灰色乡下") forState:UIControlStateNormal];
    [counpButton addTarget:self action:@selector(counpButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_buyView addSubview:counpButton];
    
    //添加同意按钮
    isArgree = NO;
    UIButton *argreeButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, 110, 20, 20)];
    [argreeButton setBackgroundImage:Image(@"支付未同意") forState:UIControlStateNormal];
    [argreeButton setBackgroundImage:Image(@"支付同意") forState:UIControlStateSelected];
    [argreeButton addTarget:self action:@selector(isArgree:) forControlEvents:UIControlEventTouchUpInside];
    [_buyView addSubview:argreeButton];
    
    //是否同意协议
    UILabel *argreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 110, BuyViewW, 20)];
    argreeLabel.text = @"我已同意支付方式";
    argreeLabel.font = Font(15);
    argreeLabel.textColor = [UIColor colorWithRed:145.f / 255 green:148.f / 255 blue:155.f / 255 alpha:1];
    [_buyView addSubview:argreeLabel];
    
    
    //添加几个按钮
    NSArray *titleString = @[@"支付宝",@"微信",@"取消"];
    
    CGFloat ButtonW = (BuyViewW - 6 * SpaceBaside) / 3;
    
    for (int i = 0 ; i < 3; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside + (2 * SpaceBaside + ButtonW) * i , 150 ,ButtonW, 35)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:titleString[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:145.f / 255 green:148.f / 255 blue:155.f / 255 alpha:1] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:232.f / 255 green:235.f / 255 blue:243.f / 255 alpha:1];
        button.layer.cornerRadius = 5;
        button.tag = 1104 + i;
        [button addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
        [_buyView addSubview:button];
        
        _buyView.frame = CGRectMake(0, 0, BuyViewW, CGRectGetMaxY(button.frame) + SpaceBaside);
        _buyView.center = self.view.center;
        
    }
    
    //这里获取优惠券的数据
    [self NetWorkGetMyCouponList];
    
    
}

- (void)counpButtonClick {
    
    if (!_counpArray.count) {
        [MBProgressHUD showError:@"没有可使用的优惠券" toView:self.view];
        return;
    }
    _counpView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth /2  - 100, 0, 100, _counpArray.count * 40)];
    _counpView.backgroundColor = [UIColor whiteColor];
    [_buyView addSubview:_counpView];
    
    for (int i = 0 ; i < _counpArray.count ; i ++) {
        
        UIButton *button = [[UIButton alloc ] initWithFrame:CGRectMake(0, i * 40 + i * 5, 100, 40)];
        [button setTitle:_counpArray[i][@"discount"] forState:UIControlStateNormal];
        [button setTitleColor:BlackNotColor forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.tag = i;
        [button addTarget:self action:@selector(counpViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [_counpView addSubview:button];
    }
}

#pragma mark --- 支付同意
- (void)isArgree:(UIButton *)button {
    if (isArgree == NO) {
        isArgree = YES;
        [button setBackgroundImage:Image(@"支付同意") forState:UIControlStateNormal];
    } else if (isArgree == YES) {
        isArgree = NO;
        [button setBackgroundImage:Image(@"支付未同意") forState:UIControlStateNormal];
    }
}

- (void)counpViewButtonClick:(UIButton *)button {
    _counpID = _counpArray[button.tag][@"coupon_id"];
    NSString *title = button.titleLabel.text;
    
    _counpLabel.text = [NSString stringWithFormat:@"使用优惠券类型：%@",title];
    [_counpView removeFromSuperview];
}

- (void)pressed:(UIButton *)button {
    
    NSInteger Num = button.tag;
    if (Num == 1104 ) {//支付宝
        
        if (isArgree == NO) {
            [MBProgressHUD showError:@"请先同意协议" toView:self.view];
            return;
        } else {
            [self classBuyNetInfoAlipay];
        }
    } else if (Num == 1105) {//微信
        if (isArgree == NO) {
            [MBProgressHUD showError:@"请先同意协议" toView:self.view];
            return;
        } else {
            [self classBuyNetInfoWxpay];
        }

    } else if (Num == 1106) {//取消

    }
    [self MissBuyView];
    
}


- (void)MissBuyView {
    
    [_allView removeFromSuperview];
    [_allButton removeFromSuperview];
    [_buyView removeFromSuperview];
}


#pragma mark --- 下载

-(void)downButtonClick{
    
    if ([_buyMessage integerValue] == 0) {//没有购买
        [MBProgressHUD showError:@"请先购买再下载" toView:self.view];
        return;
    }
    
    if ([[GLNetWorking isConnectionAvailable] isEqualToString:@"4G"] || [[GLNetWorking isConnectionAvailable] isEqualToString:@"3G"] || [[GLNetWorking isConnectionAvailable] isEqualToString:@"2G"]) {
        _downAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"如果您正在使用2G/3G/4G,如果继续运营商可能会收取流量费用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_downAlertView show];
        });

    } else {
        [self downLoadVideo];
    }
}

-(void)downLoadVideo{
    if (_video_address.length == 0) {
        [MBProgressHUD showError:@"下载地址为空" toView:self.view];
        return;
    }
    if (_downTitleStr == nil) {
        _downTitleStr = _course_title;
    }
    
    NSLog(@"%@   %@",_img,_downTitleStr);
    
    NSString *imgUrl = _img;
    NSURL *imagegurl = [NSURL URLWithString:imgUrl];
    NSData *data = [NSData dataWithContentsOfURL:imagegurl];
    UIImage *image = [[UIImage alloc] initWithData:data];
    
    
    //此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
//    NSString *name = [[NSURL URLWithString:_video_address] lastPathComponent];
    NSLog(@"======%@---%@",_downTitleStr,_video_address);
    if (!_video_address.length) {
        [MBProgressHUD showError:@"下载地址为空" toView:self.view];
        return ;
    }
    if (_video_address == nil) {
        [MBProgressHUD showError:@"下载地址为空" toView:self.view];
        return;
    } else {
//        [MBProgressHUD showSuccess:@"已添加到下载队列中...." toView:self.view];
    }
    [[ZFDownloadManager sharedDownloadManager] downFileUrl:_video_address filename:_downTitleStr fileimage:image];
    // 设置最多同时下载个数（默认是3）
    [ZFDownloadManager sharedDownloadManager].maxCount = 1;

    
}
//根据被点击按钮的索引处理点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView == _playAlertView) {
        if (buttonIndex) {//继续观看
            [self continuePlay];
            _isPlayNumber = 2;
        } else {//取消观看
            
        }
        
    } else if (alertView == _downAlertView) {
        if (buttonIndex) {
            [self downLoadVideo];
        }
    }
}

- (void)continuePlay {
    [_videoImageView removeFromSuperview];
    [_videoPlayButton removeFromSuperview];
    [wmPlayer.player play];
     wmPlayer.playOrPauseBtn.selected = NO;
}

#pragma mark --- 获取优惠券的类型

- (void)NetWorkGetMyCouponList {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"20" forKey:@"count"];
    [dic setValue:_cid forKey:@"id"];
    
    [manager BigWinCar_getCanUseCouponList:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"======  %@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1) {
            _counpArray = responseObject[@"data"];
        } else {
            _counpArray = nil;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

//购买课程 获取支付的链接
- (void)classBuyNetInfoAlipay {
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    } else {
        [MBProgressHUD showError:@"请先登陆" toView:self.view];
        return;
    }
    [dic setValue:@"alipay" forKey:@"pay_for"];
    [dic setValue:_cid forKey:@"vids"];
    if (_counpID) {
        [dic setValue:_counpID forKey:@"coupon_id"];
    }
    
    [manager BigWinCar_buyVideos:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"======  %@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"is_free"] integerValue] == 0 ) {//不是免费
                 _alipayStr = responseObject[@"data"][@"alipay"][@"ios"];
                AlipayViewController *alipayVc = [[AlipayViewController alloc] init];
                alipayVc.payStr = _alipayStr;
                [self.navigationController pushViewController:alipayVc animated:YES];
            } else {//免费
                [MBProgressHUD showSuccess:@"购买成功" toView:self.view];
            }
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

    
}


//购买课程 获取微信的链接
- (void)classBuyNetInfoWxpay {
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    } else {
        [MBProgressHUD showError:@"请先登陆" toView:self.view];
        return;
    }
    [dic setValue:@"alipay" forKey:@"pay_for"];
    [dic setValue:_cid forKey:@"vids"];
    [dic setValue:_counpID forKey:@"coupon_id"];
    
    [manager BigWinCar_getCanUseCouponList:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"======  %@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"is_free"] integerValue] == 0 ) {//不是免费
                _wxpayStr = responseObject[@"data"][@"wxpay"][@"ios"];
                AlipayViewController *alipayVc = [[AlipayViewController alloc] init];
                alipayVc.payStr = _wxpayStr;
                [self.navigationController pushViewController:alipayVc animated:YES];
            } else {//免费
                [MBProgressHUD showSuccess:@"购买成功" toView:self.view];
            }
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
    
}


#pragma mark --- 去掉标签

//去掉HTML字符
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        
        
    }
    return html;
}





@end
