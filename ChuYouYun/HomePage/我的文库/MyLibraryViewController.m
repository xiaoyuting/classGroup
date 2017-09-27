//
//  MyLibraryViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/10.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "MyLibraryViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "MyHttpRequest.h"
#import "MJRefresh.h"


#import "ZFDownloadManager.h"
#import "GLNetWorking.h"
#import "MBProgressHUD+Add.h"


#import "LibraryCell.h"


@interface MyLibraryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)NSString *downUrl;
@property (strong ,nonatomic)NSString *downName;
@property (strong ,nonatomic)NSString *downExtension;

@end

@implementation MyLibraryViewController

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
    [self netWorkList];
}
- (void)interFace {
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"我的文库";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 + 38) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 105;
    [self.view addSubview:_tableView];
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshings)];
    [_tableView headerBeginRefreshing];

}

#pragma mark --- 刷新

- (void)headerRerefreshings
{
    //    [self reachGO];
    //    [self requestData:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
    
    
}

- (void)footerRefreshing
{
    //    _numder++;
    //    [self requestData:_numder];
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
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    LibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LibraryCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataSourceWith:dict];
    
    [cell.downButton addTarget:self action:@selector(downButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.downButton.tag = indexPath.row;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
//    LibraryDetailViewController *libDetaliVc = [[LibraryDetailViewController alloc] init];
//    [self.navigationController pushViewController:libDetaliVc animated:YES];
}
#pragma mark --- 事件监听
- (void)buttonCilck:(UIButton *)button {
    
    
}

- (void)downButtonClick:(UIButton *)button {
    _downUrl = _dataArray[button.tag][@"attach"];
    _downName = _dataArray[button.tag][@"title"];
    _downExtension = _dataArray[button.tag][@"attach_info"][@"extension"];
    NSLog(@"%@",_downName);
    [self downButtonClick];
}

- (void)CateButton {
//    LibCateViewController *libCateVc = [[LibCateViewController alloc] init];
//    [self.navigationController pushViewController:libCateVc animated:YES];
}

#pragma mark --- 网络请求
- (void)netWorkList {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:@"0" forKey:@"doc_category_id"];
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"100" forKey:@"count"];
    [dic setValue:@"" forKey:@"keyword"];
    
    [manager BigWinCar_LibiaryGetMyDocList:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        if ([responseObject[@"code"] integerValue ] != 1) {
            return ;
        }
        _dataArray = responseObject[@"data"];
        [_tableView reloadData];
        
        if (_dataArray.count != 0) {
            [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
        } else {
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 64 - 48)];
            imageView.image = [UIImage imageNamed:@"文库（空白）"];
            [_tableView addSubview:imageView];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
    
    
}


#pragma mark --- 下载

-(void)downButtonClick{
    
    if ([[GLNetWorking isConnectionAvailable] isEqualToString:@"4G"] || [[GLNetWorking isConnectionAvailable] isEqualToString:@"3G"] || [[GLNetWorking isConnectionAvailable] isEqualToString:@"2G"]) {
        UIAlertView *_downAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"如果您正在使用2G/3G/4G,如果继续运营商可能会收取流量费用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_downAlertView show];
        });
        
    } else {
        [self downLoadVideo];
    }
}

-(void)downLoadVideo{
    
    UIImage *image = Image(@"文档图标");
    NSString *libriyName = [NSString stringWithFormat:@"%@.%@",_downName,_downExtension];
    
    if (!_downUrl.length) {
        [MBProgressHUD showError:@"下载地址为空" toView:self.view];
        return ;
    }
    [[ZFDownloadManager sharedDownloadManager] downFileUrl:_downUrl filename:libriyName fileimage:image];
    //设置最多同时下载个数（默认是3）
    [ZFDownloadManager sharedDownloadManager].maxCount = 1;

    //保存到本地
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:_downUrl forKey:libriyName];
    [defaults synchronize];
    
}
//根据被点击按钮的索引处理点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        [self downLoadVideo];
    }else
        return;
}



@end
