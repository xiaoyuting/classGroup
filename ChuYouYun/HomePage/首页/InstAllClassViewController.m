//
//  InstAllClassViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/12/12.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "InstAllClassViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "MBProgressHUD+Add.h"


#import "SYGClassTableViewCell.h"
#import "classDetailVC.h"
#import "ClassRevampCell.h"
#import "LiveDetailsViewController.h"
#import "ZhiBoMainViewController.h"


@interface InstAllClassViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSMutableArray *dataArray;

@end

@implementation InstAllClassViewController


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
    [self netWorkInstitutionClassList];
}

- (void)postNotification {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"1" forKey:@"offSet"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationInsClassOffSet" object:nil userInfo:dict];
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
    WZLabel.text = @"机构更多课程";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 + 36) style:UITableViewStyleGrouped];
    _tableView.rowHeight = 110;
    _tableView.dataSource = self;
    _tableView.delegate = self;
//    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}

#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    ClassRevampCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //自定义cell类
    if (cell == nil) {
        cell = [[ClassRevampCell alloc] initWithReuseIdentifier:CellIdentifier];
    }

    NSDictionary *dict = _dataArray[indexPath.row];
    NSString *type = dict[@"type"];
    [cell dataWithDict:dict withType:type];
    
    NSLog(@"%@",dict);
    NSString *timeStr = [Passport formatterDate:[dict stringValueForKey:@"ctime"]];
    if (timeStr == nil) {
        timeStr = [Passport formatterDate:[dict stringValueForKey:@"ctime"]];
    }
    NSString *sectionStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"section_count"]];
    NSString *priceStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"t_price"]];
    
    if ([type integerValue] == 1) {
        cell.kinsOf.text = [NSString stringWithFormat:@"章节数：%@  ¥：%@ ",sectionStr,priceStr];
        if ([priceStr integerValue] == 0) {
           cell.kinsOf.text = [NSString stringWithFormat:@"章节数：%@   免费",sectionStr];
        }
        
    } else if ([type integerValue] == 2) {
        cell.kinsOf.text = [NSString stringWithFormat:@"%@开课  ¥：%@ ",timeStr,priceStr];
        if ([priceStr integerValue] == 0) {
            cell.kinsOf.text = [NSString stringWithFormat:@"章节数：%@   免费",sectionStr];
        }
    }

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *type = _dataArray[indexPath.row][@"type"];
    if ([type integerValue] == 1) {
        NSString *Cid = _dataArray[indexPath.row][@"id"];
        NSString *Price = _dataArray[indexPath.row][@"price"];
        NSString *Title = _dataArray[indexPath.row][@"video_title"];
        NSString *VideoAddress = _dataArray[indexPath.row][@"video_address"];
        NSString *ImageUrl = _dataArray[indexPath.row][@"imageurl"];
        
        classDetailVC * classDetailVc = [[classDetailVC alloc]initWithMemberId:Cid andPrice:Price andTitle:Title];
        classDetailVc.videoTitle = Title;
        classDetailVc.img = ImageUrl;
        classDetailVc.video_address = VideoAddress;
        [self.navigationController pushViewController:classDetailVc animated:YES];

    } else if ([type integerValue] == 2) {
        
        NSString *address = _dataArray[indexPath.row][@"video_address"];
        NSString *Cid = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"id"]];
        if (address == nil) {
            [MBProgressHUD showError:@"直播为空" toView:self.view];
            return;
        }
        
        NSString *Price = _dataArray[indexPath.row][@"price"];
        NSString *Title = _dataArray[indexPath.row][@"video_title"];
        NSString *ImageUrl = _dataArray[indexPath.row][@"imageurl"];
        
        ZhiBoMainViewController *cvc = [[ZhiBoMainViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)indexPath.row andprice:Price];
        [self.navigationController pushViewController:cvc animated:YES];
    }
    
}

#pragma mark --- 网络请求

- (void)netWorkInstitutionClassList {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    [dic setObject:@"1" forKey:@"page"];
//    [dic setObject:@"40" forKey:@"count"];
    [dic setObject:_schoolID forKey:@"school_id"];
    
    [manager BigWinCar_GetSchoolClass:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if (![responseObject[@"msg"] isEqualToString:@"ok"]) {
            return;
        }
        _dataArray = responseObject[@"data"];
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}




@end
