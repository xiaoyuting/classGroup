//
//  MYWDViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/3/9.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import "MYWDViewController.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "SYG.h"
#import "MYWDTableViewCell.h"
#import "ZhiyiHTTPRequest.h"
#import "myQuestion.h"
#import "myAnswer.h"
#import "SYGWDViewController.h"
#import "GLReachabilityView.h"
#import "UIColor+HTMLColors.h"
#import "TIXingLable.h"
#import "MBProgressHUD+Add.h"

@interface MYWDViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    TIXingLable *_txLab;
}
@property (strong ,nonatomic)UIButton *HDButton;

@property (strong ,nonatomic)UIButton *seletedButton;

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)UIImageView *imageView;

@property (strong ,nonatomic)NSDictionary *myDic;

@property (strong ,nonatomic)NSArray *XXArray;

@property (strong ,nonatomic)NSArray *questionArray;

@property (strong ,nonatomic)NSArray *answerArray;

@property (strong ,nonatomic)NSString *titleStr;//用来标示我的问题 还是我的回答

@end

@implementation MYWDViewController

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
    [self addtitleView];
    [self addTableView];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _titleStr = @"1";
    
}

- (void)addtitleView {
    
    UIView *WZView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 48)];
    WZView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:WZView];
    
    //添加按钮
    NSArray *titleArray = @[@"我的问题",@"我的回答"];
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [[UIButton alloc] init];
        if (i == 0) {
            button.frame = CGRectMake(0, 8, MainScreenWidth / 2, 30);
        }else {
            button.frame = CGRectMake(MainScreenWidth / 2 , 8, MainScreenWidth / 2 , 30);
        }
        button.tag = i;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(WZButton:) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"%@",NSStringFromCGRect(button.frame));
        [WZView addSubview:button];
        if (i == 0) {
            [self WZButton:button];
        }
        
    }
    
    //添加横线
    _HDButton = [[UIButton alloc] initWithFrame:CGRectMake((MainScreenWidth / 2 - 60) / 2, 38, 60, 1)];
    _HDButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [WZView addSubview:_HDButton];
    

}

- (void)WZButton:(UIButton *)button {
    
    self.seletedButton.selected = NO;
    button.selected = YES;
    self.seletedButton = button;
    
    if (button.tag == 0) {//我的问题

        [self netWorkMYQ];
        //设置滑块的动画
        [UIView animateWithDuration:0.1 animations:^{
            _HDButton.frame = CGRectMake((MainScreenWidth / 2 - 60) / 2, 38, 60, 1);
        }];
        
        _titleStr = @"1";
        
    }else {//我的回答

        _titleStr = @"2";
        [self netWorkMYH];
        //设置滑块的动画
        [UIView animateWithDuration:0.1 animations:^{
            _HDButton.frame = CGRectMake(MainScreenWidth / 2 + (MainScreenWidth / 2 - 60) / 2, 38, 60, 1);
        }];
    }
}


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"我的问答";
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

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 48 , MainScreenWidth, MainScreenHeight - 98 + 23) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 95;
    [self.view addSubview:_tableView];
    _txLab = [[TIXingLable alloc]initWithFrame:CGRectMake(0, 100*MainScreenHeight/667, MainScreenWidth, 30)];
    _txLab.textColor = [UIColor clearColor];
    [self.tableView insertSubview:_txLab atIndex:0];
    //添加刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [_tableView headerBeginRefreshing];
    
    //上拉加载
//    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
   
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,8,0,0)];
    }
    
    //设置表格分割线的长度（跟两边的距离）
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,2,0,0)];
    }

}

- (void)headerRerefreshing
{

    if ([_titleStr integerValue] == 1) {//我的问题
        [self netWorkMYQ];
    } else {//我的回答
        [self netWorkMYH];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        if (_XXArray.count==0) {
            _txLab.textColor = [UIColor colorWithHexString:@"#dedede"];
        }else
            _txLab.textColor = [UIColor clearColor];
        
    });
    
    
}

#pragma mark --- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"---%ld",_XXArray.count);
    if (_XXArray == nil) {
        return 0;
    }
    return _XXArray.count;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    MYWDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MYWDTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    cell.titleLabel.text = _XXArray[indexPath.row][@"wd_description"];
    cell.timeLabel.text =  _XXArray[indexPath.row][@"ctime"];
    cell.personLabel.text = [NSString stringWithFormat:@"%@人回答",_XXArray[indexPath.row][@"wd_comment_count"]];
    
    return cell;
}


- (void)netWorkMYQ {//我的问题
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic =  [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    [manager MYQestion:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"^^^^^%@",responseObject);
        _XXArray = responseObject[@"data"];
        _questionArray = responseObject[@"data"];
        
        if (_XXArray.count == 0) {//没有内容的时候
            //添加空白处理
            
            if (_imageView.subviews == nil) {//说明是没有的
                _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 98)];
                _imageView.image = [UIImage imageNamed:@"问答-问题@2x"];
            } else {//已经存在了
                _imageView.image = [UIImage imageNamed:@"问答-问题@2x"];
            }

            [_tableView addSubview:_imageView];
            _imageView.hidden = NO;
            
            
        } else {
            _imageView.hidden = YES;
            self.tableView.alpha = 1.0;
            _imageView.hidden = YES;
            
            [self.tableView reloadData];
        }
         [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog ( @"operation1: %@" , operation. responseString);
        _XXArray = _questionArray;
        [self.tableView reloadData];
    }];
    

    
}

- (void)netWorkMYH {//我的回答
    
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic =  [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    [manager MYAnsder:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"^^^^^%@",responseObject);
        _XXArray = responseObject[@"data"];
        _answerArray = responseObject[@"data"];
        NSLog(@"%@",responseObject[@"msg"]);
        
//        if (myAnswerArray.count) {
//            
//        } else {
//            [myAnswer saveBJes:_answerArray];
//        }
        
        if (_XXArray.count == 0) {//没有内容的时候
            //添加空白处理
            
            if (_imageView.subviews == nil) {//说明是没有的
                _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 98)];
                _imageView.image = [UIImage imageNamed:@"问答-回答@2x"];
            } else {//已经存在了
                _imageView.image = [UIImage imageNamed:@"问答-回答@2x"];
            }
            
            [_tableView addSubview:_imageView];
            _imageView.hidden = NO;
            
            
        } else {
            self.tableView.alpha = 1.0;
            _imageView.hidden = YES;
            _imageView.alpha = 0;
            [_imageView removeFromSuperview];
            [_imageView removeFromSuperview];
            
            [self.tableView reloadData];
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"加载失败" toView:self.view];
        _XXArray = _answerArray;
        [self.tableView reloadData];
    }];

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

//    //这里需要取出自己的头像和名字
    NSString *Name = _XXArray[indexPath.row][@"uname"];
    NSString *Face = _XXArray[indexPath.row][@"userface"];
    NSString *CTime = _XXArray[indexPath.row][@"ctime"];
    NSString *ID = _XXArray[indexPath.row][@"id"];
    NSString *qstDescription = _XXArray[indexPath.row][@"wd_description"];

    SYGWDViewController *SYGVC = [[SYGWDViewController alloc] initWithQuizID:ID title:nil description:qstDescription uname:Name userface:Face ctime:CTime];
    [self.navigationController pushViewController:SYGVC animated:YES];
    

}



@end
