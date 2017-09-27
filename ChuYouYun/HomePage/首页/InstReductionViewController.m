//
//  InstReductionViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/3/10.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "InstReductionViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Add.h"
#import "MJRefresh.h"

#import "GLDiscountTableViewCell.h"
#import "GLDiscountModel.h"
#import "FistDataModel.h"
#import "Passport.h"


@interface InstReductionViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong ,nonatomic)NSString *schoolID;
@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSArray *dataArray;


@end

@implementation InstReductionViewController

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
//    [self addAllScrollView];
//    
    [self netWorkInstGetCouponList];
    
    
    NSLog(@"%@",self.view.subviews[0]);
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
    _tableView.rowHeight = 160;
    [self.view addSubview:_tableView];
    
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
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
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"0----%ld",_dataArray.count);
    return _dataArray.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLDiscountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLDiscountTableViewCell"];
    FistDataModel *fistmod;
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"机构的优惠券"]];// 套用自己的圖片做為背景
//    cell.contentView.backgroundColor =
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"机构的优惠券"]];
    NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"GLDiscountTableViewCell" owner:nil options:nil];
    cell = [cellArr objectAtIndex:0];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"机构的优惠券"]];
    cell.Money.font = [UIFont systemFontOfSize:30];
    cell.Money.text = [NSString stringWithFormat:@"¥：%@",_dataArray[indexPath.row][@"price"]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.MoneyLab.text = [NSString stringWithFormat:@"  %@",_dataArray[indexPath.row][@"price"]];
    cell.firstLab.text = [NSString stringWithFormat:@"满%@立减",_dataArray[indexPath.row][@"maxprice"]];//[NSString stringWithFormat:@"%@",_dataArr[indexPath.section][fistmod.coupon_id]];
    cell.SecondLab.text = [NSString stringWithFormat:@"仅%@可用",_dataArray[indexPath.row][@"school_title"]];//[NSString stringWithFormat:@"%@",_dataArr[indexPath.section][fistmod.sid]];
    NSString *starTime = [Passport glformatterDate:_dataArray[indexPath.row][@"ctime"]];
    NSString *endTime = [Passport glformatterDate:_dataArray[indexPath.row][@"end_time"]];
    
    
    cell.ThirdLab.text = [NSString stringWithFormat:@"%@ - %@",starTime,endTime];
    NSString *status = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][fistmod.status]];
    
//    [cell.UseBtn setBackgroundImage:Image(@"机构的优惠券") forState:UIControlStateNormal];
    [cell.UseBtn setTitle:@"立即领取" forState:UIControlStateNormal];
    [cell.UseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cell.UseBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    cell.UseBtn.backgroundColor = [UIColor colorWithRed:154 / 255.f green:217 / 255.f blue:248 / 255.f alpha:1];
    cell.UseBtn.titleLabel.font = Font(20);
    cell.UseBtn.titleLabel.numberOfLines = 4;
    
    [cell.UseBtn addTarget:self action:@selector(UseBtnCilck:) forControlEvents:UIControlEventTouchUpInside];
    cell.UseBtn.tag = indexPath.row;
    
    if ([status isEqualToString:@"1"]) {
        
    }else{
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark ---- 事件监听

- (void)UseBtnCilck:(UIButton *)button {
    NSString *code = [NSString stringWithFormat:@"%@",_dataArray[button.tag][@"code"]];
    [self netWorkInstGrantCoupon:code];
    
}

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
    [dic setObject:@"1" forKey:@"type"];
    [dic setObject:@"20" forKey:@"count"];
    
    [manager BigWinCar_getCouponList:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        NSLog(@"11----%@",responseObject);
        
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


//获取优惠券
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
