//
//  KCViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 15/12/30.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "KCViewController.h"
#import "MyTableViewController.h"
#import "MyViewController.h"
#import "UIButton+WebCache.h"
#import "CourseCell.h"
#import "msgViewController.h"
#import "settingViewController.h"
#import "MyShoppingCarViewController.h"
#import "CourseViewController.h"
#import "QuestionsAndAnswersViewController.h"
#import "NoteViewController.h"
#import "AttentionViewController.h"
#import "MyMsgViewController.h"
#import "receiveCommandViewController.h"
#import "FansViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "Passport.h"
#import "CData.h"
#import "MJRefresh.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "questionViewController.h"
#import "NoteViewController.h"
#import "UIImage+WebP.h"
#import "MyBuyCell.h"
#import "classDetailVC.h"
#import "teacherList.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYGClassTableViewCell.h"
#import "BuyClass.h"
#import "SYG.h"
#import "UIColor+HTMLColors.h"
#import "TIXingLable.h"
#import "MBProgressHUD+Add.h"
#import "ClassRevampCell.h"


@interface KCViewController ()<UITableViewDataSource,UITableViewDelegate>


{
    NSInteger _number;
    CGRect rect;
    TIXingLable *_txLab;
}

@property (strong ,nonatomic)NSMutableArray *dataArray;

@end

@implementation KCViewController


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
    
    [self initer];
    [self titleSet];
    [self addNav];
}

- (void)initer {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的课程";
    
    rect = [UIScreen mainScreen].applicationFrame;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, MainScreenWidth, MainScreenHeight + 20 + 10 + 5) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:237.0/255.0 alpha:1];
    self.tableView.userInteractionEnabled = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 110;
    self.dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    [self.view addSubview:self.tableView];
    _txLab = [[TIXingLable alloc]initWithFrame:CGRectMake(0, 50*MainScreenHeight/667, MainScreenWidth, 30)];
    _txLab.textColor = [UIColor clearColor];
    [self.tableView insertSubview:_txLab atIndex:0];
    //下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [self.tableView headerBeginRefreshing];
    
    
    //设置表格分割线的长度（跟两边的距离）
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,2,0,0)];
    }
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
    WZLabel.text = @"我的课程";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)titleSet {
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:44.f / 255 green:132.f / 255 blue:214.f / 255 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
}

- (void)headerRerefreshing
{
    [self reloadData:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        if ([_dataArray isEqual:[NSNull null]])  {
            
            _txLab.textColor = [UIColor colorWithHexString:@"#dedede"];
        
        }else{
            
            _txLab.textColor = [UIColor clearColor];
        }
    });
}

- (void)footerRefreshing
{
    _number++;
    [self reloadData:_number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
}

#pragma mark ---

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_dataArray isEqual:[NSNull null]]) {
        return 0;
    }else {
        return _dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellStr = @"SYGClassTableViewCell";
    ClassRevampCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[ClassRevampCell alloc] initWithReuseIdentifier:cellStr];
    }
    
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataWithDict:dict withType:@"1"];
    return cell;

}

-(void)reloadData:(NSInteger)number
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)number] forKey:@"page"];
    [dic setObject:@"10" forKey:@"count"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    //取出缓存数据
    NSArray *classArray = [BuyClass classWithDic:dic];
    NSLog(@"------%@",dic);
    
    [manager getClass:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        NSLog(@"%@",operation);
        NSLog(@"66^^^^%@",responseObject);
        _dataArray = responseObject[@"data"];
        NSArray *tempArray = responseObject[@"data"];
        if (classArray.count) {//已经有缓存,不再需要缓存
            
        } else {
            
            if (![_dataArray isEqual:[NSNull null]]) {
                //缓存数据
                [BuyClass saveClasses:responseObject[@"data"]];
            }
        }
        
        if (number == 1) {
            if (![[responseObject objectForKey:@"data"] isEqual:[NSNull null]] && tempArray.count > 0) {
                _dataArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
            } else {
                
                //添加空白处理
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
                imageView.image = [UIImage imageNamed:@"我的课程@2x"];
                [self.view addSubview:imageView];
            }
        } else {
            NSMutableArray *moreArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
            [_dataArray addObject:moreArray];
        }

        [self.tableView reloadData];
        
        if (_dataArray.count != 0) {
            //上拉加载
            [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
            
            if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
                [_tableView setSeparatorInset:UIEdgeInsetsMake(0,5,0,0)];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"加载失败" toView:self.view];
        _dataArray = classArray;
        [_tableView reloadData];
        
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *Cid = _dataArray[indexPath.row][@"id"];
    NSString *Price = _dataArray[indexPath.row][@"price"];
    NSString *Title = _dataArray[indexPath.row][@"video_title"];
    NSString *VideoAddress = _dataArray[indexPath.row][@"video_address"];
    NSString *ImageUrl = _dataArray[indexPath.row][@"imageurl"];
    
    classDetailVC * cvc = [[classDetailVC alloc]initWithMemberId:Cid andPrice:Price andTitle:Title];
    cvc.videoTitle = Title;
    cvc.img = ImageUrl;
    cvc.video_address = VideoAddress;
    [self.navigationController pushViewController:cvc animated:YES];
}

@end
