//
//  BlumClassifyVc.m
//  ChuYouYun
//
//  Created by 智艺创想 on 15/10/15.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "BlumClassifyVc.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "Helper.h"
#import "classClassifyCell.h"
#import "classViewController.h"
#import "MyHttpRequest.h"
#import "categoryList.h"
#import "tolerateClassVC.h"
#import "blumViewController.h"
#import "FLTableViewCell.h"
#import "BlumFL.h"

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width


@interface BlumClassifyVc () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray * dataArray;
}


@end

@implementation BlumClassifyVc

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
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
    
    UIButton *allButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 20, 50, 40)];
//    [allButton setImage:[UIImage imageNamed:@"点评返回@2x"] forState:UIControlStateNormal];
    [allButton setTitle:@"全部" forState:UIControlStateNormal];
    [allButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [allButton addTarget:self action:@selector(allPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:allButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"专辑分类";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNav];
    //添加右边的按钮  （全部）
    UIButton *allButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 20)];
    [allButton setTitle:@"全部" forState:UIControlStateNormal];
    [allButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [allButton addTarget:self action:@selector(allPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bake = [[UIBarButtonItem alloc] initWithCustomView:allButton];
    [self.navigationItem setRightBarButtonItem:bake];
    
    //返回按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, 25, 25)];
    [backButton setImage:[UIImage imageNamed:@"CIRCLE _ DELETE"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *baken = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:baken];
    
    
    self.title = @"选择分类";
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate =self;
    _tableView.rowHeight = 50;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    [self requestDataBlum];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}


//让分割线紧挨左边屏幕
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)requestDataBlum
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    //http://demo.51eduline.com/index.php?app=api&mod=Video&act=getVideoGroup&cateId=2
    [dic setValue:@"2" forKey:@"cateId"];
    
    NSArray *FLArray = [BlumFL BJWithDic:dic];
    
    [manager getCategory:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        _dataArray2 = [responseObject objectForKey:@"data"];
        
        if (FLArray.count) {//不需要缓存
            
        } else {//需要
            [BlumFL saveBJes:_dataArray2];
        }
        
        NSMutableArray * listArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (int i =0; i<_dataArray2.count; i++) {
            categoryList * list = [[categoryList alloc]initWithDictionarys:_dataArray2[i]];
            [listArr addObject:list];
        }
        _dataArray2 = listArr;
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@" ======   %@   error  :%@",operation.responseString,error);
        _dataArray2 = FLArray;
        [_tableView reloadData];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray2.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    FLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FLTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    categoryList * list = _dataArray2[indexPath.row];
    cell.CLabel.text = list.Category_title;

    return cell;
    
}

- (void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    categoryList * list = _dataArray2[indexPath.row];
    blumViewController * vc = [[blumViewController alloc]initWithMemberId:list.categoryId];
    [self.navigationController pushViewController:vc animated:YES];
}

//创建btn用于 创建导航按钮时用
-(UIButton *)button:(NSString *)title image:(NSString *)image frame:(CGRect)frame
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    //设置字体大小
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setBackgroundImage:[Helper imageNamed:image cache:YES] forState:UIControlStateNormal];
    return button;
}

- (void)allPressed
{
    
    blumViewController * vc = [[blumViewController alloc]initWithMemberId:@"0"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
