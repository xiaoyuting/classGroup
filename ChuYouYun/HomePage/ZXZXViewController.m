//
//  ZXZXViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/24.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width


#import "ZXZXViewController.h"
#import "AppDelegate.h"
#import "ZhiyiHTTPRequest.h"
#import "ZXZXTableViewCell.h"
#import "ZXDTViewController.h"
#import "UIButton+WebCache.h"
#import "Passport.h"
#import "MJRefresh.h"
#import "ZiXunFL.h"
#import "TIXingLable.h"
#import "UIColor+HTMLColors.h"
#import "GLReachabilityView.h"
#import "MBProgressHUD+Add.h"
#import "MyHttpRequest.h"

@interface ZXZXViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    BOOL isSecet;
    TIXingLable *_txlab;
}
@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)UIButton *seletedButton;

@property (strong ,nonatomic)NSMutableArray *dataArray;

@property (assign ,nonatomic)NSInteger number;

@property (strong ,nonatomic)NSString *typeStr;

@property (strong ,nonatomic)UIView *allView;

@property (strong ,nonatomic)UIButton *allButton;

@property (strong ,nonatomic)UIView *buyView;

@property (strong ,nonatomic)NSArray *SYGArray;

@property (strong ,nonatomic)UIButton *HDButton;

@property (strong ,nonatomic)UIImageView *imageView;

@end

@implementation ZXZXViewController

-(UIImageView *)imageView {
    if (!_imageView) {
        [self addImageView];
    }
    return _imageView;
}


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
    [self addWZView];
    [self NetWork];
    
}

- (void)interFace {
    
    isSecet = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 34 - 20, MainScreenWidth, MainScreenHeight - 98 + 98 + 8) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 110;
    [self.view addSubview:_tableView];
    _txlab = [[TIXingLable alloc]initWithFrame:CGRectMake(0,200,MainScreenWidth, 30)];
    [_tableView insertSubview:_txlab atIndex:0];
    //_txlab.font = [UIFont systemFontOfSize:14];
    //_txlab.textColor = [UIColor clearColor];
    //_txlab.text = @"数据为空，刷新重试";
    //添加刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [_tableView headerBeginRefreshing];

    //上拉加载
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,5,0,0)];
    }
    
    //设置表格分割线的长度（跟两边的距离）
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,2,0,0)];
    }

    
}

- (void)headerRerefreshing
{
//    [self NetWork:_typeStr WithNumber:1];
    [self AANetWork:_typeStr WithNumber:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        if (_dataArray.count==0) {
            _txlab.textColor = [UIColor colorWithHexString:@"#dedede"];
        }else{
    
            _txlab.textColor = [UIColor clearColor];
        }
    });
    
    
}


- (void)footerRefreshing
{
    
    _number++;
//    [self NetWork:_typeStr WithNumber:_number];
    [self AANetWork:_typeStr WithNumber:_number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });

}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"资讯";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 80, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,66)];
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
    
    UIButton *SXButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 40, 32, 40, 20)];
    [SXButton setBackgroundImage:[UIImage imageNamed:@"问答分类@2x"] forState:UIControlStateNormal];
    [SXButton addTarget:self action:@selector(SXButton) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:SXButton];
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addWZView {
    UIView *WZView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 34)];
    WZView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:WZView];
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [self.view addSubview:lineLab];
    //添加按钮
    NSArray *titleArray = @[@"最新",@"热门"];
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [[UIButton alloc] init];
        if (i == 0) {
            button.frame = CGRectMake(MainScreenWidth / 2 - 30 - 45, 7, 35, 20);
        }else {
            button.frame = CGRectMake(MainScreenWidth / 2 + 45, 7, 30, 20);
        }
        button.tag = i;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor colorWithRed:89.f / 255 green:89.f / 255 blue:89.f / 255 alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [button addTarget:self action:@selector(WZButton:) forControlEvents:UIControlEventTouchUpInside];
        [WZView addSubview:button];
        if (i == 0) {
            [self WZButton:button];
        }
    }
    //添加横线
    _HDButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 30 - 45, 27 + 3, 30, 1)];
    _HDButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [WZView addSubview:_HDButton];
}

- (void)WZButton:(UIButton *)button {

    self.seletedButton.selected = NO;
    button.selected = YES;
    self.seletedButton = button;
    
    if (button.tag == 0) {//最新资讯
        _typeStr = @"1";
        [self NetWork:_typeStr WithNumber:1];
        _number = 1;//将page 置为1,不然切换之后的page 还是之前的页数
        
        //设置滑块的动画
        [UIView animateWithDuration:0.25 animations:^{
            _HDButton.frame = CGRectMake(MainScreenWidth / 2 - 30 - 45, 27 + 3, 30, 1);
        }];

    }else {//最热资讯
        _typeStr = @"2";
        [self NetWork:_typeStr WithNumber:1];
        _number = 1;
        
        //设置滑块的动画
        [UIView animateWithDuration:0.25 animations:^{
            _HDButton.frame = CGRectMake(MainScreenWidth / 2 + 45, 27 + 3, 30, 1);
        }];
    }
}

- (void)SXButton {
    isSecet = !isSecet;
    
    if (isSecet == YES) {//创建
        [self addMoreView];
    }else {//移除
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
            [button setTitle:_SYGArray[i][@"title"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:64.f / 255 green:64.f / 255 blue:64.f / 255 alpha:1] forState:UIControlStateNormal];
            button.layer.cornerRadius = 5;
            button.tag = [_SYGArray[i][@"zy_topic_category_id"] integerValue];
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
    NSLog(@"SYG%@",_typeStr);
    [self NetWork:_typeStr WithNumber:1];
    _number = 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    ZXZXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ZXZXTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }

    [cell.imageButton setBackgroundImage:[UIImage imageNamed:@"站位图"] forState:UIControlStateNormal];
    [cell.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_dataArray[indexPath.row][@"image"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"站位图"]];
    cell.titleLabel.text = _dataArray[indexPath.row][@"title"];
    NSString *readStr = [NSString stringWithFormat:@"阅读：%@",_dataArray[indexPath.row][@"readcount"]];
    cell.readLabel.text = readStr;
    cell.timeLabel.text = _dataArray[indexPath.row][@"dateline"];
    cell.JTLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"desc"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZXDTViewController *ZXDTVC = [[ZXDTViewController alloc] init];
    [self.navigationController pushViewController:ZXDTVC animated:YES];
    ZXDTVC.titleStr = _dataArray[indexPath.row][@"title"];
    ZXDTVC.timeStr = _dataArray[indexPath.row][@"dateline"];
    ZXDTVC.readStr = _dataArray[indexPath.row][@"readcount"];
    ZXDTVC.ZYStr = _dataArray[indexPath.row][@"desc"];
    ZXDTVC.GDStr = _dataArray[indexPath.row][@"text"];
    ZXDTVC.ID = _dataArray[indexPath.row][@"id"];
}

- (void)NetWork:(NSString *)string WithNumber:(NSInteger)num {
    QKHTTPManager *manager = [QKHTTPManager manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:string forKey:@"order"];
    if (_ID == nil) {//没有分类
        
    }else {//有分类
        [dic setObject:_ID forKey:@"cid"];
    }

    [dic setValue:[NSNumber numberWithInteger:num] forKey:@"page"];
    [dic setValue:@"10" forKey:@"count"];

    [manager getpublicPort:dic mod:@"News" act:@"getList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
 
         NSLog(@"======  %@",responseObject);

         NSArray *LJArray = responseObject[@"data"];
         if (!LJArray.count) {//没有数据了
             
             if (num == 1) {//说明是第一页就没有数据

                 [self imageView];//调用懒加载
                 _imageView.hidden = NO;
                 _imageView.alpha = 1;
                 _dataArray = nil;
                 [_tableView reloadData];
                return ;
             }
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有更多数据了" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
             [alert show];
             [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alert repeats:YES];
             return ;
         }
         
         if (num == 1) {
             _dataArray = [NSMutableArray arrayWithArray:LJArray];
             
         }else {
             NSArray *SYGArray = [NSArray arrayWithArray:LJArray];
             [_dataArray addObjectsFromArray:SYGArray];
         }
         
         [_imageView removeFromSuperview];
         _imageView.alpha = 0;
         [_tableView reloadData];
        
     } failure:^(AFHTTPRequestOperation *operation, NSError *error){
         NSLog(@"===== dededede  %@    %@",error,operation. responseString);
         
     }];
}

//分类里面的请求
- (void)NetWork {
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    NSArray *FLArray = [ZiXunFL BJWithDic:dic];
    
    [manager FXFL:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",operation);
        _SYGArray = responseObject[@"data"];
        
        if (FLArray.count) {//不需要
            
        } else {//需要
            [ZiXunFL saveBJes:_SYGArray];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"数据加载失败" toView:self.view];
        _SYGArray = FLArray;
        
    }];
}

//移除警告框
- (void)removeAlert:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}

- (void)addImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 98, MainScreenWidth, MainScreenHeight - 98)];
    imageView.image = [UIImage imageNamed:@"资讯@2x"];
    imageView.tag = 100;
    [self.view addSubview:imageView];
    _imageView = imageView;

}

- (void)AANetWork:(NSString *)string WithNumber:(NSInteger)num {
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];

    [dic setObject:[NSString stringWithFormat:@"%@",string] forKey:@"order"];
    if (_ID == nil) {//没有分类
        
    }else {//有分类
        [dic setObject:_ID forKey:@"cid"];
    }
    
    [dic setValue:[NSNumber numberWithInteger:num] forKey:@"page"];
    [dic setValue:@"10" forKey:@"count"];
        
    [manager SYGZX:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"======  %@",responseObject);
        
        NSArray *LJArray = responseObject[@"data"];
        if (!LJArray.count) {//没有数据了
            if (num == 1) {//说明是第一页就没有数据
                [self imageView];//调用懒加载
                _imageView.hidden = NO;
                _imageView.alpha = 1;
                _dataArray = nil;
                [_tableView reloadData];
                return ;
            }
        }
        
        if (num == 1) {
            
            _dataArray = [NSMutableArray arrayWithArray:LJArray];
            
        }else {
            
            NSArray *SYGArray = [NSArray arrayWithArray:LJArray];
            [_dataArray addObjectsFromArray:SYGArray];
        }
        
        [_imageView removeFromSuperview];
        _imageView.alpha = 0;
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
         NSLog(@"===== dededede  %@    %@",error,operation. responseString);
    }];
}

@end
