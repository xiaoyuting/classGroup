//
//  instAllTeacherViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/12/12.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "instAllTeacherViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Add.h"

#import "SearchTeacherCell.h"
#import "TeacherDetilViewController.h"
#import "GLTeaTableViewCell.h"
#import "TeacherMainViewController.h"


@interface instAllTeacherViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSMutableArray *dataArray;

@end

@implementation instAllTeacherViewController

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
    [self postNotification];
    [self interFace];
    [self addNav];
    [self addTableView];
    [self netWorkInstitutionTeacherList];
}

- (void)postNotification {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"2" forKey:@"offSet"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationInsTeacherOffSet" object:nil userInfo:dict];
}


- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
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
    WZLabel.text = @"机构更多讲师";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 + 20 + 20 - 4) style:UITableViewStyleGrouped];
    _tableView.rowHeight = 130;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
}

#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.05;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellStr = @"GLTeaTableViewCell";
    GLTeaTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellStr];
    if (cell == nil) {
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        cell = [[GLTeaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellStr];
    }
    //    cell.contentLab.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"inro"]];
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.nameLab.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"name"]];
    NSLog(@"===33333==%@",_dataArray[indexPath.row]);
    
    if ([_dataArray[indexPath.row][@"school_info"] count]) {
        cell.JGLab.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"school_info"][@"title"]];
        
    }
    cell.img.image = [UIImage imageNamed:@"站位图"];//展位图
    NSString *url = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"headimg"]];
    [cell.img sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"站位图"]];
    cell.img.layer.cornerRadius = 50;
    cell.img.layer.masksToBounds = YES;
    
    NSString *tagstr1 = [NSString stringWithFormat:@"%@年教龄",_dataArray[indexPath.row][@"teacher_age"]];
    CGRect frames = cell.tagLab1.frame;
    frames.size.width = tagstr1.length *10 +5;
    cell.tagLab1.frame = frames;
    cell.tagLab1.text = tagstr1;
    cell.tagLab1.font = Font(10);
    if ([tagstr1 isEqualToString:@"<null>"]) {
        cell.tagLab1.text = @"未知";
    }
    
    NSString *tagstr2 = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"teach_evaluation"]];
    CGRect frame2 = cell.tagLab2.frame;
    frame2.size.width = tagstr2.length *10 +5;
    frame2.origin.x = frames.origin.x + frames.size.width + 10;
    cell.tagLab2.frame = frame2;
    cell.tagLab2.text = tagstr2;
    cell.tagLab2.font = Font(10);
    if ([tagstr2 isEqualToString:@"<null>"]) {
        cell.tagLab2.text = @"未知";
    }
    
    NSString *tagstr3 = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"graduate_school"]];
    CGRect frame3 = cell.tagLab3.frame;
    frame3.size.width = tagstr3.length *10 +5;
    frame3.origin.x = frame2.origin.x + frame2.size.width + 10;
    cell.tagLab3.font = Font(10);
    
    cell.tagLab3.frame = frame3;
    cell.tagLab3.text = tagstr3;

    if ([tagstr3 isEqualToString:@"<null>"]) {
        cell.tagLab3.text = @"未知";
    }
    
    //    NSString *tagstr4 = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"school_info"][@"title"]];
    //    CGRect frame4 = cell.tagLab4.frame;
    //    frame4.size.width = tagstr4.length *13 +5;
    //    frame4.origin.x = frame3.origin.x + frame3.size.width + 5;
    //    cell.tagLab4.frame = frame4;
    //    cell.tagLab4.text = tagstr4;
    
    
    cell.contentLab.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"inro"]];
    if ([_dataArray[indexPath.row][@"inro"] isEqual:[NSNull null]]) {
        cell.contentLab.text = @"";
    }
    NSString *count = [NSString stringWithFormat:@"播放%@次",_dataArray[indexPath.row][@"review_count"]];
    NSString *area = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"ext_info"][@"location"]];
    
    cell.areaLab.text = [NSString stringWithFormat:@"%@",area];
    
    return cell;}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TeacherMainViewController *teacherMainVc = [[TeacherMainViewController alloc]initWithNumID:_dataArray[indexPath.row][@"id"]];
    [self.navigationController pushViewController:teacherMainVc animated:YES];
}

#pragma mark --- 网络请求

- (void)netWorkInstitutionTeacherList {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    [dic setObject:@"1" forKey:@"page"];
    [dic setObject:@"40" forKey:@"count"];
    [dic setObject:_schoolID forKey:@"school_id"];
    
    [manager BigWinCar_GetSchoolTeacher:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"---%@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if (![responseObject[@"msg"] isEqualToString:@"ok"]) {
            [MBProgressHUD showError:msg toView:self.view];
            return;
        }
        _dataArray = responseObject[@"data"];
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}




@end
