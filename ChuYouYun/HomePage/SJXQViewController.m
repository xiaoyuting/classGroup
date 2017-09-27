//
//  SJXQViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/6.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import "SJXQViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "DTViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "DLViewController.h"
#import "MBProgressHUD+Add.h"

@interface SJXQViewController ()

@property (strong ,nonatomic)NSDictionary *allDic;

@property (strong ,nonatomic)NSDictionary *dataSource;

@end

@implementation SJXQViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addNav];
    [self addInfo];
    [self NetWorkDetail];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"焦点按钮@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"考试详情";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addInfo {
    
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 170)];
    [self.view addSubview:infoView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, MainScreenWidth - 40, 20)];
    titleLabel.font = Font(20);
    titleLabel.text = _titleStr;
    titleLabel.numberOfLines = 1;
    [infoView addSubview:titleLabel];
    
    UILabel *personLabel = [[UILabel  alloc] initWithFrame:CGRectMake(20, 60, 30, 20)];
    personLabel.text = [NSString stringWithFormat:@"%@",_personCount];
    personLabel.font = Font(15);
    personLabel.textColor = JHColor;
    personLabel.numberOfLines = 0;
    
    CGRect labelSize = [personLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
    personLabel.frame = CGRectMake(personLabel.frame.origin.x, personLabel.frame.origin.y, labelSize.size.width, 20);
    [infoView addSubview:personLabel];
    
    UILabel *ZDLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(personLabel.frame), 60, 60, 20)];
    ZDLabel.font = Font(15);
    ZDLabel.textColor = XXColor;
    ZDLabel.text = @"人次作答";
    [infoView addSubview:ZDLabel];
    
    //开始答题
    UIButton *DTButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 100, MainScreenWidth - 80, 40)];
    [DTButton setTitle:@"开始答题" forState:UIControlStateNormal];
    [DTButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    DTButton.backgroundColor = [UIColor colorWithRed:247.f / 255 green:79.f / 255 blue:86.f / 255 alpha:1];
    DTButton.layer.cornerRadius = 3;
    [DTButton addTarget:self action:@selector(DTButton) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:DTButton];
    
    //添加横线
    UILabel *HLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, MainScreenWidth - 40, 0.5)];
    HLabel.backgroundColor = PartitionColor;
    [infoView addSubview:HLabel];
}

- (void)DTButton {
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }

    [self NetWorkAll];

}

- (void)addDetail {
    UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 180 + 64 + 6, MainScreenWidth, 200)];
    [self.view addSubview:detailView];
    
     NSString *Str1 = [NSString stringWithFormat:@"总共：%@题",_allDic[@""]];
     NSString *Str2 = [NSString stringWithFormat:@"%@人作答",_allDic[@"count"]];
     NSString *Str3 = [NSString stringWithFormat:@"总分：%@分",_allDic[@""]];
     NSString *Str4 = [NSString stringWithFormat:@"及格：%@分",_allDic[@"exam_passing_grade"]];
     NSString *Str5 = [NSString stringWithFormat:@"发布时间：%@",_allDic[@"exam_update_date"]];
     NSString *Str6 = [NSString stringWithFormat:@"考试时间：%@分钟",_allDic[@"exam_total_time"]];
    
    NSArray *titleArray = @[@"总共：11题",Str2,@"总分：20分",Str4,Str5,Str6];
    CGFloat LH = 30;
    CGFloat HW = MainScreenWidth / 2 - 20;
    
    for (int i = 0; i < 6 ; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20 * ((i % 2) + 1) + (i % 2) * HW, (i / 2) * LH, HW, LH)];
        label.text = titleArray[i];
        label.textColor = XXColor;
        label.font = Font(15);
        [detailView addSubview:label];
    }
    
    
}



//分类里面的请求
- (void)NetWorkDetail {
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
//    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
//    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    [dic setObject:_ID forKey:@"id"];
    
    NSLog(@"%@",dic);
    [manager KSXTFXXQ:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",operation);
        _allDic = responseObject[@"data"];
        [self addDetail];
  

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error   %@",error);
        
        
    }];
    
    
}

//获取考试题的所有数据
- (void)NetWorkAll {
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    [dic setObject:_ID forKey:@"exam_id"];
    
    [MBProgressHUD showMessag:@"加载考试数据中..." toView:self.view];
    
    NSLog(@"%@",dic);
    [manager KSXTAll:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"all--------%@",responseObject);
        NSArray *allArray = responseObject[@"data"];
        if (!allArray.count) {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             [MBProgressHUD showSuccess:@"还没有考试数据" toView:self.view];
             return;
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"加载成功" toView:self.view];
        _dataSource = responseObject;
        
        DTViewController *DTVC = [[DTViewController alloc] init];
        DTVC.dataSource = _dataSource;
        DTVC.allTime = [_allDic[@"exam_total_time"] integerValue];
        [self.navigationController pushViewController:DTVC animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error   %@",error);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD showError:@"加载失败" toView:self.view];
        });
        
        
        
    }];
    
    
}



@end
