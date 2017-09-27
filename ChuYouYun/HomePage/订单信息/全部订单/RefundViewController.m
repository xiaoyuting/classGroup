//
//  RefundViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/3/6.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "RefundViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "MJRefresh.h"
#import "BigWindCar.h"
#import "MBProgressHUD+Add.h"

@interface RefundViewController ()

@property (strong ,nonatomic)UITextView *textView;
@property (strong ,nonatomic)UILabel *hintLabel;

@end

@implementation RefundViewController

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
    [self addView];
//    [self addWZView];
//    [self addTableView];
//    [self NetWorkGetOrder];
}
- (void)interFace {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:nil];
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
    WZLabel.text = @"退款申请";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
    
    UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 70, 25, 60, 30)];
    [sureButton setTitle:@"申请" forState:UIControlStateNormal];
    sureButton.titleLabel.font = Font(16);
    [sureButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:sureButton];
    
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark ---界面
- (void)addView {
    
    UILabel *className = [[UILabel alloc] initWithFrame:CGRectMake(2 * SpaceBaside, 80, MainScreenWidth - 4 * SpaceBaside, 30)];
    className.text = [NSString stringWithFormat:@"课程：%@",_orderDict[@"source_info"][@"video_title"]];
    className.textColor = BasidColor;
    className.font = Font(20);
    className.backgroundColor = [UIColor clearColor];
    [self.view addSubview:className];
    
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(2 * SpaceBaside, 120, MainScreenWidth - 4 * SpaceBaside, MainScreenHeight /2)];
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = BasidColor.CGColor;
    _textView.layer.cornerRadius = 5;
    [self.view addSubview:_textView];
    
    
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 5, MainScreenWidth - 5 * SpaceBaside, 20)];
    hintLabel.text = @"请写下您的退款原因";
    [_textView addSubview:hintLabel];
    hintLabel.textColor = [UIColor groupTableViewBackgroundColor];
    _hintLabel = hintLabel;
    
}

#pragma mark --- 时间监听

- (void)sureButtonCilck:(UIButton *)button {
    
    if (_textView.text.length == 0) {
        [MBProgressHUD showError:@"请填写申请原因" toView:self.view];
        return;
    }
    
    [self NetWorkRefund];
    
}

#pragma mark --- 通知

- (void)textChange:(NSNotification *)Not {
    
    if (_textView.text.length > 0 ) {
        _hintLabel.hidden = YES;
    } else {
        _hintLabel.hidden = NO;
    }
    
}


#pragma mark ----网络请求

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
    [dic setValue:_textView.text forKey:@"reason"];
    
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
