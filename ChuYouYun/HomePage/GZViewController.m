//
//  GZViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/15.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "GZViewController.h"
#import "AttentionCell.h"
#import "UIButton+WebCache.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "MyUIButton.h"
#import "ZhiyiHTTPRequest.h"
#import "UIImageView+WebCache.h"
#import "ATData.h"
#import "MJRefresh.h"
#import "SendMSGToChatViewController.h"
#import "GZTableViewCell.h"
#import "MessageSendViewController.h"
#import "SYG.h"

@interface GZViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    BOOL isAttention;
    BOOL isAttentionType;
    CGRect rect;
}

@property (strong ,nonatomic)UITableView *tableView;

@end

@implementation GZViewController

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
    WZLabel.text = @"关注";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNav];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 + 36) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    self.muArr = [[NSMutableArray alloc]initWithCapacity:0];
    isAttentionType = YES;
//    [self reloadAttentions];
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [_tableView headerBeginRefreshing];
    
    //关注标志
    
    
}


- (void)headerRerefreshing
{
    [self reloadAttentions];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
}
-(void)reloadAttentions
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [manager userAttentions:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"11%@",responseObject);
        NSLog(@"---%@",responseObject[@"msg"]);
        NSArray *SYGArray = responseObject[@"data"];
        if (!SYGArray.count) {
            self.tableView.alpha = 0;
            
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
            imageView.image = [UIImage imageNamed:@"关注@2x"];
            [self.view addSubview:imageView];

            
        } else
        {
            _arr = [responseObject objectForKey:@"data"];
            NSMutableArray *uArr = [[NSMutableArray alloc]initWithCapacity:0];
            for (int i = 0; i<_arr.count; i++) {
                ATData *atd = [[ATData alloc]initWithDictionary:[_arr objectAtIndex:i]];
                [uArr addObject:atd];
            }
            self.muArr=[NSMutableArray arrayWithArray:uArr];
            [self.tableView reloadData];
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error   %@",error);
    }];
}

//关注其他用户
-(void)attention
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    ATData *atd = [[ATData alloc]init];
    atd = [self.muArr objectAtIndex:self.row];
    [dic setObject:atd.uid forKey:@"user_id"];
    [manager userAttention:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *msg = [responseObject objectForKey:@"msg"];
        
        if ([msg isEqual:@"ok"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"关注成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
-(void)cancelAttention
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    ATData *atd = [[ATData alloc]init];
    atd = [self.muArr objectAtIndex:self.row];
    [dic setObject:atd.uid forKey:@"user_id"];
    [manager cancelUserAttention:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"99%@",responseObject);
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([msg isEqual:@"ok"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"取消关注成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];

            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.muArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ATData *adt = [self.muArr objectAtIndex:indexPath.row];

    static NSString *CellIdentifier = @"SYGBJTableViewCell";
    //自定义cell类
    GZTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GZTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    [cell.HeadImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:adt.avatarSmall] forState:UIControlStateNormal];
    cell.NameLabel.text = adt.uname;
    NSLog(@"----%@",adt.intro);
    if ([adt.intro isEqual:[NSNull null]] || adt.intro == nil) {
        cell.TextLabel.text = @"PHP太懒,什么都没留下";
    }else {
        cell.TextLabel.text = adt.intro;
    }

    //判断是否关注
    if ([_arr[indexPath.row][@"follow_state"][@"follower"] integerValue] == 1 && [_arr[indexPath.row][@"follow_state"][@"following"] integerValue] == 1) { //说明都是1 为互相关注
        [cell.GZButton setBackgroundImage:[UIImage imageNamed:@"相互关注@2x"] forState:UIControlStateNormal];
    } else {//不是互相关注的时候
        [cell.GZButton setBackgroundImage:[UIImage imageNamed:@"关注别人@2x"] forState:UIControlStateNormal];
    }

    cell.GZButton.enabled = NO;
    [cell.GZButton addTarget:self action: @selector(addtentionClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.GZButton.tag = indexPath.row;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    ATData *adt = [self.muArr objectAtIndex:indexPath.row];
    NSDictionary *attentionType = adt.followState;
    isAttention = [[attentionType objectForKey:@"follower"] integerValue];
    
    self.row = indexPath.row;
    NSString *str;
    if (isAttention == YES) {
        str = @"取消关注";
    }else
    {
        str = @"取消关注";
    }
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"私信" otherButtonTitles:str, nil];
    action.delegate = self;
    [action showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ATData *ad = [[ATData alloc]init];
    ad = [self.muArr objectAtIndex:self.row];
    if (buttonIndex == 0)
    {
        
        MessageSendViewController *MSVC = [[MessageSendViewController alloc] init];
        MSVC.TID = ad.uid;
        MSVC.name = ad.uname;
        [self.navigationController pushViewController:MSVC animated:YES];

        
        
    }else if (buttonIndex == 1)
    {
        NSMutableDictionary *followStateDic = [NSMutableDictionary dictionaryWithDictionary:ad.followState];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.row inSection:0];
        AttentionCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        isAttention = [[followStateDic objectForKey:@"follower"] integerValue];
        
        ad.followState = nil;
        [followStateDic setValue:@"1" forKey:@"follower"];
        ad.followState = followStateDic;
        [_muArr replaceObjectAtIndex:self.row withObject:ad];
        
        [cell setAttentionType:1 following:[[followStateDic objectForKey:@"following"] integerValue] isSelf:NO];
        //            [self attention];
        [self cancelAttention];
        
        //删除关注列表里面的cell
        [self.muArr removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSIndexSet * set =[NSIndexSet indexSetWithIndex:indexPath.section];
        //NSIndexSet－－索引集合
        [_tableView reloadSections:set withRowAnimation:UITableViewRowAnimationBottom];
        
        
        
        
        
    }
}

-(void)headClick:(UIButton *)btn
{
    
}
-(void)addtentionClick:(MyUIButton*)btn
{
    //    AttentionCell *cell = (AttentionCell *)[[[btn superview]superview] superview];
    //    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    BOOL pressed = YES;
    [btn setIsPressed:pressed];
}

- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}


@end
