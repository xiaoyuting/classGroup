//
//  ZXKSViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/29.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "ZXKSViewController.h"
#import "AppDelegate.h"
#import "ZXKSTableViewCell.h"
#import "SYG.h"
#import "SJXQViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "UIButton+WebCache.h"
#import "MJRefresh.h"
#import "TIXingLable.h"
#import "UIColor+HTMLColors.h"
#import "MBProgressHUD+Add.h"


@interface ZXKSViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isSecet;
    TIXingLable *_txLab;
}

@property (strong ,nonatomic)UIView *allView;

@property (strong ,nonatomic)UIButton *allButton;

@property (strong ,nonatomic)UIView *buyView;

@property (strong ,nonatomic)NSArray *SYGArray;

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSString *ID;//记录分类里面的id

@property (strong ,nonatomic)NSMutableArray *dataArray;

@property (assign ,nonatomic)NSInteger number;

@end

@implementation ZXKSViewController

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
    [self addTableView];
    [self NetWorkCate];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    
//    _SYGArray = @[@"全部",@"外语考试",@"公务员考试",@"建筑考试"];
    
    //添加试图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    imageView.image = [UIImage imageNamed:@"在线考试空白@2x"];
    [self.view addSubview:imageView];
    imageView.hidden = NO;
    imageView.hidden = YES;
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
    
    UIButton *SXButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 30, 32, 20, 20)];
    [SXButton setBackgroundImage:[UIImage imageNamed:@"fenleisyg"] forState:UIControlStateNormal];
    [SXButton addTarget:self action:@selector(SXButton) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:SXButton];

    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"在线考试";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 + 38) style:UITableViewStyleGrouped];
    _tableView.rowHeight = 82;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _txLab = [[TIXingLable alloc]initWithFrame:CGRectMake(0, 100*MainScreenHeight/667, MainScreenWidth, 30)];
    [_tableView insertSubview:_txLab atIndex:0];
    //添加刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [_tableView headerBeginRefreshing];
    
    //上拉加载
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
}

- (void)headerRerefreshing
{
    [self AANetWork:nil WithNumber:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        if (_dataArray.count==0) {
            _txLab.textColor = [UIColor colorWithHexString:@"#dedede"];
        }else{
            _txLab.textColor = [UIColor clearColor];
        }
    });
}

- (void)footerRefreshing
{
    _number++;
    [self AANetWork:nil WithNumber:_number];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
}

#pragma mark --- 

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    ZXKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ZXKSTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    cell.titleLabel.text = _dataArray[indexPath.row][@"exam_name"];
    cell.personLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"count"]];
    cell.CJLabel.text = _dataArray[indexPath.row][@"exam_describe"];
    if ([_dataArray[indexPath.row][@"is_test"] integerValue] == 0) {
        cell.CJLabel.text = @"未参加考试";
    } else {
        cell.CJLabel.text = @"已参加考试";
    }
    cell.timeLabel.text = [NSString stringWithFormat:@"考试时长：%@分钟",_dataArray[indexPath.row][@"exam_total_time"]];
    NSString *Str1 = _dataArray[indexPath.row][@"exam_begin_time"];
    NSString *Str2 = _dataArray[indexPath.row][@"exam_end_time"];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@ - %@",Str1,Str2];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //创建通知
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KSTime:) name:@"notificationTime" object:nil];

    
    SJXQViewController *SJXQVC = [[SJXQViewController alloc] init];
    SJXQVC.ID = _dataArray[indexPath.row][@"exam_id"];
    SJXQVC.titleStr = _dataArray[indexPath.row][@"exam_name"];
    SJXQVC.personCount = _dataArray[indexPath.row][@"count"];
    SJXQVC.endTimeStr = _dataArray[indexPath.row][@"exam_end_time"];
    SJXQVC.is_test = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"is_test"]];
    SJXQVC.describe = _dataArray[indexPath.row][@"exam_describe"];
    SJXQVC.pager_id = _dataArray[indexPath.row][@"paper_id"];
    [self.navigationController pushViewController:SJXQVC animated:YES];
    
}
- (void)SXButton {
    
    isSecet = !isSecet;
    
    if (isSecet == YES) {//创建
        
        [self addMoreView];
        
    }else {
        
        //移除
        [self removeMoreView];
    }
}

- (void)addMoreView {
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:_allView];
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
    [_allView addSubview:_allButton];
    
    _buyView = [[UIView alloc] init];
    _buyView.frame = CGRectMake(MainScreenWidth, 64, 100, _SYGArray.count * 40 + 5 * (_SYGArray.count - 1));
    _buyView.backgroundColor = [UIColor colorWithRed:254.f / 255 green:255.f / 255 blue:255.f / 255 alpha:1];
    _buyView.layer.cornerRadius = 3;
    [_allView addSubview:_buyView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(MainScreenWidth - 100, 64, 100, _SYGArray.count * 40 + 5 * (_SYGArray.count - 1));
        //在view上面添加东西
        for (int i = 0 ; i < _SYGArray.count ; i ++) {
            
            UIButton *button = [[UIButton alloc ] initWithFrame:CGRectMake(0, i * 40 + i * 5, 100, 40)];
            [button setTitle:_SYGArray[i][@"exam_category_name"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:64.f / 255 green:64.f / 255 blue:64.f / 255 alpha:1] forState:UIControlStateNormal];
            button.layer.cornerRadius = 5;
            button.tag = [_SYGArray[i][@"exam_category_id"] integerValue];
            [button addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [_buyView addSubview:button];
        }
        
        //添加中间的分割线
        for (int i = 0; i < _SYGArray.count; i ++) {
            UIButton *XButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 43 * i , 100, 1)];
            XButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [_buyView addSubview:XButton];
        }
    }];
}

- (void)removeMoreView {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(MainScreenWidth, 64, 100, _SYGArray.count * 40 + 5 * (_SYGArray.count - 1));
        _allView.alpha = 0;
        _allButton.alpha = 0;
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_buyView removeFromSuperview];
        
    });
}

- (void)miss {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(MainScreenWidth, 64, 100, _SYGArray.count * 40 + 5 * (_SYGArray.count - 1));
        _allView.alpha = 0;
        _allButton.alpha = 0;
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_buyView removeFromSuperview];
        isSecet = NO;
        
    });
}

- (void)SYGButton:(UIButton *)button {
    
    isSecet = NO;
    NSLog(@"%@",button.titleLabel.text);
    [self miss];
    
    //将分类的id传过去
    _ID = [NSString stringWithFormat:@"%ld",button.tag];
    NSLog(@"%@",_ID);

    [self AANetWork:nil WithNumber:1];
    _number = 1;

}
//分类里面的请求
- (void)NetWorkCate {
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [manager KSXTFXFL:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        _SYGArray = responseObject[@"data"];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        [MBProgressHUD showError:@"数据加载失败" toView:self.view];
        
    }];
    
    
}


- (void)AANetWork:(NSString *)string WithNumber:(NSInteger)num {
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if (_ID == nil) {//没有分类
//        [dic setObject:@"2" forKey:@"category_id"];
    }else {//有分类
        [dic setObject:_ID forKey:@"category_id"];
    }
    
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下

        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:[NSNumber numberWithInteger:num] forKey:@"page"];
    [dic setValue:@"10" forKey:@"count"];
    
    NSLog(@"%@",dic);
    
    [manager KSXTTab:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"======  %@",responseObject);
        NSLog(@"%@",operation);
        NSArray *LJArray = responseObject[@"data"];
        if (!LJArray.count) {//没有数据了
            
            if (num == 1) {//说明是第一页就没有数据
                
//                [self imageView];//调用懒加载
//                _imageView.hidden = NO;
//                _imageView.alpha = 1;
//                _dataArray = nil;
//                [_tableView reloadData];
//                return ;
            }
            
        }
        
        if (num == 1) {
            _dataArray = [NSMutableArray arrayWithArray:LJArray];
            
        }else {
            NSArray *SYGArray = [NSArray arrayWithArray:LJArray];
            [_dataArray addObjectsFromArray:SYGArray];
            
        }
        
//        [_imageView removeFromSuperview];
//        _imageView.alpha = 0;
        [_tableView reloadData];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"===== dededede  %@    %@",error,operation. responseString);
        
    }];
    
}





@end
