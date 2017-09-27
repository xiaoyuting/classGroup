//
//  CollectClassViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/7/11.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "CollectClassViewController.h"
#import "SYG.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "BigWindCar.h"
#import "MJRefresh.h"
#import "ZhiyiHTTPRequest.h"

#import "ClassRevampCell.h"
#import "classDetailVC.h"
#import "mySCClass.h"



@interface CollectClassViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSMutableArray *dataArray;

@property (assign ,nonatomic)NSInteger number;

@end

@implementation CollectClassViewController
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
    [self reloadDataClass];
    
}
- (void)interFace {
    
    self.view.backgroundColor = [UIColor whiteColor];
    _number = 0;
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
    //    [self NetWorkGetOrderWithNumber:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
    
    
}

- (void)footerRefreshing
{
    _number++;
    //    [self NetWorkGetOrderWithNumber:_number];
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
    
    static NSString *CellID = @"ClassRevampCell";
    //自定义cell类
    ClassRevampCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //自定义cell类
    if (cell == nil) {
        cell = [[ClassRevampCell alloc] initWithReuseIdentifier:CellID];
    }
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataWithDict:dict withType:@"1"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *ID = _dataArray[indexPath.row][@"id"];
    NSString *price = _dataArray[indexPath.row][@"price"];
    NSString *title = _dataArray[indexPath.row][@"video_title"];
    
    classDetailVC *detailVc = [[classDetailVC alloc] initWithMemberId:ID andPrice:price andTitle:title];
    detailVc.videoTitle = title;
    detailVc.navigationItem.title = title;
    detailVc.img = _dataArray[indexPath.row][@"imageurl"];
    detailVc.video_address = _dataArray[indexPath.row][@"videoAddress"];
    [self.navigationController pushViewController:detailVc animated:YES];
}






#pragma mark ----网络请求

-(void)reloadDataClass
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:@"1"forKey:@"page"];
    [dic setObject:@"50"forKey:@"count"];
    [dic setObject:@"1"forKey:@"type"];
    
    NSArray *classArray = [mySCClass BJWithDic:dic];
    [manager userAttentionCrouse:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        NSLog(@"%@",responseObject);
        _dataArray = responseObject[@"data"];
        NSMutableArray *muArr = [[NSMutableArray alloc]initWithCapacity:0];
        if (classArray.count) {
        } else {
            if (![_dataArray isEqual:[NSNull null]]) {
                //缓存数据
                [mySCClass saveBJes:_dataArray];
            }
        }
        
        if (![[responseObject objectForKey:@"data"] isEqual:[NSNull null]] && _dataArray.count > 0 ) {
            muArr = [responseObject objectForKey:@"data"];
            _dataArray = responseObject[@"data"];
        }else{
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 64 - 48)];
            imageView.image = [UIImage imageNamed:@"收藏-课程@2x"];
            [_tableView addSubview:imageView];
        }
        
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"加载失败" toView:self.view];
        _dataArray = classArray;
        [_tableView reloadData];
    }];
}




@end
