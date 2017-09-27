//
//  recordViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/27.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "recordViewController.h"
#import "recordCell.h"
#import "QueryViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "BBaseClass.h"
#import "BData.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "Passport.h"

@interface recordViewController ()
{
    int _page;
    CGRect rect;
}
@end

@implementation recordViewController
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNav];
    self.navigationItem.title = @"交易记录";
     rect = [UIScreen mainScreen].applicationFrame;
    // Do any additional setup after loading the view from its nib.

//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多查询" style:UIBarButtonItemStylePlain target:self action:@selector(btnClick)];
    self.muArr = [[NSMutableArray alloc]initWithCapacity:0];
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setUpRefresh];
    [self reloadDealRecord:_page];

}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 12, 22)];
    [backButton setImage:[UIImage imageNamed:@"iconfont-FH"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"交易记录";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}




-(void)reloadDealRecord:(int)page
{
    ZhiyiHTTPRequest *manager =[ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary  alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:[NSString stringWithFormat:@"%d", _page] forKey:@"page"];
    [dic setObject:@"10" forKey:@"count"];
    //获取当前时间
    NSDate *  datenow=[NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
//    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//    
//    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    
//    NSString *  locationString=[dateformatter stringFromDate:senddate];
//    NSLog(@"%@",locationString);
    [dic setObject:timeSp forKey:@"et"];
    //获取开始时间
    NSString *olderTimeString = @"2015-02-01 00:00:00";
    [dic setObject:olderTimeString forKey:@"st"];
    
    [manager reloadUserDealRecord:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"^^^^^^^%@",responseObject);
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {
            self.tableView.alpha = 0;
//            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake((rect.size.width-200)/2, 70, 200, 21)];
//            lbl.font = [UIFont systemFontOfSize:16];
//            lbl.textAlignment = NSTextAlignmentCenter;
//            lbl.text = @"没有交易记录，去逛逛吧~";
//            lbl.textColor = [UIColor colorWithRed:36.0/255.0 green:102.0/255.0 blue:167.0/255.0 alpha:1];
//            [self.view addSubview:lbl];
            
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
            imageView.image = [UIImage imageNamed:@"交易记录@2x"];
            [self.view addSubview:imageView];

            
            
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
    [self reloadDealRecord:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
}

- (void)footerRefreshing
{
    _page++;
    [self reloadDealRecord:_page];
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
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
