//
//  msgViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/27.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "msgViewController.h"
#import "MyMsgViewController.h"
#import "receiveCommandViewController.h"
#import "SystemViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "ChatViewController.h"
#import "SYG.h"



@interface msgViewController ()
{
    NSArray *lblArr;
    NSArray *imageArr;
}
@property (strong ,nonatomic)NSArray *XXArray;

@end

@implementation msgViewController
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    imageArr = [NSArray arrayWithObjects:@"我的私信私信@2x",@"收到的评论@2x",@"系统消息@2x",@"系统消息@2x", nil];
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
    [self addNav];
    self.navigationItem.title = @"我的消息";
    lblArr = [[NSArray alloc]initWithObjects:@"我的私信",@"收到的评论",@"系统消息",@"聊天信息", nil];
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight)];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    NSString *CStr = [NSString stringWithFormat:@"%@",_XXDic[@"data"][@"no_read_message"]];
    NSString *MStr = [NSString stringWithFormat:@"%@",_XXDic[@"data"][@"no_read_comment"]];
    NSString *NStr = [NSString stringWithFormat:@"%@",_XXDic[@"data"][@"no_read_notify"]];
    NSString *CheetStr = [NSString stringWithFormat:@"%@",_XXDic[@"data"][@"no_read_notify"]];

    _XXArray = @[CStr,MStr,NStr,CheetStr];
    NSLog(@"%@",_XXArray);
    
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
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"我的消息";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIButton *btn = [UIButton buttonWithType:0];
        NSString *imageStr = [imageArr objectAtIndex:indexPath.row];
        [btn setBackgroundImage:[UIImage imageNamed:imageStr] forState:0];
        btn.frame = CGRectMake(10, 15, 40, 40);
        btn.clipsToBounds = YES;
        [btn.layer setCornerRadius:20];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(60, 25, 100, 21)];
        lbl.text = [lblArr objectAtIndex:indexPath.row];
        [cell addSubview:btn];
        [cell addSubview:lbl];
        
        //添加红色的消息提醒按钮
        UIButton *TXButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50, 28, 14, 14)];
        TXButton.layer.cornerRadius = 7;
        [TXButton setTitle:_XXArray[indexPath.row] forState:UIControlStateNormal];
        if ([_XXArray[indexPath.row]integerValue] == 0) {
            TXButton.hidden = YES;
        }
        TXButton.titleLabel.font = [UIFont systemFontOfSize:12];
        TXButton.tag = indexPath.row;
        TXButton.backgroundColor = [UIColor redColor];
        [cell addSubview:TXButton];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            MyMsgViewController *m = [[MyMsgViewController alloc]init];
            [self.navigationController pushViewController:m animated:YES];
            UIButton *button = (UIButton *)[self.view viewWithTag:indexPath.row];
            [button removeFromSuperview];
        }
            break;
        case 1:
        {
            receiveCommandViewController *r = [[receiveCommandViewController alloc]init];
            [self.navigationController pushViewController:r animated:YES];
            UIButton *button = (UIButton *)[self.view viewWithTag:indexPath.row];
            [button removeFromSuperview];
        }
            break;
        case 2:
        {
            SystemViewController *s = [[SystemViewController alloc]init];
            [self.navigationController pushViewController:s animated:YES];
            UIButton *button = (UIButton *)[self.view viewWithTag:indexPath.row];
            [button removeFromSuperview];
        }
            break;
        case 3:
        {
            ChatViewController *s = [[ChatViewController alloc]init];
            [self.navigationController pushViewController:s animated:YES];
            UIButton *button = (UIButton *)[self.view viewWithTag:indexPath.row];
            [button removeFromSuperview];
        }
            break;
        default:
            break;
    }
}



@end
