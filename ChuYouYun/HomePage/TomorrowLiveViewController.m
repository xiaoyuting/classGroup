//
//  TomorrowLiveViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/3/13.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "TomorrowLiveViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "MJRefresh.h"
#import "BigWindCar.h"
#import "MBProgressHUD+Add.h"


#import "GLLiveTableViewCell.h"
#import "DLViewController.h"
#import "LiveDetailsViewController.h"
#import "ZhiBoMainViewController.h"


#import "ClassRevampCell.h"


@interface TomorrowLiveViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (assign ,nonatomic)NSInteger number;

@end

@implementation TomorrowLiveViewController

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
    [self addTableView];
    [self netWorkHomeGetLiveByTimespanWithNumber:1];
}

- (void)interFace {
//    _dataArray = [NSMutableArray array];
    _number = 1;
}



#pragma mark --- 表格视图


- (void)addTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, MainScreenWidth, MainScreenHeight - 64 + 36) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 110;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
//    //下拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [_tableView headerBeginRefreshing];
//
    //上拉加载
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,5,0,0)];
    }
    //设置表格分割线的长度（跟两边的距离）
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,2,0,0)];
    }    //添加线


    
}

#pragma mark ---- 刷新

- (void)headerRerefreshing {
    _number = 1;
    [self netWorkHomeGetLiveByTimespanWithNumber:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
}

- (void)footerRefreshing {
    _number ++;
    [self netWorkHomeGetLiveByTimespanWithNumber:_number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectio{
    
    return 0.1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    // 这里应该判断是否已经登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    NSString *Cid = _dataArray[indexPath.row][@"live_id"];
    NSString *Title = _dataArray[indexPath.row][@"video_title"];
    NSString *ImageUrl = _dataArray[indexPath.row][@"cover"];
    ZhiBoMainViewController *zhiBoMainVc = [[ZhiBoMainViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)indexPath.row andprice:_dataArray[indexPath.row][@"t_price"]];
    [self.navigationController pushViewController:zhiBoMainVc animated:YES];
}

#pragma mark --- 网络请求

//网络请求  今日直播
- (void)netWorkHomeGetLiveByTimespanWithNumber:(NSInteger)number {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if (UserOathToken == nil) {
    } else {
        [dic setObject:UserOathToken forKey:@"oauth_token"];
        [dic setObject:UserOathTokenSecret forKey:@"oauth_token_secret"];
    }
    
    [dic setObject:[NSString stringWithFormat:@"%ld",number] forKey:@"page"];
    [dic setObject:@"10" forKey:@"count"];
    [dic setObject:@"tomorrow" forKey:@"strtime"];
    
    
    [manager BigWinCar_getLiveByTimespan:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1) {
            
        } else {
            [MBProgressHUD showError:@"没有直播的" toView:self.view];
            [_tableView reloadData];
            return;
        }
        
        if (number == 1) {
            _dataArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        } else {
            [_dataArray addObjectsFromArray:responseObject[@"data"]];
        }
        
        NSLog(@"%ld",_dataArray.count);
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}




@end
