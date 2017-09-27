//
//  RefundVC.m
//  dafengche
//
//  Created by 赛新科技 on 2017/2/20.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "RefundVC.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "MJRefresh.h"
#import "MBProgressHUD+Add.h"

#import "InstitutionListCell.h"
#import "OrderCell.h"
#import "InstitutionMainViewController.h"

#import "OrderDetailViewController.h"
#import "AlipayViewController.h"

#import "ZhiBoMainViewController.h"
#import "classDetailVC.h"



@interface RefundVC ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSMutableArray *dataArray;

@property (strong ,nonatomic)NSString *pay_status;//标示符

@property (strong ,nonatomic)NSString *alipayStr;
@property (strong ,nonatomic)NSString *wxpayStr;

@property (assign ,nonatomic)NSInteger number;
@property (strong ,nonatomic)UIImageView *imageView;

@end

@implementation RefundVC

- (instancetype)initWithType:(NSString *)type {
    if (self=[super init]) {
        _isInst = type;
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
    [self addTableView];
    if ([_isInst isEqualToString:@"inst"]) {
        [self NetWorkGetOrderInfo];
    } else if ([_isInst isEqualToString:@"order"]) {
        [self NetWorkGetOrderWithNumber:1];
    }
}
- (void)interFace {
    
    self.view.backgroundColor = [UIColor yellowColor];
    _number = 1;
    
}

#pragma mark --- UITableView

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 98, MainScreenWidth, MainScreenHeight - 98 + 36) style:UITableViewStyleGrouped];
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
    [self NetWorkGetOrderWithNumber:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
    
    
}

- (void)footerRefreshing
{
    _number ++;
    [self NetWorkGetOrderWithNumber:_number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
}



#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.05;
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
    
    if ([_isInst isEqualToString:@"inst"]) {
        [cell.actionButton setTitle:@"查看详情" forState:UIControlStateNormal];
    }
    
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    
    [cell addGestureRecognizer:longPressGr];
    cell.tag = indexPath.row;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    OrderDetailViewController *orderDetailVc = [[OrderDetailViewController alloc] init];
//    orderDetailVc.orderDict = _dataArray[indexPath.row];
//    orderDetailVc.isNoRefund = @"refund";
//    [self.navigationController pushViewController:orderDetailVc animated:YES];
    
    
    NSLog(@"%@",_dataArray);
    if ([_dataArray[indexPath.row][@"order_type"] integerValue] == 4) {//点播
        
        NSString *Cid = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"source_info"][@"id"]];
        NSString *Price = _dataArray[indexPath.row][@"source_info"][@"price"];
        NSString *Title = _dataArray[indexPath.row][@"source_info"][@"video_title"];
        NSString *VideoAddress = _dataArray[indexPath.row][@"source_info"][@"video_address"];
        if ([VideoAddress isEqualToString:@""]) {//为空就返回
        }
        NSString *ImageUrl = _dataArray[indexPath.row][@"source_info"][@"cover"];
        
        classDetailVC * classDetailVc = [[classDetailVC alloc]initWithMemberId:Cid andPrice:Price andTitle:Title];
        classDetailVc.videoTitle = Title;
        classDetailVc.img = ImageUrl;
        classDetailVc.video_address = VideoAddress;
        [self.navigationController pushViewController:classDetailVc animated:YES];
    } else {//直播
        NSString *Cid = nil;
        Cid = _dataArray[indexPath.row][@"source_info"][@"id"];
        NSString *Price = _dataArray[indexPath.row][@"source_info"][@"price"];
        NSString *Title = _dataArray[indexPath.row][@"source_info"][@"video_title"];
        NSString *ImageUrl = _dataArray[indexPath.row][@"source_info"][@"cover"];
        
        ZhiBoMainViewController *zhiBoMainVc = [[ZhiBoMainViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)indexPath.row andprice:Price];
        [self.navigationController pushViewController:zhiBoMainVc animated:YES];
    }

    
}

#pragma mark --- 手势

- (void)longPressToDo:(UILongPressGestureRecognizer *)gest {
    
    NSInteger Number = gest.view.tag;
    NSLog(@"%ld",(long)Number);
    _orderDict = _dataArray[Number];
    [self isSureDelete];
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
        [self isSureRefund];
    } else if ([title isEqualToString:@"退款中"]) {
        OrderDetailViewController *orderDetailVc = [[OrderDetailViewController alloc] init];
        orderDetailVc.orderDict = _orderDict;
        orderDetailVc.isInstOrOrder = _isInst;
        orderDetailVc.isNoRefund = @"refund";
        [self.navigationController pushViewController:orderDetailVc animated:YES];
    } else if ([title isEqualToString:@"退款查看"]) {
        OrderDetailViewController *orderDetailVc = [[OrderDetailViewController alloc] init];
        orderDetailVc.orderDict = _orderDict;
        orderDetailVc.isInstOrOrder = _isInst;
        orderDetailVc.isNoRefund = @"refund";
        [self.navigationController pushViewController:orderDetailVc animated:YES];
    } else if ([title isEqualToString:@"查看详情"]) {
        OrderDetailViewController *orderDetailVc = [[OrderDetailViewController alloc] init];
        orderDetailVc.orderDict = _orderDict;
        orderDetailVc.isInstOrOrder = _isInst;
        orderDetailVc.isNoRefund = @"refund";
        [self.navigationController pushViewController:orderDetailVc animated:YES];
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

#pragma mark --- 删除订单
- (void)isSureDelete {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否要要申请退款" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self NetWorkdelete];
    }];
    [alertController addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}




#pragma mark --- 网络请求
- (void)NetWorkGetOrderWithNumber:(NSInteger)number {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:[NSString stringWithFormat:@"%ld",number] forKey:@"page"];
    [dic setValue:@"10" forKey:@"count"];
    [dic setValue:@"course" forKey:@"type"];
    [dic setValue:@"5" forKey:@"pay_status"];
    
    [manager BigWinCar_getOrder:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"======  %@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] != 1) {
            [MBProgressHUD showError:msg toView:self.view];
        }
        if (number == 1) {
            _dataArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        } else {
            [_dataArray addObjectsFromArray:responseObject[@"data"]];
        }
        if (_dataArray.count == 0) {
            _imageView.hidden = NO;
            if (_imageView.subviews.count > 0) {
                
            } else {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 200, 200)];
                imageView.image = Image(@"更改背景图片.png");
                imageView.center = CGPointMake(MainScreenWidth / 2 , 300);
                imageView.center = _tableView.center;
                [self.view addSubview:imageView];
            }
        } else {
            _imageView.hidden = YES;
        }
        
        
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)NetWorkGetOrderInfo {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"20" forKey:@"count"];
    //    [dic setValue:@"course" forKey:@"type"];
    [dic setValue:@"5" forKey:@"pay_status"];
    [dic setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"schoolID"] forKey:@"school_id"];
    
    NSLog(@"%@",dic);
    
    
    [manager BigWinCar_getOrderInfo:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"======  %@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] != 1) {
            [MBProgressHUD showError:msg toView:self.view];
            return ;
        }
        _dataArray = responseObject[@"data"][@"list"];
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
            [self NetWorkGetOrderWithNumber:_number];
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

//删除订单
- (void)NetWorkdelete {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    NSLog(@"%@",_orderDict);
    
    [dic setValue:_orderDict[@"order_id"] forKey:@"order_id"];
    [dic setValue:_orderDict[@"order_type"] forKey:@"order_type"];
    NSLog(@"%@",dic);
    
    [manager BigWinCar_deleteOrder:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"======  %@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] != 1) {
            [MBProgressHUD showError:msg toView:self.view];
        } else {
            [MBProgressHUD showSuccess:@"删除成功" toView:self.view];
            [self NetWorkGetOrderWithNumber:_number];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}



@end
