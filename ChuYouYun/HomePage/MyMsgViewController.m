//
//  MyMsgViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/31.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define SYGColer [UIColor colorWithRed:240.f / 255 green:240.f / 255 blue:240.f / 255 alpha:1]

#import "MyMsgViewController.h"
#import "MsgCell.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "ZhiyiHTTPRequest.h"
#import "MData.h"
#import "MLastMessage.h"
#import "UIButton+WebCache.h"
#import "MLastMessage.h"
#import "Passport.h"
#import "SXXQViewController.h"
#import "emotionjiexi.h"
#import "UIImageView+WebCache.h"
#import "UIColor+HTMLColors.h"
#import "TIXingLable.h"
#import <UIKit/UIKit.h>
#import "GLReachabilityView.h"
#import "SYG.h"


@interface MyMsgViewController ()<UIAlertViewDelegate>
{
    CGRect rect;
    TIXingLable *_txlab;
}
@end

@implementation MyMsgViewController
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
    rect = [UIScreen mainScreen].applicationFrame;
    self.navigationItem.title = @"我的私信";
    self.view.backgroundColor = SYGColer;
    [self addNav];
    [self reuqestMSG];
    self.msgArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.to_user_infoArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.tableView.showsVerticalScrollIndicator = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 + 36 + 10) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _txlab = [[TIXingLable alloc]initWithFrame:CGRectMake(0, 200, MainScreenWidth, 30)];
    _txlab.textColor = [UIColor clearColor];
    _txlab.textAlignment = NSTextAlignmentCenter;
    _txlab.text = @"数据为空，刷新重试";
    _txlab.hidden = YES;
    [_tableView insertSubview:_txlab atIndex:0];
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
    WZLabel.text = @"我的私信";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];

}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)frash{

    if (self.dataArr.count == 0) {
        if ([GLReachabilityView isConnectionAvailable]) {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"刷新成功请稍后" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFireMethod:) userInfo:alertView repeats:YES];
            
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请查看网络连接" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFireMethod:) userInfo:alertView repeats:YES];
        }
        
        [self reuqestMSG];
        [self.tableView reloadData];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"数据已经最新，无需刷新" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        alertView.frame = CGRectMake(0, 0, 50, 30);
//        alertView.center = self.view.center;
//        alertView.backgroundColor = [UIColor blackColor];
//        alertView.alpha = 0.7;
        [alertView show];
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alertView repeats:YES];
    }
//
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Edit" message:@"Please Modify the Info" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sure", @"Other", nil];
//    [alertView show];
    return;
}

//移除警告框
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}
-(void)reuqestMSG
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    NSLog(@"%@",dic);
    [manager messageTitle:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"^^^^^%@",responseObject);
        
        if (![[responseObject objectForKey:@"data"]isEqual:[NSNull null]]) {
          
            _magArr = [responseObject objectForKey:@"data"];
            for (int i = 0; i<_magArr.count; i++) {
                NSDictionary *data = [_magArr objectAtIndex:i];
                NSDictionary *last = [data objectForKey:@"last_message"];
                NSDictionary *userInfo = [data objectForKey:@"to_user_info"];
                if (![userInfo isEqual:[NSNull null]]) {
                    [self.msgArr addObject:last];
                    [self.to_user_infoArr addObject:userInfo];
                    [self.dataArr addObject:data];
                }
            }
            [self.tableView reloadData];
        }
        else {

            self.tableView.alpha = 0;
            
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
            imageView.image = [UIImage imageNamed:@"私信@2x"];
            [self.view addSubview:imageView];
  
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    if (_dataArr.count == 0) {
        _txlab.textColor = [UIColor colorWithHexString:@"#dedede"];
    }else{
    
        _txlab.textColor = [UIColor clearColor];
    }
}
-(void)delMessage:(NSInteger)index
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    NSDictionary *userDic = [self.dataArr objectAtIndex:index];
    NSString *uid = [userDic objectForKey:@"list_id"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:uid forKey:@"ids"];
    [manager delMessageTitle:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"msg    %@",[responseObject objectForKey:@"msg"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArr.count == 0) {
        _txlab.textColor = [UIColor colorWithHexString:@"#dedede"];
    }else{
        
        _txlab.textColor = [UIColor clearColor];
    }

    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Cell";
    MsgCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"MsgCell" owner:nil options:nil];
        cell = [cellArr objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.typeImg.layer setMasksToBounds:YES];
        [cell.typeImg.layer setCornerRadius:5]; //设置矩形四个圆角半径
        [cell.typeImg.layer setBorderWidth:1.0]; //边框宽度
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 255.0/255.0, 255.0/255.0, 255.0/255.0, 1 });
        [cell.typeImg.layer setBorderColor:colorref];//边框颜色
        
        [cell.headBtn.layer setMasksToBounds:YES];
        [cell.headBtn.layer setCornerRadius:24.0];
        [cell.headBtn addTarget:self action:@selector(msgClick:) forControlEvents:0];
    }
    
    NSLog(@"----%@",_msgArr[indexPath.row]);
    NSDictionary *msgDic = [NSDictionary dictionaryWithDictionary:[_msgArr objectAtIndex:indexPath.row]];
    NSArray *arr = [msgDic objectForKey:@"to_uid"];
    NSDictionary *userDic = [NSDictionary dictionaryWithDictionary:[_to_user_infoArr objectAtIndex:indexPath.row]];
    cell.userName.text = [NSString stringWithFormat:@"%@@",_msgArr[indexPath.row][@"user_info"][@"uname"]];
    if (arr.count) {
        NSString *key= [arr objectAtIndex:0];
        NSLog(@"KEY----%@",key);
        
        if (![key isEqual:@""]) {
            
            NSString *faceUrl;
            NSDictionary *toUserInfo = [userDic objectForKey:key];
            NSLog(@"toUserInfo----%@",toUserInfo);
            if ([toUserInfo isEqual:[NSNumber numberWithInteger:0]]) {
                return cell;
            }
            
            faceUrl = [toUserInfo objectForKey:@"avatar_small"];
            
            cell.userName.text = [toUserInfo objectForKey:@"uname"];
            cell.userName.text = [NSString stringWithFormat:@"%@@",_msgArr[indexPath.row][@"user_info"][@"uname"]];
            
            [cell.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:faceUrl] forState:UIControlStateNormal placeholderImage:nil];
            
            cell.magDate.text = [Passport formatterDate:_magArr[indexPath.row][@"list_ctime"]];
            NSLog(@"------%@",userDic[@"mtime"]);
            NSLog(@"%@",userDic);
            cell.msg.text =[msgDic objectForKey:@"content"];
            NSString *str = [msgDic objectForKey:@"content"];
            
            cell.msg.attributedText = [emotionjiexi jiexienmojconent:str font:[UIFont systemFontOfSize:17]];
        }
    }
    
    cell.userName.text = [NSString stringWithFormat:@"%@",_msgArr[indexPath.row][@"user_info"][@"uname"]];
    [cell.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_msgArr[indexPath.row][@"user_info"][@"avatar_big"]] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"---%@",self.msgArr[indexPath.row]);
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self.dataArr objectAtIndex:indexPath.row]];
    NSDictionary *msgDic = [NSDictionary dictionaryWithDictionary:[self.msgArr objectAtIndex:indexPath.row]];
    NSArray *arr = [msgDic objectForKey:@"to_uid"];
    NSString *key = [arr objectAtIndex:0];
    
    NSDictionary *userDic = [NSDictionary dictionaryWithDictionary:[self.to_user_infoArr objectAtIndex:indexPath.row]];
    NSDictionary *toUserInfo = [userDic objectForKey:key];
    NSLog(@"--toUserInfo----%@",toUserInfo);

    NSDictionary *SYGDic = self.dataArr[indexPath.row];
    NSLog(@"%@",SYGDic);
    NSLog(@"%@",SYGDic[@"last_message"][@"to_uid"]);
    NSArray *SBArray = SYGDic[@"last_message"][@"to_uid"];
    NSString *KKKK = SBArray[0];
    
    //获取自己的uid
    NSString *adminUID = [[NSUserDefaults standardUserDefaults] objectForKey:@"User_id"];
    
    if ([KKKK isEqualToString:adminUID]) {//总是自己头像
        
    } else {
        
    }
    NSLog(@"--9999%@",SYGDic[@"to_user_info"][KKKK][@"avatar_small"]);
    
    
    NSArray *array = toUserInfo[@"api_user_group"];
    NSLog(@"-----%@",array);
    NSLog(@"-----%@",toUserInfo);
    
    NSLog(@"----%@",SYGDic);
    
    
    
    NSString *faceUrl = [toUserInfo objectForKey:@"avatar_small"];
    faceUrl = SYGDic[@"to_user_info"][KKKK][@"avatar_small"];
    NSLog(@"--faceUrl--%@",SYGDic[@"last_message"][@"user_info"]);
    
    if ([KKKK isEqualToString:adminUID]) {//总是自己头像
        faceUrl = SYGDic[@"last_message"][@"user_info"][@"avatar_small"];
    } else {
//        faceUrl = SYGDic[@"last_message"][@"user_info"][@"avatar_small"];
        NSLog(@"0------%@",SYGDic);
        NSLog(@"%@",SYGDic[@"last_message"][@"to_user_info"]);
        faceUrl = SYGDic[@"to_user_info"][@"avatar_small"];
    }
    NSLog(@"--000--%@",faceUrl);
    
//    faceUrl = SYGDic[@"last_message"][@"to_user_info"][@"avatar_small"];
//
    NSLog(@"%@",faceUrl);
    
    NSString *toUid = [toUserInfo objectForKey:@"uid"];
    
    NSLog(@"-----%@",[dic objectForKey:@"list_id"]);
    NSLog(@"%@",toUid);
    
    toUid = _dataArr[indexPath.row][@"to_user_info"][@"uid"];
    NSLog(@"%@",toUid);
    SXXQViewController *SXXQVC = [[SXXQViewController alloc] initWithChatUserid: [dic objectForKey:@"list_id"] uFace:faceUrl toUserID:toUid sendToID:nil];
        NSLog(@"--000--%@",faceUrl);
    [self.navigationController pushViewController:SXXQVC animated:YES];
    
    
    
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self delMessage:indexPath.row];
        
        [self.dataArr removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
//        NSIndexSet * set =[NSIndexSet indexSetWithIndex:indexPath.section];
//        //NSIndexSet－－索引集合
//        [tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)msgClick:(UIButton *)btn
{
    
}




@end
