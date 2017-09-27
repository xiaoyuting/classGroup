//
//  BigWindCar_playViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/6/22.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "BigWindCar_playViewController.h"
#import "WMPlayer.h"

@interface BigWindCar_playViewController ()
{
    WMPlayer *wmPlayer;
    NSString *_pathUrl;
    NSString *_titlename;
    
}

@end

@implementation BigWindCar_playViewController


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:false];
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


-(instancetype)initWithPath:(NSString *)url withName:(NSString *)name{
    _pathUrl = url;
    _titlename = name;
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect playerFrame;
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    
    playerFrame = CGRectMake(0, 64, MainScreenWidth,200);
    
    NSLog(@"%@",_pathUrl);
    
    wmPlayer = [[WMPlayer alloc] initWithFrame:playerFrame videoURLStr:_pathUrl];
    //   /Users/ios/Library/Developer/CoreSimulator/Devices/340EE57E-6D91-4FEC-A855-4ABDAC7CAC7D/data/Containers/Data/Application/6B795599-BAC4-4487-884B-F41883294AD0/Library/Caches/ZFDownLoad/CacheList/chuyou81416385156.mp4
    NSLog(@"=======%@",_pathUrl);
    
    wmPlayer.closeBtn.hidden = NO;
    [self.view addSubview:wmPlayer];
    [wmPlayer.player play];
    [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    wmPlayer.fullScreenBtn.hidden = YES;
    [wmPlayer.closeBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
    
    //注册播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
    //    videoRequest = nil;
    
}


-(void)back{
    
    [wmPlayer removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    
    //    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
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
    //    _imageView.frame = CGRectMake(0,0, self.view.frame.size.height,self.view.frame.size.width);
    
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


-(void)fullScreenBtnClick:(NSNotification *)notice{
    UIButton *fullScreenBtn = (UIButton *)[notice object];
    if (fullScreenBtn.isSelected) {//全屏显示
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        //        [self toNormal];
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
                // [self toNormal];
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



@end
