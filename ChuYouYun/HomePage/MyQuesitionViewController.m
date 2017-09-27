//
//  MyQuesitionViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/7/13.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "MyQuesitionViewController.h"
#import "SYG.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "BigWindCar.h"
#import "MJRefresh.h"
#import "ZhiyiHTTPRequest.h"


#import "MYWDTableViewCell.h"
#import "SYGWDViewController.h"

@interface MyQuesitionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSMutableArray *dataArray;

@property (assign ,nonatomic)NSInteger number;

@property (strong ,nonatomic)UIImageView *imageView;

@end

@implementation MyQuesitionViewController

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
    [self netWorkMYH];
    
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
    _tableView.rowHeight = 95;
    [self.view addSubview:_tableView];
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshings)];
    [_tableView headerBeginRefreshing];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
}


#pragma mark --- 刷新

- (void)headerRerefreshings
{
    //    [self netWorkWithNumber:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
    
    
}

- (void)footerRefreshing
{
    _number++;
    //    [self netWorkWithNumber:_number];
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
    
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    MYWDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MYWDTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    cell.titleLabel.text = _dataArray[indexPath.row][@"wd_description"];
    cell.timeLabel.text =  _dataArray[indexPath.row][@"ctime"];
    cell.personLabel.text = [NSString stringWithFormat:@"%@人回答",_dataArray[indexPath.row][@"wd_comment_count"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //    //这里需要取出自己的头像和名字
    NSString *Name = _dataArray[indexPath.row][@"uname"];
    NSString *Face = _dataArray[indexPath.row][@"userface"];
    NSString *CTime = _dataArray[indexPath.row][@"ctime"];
    NSString *ID = _dataArray[indexPath.row][@"id"];
    NSString *qstDescription = _dataArray[indexPath.row][@"wd_description"];
    
    SYGWDViewController *SYGVC = [[SYGWDViewController alloc] initWithQuizID:ID title:nil description:qstDescription uname:Name userface:Face ctime:CTime];
    [self.navigationController pushViewController:SYGVC animated:YES];
    
}






#pragma mark ----网络请求

- (void)netWorkMYH {//我的回答
    
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic =  [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    [manager MYAnsder:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"^^^^^%@",responseObject);
        
        _dataArray = responseObject[@"data"];
        _dataArray = responseObject[@"data"];
        NSLog(@"%@",responseObject[@"msg"]);
        
        if (_dataArray.count == 0) {//没有内容的时候
            //添加空白处理
            
            if (_imageView.subviews == nil) {//说明是没有的
                _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 98)];
                _imageView.image = [UIImage imageNamed:@"问答-回答@2x"];
            } else {//已经存在了
                _imageView.image = [UIImage imageNamed:@"问答-回答@2x"];
            }
            
            [_tableView addSubview:_imageView];
            _imageView.hidden = NO;
            
            
        } else {
            self.tableView.alpha = 1.0;
            _imageView.hidden = YES;
            _imageView.alpha = 0;
            [_imageView removeFromSuperview];
            [_imageView removeFromSuperview];
            
            [self.tableView reloadData];
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"加载失败" toView:self.view];
        [self.tableView reloadData];
    }];
    
    
}





@end
