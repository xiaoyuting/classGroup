//
//  SYGBJViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/4.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "SYGBJViewController.h"
#import "NoteTableViewCell.h"
#import "NoteDetailsViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "NBaseClass.h"
#import "SBaseClass.h"
#import "UIButton+WebCache.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "MJRefresh.h"
#import "noteVC.h"
#import "NoteDetailsViewController.h"
#import "SYGBJTableViewCell.h"
#import "Passport.h"
#import "BJXQViewController.h"
#import "myBJ.h"
#import "SYG.h"
#import "UIColor+HTMLColors.h"
#import "TIXingLable.h"
#import "MBProgressHUD+Add.h"


@interface SYGBJViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    TIXingLable *_txLab;

}
@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSArray *dataArray;

@end

@implementation SYGBJViewController

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
    [self addNav];
    [self addTableView];
    [self reloadData];
}

- (void)initer {
    self.view.backgroundColor = [UIColor whiteColor];
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
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"我的笔记";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
}

- (void)addTableView {
    self.automaticallyAdjustsScrollViewInsets = false;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 24) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [_tableView headerBeginRefreshing];
    _txLab = [[TIXingLable alloc]initWithFrame:CGRectMake(0, 100*MainScreenHeight/667, MainScreenWidth, 30)];
    _txLab.textColor = [UIColor clearColor];
    [self.tableView insertSubview:_txLab atIndex:0];
}

- (void)headerRerefreshing
{
    [self reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
    
}


- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)reloadData
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];

    NSArray *BJArray = [myBJ BJWithDic:dic];
    [manager reloadNoteTitle:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
         _dataArray = responseObject[@"data"];
        if (BJArray.count) {
        } else {
            if (![_dataArray isEqual:[NSNull null]]) {
                //缓存数据
              [myBJ saveBJes:responseObject[@"data"]];
            }
        }
        
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {
            
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
            imageView.image = [UIImage imageNamed:@"我的笔记@2x"];
            [self.view addSubview:imageView];
            
        } else {
            _dataArray = responseObject[@"data"];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"加载失败" toView:self.view];
        _dataArray = BJArray;
        [_tableView reloadData];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height + 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if ([_dataArray isEqual:[NSNull null]]) {
        return 0;
    } else {
         return self.dataArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定cellIdentifier为自定义的cell
    static NSString *CellIdentifier = @"SYGBJTableViewCell";
    //自定义cell类
    SYGBJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SYGBJTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
//    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.BTLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"note_title"]];
    cell.SJLabel.text = _dataArray[indexPath.row][@"strtime"];
    [cell setIntroductionText:_dataArray[indexPath.row][@"note_description"]];
    cell.PLLabel.text = _dataArray[indexPath.row][@"note_comment_count"];
    cell.DZLabel.text = _dataArray[indexPath.row][@"note_help_count"];
    cell.LZLabel.text = [NSString stringWithFormat:@"源自:%@",_dataArray[indexPath.row][@"video_title"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BJXQViewController *BJXQVC = [[BJXQViewController alloc] init];
    [self.navigationController pushViewController:BJXQVC animated:YES];
    BJXQVC.headStr = _dataArray[indexPath.row][@"userface"];
    BJXQVC.nameStr = _dataArray[indexPath.row][@"uname"];
    BJXQVC.timeStr = _dataArray[indexPath.row][@"strtime"];
    BJXQVC.isOpen = _dataArray[indexPath.row][@"is_open"];
    BJXQVC.JTStr = _dataArray[indexPath.row][@"note_description"];
    BJXQVC.titleStr = _dataArray[indexPath.row][@"note_title"];
    BJXQVC.ID = _dataArray[indexPath.row][@"id"];
    
}



@end
