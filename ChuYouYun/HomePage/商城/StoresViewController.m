//
//  StoresViewController.m
//  dafengche
//
//  Created by IOS on 16/12/19.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "StoresViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "HomeInstitutionViewController.h"
#import "HeaderCRView.h"
#import "SDCycleScrollView.h"
#import "mainCollectionViewCell.h"
#import "UIColor+HTMLColors.h"
#import "ShopDetailViewController.h"
#import "StoreCategorryViewController.h"
#import "MyHttpRequest.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import "MJRefresh.h"
#import "MBProgressHUD+Add.h"

#import "AdViewController.h"
#import "StoreMoreViewController.h"




@interface StoresViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
{
    UITableView *_tableView;
    NSString *_ID;
    //更多数据的 判断数组
    NSArray *_ISONArr;
    NSMutableArray *_muArray;
}

@property (strong ,nonatomic)NSMutableArray *GLdataArray;
@property (strong ,nonatomic)NSMutableArray *GLdataArray1;
@property (strong ,nonatomic)NSMutableArray *GLdataArray2;
@property (strong ,nonatomic)NSMutableArray *LBdataArray;
@property (strong ,nonatomic)NSMutableArray *banerurlArray;


@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)NSString *mallID;
@property (strong ,nonatomic)NSString *mallName;
@property (strong ,nonatomic)UIView   *headerView;
@property (strong ,nonatomic)UIScrollView *headerSrcollView;

@end

@implementation StoresViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [self requestLBData];
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self interFace];
    
}
-(void)requestLBData
{
    
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSDictionary *parameter;
    
    parameter=@{@"place":@"app_goods_banner"};
    [manager getpublicPort:parameter mod:@"Home" act:@"getAdvert" success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"===__===%@",responseObject);
        _LBdataArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        [_tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"获取数据失败" toView:self.view];
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    self.navigationController.navigationBar.hidden = NO;
    [super viewWillDisappear:animated];

}

-(instancetype)initWithID:(NSString *)ID{
    
    self = [super init];
    
    if (self) {
        
        _ID = ID;
    }
    return self;}

-(void)requestData {
    
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    

    if (_mallID == nil) {
        
    } else {
        [dic setValue:_mallID forKey:@"cate_id"];
//        [dic setValue:@"list" forKey:@"type"];
    }
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"6" forKey:@"count"];
    [dic setValue:@"5" forKey:@"floor_count"];
    if (_mallID != nil) {
        [dic setValue:@"2" forKey:@"floor_count"];
    }
    
    if (UserOathToken == nil) {
        
    } else {
        [dic setValue:UserOathToken forKey:@"oauth_token"];
        [dic setValue:UserOathTokenSecret forKey:@"oauth_token_secret"];
    }
    
    NSLog(@"%@",dic);
//    [MBProgressHUD showError:@"数据加载中...." toView:self.view];
    
    [manager getpublicPort:dic mod:@"Goods" act:@"index" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"===__===%@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
//            [MBProgressHUD showError:@"加载完成...." toView:self.view];
            if (_mallID != nil) {
                  _GLdataArray = [NSMutableArray arrayWithArray:responseObject[@"data"][@"rank"]];
            } else {
                 _GLdataArray = [NSMutableArray arrayWithArray:responseObject[@"data"][@"rank"]];
                [self addHeaderView];
            }
            _dataArray = [NSMutableArray arrayWithArray:responseObject[@"data"][@"list"]];
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }
        
        NSLog(@"%@",_dataArray);
        [_tableView reloadData];
        
        if (_GLdataArray.count > 0 && _dataArray.count == 0) {
            [self addHeaderWithOutTableView];
            [_tableView setTableHeaderView:_headerView];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"获取数据失败" toView:self.view];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _ISONArr = @[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"];
    _muArray = [NSMutableArray arrayWithArray:_ISONArr];
    [self interFace];
    [self addNav];
    [self addTabView];
    [self requestData];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NSNoticafition:) name:@"NSNotificationMallID" object:nil];
    
    _banerurlArray = [NSMutableArray array];
    
}
    
    
- (void)NSNoticafition:(NSNotification *)Not {
    NSLog(@"%@",Not.object);
    _mallID = [NSString stringWithFormat:@"%@", Not.object[@"ID"]];
    _mallName = [NSString stringWithFormat:@"%@", Not.object[@"title"]];
    [self requestData];
    
}
- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"商城";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 70, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,56)];
    [backButton setTitle:@" " forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    //设置button上字体的偏移量
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10.0 , 0.0, 0)];
    [SYGView addSubview:backButton];
    
    //添加分类按钮
    UIButton *SXButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth-35, 30, 20, 20)];
    [SXButton setBackgroundImage:[UIImage imageNamed:@"fenleisyg"] forState:UIControlStateNormal];
    [SXButton addTarget:self action:@selector(ShopCateButton) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:SXButton];
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
}

- (void)backPressed {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//分类
-(void)ShopCateButton{
    
    self.navigationController.navigationBar.hidden = NO;
    StoreCategorryViewController *goods = [[StoreCategorryViewController alloc]init];
    [self.navigationController pushViewController:goods animated:YES];
}

-(void)addTabView{

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    [self.view addSubview: _tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
//    _tableView.tableHeaderView = _headerView;
   // _tableView.separatorStyle = UITableViewCellSelectionStyleNone;

}
#pragma mark - 添加滚动视图

-(UIView *)addHeaderView{
    
    // 情景二：采用网络图片实现
    NSMutableArray *imagesURLStrings = [NSMutableArray array];
    for (int i =0; i<_LBdataArray.count; i++) {
        [imagesURLStrings addObject:[NSString stringWithFormat:@"%@",_LBdataArray[i][@"banner"]]];
        
        NSString *banerurl = _LBdataArray[i][@"bannerurl"];
        [_banerurlArray addObject:banerurl];
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 230*MainScreenWidth/375 + 145 + 20 + 30)];
    view.backgroundColor = [UIColor whiteColor];
    _headerView = view;
    
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, MainScreenWidth, 230*MainScreenWidth/375) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    cycleScrollView3.imageURLStringsGroup = imagesURLStrings;
    cycleScrollView3.backgroundColor = [UIColor cyanColor];
    cycleScrollView3.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView3.delegate = self;
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, cycleScrollView3.current_y_h, MainScreenWidth, 30)];
    lab.text = @"   兑换排行榜";
    lab.font = Font(15);
    [view addSubview:cycleScrollView3];
     [view addSubview:lab];
    
    UILabel *backLab = [[UILabel alloc]initWithFrame:CGRectMake(10, lab.current_y_h +3, MainScreenWidth - 20, 3)];
    backLab.backgroundColor = [UIColor blueColor];
    [view addSubview:backLab];
    backLab.alpha = 0.5;
    
    int width = MainScreenWidth / 2 - 20;
    for (int i = 0 ; i < _GLdataArray.count ; i ++) {
        
        UIButton *imgaeButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside + (i % 2) * (width +  2 * SpaceBaside), backLab.current_y_h + SpaceBaside + (i / 2) * (width + 50), width, width)];
        imgaeButton.backgroundColor = [UIColor whiteColor];
        [imgaeButton sd_setImageWithURL:[NSURL URLWithString:_GLdataArray[i][@"cover"]] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
        NSInteger num = [[NSString stringWithFormat:@"%@",_GLdataArray[i][@"goods_id"]] integerValue];
        imgaeButton.tag = 1000 + num;
        [imgaeButton addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:imgaeButton];
        
        //添加序号
        UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(SpaceBaside + (width + 2 * SpaceBaside ) * (i % 2), SpaceBaside + width + backLab.current_y_h + (width)*(i / 2) + 50 * (i / 2), 15, 20)];
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.backgroundColor = [UIColor blueColor];
        [view addSubview:numberLabel];
        numberLabel.font = Font(13);
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.text = [NSString stringWithFormat:@"%d",i+1];
        
        //添加标题
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 3 * SpaceBaside + (width + 2 * SpaceBaside ) * (i % 2),SpaceBaside + width + backLab.current_y_h + (width)*(i / 2) + 50 * (i / 2), width - 30, 20)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor whiteColor];
        [view addSubview:titleLabel];
        titleLabel.font = Font(13);
        titleLabel.text = [NSString stringWithFormat:@"%@",_GLdataArray[i][@"title"]];;
        
        //添加积分
        UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(SpaceBaside + (width + 2 * SpaceBaside ) * (i % 2),SpaceBaside + width + backLab.current_y_h + (width)*(i / 2) + 50 * (i / 2) + 20, width - 20,20)];
        scoreLabel.textColor = [UIColor grayColor];
        scoreLabel.backgroundColor = [UIColor whiteColor];
        [view addSubview:scoreLabel];
        scoreLabel.font = Font(15);
        if (iPhone5o5Co5S) {
            scoreLabel.font = Font(12);
        } else if (iPhone6) {
            scoreLabel.font = Font(13);
        } else if (iPhone6Plus) {
            scoreLabel.font = Font(14);
        }
        scoreLabel.text = [NSString stringWithFormat:@"%@积分，库存%@",_GLdataArray[i][@"price"],_GLdataArray[i][@"stock"]];

        
        UILabel *allLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 230*MainScreenWidth/375 + 120 + (width + 50) * _GLdataArray.count/2  - 60, 200, 20)];
        allLabel.textColor = [UIColor grayColor];
        [view addSubview:allLabel];
        allLabel.font = Font(15);
        allLabel.text = @"全部商品";

        UILabel *headerlab = [[UILabel alloc]initWithFrame:CGRectMake(10, 230*MainScreenWidth/375 + 120 + (width + 50) *_GLdataArray.count/2  - 30, 200, 20)];
        [view addSubview:headerlab];
        headerlab.font = Font(15);
        headerlab.text = nil;
        if (_dataArray.count) {
             headerlab.text = [NSString stringWithFormat:@"1F  %@",_dataArray[0][@"cate_name"]];
        }

        view.frame = CGRectMake(0, 0, MainScreenWidth, 230*MainScreenWidth/375 + 60 + _GLdataArray.count * (width + 50) + 100);
        
    }
    
    
    return view;
}


#pragma mark --- 头部视图
- (void)addHeaderWithOutTableView {
    
    
    //添加滚动视图
    _headerSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight)];
    _headerSrcollView.backgroundColor = [UIColor whiteColor];
    _headerSrcollView.userInteractionEnabled = YES;
    [self.view addSubview:_headerSrcollView];
    
    
    
    
    // 情景二：采用网络图片实现
    NSMutableArray *imagesURLStrings = [NSMutableArray array];
    for (int i =0; i<_LBdataArray.count; i++) {
        [imagesURLStrings addObject:[NSString stringWithFormat:@"%@",_LBdataArray[i][@"banner"]]];
        
        NSString *banerurl = _LBdataArray[i][@"bannerurl"];
        [_banerurlArray addObject:banerurl];
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 230*MainScreenWidth/375 + 145)];
    view.backgroundColor = [UIColor whiteColor];
    [_headerSrcollView addSubview:view];
//    _headerView = view;
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, MainScreenWidth, 230*MainScreenWidth/375) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    cycleScrollView3.imageURLStringsGroup = imagesURLStrings;
    cycleScrollView3.backgroundColor = [UIColor cyanColor];
    cycleScrollView3.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView3.delegate = self;
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, cycleScrollView3.current_y_h, MainScreenWidth, 30)];
    lab.text = @"   兑换排行榜";
    lab.font = Font(15);
    [view addSubview:cycleScrollView3];
    [view addSubview:lab];
    
    UILabel *backLab = [[UILabel alloc]initWithFrame:CGRectMake(10, lab.current_y_h +3, MainScreenWidth - 20, 3)];
    backLab.backgroundColor = [UIColor blueColor];
    [view addSubview:backLab];
    backLab.alpha = 0.5;
    
    int width = MainScreenWidth/2 - 10;

    
    for (int i = 0 ; i < _GLdataArray.count ; i ++) {
        
        UIButton *imgaeButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside + (i % 2) * (width +  2 * SpaceBaside), backLab.current_y_h + SpaceBaside + (i / 2) * (width + 50), width, width)];
        imgaeButton.backgroundColor = [UIColor whiteColor];
        [imgaeButton sd_setImageWithURL:[NSURL URLWithString:_GLdataArray[i][@"cover"]] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
        NSInteger num = [[NSString stringWithFormat:@"%@",_GLdataArray[i][@"goods_id"]] integerValue];
        imgaeButton.tag = 1000 + num;
        [imgaeButton addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:imgaeButton];
        
        //添加序号
        UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(SpaceBaside + (width + 2 * SpaceBaside ) * (i % 2), SpaceBaside + width + backLab.current_y_h + (width)*(i / 2) + 50 * (i / 2), 15, 20)];
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.backgroundColor = [UIColor blueColor];
        [view addSubview:numberLabel];
        numberLabel.font = Font(13);
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.text = [NSString stringWithFormat:@"%d",i+1];
        
        //添加标题
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 3 * SpaceBaside + (width + 2 * SpaceBaside ) * (i % 2),SpaceBaside + width + backLab.current_y_h + (width)*(i / 2) + 50 * (i / 2), width - 30, 20)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor whiteColor];
        [view addSubview:titleLabel];
        titleLabel.font = Font(13);
        titleLabel.text = [NSString stringWithFormat:@"%@",_GLdataArray[i][@"title"]];;
        
        //添加积分
        UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(SpaceBaside + (width + 2 * SpaceBaside ) * (i % 2),SpaceBaside + width + backLab.current_y_h + (width)*(i / 2) + 50 * (i / 2) + 20, width - 20,20)];
        scoreLabel.textColor = [UIColor grayColor];
        scoreLabel.backgroundColor = [UIColor whiteColor];
        [view addSubview:scoreLabel];
        scoreLabel.font = Font(15);
        if (iPhone5o5Co5S) {
            scoreLabel.font = Font(12);
        } else if (iPhone6) {
            scoreLabel.font = Font(13);
        } else if (iPhone6Plus) {
            scoreLabel.font = Font(14);
        }
        scoreLabel.text = [NSString stringWithFormat:@"%@积分，库存%@",_GLdataArray[i][@"price"],_GLdataArray[i][@"stock"]];
        
        
        UILabel *allLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 230*MainScreenWidth/375 + 120 + (width + 50) * _GLdataArray.count/2  - 60, 200, 20)];
        allLabel.textColor = [UIColor grayColor];
        [view addSubview:allLabel];
        allLabel.font = Font(15);
        allLabel.text = @"全部商品";
        
        UILabel *headerlab = [[UILabel alloc]initWithFrame:CGRectMake(10, 230*MainScreenWidth/375 + 120 + (width + 50) *_GLdataArray.count/2  - 30, 200, 20)];
        [view addSubview:headerlab];
        headerlab.font = Font(15);
        headerlab.text = nil;
        if (_dataArray.count) {
            headerlab.text = [NSString stringWithFormat:@"1F  %@",_dataArray[0][@"cate_name"]];
        }
        
        view.frame = CGRectMake(0, 0, MainScreenWidth, 230*MainScreenWidth/375 + 60 + _GLdataArray.count * (width + 50) + 100);
         double hight = CGRectGetMaxY(headerlab.frame);
         _headerSrcollView.contentSize = CGSizeMake(0, hight + 100);
    }

}


#pragma mark -- UITableViewDatasoure

//头部视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        UIView *view = [self addHeaderView];
        return view;
        
    }else{
    
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,MainScreenWidth , 100, 50)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, MainScreenWidth - 20, 50)];
        NSInteger num = section+1;
        lab.text = [NSString stringWithFormat:@"%ldF  %@",num,_dataArray[section][@"cate_name"]];
        lab.textColor = [UIColor blackColor];
        [view addSubview:lab];
        /*
        UILabel *backLab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, lab.current_y_h + 15, MainScreenWidth, 3)];
        backLab2.backgroundColor = [UIColor blueColor];
        [view addSubview:backLab2];
         */
        return view;
    }
}
//尾部视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,MainScreenWidth , 100, 40)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(MainScreenWidth - 50, 0, 40, 40)];
    btn.titleLabel.font = Font(15);
    if ([_muArray[section] isEqualToString: @"1"]) {
        [btn setTitle:@"收起" forState:UIControlStateNormal];
    }else {
        [btn setTitle:@"更多" forState:UIControlStateNormal];
    }
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(changeCell:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = section + 100;
    [view addSubview:btn];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    float width = MainScreenWidth/3 - 40/3 + 120;
    NSInteger num = [_dataArray[indexPath.section][@"data_list"] count];
    if ([_muArray[indexPath.section] isEqualToString: @"0"]) {
        if (num>6) {
            num =6;
        }
    }
    num = num -1;
    num = num/3+1;
    NSLog(@"%ld",num);
    return width *num ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
//        return 230 * MainScreenWidth / 375 + 120 +(MainScreenWidth/2 - 10)*_GLdataArray.count/2 ;
        return  230*MainScreenWidth/375 + 60 + _GLdataArray.count / 2 * (MainScreenWidth / 2 - 20 + 50) + 50;
    }else{
    return 50;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 40;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    
    NSInteger num = [_dataArray[indexPath.section][@"data_list"] count];
    if ([_muArray[indexPath.section] isEqualToString: @"0"]) {
        if (num>6) {
            num = 6;
        }else{
            [_muArray replaceObjectAtIndex:indexPath.section withObject:@"2"];
        }
    }
    
    NSLog(@"%@",_dataArray[indexPath.section][@"data_list"]);
        for (int i = 0; i<num; i++) {
        float width = MainScreenWidth/3 - 40/3;
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10 +width*(i%3) +(i%3)*10,10+(120+width)*(i/3), width,width)];
        [img sd_setImageWithURL:[NSURL URLWithString:_dataArray[indexPath.section][@"data_list"][i][@"cover"]]];
        [cell.contentView addSubview:img];
        
        UILabel *titlelab = [[UILabel alloc]initWithFrame:CGRectMake( 10 +width*(i%3) +(i%3)*10, img.current_y_h + 10, width - 30, 20)];
        titlelab.textColor = [UIColor blackColor];
        [cell.contentView addSubview:titlelab];
        titlelab.font = Font(15);
        titlelab.textAlignment = NSTextAlignmentCenter;
        titlelab.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.section][@"data_list"][i][@"title"]];
        
        UILabel *lastlab = [[UILabel alloc]initWithFrame:CGRectMake(10 +width*(i%3) +(i%3)*10,titlelab.current_y_h +5, width - 20,35)];
        lastlab.textColor = [UIColor grayColor];
        [cell.contentView addSubview:lastlab];
        lastlab.font = Font(14);
        lastlab.numberOfLines = 2;
        lastlab.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.section][@"data_list"][i][@"info"]];
        lastlab.hidden = YES;
        
        UILabel *pricelab = [[UILabel alloc]initWithFrame:CGRectMake(10 +width*(i%3) +(i%3)*10, titlelab.current_y_h + 10, width, 20)];
        pricelab.textColor = [UIColor grayColor];
        [cell.contentView addSubview:pricelab];
        pricelab.font = Font(13);
        pricelab.text = [NSString stringWithFormat:@"%@积分,剩余%@名额",_dataArray[indexPath.section][@"data_list"][i][@"price"],_dataArray[indexPath.section][@"data_list"][i][@"fare"]];
        pricelab.textAlignment = NSTextAlignmentCenter;
        
        UIButton *bttn  = [[UIButton alloc]initWithFrame:CGRectMake(10 +width*(i%3) +(i%3)*10,10+(120+width)*(i/3), width,width)];
        [cell.contentView addSubview:bttn];
        [bttn addTarget:self action:@selector(sendBtn:) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"%@",_dataArray[indexPath.section][@"data_list"][i][@"goods_id"]);
        
        NSInteger num = [[NSString stringWithFormat:@"%@",_dataArray[indexPath.section][@"data_list"][i][@"goods_id"]] integerValue];
        bttn.tag = 10000 + num;
            NSLog(@"%ld",num);
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"点击了ecell");
    //classDetailVC *classDVc = [[classDetailVC alloc] initWithMemberId:_lookArray[indexPath.row][@"id"] andPrice:nil andTitle:_lookArray[indexPath.row][@"video_title"]];
    //classDVc.isLoad = @"123";
    // [self.navigationController pushViewController:classDVc animated:YES];
    
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
    AdViewController *adVc = [[AdViewController alloc] init];
    adVc.adStr = _banerurlArray[index];
    [self.navigationController pushViewController:adVc animated:YES];
    
}


-(void)changeCell:(UIButton *)sender{
    
    NSInteger num = sender.tag - 100;
    NSLog(@"%ld",num);
    if ([_muArray[num] isEqualToString: @"0"]) {
        [_muArray replaceObjectAtIndex:num withObject:@"1"];
        [_tableView reloadData];
    }else if ([_muArray[num] isEqualToString: @"1"]){
        [_muArray replaceObjectAtIndex:num withObject:@"0"];
        [_tableView reloadData];
    }else if ([_muArray[num] isEqualToString: @"2"]){
        [MBProgressHUD showError:@"没有更多数据" toView:self.view];
        StoreMoreViewController *storeMoreVc = [[StoreMoreViewController alloc] init];
        storeMoreVc.moreDic = _dataArray[sender.tag - 100];
        storeMoreVc.mallID = _dataArray[sender.tag - 100][@"cate_id"];
        [self.navigationController pushViewController:storeMoreVc animated:YES];
    }
}

-(void)sendBtn:(UIButton *)sender{

    NSString *ID = [NSString stringWithFormat:@"%ld",sender.tag - 10000];
    ShopDetailViewController *shopDetail = [[ShopDetailViewController alloc]initWithID:ID];
    [self.navigationController pushViewController:shopDetail animated:YES];
}

-(void)btnclick:(UIButton *)sender{

    NSString *ID = [NSString stringWithFormat:@"%ld",sender.tag - 1000];
    ShopDetailViewController *shopDetail = [[ShopDetailViewController alloc]initWithID:ID];
    [self.navigationController pushViewController:shopDetail animated:YES];

}

- (void)mallBtnclick:(UIButton *)button {
    
    NSString *ID = [NSString stringWithFormat:@"%ld",button.tag - 1000];
    ShopDetailViewController *shopDetail = [[ShopDetailViewController alloc]initWithID:ID];
    [self.navigationController pushViewController:shopDetail animated:YES];
}

@end
