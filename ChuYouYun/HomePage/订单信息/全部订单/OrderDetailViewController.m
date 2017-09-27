//
//  OrderDetailViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/12/5.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Add.h"

#import "InstitutionMainViewController.h"
#import "AlipayViewController.h"
#import "RefundViewController.h"



@interface OrderDetailViewController ()<UIWebViewDelegate>

@property (strong ,nonatomic)UIView *infoView;

@property (strong ,nonatomic)UIView *allView;
@property (strong ,nonatomic)UIButton *allButton;
@property (strong ,nonatomic)UIView *buyView;
@property (strong ,nonatomic)NSArray *couponArray;

@property (assign ,nonatomic)NSInteger payStatus;

@property (strong ,nonatomic)UIImageView *schoolImage;
@property (strong ,nonatomic)UILabel *schoolName;
@property (strong ,nonatomic)UIButton *schoolButton;
@property (strong ,nonatomic)UILabel *status;
@property (strong ,nonatomic)UIImageView *headerImage;
@property (strong ,nonatomic)UILabel *name;
@property (strong ,nonatomic)UILabel *content;
@property (strong ,nonatomic)UILabel *price;
@property (strong ,nonatomic)UILabel *readPrice;
@property (strong ,nonatomic)UILabel *discount;
@property (strong ,nonatomic)UIButton *downButton;
@property (strong ,nonatomic)UIButton *cancleButton;
@property (strong ,nonatomic)UIButton *actionButton;

@property (strong ,nonatomic)NSString *alipayStr;
@property (strong ,nonatomic)NSString *wxpayStr;

@property (strong ,nonatomic)UITextView *applyTextView;
@property (strong ,nonatomic)UITextView *rejectTextView;
@property (strong ,nonatomic)UIWebView  *webView;
@property (assign ,nonatomic)NSInteger  typeNum;


@end

@implementation OrderDetailViewController

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
    [self addInfoView];
    [self NetWorkGetMyCouponList];

}
- (void)interFace {
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"%@",_orderDict);
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
    WZLabel.text = @"订单详情";
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

#pragma mark ---详情界面

- (void)addInfoView {
    
    _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight)];
    _infoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_infoView];
    
    //机构图像
    _schoolImage = [[UIImageView alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 20, 20)];
    [_infoView addSubview:_schoolImage];
    
    //机构
    _schoolName = [[UILabel alloc] initWithFrame:CGRectMake(40, SpaceBaside, 200, 20)];
    [_infoView addSubview:_schoolName];
    _schoolName.backgroundColor = [UIColor whiteColor];
    
    //机构按钮
    _schoolButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth / 2, 35)];
    _schoolButton.backgroundColor = [UIColor clearColor];
    _schoolButton.tag = 100;
    [_schoolButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_infoView addSubview:_schoolButton];
    
    
    //状态
    _status = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 100, SpaceBaside, 90, 20)];
    [_infoView addSubview:_status];
    _status.textAlignment = NSTextAlignmentRight;
    _status.backgroundColor = [UIColor whiteColor];
    
    //添加背景色
    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, MainScreenWidth, 70)];
    midView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_infoView addSubview:midView];
    
    
    //图片
    _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(SpaceBaside, 40, 60, 60)];
    [_infoView addSubview:_headerImage];
    
    //标题
    _name = [[UILabel alloc] initWithFrame:CGRectMake(80,40,MainScreenWidth - 90, 20)];
    [_infoView addSubview:_name];
    _name.font = Font(15);
    _name.textColor = BlackNotColor;
    
    //名字
    _content = [[UILabel alloc] initWithFrame:CGRectMake(80, 70,MainScreenWidth - 90, 30)];
    [_infoView addSubview:_content];
    _content.font = Font(12);
    _content.numberOfLines = 2;
    _content.textColor = [UIColor grayColor];
    
    //价格
    _price = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 110,MainScreenWidth - 2 * SpaceBaside, 30)];
    [_infoView addSubview:_price];
    _price.font = Font(14);
    _price.textAlignment = NSTextAlignmentRight;
    _price.textColor = [UIColor grayColor];
    
    
    //添加选择折扣
    _discount = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 150, 140,130, 30)];
    [_infoView addSubview:_discount];
    _discount.text = @"请选择折扣:";
    _discount.font = Font(14);
    _discount.textColor = [UIColor grayColor];
    
    
    //添加箭头按钮
    _downButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 30, 140, 30,30)];
    [_downButton setImage:Image(@"灰色乡下") forState:UIControlStateNormal];
    [_downButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _downButton.tag = 400;
    [_infoView addSubview:_downButton];
    
    //实际付款
    _readPrice = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 170,MainScreenWidth - 2 * SpaceBaside, 30)];
    [_infoView addSubview:_readPrice];
    _readPrice.font = Font(14);
    _readPrice.textAlignment = NSTextAlignmentRight;
    _readPrice.textColor = [UIColor grayColor];
    
    
    
    
    //添加横线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_infoView addSubview:lineButton];
    
    //取消订单
    _cancleButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 200, 210, 90, 30)];
    [_cancleButton setTitle:@"取消订单" forState:UIControlStateNormal];
    _cancleButton.layer.cornerRadius = 3;
    _cancleButton.layer.borderWidth = 1;
    _cancleButton.titleLabel.font = Font(16);
    _cancleButton.tag = 200;
    _cancleButton.layer.borderColor = [UIColor orangeColor].CGColor;
    [_cancleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_cancleButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_infoView addSubview:_cancleButton];
    
    //付款
    _actionButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 100, 210, 90, 30)];
    [_actionButton setTitle:@"付款" forState:UIControlStateNormal];
    _actionButton.layer.cornerRadius = 3;
    _actionButton.layer.borderWidth = 1;
    _actionButton.titleLabel.font = Font(16);
    _actionButton.tag = 300;
    _actionButton.layer.borderColor = [UIColor orangeColor].CGColor;
    [_actionButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_actionButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_infoView addSubview:_actionButton];
    
    
    NSDictionary *dict = _orderDict;
    NSLog(@"dict ----- %@",dict);
    NSLog(@"%@",dict[@"source_info"][@"school_info"]);
    
    NSString *imageUrl = nil;
    NSDictionary *schoolDic = dict[@"source_info"][@"school_info"];
    if ([schoolDic count] == 0) {
        imageUrl = nil;
        _schoolName.text = @"";
    } else {
        imageUrl = dict[@"source_info"][@"school_info"][@"logo"];
        _schoolName.text = dict[@"source_info"][@"school_info"][@"title"];
    }
    [_schoolImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Image(@"站位图")];
    NSInteger payStatus = [dict[@"pay_status"] integerValue];
    _payStatus = payStatus;
    if (payStatus == 1) {
        _status.text = @"未支付";
        [_cancleButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [_actionButton setTitle:@"去支付" forState:UIControlStateNormal];
    } else if (payStatus == 2) {
        _status.text = @"已取消";
        [_cancleButton setTitle:@"" forState:UIControlStateNormal];
        [_actionButton setTitle:@"查看" forState:UIControlStateNormal];
        _cancleButton.hidden = YES;
        _actionButton.enabled = NO;
        _actionButton.backgroundColor = [UIColor grayColor];
        [_actionButton setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateNormal];
        _actionButton.layer.borderColor = [UIColor grayColor].CGColor;
        
    } else if (payStatus == 3) {
        _status.text = @"已支付";
        _cancleButton.hidden = YES;
        [_actionButton setTitle:@"申请退款" forState:UIControlStateNormal];
        if ([_isInstOrOrder isEqualToString:@"inst"]) {
            [_actionButton setTitle:@"已见详情" forState:UIControlStateNormal];
        }
    } else if (payStatus == 4) {
        _status.text = @"退款审核中";
        _cancleButton.hidden = YES;
        [_actionButton setTitle:@"申请退款" forState:UIControlStateNormal];
        _actionButton.hidden = YES;
    } else if (payStatus == 5) {
        _status.text = @"退款成功";
        _cancleButton.hidden = YES;
        [_actionButton setTitle:@"退款查看" forState:UIControlStateNormal];
        if ([_isInstOrOrder isEqualToString:@"inst"]) {
            [_actionButton setTitle:@"已见详情" forState:UIControlStateNormal];
        }
        
    } else if (payStatus == 6) {
        _status.text = @"被驳回";
        _status.textColor = [UIColor redColor];
        _actionButton.hidden = YES;
        _cancleButton.hidden = YES;
        
    }
    
    NSLog(@"%@",dict);
    NSString *urlStr = dict[@"source_info"][@"cover"];
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
    
    _name.text = dict[@"source_info"][@"video_title"];
    NSString *intro = [self filterHTML:dict[@"source_info"][@"video_intro"]];
    _content.text = intro;
    _price.text = [NSString stringWithFormat:@"应付：%@",dict[@"old_price"]];
    _readPrice.text = [NSString stringWithFormat:@"实付：%@",dict[@"price"]];
    
    NSLog(@"%@",_isNoRefund);
    if ([_isNoRefund isEqualToString:@"refund"]) {
        _discount.hidden = YES;
        _downButton.hidden = YES;
        //添加优惠类型
        UILabel *privilegeType = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 150, 140,140, 30)];
        [_infoView addSubview:privilegeType];
        privilegeType.textAlignment = NSTextAlignmentRight;
        privilegeType.textColor = [UIColor grayColor];
        privilegeType.font = Font(14);
        if ([dict[@"discount"] integerValue] == 0) {
            privilegeType.text = @"未享受优惠";
        } else if ([dict[@"order_type"] integerValue] == 1) {
            CGFloat Float = [dict[@"price"] doubleValue] / [dict[@"old_price"] floatValue] * 10;
            privilegeType.text = [NSString stringWithFormat:@"打折：%lf",Float];
            _readPrice.text = [NSString stringWithFormat:@"实付：%lf",[dict[@"price"] floatValue] * Float];
        } else if ([dict[@"order_type"] integerValue] == 2) {
            double Num = [dict[@"old_price"] doubleValue] - [dict[@"price"] floatValue];
            privilegeType.text = [NSString stringWithFormat:@"优惠：%f",Num];
            _readPrice.text = [NSString stringWithFormat:@"实付：%lf",[dict[@"old_price"] floatValue] - Num];
        } else if ([dict[@"order_type"] integerValue] == 4) {//打折
            CGFloat Float = [dict[@"price"] doubleValue] / [dict[@"old_price"] floatValue] * 10;
            privilegeType.text = [NSString stringWithFormat:@"打折：%lf",Float];
            _readPrice.text = [NSString stringWithFormat:@"实付：%lf",[dict[@"price"] floatValue] * Float];
            
        } else {
            privilegeType.text = [NSString stringWithFormat:@"优惠：%@",dict[@"discount"]];
            _readPrice.text = [NSString stringWithFormat:@"实付：%lf",[dict[@"old_price"] floatValue] - [dict[@"discount"] floatValue]];
        }
    
        
        //已退款
//        privilegeType.hidden = YES;
//        _cancleButton.hidden = YES;
//        _actionButton.hidden = YES;
//        _price.hidden = YES;
//        _readPrice.hidden = YES;
//        lineButton.hidden = YES;
        
    }

    
    if (payStatus == 4 || payStatus == 6) {
         [self addTextViews];
    }

    
}

- (void)addTextViews {
    _applyTextView = [[UITextView alloc] initWithFrame:CGRectMake(SpaceBaside,CGRectGetMaxY(_actionButton.frame) + 40, MainScreenWidth - 2 * SpaceBaside, 100)];
    _applyTextView.layer.cornerRadius = 5;
    _applyTextView.layer.borderWidth = 1;
    _applyTextView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [self.view addSubview:_applyTextView];
    _applyTextView.text = [NSString stringWithFormat:@"申请原因：%@",_orderDict[@"refund_reason"]];
    _applyTextView.editable = NO;
    
    
    
    _rejectTextView = [[UITextView alloc] initWithFrame:CGRectMake(SpaceBaside,CGRectGetMaxY(_applyTextView.frame) + 20, MainScreenWidth - 2 * SpaceBaside, 100)];
    _rejectTextView.layer.cornerRadius = 5;
    _rejectTextView.layer.borderWidth = 1;
    _rejectTextView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [self.view addSubview:_rejectTextView];
    _rejectTextView.text = [NSString stringWithFormat:@"驳回原因：%@",_orderDict[@"reject_info"]];
    if (_payStatus != 6) {
        _rejectTextView.hidden = YES;
    }

    if ([_isInstOrOrder isEqualToString:@"inst"]) {
        _applyTextView.hidden = YES;
        _rejectTextView.hidden = YES;
    }
    
    
}

#pragma mark --- 事件监听
- (void)buttonClick:(UIButton *)button {
    NSString *title = button.titleLabel.text;
    if (button.tag == 100) {
        InstitutionMainViewController *mainVc = [[InstitutionMainViewController alloc] init];
        mainVc.schoolID = _orderDict[@"source_info"][@"school_info"][@"school_id"];
        [self.navigationController pushViewController:mainVc animated:YES];
    } else if (button.tag == 200) {//取消订单
        [self NetWorkCancel];
    } else if (button.tag == 300) {//支付
        if ([title isEqualToString:@"去支付"]) {
            [self gotoAlipay];
        } else if ([title isEqualToString:@"申请退款"]) {
//            [self NetWorkRefund];
            [self gotoRefundVc];
        }
        
    } else if (button.tag == 400) {//选择折扣
        [self addMoreView];
    }

}

- (void)gotoRefundVc {
    
    RefundViewController *refundVc = [[RefundViewController alloc] init];
    refundVc.orderDict = _orderDict;
    [self.navigationController pushViewController:refundVc animated:YES];
}

#pragma mark --- View

- (void)addMoreView {
    
    if (!_couponArray.count) {
        [MBProgressHUD showError:@"没有可用的优惠券" toView:self.view];
        return;
    }
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:_allView];
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
    [_allView addSubview:_allButton];
    
    _buyView = [[UIView alloc] init];
    _buyView.frame = CGRectMake(MainScreenWidth, 64, 100, _couponArray.count * 40 + 5 * (_couponArray.count - 1));
    _buyView.backgroundColor = [UIColor colorWithRed:254.f / 255 green:255.f / 255 blue:255.f / 255 alpha:1];
    _buyView.layer.cornerRadius = 3;
    [_allView addSubview:_buyView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(MainScreenWidth - 100, 64, 100, _couponArray.count * 40 + 5 * (_couponArray.count - 1));
        //在view上面添加东西
        for (int i = 0 ; i < _couponArray.count ; i ++) {
            
            UIButton *button = [[UIButton alloc ] initWithFrame:CGRectMake(0, i * 40 + i * 5, 100, 40)];
            [button setTitle:_couponArray[i][@"discount"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:64.f / 255 green:64.f / 255 blue:64.f / 255 alpha:1] forState:UIControlStateNormal];
            button.layer.cornerRadius = 5;
//            button.tag = [_SYGArray[i][@"exam_category_id"] integerValue];
            [button addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [_buyView addSubview:button];
        }
        
        //添加中间的分割线
        for (int i = 0; i < _couponArray.count; i ++) {
            UIButton *XButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 43 * i , 100, 1)];
            XButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [_buyView addSubview:XButton];
        }
    }];
}


- (void)miss {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(MainScreenWidth, 64, 100, _couponArray.count * 40 + 5 * (_couponArray.count - 1));
        _allView.alpha = 0;
        _allButton.alpha = 0;
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_buyView removeFromSuperview];
        
    });
}

- (void)SYGButton:(UIButton *)button {

    [self miss];
    _discount.frame = CGRectMake(0, 140, MainScreenWidth - 40, 30);
    _discount.textAlignment = NSTextAlignmentRight;
    _discount.text = [NSString stringWithFormat:@"请选择折扣类型：%@",button.titleLabel.text];
    
    //计算最终价格
    NSInteger allNum = [_orderDict[@"price"] integerValue];
    NSInteger littleNum = [button.titleLabel.text integerValue];
    NSInteger lastNum = allNum - littleNum;
    
    _readPrice.text = [NSString stringWithFormat:@"实付：%ld",lastNum];
    if (lastNum < 0) {
        _readPrice.text = [NSString stringWithFormat:@"实付：%d",0];
    }
    
}

- (void)gotoAlipay {
//    [self NetGotoPay];
    [self whichPay];
}


#pragma mark --- 网络请求

- (void)NetWorkGetMyCouponList {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"20" forKey:@"count"];
    [dic setValue:_orderDict[@"source_info"][@"id"] forKey:@"id"];
    
    [manager BigWinCar_getCanUseCouponList:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"======  %@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1) {
            _couponArray = responseObject[@"data"];
        } else {
            _couponArray = nil;
        }
        
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



//支付宝支付
- (void)NetGotoAliPay {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    [dic setValue:_orderDict[@"order_id"] forKey:@"order_id"];
    [dic setValue:_orderDict[@"order_type"] forKey:@"order_type"];//点播
    [dic setValue:@"alipay" forKey:@"pay_for"];
    
    [manager BigWinCar_payOrder:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"======  %@",responseObject);
        
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"is_free"] integerValue] == 0 ) {//不是免费
                _alipayStr = responseObject[@"data"][@"alipay"][@"ios"];
                [self addWebView];
            } else {//免费
                [MBProgressHUD showSuccess:@"购买成功" toView:self.view];
            }
        } else {
            [MBProgressHUD showSuccess:msg toView:self.view];
            msg = @"暂时不能支付";
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alter show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"网络访问失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alter show];
    }];
    
}

//微信支付
- (void)NetGotoWxPay {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    [dic setValue:_orderDict[@"order_id"] forKey:@"order_id"];
    NSLog(@"%@",_orderDict[@"order_id"]);
    [dic setValue:_orderDict[@"order_type"] forKey:@"order_type"];//点播
    [dic setValue:@"wxpay" forKey:@"pay_for"];
    
    [manager BigWinCar_payOrder:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"======  %@",responseObject);
        
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"is_free"] integerValue] == 0 ) {//不是免费
                _wxpayStr = responseObject[@"data"][@"wxpay"][@"ios"];
                [self addWebView];
            } else {//免费
                [MBProgressHUD showSuccess:@"购买成功" toView:self.view];
            }
        } else {
            [MBProgressHUD showError:msg toView:self.view];
            msg = @"暂时不能微信支付";
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alter show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"网络访问失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alter show];
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
    [dic setValue:_orderDict[@"order_type"] forKey:@"order_type"];//点播
    
    [manager BigWinCar_orderCancel:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"======  %@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] != 1) {
            [MBProgressHUD showError:msg toView:self.view];
        } else {
            [MBProgressHUD showSuccess:@"取消成功" toView:self.view];
            [self.navigationController popToRootViewControllerAnimated:YES];
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
    //    [dic setValue:@"1" forKey:@"order_id"];
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




#pragma mark --- 去掉HTML字符
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    }
    // NSString * regEx = @"<([^>]*)>";
    // html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}


#pragma mark --- 添加跳转识图
- (void)addWebView {
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, MainScreenWidth * 2, MainScreenWidth,MainScreenHeight / 2)];
    _webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_webView];
    
    
    [_webView setUserInteractionEnabled:YES];//是否支持交互
    _webView.delegate=self;
    [_webView setOpaque:YES];//opaque是不透明的意思
    [_webView setScalesPageToFit:YES];//自适应
    
    NSURL *url = nil;
    if (_typeNum == 1) {
        if (_alipayStr == nil) {
            [MBProgressHUD showError:@"支付失败" toView:self.view];
        } else {
            url = [NSURL URLWithString:_alipayStr];
        }
        
    } else if (_typeNum == 2) {
        if (_wxpayStr == nil) {
            [MBProgressHUD showError:@"支付失败" toView:self.view];
        } else {
            url = [NSURL URLWithString:_wxpayStr];
        }
    }
    
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}


#pragma mark --- 添加视图

//是否 真要删除小组
- (void)whichPay {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请选择支付方式" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *aliAction = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        _typeNum = 1;
        [self NetGotoAliPay];
    }];
    [alertController addAction:aliAction];
    
    UIAlertAction *wxAction = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        _typeNum = 2;
        [self NetGotoWxPay];
    }];
    [alertController addAction:wxAction];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
