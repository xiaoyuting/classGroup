//
//  honourViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/3/2.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "honourViewController.h"
#import "HonourCell.h"
#import "ZhiyiHTTPRequest.h"
#import "HonourCell.h"
#import "UIButton+WebCache.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"

@interface honourViewController ()
{
    CGRect rect;
}
@end

@implementation honourViewController
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
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"光荣榜";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 300, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,286)];
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



- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNav];
    self.navigationItem.title = @"光荣榜";
    rect = [UIScreen mainScreen].applicationFrame;
    self.muArr = [[NSMutableArray alloc]initWithCapacity:0];
    [self reloadHonour];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, rect.size.width, rect.size.height) style:UITableViewStylePlain];
//    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.delegate = self;
    self.tableview.dataSource =self;
    [self.view addSubview:self.tableview];
}
-(void)reloadHonour
{
    ZhiyiHTTPRequest *manager =[ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
//    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
//    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [manager RequestHonour:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.muArr = [responseObject objectForKey:@"data"];
        [self.tableview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.muArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    HonourCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"HonourCell" owner:nil options:nil];
        cell = [cellArr objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    switch (indexPath.row) {
        case 0:
            cell.topImage.image = [UIImage imageNamed:@"Top1.png"];
            break;
        case 1:
            cell.topImage.image = [UIImage imageNamed:@"Top2.png"];
            break;
        case 2:
            cell.topImage.image = [UIImage imageNamed:@"Top3.png"];
            break;
        default:
            break;
    }
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:[self.muArr objectAtIndex:indexPath.row]];
    cell.quizNumber.text = [dic objectForKey:@"count"];
    cell.quizNumber.textColor = BasidColor;
    NSDictionary *userInfo = [dic objectForKey:@"userinfo"];
    [cell.userFace sd_setBackgroundImageWithURL:[NSURL URLWithString:[userInfo objectForKey:@"avatar_small"]] forState:0 placeholderImage:nil];
    cell.userFace.clipsToBounds = YES;
    cell.userFace.layer.cornerRadius = 30.0;
    cell.userName.text = [userInfo objectForKey:@"uname"];
    if ([userInfo[@"intro"] isEqual:[NSNull null]]) {
        cell.userText.text = @"暂无";
    }else {
         cell.userText.text = [userInfo objectForKey:@"intro"];
    }
   
    return cell;
}



@end
