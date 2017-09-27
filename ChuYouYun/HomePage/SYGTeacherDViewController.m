//
//  SYGTeacherDViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/1/28.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

#import "SYGTeacherDViewController.h"
#import "SYGClassTableViewCell.h"
#import "UIButton+WebCache.h"
#import "MyHttpRequest.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "teacherDetailTabelViewCellTableViewCell.h"
#import "teacherList.h"
#import "classDetailVC.h"
#import "ZhiyiHTTPRequest.h"
#import "DLViewController.h"
#import "SXXQViewController.h"
#import "SendMSGToChatViewController.h"
#import "MJRefresh.h"
#import "SXXQViewController.h"
#import "MessageSendViewController.h"
#import "GLReachabilityView.h"
#import "TIXingLable.h"
#import "UIColor+HTMLColors.h"




@interface SYGTeacherDViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    TIXingLable *_txLab;
    
}

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSMutableArray *dataArray;

@property (nonatomic , strong)NSDictionary *SYGDic;

@property (strong ,nonatomic)NSString *uID;

@property (nonatomic , strong)UIButton *GZButton;

@property (nonatomic , strong)UIButton *LTButton;

@property (assign ,nonatomic)NSInteger number;

@property (strong ,nonatomic)UIImageView *imageView;


@end

@implementation SYGTeacherDViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    //登录之后这里应该需要刷新数据和之前的界面
//    [_tableView reloadData];
//    [self GZNetWork];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self GZNetWork];
//    [self requestData];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self initer];
    
    
    

}

- (void)initer {
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加ImageView
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 280)];
    imageView.image = [UIImage imageNamed:@"组-1@2x"];
    [self.view addSubview:imageView];
    _imageView = imageView;
    imageView.userInteractionEnabled = YES;
    
    //添加返回按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"焦点按钮@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(CLButton:) forControlEvents:UIControlEventTouchUpInside];
    backButton.tag = 1;
    [imageView addSubview:backButton];
    
    //添加头像
    UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 40, 60, 80, 80)];
    imageButton.layer.cornerRadius = 40;
//    [imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_SYGDic[@"headimg"]] forState:UIControlStateNormal];
    [imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_headImageStr] forState:UIControlStateNormal];
    imageButton.layer.cornerRadius = 40;
    imageButton.layer.masksToBounds = YES;
    [imageView addSubview:imageButton];
    
    //添加名字
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 150, 200, 30)];
//    nameLabel.text = _SYGDic[@"name"];
    nameLabel.text = _nameStr;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:nameLabel];
    
    //添加简介
    UILabel *JJLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 200, 180, 400, 30)];
//    JJLabel.text = _SYGDic[@"label"];
    JJLabel.text = _JSLabel;
    JJLabel.textColor = [UIColor whiteColor];
    JJLabel.font = [UIFont systemFontOfSize:13];
    JJLabel.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:JJLabel];
    [self addGZView];
    [self addTableView];
    
    //添加刷新
    //添加刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [_tableView headerBeginRefreshing];
    
    //上拉加载
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
}

- (void)addGZView {
    
    UIView *GZView = [[UIView alloc] initWithFrame:CGRectMake(0, 240, MainScreenWidth, 40)];
    GZView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:GZView];
    
    //添加相关课程和最新课程
    
    NSArray *XGZXArray;
    if ([_SYGDic[@"follow_state"][@"following"] integerValue] == 1) {
        
        XGZXArray = @[@"已关注",@"私信"];
    }else {
        XGZXArray = @[@"关注",@"私信"];
    }

    _GZButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, MainScreenWidth / 2, 30)];
    _GZButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_GZButton setTitle:XGZXArray[0] forState:UIControlStateNormal];
    [_GZButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _GZButton.tag = 0;
    [_GZButton addTarget:self action:@selector(GZLT:) forControlEvents:UIControlEventTouchUpInside];
    [GZView addSubview:_GZButton];
    
    
    _LTButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 , 5, MainScreenWidth / 2, 30)];
    _LTButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_LTButton setTitle:XGZXArray[1] forState:UIControlStateNormal];
    [_LTButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _LTButton.tag = 1;
    [_LTButton addTarget:self action:@selector(GZLT:) forControlEvents:UIControlEventTouchUpInside];
    [GZView addSubview:_LTButton];
    

    //添加中间的分割线
    UILabel *FGLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 0.5, 0, 0.5, 40)];
    FGLabel.backgroundColor = [UIColor whiteColor];
    [GZView addSubview:FGLabel];

}

- (void)headerRerefreshing
{
    
    [self requestData:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        if (_dataArray.count == 0) {
            _txLab.textColor = [UIColor colorWithHexString:@"#dedede"];
        }else{
        
            _txLab.textColor = [UIColor clearColor];
        }
    });
    
    
}


- (void)footerRefreshing
{
    
    _number++;
    [self requestData:_number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
    
    
    
}



- (void)GZLT:(UIButton *)button {

    if (![GLReachabilityView isConnectionAvailable]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"操作失败,请查看网络连接" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (button.tag == 0) {//关注
        NSLog(@"%@",button.titleLabel.text);
        if ([button.titleLabel.text isEqualToString:@"关注"]) {
            [self GZTJ];
        }else {
            [self GZNO];
        }
        
    }
    if (button.tag == 1) {//聊天
        //进入私信界面
        NSLog(@"------%@",_SYGDic);

        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
            
            DLViewController *DLVC = [[DLViewController alloc] init];
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
            [self.navigationController presentViewController:Nav animated:YES completion:nil];
            return;
            
        }
        
        MessageSendViewController *MSVC = [[MessageSendViewController alloc] init];
        MSVC.TID = _uID;
        MSVC.name = _nameStr;
        [self.navigationController pushViewController:MSVC animated:YES];
        
        
    }
}

- (void)addTableView {
    
    UIView *KCView = [[UIView alloc] initWithFrame:CGRectMake(0, 280, MainScreenWidth, 40)];
    KCView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:KCView];
    
    //添加他的主页
    UILabel *ZYLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, MainScreenWidth - 20, 40)];
    ZYLabel.text = @"TA的课程";
    ZYLabel.font = [UIFont systemFontOfSize:16];
    [KCView addSubview:ZYLabel];


    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 320, MainScreenWidth, MainScreenHeight - 320 + 20 + 20 -2) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 110;
    [self.view addSubview:_tableView];
    _txLab = [[TIXingLable alloc]initWithFrame:CGRectMake(0, 50*MainScreenHeight/667, MainScreenWidth, 30)];
    [_tableView insertSubview:_txLab atIndex:0];
    _txLab.textColor = [UIColor clearColor];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,5,0,0)];
    }
    
    //设置表格分割线的长度（跟两边的距离）
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,2,0,0)];
    }
    
}

- (void)CLButton:(UIButton *)button {
    
    if (button.tag == 1) {//返回
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (button.tag == 2) {//主页
        
    }
}


#pragma mark -- 

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_dataArray isEqual:[NSNull null]]) {
        return 0;
    }else {
        return _dataArray.count;
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellStr = @"SYGClassTableViewCell";
    SYGClassTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[SYGClassTableViewCell alloc] initWithReuseIdentifier:cellStr];
    }
    
    NSLog(@"%@",_dataArray);

    [cell.imageButton setBackgroundImage:[UIImage imageNamed:@"站位图"] forState:UIControlStateNormal];
    [cell.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_dataArray[indexPath.row][@"cover"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"站位图"]];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"video_title"]];
    cell.contentLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"video_intro"]];
    cell.GKLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"video_order_count"]];
    cell.XBLabel.text = [NSString stringWithFormat:@"%@  元",_dataArray[indexPath.row][@"mzprice"][@"price"]];
    
    
    NSString *MoneyStr = [NSString stringWithFormat:@"%@  元",_dataArray[indexPath.row][@"mzprice"][@"price"]];
    NSString *XBStr = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"mzprice"][@"price"]];
    //变颜色
    NSMutableAttributedString *needStr = [[NSMutableAttributedString alloc] initWithString:MoneyStr];
    [needStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] range:NSMakeRange(0, XBStr.length)];
    //设置字体加错
    [needStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, XBStr.length)];
    [needStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, XBStr.length)];
    
    [cell.XBLabel setAttributedText:needStr] ;
    
    
    NSString * starStr = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"video_score"]];
    float length = [starStr floatValue];
    
    if (length == 1) {
        
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"101@2x"] forState:UIControlStateNormal];
    }
    
    if (length == 2) {
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"102@2x"] forState:UIControlStateNormal];
    }else {
        
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"100@2x"] forState:UIControlStateNormal];
    }
    
    if (length == 3) {
        
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"103@2x"] forState:UIControlStateNormal];
    }
    
    if (length == 4) {
        
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"104@2x"] forState:UIControlStateNormal];
    }
    
    if (length == 5) {
        
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"105@2x"] forState:UIControlStateNormal];
    }


    return cell;

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",_dataArray[indexPath.row]);
    NSString *CID = _dataArray[indexPath.row][@"id"];
    NSString *PStr = _dataArray[indexPath.row][@"mzprice"][@"price"];
    NSString *titleStr = _dataArray[indexPath.row][@"video_title"];
    classDetailVC * cvc = [[classDetailVC alloc]initWithMemberId:CID andPrice:PStr andTitle:titleStr];
    cvc.videoTitle = titleStr;
    cvc.img = _dataArray[indexPath.row][@"big_ids"];
    cvc.video_address = _dataArray[indexPath.row][@"video_address"];
    [self.navigationController pushViewController:cvc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


//网络请求

- (void)requestData:(NSInteger)num;
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_tid forKey:@"teacher_id"];
    [dic setValue:[NSNumber numberWithInteger:num] forKey:@"page"];
    [dic setValue:@"20" forKey:@"count"];
    [dic setValue:_relateCourse forKey:@"cateId"];
    [manager getTeacher:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"---->>%@",responseObject);
         NSArray *LJArray = responseObject[@"data"];
//        array = [responseObject objectForKey:@"data"];
//        NSMutableArray * listArr = [[NSMutableArray alloc]initWithCapacity:0];
        
        if(!LJArray.count)
        {
            if (num == 1) {//课程本来就没有数据
                
                //空白处理
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 320, 150, 150)];
                imageView.image = [UIImage imageNamed:@"更改背景图片"];
                imageView.center = CGPointMake(_tableView.center.x, _tableView.center.y - 50);
                imageView.backgroundColor = [UIColor redColor];
                [self.view addSubview:imageView];
                
                UILabel *WZLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 30)];
                WZLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
                WZLabel.text = @"这个讲师有点忙，还没有上传课程的哦";
                WZLabel.textAlignment = NSTextAlignmentCenter;
                WZLabel.font = [UIFont systemFontOfSize:14];
                WZLabel.textColor = [UIColor colorWithRed:125.f / 255 green:125.f / 255 blue:125.f / 255 alpha:1];
                //设置字体
                WZLabel.center = CGPointMake(_tableView.center.x, CGRectGetMaxY(imageView.frame) + 10);
                [self.view addSubview:WZLabel];

            } else {//刷新到没有数据了
                
            }
        }
        else{
            
            if (num == 1) {
                _dataArray = [NSMutableArray arrayWithArray:LJArray];
                
            }else {
                NSArray *SYGArray = [NSArray arrayWithArray:LJArray];
                [_dataArray addObjectsFromArray:SYGArray];
                
            }

            
            [_tableView reloadData];
        }
      
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (void)GZNetWork {
    
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_tid forKey:@"teacher_id"];
    //判断是否处于登录状态
    [self initer];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        
        
    } else {//已经登录
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
        
    }
    
    
    [manager getTeacherGZ:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"---->>%@",responseObject);
        _SYGDic = responseObject[@"data"];
        _uID = responseObject[@"data"][@"uid"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

//取消关注
- (void)GZNO {
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_uID forKey:@"user_id"];
    //判断是否处于登录状态
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        //提示登录
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];

        
    } else {//已经登录
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
        
    }
    
    
    [manager cancelUserAttention:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"---->>%@",responseObject);

        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {//取消成功
            
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"取消成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//            [alert show];
//            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];
            [_GZButton setTitle:@"关注" forState:UIControlStateNormal];

        }else {//取消失败
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"取消失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];
            

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}


//添加关注
- (void)GZTJ {
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_uID forKey:@"user_id"];
    //判断是否处于登录状态
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        //提示登录
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        
    } else {//已经登录
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
        
    }
    
    
    [manager userAttention:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"---->>%@",responseObject);

        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {//添加成功
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"关注成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//            [alert show];
//            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];

            [_GZButton setTitle:@"已关注" forState:UIControlStateNormal];
            
        }else {//添加失败
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"关注失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];
            return ;

        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

//移除警告框
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}


@end
