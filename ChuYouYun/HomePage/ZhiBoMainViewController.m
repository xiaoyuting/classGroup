//
//  ZhiBoMainViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/5/20.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "ZhiBoMainViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"


#import "DLViewController.h"
#import "ZhiBoDetailViewController.h"
#import "ZhiBoClassViewController.h"
#import "ZhiBoCommentViewController.h"
#import "LiveDetailCommentViewController.h"

#import "ZhiboPayViewController.h"


@interface ZhiBoMainViewController ()<UIScrollViewDelegate,UMSocialUIDelegate,UIWebViewDelegate>

@property (strong ,nonatomic)UIScrollView *controllerSrcollView;
@property (strong ,nonatomic)UIImageView  *imageView;
@property (strong ,nonatomic)UISegmentedControl *mainSegment;
@property (strong ,nonatomic)UIButton *zhiBoLikeButton;
@property (strong ,nonatomic)UIButton *buyButton;
@property (strong ,nonatomic)UIButton *priceButton;
@property (strong ,nonatomic)UIView *downView;
@property (strong ,nonatomic)UIView *WZView;

@property (strong ,nonatomic)NSString *ID;
@property (strong ,nonatomic)NSString *zhiBoTitle;
@property (strong ,nonatomic)NSString *imageUrl;
@property (strong ,nonatomic)NSDictionary *zhiBoDic;
@property (strong ,nonatomic)NSString *collectStr;

@property (strong ,nonatomic)NSString *videoUrl;

@end

@implementation ZhiBoMainViewController

-(id)initWithMemberId:(NSString *)MemberId andImage:(NSString *)imgUrl andTitle:(NSString *)title andNum:(int)num andprice:(NSString *)price
{
    if (self=[super init]) {
        _ID = MemberId;
        _zhiBoTitle = title;
        _imageUrl = imgUrl;
    }
    return self;
}


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
    [self addImageView];
    [self addTitleView];
    [self addControllerSrcollView];
    [self addDownView];
    [self netWorkInfo];
    
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25, MainScreenWidth - 100, 30)];
    WZLabel.text = _zhiBoTitle;
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    //添加横线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:button];
    
    //添加分类的按钮
    UIButton *SortButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 45, 25, 30, 30)];
    [SortButton setBackgroundImage:Image(@"空心五角星@2x") forState:UIControlStateNormal];
    [SortButton addTarget:self action:@selector(SortButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:SortButton];
    _zhiBoLikeButton = SortButton;
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 添加图片视图
- (void)addImageView {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 200)];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:Image(@"站位图")];
    if (iPhone5o5Co5S) {
        _imageView.frame = CGRectMake(0, 64, MainScreenWidth, 160);
    } else if (iPhone6) {
        _imageView.frame = CGRectMake(0, 64, MainScreenWidth, 180);
    } else if (iPhone6Plus) {
        _imageView.frame = CGRectMake(0, 64, MainScreenWidth, 200);
    }
    _imageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_imageView];
    
}

#pragma mark --- 添加分类
- (void)addTitleView {
    UIView *WZView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame) , MainScreenWidth, 50)];
    WZView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:WZView];
    _WZView = WZView;
    
    NSArray *titleArray = @[@"详情",@"课程",@"点评"];
    _mainSegment = [[UISegmentedControl alloc] initWithItems:titleArray];
    _mainSegment.frame = CGRectMake(2 * SpaceBaside,SpaceBaside,MainScreenWidth - 4 * SpaceBaside, 30);
    _mainSegment.selectedSegmentIndex = 0;
    [_mainSegment setTintColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1]];
    [_mainSegment addTarget:self action:@selector(mainChange:) forControlEvents:UIControlEventValueChanged];
    [WZView addSubview:_mainSegment];
    
    
}

#pragma mark --- 添加底部的视图
- (void)addDownView {
    
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 50   , MainScreenWidth, 50)];
    _downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downView];
    
    //添加线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_downView addSubview:lineButton];
    
    
    CGFloat ButtonW = MainScreenWidth / 3;
    //    buttonW = ButtonW;
    CGFloat ButtonH = 30;
    
    NSArray *title = @[@"免费",@"",@"购买"];
    NSArray *image = @[@"",@"share@2x",@""];
    
    for (int i = 0 ; i < 3 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * ButtonW, SpaceBaside, ButtonW, ButtonH)];
        [button setTitle:title[i] forState:UIControlStateNormal];
        [button setTitleColor:BlackNotColor forState:UIControlStateNormal];
        [button setImage:Image(image[i]) forState:UIControlStateNormal];
        button.titleLabel.font = Font(13);
        button.tag = i;
        NSLog(@"%ld",button.tag);
        [button addTarget:self action:@selector(downButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_downView addSubview:button];
        
        if (i == 0) {
            _priceButton = button;
        } else if (i == 2) {
            _buyButton = button;
        }
        
    }
    
}




#pragma mark --- 添加控制器

- (void)addControllerSrcollView {
    
    _controllerSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_WZView.frame),  MainScreenWidth, MainScreenHeight * 3 + 500)];
    _controllerSrcollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _controllerSrcollView.pagingEnabled = YES;
    _controllerSrcollView.scrollEnabled = YES;
    _controllerSrcollView.delegate = self;
    _controllerSrcollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * 3,0);
    [self.view addSubview:_controllerSrcollView];
    
    ZhiBoDetailViewController *zhiBoDetailVc= [[ZhiBoDetailViewController alloc] initWithNumID:_ID];
    zhiBoDetailVc.view.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
    [self addChildViewController:zhiBoDetailVc];
    [_controllerSrcollView addSubview:zhiBoDetailVc.view];
    
    ZhiBoClassViewController * zhiBoClassVc = [[ZhiBoClassViewController alloc] initWithNumID:_ID];
    zhiBoClassVc.view.frame = CGRectMake(MainScreenWidth, 0, MainScreenWidth, MainScreenHeight * 2 + 500);
    [self addChildViewController:zhiBoClassVc];
    [_controllerSrcollView addSubview:zhiBoClassVc.view];
    
     LiveDetailCommentViewController *zhiBoCommentVc = [[LiveDetailCommentViewController alloc] initWithType:_ID];
     zhiBoCommentVc.view.frame = CGRectMake(MainScreenWidth * 2, 0, MainScreenWidth, MainScreenHeight * 2 + 500);
     [self addChildViewController:zhiBoCommentVc];
     [_controllerSrcollView addSubview:zhiBoCommentVc.view];

}

#pragma mark --- 分段

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

#pragma mark --- 滚动试图

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat contentCrorX = _controllerSrcollView.contentOffset.x;
    if (contentCrorX < MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 0;
    } else if (contentCrorX < 2 * MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 1;
    } else if (contentCrorX < 3 * MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 2;
    }
    
}



#pragma mark --- 事件监听

- (void)SortButtonClick {//收藏按钮
    //判断是否登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {
        //没有登录的情况下
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }else {
        //已经登录
        [self SYGCollect];
    }
}

- (void)SYGCollect {
    
    QKHTTPManager * manager = [QKHTTPManager manager];
    if ([_collectStr intValue]==1) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:@"2" forKey:@"sctype"];
        [dic setValue:@"0" forKey:@"type"];
        [dic setValue:_ID forKey:@"source_id"];
        if (UserOathToken != nil) {
            [dic setObject:UserOathToken forKey:@"oauth_token"];
            [dic setObject:UserOathTokenSecret forKey:@"oauth_token_secret"];
        } else {
            [MBProgressHUD showError:@"请先登陆" toView:self.view];
            return;
        }
        
        [manager collectLive:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [_zhiBoLikeButton setBackgroundImage:[UIImage imageNamed:@"空心五角星@2x"] forState:UIControlStateNormal];
            [MBProgressHUD showSuccess:@"取消收藏成功" toView:self.view];
            _collectStr = @"0";
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD showError:@"取消收藏失败" toView:self.view];
        }];
    }else if ([_collectStr intValue]==0){
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:@"2" forKey:@"sctype"];
        [dic setValue:@"1" forKey:@"type"];
        [dic setValue:_ID forKey:@"source_id"];
        [dic setObject:UserOathToken forKey:@"oauth_token"];
        [dic setObject:UserOathTokenSecret forKey:@"oauth_token_secret"];
        
        [manager collectLive:dic success:^(AFHTTPRequestOperation *operation, id responseObject){
            [_zhiBoLikeButton setBackgroundImage:[UIImage imageNamed:@"实心五角星@2x"] forState:UIControlStateNormal];
            [MBProgressHUD showSuccess:@"收藏成功" toView:self.view];
            _collectStr = @"1";
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD showError:@"收藏失败" toView:self.view];
        }];
    }
}



- (void)downButtonClick:(UIButton *)button {
    
    if (button.tag == 1) {//分享
         [self shareButtonCilck];
    } else if (button.tag == 2) {//购买
        if ([_buyButton.titleLabel.text isEqualToString:@"购买"]) {
            if (UserOathToken == nil) {
                DLViewController *DLVC = [[DLViewController alloc] init];
                UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
                [self.navigationController presentViewController:Nav animated:YES completion:nil];
                return;
            } else {
                ZhiboPayViewController *payVc = [[ZhiboPayViewController alloc] init];
                payVc.dict = _zhiBoDic;
                payVc.cid = _ID;
                payVc.typeStr = @"直播";
                [self.navigationController pushViewController:payVc animated:YES];
            }
        } else if ([_buyButton.titleLabel.text isEqualToString:@"已经购买"]) {
            [MBProgressHUD showError:@"已经购买过了" toView:self.view];
            return;
        }
    }
}

- (void)shareButtonCilck {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl]];
    
//    NSString *shareUrl = [NSString stringWithFormat:@"http://www.igenwoxue.com/index.php?app=live&mod=Index&act=view&id=%@",_ID];
    
    NSString *str1 = @"app=live&mod=Index&act=view&id=";
    NSString *str2 = [NSString stringWithFormat:@"%@%@",str1,_ID];
    NSString *shareUrl = [NSString stringWithFormat:@"%@%@",basidUrl,str2];
    
    [UMSocialWechatHandler setWXAppId:@"wxbbb961a0b0bf577a" appSecret:@"eb43d9bc799c4f227eb3a56224dccc88" url:shareUrl];
    [UMSocialQQHandler setQQWithAppId:@"1105368823" appKey:@"Q6Q6hJa2Cs8EqtLt" url:shareUrl];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3997129963" secret:@"da07bcf6c9f30281e684f8abfd0b4fca" RedirectURL:shareUrl];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"574e8829e0f55a12f8001790"
                                      shareText:_zhiBoTitle
                                     shareImage:imageView.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:self];
    
}

- (void)buyButtonCilck {//购买
    
    
}
#pragma mark --- 网络请求
- (void)netWorkInfo
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    // 这里应该判断是否已经登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
//        DLViewController *DLVC = [[DLViewController alloc] init];
//        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
//        [self.navigationController presentViewController:Nav animated:YES completion:nil];
//        return;
    } else {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:_ID forKey:@"live_id"];
    NSLog(@"---%@",dic);
    [manager getpublicPort:dic mod:@"Live" act:@"getDetail" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        NSString *msg = responseObject[@"msg"];
        
        if ([responseObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showError:msg  toView:self.view];
            [self backPressed];
            return ;
        }
        
        _zhiBoDic = [responseObject dictionaryValueForKey:@"data"];
        _videoUrl = [[responseObject dictionaryValueForKey:@"data"] stringValueForKey:@"cover"];
        _collectStr = [NSString stringWithFormat:@"%@",[[responseObject dictionaryValueForKey:@"data"] stringValueForKey:@"iscollect"]];
        
        if ([_collectStr integerValue] == 0) {
            [_zhiBoLikeButton setBackgroundImage:[UIImage imageNamed:@"空心五角星@2x"] forState:UIControlStateNormal];
        }else{
            [_zhiBoLikeButton setBackgroundImage:[UIImage imageNamed:@"实心五角星@2x"] forState:UIControlStateNormal];
        }
        
        NSString *moneyStr = [_zhiBoDic stringValueForKey:@"t_price"];
        if ([moneyStr integerValue] == 0) {
            [_priceButton setTitle:@"免费" forState:UIControlStateNormal];
        } else {
            [_priceButton setTitle:[NSString stringWithFormat:@"¥：%@",moneyStr] forState:UIControlStateNormal];
        }

        NSString *numstr = [NSString stringWithFormat:@"%@",[[responseObject dictionaryValueForKey:@"data"] stringValueForKey:@"is_buy"]];
        if ([numstr isEqualToString:@"1"]) {
            
            [_buyButton setTitle:@"已经购买" forState:UIControlStateNormal];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



@end
