//
//  LiveCategorryViewController.m
//  ChuYouYun
//
//  Created by IOS on 16/11/16.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "LiveCategorryViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "Helper.h"
#import "classClassifyCell.h"
#import "classViewController.h"
#import "MyHttpRequest.h"
#import "categoryList.h"
#import "tolerateClassVC.h"
#import "FLTableViewCell.h"
#import "ClassFL.h"
#import "UIColor+HTMLColors.h"
#import "LiveViewController.h"

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width


@interface LiveCategorryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray * dataArray;
    UILabel *_lable;
    NSArray *_dataArr;
    NSString *_title;
    NSArray * _IDNum;
    NSMutableArray * _IDArray;
    
}
@end


@implementation LiveCategorryViewController


-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    _IDArray = [NSMutableArray array];
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(instancetype)initwithTitle:(NSString *)title array:(NSArray *)array id:(NSString *)numstr{
    
    _title = title;
    _dataArr = array;
    return self;
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"直播分类";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 90, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,76)];
    [backButton setTitle:@" " forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    //设置button上字体的偏移量
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10.0 , 0.0, 0)];
    [SYGView addSubview:backButton];

    UIButton *allButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 20, 50, 40)];
    //    [allButton setImage:[UIImage imageNamed:@"点评返回@2x"] forState:UIControlStateNormal];
    [allButton setTitle:@"全部" forState:UIControlStateNormal];
    [allButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [allButton addTarget:self action:@selector(allPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:allButton];
}

- (void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNav];
    self.title = @"选择分类";
    self.view.backgroundColor = [UIColor whiteColor];
    // [self addItem:@"" position:Left_Items image:@"CIRCLE _ DELETE" action:@selector(back)];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"焦点按钮@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bake1 = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:bake1];
    //添加全部课程按钮
    UIButton *allButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 20)];
    [allButton setTitle:@"全部" forState:UIControlStateNormal];
    [allButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [allButton addTarget:self action:@selector(allPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bake = [[UIBarButtonItem alloc] initWithCustomView:allButton];
    [self.navigationItem setRightBarButtonItem:bake];
    
    [self requestData];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate =self;
    _tableView.rowHeight = 50;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    _lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 100,MainScreenWidth, 12)];
    [_tableView addSubview:_lable];
    [_tableView insertSubview:_lable atIndex:0];
    _lable.text = @"数据为空，刷新重试";
    _lable.textAlignment = NSTextAlignmentCenter;
    _lable.textColor = [UIColor clearColor];
    _lable.font = [UIFont systemFontOfSize:14];
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

- (void)requestData
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:@"1" forKey:@"cateId"];
    
    NSArray *FLArray = [ClassFL BJWithDic:dic];
    NSLog(@"%@",FLArray);

    [manager getpublicPort:dic mod:@"Live" act:@"getLiveCategoryList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        _dataArray2 = responseObject[@"data"];
        _IDArray = responseObject[@"zy_live_category_id"];
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        _dataArray2 = FLArray;
        [_tableView reloadData];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray2.count==0) {
        
        _lable.textColor = [UIColor colorWithHexString:@"#dedede"];
        
    }else{
        
        _lable.textColor = [UIColor clearColor];
    }
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
    
    cell.CLabel.text = _dataArray2[indexPath.row][@"title"];
    
    return cell;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ID = [NSString stringWithFormat:@"%@",_dataArray2[indexPath.row][@"zy_live_category_id"]];
    LiveViewController * vc = [[LiveViewController alloc]initWithId:ID];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)allPressed
{
    LiveViewController * vc = [[LiveViewController alloc]initWithId:@""];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
