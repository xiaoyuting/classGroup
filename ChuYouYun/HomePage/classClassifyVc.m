//
//  classClassifyVc.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/28.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "classClassifyVc.h"
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


#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
@interface classClassifyVc ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray * dataArray;
    UILabel *_lable;
    NSArray *_dataArr;
    NSString *_title;
    NSArray * _IDNum;
}
@end

@implementation classClassifyVc

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
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
     SYGView.backgroundColor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
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
    if ([_title isEqualToString:@"直播"]) {
        
        WZLabel.text = @"直播分类";
        
        
    }else
    {
        
        WZLabel.text = @"课程分类";
    }
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
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
    [self addItem:@"" position:Left_Items image:@"CIRCLE _ DELETE" action:@selector(back)];
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
    [manager getCategory:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([_title isEqualToString:@"直播"]) {
            NSArray *arr = @[@"iso",@"java",@"php"];
            [_dataArray2 addObjectsFromArray:arr];
            
        }else{
        _dataArray2 = [responseObject objectForKey:@"data"];
        }
        if (FLArray.count) {//不需要
            
        } else {//需要
            [ClassFL saveBJes:_dataArray2];
        }
        NSMutableArray * listArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (int i =0; i<_dataArray2.count; i++) {
            categoryList * list = [[categoryList alloc]initWithDictionarys:_dataArray2[i]];
            [listArr addObject:list];
        }
        _dataArray2 = listArr;
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
    
    categoryList * list = _dataArray2[indexPath.row];
    cell.CLabel.text = list.Category_title;

    
    return cell;
    
}

- (void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    categoryList * list = _dataArray2[indexPath.row];
    classViewController * vc = [[classViewController alloc]initWithMemberId:list.categoryId];
    vc.formStr = @"123";
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
//创建导航条上的按钮
-(void)addItem:(NSString *)title position:(items)position image:(NSString *)image action:(SEL)action
{
    UIButton * button = [self button:title image:image frame:CGRectMake(0, 0, 25, 25)];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:button];
    if (position==Left_Items) {
        
        self.navigationItem.leftBarButtonItem = item;
    }else{
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)allPressed
{
    if ([_title isEqualToString:@"直播"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    classViewController * vc = [[classViewController alloc]initWithMemberId:@"0"];
    vc.formStr = @"123";
    [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
