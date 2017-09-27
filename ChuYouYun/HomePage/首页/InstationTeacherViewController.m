//
//  InstationTeacherViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/4.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "InstationTeacherViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

#import "SearchTeacherCell.h"
#import "TeacherDetilViewController.h"
#import "instAllTeacherViewController.h"

#import "GLTeaTableViewCell.h"
#import "TeacherMainViewController.h"



@interface InstationTeacherViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSArray *headerTitleArray;
@property (strong ,nonatomic)NSArray *dataArray;
@property (strong ,nonatomic)NSArray *teacherArray;

@end

@implementation InstationTeacherViewController

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
//    [self addNav];
    [self addTableView];
//    [self netWorkInstitutionTeacherList];
    
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _headerTitleArray = @[@"一对一"];
    
    //接受通知（将机构的id传过来）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetInstitonSchoolID:) name:@"NotificationInstitionSchoolID" object:nil];
}

#pragma mark --- 通知

- (void)GetInstitonSchoolID:(NSNotification *)Not {
    _schoolID = (NSString *)Not.userInfo[@"school_id"];
    [self netWorkInstitutionTeacherList];
}


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"点评返回@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"机构";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight) style:UITableViewStylePlain];
    _tableView.rowHeight = 130;
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_tableView];
}

#pragma mark --- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (_teacherArray.count >= 1) {
        return 1;
    } else {
        return _teacherArray.count;
    }
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
    
    cell.nameLab.text = [NSString stringWithFormat:@"%@",_teacherArray[indexPath.row][@"name"]];
    NSLog(@"===33333==%@",_teacherArray[indexPath.row]);
    
    if ([_teacherArray[indexPath.row][@"school_info"] count]) {
        cell.JGLab.text = [NSString stringWithFormat:@"%@",_teacherArray[indexPath.row][@"school_info"][@"title"]];
        
    }
    cell.img.image = [UIImage imageNamed:@"站位图"];//展位图
    NSString *url = [NSString stringWithFormat:@"%@",_teacherArray[indexPath.row][@"headimg"]];
    [cell.img sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"站位图"]];
    cell.img.layer.cornerRadius = 50;
    cell.img.layer.masksToBounds = YES;
    
    NSString *tagstr1 = [NSString stringWithFormat:@"%@年教龄",_teacherArray[indexPath.row][@"teacher_age"]];
    CGRect frames = cell.tagLab1.frame;
    frames.size.width = tagstr1.length *10 + 5;
    cell.tagLab1.frame = frames;
    cell.tagLab1.text = tagstr1;
    cell.tagLab1.font = Font(10);
    if ([tagstr1 isEqualToString:@"<null>"]) {
        cell.tagLab1.text = @"未知";
    }
    
    NSString *tagstr2 = [NSString stringWithFormat:@"%@",_teacherArray[indexPath.row][@"teach_evaluation"]];
    CGRect frame2 = cell.tagLab2.frame;
    frame2.size.width = tagstr2.length *10 +5;
    frame2.origin.x = frames.origin.x + frames.size.width + 10;
    cell.tagLab2.frame = frame2;
    cell.tagLab2.text = tagstr2;
    cell.tagLab2.font = Font(10);
    if ([tagstr2 isEqualToString:@"<null>"]) {
        cell.tagLab2.text = @"未知";
    }
    
    NSString *tagstr3 = [NSString stringWithFormat:@"%@",_teacherArray[indexPath.row][@"graduate_school"]];
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
    
    cell.contentLab.text = [NSString stringWithFormat:@"%@",_teacherArray[indexPath.row][@"inro"]];
    if ([_teacherArray[indexPath.row][@"inro"] isEqual:[NSNull null]]) {
        cell.contentLab.text = @"";
    }
    NSString *count = [NSString stringWithFormat:@"播放%@次",_teacherArray[indexPath.row][@"review_count"]];
    NSString *area = [NSString stringWithFormat:@"%@",_teacherArray[indexPath.row][@"ext_info"][@"location"]];
    
    cell.areaLab.text = [NSString stringWithFormat:@"%@",area];
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 30;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_teacherArray.count == 0) {
        return 60;
    } else {
        return 110;
    }
}
//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return _headerTitleArray[section];
//}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 80)];
    footView.backgroundColor = [UIColor whiteColor];
    
    //添加查看全部的课程
    UIButton *allClassButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 50, 10, 100, 20)];
    [allClassButton setTitle:@"查看全部老师" forState:UIControlStateNormal];
    allClassButton.titleLabel.font = Font(12);
    [allClassButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [allClassButton setImage:Image(@"首页更多") forState:UIControlStateNormal];
    allClassButton.imageEdgeInsets =  UIEdgeInsetsMake(0,80,0,0);
    allClassButton.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 20);
    [allClassButton addTarget:self action:@selector(allClassButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    allClassButton.tag = 600;
    [footView addSubview:allClassButton];
    
    if (_teacherArray.count == 0) {
        allClassButton.hidden = YES;
        footView.frame = CGRectMake(0, 0, MainScreenWidth, 40);
    }
    
    //添加横线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, MainScreenWidth, SpaceBaside)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [footView addSubview:lineButton];
    if (_teacherArray.count == 0) {
        lineButton.hidden = YES;
        lineButton.frame = CGRectMake(0, 0, MainScreenWidth, 0.00001);
    }
    
    
    //添加班课
    NSArray *textArray = @[@"机构ID",@"机构二维码名片"];
    CGFloat textH = 30;
    
    for (int i = 0 ; i < 2 ; i ++) {
        UILabel *class = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, CGRectGetMaxY(lineButton.frame) + (textH + 1) * i , 200, textH)];
        class.text = textArray[i];
        class.font = Font(13);
        [footView addSubview:class];
        
        //添加ID 文本
        if (i == 0) {
            UILabel *IDLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - SpaceBaside - 30, CGRectGetMaxY(lineButton.frame) + (textH + 1) * i + 5, 30, textH - 10)];
            IDLabel.text = [NSString stringWithFormat:@"%@",_schoolID];
            IDLabel.textColor = [UIColor grayColor];
            IDLabel.textAlignment = NSTextAlignmentCenter;
            IDLabel.font = Font(14);
            [footView addSubview:IDLabel];
            
        } else if (i == 1) {
            UIButton *IDButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - SpaceBaside - 20, CGRectGetMaxY(lineButton.frame) + (textH + 1) * i + 5, textH - 10, textH - 10)];
            [IDButton setImage:Image(@"二维码") forState:UIControlStateNormal];
            [footView addSubview:IDButton];
            
        }
        
    }
    
    UIButton *lineButton2 = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside,CGRectGetMaxY(lineButton.frame) + textH + 1 , MainScreenWidth, 1)];
    lineButton2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [footView addSubview:lineButton2];
    
    return footView;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TeacherMainViewController *teacherMainVc = [[TeacherMainViewController alloc]initWithNumID:_teacherArray[indexPath.row][@"id"]];
    [self.navigationController pushViewController:teacherMainVc animated:YES];
}


#pragma mark --- 事件监听

- (void)allClassButtonCilck:(UIButton *)button {
    instAllTeacherViewController *allTeacherVc = [[instAllTeacherViewController alloc] init];
    allTeacherVc.schoolID = _schoolID;
    [self.navigationController pushViewController:allTeacherVc animated:YES];
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
    [dic setObject:@"5" forKey:@"count"];
    [dic setObject:_schoolID forKey:@"school_id"];
    
    [manager BigWinCar_GetSchoolTeacher:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"---%@",responseObject);
        NSLog(@"%@",operation);
        
        if (![responseObject[@"msg"] isEqualToString:@"ok"]) {
            return;
        }
        _dataArray = responseObject[@"data"];
        _teacherArray = responseObject[@"data"];
        _tableView.frame = CGRectMake(0, 64, MainScreenWidth, _teacherArray.count * 100 + 120);
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}



@end
