//
//  DealFromDateViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/12.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#import "DealFromDateViewController.h"
#import "recordCell.h"
#import "QueryViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "BBaseClass.h"
#import "BData.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "Passport.h"
#import "UIColor+HTMLColors.h"
#import "GLReachabilityView.h"

@interface DealFromDateViewController ()
{
    int _page;
    CGRect rect;
}
@end

@implementation DealFromDateViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
}
-(id)initWithQueryDateNowDate:(NSString *)nowDate fromDate:(NSString *)fDate
{
    self = [super init];
    if (self) {
        self.now = nowDate;
        self.fromDate = fDate;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"查询交易记录";
     rect = [UIScreen mainScreen].applicationFrame;
    
    self.muArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setUpRefresh];
    [self reloadDealRecord:_page queryDate:self.now fromData:self.fromDate];
    
}
-(void)reloadDealRecord:(int)page queryDate:(NSString *)nowDate fromData:(NSString *)date
{
    ZhiyiHTTPRequest *manager =[ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary  alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:[NSString stringWithFormat:@"%d", _page] forKey:@"page"];
    [dic setObject:@"10" forKey:@"count"];
#pragma !!!!!!!!!!!!!!!!!!! 此处的网络请求有问题
//    [dic setObject:[NSString stringWithFormat:@"%@",nowDate] forKey:@"st"];
//    [dic setObject:[NSString stringWithFormat:@"%@",date] forKey:@"et"];
    NSLog(@"%@",self.now);
    [dic setObject:self.now forKey:@"st"];
    NSLog(@"%@",self.fromDate);
    [dic setObject:self.fromDate forKey:@"et"];

    [manager reloadUserDealRecord:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"^^^8^^^^%@",responseObject);
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {
            self.tableView.alpha = 0;
            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake((rect.size.width-200)/2, 70, 200, 21)];
            lbl.font = [UIFont systemFontOfSize:16];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.text = @"没有记录，快去逛逛吧~";
            lbl.textColor = [UIColor colorWithRed:36.0/255.0 green:102.0/255.0 blue:167.0/255.0 alpha:1];
            [self.view addSubview:lbl];
        } else {
            BBaseClass *bb = [[BBaseClass alloc]init];
            bb.data = [responseObject objectForKey:@"data"];
            NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:0];
            if (bb.data.count == 0) {
                return;
            }
            for (int i = 0; i <bb.data.count; i++) {
                BData *bd = [bb.data objectAtIndex:i];
                [arr addObject:bd];
            }
            self.muArr = arr;
        }
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)setUpRefresh
{
    //下拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [_tableView headerBeginRefreshing];
    
    //上拉加载
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
}

- (void)headerRerefreshing
{
    [self reloadDealRecord:1 queryDate:nil fromData:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
}

- (void)footerRefreshing
{
    _page++;
    [self reloadDealRecord:_page queryDate:nil fromData:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.muArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Cell";
    recordCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell)
    {
        NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"recordCell" owner:nil options:nil];
        cell = [cellArr objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:[self.muArr objectAtIndex:indexPath.row]];
    BData *bd = [[BData alloc]initWithDictionary:dic];
    NSString *str = [NSString stringWithFormat:@"-%@",bd.price];
    cell.numberLbl.text = str;
    NSRange range = [str rangeOfString:@"-"];
    if (range.length > 0) {
        cell.numberLbl.textColor = [UIColor orangeColor];
    }
    cell.remainingLbl.text = bd.title;
    cell.dateLbl.text = [Passport formatterDate:bd.ctime];
    return cell;
}
-(void)btnClick
{
    QueryViewController *q = [[QueryViewController alloc]init];
    [self.navigationController pushViewController:q animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
