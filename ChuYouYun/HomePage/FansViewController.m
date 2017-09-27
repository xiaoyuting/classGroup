//
//  FansViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/3.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "FansViewController.h"
#import "AttentionCell.h"
#import "MyUIButton.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "UIButton+WebCache.h"
#import "SendMSGToChatViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "ATData.h"

@interface FansViewController ()
{
    BOOL isAttention;
    BOOL isAttentionType;
    CGRect rect;
}
@end

@implementation FansViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的粉丝";
    rect = [UIScreen mainScreen].applicationFrame;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.muArr = [[NSMutableArray alloc]initWithCapacity:0];
    isAttentionType = YES;
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [_tableView headerBeginRefreshing];
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
    [manager userFans:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {
            self.tableView.alpha = 0;
            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake((rect.size.width-200)/2, 70, 200, 21)];
            lbl.font = [UIFont systemFontOfSize:16];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.text = @"还没有粉丝，快去逛逛吧~";
            lbl.textColor = [UIColor colorWithRed:36.0/255.0 green:102.0/255.0 blue:167.0/255.0 alpha:1];
            [self.view addSubview:lbl];

        } else {
            NSArray *arr = [responseObject objectForKey:@"data"];
            NSMutableArray *uArr = [[NSMutableArray alloc]initWithCapacity:0];
            for (int i = 0; i<arr.count; i++) {
                ATData *atd = [[ATData alloc]initWithDictionary:[arr objectAtIndex:i]];
                [uArr addObject:atd];
            }
            self.muArr=[NSMutableArray arrayWithArray:uArr];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error   %@",error);
    }];
}
-(void)attention
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];

    [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    ATData *atd = [[ATData alloc]init];
    atd = [self.muArr objectAtIndex:self.row];
    [dic setObject:atd.uid forKey:@"user_id"];
    [manager attention:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([msg isEqual:@"ok"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"已关注" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
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
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([msg isEqual:@"ok"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"取消关注成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
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
    ATData *adt = [[ATData alloc]init];
    adt = [self.muArr objectAtIndex:indexPath.row];
    NSDictionary *attentionType = adt.followState;
    
    [cell setAttentionType:[[attentionType objectForKey:@"follower"] integerValue] following:[[attentionType objectForKey:@"following"] integerValue] isSelf:NO];
    
    cell.userText.numberOfLines = 0;
    
    [cell.headIMG sd_setImageWithURL:[NSURL URLWithString:adt.avatarSmall] placeholderImage:nil];
    cell.headIMG.userInteractionEnabled = YES;
    cell.attentionType.enabled = NO;

    [cell.attentionType addTarget:self action: @selector(addtentionClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.attentionType.tag = indexPath.row;
    cell.userName.text = adt.uname;
    cell.userText.text =@"adt.intro";
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ATData *adt = [[ATData alloc]init];
    adt = [self.muArr objectAtIndex:indexPath.row];
    NSDictionary *attentionType = adt.followState;
    isAttention = [[attentionType objectForKey:@"following"] integerValue];
    
    self.row = indexPath.row;
    NSString *str;
    if (isAttention == YES) {
        str = @"取消关注";
    }else
    {
        str = @"关注";
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
        isAttention = [[followStateDic objectForKey:@"following"] integerValue];
        if (isAttention == NO) {
            ad.followState = nil;
            [followStateDic setValue:@"1" forKey:@"following"];
            ad.followState = followStateDic;
            [_muArr replaceObjectAtIndex:self.row withObject:ad];
            
            [cell setAttentionType:1 following:[[followStateDic objectForKey:@"following"] integerValue] isSelf:NO];
            [self attention];
        }else if (isAttention == YES){
            ad.followState = nil;
            [followStateDic setValue:@"0" forKey:@"following"];
            ad.followState = followStateDic;
            [_muArr replaceObjectAtIndex:self.row withObject:ad];
            
            [cell setAttentionType:1 following:[[followStateDic objectForKey:@"following"] integerValue] isSelf:NO];
            [self cancelAttention];
        }
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

- (void)hha {
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:@"" forKey:@"user_id"];
    
    [manager attention:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"666%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {//关注失败
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"已经关注了" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
        } else {//关注成功
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"关注成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    

}


@end
