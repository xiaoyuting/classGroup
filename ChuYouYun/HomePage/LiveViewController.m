//
//  LiveViewController.m
//  ChuYouYun
//
//  Created by IOS on 16/7/29.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "LiveViewController.h"
#import "MyHttpRequest.h"
#import "teacherList.h"
#import "classTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "MJRefreshBaseView.h"
#import "LiveDetailsViewController.h"
#import "classViewController.h"
#import "SYGClassTool.h"
#import "SYGClassTableViewCell.h"
#import "UIButton+WebCache.h"
#import "GLReachabilityView.h"
#import "UIColor+HTMLColors.h"
#import "classClassifyVc.h"
#import "blumViewController.h"
#import "LiveCategorryViewController.h"
#import "MBProgressHUD+Add.h"
#import "AppDelegate.h"
#import "GLClassViewController.h"
#import "DLViewController.h"
#import "GLLiveTableViewCell.h"
#import "ZhiBoMainViewController.h"

#import "BigWindCar.h"
#import "SYG.h"
#import "ClassRevampCell.h"



#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define iOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

@interface LiveViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray * dataArray2;
    classViewController * cvc;
    UIView *_view;
    UILabel *_lable;
    
}

@property(nonatomic,assign)NSInteger numder;


@end

@implementation LiveViewController

- (instancetype)initWithId:(NSString *)Id
{
    if (self=[super init]) {
        _cateory_id = Id;
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
    //创建view
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    //添加分类按钮
    UIButton *FLButton = [UIButton buttonWithType:UIButtonTypeSystem];
    FLButton.frame = CGRectMake(MainScreenWidth-35, 30, 20, 20);
    [FLButton setBackgroundImage:[UIImage imageNamed:@"fenleisyg"] forState:UIControlStateNormal];
    [FLButton addTarget:self action:@selector(gokind) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"直播";
    [navView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 60, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,46)];
    [backButton setTitle:@" " forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    //设置button上字体的偏移量
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10.0 , 0.0, 0)];
    [navView addSubview:backButton];
    
    _view = (UIView *)[GLReachabilityView popview];
    [self.view addSubview:_view];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, MainScreenWidth, MainScreenHeight - 64 + 20 + 16) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 110;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    dataArray2 = [[NSMutableArray alloc]init];
    
    //下拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [_tableView headerBeginRefreshing];
    
//    //上拉加载
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
//
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,5,0,0)];
    }
    //设置表格分割线的长度（跟两边的距离）
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,2,0,0)];
    }    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [navView addSubview:lineLab];
}

- (void)backPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)gokind{
    
    NSArray *arr = @[@"ios",@"java",@"phh"];
    LiveCategorryViewController * vc = [[LiveCategorryViewController alloc]initwithTitle:@"直播" array:arr id:@"2"];
    rootViewController * ntvc;
    [ntvc isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshHeader
{
    [_tableView headerBeginRefreshing];
}

- (void)headerRerefreshing
{
    _numder = 1;
    [self netWorkHomeGetLiveByTimespanWithNumber:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        if (_dataArray.count==0) {
            _lable.textColor = [UIColor colorWithHexString:@"#dedede"];
        }else{
            _lable.textColor = [UIColor clearColor];
        }
    });
}

- (void)footerRefreshing
{
    //先隐藏
    _numder++;
    [self netWorkHomeGetLiveByTimespanWithNumber:_numder];
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
    [dic setObject:@"today" forKey:@"strtime"];
    
    [manager BigWinCar_getLiveByTimespan:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1) {
        } else {
            [MBProgressHUD showError:@"没有直播的" toView:self.view];
            return;
        }
        
        if (number == 1) {
            _dataArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        } else {
            [_dataArray addObjectsFromArray:responseObject[@"data"]];
        }

        [_tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}



//去掉HTML字符
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO){
        
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        
        //        //找到标签的起始位置
        //        [scanner scanUpToString:@"<" intoString:nil];
        //        //找到标签的结束位置
        //        [scanner scanUpToString:@">" intoString:&text];
        
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    }
    // NSString * regEx = @"<([^>]*)>";
    // html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

@end
