//
//  XCDetilViewController.m
//  dafengche
//
//  Created by IOS on 16/12/16.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "XCDetilViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "PaiKeTableViewCell.h"
#import "MyHttpRequest.h"
#import "Passport.h"
#import "MBProgressHUD+Add.h"
//相册
#import "GLImageVievs.h"

@interface XCDetilViewController ()<UIScrollViewDelegate>{

    NSString *_name;
    
    NSInteger _ID;
    NSString *_teacher_id;
    
    NSArray *_imgUrlArr;

}
@property (strong ,nonatomic)UIScrollView *headScrollow;


@end

@implementation XCDetilViewController

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
-(instancetype)initwithphoto_id:(NSInteger)ID name:(NSString *)name teacher_id:(NSString *)teacher_id{

    _name = name;
    _ID = ID;
    _teacher_id = teacher_id;
    
    return self;
}

-(void)addscrollow{
    
    _headScrollow = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64, MainScreenWidth,MainScreenHeight - 64)];
    _headScrollow.delegate = self;
    _headScrollow.alwaysBounceVertical = NO;
    _headScrollow.pagingEnabled = NO;
    //同时单方向滚动
    _headScrollow.directionalLockEnabled = YES;
    _headScrollow.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:_headScrollow];
    _headScrollow.showsVerticalScrollIndicator = NO;
    _headScrollow.showsHorizontalScrollIndicator = NO;
    _headScrollow.delegate = self;
    _headScrollow.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _headScrollow.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addNav];
    [self addscrollow];
    [self requestLXCata:_teacher_id];

}

//获取相册数据
-(void)requestLXCata:(NSString *)teacher_id
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    //临时的
    [dic setValue:[NSString stringWithFormat:@"%@",_teacher_id] forKey:@"teacher_id"];
    [dic setValue:[NSString stringWithFormat:@"%ld",_ID] forKey:@"photos_id"];

    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"20" forKey:@"count"];
    [manager getpublicPort:dic mod:@"Teacher" act:@"getTeacherPhotosInfo" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);

        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            NSArray *arr = responseObject[@"data"];
            NSMutableArray *marr = [NSMutableArray array];
            NSMutableArray *titlemarr = [NSMutableArray array];
            for (int i = 0; i<arr.count; i++) {
                
                if ([arr[i][@"cover"] length]) {
                    [marr addObject:arr[i][@"cover"]];
                    [titlemarr addObject:[NSString stringWithFormat:@"%@",arr[i][@"title"]]];
                }
            }
            _imgUrlArr = [NSArray arrayWithArray:marr];
            NSArray *titlearr = [NSArray arrayWithArray:titlemarr];
            CGFloat width = MainScreenWidth/3 - 50/3;
            CGFloat y =  width*160/277 + 25 ;
            NSInteger number = titlearr.count;
            _headScrollow.contentSize = CGSizeMake(MainScreenWidth, (1+number/3)*y+50);
            GLImageVievs *glV = [[GLImageVievs alloc]initWithFrame:CGRectMake(0,10, MainScreenWidth, (1+number/3)*y+50) array:_imgUrlArr titleArr:titlearr];
            [_headScrollow addSubview:glV];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}
- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = _name;
    titleLab.text = @"讲师相册";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 120, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,106)];
    [backButton setTitle:@" " forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    //设置button上字体的偏移量
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10.0 , 0.0, 0)];
    [SYGView addSubview:backButton];
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
