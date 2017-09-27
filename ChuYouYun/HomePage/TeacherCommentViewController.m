//
//  TeacherCommentViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/5/15.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "TeacherCommentViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "MBProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"
#import "Passport.h"
#import "SYGDPViewController.h"
#import "DLViewController.h"




@interface TeacherCommentViewController ()

@property (strong ,nonatomic)NSString *ID;
@property (strong ,nonatomic)NSArray  *commentArray;

@end

@implementation TeacherCommentViewController

-(instancetype)initWithNumID:(NSString *)ID{
    
    self = [super init];
    if (self) {
        _ID = ID;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    //用于刷新评论的
    [super viewWillAppear:animated];
    [self netWorkComment];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addCommentButton];
    [self netWorkComment];
}


- (void)interFace {
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)addCommentButton {
    
    UIButton * v_headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    v_headerBtn.frame = CGRectMake(MainScreenWidth-70, 70, 85, 22);
    v_headerBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [v_headerBtn setImage:[UIImage imageNamed:@"552cc17f5bb87_32@2x.png"] forState:UIControlStateNormal];
    [v_headerBtn addTarget:self action:@selector(MakeCommentBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:v_headerBtn];
    
}

- (void)addCommentView {
    
    for (int i = 0 ; i < _commentArray.count ; i ++) {
    
        UIView *indexView = [[UIView alloc] initWithFrame:CGRectMake(0, 100 + 110 * i, MainScreenWidth, 100)];
        indexView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:indexView];
        
        //名字 文本
        UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, 60 , 60)];
        imageButton.backgroundColor = [UIColor redColor];
        imageButton.layer.cornerRadius = 30;
        imageButton.layer.masksToBounds = YES;
        [indexView addSubview:imageButton];
        [imageButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_commentArray[i][@"userface"]]]forState:(UIControlStateNormal) placeholderImage:(Image(@"站位图"))];
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside,70, 60 , 20)];
        name.font = Font(14);
        name.textColor = [UIColor grayColor];
        name.textAlignment = NSTextAlignmentCenter;
        [indexView addSubview:name];
        name.text = _commentArray[i][@"username"];
        
        
        //分数
       UILabel *score = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageButton.frame) + SpaceBaside, SpaceBaside, MainScreenWidth - 90 , 20)];
        score.text = @"综合：5分 专业水平：5分 授课技巧：5分 教学态度：5分";
        score.font = Font(12);
        score.textColor = BlackNotColor;
        [indexView addSubview:score];
        
        NSString *Str0 = [NSString stringWithFormat:@"%@分",_commentArray[i][@"star"]];
        NSString *Str1 = [NSString stringWithFormat:@"%@分",_commentArray[i][@"attitude"]];
        if ([_commentArray[i][@"attitude"] isEqual:[NSNull null]]) {
            Str1 = @"";
        }
        NSString *Str2 = [NSString stringWithFormat:@"%@分",_commentArray[i][@"professional"]];
        if ([_commentArray[i][@"professional"] isEqual:[NSNull null]]) {
            Str2 = @"";
        }
        NSString *Str3 = [NSString stringWithFormat:@"%@分",_commentArray[i][@"skill"]];
        if ([_commentArray[i][@"skill"] isEqual:[NSNull null]]) {
            Str3 = @"";
        }
        score.text = [NSString stringWithFormat:@"综合:%@ 专业水平:%@ 授课技巧:%@ 教学态度:%@",Str0,Str1,Str2,Str3];
        
        //详情
       UILabel *comment = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageButton.frame) + SpaceBaside, 40, MainScreenWidth - 90 , 40)];
        comment.font = Font(14);
        comment.textColor = [UIColor grayColor];
        comment.numberOfLines = 2;
        [indexView addSubview:comment];
        comment.text = _commentArray[i][@"review_description"];
    }
    
    
    if (_commentArray.count == 0) {
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
        [self.view addSubview:imageView];
    }
    
    //计算偏移量

    double MaxSet = _commentArray.count * 110 + 50;
    NSString *MaxStr = [NSString stringWithFormat:@"%lf",MaxSet];
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TeacherCommentScrollHight" object:MaxStr];
}

#pragma mark --- 事件点击

- (void)MakeCommentBtn {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    SYGDPViewController *SYGDPVC = [[SYGDPViewController alloc] init];
    UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:SYGDPVC];
    SYGDPVC.ID = _ID;
    SYGDPVC.isTeacher = @"teacher";
    [self.navigationController presentViewController:Nav animated:YES completion:nil];
}

#pragma mark --- 网络请求

-(void)netWorkComment {
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    //临时的
    [dic setValue:_ID forKey:@"teacher_id"];
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"20" forKey:@"count"];
    
    [manager getpublicPort:dic mod:@"Teacher" act:@"getCommentList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1) {
            _commentArray = responseObject[@"data"];
        }
        [self addCommentView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


@end
