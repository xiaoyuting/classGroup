//
//  LiveDetailsViewController.m
//  ChuYouYun
//
//  Created by IOS on 16/7/29.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "LiveDetailsViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "Helper.h"
#import "classDetailMessageVC.h"
#import "noteVC.h"
#import "questionVC.h"
#import "commentVC.h"
#import "MyHttpRequest.h"
#import "teacherList.h"
#import "ZhiyiHTTPRequest.h"
#import "MakeNoteVC.h"
#import "MakeQuestions.h"
#import "SYGNoteViewController.h"
#import "DLViewController.h"
#import "UIColor+HTMLColors.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "UIImageView+WebCache.h"
#import "SYG.h"
#import "ASIHTTPRequest.h"
#import "classDetailMessageVC.h"
#import <EplayerPluginFramework/EPlayerPluginViewController.h>
#import "AppDelegate.h"
#import "RechanrgViewController.h"
#import "characterTableCell.h"
#import "HDZBLiveViewController.h"
#import "BigWindCar.h"
#import "UIImage+WebP.h"
#import "UIButton+WebCache.h"
#import "UMSocial.h"
//支付
#import "AlipayViewController.h"
#import "ClassPayViewController.h"

//机构
#import "InstitutionMainViewController.h"

//支付的弹窗
#import "GLPayView.h"

#import "ZhiyiHTTPRequest.h"

#import "MBProgressHUD+Add.h"

#import "TeacherDetilViewController.h"
#import "LiveDetailTwoViewController.h"
#import "LiveDetailCommentViewController.h"
#import "ZhiboPayViewController.h"




#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4,4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕


#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕

#define iPhone6PlusBIG ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus放大版屏幕
#define SPACE (self.view.frame.size.width-35*3)/3 //间隙


@interface LiveDetailsViewController ()

<UIScrollViewDelegate,UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,UMSocialUIDelegate>{
    
    UIScrollView * _scrollView;
    UIImageView * _arrowImageView;
    UIImageView * imageView;
    UIView * bgView;
    CGRect rect;
    MBProgressHUD * HUD;

    NSMutableDictionary *_dict;
    NSString *_imgUrl;
    BOOL isSecet;
    UILabel *titleLab;
    UIWebView * _webView;
    //判断是否购买
    NSString *_buyMessage;
    CGRect playerFrame;
    int row;
    UIButton *detilBtn;
    UIButton *classBtn;
    UIButton *commentButton;
    NSMutableArray *_dataArray;
    NSMutableArray *_allDataArr;
    
    NSString *_title;
    UILabel *_lab ;
    NSString *_moneyString;
    UIButton *_Starbtn;
    int _lengtn;
    NSString *_OrderNUm;
    UILabel *_OrderLab;
    UILabel *_secondTitleLab;
    UITextView *_texV;
    NSString *_detilString;
    int _flag;
    UIBarButtonItem *_likeButton;
    UIButton *_SYGLikeButton;
    UILabel *_lineLable;
    UILabel *_moneyLab;
    
    //参数
    NSString *_HDtitle;
    NSString *_HDnickName;
    NSString *_HDwatchPassword;
    NSString *_HDroomNumber;
    NSDictionary *dict;
    CGRect _frame;
    BOOL isArgree;
    
    //同意支付协议
    //价格
    UILabel *_agoLab;
    UILabel *_nowlab;
    //课程介绍
  //  UILabel *_ClassDetilLab;
    //讲师介绍
    UITextView *_teacherDetilView;
    
    UIImageView * _useraconImg;
    //标题
    UILabel *_usertitleLab;
    //详情
    UILabel *_userdetilLab;
    //粉丝人数
    UILabel *_fanslLab;

    //机构
    UIImageView *_aconImg;
    //标题
    UILabel *_titleLab;
    //详情
    UILabel *_JGDetilLab;
    //好评度
    UILabel *_priceLab1;
    //好评度
    UILabel *_priceLab2;
    //好评度
    UILabel *_priceLab3;
    
    GLPayView *_payV;
    
    //讲师ID
    NSString *_teacherID;

    
}
@property (nonatomic ,strong)UIView *buyView;
@property (strong ,nonatomic)NSString *alipayStr;

@property (strong ,nonatomic)UIButton *allButton;

@property (strong ,nonatomic)UIButton *DJbutton;
@property (strong ,nonatomic)NSDictionary *moneyDic;
@property (strong ,nonatomic)UIView *allView;
@property (nonatomic ,strong)NSDictionary *userDic;


@property (strong ,nonatomic)UIButton *imgBtn;

@property (strong ,nonatomic)UIButton *buyButton;

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)UITableView *poptableView;

@property (strong ,nonatomic)UIView *counpView;

@property (strong ,nonatomic)NSArray *counpArray;


@end

@implementation LiveDetailsViewController

-(id)initWithMemberId:(NSString *)MemberId andImage:(NSString *)imgUrl andTitle:(NSString *)title andNum:(int)num andprice:(NSString *)price
{
    if (self=[super init]) {
        _cid = MemberId;
        _course_title = title;
        _imgUrl = imgUrl;
        row = num;
        NSString  *a = price;
        NSString *b = [a substringToIndex:0];
        
        if ([b isEqualToString:@"0"]) {

        }else{
        _moneyString = price;
        }
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"options.png"] forBarMetrics:UIBarMetricsDefault];
    
    if (_payV) {
        [_payV removeFromSuperview];
    }
    [self requestData];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = NO;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    //self.navigationController.navigationBar.hidden = NO;
}

-(void)goBuy{
    
    // 这里应该判断是否已经登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        
    }else {

        NSMutableDictionary *buydic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [buydic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [buydic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
        [buydic setValue:[NSString stringWithFormat:@"%@",dict[@"live_id"]] forKey:@"live_id"];

        NSMutableDictionary *YHJdic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [YHJdic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [YHJdic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
        [YHJdic setValue:_cid forKey:@"live_id"];
        //价格
        NSString *price = [NSString stringWithFormat:@"%@",dict[@"price"]];
        
        if ([price doubleValue] == 0) {
            [MBProgressHUD showError:@"免费课程，无需购买" toView:self.view];
            return;
        }
        
        if (_buyButton.tag == 1) {
            [MBProgressHUD showError:@"已经购买过了" toView:self.view];
            return;
        } else {//购买
            ZhiboPayViewController *payVc = [[ZhiboPayViewController alloc] init];
            payVc.dict = dict;
            payVc.cid = _cid;
            payVc.typeStr = @"直播";
            [self.navigationController pushViewController:payVc animated:YES];
            
        }
    }
}

//购买课程
- (void)buyClass {
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:_cid forKey:@"vids"];
    if (_buyButton.tag == 1) {
        
    }else{
//        [self SYGBuy];
    }
    return;
}

- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
    
}

-(void)shoucang{
    
    //判断是否登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {
        
        //没有登录的情况下
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        
    }else {
        
        //已经登录
        [_SYGLikeButton setBackgroundImage:[UIImage imageNamed:@"空心五角星@2x"] forState:UIControlStateNormal];
        _likeButton = [[UIBarButtonItem alloc] initWithCustomView:_SYGLikeButton];
        self.navigationItem.rightBarButtonItem = _likeButton;
        // [self SYGCollect];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self requestData];
    _lineLable = [[UILabel alloc]init];
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    _dataArray = [[NSMutableArray alloc]init];
    _allDataArr = [[NSMutableArray alloc]init];
    rect = [UIScreen mainScreen].applicationFrame;
    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 0, 30)];
    titleText.backgroundColor = [UIColor clearColor];
    titleText.textColor=[UIColor blackColor];
    [titleText setFont:[UIFont systemFontOfSize:15]];
    NSLog(@"%@",_course_title);
    self.navigationItem.titleView=titleText;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 230, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,216)];
    if (!_course_title) {
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
    }else{
        [backButton setTitle:_course_title forState:UIControlStateNormal];
    }
    [backButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    //设置button上字体的偏移量
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10.0 , 0.0, 0)];

    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:back];
    //收藏按钮
    _SYGLikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _SYGLikeButton.frame = CGRectMake(0, 0, 20, 20);
    [_SYGLikeButton addTarget:self action:@selector(likeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self shoucang];
    
    //=============================
    _imgBtn = [[UIButton alloc]init];
    [self addPlayer];
    
    UIImageView *imageviews = [[UIImageView alloc]initWithFrame:_imgBtn.frame];
    [imageviews sd_setImageWithURL:[NSURL URLWithString:_imgUrl] placeholderImage:[UIImage imageNamed:@"站位图"]];
    [self.view addSubview:imageviews];
    [self.view addSubview:_imgBtn];
    //[_imgBtn addTarget:self action:@selector(gogolive) forControlEvents:UIControlEventTouchUpInside];
    _imgBtn.backgroundColor = [UIColor clearColor];
    [imageviews setContentMode:UIViewContentModeScaleAspectFill];
    imageviews.clipsToBounds = YES;
    [self addPlayer];
    self.view.backgroundColor = [UIColor whiteColor];
    titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _imgBtn.frame.size.height+_imgBtn.frame.origin.y, MainScreenWidth, 36)];
    // titleLab.text = @"详情";
    titleLab.textColor = [UIColor colorWithHexString:@"#2069cf"];
    [self.view addSubview:titleLab];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:14];
    
    CGFloat buttonW = MainScreenWidth /  3;
    CGFloat buttonH = 30;
    
    //添加课程按钮
    detilBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, _imgBtn.frame.size.height+_imgBtn.frame.origin.y, buttonW, buttonH)];
    [detilBtn setTitleColor:[UIColor colorWithHexString:@"#2069cf"] forState:UIControlStateNormal];
    [detilBtn setTitle:@"课程" forState:UIControlStateNormal];
    [self.view addSubview:detilBtn];
    [detilBtn addTarget:self action:@selector(move:) forControlEvents:UIControlEventTouchUpInside];
    detilBtn.tag = 1;
    detilBtn.titleLabel.font = Font(14);
    detilBtn.backgroundColor = [UIColor whiteColor];
    
    //添加详情按钮
    classBtn = [[UIButton alloc]initWithFrame:CGRectMake(buttonW, _imgBtn.frame.size.height+_imgBtn.frame.origin.y, buttonW, buttonH)];
    [classBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [classBtn setTitle:@"详情" forState:UIControlStateNormal];
    [self.view addSubview:classBtn];
    classBtn.backgroundColor = [UIColor whiteColor];
    [classBtn addTarget:self action:@selector(move:) forControlEvents:UIControlEventTouchUpInside];
    classBtn.tag = 2;
    classBtn.titleLabel.font = Font(14);
    
    
    //评论按钮
    commentButton = [[UIButton alloc]initWithFrame:CGRectMake(buttonW * 2, _imgBtn.frame.size.height+_imgBtn.frame.origin.y, buttonW, buttonH)];
    [commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commentButton setTitle:@"点评" forState:UIControlStateNormal];
    [self.view addSubview:commentButton];
    [commentButton addTarget:self action:@selector(move:) forControlEvents:UIControlEventTouchUpInside];
    commentButton.tag = 3;
    commentButton.titleLabel.font = Font(14);
    commentButton.backgroundColor = [UIColor whiteColor];
    
    
    _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(90,classBtn.frame.size.height+classBtn.frame.origin.y, 50, 5)];
//    _arrowImageView.image = [UIImage imageNamed:@"尖角.png"];
//    CGPoint center = _arrowImageView.center;
//    center.x = MainScreenWidth / 4;
//    _arrowImageView.center = center;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,classBtn.frame.size.height+classBtn.frame.origin.y, MainScreenWidth,MainScreenHeight - classBtn.frame.size.height - classBtn.frame.origin.y  - 36)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.alwaysBounceVertical = NO;

    //同时单方向滚动
    _scrollView.directionalLockEnabled = YES;
    _scrollView.contentSize = CGSizeMake(MainScreenWidth * 3, MainScreenHeight);
    _scrollView.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:_scrollView];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
//    [self creatscrollow];
    [self addTableView];
    
    [self addLiveDetailTwo];
    
    [self addLiveDetailComment];
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth,0,MainScreenWidth, 0.5)];
    lineLab.backgroundColor = [UIColor lightGrayColor];
    lineLab.alpha = 0.8;

    [_scrollView addSubview:lineLab];
    [self.view addSubview:_arrowImageView];
    
    //悬浮按钮
    _buyButton = [[UIButton alloc] init];
    [self addPlayer];
    [_buyButton addTarget:self action:@selector(goBuy) forControlEvents:UIControlEventTouchUpInside];
    
    _lineLable.frame = CGRectMake(100, classBtn.frame.size.height+classBtn.frame.origin.y -2, 40, 2);
    CGPoint center = _lineLable.center;
    center.x = MainScreenWidth / 6;
    _lineLable.center = center;
    _lineLable.backgroundColor = [UIColor colorWithHexString:@"#2069CF"];
    [self.view addSubview:_lineLable];
    
    UIView *View = [[UIView alloc]initWithFrame:CGRectMake(0, MainScreenHeight - 36, MainScreenWidth, 36)];
    [self.view addSubview:View];
    View.backgroundColor = [UIColor redColor];
    View.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    
    _moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth / 3, 36)];
    [View addSubview:_moneyLab];
    _moneyLab.textColor = [UIColor colorWithHexString:@"#2069CF"];
    
    NSString  *a = _moneyString;
    NSString *b = [a substringToIndex:1];
    NSLog(@"%@",b);
    
    if ([b isEqualToString:@"0"]) {
        _moneyLab.text = @"免费";
    }else{
        _moneyLab.text = [NSString stringWithFormat:@"¥ %@",_moneyString];
    }
    _moneyLab.textAlignment = NSTextAlignmentCenter;
    _moneyLab.font = [UIFont systemFontOfSize:17];
    
    //添加分享的按钮
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 3, 0, MainScreenWidth / 3, 36)];
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    shareButton.titleLabel.font = Font(14);
    [shareButton setImage:Image(@"share@2x") forState:UIControlStateNormal];
    shareButton.imageEdgeInsets =  UIEdgeInsetsMake(0,0,20,0);
    shareButton.titleEdgeInsets = UIEdgeInsetsMake(16, -30, 0, 20);
    [View addSubview:shareButton];
    [shareButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    
    
    [View addSubview:_buyButton];
    _buyButton.frame = CGRectMake(MainScreenWidth / 3 * 2, 0, MainScreenWidth / 3, 36);
    _buyButton.backgroundColor = [UIColor colorWithHexString:@"#2069CF"];
    [_buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    _buyButton.titleLabel.font = [UIFont systemFontOfSize:17];
    _moneyLab.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _scrollView.backgroundColor = [UIColor whiteColor];
}


- (void)addLiveDetailTwo {
    LiveDetailTwoViewController * liveDetailVc = [[LiveDetailTwoViewController alloc]initWithType:_cid];
    liveDetailVc.view.frame = CGRectMake(MainScreenWidth, 0, MainScreenWidth, _scrollView.frame.size.height );
    [self addChildViewController:liveDetailVc];
    [_scrollView addSubview:liveDetailVc.view];
    
}

- (void)addLiveDetailComment {
    
    LiveDetailCommentViewController *commentVc = [[LiveDetailCommentViewController alloc] initWithType:_cid];
    commentVc.view.frame = CGRectMake(MainScreenWidth * 2, 0, MainScreenWidth, _scrollView.frame.size.height);
    [self addChildViewController:commentVc];
    [_scrollView addSubview:commentVc.view];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView{
//    int num = 1;
//    if ([scrollView isEqual:_scrollView]) {
////         num = scrollView.contentOffset.x/MainScreenWidth;
//    }
//    NSLog(@"%d",num);
//    CGPoint center = _lineLable.center;
//    center.x = MainScreenWidth / 4 + num * MainScreenWidth/2 +1;
//    _lineLable.center = center;
    
    
    CGPoint point = scrollView.contentOffset;
    
    
    
    if (point.x == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            [detilBtn setTitleColor:[UIColor colorWithHexString:@"#2069cf"] forState:UIControlStateNormal];
            [classBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            CGPoint center = _arrowImageView.center;
            center.x = MainScreenWidth / 6;
//            _arrowImageView.center = center;
            _scrollView.contentOffset = CGPointMake(0, 0);
            _lineLable.center = center;
            if (iPhone5o5Co5S) {
                _lineLable.center = CGPointMake(center.x, center.y - 5);
            }
        }];
    }else if (point.x >= MainScreenWidth && point.x < MainScreenWidth * 2){
        [UIView animateWithDuration:0.3 animations:^{
            [classBtn setTitleColor:[UIColor colorWithHexString:@"#2069cf"] forState:UIControlStateNormal];
            [detilBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            CGPoint center = _arrowImageView.center;
            center.x = MainScreenWidth / 2;
//            _arrowImageView.center = center;
            _lineLable.center = center;
            if (iPhone5o5Co5S) {
                _lineLable.center = CGPointMake(center.x, center.y - 5);
            }

        }];
    } else if (point.x >= MainScreenWidth * 2 && point.x < MainScreenWidth * 3) {
        [UIView animateWithDuration:0.3 animations:^{
            [classBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [detilBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [commentButton setTitleColor:[UIColor colorWithHexString:@"#2069cf"] forState:UIControlStateNormal];
            CGPoint center = _arrowImageView.center;
            center.x = MainScreenWidth / 6 * 5;
//            _lineLable.center = center;
            _arrowImageView.center = center;
            if (iPhone5o5Co5S) {
                _lineLable.center = CGPointMake(center.x, center.y - 5);
            }
            _scrollView.contentOffset = CGPointMake(MainScreenWidth * 2, 0);
        }];

    }
}

-(void)move:(UIButton *)sender{
    
    // 这里应该判断是否已经登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
//        DLViewController *DLVC = [[DLViewController alloc] init];
//        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
//        [self.navigationController presentViewController:Nav animated:YES completion:nil];
//        return;
    }
    if (sender.tag==1) {
        
        [UIView animateWithDuration:0.0 animations:^{
            
            [detilBtn setTitleColor:[UIColor colorWithHexString:@"#2069cf"] forState:UIControlStateNormal];
            [classBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            CGPoint center = _arrowImageView.center;
//            center.x = MainScreenWidth / 4;
//            _arrowImageView.center = center;
           _scrollView.contentOffset = CGPointMake(0, 0);
            CGPoint center = _lineLable.center;
            center.x = MainScreenWidth / 6 ;
            _lineLable.center = center;
        }];
        
    }else if (sender.tag == 2){
        
        [UIView animateWithDuration:0.0 animations:^{
            
            [classBtn setTitleColor:[UIColor colorWithHexString:@"#2069cf"] forState:UIControlStateNormal];
            [detilBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            CGPoint center = _arrowImageView.center;
//            center.x = 3*MainScreenWidth / 4;
//            _arrowImageView.center = center;
            _scrollView.contentOffset = CGPointMake(MainScreenWidth, 0);
            CGPoint center = _lineLable.center;
            center.x = MainScreenWidth / 2;
            _lineLable.center = center;
        }];
    } else if (sender.tag == 3) {
        [UIView animateWithDuration:0.0 animations:^{
            
            [classBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [detilBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [commentButton setTitleColor:[UIColor colorWithHexString:@"#2069cf"] forState:UIControlStateNormal];
            _scrollView.contentOffset = CGPointMake(MainScreenWidth * 2, 0);
            CGPoint center = _lineLable.center;
            center.x = MainScreenWidth / 6 * 5;
            _lineLable.center = center;
        }];

    }
}

-(void)backBtn{
    
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"backBtnClick" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)gogolive{
    
    // 这里应该判断是否已经登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        
    }else {
        
        if (_buyButton.tag == 1) {//购买的
            
           // HDZBLiveViewController *hdzb = [[HDZBLiveViewController alloc]initwithTitle:<#(NSString *)#> nickName:<#(NSString *)#> watchPassword:<#(NSString *)#> roomNumber:<#(NSString *)#>];
           // [self.navigationController pushViewController:hdzb animated:YES];
            
//                        EPlayerData *playerData =[[EPlayerData alloc] init];
//            
//                        playerData.liveClassroomId = @"5790dcc95081bffb1b0093ba";
//            
//                        playerData.customer = @"seition";
//            
//                        playerData.loginType = EPlayerLoginTypeNone;
//
//                        EPlayerPluginViewController *controller = [[EPlayerPluginViewController alloc] initPlayer:playerData];
//                        //self.navigationController.navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"圆角矩形-1@2x"]];
//                        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar"] forBarMetrics:UIBarMetricsDefault];
//                        [self.navigationController pushViewController:controller animated:YES];
            
        }else{
            
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText =@"您尚未购买，请购买后观看";
            HUD.minShowTime = 1.0;
            HUD.removeFromSuperViewOnHide = YES;
            [HUD show:YES];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:@"您尚未购买，请购买后观看" toView:self.view];
        }
    }
}

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, _scrollView.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    [_scrollView addSubview:_tableView];
    //_tableView.separatorStyle = UITableViewCellSelectionStyleNone;
}

//滚动视图
-(void)creatscrollow{
    
    UIScrollView *detilScrollow = [[UIScrollView alloc]initWithFrame:CGRectMake(MainScreenWidth, 0, MainScreenWidth, _scrollView.current_h)];
    detilScrollow.delegate = self;
    detilScrollow.alwaysBounceVertical = NO;
    
    //同时单方向滚动
    detilScrollow.directionalLockEnabled = YES;
    detilScrollow.contentSize = CGSizeMake(0, 500);
    detilScrollow.contentOffset = CGPointMake(0, 0);
    [_scrollView addSubview:detilScrollow];
    detilScrollow.showsVerticalScrollIndicator = NO;
    detilScrollow.showsHorizontalScrollIndicator = NO;
    detilScrollow.delegate = self;
    
    //添加评分文本
    UILabel *PFLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 50, 40)];
    PFLabel.text = @"评分：";
    PFLabel.font = [UIFont systemFontOfSize:15];
    PFLabel.textColor = [UIColor colorWithRed:170.f / 255 green:170.f / 255 blue:170.f / 255 alpha:1];
    [detilScrollow addSubview:PFLabel];
    _Starbtn = [[UIButton alloc] initWithFrame:CGRectMake(PFLabel.frame.size.width+PFLabel.frame.origin.x, 14, 80, 12)];
    [detilScrollow addSubview:_Starbtn];
    _OrderLab = [[UILabel alloc]initWithFrame:CGRectMake(_Starbtn.frame.size.width+_Starbtn.frame.origin.x +60, 14, 120, 12)];
    _OrderLab.textColor = [UIColor colorWithRed:170.f / 255 green:170.f / 255 blue:170.f / 255 alpha:1];
    _OrderLab.font = [UIFont systemFontOfSize:15];
    [detilScrollow addSubview:_OrderLab];
    UIView *backLab = [[UIView alloc]initWithFrame:CGRectMake(0, _Starbtn.frame.size.height+_Starbtn.frame.origin.y +20 , MainScreenWidth, 35)];
    [detilScrollow addSubview:backLab];
    backLab.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _secondTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, MainScreenWidth - 10, 35)];
    _secondTitleLab.textColor = [UIColor blackColor];
    _secondTitleLab.font = [UIFont systemFontOfSize:15];
    [backLab addSubview:_secondTitleLab];
    _secondTitleLab.text = _course_title;
    
    //价格
    _nowlab = [[UILabel alloc]initWithFrame:CGRectMake(10, backLab.frame.size.height +backLab.frame.origin.y +5, 80, 30)];
    [detilScrollow addSubview:_nowlab];
    _nowlab.textColor = BasidColor;
//    _nowlab.text = @"¥1.0";
    _nowlab.font = Font(16);

    //价格
    _agoLab = [[UILabel alloc]initWithFrame:CGRectMake(_nowlab.current_x_w, backLab.frame.size.height +backLab.frame.origin.y +5, 150, 30)];
    [detilScrollow addSubview:_agoLab];
    _agoLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _agoLab.font = Font(13);

   UILabel *headerlab = [[UILabel alloc]initWithFrame:CGRectMake(_nowlab.current_x, _nowlab.current_y_h+8, 3, 20)];
    [detilScrollow addSubview:headerlab];
    headerlab.backgroundColor = BasidColor;
    
    UILabel *classlab = [[UILabel alloc]initWithFrame:CGRectMake(headerlab.current_x +10, headerlab.current_y - 5, 100, 30)];
    [detilScrollow addSubview:classlab];
    classlab.text = @"课程信息";
    classlab.font = Font(14);
    classlab.textColor = [UIColor blackColor];
    
    //课程详情
    _texV = [[UITextView alloc]initWithFrame:CGRectMake(classlab.current_x, classlab.frame.size.height +classlab.frame.origin.y , MainScreenWidth - 20, 80)];
      [detilScrollow addSubview:_texV];
    _texV.textColor = [UIColor blackColor];
    _texV.editable = NO;

    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, _texV.current_y_h, MainScreenWidth, 0.45)];
    line.backgroundColor = [UIColor grayColor];
    [detilScrollow addSubview:line];
    
    //讲师
    UILabel *teacherLab = [[UILabel alloc]initWithFrame:CGRectMake(_nowlab.current_x, line.current_y_h+8, 3, 20)];
    [detilScrollow addSubview:teacherLab];
    teacherLab.backgroundColor = BasidColor;
    
    UILabel *teacherDetilLab = [[UILabel alloc]initWithFrame:CGRectMake(headerlab.current_x +10, teacherLab.current_y - 5, 100, 30)];
    [detilScrollow addSubview:teacherDetilLab];
    teacherDetilLab.text = @"讲师介绍";
    teacherDetilLab.font = Font(14);
    teacherDetilLab.textColor = [UIColor blackColor];
    
    _teacherDetilView = [[UITextView alloc]initWithFrame:CGRectMake(classlab.current_x, teacherDetilLab.frame.size.height +teacherDetilLab.frame.origin.y , MainScreenWidth - 20, 80)];
//    _teacherDetilView.editable = NO;
//
//    [detilScrollow addSubview:_teacherDetilView];
//    _teacherDetilView.textColor = [UIColor colorWithHexString:@"#333333"];
//    _teacherDetilView.font = Font(13);
//    _teacherDetilView.textAlignment = NSTextAlignmentLeft;
//    _teacherDetilView.text = @"测试直播教育";
    
    _useraconImg = [[UIImageView alloc]initWithFrame:CGRectMake(teacherDetilLab.current_x, teacherDetilLab.current_y_h + 10, 70, 70)];
    _useraconImg.image = [UIImage imageNamed:@"站位图.png"];
    [detilScrollow addSubview:_useraconImg];
    
    //详情
    _usertitleLab = [[UILabel alloc]initWithFrame:CGRectMake(_useraconImg.current_x_w + 10, _useraconImg.current_y - 5, 100, 20)];
    _usertitleLab.textAlignment = NSTextAlignmentLeft;
    _usertitleLab.textColor = BasidColor;
    [detilScrollow addSubview:_usertitleLab];
    _usertitleLab.font = Font(14);
    _usertitleLab.text = @"ET教育";
    
    _userdetilLab = [[UILabel alloc]initWithFrame:CGRectMake(_useraconImg.current_x_w + 10, _usertitleLab.current_y_h + 3, MainScreenWidth - _useraconImg.current_x_w - 20, 30)];
    _userdetilLab.textAlignment = NSTextAlignmentLeft;
    _userdetilLab.textColor = [UIColor grayColor];
    [detilScrollow addSubview:_userdetilLab];
    _userdetilLab.font = Font(13);
    _userdetilLab.text = @"ET教育教育教育教育教育教育教育教育";
    
    //粉丝
    _fanslLab = [[UILabel alloc]initWithFrame:CGRectMake(_useraconImg.current_x_w + 10, _userdetilLab.current_y_h + 5, 100, 20)];
    _fanslLab.textAlignment = NSTextAlignmentLeft;
    _fanslLab.textColor = [UIColor grayColor];
    [detilScrollow addSubview:_fanslLab];
    _fanslLab.font = Font(14);
    _fanslLab.text = @"ET教育";
    
    UIButton *teacherbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, _useraconImg.current_y, MainScreenWidth, _useraconImg.current_h)];
    [detilScrollow addSubview:teacherbtn];
    [teacherbtn addTarget:self action:@selector(goTE) forControlEvents:UIControlEventTouchUpInside];
    teacherbtn.backgroundColor = [UIColor clearColor];
    
    
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, _useraconImg.current_y_h+10, MainScreenWidth, 0.45)];
    line1.backgroundColor = [UIColor grayColor];
    [detilScrollow addSubview:line1];
    
    //机构
    UILabel *JGLab = [[UILabel alloc]initWithFrame:CGRectMake(_nowlab.current_x, line1.current_y_h+8, 3, 20)];
    [detilScrollow addSubview:JGLab];
    JGLab.backgroundColor = BasidColor;
    
    UILabel *JGDELab = [[UILabel alloc]initWithFrame:CGRectMake(headerlab.current_x +10, JGLab.current_y - 5, 100, 30)];
    [detilScrollow addSubview:JGDELab];
    JGDELab.text = @"机构信息";
    JGDELab.font = Font(14);
    JGDELab.textColor = [UIColor blackColor];
    
    _aconImg = [[UIImageView alloc]initWithFrame:CGRectMake(JGDELab.current_x, JGDELab.current_y_h + 10, 70, 70)];
    _aconImg.image = [UIImage imageNamed:@"站位图.png"];
    [detilScrollow addSubview:_aconImg];
    
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(_aconImg.current_x_w + 10, _aconImg.current_y - 5, 100, 20)];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.textColor = BasidColor;
    [detilScrollow addSubview:_titleLab];
    _titleLab.font = Font(14);
    _titleLab.text = @"ET教育";
    
    _JGDetilLab = [[UILabel alloc]initWithFrame:CGRectMake(_aconImg.current_x_w + 10, _titleLab.current_y_h, MainScreenWidth - _aconImg.current_x_w - 20, 30)];
    _JGDetilLab.textAlignment = NSTextAlignmentLeft;
    _JGDetilLab.textColor = BlackNotColor;
    _JGDetilLab.numberOfLines = 2;
    _JGDetilLab.font = Font(12);

    [detilScrollow addSubview:_JGDetilLab];
    _JGDetilLab.text = @"ET教育ET教育ET教育ET教育ET教育ET教育ET教育ET教ET教育ET教育育";
    
    _priceLab1 = [[UILabel alloc]initWithFrame:CGRectMake(_aconImg.current_x_w + 10, _JGDetilLab.current_y_h + 5, (MainScreenWidth - _aconImg.current_x_w - 10)/3, 20)];
    _priceLab1.textColor = [UIColor grayColor];
    [detilScrollow addSubview:_priceLab1];
    _priceLab1.font = Font(13);
    _priceLab1.textAlignment = NSTextAlignmentLeft;

    _priceLab2 = [[UILabel alloc]initWithFrame:CGRectMake(_priceLab1.current_x_w, _JGDetilLab.current_y_h + 5, (MainScreenWidth - _aconImg.current_x_w - 10)/3, 20)];
    _priceLab2.textColor = [UIColor grayColor];
    [detilScrollow addSubview:_priceLab2];
    _priceLab2.font = Font(13);
    _priceLab2.textAlignment = NSTextAlignmentLeft;

    _priceLab3 = [[UILabel alloc]initWithFrame:CGRectMake(_priceLab2.current_x_w, _JGDetilLab.current_y_h + 5, (MainScreenWidth - _aconImg.current_x_w - 10)/3, 20)];
    _priceLab3.textColor = [UIColor grayColor];
    [detilScrollow addSubview:_priceLab3];
    _priceLab3.font = Font(13);
    _priceLab3.textAlignment = NSTextAlignmentLeft;

    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, _aconImg.current_y, MainScreenWidth, _aconImg.current_h)];
    [detilScrollow addSubview:btn];
    [btn addTarget:self action:@selector(goJG) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor clearColor];
    [self star];
}

//去讲师详情
-(void)goTE{
    
    TeacherDetilViewController *TDV = [[TeacherDetilViewController alloc]initWithNumID:_teacherID];
    [self.navigationController pushViewController:TDV animated:YES];
}

//去机构
-(void)goJG{
    
    InstitutionMainViewController*instVc = [[InstitutionMainViewController alloc] init];
    instVc.schoolID =  [NSString stringWithFormat:@"%@",dict[@"school_info"][@"school_id"]];
    instVc.uID = [NSString stringWithFormat:@"%@",dict[@"school_info"][@"uid"]];
    [self.navigationController pushViewController:instVc animated:YES];
}

-(void)star{
    
    NSString  *a = _moneyString;
    NSString *b = [a substringToIndex:1];
    NSLog(@"%@",b);
    if ([b isEqualToString:@"0"]) {
        _nowlab.text = @"  免费";
    }else{
    _nowlab.text = [NSString stringWithFormat:@"¥ %@",_moneyString];
    }
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSString *tempStr =[NSString stringWithFormat:@"%@",dict[@"t_price"]];
    NSString *v_price = [NSString stringWithFormat:@"原价：¥：%@",tempStr];
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:v_price attributes:attribtDic];
    _agoLab.attributedText = attribtStr;
    
    //讲师
    _usertitleLab.text = [NSString stringWithFormat:@"%@",dict[@"school_info"][@"user_info"][@"uname"]];
    _userdetilLab.text = [NSString stringWithFormat:@"%@",dict[@"school_info"][@"user_info"][@"intro"]];
//    _fanslLab.text  = [NSString stringWithFormat:@"粉丝：%@人",dict[@"school_info"][@"follow_state"][@"follower"]];
    [_useraconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict[@"school_info"][@"user_info"][@"avatar_big"]]]];
    
    //机构
    [_aconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict[@"school_info"][@"cover"]]]];
    _titleLab.text = [NSString stringWithFormat:@"%@",dict[@"school_info"][@"title"]];
    NSString *Tstr = [NSString stringWithFormat:@"%@",dict[@"school_info"][@"info"]];
    NSString *detile = Tstr;
    detile = [detile stringByReplacingOccurrencesOfString: @"\n" withString: @""];
    detile = [detile stringByReplacingOccurrencesOfString: @"\r" withString: @""];
    detile = [detile stringByReplacingOccurrencesOfString:@" " withString:@""];
    detile = [detile stringByTrimmingCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    _texV.text = detile;
    _texV.text = _detilString;

    NSString *strUrl = [self filterHTML:_detilString];
    strUrl = [strUrl stringByReplacingOccurrencesOfString: @"\n" withString: @""];
    strUrl = [strUrl stringByReplacingOccurrencesOfString: @"\r" withString: @""];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
    strUrl = [strUrl stringByTrimmingCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    _teacherDetilView.text = strUrl;
    _OrderLab.text = [NSString stringWithFormat:@"购买人数：%@",_OrderNUm];

    _JGDetilLab.text = detile;
    _priceLab1.text = [NSString stringWithFormat:@"好评度：%@",dict[@"school_info"][@"count"][@"comment_rate"]];
    _priceLab2.text = [NSString stringWithFormat:@" 课程数：%@",dict[@"school_info"][@"count"][@"video_count"]];
    _priceLab3.text = [NSString stringWithFormat:@"%@ 次学习",dict[@"school_info"][@"count"][@"learn_count"]];

    int length = _lengtn;
    if (length == 1) {
        [_Starbtn setBackgroundImage:[UIImage imageNamed:@"101@2x"] forState:UIControlStateNormal];
    }
    if (length == 2) {
        [_Starbtn setBackgroundImage:[UIImage imageNamed:@"102@2x"] forState:UIControlStateNormal];
    } else {
        [_Starbtn setBackgroundImage:[UIImage imageNamed:@"100@2x"] forState:UIControlStateNormal];
    }
    if (length == 3) {
        [_Starbtn setBackgroundImage:[UIImage imageNamed:@"103@2x"] forState:UIControlStateNormal];
    }
    if (length == 4) {
        [_Starbtn setBackgroundImage:[UIImage imageNamed:@"104@2x"] forState:UIControlStateNormal];
    }
    if (length == 5) {
        [_Starbtn setBackgroundImage:[UIImage imageNamed:@"105@2x"] forState:UIControlStateNormal];
    }
}

//进入直播的图片
- (void)addPlayer {
    
    //添加箭头等
    if (iPhone4SOriPhone4) {
        //创建播放器
        _imgBtn.frame = CGRectMake(0, 64, MainScreenWidth,MainScreenWidth*3/5);
       // _buyButton.frame = CGRectMake(MainScreenWidth - 70, titleLab.frame.origin.y+titleLab.frame.origin.x+50, 40,40);
        
    }else if (iPhone5o5Co5S) {
            //创建播放器
            _imgBtn.frame = CGRectMake(0, 64, MainScreenWidth,MainScreenWidth*3/5);
           // _buyButton.frame = CGRectMake(MainScreenWidth - 70, MainScreenHeight - 290 + 64, 40,40);
        }
        else if(iPhone6)
        {
            //创建播放器
            _imgBtn.frame = CGRectMake(0, 64, MainScreenWidth, MainScreenWidth *3/5);
           // _buyButton.frame = CGRectMake(MainScreenWidth - 70, MainScreenHeight - 310 + 64, 50,50);
      }
        else if(iPhone6Plus)
        {
            //创建播放器
            _imgBtn.frame = CGRectMake(0, 64, MainScreenWidth, MainScreenWidth*3/4);
           // _buyButton.frame = CGRectMake(MainScreenWidth - 60, MainScreenHeight - 310 + 64, 50,50);
        }else {//ipad 适配
            
            //创建播放器
            _imgBtn.frame = CGRectMake(0, 64, MainScreenWidth, MainScreenWidth*3/5);
            _buyButton.frame = CGRectMake(MainScreenWidth - 60, MainScreenHeight - 310 + 64, 50,50);
        }
}

- (void)requestData
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

    [dic setValue:_cid forKey:@"live_id"];
    NSLog(@"---%@",dic);
    [manager getpublicPort:dic mod:@"Live" act:@"getDetail" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        NSString *msg = responseObject[@"msg"];
        
        if ([responseObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showError:msg  toView:self.view];
            [self backBtn];
            return ;
        }
        
        dict = responseObject[@"data"];
        _teacherID = [NSString stringWithFormat:@"%@",dict[@"teacher_id"]];
        NSLog(@"%@",_teacherID);
        _collectStr = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"iscollect"]];
        if ([_collectStr isEqualToString:@"0"]) {
            [_SYGLikeButton setBackgroundImage:[UIImage imageNamed:@"空心五角星@2x"] forState:UIControlStateNormal];
        }else{
            [_SYGLikeButton setBackgroundImage:[UIImage imageNamed:@"实心五角星@2x"] forState:UIControlStateNormal];
        }
        NSString  *a = _moneyString;
        NSString *b = [a substringToIndex:1];
        
        
        if ([b isEqualToString:@"0"]) {
            _moneyLab.text = @"免费";
        }else{
            _moneyLab.text = [NSString stringWithFormat:@"¥ %@",_moneyString];
        }
        NSString * starStr = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"score"]];
        _lengtn = [starStr intValue];
//        _OrderNUm = responseObject[@"data"][@"school_info"][@"count"][@"follower_count"];
        //_detilStringcomment_star
        _detilString = [self filterHTML:responseObject[@"data"][@"video_intro"]];
        
        _texV.text = _detilString;
        
        [_allDataArr removeAllObjects];
        [_allDataArr addObjectsFromArray:responseObject[@"data"]];
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:responseObject[@"data"][@"sections"]];

        NSString *numstr = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"is_buy"]];
        [_tableView reloadData];
        
        if ([numstr isEqualToString:@"1"]) {
            
            [_buyButton setTitle:@"已经购买" forState:UIControlStateNormal];
            _buyButton.tag = 1;
            [_tableView reloadData];
        }
        
        [self requestTeacherData];
        
        [self star];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

#pragma mark --- 事件监听
- (void)shareButtonCilck {
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"574e8829e0f55a12f8001790"
                                      shareText:[NSString stringWithFormat:@"我正在云课堂课堂app观看直播—%@视频地址%@",_videoTitle,_video_address]
                                     shareImage:[UIImage imageNamed:@"chuyou.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToRenren,nil]
                                       delegate:self];
    

    
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
    needMoney.text = [NSString stringWithFormat:@"该专辑需支付:  %@ ¥",dict[@"price"]];
    [_buyView addSubview:needMoney];
    
    //使用优惠券
    UILabel *counpLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 80, BuyViewW - 40, 20)];
    counpLabel.text = @"使用优惠券：";
    counpLabel.font = Font(15);
    [_buyView addSubview:counpLabel];
    
    //选择的按钮
    UIButton *counpButton = [[UIButton alloc] initWithFrame:CGRectMake(BuyViewW - 30, 80, 20, 20)];
    [counpButton setImage:Image(@"灰色乡下") forState:UIControlStateNormal];
    [counpButton addTarget:self action:@selector(counpButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    counpButton.tag = 0;
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
    
    _poptableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    _poptableView.delegate = self;
    _poptableView.dataSource = self;
    _poptableView.rowHeight = 50;
    _poptableView.tag = 1230;
    _poptableView.backgroundColor = [UIColor whiteColor];
    _frame = CGRectMake(counpLabel.current_x, counpLabel.current_y_h, counpLabel.current_w, 300);
    [_buyView addSubview:_poptableView];
    //这里获取优惠券的数据
    [self NetWorkGetMyCouponList];
}

#pragma mark --- 获取优惠券的类型
- (void)NetWorkGetMyCouponList {

    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setValue:_cid forKey:@"live_id"];
    
    [manager getpublicPort:dic mod:@"Live" act:@"getCanUseCouponList" success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if ([responseObject[@"code"] integerValue] == 1) {
            
            _counpArray = responseObject[@"data"];

        } else {
            
            _counpArray = nil;
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)counpButtonClick:(UIButton *)sender {
    
    if (!_counpArray.count) {
        [MBProgressHUD showError:@"没有可使用的优惠券" toView:self.view];
        return;
    }

    if (_poptableView) {
        if (_poptableView.frame.origin.x==0) {
            _poptableView.frame = _frame;
        }else{
            _poptableView.frame = CGRectMake(0, 0, 0, 0);
        }
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

- (void)pressed:(UIButton *)button {
    
    NSInteger Num = button.tag;
    if (Num == 1104 ) {//支付宝
        
        if (isArgree == NO) {
            [MBProgressHUD showError:@"请先同意协议" toView:self.view];
            return;
            
        } else {
            
            [self LiveAlipay];
        }
    } else if (Num == 1105) {//微信
        
        if (isArgree == NO) {
            [MBProgressHUD showError:@"请先同意协议" toView:self.view];
            return;
            
        } else {
            //            AlipayViewController *alipayVc = [[AlipayViewController alloc] init];
            //            [self.navigationController pushViewController:alipayVc animated:YES];
        }
    } else if (Num == 1106) {//取消
  
    }
    [self MissBuyView];
}

//购买课程 获取支付的链接
- (void)LiveAlipay {
    
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    } else {
        [MBProgressHUD showError:@"请先登陆" toView:self.view];
        return;
    }
   // [dic setValue:@"alipay" forKey:@"pay_for"];
    [dic setValue:[NSString stringWithFormat:@"%@",dict[@"live_id"]] forKey:@"live_id"];

    [manager getpublicPort:dic mod:@"Live" act:@"buyOperating" success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"is_free"] integerValue] == 0 ) {
                
                //不是免费
                _alipayStr = responseObject[@"data"][@"alipay"][@"ios"];
                AlipayViewController *alipayVc = [[AlipayViewController alloc] init];
                alipayVc.payStr = _alipayStr;
                [self.navigationController pushViewController:alipayVc animated:YES];
            } else {
                //免费
                [MBProgressHUD showSuccess:@"购买成功" toView:self.view];
            }
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)MissBuyView {
    
    [_allView removeFromSuperview];
    [_allButton removeFromSuperview];
    [_buyView removeFromSuperview];
}

- (void)SYGBuy1 {
    
    //网络请求下自己账户中得金额
    ZhiyiHTTPRequest *manager =[ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [manager reloadUserbalance:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _moneyDic = [[NSMutableDictionary alloc]initWithDictionary:[responseObject objectForKey:@"data"]];
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取数据失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertV show];
        return ;
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
    needMoney.text = [NSString stringWithFormat:@"需要消耗%@元",_moneyString];
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

#pragma mark -- UITableViewDatasoure

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 1230) {
        return _counpArray.count;
    }
    [_lab removeFromSuperview];
    
    if (_dataArray.count) {

        return _dataArray.count;
        
    }else{
        
        _lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, MainScreenWidth, 20)];
        _lab.textAlignment = NSTextAlignmentCenter;
        [_tableView addSubview:_lab];
        _lab.text = @"暂时没有课程";
        _lab.textColor = [UIColor grayColor];
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 1230) {
        
        NSString * identifier= @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,_frame.size.width, 50)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lab];
        lab.text = [NSString stringWithFormat:@"type == %@",_counpArray[indexPath.row][@"type"]];
        cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    static NSString * cellStr = @"cell";
    characterTableCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        NSArray * xibArr = [[NSBundle mainBundle]loadNibNamed:@"characterTableCell" owner:nil options:nil];
        for (id obj in xibArr) {
            cell = (characterTableCell *)obj;
            break;
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(60 + 3, 35 / 2, 15, 15)];
    [cell addSubview:button];
    cell.titleLab.text = _dataArray[indexPath.row][@"title"];
    cell.titleLab.textColor = [UIColor blackColor];
    cell.countLab.text = [NSString stringWithFormat:@"课时%ld",(long)(indexPath.row+1)];
    cell.liveLab.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"note"]];
    NSString *liveStr = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"note"]];
    if ([liveStr isEqualToString:@"已结束"]) {
        cell.titleLab.alpha = 0.6;
        cell.countLab.alpha = 0.6;
        cell.liveLab.alpha = 0.6;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    [_poptableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *liveStr = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"note"]];
//    if ([liveStr isEqualToString:@"已结束"]) {
//        [MBProgressHUD showSuccess:@"直播已结束" toView:self.view];
//        return;
//    }
    if (tableView.tag == 1230) {
        
        _poptableView.frame = CGRectMake(0, 0, 0, 0);
        return;
    }

    if (_flag == (int)indexPath.row) {
        
    }else{

        _flag = (int)indexPath.row;
        [_tableView reloadData];
    }
    // 这里应该判断是否已经登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {
        
        //没有登录的情况下
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        
    }else{
        
        if (_buyButton.tag == 1) {
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            _HDnickName = [defaults objectForKey:@"WDC"];
            NSLog(@"%@",_HDnickName);
            
            

            NSLog(@"%@",_dataArray[indexPath.row]);
            //参数
            _HDtitle = _dataArray[indexPath.row][@"subject"];
//            _HDwatchPassword = _dataArray[indexPath.row][@"studentClientToken"];
//            _HDroomNumber = _dataArray[indexPath.row][@"number"];
//             HDZBLiveViewController *hdzb = [[HDZBLiveViewController alloc]init];
//            [hdzb initwithTitle:_HDtitle nickName: _HDnickName watchPassword:_HDwatchPassword roomNumber:_HDroomNumber];
            NSString *ID = _dataArray[indexPath.row][@"live_id"];
            NSString *secitonID = _dataArray[indexPath.row][@"section_id"];
            [self NetWorkGetUrl:ID WithSecitionID:secitonID];
            
//             [self.navigationController pushViewController:hdzb animated:YES];
            
//            EPlayerData *playerData =[[EPlayerData alloc] init];
//            playerData.liveClassroomId = _dataArray[indexPath.row][@"room_id"];
//            playerData.customer = @"seition";
//            playerData.loginType = EPlayerLoginTypeNone;
//            EPlayerPluginViewController *controller = [[EPlayerPluginViewController alloc] initPlayer:playerData];
//            //self.navigationController.navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"圆角矩形-1@2x"]];
//            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar"] forBarMetrics:UIBarMetricsDefault];
//            [self.navigationController pushViewController:controller animated:YES];
            
        }else{
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:@"您尚未购买，请购买后观看" toView:self.view];
        }
    }
}

//收藏
- (void)likeBtn
{
    //判断是否登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {
        //没有登录的情况下
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
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
        [dic setValue:_cid forKey:@"source_id"];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
            [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
            [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
        } else {
            [MBProgressHUD showError:@"请先登陆" toView:self.view];
            return;
        }
        
        [manager collectLive:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [_SYGLikeButton setBackgroundImage:[UIImage imageNamed:@"空心五角星@2x"] forState:UIControlStateNormal];
            [MBProgressHUD showSuccess:@"取消收藏成功" toView:self.view];
            [self requestData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }else if ([_collectStr intValue]==0){
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:@"2" forKey:@"sctype"];
        [dic setValue:@"1" forKey:@"type"];
        [dic setValue:_cid forKey:@"source_id"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
        
        [manager collectLive:dic success:^(AFHTTPRequestOperation *operation, id responseObject){
            [_SYGLikeButton setBackgroundImage:[UIImage imageNamed:@"实心五角星@2x"] forState:UIControlStateNormal];
            [MBProgressHUD showSuccess:@"收藏成功" toView:self.view];
            [self requestData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}

//去掉HTML字符
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO){
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    }
    return html;
    
}

#pragma mark ---- 讲师详情

-(void)requestTeacherData
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:_teacherID forKey:@"teacher_id"];
//    
    [manager getpublicPort:dic mod:@"Teacher" act:@"getTeacher" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        if ([responseObject[@"code"] integerValue] != 1) {
            return ;
        } else {
            _usertitleLab.text = responseObject[@"data"][@"name"];
            _userdetilLab.text = responseObject[@"data"][@"inro"];
            NSString *urlStr = responseObject[@"data"][@"headimg"];
            [_useraconImg sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}



- (void)NetWorkGetUrl:(NSString *)ID WithSecitionID:(NSString *)secitonID {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:ID forKey:@"live_id"];
    [dic setValue:secitonID forKey:@"section_id"];
    
    [manager BigWinCar_getLiveUrl:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"======  %@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"type"] integerValue] == 1) {//展示互动
                
                _HDwatchPassword = responseObject[@"data"][@"body"][@"join_pwd"];
                _HDroomNumber = responseObject[@"data"][@"body"][@"number"];
                 HDZBLiveViewController *hdzb = [[HDZBLiveViewController alloc]init];
                [hdzb initwithTitle:_HDtitle nickName: _HDnickName watchPassword:_HDwatchPassword roomNumber:_HDroomNumber];
                hdzb.account = responseObject[@"data"][@"body"][@"account"];
                hdzb.domain = responseObject[@"data"][@"body"][@"domain"];
                [self.navigationController pushViewController:hdzb animated:YES];
            } else if ([responseObject[@"data"][@"type"] integerValue] == 2){//光辉直播
//                EPlayerData *playerData =[[EPlayerData alloc] init];
//                playerData.liveClassroomId = ID;
//                playerData.customer = @"seition";
//                playerData.loginType = EPlayerLoginTypeNone;
//                EPlayerPluginViewController *controller = [[EPlayerPluginViewController alloc] initPlayer:playerData];
//                //self.navigationController.navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"圆角矩形-1@2x"]];
//                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar"] forBarMetrics:UIBarMetricsDefault];
//                [self.navigationController pushViewController:controller animated:YES];
            }
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}


@end
