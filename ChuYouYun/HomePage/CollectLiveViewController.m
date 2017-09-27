//
//  CollectLiveViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/7/11.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "CollectLiveViewController.h"
#import "SYG.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "BigWindCar.h"
#import "MJRefresh.h"
#import "ZhiyiHTTPRequest.h"



#import "ClassRevampCell.h"
#import "ZhiBoMainViewController.h"


@interface CollectLiveViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSMutableArray *dataArray;

@property (assign ,nonatomic)NSInteger number;

@end

@implementation CollectLiveViewController

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
    [self addTableView];
    [self netWorkWithNumber:1];
    
}
- (void)interFace {
    
    self.view.backgroundColor = [UIColor whiteColor];
    _number = 1;
}

- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"退款申请";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- UITableView

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 98, MainScreenWidth, MainScreenHeight - 98 + 36) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 110;
    [self.view addSubview:_tableView];
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshings)];
    [_tableView headerBeginRefreshing];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
}


#pragma mark --- 刷新

- (void)headerRerefreshings
{
    [self netWorkWithNumber:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
    
    
}

- (void)footerRefreshing
{
    _number++;
    [self netWorkWithNumber:_number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
}



#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.05;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellID = @"GLLiveTableViewCell";
    //自定义cell类
    ClassRevampCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //自定义cell类
    if (cell == nil) {
        cell = [[ClassRevampCell alloc] initWithReuseIdentifier:CellID];
    }
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataWithDict:dict withType:@"2"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *Cid = nil;
    Cid = _dataArray[indexPath.row][@"source_info"][@"id"];
    NSString *Price = _dataArray[indexPath.row][@"source_info"][@"price"];
    NSString *Title = _dataArray[indexPath.row][@"source_info"][@"video_title"];
    NSString *ImageUrl = _dataArray[indexPath.row][@"source_info"][@"cover"];
    
    ZhiBoMainViewController *zhiBoMainVc = [[ZhiBoMainViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)indexPath.row andprice:Price];
    [self.navigationController pushViewController:zhiBoMainVc animated:YES];
}






#pragma mark ----网络请求

-(void)netWorkWithNumber:(NSInteger)number
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    [dic setObject:@"2" forKey:@"type"];
    [dic setObject:[NSString stringWithFormat:@"%ld",number] forKey:@"page"];
    [dic setObject:@"50" forKey:@"count"];
    
    [manager getpublicPort:dic mod:@"Video" act:@"getCollectVideoList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        NSLog(@"%@",responseObject);
        
        NSMutableArray * listArr = [[NSMutableArray alloc]initWithCapacity:0];
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            listArr = responseObject[@"data"];
        }
        if(number==1){
            if (listArr.count) {
                _dataArray = [NSMutableArray arrayWithArray:listArr];
                [_tableView reloadData];
            }else{
                //添加空白处理
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 64 - 48)];
                imageView.image = [UIImage imageNamed:@"直播（空白）"];
                [_tableView addSubview:imageView];
            }
        }else{
            if (listArr.count) {
                //                [_dataArray addObjectsFromArray:listArr];
            }else{
                [MBProgressHUD showError:@"没有更多数据" toView:self.view];
            }
            _dataArray = responseObject[@"data"];
        }
        NSLog(@"------%@",_dataArray);
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}





@end
