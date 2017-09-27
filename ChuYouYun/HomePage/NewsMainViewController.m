//
//  NewsMainViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/8/1.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "NewsMainViewController.h"
#import "SYG.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "ZiXunTableViewCell.h"
#import "ZiXunsTableViewCell.h"
#import "ZhiyiHTTPRequest.h"
#import "ZXZXViewController.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "ZXDTViewController.h"
#import "MBProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "GSMJRefresh.h"
#import "ZiXunsssTableViewCell.h"
#import "UIButton+WebCache.h"


@interface NewsMainViewController ()<UIScrollViewDelegate>{
    
    NSArray *_menuarr;
    UIButton *menubtn;
    int numsender;
    int tempNumber;
    UILabel *_colorLine;
    NSString *_ID;
    CGFloat buttonX;//每个按钮的最开始的位置
    CGFloat allButtonX;//最后按钮的X轴上的偏移量
}

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSArray *lookArray;

@property (strong ,nonatomic)UIScrollView *headScrollow;

///顶部btn集合
@property (strong, nonatomic) NSArray *btns;

@property (strong ,nonatomic)NSArray *dataArray;

@property (strong ,nonatomic)NSMutableArray *dataArr;

@property (assign ,nonatomic)NSInteger number;

@property (strong ,nonatomic)NSMutableArray *imgdataArray;


@end

@implementation NewsMainViewController


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
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self interFace];
    [self addNav];
    [self addscrollow];
    [self NetWork];
    [_tableView.header beginRefreshing];
}

- (void)interFace {
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    buttonX = 0;
    allButtonX = 0;
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"资讯";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30,120, 24)];
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
    
    //添加测试按钮
    UIButton *testButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 20, 30, 30)];
    testButton.backgroundColor = [UIColor redColor];
    [SYGView addSubview:testButton];
    [testButton addTarget:self action:@selector(testButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    testButton.hidden = YES;
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)creatMenu{
    
    //自定义segment区域
    NSMutableArray *marr = [NSMutableArray array];
    UIColor *ffbbcolor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
    
    for (int i=0; i< _dataArray.count; i++) {
        menubtn = [[UIButton alloc]init];
        //        menubtn.frame = CGRectMake(i*MainScreenWidth/5, 0, MainScreenWidth/5, 40);
        menubtn.frame = CGRectMake(buttonX, 0, MainScreenWidth/5, 40);
        [menubtn setTitle:_dataArray[i][@"title"] forState:UIControlStateNormal];
        [_headScrollow addSubview:menubtn];
        menubtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [menubtn setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
        menubtn.tag = 100+i;
        menubtn.titleLabel.font = [UIFont systemFontOfSize:14];
        if (iPhone5o5Co5S) {
            menubtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        } else if (iPhone6) {
            menubtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        } else if (iPhone6Plus) {
            menubtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        }
        
        
        //按钮的自适应
        
        CGRect labelSize = [menubtn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil];
        if (labelSize.size.width < MainScreenWidth / 5 ) {
            labelSize.size.width = MainScreenWidth / 5;
        }
        menubtn.frame = CGRectMake(menubtn.frame.origin.x, menubtn.frame.origin.y,labelSize.size.width, 40);
        buttonX = labelSize.size.width + menubtn.frame.origin.x;
        allButtonX = labelSize.size.width + menubtn.frame.origin.x;
        
        [menubtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            [menubtn setTitleColor:ffbbcolor forState:UIControlStateNormal];
        }
        [marr addObject:menubtn];
        
        if (i == _dataArray.count - 1) {
            
        } else {
            //添加横线
            for (int i = 0 ; i < _dataArray.count - 1 ; i ++) {
                UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, 12.5, 1, 15)];
                lineButton.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
                [_headScrollow addSubview:lineButton];
            }
        }
        
        
        
        
    }
    self.btns = [marr copy];
    int tempNum;
    tempNum = (int)_dataArray.count;
    //    _headScrollow.contentSize = CGSizeMake((_dataArray.count) * MainScreenWidth/5, 40);
    _headScrollow.contentSize = CGSizeMake(allButtonX + 20, 5);
    _colorLine = [[UILabel alloc]initWithFrame:CGRectMake(0, _headScrollow.frame.size.height - 2, MainScreenWidth/5, 2)];
    _colorLine.backgroundColor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
    [_headScrollow addSubview:_colorLine];
    CGPoint center = _colorLine.center;
    center.x = MainScreenWidth / (2 * tempNum);
    _colorLine.center = center;
    _colorLine.hidden = YES;
}


-(void)addscrollow{
    
    _headScrollow = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64, MainScreenWidth,40)];
    _headScrollow.delegate = self;
    _headScrollow.alwaysBounceVertical = NO;
    _headScrollow.pagingEnabled = NO;
    _headScrollow.backgroundColor = [UIColor whiteColor];
    //同时单方向滚动
    _headScrollow.directionalLockEnabled = YES;
    _headScrollow.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:_headScrollow];
    _headScrollow.showsVerticalScrollIndicator = NO;
    _headScrollow.showsHorizontalScrollIndicator = NO;
    _headScrollow.delegate = self;
    
}



#pragma mark --- 网络请求
- (void)NetWork {
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [manager FXFL:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _dataArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        [self creatMenu];
//        [self addTableView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"数据加载失败" toView:self.view];
        NSLog(@"error   %@",error);
    }];
}



@end
