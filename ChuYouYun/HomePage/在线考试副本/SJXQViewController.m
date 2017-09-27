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
#import "RecordViewController.h"
#import "Passport.h"

@interface SJXQViewController ()

@property (strong ,nonatomic)NSDictionary *allDic;

@property (strong ,nonatomic)NSDictionary *dataSource;

@property (strong ,nonatomic)UIView *moreView;

@property (strong ,nonatomic)NSDictionary *timeDic;

@property (assign ,nonatomic)NSInteger sumTime;

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
    if ([_is_test isEqualToString:@"1"]) {
        [self NetWorkLook];
    }
    [self NetWorkDetail];
    [self getEaxmTime];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _moreView = [[UIView alloc] init];
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
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"考试详情";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addInfo {
    NSLog(@"%@",_describe);
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 170)];
    [self.view addSubview:infoView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, MainScreenWidth - 40, 20)];
    titleLabel.font = Font(20);
    titleLabel.text = _titleStr;
    titleLabel.numberOfLines = 1;
    [infoView addSubview:titleLabel];
    
    //添加考试的描述
    UILabel *describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, MainScreenWidth - 40, 40)];
    describeLabel.font = Font(15);
    describeLabel.textColor = XXColor;
    describeLabel.text = _describe;
    describeLabel.numberOfLines = 2;
    [infoView addSubview:describeLabel];
    
    
    
//    UILabel *personLabel = [[UILabel  alloc] initWithFrame:CGRectMake(20, 60, 30, 20)];
//    personLabel.text = [NSString stringWithFormat:@"%@",_personCount];
//    personLabel.font = Font(15);
//    personLabel.textColor = JHColor;
//    personLabel.numberOfLines = 0;

//    CGRect labelSize = [personLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
//    personLabel.frame = CGRectMake(personLabel.frame.origin.x, personLabel.frame.origin.y, labelSize.size.width, 20);
//    [infoView addSubview:personLabel];
//    
//    UILabel *ZDLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(personLabel.frame), 60, 60, 20)];
//    ZDLabel.font = Font(15);
//    ZDLabel.textColor = XXColor;
//    ZDLabel.text = @"人次作答";
//    [infoView addSubview:ZDLabel];
//    
//    UILabel *isKSLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60 + 20, 60, 20)];
//    isKSLabel.font = Font(15);
//    isKSLabel.textColor = XXColor;
//   
//    if ([_is_test isEqualToString:@"0"]) {
//         isKSLabel.text = @"已考";
//    } else {
//         isKSLabel.text = @"未考";
//    }
//    [infoView addSubview:isKSLabel];
    
    
    //开始答题
    UIButton *DTButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 100, MainScreenWidth - 80, 40)];
    [DTButton setTitle:@"开始答题" forState:UIControlStateNormal];
    if ([_is_test isEqualToString:@"1"]) {
            [DTButton setTitle:@"查看考试详情" forState:UIControlStateNormal];
    }
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
    UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 180 + 64 + 6, MainScreenWidth, 100)];
    [self.view addSubview:detailView];
    
     NSString *Str1 = [NSString stringWithFormat:@"总共：%@题",_allDic[@"content_sum"]];
     NSString *Str2 = [NSString stringWithFormat:@"%@人作答",_allDic[@"count"]];
     NSString *Str3 = [NSString stringWithFormat:@"总分：%@分",_allDic[@"score_sum"]];
     NSString *Str4 = [NSString stringWithFormat:@"及格：%@分",_allDic[@"exam_passing_grade"]];
    NSString *Str5 = [NSString stringWithFormat:@"发布时间：%@",_allDic[@"exam_begin_time"]];
     NSString *Str6 = [NSString stringWithFormat:@"考试时间：%@分钟",_allDic[@"exam_total_time"]];
    
    NSArray *titleArray = @[Str1,Str2,Str3,Str4,Str5,Str6];
    CGFloat LH = 30;
    CGFloat HW = MainScreenWidth / 2 - 20;
    
    for (int i = 0; i < 6 ; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20 * ((i % 2) + 1) + (i % 2) * HW, (i / 2) * LH, HW, LH)];
        label.text = titleArray[i];
        label.textColor = XXColor;
        if (iPhone6) {
            label.font = Font(12);
        } else if (iPhone5o5Co5S) {
            label.font = Font(10);
        } else if (iPhone4SOriPhone4) {
            label.font = Font(10);
        } else if (iPhone6Plus) {
            label.font = Font(12);
        }
        [detailView addSubview:label];
    }
    
    _moreView.frame = CGRectMake(0, CGRectGetMaxY(detailView.frame), MainScreenWidth, MainScreenHeight);
    _moreView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_moreView];

    
}

- (void)addmoreView {
    NSString *Str1 = [NSString stringWithFormat:@"答错：%@题",_dataSource[@"data"][@"user_error_count"]];
    NSString *Str2 = [NSString stringWithFormat:@"答对：%@题",_dataSource[@"data"][@"user_right_count"]];
    NSString *Str3 = [NSString stringWithFormat:@"日期：%@",_dataSource[@"data"][@"user_total_date"]];
    NSString *Str4 = [NSString stringWithFormat:@"得分：%@分",_dataSource[@"data"][@"user_total_score"]];
    
    NSArray *titleArray = @[Str1,Str2,Str3,Str4];
    CGFloat LH = 30;
    CGFloat HW = MainScreenWidth / 2 - 20;
    
    for (int i = 0; i < 4 ; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20 * ((i % 2) + 1) + (i % 2) * HW, (i / 2) * LH, HW, LH)];
        label.text = titleArray[i];
        label.textColor = XXColor;
        if (iPhone6) {
            label.font = Font(12);
        } else if (iPhone5o5Co5S) {
            label.font = Font(10);
        } else if (iPhone4SOriPhone4) {
            label.font = Font(10);
        } else if (iPhone6Plus) {
            label.font = Font(15);
        }
        [_moreView addSubview:label];
    }

    
}

//分类里面的请求
- (void)NetWorkDetail {
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:_ID forKey:@"id"];
    [dic setObject:_pager_id forKey:@"paper_id"];
    
    NSLog(@"%@",dic);
    [manager KSXTFXXQ:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        _allDic = responseObject[@"data"];
        [self addDetail];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}



//获取考试题的所有数据
- (void)NetWorkAll {
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    [dic setObject:_ID forKey:@"exam_id"];
    [dic setObject:_pager_id forKey:@"paper_id"];
    
    [MBProgressHUD showMessag:@"加载考试数据中..." toView:self.view];
    
    NSLog(@"%@",dic);
    [manager KSXTAll:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"all--------%@",responseObject);
        NSLog(@"%@",responseObject[@"data"]);
        
        if ([responseObject[@"code"] integerValue] == 1) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([_is_test integerValue] == 0) {//没有考
                
                DTViewController *DTVC = [[DTViewController alloc] init];
                _dataSource = responseObject;
                DTVC.dataSource = _dataSource;
                
                NSInteger oldTime = [_allDic[@"exam_total_time"] integerValue] * 60;
                if (oldTime > _sumTime) {//说明还有剩余时间
                    DTVC.allTime = oldTime - _sumTime;
                } else {//没有剩余时间
                    DTVC.allTime = -100;
                }
                
                DTVC.endTimeStr = _endTimeStr;
                DTVC.examID = _ID;
                DTVC.gradeStr = _allDic[@"exam_passing_grade"];
                [self.navigationController pushViewController:DTVC animated:YES];
                
            } else if ([_is_test integerValue] == 1) {//已经考了
                
                RecordViewController *recordVC = [[RecordViewController alloc] init];
                
                if (_dataSource == nil) {
                    [MBProgressHUD showMessag:@"加载失败" toView:self.view];
                } else {
                    recordVC.dataSource = _dataSource;
                    [self.navigationController pushViewController:recordVC animated:YES];
                }
            }
            
        } else {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([_is_test integerValue] == 0) {//没有考
                [MBProgressHUD showError:@"没有考试数据" toView:self.view];
            } else if ([_is_test integerValue] == 1) {
                if (_dataSource == nil) {
                    [MBProgressHUD showError:@"加载失败" toView:self.view];
                } else {
                    RecordViewController *recordVC = [[RecordViewController alloc] init];
                    recordVC.dataSource = _dataSource;
                    [self.navigationController pushViewController:recordVC animated:YES];
                }

            }

        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"加载失败" toView:self.view];
    }];
}

//考试后查看记录
- (void)NetWorkLook {
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        
        return;
    }

    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    [dic setObject:_ID forKey:@"exam_id"];
    [dic setObject:_pager_id forKey:@"paper_id"];
    
    NSLog(@"%@",dic);
    [manager KSXTJLXQ:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        _dataSource = responseObject;
//        [self addmoreView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)getEaxmTime {
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        
        return;
    }
    
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    [dic setObject:_ID forKey:@"exam_id"];
    
    NSLog(@"%@",dic);
    [manager KSXTTime:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        _timeDic = responseObject[@"data"];
        NSString *HHH = [Passport formatterTime:responseObject[@"data"][@"ctime"]];
        NSString *HH = [Passport formatterTime:responseObject[@"data"][@"time"]];
        NSLog(@"%@----%@",HHH,HH);
        NSInteger sum = [Passport intervalSinceNow:HHH WithTime:HH];
        NSLog(@"%ld",sum);
        _sumTime = sum;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}


@end
