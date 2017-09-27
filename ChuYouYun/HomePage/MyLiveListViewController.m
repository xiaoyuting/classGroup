//
//  MyLiveListViewController.m
//  ChuYouYun
//
//  Created by IOS on 16/11/14.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "MyLiveListViewController.h"
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


#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4,4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕


#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕

#define iPhone6PlusBIG ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus放大版屏幕
#define SPACE (self.view.frame.size.width-35*3)/3 //间隙



@interface MyLiveListViewController ()<UIScrollViewDelegate,UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
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
    
    //参数
    NSString *_HDtitle;
    NSString *_HDnickName;
    NSString *_HDwatchPassword;
    NSString *_HDroomNumber;
    
}
@property (nonatomic ,strong)UIView *buyView;

@property (strong ,nonatomic)UIButton *allButton;

@property (strong ,nonatomic)UIButton *DJbutton;
@property (strong ,nonatomic)NSDictionary *moneyDic;
@property (strong ,nonatomic)UIView *allView;
@property (nonatomic ,strong)NSDictionary *userDic;


@property (strong ,nonatomic)UIButton *imgBtn;

@property (strong ,nonatomic)UIButton *buyButton;

@property (strong ,nonatomic)UITableView *tableView;



@end

@implementation MyLiveListViewController

-(id)initWithMemberId:(NSString *)MemberId andImage:(NSString *)imgUrl andTitle:(NSString *)title andNum:(int)num
{
    if (self=[super init]) {
        _cid = MemberId;
        _course_title = title;
        _imgUrl = imgUrl;
        row = num;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    //self.navigationController.navigationBar.hidden = YES;
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"options.png"] forBarMetrics:UIBarMetricsDefault];
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
    //    NSLog(@"%@",dic);
    //&oauth_token=44da0cedbcda40ce2fabfafb51ae4622&oauth_token_secret=34e7b83af30a98d365ec47610761dae1&page=1
    // NSString *liveUrl = [NSString stringWithFormat:@"http://demo.51eduline.com/?app=api&mod=Live&act=getDetail&oauth_token=3c664fc22dfa3d0baebf48ec964ffde2&oauth_token_secret=d3702c16b211a45e0e8b95b80ad2adcd&live_id=%@&has_user_info=0",_cid];
    
    if (_buyButton.tag == 1) {
        
    }else{
        [self SYGBuy];
    }
    [manager getpublicPort:dic mod:@"Live" act:@"getDetail" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = [responseObject objectForKey:@"msg"];
        
        if (_buyButton.tag == 1) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];
            
        } else {
            
            [UIView animateWithDuration:0.2 animations:^{
                
                _scrollView.contentOffset = CGPointMake(0, 0);
                [detilBtn setTitleColor:[UIColor colorWithHexString:@"#2069cf"] forState:UIControlStateNormal];
                [classBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                CGPoint center = _arrowImageView.center;
                center.x = MainScreenWidth / 4;
                _arrowImageView.center = center;
                
            }];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"报名成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            // [_buyButton setBackgroundImage:[UIImage imageNamed:@"zhibo.png"] forState:UIControlStateNormal];
            //[alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    _dataArray = [[NSMutableArray alloc]init];
    _allDataArr = [[NSMutableArray alloc]init];
    rect = [UIScreen mainScreen].applicationFrame;
    
//    UILabel *titleText = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 0, 30)];
//    titleText.backgroundColor = [UIColor clearColor];
//    titleText.textColor=[UIColor blackColor];
//    [titleText setFont:[UIFont systemFontOfSize:15]];
//    [titleText setText:_course_title];
//    self.navigationItem.titleView=titleText;
    self.title = _course_title;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 22)];
    [backButton setImage:[UIImage imageNamed:@"iconfont-FH"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:back];
    
    //=============================
    _imgBtn = [[UIButton alloc]init];
    [self addPlayer];
    
    UIImageView *imageviews = [[UIImageView alloc]initWithFrame:_imgBtn.frame];
    [imageviews sd_setImageWithURL:[NSURL URLWithString:_imgUrl]];
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
    detilBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, _imgBtn.frame.size.height+_imgBtn.frame.origin.y, MainScreenWidth/2 +3, 30)];
    [detilBtn setTitleColor:[UIColor colorWithHexString:@"#2069cf"] forState:UIControlStateNormal];
    [detilBtn setTitle:@"课程" forState:UIControlStateNormal];
    [self.view addSubview:detilBtn];
    [detilBtn addTarget:self action:@selector(move:) forControlEvents:UIControlEventTouchUpInside];
    detilBtn.tag = 1;
    detilBtn.titleLabel.font = Font(14);
    detilBtn.backgroundColor = [UIColor whiteColor];
    
    classBtn = [[UIButton alloc]initWithFrame:CGRectMake(MainScreenWidth/2 + 3, _imgBtn.frame.size.height+_imgBtn.frame.origin.y, MainScreenWidth/2 -3, 30)];
    [classBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [classBtn setTitle:@"详情" forState:UIControlStateNormal];
    [self.view addSubview:classBtn];
    classBtn.backgroundColor = [UIColor whiteColor];
    [classBtn addTarget:self action:@selector(move:) forControlEvents:UIControlEventTouchUpInside];
    classBtn.tag = 2;
    classBtn.titleLabel.font = Font(14);
    _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(90,classBtn.frame.size.height+classBtn.frame.origin.y, 50, 5)];
    _arrowImageView.image = [UIImage imageNamed:@"尖角.png"];
    CGPoint center = _arrowImageView.center;
    center.x = MainScreenWidth / 4;
    _arrowImageView.center = center;
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0,_arrowImageView.frame.size.height+_arrowImageView.frame.origin.y - 1,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [self.view addSubview:lineLab];
    [self.view addSubview:_arrowImageView];
    
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,lineLab.frame.size.height+lineLab.frame.origin.y +10, MainScreenWidth,MainScreenHeight - lineLab.frame.size.height - lineLab.frame.origin.y - 10)];
    _scrollView.delegate = self;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.pagingEnabled = YES;
    //同时单方向滚动
    _scrollView.directionalLockEnabled = YES;
    _scrollView.contentSize = CGSizeMake(MainScreenWidth * 2, 0);
    _scrollView.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:_scrollView];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self creatscrollow];
    [self addTableView];
    
    UIButton *buyButton = [[UIButton alloc] init];
    buyButton.frame = CGRectMake(MainScreenWidth - 100, 400, 50, 50);
    if ([_buyMessage isEqual:@"ok"]) {
        
        [buyButton setBackgroundImage:[UIImage imageNamed:@"zhibo.png"] forState:UIControlStateNormal];
        
    }else{
        [buyButton setBackgroundImage:[UIImage imageNamed:@"悬浮9"] forState:UIControlStateNormal];
    }    [self.view addSubview:buyButton];
    //    buyButton.backgroundColor = [UIColor redColor];
    _buyButton = buyButton;
    [self addPlayer];
    [_buyButton addTarget:self action:@selector(goBuy) forControlEvents:UIControlEventTouchUpInside];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView{
    
    int num = scrollView.contentOffset.x/MainScreenWidth;
    NSLog(@"%d",num);
    
    if (num==0) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            [detilBtn setTitleColor:[UIColor colorWithHexString:@"#2069cf"] forState:UIControlStateNormal];
            [classBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            CGPoint center = _arrowImageView.center;
            center.x = MainScreenWidth / 4;
            _arrowImageView.center = center;
            _scrollView.contentOffset = CGPointMake(0, 0);
        }];
        
    }else{
        
        [UIView animateWithDuration:0.2 animations:^{
            
            [classBtn setTitleColor:[UIColor colorWithHexString:@"#2069cf"] forState:UIControlStateNormal];
            [detilBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            CGPoint center = _arrowImageView.center;
            center.x = 3*MainScreenWidth / 4;
            _arrowImageView.center = center;
            _scrollView.contentOffset = CGPointMake(MainScreenWidth, 0);
            
        }];
        
        
    }
    
}
-(void)move:(UIButton *)sender{
    
    // 这里应该判断是否已经登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    
    if (sender.tag==1) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            [detilBtn setTitleColor:[UIColor colorWithHexString:@"#2069cf"] forState:UIControlStateNormal];
            [classBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            CGPoint center = _arrowImageView.center;
            center.x = MainScreenWidth / 4;
            _arrowImageView.center = center;
            _scrollView.contentOffset = CGPointMake(0, 0);
        }];
        
        
    }else{
        
        [UIView animateWithDuration:0.2 animations:^{
            
            [classBtn setTitleColor:[UIColor colorWithHexString:@"#2069cf"] forState:UIControlStateNormal];
            [detilBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            CGPoint center = _arrowImageView.center;
            center.x = 3*MainScreenWidth / 4;
            _arrowImageView.center = center;
            _scrollView.contentOffset = CGPointMake(MainScreenWidth, 0);
            
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
        
        if ([_buyMessage isEqual:@"ok"]) {//购买的
            
            //            EPlayerData *playerData =[[EPlayerData alloc] init];
            //
            //            playerData.liveClassroomId = @"5790dcc95081bffb1b0093ba";
            //
            //            playerData.customer = @"seition";
            //
            //            playerData.loginType = EPlayerLoginTypeNone;
            //
            //
            //            EPlayerPluginViewController *controller = [[EPlayerPluginViewController alloc] initPlayer:playerData];
            //            //self.navigationController.navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"圆角矩形-1@2x"]];
            //            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar"] forBarMetrics:UIBarMetricsDefault];
            //            [self.navigationController pushViewController:controller animated:YES];
            //
            
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
    
    //
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
    
    //添加评分文本
    UILabel *PFLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth+20, 0, 50, 40)];
    PFLabel.text = @"评分：";
    PFLabel.font = [UIFont systemFontOfSize:15];
    PFLabel.textColor = [UIColor colorWithRed:170.f / 255 green:170.f / 255 blue:170.f / 255 alpha:1];
    [_scrollView addSubview:PFLabel];
    _Starbtn = [[UIButton alloc] initWithFrame:CGRectMake(PFLabel.frame.size.width+PFLabel.frame.origin.x, 14, 80, 12)];
    [_scrollView addSubview:_Starbtn];
    _OrderLab = [[UILabel alloc]initWithFrame:CGRectMake(_Starbtn.frame.size.width+_Starbtn.frame.origin.x +60, 14, 120, 12)];
    _OrderLab.textColor = [UIColor colorWithRed:170.f / 255 green:170.f / 255 blue:170.f / 255 alpha:1];
    _OrderLab.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:_OrderLab];
    UIView *backLab = [[UIView alloc]initWithFrame:CGRectMake(MainScreenWidth, _Starbtn.frame.size.height+_Starbtn.frame.origin.y +20 , MainScreenWidth, 35)];
    [_scrollView addSubview:backLab];
    backLab.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _secondTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, MainScreenWidth - 10, 35)];
    _secondTitleLab.textColor = [UIColor blackColor];
    _secondTitleLab.font = [UIFont systemFontOfSize:15];
    [backLab addSubview:_secondTitleLab];
    _secondTitleLab.text = _course_title;
    _texV = [[UITextView alloc]initWithFrame:CGRectMake(MainScreenWidth+10, backLab.frame.size.height +backLab.frame.origin.y +5, MainScreenWidth - 20, _scrollView.frame.size.height - backLab.frame.size.height -backLab.frame.origin.y -30)];
    [_scrollView addSubview:_texV];
    _texV.textColor = [UIColor blackColor];
    
    [self star];
}
-(void)star{
    
    _texV.text = _detilString;
    _OrderLab.text = [NSString stringWithFormat:@"学习人数：%@",_OrderNUm];
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
        _buyButton.frame = CGRectMake(MainScreenWidth - 70, titleLab.frame.origin.y+titleLab.frame.origin.x+50, 40,40);
        
    }else
        if (iPhone5o5Co5S) {
            
            //创建播放器
            _imgBtn.frame = CGRectMake(0, 64, MainScreenWidth,MainScreenWidth*3/5);
            _buyButton.frame = CGRectMake(MainScreenWidth - 70, MainScreenHeight - 290 + 64, 40,40);
            
        }
        else if(iPhone6)
        {
            //创建播放器
            _imgBtn.frame = CGRectMake(0, 64, MainScreenWidth, MainScreenWidth*3/5);
            _buyButton.frame = CGRectMake(MainScreenWidth - 70, MainScreenHeight - 310 + 64, 50,50);
            
            
        }
        else if(iPhone6Plus)
        {
            //创建播放器
            _imgBtn.frame = CGRectMake(0, 64, MainScreenWidth, MainScreenWidth*3/4);
            _buyButton.frame = CGRectMake(MainScreenWidth - 60, MainScreenHeight - 310 + 64, 50,50);
            
            
        }else {//ipad 适配
            
            //创建播放器
            _imgBtn.frame = CGRectMake(0, 64, MainScreenWidth, MainScreenWidth*3/5);
            _buyButton.frame = CGRectMake(MainScreenWidth - 60, MainScreenHeight - 310 + 64, 50,50);
        }
    _buyButton.frame = CGRectMake(MainScreenWidth - 70, titleLab.frame.origin.y+titleLab.frame.origin.x+50, 40,40);
    
}

- (void)requestData
{
    QKHTTPManager * manager = [QKHTTPManager manager];

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *key = [ user objectForKey:@"oauthToken"];
    NSString *passWord = [ user objectForKey:@"oauthTokenSecret"];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_cid forKey:@"live_id"];
    [dic setValue:[NSNumber numberWithInteger:0] forKey:@"has_user_info"];

    [dic setObject:key forKey:@"oauth_token"];
    [dic setObject:passWord forKey:@"oauth_token_secret"];
    
    NSString *liveUrl = @"http://dafengche.51eduline.com/?app=api&mod=Live&act=getDetail";
    NSLog(@"%@",liveUrl);
    
    [manager getpublicPort:dic mod:@"Live" act:@"getDetail" success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"%@",responseObject);
        
        _moneyString = responseObject[@"data"][@"v_price"];
        _lengtn = [responseObject[@"data"][@"video_score"] intValue];
        _OrderNUm = responseObject[@"data"][@"video_order_count"];
        //_detilString
        _detilString = responseObject[@"data"][@"video_intro"];
        NSLog(@"%d",_lengtn);
        NSLog(@"%@",_moneyString);
        [_allDataArr removeAllObjects];
        [_allDataArr addObjectsFromArray:responseObject[@"data"]];
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:responseObject[@"data"][@"sections"]];
        NSLog(@"%@",responseObject[@"data"][@"is_buy"]);
        NSString *numstr = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"is_buy"]];
        [_tableView reloadData];
        if ([numstr isEqualToString:@"1"]) {
            [_buyButton setBackgroundImage:[UIImage imageNamed:@"zhibo.png"] forState:UIControlStateNormal];
            _buyButton.tag = 1;
            
        }
        [self star];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"加载失败");
        
    }];
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
- (void)MissBuyView {
    
    [_allView removeFromSuperview];
    [_allButton removeFromSuperview];
    [_buyView removeFromSuperview];
}

- (void)pressed:(UIButton *)button {
    if (button.tag == 2) {//取消支付
        [self MissBuyView];
    }
    if (button.tag == 0) {//支付
        //应该跳转到支付界面
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_buyView removeFromSuperview];
        
        if ([_moneyDic[@"balance"] floatValue] < [_moneyString floatValue]) {//说明余额不足
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
            //http://demo.51eduline.com/index.php?app=api&mod=Live&act=buyOperating&oauth_token=3c664fc22dfa3d0baebf48ec964ffde2&oauth_token_secret=d3702c16b211a45e0e8b95b80ad2adcd&live_id=10025
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *key = [ user objectForKey:@"oauthToken"];
            NSString *passWord = [ user objectForKey:@"oauthTokenSecret"];
            
            NSString *buyUrl = [NSString stringWithFormat:@"http://dafengche.51eduline.com/?app=api&mod=Live&act=buyOperating&oauth_token=%@&oauth_token_secret=%@&live_id=%@&has_user_info=0",key,passWord,_cid];
            
            [manager getpublicPort:dic mod:@"Live" act:@"buyOperating" success:^(AFHTTPRequestOperation *operation, id responseObject) {

                NSLog(@"^^%@",responseObject);
                NSString *msg = [responseObject objectForKey:@"msg"];
                if (![msg isEqual:@"ok"]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    // [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alert repeats:YES];
                }else {
                    
                    [_buyButton setBackgroundImage:[UIImage imageNamed:@"zhibo.png"] forState:UIControlStateNormal];
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"购买成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    [alert show];
                    // [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alert repeats:YES];
                    
                    
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
            //            [manager buyAlbum:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //                NSLog(@"^^%@",responseObject);
            //                NSString *msg = [responseObject objectForKey:@"msg"];
            //                if (![msg isEqual:@"ok"]) {
            //                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //                    [alert show];
            //                   // [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alert repeats:YES];
            //                }else {
            //                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"购买成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            //                    [alert show];
            //                   // [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alert repeats:YES];
            //
            //
            //                }
            //            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //
            //            }];
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

#pragma mark -- UITableViewDatasoure


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
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
        
    }}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    
    //    //添加线
    UILabel *XLabel = [[UILabel alloc] initWithFrame:CGRectMake(67 + 3, 0, 1, 35 / 2)];
    XLabel.backgroundColor = [UIColor colorWithRed:153.f / 255 green:152.f / 255 blue:152.f / 255 alpha:1];
    [cell addSubview:XLabel];
    
    UILabel *SLabel = [[UILabel alloc] initWithFrame:CGRectMake(67 + 3, 50 - 35 / 2 - 2, 1, 35 / 2 + 2)];
    SLabel.backgroundColor = [UIColor colorWithRed:153.f / 255 green:152.f / 255 blue:152.f / 255 alpha:1];
    [cell addSubview:SLabel];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(60 + 3, 35 / 2, 15, 15)];
    
    
    [cell addSubview:button];
    
    //    blumCatalogList * list = _dataArray[indexPath.row];
    //    cell.titleLab.text = list.classTitle;
    cell.titleLab.text = _dataArray[indexPath.row][@"title"];
    cell.titleLab.textColor = [UIColor blackColor];
    cell.countLab.text = [NSString stringWithFormat:@"课时%ld",(long)(indexPath.row+1)];
    //[_XZArray[indexPath.section][indexPath.row] boolValue] == NO
    if (indexPath.row != _flag) {
        [button setBackgroundImage:[UIImage imageNamed:@"椭圆-100"] forState:UIControlStateNormal];
        cell.titleLab.textColor = [UIColor blackColor];
        cell.countLab.textColor = [UIColor blackColor];
        
    }else {
        [button setBackgroundImage:[UIImage imageNamed:@"点@2x"] forState:UIControlStateNormal];
        
        //变颜色
        cell.titleLab.textColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
        cell.countLab.textColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    }
    
    
    //[cell addSubview:_XZButton];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"点击了ecell");
    NSLog(@"%@",_allDataArr[indexPath.row]);
    if (_flag == (int)indexPath.row) {
        
    }else{
        _flag = (int)indexPath.row;
        [_tableView reloadData];
    }
    // 这里应该判断是否已经登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        
    }else{
        
        if (_buyButton.tag == 1) {
            
//            EPlayerData *playerData =[[EPlayerData alloc] init];
//            
//            playerData.liveClassroomId = _dataArray[indexPath.row][@"room_id"];
//            
//            playerData.customer = @"seition";
//            
//            playerData.loginType = EPlayerLoginTypeNone;
//            
//            EPlayerPluginViewController *controller = [[EPlayerPluginViewController alloc] initPlayer:playerData];
//            //self.navigationController.navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"圆角矩形-1@2x"]];
//            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar"] forBarMetrics:UIBarMetricsDefault];
//            [self.navigationController pushViewController:controller animated:YES];
            
        }else{
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [MBProgressHUD showError:@"您尚未购买，请购买后观看" toView:self.view];
            //            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            //            [self.view addSubview:HUD];
            //            HUD.labelText =@"您尚未购买，请购买后观看";
            //            HUD.minShowTime = 1.0;
            //            HUD.removeFromSuperViewOnHide = YES;
            //            [HUD show:YES];
        }
        
        //        classDetailVC *classDVc = [[classDetailVC alloc] initWithMemberId:_lookArray[indexPath.row][@"id"] andPrice:nil andTitle:_lookArray[indexPath.row][@"video_title"]];
        //        classDVc.isLoad = @"123";
        //        [self.navigationController pushViewController:classDVc animated:YES];
        
    }
    
    
    
}



@end
