//
//  MyInstationViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/10.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "MyInstationViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "MJRefresh.h"

#import "InstitutionListCell.h"
#import "MoreTableViewCell.h"
#import "InstitutionMainViewController.h"
#import "InstCourseViewController.h"

#import "ApplyInsViewController.h"
#import "InstationOrderViewController.h"




@interface MyInstationViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)UIButton *stausButton;
@end

@implementation MyInstationViewController

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
    [self addButtonView];
//    [self netWorkInstitutionList];
    [self netWorkInstitutionGetStatus];
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
    _titleText = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    _titleText.text = @"我的机构";
    [_titleText setTextColor:BasidColor];
    _titleText.textAlignment = NSTextAlignmentCenter;
    _titleText.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:_titleText];
    
    //添加横线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:button];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 50;
    [self.view addSubview:_tableView];
    _tableView.hidden = YES;
}


- (void)addButtonView {
    _stausButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 90, MainScreenWidth - 100, 40)];
    _stausButton.center = self.view.center;
    _stausButton.layer.cornerRadius = 5;
    _stausButton.backgroundColor = [UIColor redColor];
    [_stausButton addTarget:self action:@selector(stausButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_stausButton];
    _stausButton.hidden = YES;
    
}

#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"culture";
    
    NSArray *imageArray = @[@"iconfont-kaoshi",@"xiaowenda",@"iconfont-kaoshi"];
    NSArray *titleArray = @[@"主页",@"排课",@"机构订单"];
    
    //自定义cell类
    MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MoreTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    [cell.SYGButton setBackgroundImage:Image(imageArray[indexPath.row]) forState:UIControlStateNormal];
    cell.SYGLabel.text = titleArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    
    if (indexPath.row == 0) {
        InstitutionMainViewController *institionMainVc = [[InstitutionMainViewController alloc] init];
        institionMainVc.schoolID = _schoolID;
        [self.navigationController pushViewController:institionMainVc animated:YES];
    } else if (indexPath.row == 1) {
        InstCourseViewController *instCourseVc = [[InstCourseViewController alloc] init];
        instCourseVc.schoolID = _schoolID;
        [self.navigationController pushViewController:instCourseVc animated:YES];
    } else if (indexPath.row == 2) {
        InstationOrderViewController *instOrderVc = [[InstationOrderViewController alloc] init];
        [self.navigationController pushViewController:instOrderVc animated:YES];
    }
    
}

#pragma mark --- 事件监听
- (void)stausButtonClick {
    ApplyInsViewController *applyInsVc = [[ApplyInsViewController alloc] init];
    [self.navigationController pushViewController:applyInsVc animated:YES];
}

#pragma mark --- 网络请求

//获取机构列表
- (void)netWorkInstitutionList {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    [dic setObject:@"1" forKey:@"page"];
    [dic setObject:@"20" forKey:@"count"];
    
    [manager BigWinCar_GetMySchoolList:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (![responseObject[@"msg"] isEqualToString:@"ok"]) {
            return;
        }
        _dataArray = responseObject[@"data"];
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}

//判断时候 为机构
- (void)netWorkInstitutionGetStatus {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [manager BigWinCar_getStatus:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 1) {
            NSDictionary *dic = responseObject[@"data"];
            _statusStr = dic[@"status"];
            _schoolID = dic[@"school_id"];
            
            //存到本地
            [[NSUserDefaults standardUserDefaults] setObject:_schoolID forKey:@"schoolID"];
            
            if ([_statusStr integerValue] == -1) {//未提交或失败
                [_stausButton setTitle:@"还不是机构，去申请吧" forState:UIControlStateNormal];
                _tableView.hidden = YES;
                _stausButton.hidden = NO;
            } else if ([_statusStr integerValue] == 0) {//提交 但未审核
                [_stausButton setTitle:@"已提交，待审核" forState:UIControlStateNormal];
                _tableView.hidden = YES;
                _stausButton.hidden = NO;
                _stausButton.enabled = NO;
            } else if ([_statusStr integerValue] == 1) {//通过了
                _tableView.hidden = NO;
                _stausButton.hidden = YES;
            } else if ([_statusStr integerValue] == 2) {//禁用
                [_stausButton setTitle:@"被禁用，用不了啦" forState:UIControlStateNormal];
                _tableView.hidden = YES;
                _stausButton.hidden = NO;
            } else if ([_statusStr integerValue] == 3) {//没有通过
                [_stausButton setTitle:@"没有通过,请重新申请" forState:UIControlStateNormal];
                _tableView.hidden = YES;
                _stausButton.hidden = NO;
            }
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}



@end
