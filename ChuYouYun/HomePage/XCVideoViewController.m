//
//  XCVideoViewController.m
//  dafengche
//
//  Created by IOS on 16/12/21.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "XCVideoViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "PaiKeTableViewCell.h"
#import "MyHttpRequest.h"
#import "Passport.h"
#import "MBProgressHUD+Add.h"
#import "UIImageView+WebCache.h"
#import "UIImage+WebP.h"
#import "UIButton+WebCache.h"
#import "WMPlayer.h"


@interface XCVideoViewController ()<UIScrollViewDelegate>{
    
    NSString *_name;
    
    NSInteger _ID;
    NSString *_teacher_id;
    
    NSArray *_imgUrlArr;
    NSArray *_VideoUrlArr;
    NSArray *_titlearr;
    
    WMPlayer *wmPlayer;


}
@property (strong ,nonatomic)UIScrollView *headScrollow;


@end

@implementation XCVideoViewController


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
-(instancetype)initwithvideo_id:(NSInteger)ID name:(NSString *)name teacher_id:(NSString *)teacher_id{
    
    _name = name;
    _ID = ID;
    _teacher_id = teacher_id;
    
    return self;
}

-(void)addscrollow{
    
    _headScrollow = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64, MainScreenWidth,MainScreenHeight - 64)];
    _headScrollow.delegate = self;
    _headScrollow.alwaysBounceVertical = NO;
    _headScrollow.pagingEnabled = NO;
    //同时单方向滚动
    _headScrollow.directionalLockEnabled = YES;
    _headScrollow.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:_headScrollow];
    _headScrollow.showsVerticalScrollIndicator = NO;
    _headScrollow.showsHorizontalScrollIndicator = NO;
    _headScrollow.delegate = self;
    _headScrollow.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _headScrollow.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addNav];
    [self addscrollow];
    [self requestLXCata:_teacher_id];
    
}

//获取相册数据
-(void)requestLXCata:(NSString *)teacher_id
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    //临时的
    [dic setValue:[NSString stringWithFormat:@"%@",_teacher_id] forKey:@"teacher_id"];
    [dic setValue:[NSString stringWithFormat:@"%ld",_ID] forKey:@"photos_id"];
    
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"20" forKey:@"count"];
    [manager getpublicPort:dic mod:@"Teacher" act:@"getTeacherPhotosInfo" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            NSArray *arr = responseObject[@"data"];
            NSMutableArray *marr = [NSMutableArray array];
            NSMutableArray *titlemarr = [NSMutableArray array];
            NSMutableArray *videomarr = [NSMutableArray array];

            for (int i = 0; i<arr.count; i++) {
                
                if ([arr[i][@"cover"] length]) {
                    [marr addObject:arr[i][@"cover"]];
                    [titlemarr addObject:[NSString stringWithFormat:@"%@",arr[i][@"title"]]];
                    [videomarr addObject:[NSString stringWithFormat:@"%@",arr[i][@"resource"]]];
                }
            }
            _imgUrlArr = [NSArray arrayWithArray:marr];
            _VideoUrlArr = [NSArray arrayWithArray:videomarr];
            _titlearr = [NSArray arrayWithArray:titlemarr];

            NSArray *titlearr = [NSArray arrayWithArray:titlemarr];
            CGFloat width = MainScreenWidth/3 - 50/3;
            CGFloat y =  width*160/277 + 25 ;
            NSInteger number = titlearr.count;
            _headScrollow.contentSize = CGSizeMake(MainScreenWidth, (1+number/3)*y+50);
            [self creatBody];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
//body
-(void)creatBody{
    
    if (_imgUrlArr.count==0) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 30,MainScreenWidth, 30)];
        lab.text = @"暂时没有图片";
        lab.textColor = [UIColor grayColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:13];
        [_headScrollow addSubview:lab];
    }
    CGFloat width = MainScreenWidth/3 - 50/3;
    CGFloat height = width*160/277;

    for (int i = 0; i<_imgUrlArr.count; i++) {
        UIButton *IMG = [[UIButton alloc]initWithFrame:CGRectMake(10 +(i%3)*(width + 10), 10+(i/3)*(height + 10), width, height)];
        [_headScrollow addSubview:IMG];
        NSLog(@"%@",_imgUrlArr);
        [IMG sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_imgUrlArr[i]]]forState:0];
        
        [IMG addTarget:self action:@selector(goVideo:) forControlEvents:UIControlEventTouchUpInside];
        IMG.tag = i;
        //标题
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(IMG.current_x, IMG.current_y_h,width, 15)];
        lab.text = [NSString stringWithFormat:@"%@",_titlearr[i]];
        lab.textColor = [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:13];
        UIColor *color = [UIColor blackColor];
        lab.backgroundColor = [color colorWithAlphaComponent:0.2];
        [_headScrollow addSubview:lab];
    }
}
//去视频
-(void)goVideo:(UIButton *)sender{

    if (wmPlayer!=nil||wmPlayer.superview !=nil){
        [self releaseWMPlayer];
    }
    
    wmPlayer = [[WMPlayer alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenWidth*3/5) videoURLStr:_VideoUrlArr[sender.tag]];
    wmPlayer.closeBtn.hidden = NO;
    [wmPlayer.closeBtn addTarget:self action:@selector(gb) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wmPlayer];
    [wmPlayer.player play];
    [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
}
-(void)gb{
    
    if (wmPlayer!=nil||wmPlayer.superview !=nil){
        [self releaseWMPlayer];
        [wmPlayer removeFromSuperview];

    }
}
-(void)fullScreenBtnClick:(NSNotification *)notice{
    
    [self releaseWMPlayer];
    
    [wmPlayer removeFromSuperview];
    
    UIButton *fullScreenBtn = (UIButton *)[notice object];
    if (fullScreenBtn.isSelected) {//全屏显示
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        [self releaseWMPlayer];

        [wmPlayer removeFromSuperview];
    }
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
    wmPlayer.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
    wmPlayer.playerLayer.frame =  CGRectMake(0,0,MainScreenHeight,MainScreenWidth);
    wmPlayer.fullScreenBtn.hidden = YES;

    //在这里设置提醒试看试图的大小 （跟着视频大小的变化一起变化）
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

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}
- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = _name;
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 120, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,106)];
    [backButton setTitle:@" " forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    //设置button上字体的偏移量
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10.0 , 0.0, 0)];
    [SYGView addSubview:backButton];
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
