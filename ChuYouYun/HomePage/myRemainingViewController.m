//
//  myRemainingViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/27.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "myRemainingViewController.h"
#import "rechargeAndBring.h"
#import "recordViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "JYJLViewController.h"

@interface myRemainingViewController ()

@end

@implementation myRemainingViewController
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self reloadBalance];
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
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的余额";
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 0,0)];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"焦点按钮@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"我的余额";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)reloadBalance
{
    ZhiyiHTTPRequest *manager =[ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [manager reloadUserbalance:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _userDic = [[NSMutableDictionary alloc]initWithDictionary:[responseObject objectForKey:@"data"]];
        NSString *msg = [responseObject objectForKey:@"msg"];
        if (![msg isEqual:@"ok"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:Identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 100, 21)];
        switch (indexPath.row) {
            case 0:
            {
                NSString *balance = [_userDic objectForKey:@"balance"];
                if ([balance isEqual:[NSNull null]]) {
                    balance = @"";
                }
                lbl.text = @"我的余额";
                UILabel *numberLbl = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width-208, 20, 200, 21)];
                numberLbl.text = [NSString stringWithFormat:@"%@元",balance];
                numberLbl.textAlignment = NSTextAlignmentRight;
                numberLbl.textColor = [UIColor lightGrayColor];
                numberLbl.backgroundColor = [UIColor whiteColor];
                [cell addSubview:numberLbl];
            }
                break;
            case 1:
            {
                lbl.text = @"充值";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 2:
            {
                lbl.text = @"提现";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 3:
            {
                lbl.text = @"交易记录";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
                
            default:
                break;
        }
        [cell addSubview:lbl];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
        }
            break;
        case 1:
        {
            rechargeAndBring *r = [[rechargeAndBring alloc]initWithRechargeAndBring:1];

            [self.navigationController pushViewController:r animated:YES];
        }
            break;
        case 2:
        {
            rechargeAndBring *r = [[rechargeAndBring alloc]initWithRechargeAndBring:0];

            [self.navigationController pushViewController:r animated:YES];
        }
            break;
        case 3:
        {
//            recordViewController *r =[[recordViewController alloc]init];
//            [self.navigationController pushViewController:r animated:YES];
            
            JYJLViewController *JYJLVC = [[JYJLViewController alloc] init];
            [self.navigationController pushViewController:JYJLVC animated:YES];
        }
            break;
            
        default:
            break;
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
