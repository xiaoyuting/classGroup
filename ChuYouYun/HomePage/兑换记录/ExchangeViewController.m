//
//  ExchangeViewController.m
//  dafengche
//
//  Created by IOS on 16/10/12.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "ExchangeViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "MyHttpRequest.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "MBProgressHUD+Add.h"

#import "Passport.h"


@interface ExchangeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSArray *dataArray;
@property (strong ,nonatomic)NSMutableArray *lookArray;
@property (assign ,nonatomic)NSInteger number;


@end

@implementation ExchangeViewController

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

}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"兑换记录";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 300, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,286)];
    [backButton setTitle:@" " forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    //设置button上字体的偏移量
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10.0 , 0.0, 0)];
    [SYGView addSubview:backButton];

}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 55;
    [self.view addSubview:_tableView];
    //添加刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [_tableView headerBeginRefreshing];

    
}
- (void)headerRerefreshing
{
    _number = 1;
    [self requestData:_number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
}

- (void)footerRefreshing
{
    _number++;
    [self requestData:_number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
}

#pragma mark -- UITableViewDatasoure


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    UILabel *headerLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    headerLab.text = @"支付";
    headerLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [cell.contentView addSubview:headerLab];
    headerLab.font  = Font(13);
    
    UILabel *detilLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, MainScreenWidth - 130 , 20)];
    detilLab.text = _dataArray[indexPath.row][@"source_info"][@"title"];
    detilLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [cell.contentView addSubview:detilLab];
    detilLab.font  = Font(13);
    
    UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(MainScreenWidth - 210, 10, 200, 20)];
    timeLab.text = [Passport formatterTime:_dataArray[indexPath.row][@"ctime"]];;
    timeLab.textColor = [UIColor grayColor];
    [cell.contentView addSubview:timeLab];
    timeLab.alpha = 0.7;
    timeLab.font  = Font(12);
    timeLab.textAlignment = NSTextAlignmentRight;
    
    UILabel *last = [[UILabel alloc]initWithFrame:CGRectMake(MainScreenWidth - 130, 35, 120, 20)];
    last.text = [NSString stringWithFormat:@"-%@积分",_dataArray[indexPath.row][@"price"]];;
    last.textColor = BasidColor;
    last.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:last];
    last.font  = Font(13);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark ---- 网络请求
-(void)requestData:(NSInteger)num {
        
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    manager.requestSerializer.timeoutInterval = 10.0;
    
    NSString *key = [user objectForKey:@"oauthToken"];
    NSString *passWord = [user objectForKey:@"oauthTokenSecret"];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:key forKey:@"oauth_token"];
    [dic setValue:passWord forKey:@"oauth_token_secret"];
//    [dic setValue:[NSNumber numberWithInteger:num] forKey:@"page"];
//    [dic setValue:@"10" forKey:@"count"];
    
    [dic setValue:@"exchange" forKey:@"type"];
    
    [manager getpublicPort:dic mod:@"Order" act:@"getOrder" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"===__===%@",responseObject);
        
        if ([responseObject[@"data"] count] == 0) {
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 64 - 48)];
            imageView.image = [UIImage imageNamed:@"兑换记录（空白）"];
            [_tableView addSubview:imageView];
            
            return ;
        }else{
            _dataArray = responseObject[@"data"];
            NSLog(@"=====%@",_dataArray);
            [_tableView reloadData];
        }
        
        if (_dataArray.count != 0) {
            //上拉加载
            [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"获取失败" toView:self.view];
    }];
    
}



@end
