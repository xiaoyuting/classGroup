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

#import "AnswerViewController.h"
#import "MenuViewController.h"
#import "MyMenuViewController.h"


@interface SJXQViewController ()

@property (strong ,nonatomic)NSDictionary *allDic;

@property (strong ,nonatomic)NSDictionary *dataSource;

@property (strong ,nonatomic)UIView *moreView;

@property (strong ,nonatomic)NSDictionary *timeDic;

@property (assign ,nonatomic)NSInteger sumTime;

@property (assign ,nonatomic)NSInteger nowTime;
@property (assign ,nonatomic)NSInteger startTime;
@property (assign ,nonatomic)NSInteger endTime;

@property (strong ,nonatomic)UIButton *testButton;
@property (strong ,nonatomic)id  responseObject;

@end

@implementation SJXQViewController

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
    [self getNowDate];
    [self addNav];
    [self addInfo];
    
    if ([_test_number integerValue] == 0) {//没有考
        
    } else {//已经考过了
        [self NetWorkLookWithTest_Number];
    }
    
    

    
    [self NetWorkDetail];
    [self getEaxmTime];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _moreView = [[UIView alloc] init];
    
    NSLog(@"%@  %@  %@",_exam_times_mode,_startTimeStr,_endTimeStr);
}

- (void)getNowDate {
    NSDate *date = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%f",[date timeIntervalSince1970]];
    NSLog(@"%@",timeSp);
    _nowTime = [timeSp integerValue];
    
    //获取开始的时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSLog(@"%@",formatter);
    
    NSDate *startDate = [formatter dateFromString:_startTimeStr];
    NSLog(@"%@",startDate);
    
    NSString *startTimeSp = [NSString stringWithFormat:@"%f",[startDate timeIntervalSince1970]];
    _startTime = [startTimeSp integerValue];
    
    //获取
    NSDate *endDate = [formatter dateFromString:_endTimeStr];
    NSLog(@"%@",endDate);
    
    NSString *endTimeSp = [NSString stringWithFormat:@"%f",[endDate timeIntervalSince1970]];
    _endTime = [endTimeSp integerValue];
    
    
    NSLog(@"%ld %ld  %ld",_nowTime,_startTime,_endTime);

    
    
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
    
    
    //开始答题
    UIButton *DTButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 100, MainScreenWidth - 80, 40)];
//    [DTButton setTitle:@"开始答题" forState:UIControlStateNormal];
//    if ([_test_number integerValue] == 0) {
//        [DTButton setTitle:@"开始答题" forState:UIControlStateNormal];
//    }
//    
//    if ([_test_number integerValue] > 0) {//考试详情
//        [DTButton setTitle:@"查看考试详情" forState:UIControlStateNormal];
//    }
    DTButton.backgroundColor = [UIColor redColor];
    
    if (_nowTime < _startTime) {//还没有开始
        [DTButton setTitle:@"还未开始" forState:UIControlStateNormal];
        DTButton.backgroundColor = [UIColor grayColor];
        DTButton.enabled = NO;
    } else if (_nowTime > _startTime) {//已经开始
        
        if ([_exam_times_mode integerValue] == 0) {//无限制次数
            if (_nowTime > _endTime) {
                [DTButton setTitle:@"考试已结束" forState:UIControlStateNormal];
                DTButton.backgroundColor = [UIColor grayColor];
                DTButton.enabled = NO;
            } else {
                [DTButton setTitle:@"开始答题" forState:UIControlStateNormal];
            }
        } else {//有次数限制
            NSLog(@"%ld  %ld",[_test_number integerValue],[_exam_times_mode integerValue]);
            if ([_test_number integerValue] < [_exam_times_mode integerValue]) {//还可以考
                if (_nowTime > _endTime) {//已结束
                    [DTButton setTitle:@"考试已结束" forState:UIControlStateNormal];
                    DTButton.backgroundColor = [UIColor grayColor];
                    DTButton.enabled = NO;
                } else {//还可以考
                     [DTButton setTitle:@"开始答题" forState:UIControlStateNormal];
                }
            } else {//不可以考了
                 [DTButton setTitle:@"查看考试详情" forState:UIControlStateNormal];
            }
        }
    }
    
    if ([_myTest isEqualToString:@"myTest"]) {//从我的考试过来
        [DTButton setTitle:@"查看考试详情" forState:UIControlStateNormal];
        DTButton.backgroundColor = [UIColor redColor];
        DTButton.enabled = YES;
    }
    
    
    
    [DTButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    DTButton.layer.cornerRadius = 3;
    [DTButton addTarget:self action:@selector(DTButton) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:DTButton];
    _testButton = DTButton;
    
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
    if ([_allDic[@"content_sum"] isEqual:[NSNull null]] ) {
        Str1 = @"总共：0题";
    }
     NSString *Str2 = [NSString stringWithFormat:@"考试人数：%@人",_allDic[@"count"]];
//     NSString *Str2 = [NSString stringWithFormat:@"%@人作答",_test_number];
     NSString *Str3 = [NSString stringWithFormat:@"总分：%@分",_allDic[@"score_sum"]];
    if ([_allDic[@"content_sum"] isEqual:[NSNull null]]) {
        Str3 = @"总分：0分";
    }

    NSString *Str4 = [NSString stringWithFormat:@"及格：%@分",_allDic[@"exam_passing_grade"]];
    NSString *Str5 = [NSString stringWithFormat:@"考试时间：%@分钟",_allDic[@"exam_total_time"]];
    NSString *Str6 = [NSString stringWithFormat:@"发布时间：%@",_allDic[@"exam_begin_time"]];

    if ([_allDic[@"exam_total_time"] integerValue ] == 0) {
        Str6 = @"考试时间：没有限制";
    }
    
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
            label.font = Font(15);
        }
        [detailView addSubview:label];
    }
    
    _moreView.frame = CGRectMake(0, CGRectGetMaxY(detailView.frame), MainScreenWidth, MainScreenHeight);
    _moreView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_moreView];

    
}

- (void)addmoreView {
    NSString *Str1 = [NSString stringWithFormat:@"答错：%@题",[[_dataSource dictionaryValueForKey:@"data"] stringValueForKey:@"user_error_count" defaultValue:@"0"]];
    NSString *Str2 = [NSString stringWithFormat:@"答对：%@题",[[_dataSource dictionaryValueForKey:@"data"] stringValueForKey:@"user_right_count" defaultValue:@"0"]];
    NSString *Str3 = [NSString stringWithFormat:@"用时：%@",[[_dataSource dictionaryValueForKey:@"data"] stringValueForKey:@"user_total_date" defaultValue:@"0"]];
    NSString *Str4 = [NSString stringWithFormat:@"得分：%@分",[[_dataSource dictionaryValueForKey:@"data"] stringValueForKey:@"user_total_score" defaultValue:@"0"]];
    
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
    [dic setObject:_pager_id forKey:@"paper_id"];
    
    [MBProgressHUD showMessag:@"加载考试数据中..." toView:self.view];
    
    NSLog(@"%@",dic);
    [manager KSXTAll:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"all--------%@",responseObject);
        _responseObject = responseObject;
        NSLog(@"%@",operation);
        NSLog(@"%@",responseObject[@"data"]);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([responseObject[@"code"] isEqual:[NSNumber numberWithInteger:1]]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            
            if ([_testButton.titleLabel.text isEqualToString:@"开始答题"]) {
                [self beginTest];
            } else if ([_testButton.titleLabel.text isEqualToString:@"查看考试详情"]) {
                [self lookTest];
            }
            
            
//            if (_test_number == nil) {//在线考试进来的
//                
//                if ([_is_test isEqualToString:@"0"]) {//还没有考试
//                    [self beginTest];
//                } else if ([_is_test isEqualToString:@"1"]) {//已经考试了
//                    [self lookTest];
//                }
//
//            } else {//我的考试进来的
//                
//                if ([_test_number integerValue] == 0) {//开始考试
//                    
//                    [self beginTest];
//                } else {//查看考试详情
//                    [self lookTest];
//                }
//                
//            }

        } else {
            
            
            [self lookTest];
            
            
//            if ([_is_test isEqualToString:@"0"]) {//还没有考试
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                 [MBProgressHUD showSuccess:@"还没有考试数据" toView:self.view];
//                return ;
//                
//            } else if ([_is_test isEqualToString:@"1"]) {//已经考试过了
//                
//                NSLog(@"%@",_dataSource);
//                if ([_dataSource[@"code"] integerValue] == 1 ) {
//                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                    [MBProgressHUD showSuccess:@"加载成功" toView:self.view];
//                    RecordViewController *recordVC = [[RecordViewController alloc] init];
//                    recordVC.dataSource = _dataSource;
//                    [self.navigationController pushViewController:recordVC animated:YES];
//                } else {
//                    NSString *showString = _dataSource[@"data"];
//                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                     [MBProgressHUD showSuccess:showString toView:self.view];
//                }
//            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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

//    
//    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
//    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    [dic setObject:_ID forKey:@"exam_id"];
    [dic setObject:_pager_id forKey:@"paper_id"];
    
    
    NSLog(@"%@",dic);
    [manager KSXTJLXQ:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",operation);
        NSLog(@"%@",responseObject[@"data"]);
        _dataSource = responseObject;
//        [self addmoreView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error   %@",error);
        
        
    }];

}

//考试完之后查看答案
- (void)NetWorkLookWithTest_Number {
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        
        return;
    }
    
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    [dic setObject:_ID forKey:@"exam_id"];
    [dic setObject:_pager_id forKey:@"paper_id"];
    [dic setObject:_test_number forKey:@"test_number"];
    
    [manager KSXTTJ_Test_Number:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",operation);
        if ([responseObject[@"code"] integerValue] == 0) {
            return ;
        }
        _dataSource = responseObject;
        [self addmoreView];
        
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
        NSLog(@"error   %@",error);
        
        
    }];

    
}


#pragma mark ---开始考试
- (void)beginTest {
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    [MBProgressHUD showSuccess:@"加载成功" toView:self.view];
//    _dataSource = _responseObject;
//    
//    DTViewController *DTVC = [[DTViewController alloc] init];
//    DTVC.dataSource = _dataSource;
//    
//    NSInteger oldTime = [_allDic[@"exam_total_time"] integerValue] * 60;
//    DTVC.allTime = oldTime;
//    
//    NSLog(@"%ld",DTVC.allTime);
//    DTVC.endTimeStr = _endTimeStr;
//    DTVC.examID = _ID;
//    DTVC.gradeStr = _allDic[@"exam_passing_grade"];
//    DTVC.examTime = _allDic[@"exam_total_time"];
//    
//    NSLog(@"%@",DTVC.gradeStr);
//    [self.navigationController pushViewController:DTVC animated:YES];
//
    
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showSuccess:@"加载成功" toView:self.view];
    _dataSource = _responseObject;
    
    AnswerViewController *answerVc = [[AnswerViewController alloc] init];
    answerVc.dataSource = _dataSource;
    
    NSInteger oldTime = [_allDic[@"exam_total_time"] integerValue] * 60;
    answerVc.allTime = oldTime;
    
    NSLog(@"%ld",answerVc.allTime);
    answerVc.endTimeStr = _endTimeStr;
    answerVc.examID = _ID;
    answerVc.gradeStr = _allDic[@"exam_passing_grade"];
    answerVc.examTime = _allDic[@"exam_total_time"];

    [self.navigationController pushViewController:answerVc animated:YES];
    
}


- (void)lookTest {
//    NSLog(@"%@",_dataSource);
//    RecordViewController *recordVC = [[RecordViewController alloc] init];
//    recordVC.dataSource = _dataSource;
//    [self.navigationController pushViewController:recordVC animated:YES];
    
    
//    MenuViewController *menuVC = [[MenuViewController alloc] init];
//    menuVC.dataSource = _dataSource;
//    [self.navigationController pushViewController:menuVC animated:YES];
    
    if (_dataSource == nil) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"数据不见了" toView:self.view];
        return;
    }
    MyMenuViewController *myMenuVc = [[MyMenuViewController alloc] init];
    myMenuVc.dataSource = _dataSource;
    [self.navigationController pushViewController:myMenuVc animated:YES];
    
}
@end
