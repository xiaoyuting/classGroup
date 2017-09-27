//
//  ChangeCityViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/10/31.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "ChangeCityViewController.h"
#import "rootViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "BigWindCar.h"



@interface ChangeCityViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)UIView *headerView;

@property (strong ,nonatomic)NSMutableArray *headerTitleArray;

@property (strong ,nonatomic)NSArray *allCityArray;
@property (strong ,nonatomic)NSMutableArray *letterArray;
@property (strong ,nonatomic)NSMutableArray *dataSource;
@property (strong ,nonatomic)NSArray *resultArray;

@end

@implementation ChangeCityViewController

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
    [self addHeaderView];
    [self addTableView];
    [self netWorkHomeGetArea];

}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _headerTitleArray = [NSMutableArray array];
    _letterArray = [NSMutableArray array];
    _dataSource = [NSMutableArray array];
    
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
     SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 60, 25,120, 30)];
    WZLabel.text = @"切换城市";
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

- (void)addHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 350)];
    _headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];

    [self.view addSubview:_headerView];
    
    
    //添加定位城市
    
    NSArray *titleArray = @[@"  定位城市",@"  当前城市",@"  热门城市"];
    
    CGFloat ButtonW = (MainScreenWidth - 2 * SpaceBaside - 4 * SpaceBaside) / 3;
    CGFloat ButtonH = 40;
    
    for (int i = 0 ; i < 3; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, i * 80, MainScreenWidth, 20)];
        label.backgroundColor = [UIColor whiteColor];
        label.text = titleArray[i];
        label.font = Font(13);
        label.textColor = BlackNotColor;
        [_headerView addSubview:label];
        
    }
    
    
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 30 + i * 80, ButtonW, ButtonH)];
        [button setTitle:_cityTitle forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:BlackNotColor forState:UIControlStateNormal];
        button.titleLabel.font = Font(15);
        [_headerView addSubview:button];
    }
    
    NSArray *cityButtonArray = @[@"北京",@"上海",@"成都",@"武汉",@"深圳",@"广州",@"西安",@"大连",@"南京"];
    
    for (int i = 0 ; i < 9; i ++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside + (ButtonW + SpaceBaside) * (i % 3), 180 + SpaceBaside + (ButtonH + SpaceBaside) * (i / 3), ButtonW, ButtonH)];
        [button setTitle:cityButtonArray[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:BlackNotColor forState:UIControlStateNormal];
        button.titleLabel.font = Font(15);
        button.tag = i;
        [_headerView addSubview:button];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
   
    }
 
}

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    _tableView.rowHeight = 40;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = _headerView;
    [self.view addSubview:_tableView];
    
}

#pragma mark --- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *letter = _dataSource[section];
    return letter.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = _dataSource[indexPath.section][indexPath.row];
    cell.textLabel.textColor = BlackNotColor;
    cell.textLabel.font = Font(15);
    return cell;
}


//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
//    btn.tag =section;
////    NSArray *sectionArray = _dataArray[section];
////    NSString *str1 ;
////
////    str1 = [NSString stringWithFormat:@"   %@(%ld)",_titleArray[section],sectionArray.count];
////    
////    [btn setTitle:str1 forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////    [btn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
//    btn.selected = NO;
//    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    //左对齐
//    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    btn.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
//    return btn;
//}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _resultArray[section];
}


//头部视图
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _resultArray.count;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    //更改索引的背景颜色:
    
    tableView.sectionIndexColor = BlackNotColor;
    return _resultArray;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = _dataSource[indexPath.section][indexPath.row];
    NSLog(@"%@",title);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:title forKey:@"title"];
    
    //发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationCityInfo" object:nil userInfo:dict];
    
    [self backPressed];
}

#pragma mark --- 事件点击

- (void)buttonClick:(UIButton *)button {
    
    NSString *title = button.titleLabel.text;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:title forKey:@"title"];
    //发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationCityInfo" object:nil userInfo:dict];
    
    [self backPressed];
}

#pragma mark --- 处理数据
- (void)GetDataSource {
    
    NSLog(@"%@",_allCityArray);
    
    

    for (int i = 0; i < _allCityArray.count ; i ++) {
        
        [_headerTitleArray addObject:_allCityArray[i][@"letter"]];
    }
    
    
    NSLog(@"%@",_headerTitleArray);
    
    //排序呢
    NSArray *newArray = [_headerTitleArray sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"%@",newArray);
    
    //删除相同元素
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *string in newArray) {
        if (![result containsObject:string]) {
            [result addObject:string];
        }
    }
    
    _resultArray = result;
    NSLog(@"%@",result);
    
   
    NSMutableArray *letterArray1 = [NSMutableArray array];
    NSMutableArray *letterArray2 = [NSMutableArray array];
    NSMutableArray *letterArray3 = [NSMutableArray array];
    NSMutableArray *letterArray4 = [NSMutableArray array];
    NSMutableArray *letterArray5 = [NSMutableArray array];
    NSMutableArray *letterArray6 = [NSMutableArray array];
    NSMutableArray *letterArray7 = [NSMutableArray array];
    NSMutableArray *letterArray8 = [NSMutableArray array];
    NSMutableArray *letterArray9 = [NSMutableArray array];
    NSMutableArray *letterArray10 = [NSMutableArray array];
    NSMutableArray *letterArray11 = [NSMutableArray array];
    NSMutableArray *letterArray12 = [NSMutableArray array];
    NSMutableArray *letterArray13 = [NSMutableArray array];
    NSMutableArray *letterArray14 = [NSMutableArray array];
    
    for (int i = 0; i < _allCityArray.count ; i ++) {
        
        
        NSArray *array = _allCityArray[i][@"child"];
        for (int k = 0 ; k < array.count ; k ++) {
            if ([array[k][@"letter"] isEqualToString:@"A"]) {
                [letterArray1 addObject:array[k][@"title"]];
            } else if ([array[k][@"letter"] isEqualToString:@"B"]) {
                [letterArray2 addObject:array[k][@"title"]];
            } else if ([array[k][@"letter"] isEqualToString:@"F"]) {
                [letterArray3 addObject:array[k][@"title"]];
            } else if ([array[k][@"letter"] isEqualToString:@"G"]) {
                [letterArray4 addObject:array[k][@"title"]];
            } else if ([array[k][@"letter"] isEqualToString:@"H"]) {
                [letterArray5 addObject:array[k][@"title"]];
            } else if ([array[k][@"letter"] isEqualToString:@"J"]) {
                [letterArray6 addObject:array[k][@"title"]];
            } else if ([array[k][@"letter"] isEqualToString:@"L"]) {
                [letterArray7 addObject:array[k][@"title"]];
            } else if ([array[k][@"letter"] isEqualToString:@"N"]) {
                [letterArray8 addObject:array[k][@"title"]];
            } else if ([array[k][@"letter"] isEqualToString:@"Q"]) {
                [letterArray9 addObject:array[k][@"title"]];
            } else if ([array[k][@"letter"] isEqualToString:@"S"]) {
                [letterArray10 addObject:array[k][@"title"]];
            } else if ([array[k][@"letter"] isEqualToString:@"T"]) {
                [letterArray11 addObject:array[k][@"title"]];
            } else if ([array[k][@"letter"] isEqualToString:@"X"]) {
                [letterArray12 addObject:array[k][@"title"]];
            } else if ([array[k][@"letter"] isEqualToString:@"Y"]) {
                [letterArray13 addObject:array[k][@"title"]];
            } else if ([array[k][@"letter"] isEqualToString:@"Z"]) {
                [letterArray14 addObject:array[k][@"title"]];
            }
        }
    }

    
    
    NSLog(@"%@",letterArray1);
    NSLog(@"%@",_dataSource);
    [_dataSource addObject:letterArray1];
    [_dataSource addObject:letterArray2];
    [_dataSource addObject:letterArray3];
    [_dataSource addObject:letterArray4];
    [_dataSource addObject:letterArray5];
    [_dataSource addObject:letterArray6];
    [_dataSource addObject:letterArray7];
    [_dataSource addObject:letterArray8];
    [_dataSource addObject:letterArray9];
    [_dataSource addObject:letterArray10];
    [_dataSource addObject:letterArray11];
    [_dataSource addObject:letterArray12];
    [_dataSource addObject:letterArray13];
    [_dataSource addObject:letterArray14];

    
    
    for (int i = 0 ; i < _dataSource.count ; i ++) {
        NSLog(@"%@",_dataSource[i]);
        NSArray *array = _dataSource[i];
        for (int k = 0 ; k < array.count ; k ++ ) {
            NSLog(@"%@",array[k]);
        }
    }
    [_tableView reloadData];

    
}


#pragma mark --- 网络请求
//获取城市
- (void)netWorkHomeGetArea {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [manager BigWinCar_HomeGetArea:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        _allCityArray = responseObject[@"data"];
        [self GetDataSource];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}



@end
