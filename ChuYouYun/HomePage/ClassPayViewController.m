//
//  ClassPayViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/3/8.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "ClassPayViewController.h"
#import "SYG.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "ZhiyiHTTPRequest.h"
#import "BigWindCar.h"
#import "MyHttpRequest.h"
#import "MBProgressHUD+Add.h"
#import "MJRefresh.h"
#import "AlipayViewController.h"


@interface ClassPayViewController ()<UIWebViewDelegate> {
    BOOL isArgree;
}

@property (strong ,nonatomic)UIView *buyView;
@property (strong ,nonatomic)UILabel *counpLabel;
@property (strong ,nonatomic)UILabel *infoLabel;
@property (strong ,nonatomic)UILabel *priceLabel;
@property (strong ,nonatomic)NSArray *counpArray;

@property (strong ,nonatomic)NSString *alipayStr;
@property (strong ,nonatomic)NSString *counpID;
@property (strong ,nonatomic)NSString *wxpayStr;


@property (strong ,nonatomic)UIView *allView;
@property (strong ,nonatomic)UIButton *allButton;
@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)UIWebView *webView;
@property (assign,nonatomic) NSInteger typeNum;

@end

@implementation ClassPayViewController

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
    WZLabel.text = @"订单支付";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
//   // 添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark --- webView
- (void)addWebView {
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, MainScreenWidth * 2, MainScreenWidth,MainScreenHeight / 2)];
    _webView.backgroundColor = [UIColor clearColor];
    //    _webView.center = self.view.center;
    [self.view addSubview:_webView];
    
    
    [_webView setUserInteractionEnabled:YES];//是否支持交互
    _webView.delegate=self;
    [_webView setOpaque:YES];//opaque是不透明的意思
    [_webView setScalesPageToFit:YES];//自适应
    
    NSURL *url = nil;
    if (_typeNum == 1104) {
        url = [NSURL URLWithString:_alipayStr];
    } else if (_typeNum == 1105) {
        url = [NSURL URLWithString:_wxpayStr];
    }
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}



#pragma mark --- 添加试图

- (void)addInfoView {
    
    NSArray *titleArray = @[@"课程：",@"价格：",@"使用券："];
    NSString *title = [NSString stringWithFormat:@"%@",_dict[@"video_title"]];
    if ([title isEqualToString:@"(null)"]) {
        title = @"";
    }
    NSString *price = [NSString stringWithFormat:@"%@",_dict[@"mzprice"][@"price"]];
    
    if ([_typeStr isEqualToString:@"直播"]) {
        price = [NSString stringWithFormat:@"%@",_dict[@"price"]];
    } else if ([_typeStr isEqualToString:@"点播"]) {
        price = [NSString stringWithFormat:@"%@",_dict[@"mzprice"][@"price"]];
    }
    
    if ([price integerValue] == 0) {
        price = @"免费";
    }
    
    NSArray *infoArray = @[title,price,@"不使用优惠券"];
    
    for (int i = 0 ; i < 3 ; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 80 + i * 50, 80, 30)];
        if (i == 2) {
            label.frame = CGRectMake(20, 80 + i * 50, 120, 30);
            _counpLabel = label;
            
        }
        
        label.text = titleArray[i];
        [self.view addSubview:label];
        
        
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 80 + i * 50, MainScreenWidth - CGRectGetWidth(label.frame) - 40, 30)];
        infoLabel.text = infoArray[i];
        infoLabel.textColor = BasidColor;
        [self.view addSubview:infoLabel];
        
        if (i == 1) {
            _priceLabel = infoLabel;
        } else if (i == 2) {
            _infoLabel = infoLabel;
        }
        
        if (i == 2) {
            UIButton *chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - CGRectGetWidth(label.frame) - 40, 30)];
            chooseButton.backgroundColor = [UIColor clearColor];
            [chooseButton addTarget:self action:@selector(chooseButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [infoLabel addSubview:chooseButton];
            infoLabel.userInteractionEnabled = YES;
            infoLabel.frame = CGRectMake(100, 80 + i * 50, MainScreenWidth - CGRectGetWidth(label.frame) - 40, 30);
        }
        
        
    }
    
    
    for (int i = 0 ; i < 4 ; i ++) {
        UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 120 + i * 50, MainScreenWidth, 1)];
        lineButton.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
        [self.view addSubview:lineButton];
    }
    
    
    CGFloat BuyViewW = MainScreenWidth / 4 * 3;
    
    //添加同意按钮
    isArgree = NO;
    UIButton *argreeButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside * 2, CGRectGetMaxY(_counpLabel.frame) + 25, 20, 20)];
    [argreeButton setBackgroundImage:Image(@"支付未同意") forState:UIControlStateNormal];
    [argreeButton setBackgroundImage:Image(@"支付同意") forState:UIControlStateSelected];
    [argreeButton addTarget:self action:@selector(isArgree:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:argreeButton];
    
    //是否同意协议
    UILabel *argreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(argreeButton.frame), CGRectGetMaxY(_counpLabel.frame) + 25, BuyViewW, 20)];
    argreeLabel.text = @"我已同意支付方式";
    argreeLabel.font = Font(15);
    argreeLabel.textColor = [UIColor colorWithRed:145.f / 255 green:148.f / 255 blue:155.f / 255 alpha:1];
    [self.view addSubview:argreeLabel];
    
    
    //添加几个按钮
    NSArray *titleString = @[@"支付宝",@"微信"];
    
    CGFloat ButtonW = (MainScreenWidth - 6 * SpaceBaside) / titleString.count;
    
    for (int i = 0 ; i < titleString.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(2 *SpaceBaside + (2 * SpaceBaside + ButtonW) * i , 400 ,ButtonW, 35)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:titleString[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:145.f / 255 green:148.f / 255 blue:155.f / 255 alpha:1] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:232.f / 255 green:235.f / 255 blue:243.f / 255 alpha:1];
        button.layer.cornerRadius = 5;
        button.tag = 1104 + i;
        [button addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        _buyView.frame = CGRectMake(0, 0, BuyViewW, CGRectGetMaxY(button.frame) + SpaceBaside);
        _buyView.center = self.view.center;
        
    }


}



#pragma mark --- 事件点击

- (void)isArgree:(UIButton *)button {
    if (isArgree == NO) {
        isArgree = YES;
        [button setBackgroundImage:Image(@"支付同意") forState:UIControlStateNormal];
    } else if (isArgree == YES) {
        isArgree = NO;
        [button setBackgroundImage:Image(@"支付未同意") forState:UIControlStateNormal];
    }
}

- (void)pressed:(UIButton *)button {
    
    NSInteger Num = button.tag;
    _typeNum = Num;
    if (Num == 1104 ) {//支付宝
        
        if (isArgree == NO) {
            [MBProgressHUD showError:@"请先同意协议" toView:self.view];
            return;
        } else {
            [self classBuyNetInfoAlipay];
        }
    } else if (Num == 1105) {//微信
        if (isArgree == NO) {
            [MBProgressHUD showError:@"请先同意协议" toView:self.view];
            return;
        } else {
            [self classBuyNetInfoWxpay];
        }
        
    } 
    
}

- (void)chooseButtonClick {
    
    if (_counpArray.count == 0 || _counpArray == nil) {
        [MBProgressHUD showError:@"没有可选优惠类型" toView:self.view];
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
    
    
    
    //创建个VIew
    _buyView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth / 4, -100, MainScreenWidth / 2, 85)];
    _buyView.backgroundColor = [UIColor colorWithRed:254.f / 255 green:255.f / 255 blue:255.f / 255 alpha:1];
    _buyView.layer.cornerRadius = 3;
    [_allView addSubview:_buyView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        //改变位置 动画
        _buyView.frame = CGRectMake(MainScreenWidth / 4 ,220 ,MainScreenWidth / 2, 85);
        _buyView.center = self.view.center;

        for (int i = 0 ; i < _counpArray.count ; i ++) {
            UIButton *button = [[UIButton alloc ] initWithFrame:CGRectMake(0, i * 40 + i * 5, 120, 40)];
            
            NSString *title = nil;
            if ([_counpArray[i][@"type"] integerValue] == 1) {//优惠券
                title = [NSString stringWithFormat:@"优惠券：%@",_counpArray[i][@"price"]];
            } else if ([_counpArray[i][@"type"] integerValue] == 2) {
                title = [NSString stringWithFormat:@"打折卡：%@",_counpArray[i][@"discount"]];
            }
            
            [button setTitle:title forState:UIControlStateNormal];
//            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
            button.titleLabel.textAlignment = NSTextAlignmentLeft;
            button.layer.cornerRadius = 5;
            button.tag = [_counpArray[i][@"coupon_id"] integerValue];
            button.tag = i;
            [button addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitleColor:BasidColor forState:UIControlStateNormal];
            [_buyView addSubview:button];
            
            _buyView.frame = CGRectMake(MainScreenWidth / 4, 220, MainScreenWidth / 2, 44 * _counpArray.count);
            
        }
    }];

}

- (void)miss {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(MainScreenWidth / 4, MainScreenHeight, MainScreenWidth / 2, 85);
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
    
    _counpLabel.text = button.titleLabel.text;
    NSString *allStr = button.titleLabel.text;
    NSArray *srtArray = [allStr componentsSeparatedByString:@"："];
    
    if ([_counpArray[button.tag][@"type"] integerValue] == 1) { //优惠券
        _counpLabel.text = @"优惠券：";
        _infoLabel.text = srtArray[1];
        if ([_typeStr isEqualToString:@"直播"]) {
            _priceLabel.text = [NSString stringWithFormat:@"%ld",[_dict[@"price"] integerValue] - [srtArray[1] integerValue]];
        } else if ([_typeStr isEqualToString:@"点播"]) {
            _priceLabel.text = [NSString stringWithFormat:@"%ld",[_dict[@"mzprice"][@"price"] integerValue] - [srtArray[1] integerValue]];
        }
    } else {//打折卡
        _counpLabel.text = @"打折卡：";
        _infoLabel.text = srtArray[1];
        
        if ([_typeStr isEqualToString:@"直播"]) {
            _priceLabel.text = [NSString stringWithFormat:@"%ld",[_dict[@"price"] integerValue] * [srtArray[1] integerValue] / 10];
        } else if ([_typeStr isEqualToString:@"点播"]) {
            _priceLabel.text = [NSString stringWithFormat:@"%ld",[_dict[@"mzprice"][@"price"] integerValue] * [srtArray[1] integerValue] / 10];
        }
        
    }
    
    _counpID = _counpArray[button.tag][@"coupon_id"];
    [self miss];
    
}
#pragma mark --- 获取优惠券的类型

- (void)NetWorkGetMyCouponList {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"20" forKey:@"count"];
    [dic setValue:_cid forKey:@"id"];
    
    [manager BigWinCar_getCanUseCouponList:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"======  %@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1) {
            _counpArray = responseObject[@"data"];
        } else {
            _counpArray = nil;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

//购买课程 获取支付的链接
- (void)classBuyNetInfoAlipay {
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    } else {
        [MBProgressHUD showError:@"请先登陆" toView:self.view];
        return;
    }
    [dic setValue:@"alipay" forKey:@"pay_for"];
    [dic setValue:_cid forKey:@"vids"];
    if (_counpID) {
        [dic setValue:_counpID forKey:@"coupon_id"];
    }
    
    [manager BigWinCar_buyVideos:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"--%@",operation);
        NSLog(@"======  %@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"is_free"] integerValue] == 0 ) {//不是免费
                _alipayStr = responseObject[@"data"][@"alipay"][@"ios"];
                [self addWebView];
//                AlipayViewController *alipayVc = [[AlipayViewController alloc] init];
//                alipayVc.payStr = _alipayStr;
//                [self.navigationController pushViewController:alipayVc animated:YES];
            } else {//免费
                [MBProgressHUD showSuccess:@"购买成功" toView:self.view];
            }
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
    
}


//购买课程 获取微信的链接
- (void)classBuyNetInfoWxpay {
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    } else {
        [MBProgressHUD showError:@"请先登陆" toView:self.view];
        return;
    }
    [dic setValue:@"wxpay" forKey:@"pay_for"];
    [dic setValue:_cid forKey:@"vids"];
    if (_counpID) {
        [dic setValue:_counpID forKey:@"coupon_id"];
    }
    
    [manager BigWinCar_wxpay:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",operation);
        NSLog(@"======  %@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            if ([responseObject[@"data"][@"is_free"] integerValue] == 0 ) {//不是免费
                _wxpayStr = responseObject[@"data"][@"wxpay"][@"ios"];
                [self addWebView];
//                AlipayViewController *alipayVc = [[AlipayViewController alloc] init];
//                alipayVc.payStr = _wxpayStr;
//                [self.navigationController pushViewController:alipayVc animated:YES];
            } else {//免费
                [MBProgressHUD showSuccess:@"购买成功" toView:self.view];
            }
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"支付失败" toView:self.view];
    }];
    
    
}



@end
