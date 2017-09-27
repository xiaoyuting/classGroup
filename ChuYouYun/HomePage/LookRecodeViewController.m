//
//  LookRecodeViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/9/14.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//  观看记录

#import "LookRecodeViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "classDetailVC.h"
#import "BigWindCar.h"
#import "MBProgressHUD+Add.h"

#import "SYGClassTableViewCell.h"
#import "LookRecodeCell.h"



@interface LookRecodeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSArray *lookArray;

@end

@implementation LookRecodeViewController

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
    [self NetWork];
}


- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _lookArray = [NSArray array];
    
}


- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"观看记录";
    [WZLabel setTextColor:BasidColor];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];

    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
}

- (void)backPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 + 20 + 18) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 100;
    [self.view addSubview:_tableView];
    
}

#pragma mark -- UITableViewDatasoure


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _lookArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    LookRecodeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[LookRecodeCell alloc] initWithReuseIdentifier:cellID];
    }
    NSDictionary *dict = _lookArray[indexPath.row];
    [cell dataSourceWith:dict];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"----%@",_lookArray[indexPath.row]);
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    classDetailVC *classDVc = [[classDetailVC alloc] initWithMemberId:_lookArray[indexPath.row][@"video_info"][@"id"] andPrice:nil andTitle:_lookArray[indexPath.row][@"video_info"][@"video_title"]];
//    classDVc.isLoad = @"123";
    classDVc.img = _lookArray[indexPath.row][@"video_info"][@"cover"];
    classDVc.video_address = _lookArray[indexPath.row][@"video_section"][@"video_address"];
    [self.navigationController pushViewController:classDVc animated:YES];
    
}


- (void)NetWork {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"20" forKey:@"count"];
    
    [manager BigWinCar_GetRecord:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"======  %@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] != 1) {
            [MBProgressHUD showError:msg toView:self.view];
            return ;
        }
        _lookArray = responseObject[@"data"];
        if (_lookArray.count == 0) {
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 64 - 48)];
            imageView.image = [UIImage imageNamed:@"观看记录（空白）"];
            [_tableView addSubview:imageView];
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];

    
}

@end
