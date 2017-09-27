//
//  ZhiBoDetailViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/5/20.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "ZhiBoDetailViewController.h"
#import "SYG.h"
#import "MyHttpRequest.h"

#import "LiveDetailOneCell.h"
#import "LiveDetailTwoCell.h"
#import "LiveDetailThreeCell.h"
#import "TeacherMainViewController.h"

#import "InstitutionMainViewController.h"
#import "TeacherDetilViewController.h"
#import "LiveDetailFourCell.h"


@interface ZhiBoDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSString *ID;
@property (strong ,nonnull)NSDictionary *dict;
@property (strong ,nonatomic)NSString *teacherID;
@property (strong ,nonatomic)NSDictionary *teacherDict;

@end

@implementation ZhiBoDetailViewController

-(instancetype)initWithNumID:(NSString *)ID{
    
    self = [super init];
    if (self) {
        _ID = ID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addTableView];
    [self netWork];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 300) style:UITableViewStyleGrouped];
    if (iPhone5o5Co5S) {
        _tableView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 300);
    } else if (iPhone6) {
        _tableView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 300 - 20);
    } else if (iPhone6Plus) {
        _tableView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 300 - 40);
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark ---- UITableVieDataSoruce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10.0000001;
    } else {
        return 0.000001;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height ;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *CellID = @"LiveDetailOneCell";
        //自定义cell类
        LiveDetailOneCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        //自定义cell类
        if (cell == nil) {
            cell = [[LiveDetailOneCell alloc] initWithReuseIdentifier:CellID];
        }
        [cell dataWithDict:_dict];
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *CellID = @"LiveDetailTwoCell";
        //自定义cell类
        LiveDetailTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        //自定义cell类
        if (cell == nil) {
            cell = [[LiveDetailTwoCell alloc] initWithReuseIdentifier:CellID];
        }
        [cell dataWithDict:_teacherDict];
        return cell;
        
    } else if (indexPath.section == 2) {
        static NSString *CellID = @"LiveDetailThreeCell";
        //自定义cell类
        LiveDetailThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        //自定义cell类
        if (cell == nil) {
            cell = [[LiveDetailThreeCell alloc] initWithReuseIdentifier:CellID];
        }
        [cell dataWithDict:_dict];
        return cell;
        
    } else if (indexPath.section == 3) {
        static NSString *CellID = @"LiveDetailFourCell";
        //自定义cell类
        LiveDetailFourCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        //自定义cell类
        if (cell == nil) {
            cell = [[LiveDetailFourCell alloc] initWithReuseIdentifier:CellID];
        }
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {//讲师
        NSString *teacherID = [NSString stringWithFormat:@"%@",_dict[@"teacher_id"]];
        TeacherMainViewController *teacherMainVc = [[TeacherMainViewController alloc]initWithNumID:teacherID];
        [self.navigationController pushViewController:teacherMainVc animated:YES];
    } else if (indexPath.section == 2) {//机构
        InstitutionMainViewController*instVc = [[InstitutionMainViewController alloc] init];
        instVc.schoolID =  [NSString stringWithFormat:@"%@",_dict[@"school_info"][@"school_id"]];
        instVc.uID = [NSString stringWithFormat:@"%@",_dict[@"school_info"][@"uid"]];
        [self.navigationController pushViewController:instVc animated:YES];
    }
    
}

#pragma mark --- 网络请求

- (void)netWork
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    // 这里应该判断是否已经登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        //        return;
    } else {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:_ID forKey:@"live_id"];
    [manager getpublicPort:dic mod:@"Live" act:@"getDetail" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        _teacherID = responseObject[@"data"][@"teacher_id"];
        _dict = responseObject[@"data"];
        [self requestTeacherData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//获取讲师详情
-(void)requestTeacherData
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    if (_teacherID == nil) {
        [dic setObject:@"" forKey:@"teacher_id"];
    } else {
        [dic setObject:_teacherID forKey:@"teacher_id"];
    }

    //
    [manager getpublicPort:dic mod:@"Teacher" act:@"getTeacher" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",operation);
        NSLog(@"%@",responseObject[@"msg"]);
        if ([responseObject[@"code"] integerValue] != 1) {
            _teacherDict = responseObject[@"data"];
//            return ;
        } else {
            _teacherDict = responseObject[@"data"];
        }
        
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView reloadData];
    }];
}





@end
