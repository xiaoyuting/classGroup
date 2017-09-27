//
//  AllOrderViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/16.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "AllOrderViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "MJRefresh.h"
#import "BigWindCar.h"
#import "MBProgressHUD+Add.h"

#import "InstitutionListCell.h"
#import "OrderCell.h"
#import "InstitutionMainViewController.h"

#import "RefundViewController.h"
#import "OrderDetailViewController.h"
#import "AlipayViewController.h"





@interface AllOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSMutableArray *dataArray;

@property (strong ,nonatomic)NSString *pay_status;//标示符

@property (strong ,nonatomic)NSString *alipayStr;
@property (strong ,nonatomic)NSString *wxpayStr;

@end

@implementation AllOrderViewController
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
    [self addWZView];
    [self addTableView];
    [self NetWorkGetOrder];
}
- (void)interFace {
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"全部订单";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addWZView {
    UIView *WZView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 34)];
    WZView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:WZView];
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [self.view addSubview:lineLab];
    //添加按钮
    NSArray *titleArray = @[@"全部",@"待支付",@"已取消",@"已支付",@"未退款",@"已退款"];
    
    CGFloat ButtonH = 20;
    CGFloat ButtonW = MainScreenWidth / titleArray.count;
    _buttonW = ButtonW;
    for (int i = 0; i < titleArray.count; i ++) {
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(ButtonW * i, 7, ButtonW, ButtonH);
        button.tag = i;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor colorWithRed:89.f / 255 green:89.f / 255 blue:89.f / 255 alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [button addTarget:self action:@selector(WZButton:) forControlEvents:UIControlEventTouchUpInside];
        [WZView addSubview:button];
        if (i == [_typeStr integerValue]) {
            [self WZButton:button];
        }
        
    }
    
    //添加横线
    _HDButton = [[UIButton alloc] initWithFrame:CGRectMake(ButtonW * [_typeStr integerValue], 27 + 3, ButtonW, 1)];
    _HDButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [WZView addSubview:_HDButton];
    
    
}

- (void)WZButton:(UIButton *)button {
    
    self.seletedButton.selected = NO;
    button.selected = YES;
    self.seletedButton = button;
    
    [UIView animateWithDuration:0.25 animations:^{
        _HDButton.frame = CGRectMake(button.tag * _buttonW, 27 + 3, _buttonW, 1);
        _pay_status = [NSString stringWithFormat:@"%ld",button.tag];
    }];
    [self NetWorkGetOrder];
    
}

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 98, MainScreenWidth, MainScreenHeight - 98) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 190;
    [self.view addSubview:_tableView];
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshings)];
    [_tableView headerBeginRefreshing];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
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
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellID = nil;
    CellID = [NSString stringWithFormat:@"cell%@ - %ld",_pay_status,indexPath.row];
    //自定义cell类
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //自定义cell类
    if (cell == nil) {
        cell = [[OrderCell alloc] initWithReuseIdentifier:CellID];
    }
    
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataSourceWith:dict WithType:_typeStr];
    
    [cell.schoolButton addTarget:self action:@selector(schoolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.actionButton addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.schoolButton.tag = indexPath.row;
    cell.actionButton.tag = indexPath.row;
    cell.cancelButton.tag = indexPath.row;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderDetailViewController *orderDetailVc = [[OrderDetailViewController alloc] init];
    orderDetailVc.orderDict = _dataArray[indexPath.row];
    [self.navigationController pushViewController:orderDetailVc animated:YES];

}

#pragma mark --- 事件

- (void)schoolButtonClick:(UIButton *)button {
    InstitutionMainViewController *mainVc = [[InstitutionMainViewController alloc] init];
    mainVc.schoolID = _dataArray[button.tag][@"source_info"][@"school_info"][@"school_id"];
    [self.navigationController pushViewController:mainVc animated:YES];
}

- (void)actionButtonClick:(UIButton *)button {
    NSInteger index = button.tag;
    _orderDict = _dataArray[index];
    
    NSLog(@"%@",_orderDict);
    NSString *title = button.titleLabel.text;
    
    if ([title isEqualToString:@"去支付"]) {
        [self NetGotoPay];
    } else if ([title isEqualToString:@"申请退款"]) {
        [self gotoRefundView];
//        [self isSureRefund];
    } else if ([title isEqualToString:@"退款中"]) {
        
    } else if ([title isEqualToString:@"退款查看"]) {
        
    }
}

- (void)cancelButtonClick:(UIButton *)button {
    NSInteger index = button.tag;
    _orderDict = _dataArray[index];
    [self isSureDele];
}

//是否 真要删除小组
- (void)isSureDele {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否确定要取消该订单" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self NetWorkCancel];
    }];
    [alertController addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//是否 真要删除小组
- (void)isSureRefund {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否要要申请退款" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self NetWorkRefund];
    }];
    [alertController addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)gotoRefundView {
    RefundViewController *refundVc = [[RefundViewController alloc] init];
    refundVc.orderDict= _orderDict;
    [self.navigationController pushViewController:refundVc animated:YES];
    
}


#pragma mark --- 网络请求
- (void)NetWorkGetOrder {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"20" forKey:@"count"];
    [dic setValue:@"course" forKey:@"type"];
    [dic setValue:_pay_status forKey:@"pay_status"];
    
    [manager BigWinCar_getOrder:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"======  %@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] != 1) {
            [MBProgressHUD showError:msg toView:self.view];
        }
        _dataArray = responseObject[@"data"];
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}


//去支付
- (void)NetGotoPay {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    [dic setValue:_orderDict[@"order_id"] forKey:@"order_id"];
    NSLog(@"%@",_orderDict[@"order_id"]);
    [dic setValue:_orderDict[@"order_type"] forKey:@"order_type"];//点播
    
    [manager BigWinCar_payOrder:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"======  %@",responseObject);
        
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"is_free"] integerValue] == 0 ) {//不是免费
                _alipayStr = responseObject[@"data"][@"alipay"][@"ios"];
                AlipayViewController *alipayVc = [[AlipayViewController alloc] init];
                alipayVc.payStr = _alipayStr;
                [self.navigationController pushViewController:alipayVc animated:YES];
            } else {//免费
                [MBProgressHUD showSuccess:@"购买成功" toView:self.view];
            }
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}



//取消订单
- (void)NetWorkCancel {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    
    [dic setValue:_orderDict[@"order_id"] forKey:@"order_id"];
    [dic setValue:_orderDict[@"order_type"] forKey:@"order_type"];
    NSLog(@"%@   %@",dic,_orderDict);
    
    [manager BigWinCar_orderCancel:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"======  %@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] != 1) {
            [MBProgressHUD showError:msg toView:self.view];
        } else {
            [MBProgressHUD showSuccess:@"取消成功" toView:self.view];
//            [self.navigationController popToRootViewControllerAnimated:YES];
            [self NetWorkGetOrder];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}


//申请退款
- (void)NetWorkRefund {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:_orderDict[@"order_id"] forKey:@"order_id"];
    [dic setValue:_orderDict[@"order_type"] forKey:@"order_type"];
    NSLog(@"%@",dic);
    
    [manager BigWinCar_orderRefund:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"======  %@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] != 1) {
            [MBProgressHUD showError:msg toView:self.view];
        } else {
            [MBProgressHUD showSuccess:@"申请成功" toView:self.view];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}







@end
