//
//  SystemViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/31.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "SystemViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SystemTextViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "Passport.h"
#import "SMBaseClass.h"
#import "SMsgCell.h"
#import "XTTableViewCell.h"
#import "GLReachabilityView.h"
#import "SYG.h"

@interface SystemViewController ()
{
    CGRect rect;
}
@property (strong ,nonatomic)NSArray *dataArray;
@property (strong ,nonatomic)NSMutableArray *readArray;//是否已读

@end

@implementation SystemViewController
-(void)viewWillAppear:(BOOL)animated
{
    rect = [UIScreen mainScreen].applicationFrame;
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
    _readArray = [NSMutableArray array];
    self.navigationItem.title = @"系统消息";
    self.tableView.showsVerticalScrollIndicator = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,MainScreenWidth, MainScreenHeight - 64 + 20 + 20 + 10) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,15,0,0)];
    }
    
    //设置表格分割线的长度（跟两边的距离）
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,2,0,0)];
    }

    
    [self reloadMsg];
    [self addNav];
    
}


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    //刷新按钮
    UIButton *frashButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth-55, 20, 40, 40)];
    [frashButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [frashButton setTitle:@"刷新" forState:UIControlStateNormal];
    [frashButton addTarget:self action:@selector(frash) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:frashButton];
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"系统消息";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
}
-(void)frash{
    
    if (self.muArr.count==0) {
        if ([GLReachabilityView isConnectionAvailable]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"刷新成功请稍后" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFireMethod:) userInfo:alertView repeats:YES];

        }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请查看网络连接" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFireMethod:) userInfo:alertView repeats:YES];

        }
        [self reloadMsg];
        [self.tableView reloadData];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"数据已经最新，无需刷新" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];

        [alertView show];
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alertView repeats:YES];
        
    }
    //
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Edit" message:@"Please Modify the Info" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sure", @"Other", nil];
    //    [alertView show];
    return;
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}


-(void)reloadMsg
{
    self.muArr = [[NSMutableArray alloc]initWithCapacity:0];
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic  =[[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
     [dic setObject:@"1" forKey:@"page"];
    [dic setObject:@"10" forKey:@"count"];
    [manager systemMsg:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"^^^^^^%@",responseObject);
        _dataArray = responseObject[@"data"];
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {
            self.tableView.alpha = 0;
            
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
            imageView.image = [UIImage imageNamed:@"我的消息@2x"];
            [self.view addSubview:imageView];
            
            
        } else {
            NSArray *dataArr = [responseObject objectForKey:@"data"];
            for (int i = 0; i<dataArr.count; i++) {
                NSDictionary *dic = [dataArr objectAtIndex:i];
                SMBaseClass *sm = [[SMBaseClass alloc]initWithDictionary:dic];
                [self.muArr addObject:sm];
                
                //添加已读的信息
                NSString *is_read = dataArr[i][@"is_read"];
                [_readArray addObject:is_read];
            }
        }
       
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.muArr.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    //指定cellIdentifier为自定义的cell
    static NSString *CellIdentifier = @"SYGBJTableViewCell";
    //自定义cell类
    XTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[XTTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    [cell setIntroductionText:_dataArray[indexPath.row][@"body"]];
    cell.timeLabel.text = [Passport formatterDate:_dataArray[indexPath.row][@"ctime"]];
    
    if ([_readArray[indexPath.row] isEqualToString:@"1"]) {
        cell.TXButton.hidden = YES;
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_readArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
    [_tableView reloadData];
}




@end
