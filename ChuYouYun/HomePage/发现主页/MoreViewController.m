//
//  MoreViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 15/12/29.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width


#import "MoreViewController.h"
#import "MoreTableViewCell.h"
#import "ZiXunViewController.h"
#import "ZXKSViewController.h"
#import "GLReachabilityView.h"
#import "questionViewController.h"
#import "ChatViewController.h"
#import "GroupViewController.h"
#import "StoresViewController.h"
#import "LibraryViewController.h"
#import "ExchangeViewController.h"
#import "ZhongChouViewController.h"
#import "TempViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "GroupMainViewController.h"
#import "YunKeTang_questionViewController.h"


@interface MoreViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong ,nonatomic)UITableView *tableView;

@end

@implementation MoreViewController

- (void)viewWillAppear:(BOOL)animated {
    
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [GLReachabilityView isConnectionAvailable];
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    //添加标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, MainScreenWidth, 49)];
    titleLabel.text = @"发现";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [navView addSubview:titleLabel];
    
    //添加表格视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 - 49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    [self.view addSubview:_tableView];
    
    //设置表格分割线的长度（跟两边的距离）
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,16)];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1 || section == 0 || section == 2) {
        return 2;
    } else  {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *titleArray = @[@"资讯",@"商城",@"考试",@"文库",@"问答",@"小组",@"临时"];
//    NSArray *imageArray = @[@"发现_资讯",@"发现_活动",@"发现_在线考试",@"发现_文库",@"发现_问答",@"发现_小组",@"发现_小组"];
    NSArray *imageArray = @[@"发现_资讯",@"faxian_mall",@"发现_在线考试",@"faxian_article",@"faxian_wenda",@"发现_小组",@"发现_小组"];
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MoreTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    NSInteger indexSet = indexPath.section;
    NSInteger indexRow = indexPath.row;
    
    if (indexSet == 0) {
        [cell.SYGButton setBackgroundImage:[UIImage imageNamed:imageArray[indexRow]] forState:UIControlStateNormal];
        cell.SYGLabel.text = titleArray[indexRow];
    } else if (indexSet == 1) {
        [cell.SYGButton setBackgroundImage:[UIImage imageNamed:imageArray[indexRow + 2]] forState:UIControlStateNormal];
        cell.SYGLabel.text = titleArray[indexRow+ 2];
    } else if (indexSet == 2) {
        [cell.SYGButton setBackgroundImage:[UIImage imageNamed:imageArray[indexRow + 4]] forState:UIControlStateNormal];
        cell.SYGLabel.text = titleArray[indexRow + 4];
    } else if (indexSet == 3) {
        [cell.SYGButton setBackgroundImage:[UIImage imageNamed:imageArray[indexRow + 6]] forState:UIControlStateNormal];
        cell.SYGLabel.text = titleArray[indexRow + 6];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//表格箭头的样式
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 22;
    }
    return 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger indexSet = indexPath.section;
    NSInteger indexRow = indexPath.row;
    
    if (indexSet == 0) {//第一列
        if (indexRow == 0) {//资讯
            ZiXunViewController *ZXZXVC = [[ZiXunViewController alloc] init];
            [self.navigationController pushViewController:ZXZXVC animated:YES];
        } else { //积分商城
            [self.navigationController pushViewController:[StoresViewController new] animated:YES];
        }
        
    } else if (indexSet == 1) {

        if (indexRow == 0) {//在线考试
            ZXKSViewController *ZXKSVC = [[ZXKSViewController alloc] init];
            [self.navigationController pushViewController:ZXKSVC animated:YES];
            
        } else {//文库
            LibraryViewController *libVc = [[LibraryViewController alloc] init];
            [self.navigationController pushViewController:libVc animated:YES];
        }
    } else if (indexSet == 2) {
        if (indexRow == 0) {//问答
//            questionViewController *questionVc = [[questionViewController alloc] init];
//            [self.navigationController pushViewController:questionVc animated:YES];
            
            YunKeTang_questionViewController *vc = [[YunKeTang_questionViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {//小组
            GroupMainViewController *groupMainVc = [[GroupMainViewController alloc] init];
            [self.navigationController pushViewController:groupMainVc animated:YES];
        }

    } else if (indexSet == 3) {//临时
        TempViewController *exchangeV = [[TempViewController alloc]init];
        [self.navigationController pushViewController:exchangeV animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

@end
