//
//  AreaViewController.m
//  dafengche
//
//  Created by IOS on 16/11/1.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "AreaViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"

@interface AreaViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    
    NSMutableArray *_data;
}
@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSArray *lookArray;

@property (strong ,nonatomic)UIScrollView *headScrollow;

@property (strong ,nonatomic)NSArray *headerTitleArray;

@end

@implementation AreaViewController

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
    _headerTitleArray = @[@"热",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"J",@"K",@"L",@"M",@"N",@"P",@"R",@"S",@"T",@"W",@"X",@"Y",@"Z"];
    
    [self interFace];
    [self addNav];
    [self addTableView];
    
}
- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 75, MainScreenWidth, MainScreenHeight - 75) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    [self.view addSubview:_tableView];
    //_tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //读取plist
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Area" ofType:@"plist"];
    _data = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    NSLog(@"%@", _data);//直接打印数据。
}
#pragma mark -- UITableViewDatasoure

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _headerTitleArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr = _data[section];

    return arr.count;
    
}
//索引列点击事件

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSLog(@"===%@  ===%ld",title,index);
    
    //点击索引，列表跳转到对应索引的行
    
    [_tableView
     scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
     atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    //弹出首字母提示
    
    //    [self showLetter:title ];
    
    return index;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSArray *arr = _data[indexPath.section];
    NSLog(@"%ld",indexPath.section);
    //if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(260.0,0,50,40)]; //这里x轴，Y轴，宽度，高度自己根据需求定义
        label.font = Font(13); //设置字体大小，字体
        label.textColor = [UIColor colorWithHexString:@"#333333"]; //设置字体颜色
        [cell addSubview:label];
        cell.textLabel.font = Font(13);
        NSArray *array = arr[indexPath.row];
        NSString *key = array[0l];
        NSString *value = array[1l];
        
        NSLog(@"=======%@",key);
        cell.textLabel.text = key;
        label.text = value;  //设置内容
        
    //}
    return cell;
    
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _headerTitleArray[section];
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    NSArray *arr = @[@"热",@"",@"A",@"  ",@"B",@"   ",@"C",@"  ",@"D",@"  ",@"E",@"  ",@"F",@"  ",@"G",@"  ",@"H",@"  ",@"J",@"  ",@"K",@"  ",@"L",@"  ",@"M",@"  ",@"N",@"  ",@"P",@"  ",@"R",@"  ",@"S",@"  ",@"T",@"  ",@"W",@"  ",@"X",@"  ",@"Y",@"  ",@"Z"];
    //更改索引的背景颜色:
    tableView.sectionIndexColor = BlackNotColor;
    tableView.sectionHeaderHeight = 10;
    tableView.sectionFooterHeight = 10;
    tableView.estimatedSectionHeaderHeight = 20;
    return _headerTitleArray;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"点击了ecell");
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@",cell.textLabel.text);
    //classDetailVC *classDVc = [[classDetailVC alloc] initWithMemberId:_lookArray[indexPath.row][@"id"] andPrice:nil andTitle:_lookArray[indexPath.row][@"video_title"]];
    //classDVc.isLoad = @"123";
    // [self.navigationController pushViewController:classDVc animated:YES];
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
    titleLab.text = @"选择您的国家";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 130, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,116)];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    //设置button上字体的偏移量
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10.0 , 0.0, 0)];
    [SYGView addSubview:backButton];

    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
}


- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
