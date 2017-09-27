//
//  LibraryViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/10/9.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "LibraryViewController.h"
#import "SYG.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "ZhiyiHTTPRequest.h"
#import "BigWindCar.h"
#import "MyHttpRequest.h"
#import "MBProgressHUD+Add.h"
#import "MJRefresh.h"


#import "LibraryCell.h"
#import "LibCateViewController.h"
#import "LibraryDetailViewController.h"

#import "ZFDownloadManager.h"
#import "GLNetWorking.h"


@interface LibraryViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)NSString *downUrl;
@property (strong ,nonatomic)NSString *downName;
@property (assign ,nonatomic)NSInteger num;
@property (strong ,nonatomic)NSString *docID;
@property (strong ,nonatomic)NSString *downExtension;

@property (strong ,nonatomic)NSString *doc_Category_ID;
@property (assign ,nonatomic)NSInteger indexRow;

@end

@implementation LibraryViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetLib_Category_ID:) name:@"NotificationLib_Category_ID" object:nil];
  
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
//    [self addScreenView];
    [self addTableView];
    //    [self NetWork];
//    [self netWork];
//    [self netWorkCate];
    [self netWorkList:_num];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];
    _num = 1;
    _doc_Category_ID = @"0";
    _indexRow = 0;

}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"文库";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    UIButton *SXButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 40, 32, 40, 20)];
    [SXButton setBackgroundImage:[UIImage imageNamed:@"问答分类@2x"] forState:UIControlStateNormal];
    [SXButton addTarget:self action:@selector(CateButton) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:SXButton];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addScreenView {
    UIView *screenView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 40)];
    screenView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:screenView];
    
    NSArray *titleArray = @[@"综合排序",@"筛选"];
    for (int i = 0; i < 2 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * MainScreenWidth / 2, 5, MainScreenWidth / 2, 30)];
        button.titleLabel.font = Font(15);
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:BlackNotColor forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"灰色乡下"] forState:UIControlStateNormal];
        button.imageEdgeInsets =  UIEdgeInsetsMake(0,MainScreenWidth / 2 - 70,0,80);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 30);
        
        button.tag = i;
        [button addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [screenView addSubview:button];
    }

}

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 40 - 40, MainScreenWidth, MainScreenHeight - 64 + 36) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 105;
    [self.view addSubview:_tableView];
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshings)];
    [_tableView headerBeginRefreshing];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
}

#pragma mark --- 刷新
- (void)headerRerefreshings
{
    [self netWorkList:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
}

- (void)footerRefreshing
{
    _num ++;
    [self netWorkList:_num];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
}


#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = nil;
    CellIdentifier = [NSString stringWithFormat:@"cell - %ld",indexPath.row];
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

#pragma mark --- 通知

- (void)GetLib_Category_ID:(NSNotification *)Not {
    _doc_Category_ID = (NSString *)Not.userInfo;
    _num = 1;
    [self netWorkList:_num];
}

#pragma mark --- 事件监听
- (void)buttonCilck:(UIButton *)button {

    
}

- (void)downButtonClick:(UIButton *)button {
    
    _downUrl = _dataArray[button.tag][@"attach"];
    _docID = _dataArray[button.tag][@"doc_id"];
    _downName = _dataArray[button.tag][@"title"];
    _downExtension = _dataArray[button.tag][@"attach_info"][@"extension"];
    _indexRow = button.tag;
    NSString *title = button.titleLabel.text;
    if ([title isEqualToString:@"下载"]) {
        [self downButtonClick];
    } else if ([title isEqualToString:@"兑换"]) {
        [self netWorkExchange:_docID];
    }
    
}

- (void)CateButton {
    LibCateViewController *libCateVc = [[LibCateViewController alloc] init];
    [self.navigationController pushViewController:libCateVc animated:YES];
}

#pragma mark --- 网络请求
- (void)netWorkList:(NSInteger)Num{
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }

    [dic setValue:_doc_Category_ID forKey:@"doc_category_id"];
    [dic setValue:[NSString stringWithFormat:@"%ld",Num] forKey:@"page"];
    [dic setValue:@"20" forKey:@"count"];
    [dic setValue:@"" forKey:@"keyword"];
    if (Num == 1) {
//        [MBProgressHUD showError:@"数据加载中...." toView:self.view];
    }

    [manager BigWinCar_LibiaryList:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        NSLog(@"======  %@",responseObject);
        
        
        NSLog(@"%@",operation);
         if ([responseObject[@"code"] integerValue ] != 1) {
             [MBProgressHUD showError:@"没有数据" toView:self.view];
             return ;
         }
//        [MBProgressHUD showError:@"加载完成...." toView:self.view];
        
        if (_num == 1) {
            NSArray *oneArray = responseObject[@"data"];
            if (!oneArray.count) {
                [MBProgressHUD showError:@"没有相关数据" toView:self.view];
                _dataArray = nil;
                [_tableView reloadData];
                return;
            } else {
                _dataArray = [NSMutableArray arrayWithArray:oneArray];
            }
        } else {
            NSArray *array = responseObject[@"data"];
            if (!array.count) {
                [MBProgressHUD showError:@"没有更多数据了" toView:self.view];
            } else {
                [_dataArray addObjectsFromArray:array];
            }
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MBProgressHUD showError:@"请求数据失败" toView:self.view];
    }];
 
    
}

//积分兑换
- (void)netWorkExchange:(NSString *)docID {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    } else {
        [MBProgressHUD showError:@"请先登陆" toView:self.view];
        return;
    }
    
    [dic setValue:docID forKey:@"doc_id"];
    
    [manager BigWinCar_LibiaryExchange:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = responseObject[@"msg"];
        
        if ([responseObject[@"code"] integerValue] == 1) {
            [MBProgressHUD showSuccess:@"兑换成功" toView:self.view];
            //替换当前
//            [_dataArray replaceObjectAtIndex:_indexRow withObject:@"下载"];
            [self netWorkRefrsehList:_indexRow / 20 ];
//            [self netWorkRefrsehList:0];
            
//            //刷新当前当前
//            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_indexRow inSection:0];
//            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"兑换失败" toView:self.view];
    }];
    
}


//刷新某条数据时候
- (void)netWorkRefrsehList:(NSInteger)Num{
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:_doc_Category_ID forKey:@"doc_category_id"];
    [dic setValue:[NSString stringWithFormat:@"%ld",Num] forKey:@"page"];
    [dic setValue:@"20" forKey:@"count"];
    [dic setValue:@"" forKey:@"keyword"];
    
    [manager BigWinCar_LibiaryList:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        NSLog(@"======  %@",responseObject);
        
        NSArray *refresh = responseObject[@"data"];
        
        [_dataArray replaceObjectAtIndex:_indexRow withObject:refresh[_indexRow % 20]];
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"请求数据失败" toView:self.view];
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
