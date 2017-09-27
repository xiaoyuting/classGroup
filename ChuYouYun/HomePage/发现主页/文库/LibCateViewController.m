//
//  LibCateViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/10/9.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//  文库分类

#define TableViewW 100

#import "LibCateViewController.h"
#import "SYG.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "BigWindCar.h"

#import "LibCateCell.h"
#import "CollectionViewHeaderView.h"
#import "LibCateCollectionViewCell.h"


@interface LibCateViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSInteger index;
}
@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)UICollectionView *collectionView;

@property (strong ,nonatomic)NSArray *tableArray;
@property (strong ,nonatomic)NSMutableArray *collectionArray;

@end

static NSString *cellID = @"cell";

@implementation LibCateViewController


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
    [self addCollectionView];
    [self netWorkCategory];

}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _seletedArray = [NSMutableArray array];
    _collectionArray = [NSMutableArray array];
    index = 0;
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
    WZLabel.text = @"文库分类";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];

    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---View

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, TableViewW, MainScreenHeight) style:UITableViewStyleGrouped];
    _tableView.rowHeight = 50;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)addCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    layout.itemSize = CGSizeMake((MainScreenWidth - 24 - TableViewW) / 3, 40);
    if (iPhone6Plus) {
        layout.itemSize = CGSizeMake((MainScreenWidth - 24 - TableViewW) / 3, 40);
    } else if (iPhone6) {
        layout.itemSize = CGSizeMake((MainScreenWidth - 31 - TableViewW) / 3, 40);
    } else if (iPhone5o5Co5S) {
        layout.itemSize = CGSizeMake((MainScreenWidth - 24 - TableViewW) / 3, 40);
    } else if (iPhone4SOriPhone4) {
        layout.itemSize = CGSizeMake((MainScreenWidth - 24 - TableViewW) / 3, 40);
    }
    layout.headerReferenceSize = CGSizeMake(MainScreenWidth - 2 * SpaceBaside - 4 - TableViewW, 50);
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(TableViewW + 10 , 64, MainScreenWidth - TableViewW - 21, MainScreenHeight - 64) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[LibCateCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    
    [self.collectionView registerClass:[CollectionViewHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionViewHeaderView"];
    
}

#pragma mark --- UICollectionViewDataSource

//头部视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseID;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reuseID = @"CollectionViewHeaderView";
    }
    CollectionViewHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseID forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        view.title.text = _tableArray[index][@"childs"][indexPath.section][@"title"];
    }
    return view;
  
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSArray *array = _tableArray[index][@"childs"];
    return array.count;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSDictionary *dict = _tableArray[index][@"childs"][section];
    NSArray *numArray = dict[@"childs"];
    return numArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LibCateCollectionViewCell *cell = (LibCateCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.borderColor=[UIColor grayColor].CGColor;
    cell.layer.borderWidth=0.3;
    if (iPhone6Plus) {
        
    } else if (iPhone6) {
        cell.title.font = Font(16);
    } else if (iPhone5o5Co5S) {
        cell.title.font = Font(15);
    }
    cell.title.text = _tableArray[index][@"childs"][indexPath.section][@"childs"][indexPath.row][@"title"];
    
    return cell;
    
}

#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    LibCateCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LibCateCell alloc] initWithReuseIdentifier:CellIdentifier];
        
    }
    NSDictionary *dict = _tableArray[indexPath.row];
    [cell dataSourceWith:dict];
    [cell arrayWithArray:_seletedArray withIndex:indexPath.row];
    
    return cell;
}

#pragma mark ---- 点击

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID = _tableArray[index][@"childs"][indexPath.section][@"childs"][indexPath.row][@"doc_category_id"];
    NSLog(@"id-----%@",ID);
    [self backPressed];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationLib_Category_ID" object:nil userInfo: _tableArray[index][@"childs"][indexPath.section][@"childs"][indexPath.row][@"doc_category_id"]];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger Count = _seletedArray.count;
    [_seletedArray removeAllObjects];
    for (int i = 0 ; i < Count ; i ++) {
        if (i == indexPath.row) {
            [_seletedArray addObject:@"1"];
        }
        [_seletedArray addObject:@"0"];
    }
    
    index = indexPath.row;
    
    [_tableView reloadData];
    [_collectionView reloadData];
    
}

#pragma mark --- 网络请求
- (void)netWorkCategory {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    [dic setValue:@"0" forKey:@"doc_category_id"];
    
    [manager BigWinCar_LibiaryCategory:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        NSLog(@"======  %@",responseObject);
        _tableArray = responseObject[@"data"];
        
        for (int i = 0 ; i < _tableArray.count ; i ++) {
            if (i == 0) {
                [_seletedArray addObject:@"1"];
            }
            [_seletedArray addObject:@"0"];
 
        }
        [_tableView reloadData];
        NSLog(@"----%@",_collectionArray);
        [_collectionView reloadData];
        NSLog(@"%@",_tableArray);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}


@end
