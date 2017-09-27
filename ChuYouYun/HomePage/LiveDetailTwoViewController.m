//
//  LiveDetailTwoViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/3/21.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "LiveDetailTwoViewController.h"
#import "SYG.h"
#import "MyHttpRequest.h"

#import "LiveDetailOneCell.h"
#import "LiveDetailTwoCell.h"
#import "LiveDetailThreeCell.h"

#import "InstitutionMainViewController.h"
#import "TeacherDetilViewController.h"
#import "LiveDetailFourCell.h"



@interface LiveDetailTwoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSString *ID;
@property (strong ,nonnull)NSDictionary *dict;

@end

@implementation LiveDetailTwoViewController

- (instancetype)initWithType:(NSString *)ID {
    if (self=[super init]) {
        _ID = ID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addTableView];
    [self requestData];
}

- (void)interFace {
    
}

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight) style:UITableViewStyleGrouped];
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
//    return 5;
    if (section == 0) {
        return 10;
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 2;
    } else if (section == 3) {
        return 2;
    } else {
        return 10;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
    
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
        [cell dataWithDict:_dict];
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
        TeacherDetilViewController *TDV = [[TeacherDetilViewController alloc]initWithNumID:teacherID];
        [self.navigationController pushViewController:TDV animated:YES];
    } else if (indexPath.section == 2) {//机构
        InstitutionMainViewController*instVc = [[InstitutionMainViewController alloc] init];
        instVc.schoolID =  [NSString stringWithFormat:@"%@",_dict[@"school_info"][@"school_id"]];
        instVc.uID = [NSString stringWithFormat:@"%@",_dict[@"school_info"][@"uid"]];
        [self.navigationController pushViewController:instVc animated:YES];
    }
    
}

#pragma mark --- 网络请求

- (void)requestData
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
        _dict = responseObject[@"data"];
        [_tableView reloadData];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}





@end
