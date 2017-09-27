//
//  InstCouponViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/3/10.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "InstCouponViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Add.h"
#import "MJRefresh.h"

#import "GLSecondDiscountTableViewCell.h"


@interface InstCouponViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic)NSString *schoolID;
@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSArray *dataArray;

@end

@implementation InstCouponViewController

- (instancetype)initWithSchoolID:(NSString *)schoolID {
    if (self=[super init]) {
        _schoolID= schoolID;
    }
    return self;
}

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
    [self netWorkInstGetCouponList];
    
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
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
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25, MainScreenWidth - 100, 30)];
    WZLabel.text = @"机构主页";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    //添加横线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:button];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark --- UITableView

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 98, MainScreenWidth, MainScreenHeight - 98 + 36) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
//    _tableView.rowHeight = 190;
    [self.view addSubview:_tableView];
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshings)];
    [_tableView headerBeginRefreshing];

}


#pragma mark --- 刷新

- (void)headerRerefreshings
{
    //    [self reachGO];
    //    [self requestData:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
    
    
}

- (void)footerRefreshing
{
    //    _numder++;
    //    [self requestData:_numder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
}




#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (MainScreenWidth>375) {
        return 320;
    }else
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLSecondDiscountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLSecondDiscountTableViewCell"];
    
    if (!cell) {
        NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"GLSecondDiscountTableViewCell" owner:nil options:nil];
        cell = [cellArr objectAtIndex:0];
    }
    [cell.UseBtn.layer setBorderColor:[UIColor colorWithHexString:@"#e15a5a"].CGColor];
    
    [cell.UseBtn setTitleColor:[UIColor colorWithHexString:@"#e15a5a"] forState:UIControlStateNormal];
    [cell.UseBtn setTitle:@"立即领取" forState:UIControlStateNormal];
    cell.UseBtn.tag = indexPath.row;
    [cell.UseBtn addTarget:self action:@selector(UseBtnCilck:) forControlEvents:UIControlEventTouchUpInside];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.cateGarryLab.textColor = [UIColor colorWithHexString:@"#BC3838"];
    cell.backLab.backgroundColor = [UIColor colorWithHexString:@"#fa9899"];
    cell.xiamianImg.image = [UIImage imageNamed:@"670-1.png"];
    cell.LimitTimelab.textColor = [UIColor colorWithHexString:@"#BC3838"];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cell.FirstLab.text = [NSString stringWithFormat:@"机构：%@",_dataArray[indexPath.row][@"school_title"]];
    
    
    NSString *starTime = [Passport glformatterDate:_dataArray[indexPath.row][@"ctime"]];
    NSString *endTime = [Passport glformatterDate:_dataArray[indexPath.row][@"end_time"]];
    cell.LimitTimelab.text = [NSString stringWithFormat:@"%@ - %@",starTime,endTime];
//    //折扣
    NSString *discount = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"discount"]];
    int disco = [discount intValue];
    cell.HeaderTitleLab.text = [NSString stringWithFormat:@"%d折",disco];
//    //存编号
//    cell.secondLab.text = [NSString stringWithFormat:@"存编号：%@",_da];
    cell.secondLab.text = [NSString stringWithFormat:@"卡券编号：%@",_dataArray[indexPath.row][@"code"]];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark --- 事件监听

- (void)UseBtnCilck:(UIButton *)button {
    
    NSLog(@"123");
    NSString *code = [NSString stringWithFormat:@"%@",_dataArray[button.tag][@"code"]];
    
    [self netWorkInstGrantCoupon:code];
    
}

#pragma mark --- 网络请求

#pragma mark --- 网络请求
//获取机构详情
- (void)netWorkInstGetCouponList {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    [dic setObject:_schoolID forKey:@"school_id"];
    [dic setObject:@"2" forKey:@"type"];
    [dic setObject:@"20" forKey:@"count"];
    
    [manager BigWinCar_getCouponList:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        NSLog(@"22----%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 0) {
            //添加空白提示
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 200, 200)];
            imageView.image = Image(@"更改背景图片.png");
            imageView.center = CGPointMake(MainScreenWidth / 2 , 300);
            if (iPhone6) {
                imageView.center = CGPointMake(MainScreenWidth / 2 , 220);
            } else if (iPhone6Plus) {
                imageView.center = CGPointMake(MainScreenWidth / 2 , 280);
            } else if (iPhone5o5Co5S) {
                imageView.center = CGPointMake(MainScreenWidth / 2 , 190);
            }
            [_tableView addSubview:imageView];
            return;
        }
        
        _dataArray = responseObject[@"data"];
        NSLog(@"%@",_dataArray);
        [_tableView reloadData];
        if (_dataArray.count != 0) {
            [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


//获取机构优惠券
- (void)netWorkInstGrantCoupon:(NSString*)code {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    [dic setObject:code forKey:@"code"];
    
    [manager BigWinCar_grantCoupon:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        NSLog(@"22----%@",responseObject);
        NSString *msg = responseObject[@"msg"];
        
        if ([responseObject[@"code"] integerValue] == 1) {
            [MBProgressHUD showSuccess:@"领取成功" toView:self.view];
            [self netWorkInstGetCouponList];
        } else {
            [MBProgressHUD showError:msg toView:self.view];
            return ;
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}




@end
