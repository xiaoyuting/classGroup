//
//  DiscountViewController.m
//  dafengche
//
//  Created by IOS on 16/9/30.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "DiscountViewController.h"
#import "AppDelegate.h"
#import "UIColor+HTMLColors.h"
#import "UIView+Utils.h"
#import "MyHttpRequest.h"
#import "FirstView.h"
#import "SecondView.h"
#import "GLpublicList.h"
#import "ZhiyiHTTPRequest.h"
#import "ThirdView.h"
#import "FourView.h"
#import "GLpublicList.h"
#import "MyHttpRequest.h"
#import "DiscountViewController.h"


@interface DiscountViewController ()<UIScrollViewDelegate>

{
    NSArray *_menuarr;
    UILabel *_linelab;
    UIButton *menubtn;
    int num;
    NSInteger numsender;
    FirstView *_thirdV;
    SecondView *_fourV;
    ThirdView *_secondV;
    FourView *_firstV;
    
//    NSMutableDictionary *_firstDic;
//    NSMutableDictionary *_secondDic;
//    NSMutableDictionary *_thirdDic;
//    NSMutableDictionary *_fourDic;
    //优惠券
    NSMutableDictionary *_dataDic1;
    //打折卡
    NSMutableDictionary *_dataDic2;
    //会员卡
    NSMutableDictionary *_dataDic3;
    //充值卡
    NSMutableDictionary *_dataDic4;

    
}

@property (strong, nonatomic) NSArray *dataItems;

///顶部btn集合
@property (strong, nonatomic) NSArray *btns;
@property (strong, nonatomic) UIView *lineLab;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray     *subViewArr;

@end

@implementation DiscountViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _dataDic1 = [NSMutableDictionary dictionary];
    _dataDic2 = [NSMutableDictionary dictionary];
    _dataDic3 = [NSMutableDictionary dictionary];
    _dataDic4 = [NSMutableDictionary dictionary];
//    _firstDic= [NSMutableDictionary dictionary];
//    _secondDic= [NSMutableDictionary dictionary];
//    _thirdDic= [NSMutableDictionary dictionary];
//    _fourDic= [NSMutableDictionary dictionary];

    [self addNav];
    num = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatMenu];
    [self initScrollView];
    [self requestData:2];
    [self requestData:3];
    [self requestData:1];
    [self requestData:4];
    [self sendData];

    //[self initScrollViewSubViews];
}
- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
     SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"我的优惠卷";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 130, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,116)];
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
- (void)initScrollView
{
    UILabel *backLab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.lineLab .frame.size.height+self.lineLab .frame.origin.y, MainScreenWidth+3, 1)];
    backLab.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:backLab];
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,backLab.frame.size.height+backLab.frame.origin.y, MainScreenWidth,MainScreenHeight-backLab.frame.origin.y-backLab.frame.size.height-2)];
    self.scrollView.contentSize = CGSizeMake(MainScreenWidth*4, self.scrollView.bounds.size.height);
    self.scrollView.delegate = self;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.pagingEnabled = YES;
    //同时单方向滚动
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:self.scrollView];
   // self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景-拷贝-3@2x.png"]];
    self.scrollView.contentSize = CGSizeMake(MainScreenWidth * _menuarr.count, MainScreenHeight-menubtn.frame.origin.y-menubtn.frame.size.height-5);
    //添加页面
    //3
    _thirdV = [[FirstView alloc]initWithFrame:CGRectMake(2 * MainScreenWidth, 0, MainScreenWidth, self.scrollView.frame.size.height)];
    //4
    _fourV = [[SecondView alloc]initWithFrame:CGRectMake(MainScreenWidth*3, 0, MainScreenWidth, self.scrollView.frame.size.height)];
    //2
    _secondV = [[ThirdView alloc]initWithFrame:CGRectMake(MainScreenWidth, 0, MainScreenWidth, self.scrollView.frame.size.height)];
    //1
    _firstV = [[FourView alloc]initWithFrame:CGRectMake(MainScreenWidth*0, 0, MainScreenWidth, self.scrollView.frame.size.height)];
    
    [self.scrollView addSubview:_firstV];
    [self.scrollView addSubview:_thirdV];
    [self.scrollView addSubview:_fourV];
    [self.scrollView addSubview:_secondV];

}

-(void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView{
    
    num = scrollView.contentOffset.x/MainScreenWidth;
    NSLog(@"%d",num);
    for (int i=0; i<_menuarr.count; i++) {
        [self.btns[i] setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
    }
    CGRect frame = self.lineLab.frame;
    UIButton *btn = (UIButton *)self.btns[num];
    frame.origin.x = btn.frame.origin.x;
    [UIView animateWithDuration:0.2 animations:^{
        self.lineLab.frame = frame;
        [btn setTitleColor:[UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1] forState:UIControlStateNormal];
        self.scrollView.contentOffset = CGPointMake(MainScreenWidth*num, 0);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //self.scrollView.contentOffset.x; //x
    //self.scrollView.contentOffset.y; //y
}

-(void)creatMenu{
    //自定义segment区域
    NSMutableArray *marr = [NSMutableArray array];
    _menuarr = [NSArray arrayWithObjects:@"打折",@"会员",@"优惠券",@"充值卡", nil];
    UIColor *ffbbcolor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
    for (int i=0; i<_menuarr.count; i++) {
        
        menubtn = [[UIButton alloc]init];
        menubtn.frame = CGRectMake(65*i+(i+1)*(MainScreenWidth- (65 * _menuarr.count))/(_menuarr.count + 1), 65, 65, 30);
        [menubtn setTitle:_menuarr[i] forState:UIControlStateNormal];
        [self.view addSubview:menubtn];
        menubtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [menubtn setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
        menubtn.tag = 100+i;
        menubtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [menubtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i==0) {
            
            [menubtn setTitleColor:ffbbcolor forState:UIControlStateNormal];
        }
        [marr addObject:menubtn];
    }
    self.btns = [marr copy];
    self.lineLab = [[UIView alloc]initWithFrame:CGRectMake((MainScreenWidth- (65 * _menuarr.count))/(_menuarr.count + 1),menubtn.frame.origin.y+menubtn.frame.size.height,65, 2)];
    self.lineLab.backgroundColor = ffbbcolor;
    UILabel *colorLine = [[UILabel alloc]initWithFrame:CGRectMake(0,menubtn.frame.origin.y+menubtn.frame.size.height+2,MainScreenWidth,0.5)];
    colorLine.backgroundColor = [UIColor grayColor];
    [self.view addSubview:colorLine];
    [self.view addSubview:self.lineLab];
}

//传值
-(void)sendData{
//1优惠券，2打折卡，3会员卡，4充值卡
    if (_dataDic4) {
        [_fourV resetViewWithEntity:_dataDic4];
    }
    if (_dataDic3) {
        [_secondV resetViewWithEntity:_dataDic3];
    }
    if (_dataDic1) {
        [_thirdV resetViewWithEntity:_dataDic1];
    }
    if (_dataDic2) {
        [_firstV resetViewWithEntity:_dataDic2];
    }
}
-(void)change:(UIButton *)sender{
    
    [self sendData];
    for (int i=0; i<_menuarr.count; i++) {
        [self.btns[i] setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
    }
    numsender = (int)sender.tag-100;
    CGRect frame = self.lineLab.frame;
    frame.origin.x = sender.frame.origin.x;
    [UIView animateWithDuration:0.2 animations:^{
        self.lineLab.frame = frame;
        [sender setTitleColor:[UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1] forState:UIControlStateNormal];
        self.scrollView.contentOffset = CGPointMake(MainScreenWidth*numsender, 0);
    }];
}

- (void)backPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestData:(NSInteger)num
{
    NSString *dataID = [NSString stringWithFormat:@"%ld",num];
    
    NSLog(@"%@",dataID);
    
    QKHTTPManager * manager = [QKHTTPManager manager];
//    manager.requestSerializer.timeoutInterval = 10.0;
//    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:1];
//    [GLpublicList creatList:dataID];
//    NSArray *TeacherArray = [GLpublicList publicDataWithDic:dic DataID:dataID];

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *key = [ user objectForKey:@"oauthToken"];
    NSString *passWord = [ user objectForKey:@"oauthTokenSecret"];
    NSDictionary *parameter=@{@"oauth_token": key,@"oauth_token_secret": passWord ,@"page": @"1",@"count": @"20",@"status": @"-1",@"type": dataID};
    [manager getpublicPort:parameter mod:@"Coupon" act:@"getMyCouponList" success:^(AFHTTPRequestOperation *operation, id responseObject) {

        //1优惠券，2打折卡，3会员卡，4充值卡
        if ([dataID isEqualToString:@"2"]){
            
            //打折
            [_dataDic2 addEntriesFromDictionary:responseObject];
            [_firstV resetViewWithEntity:responseObject];

        }else if ([dataID isEqualToString:@"3"]){
            
            //会员
            [_dataDic3 addEntriesFromDictionary:responseObject];
            [_secondV resetViewWithEntity:responseObject];

        }else if ([dataID isEqualToString:@"1"]){
            
            //优惠券
            [_dataDic1 addEntriesFromDictionary:responseObject];
            [_thirdV resetViewWithEntity:responseObject];

        }else if ([dataID isEqualToString:@"4"]){
            
            //充值卡
            [_dataDic4 addEntriesFromDictionary:responseObject];
            [_fourV resetViewWithEntity:responseObject];
            NSLog(@"--+----%@",responseObject);
        }
//        [self sendData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"加载失败");
    }];
    
   // NSArray *TeacherArray = [TeacherTool teacherWithDic:dic];
}

@end
