//
//  AttentionViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/31.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "AttentionViewController.h"
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

@interface AttentionViewController ()
{
    BOOL isAttention;
    BOOL isAttentionType;
    CGRect rect;
}
@end

@implementation AttentionViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
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
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 12, 22)];
    [backButton setImage:[UIImage imageNamed:@"iconfont-FH"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"关注";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNav];
    rect = [UIScreen mainScreen].applicationFrame;
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"关注";
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight)];
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.muArr = [[NSMutableArray alloc]initWithCapacity:0];
    isAttentionType = YES;
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
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {
            self.tableView.alpha = 0;
            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake((rect.size.width-200)/2, 70, 200, 21)];
            lbl.font = [UIFont systemFontOfSize:16];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.text = @"还没有关注，快去逛逛吧~";
            lbl.textColor = [UIColor colorWithRed:36.0/255.0 green:102.0/255.0 blue:167.0/255.0 alpha:1];
            [self.view addSubview:lbl];

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
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"关注成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
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
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"取消关注成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
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
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Cell";
    AttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"AttentionCell" owner:nil options:nil];
        cell = [cellArr objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.headIMG.clipsToBounds = YES;
        cell.headIMG.layer.cornerRadius = 25.0;
        }
    ATData *adt = [self.muArr objectAtIndex:indexPath.row];
    cell.userText.numberOfLines = 0;
    
    [cell.headIMG sd_setImageWithURL:[NSURL URLWithString:adt.avatarSmall] placeholderImage:nil];
    cell.headIMG.userInteractionEnabled = YES;
    
    //判断是否关注
    if ([_arr[indexPath.row][@"follow_state"][@"follower"] integerValue] == 1 && [_arr[indexPath.row][@"follow_state"][@"following"] integerValue] == 1) { //说明都是1 为互相关注
        [cell.attentionType setBackgroundImage:[UIImage imageNamed:@"Shape273.png"] forState:UIControlStateNormal];
    
    } else {//不是互相关注的时候
        [cell.attentionType setBackgroundImage:[UIImage imageNamed:@"Shape272.png"] forState:UIControlStateNormal];
    }
    
    cell.attentionType.enabled = NO;
    [cell.attentionType addTarget:self action: @selector(addtentionClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.attentionType.tag = indexPath.row;
    
    
    cell.userName.text = adt.uname;
    cell.userText.text = @"PHP太懒,什么都没留下";

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        SendMSGToChatViewController *c = [[SendMSGToChatViewController alloc]initWithChatUserid:nil uFace:ad.avatarSmall toUserID:nil sendToID:ad.uid];
        [self.navigationController pushViewController:c animated:YES];
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
