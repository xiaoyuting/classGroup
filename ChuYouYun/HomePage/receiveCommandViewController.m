//
//  receiveCommandViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/31.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#define SYGColer [UIColor colorWithRed:240.f / 255 green:240.f / 255 blue:240.f / 255 alpha:1]

#import "receiveCommandViewController.h"
#import "TextCommandCell.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "ZhiyiHTTPRequest.h"
#import "CMBaseClass.h"
#import "UIButton+WebCache.h"
#import "WebVC.h"
#import "Passport.h"
#import "SYGCommandTableViewCell.h"
#import "emotionjiexi.h"
#import "UIColor+HTMLColors.h"
#import "TIXingLable.h"
#import "GLReachabilityView.h"
#import "SYG.h"


@interface receiveCommandViewController ()
{
    NSArray *arr;
    NSString * labelStr;
    NSString * cmdStr;
    CGRect rect;
    TIXingLable *_txLab;
}
@end

@implementation receiveCommandViewController

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
    [self reloadComand];
    [self addNav];
    rect = [UIScreen mainScreen].applicationFrame;
    self.muArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.tableView.showsVerticalScrollIndicator = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 + 37) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _txLab = [[TIXingLable alloc]initWithFrame:CGRectMake(0,200*MainScreenHeight/667, MainScreenWidth, 30)];
    _txLab.textColor = [UIColor clearColor];
    [_tableView insertSubview:_txLab atIndex:0];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,10,0,0)];
    }
    
    //设置表格分割线的长度（跟两边的距离）
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,2,0,0)];
    }
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
    [frashButton setTitleColor:BasidColor forState:UIControlStateNormal];
    frashButton.hidden = YES;
    
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"收到的评论";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];

    
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
            
        }        [self reloadComand];
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


-(void)reloadComand
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:@"1" forKey:@"page"];
    [dic setObject:@"5" forKey:@"count"];
    [manager reloadCommandForMe:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"^^^^^%@",responseObject);
        NSLog(@"%@",operation);
        
        if (![[responseObject objectForKey:@"data"]isEqual:[NSNull null]]) {
            _dataArr=[NSArray arrayWithArray:[responseObject objectForKey:@"data"]];
            for (int i=0; i<_dataArr.count; i++) {
                CMBaseClass *cm =[[CMBaseClass alloc]initWithDictionary:[_dataArr objectAtIndex:i]];
                [self.muArr addObject:cm];
            }
            [self.tableView reloadData];
        }else
        {
            self.tableView.alpha = 0;
            
            //添加空白处理
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
            imageView.image = [UIImage imageNamed:@"我的评论@2x"];
            [self.view addSubview:imageView];
            
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)delDataAtIndex:(NSInteger)indexRow
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    CMBaseClass *cmb = [self.muArr objectAtIndex:indexRow];
    
    [dic setObject:cmb.internalBaseClassIdentifier forKey:@"id"];
    [manager delCommandForMe:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([msg isEqual:@"ok"]) {
            //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
//-(void)reloadXML:(NSString *)xml
//{
//    NSString *dataString = [NSString stringWithContentsOfURL:[NSURL URLWithString:xml] encoding:NSUTF8StringEncoding error:nil];
//    NSData *htmlData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
//    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
//    NSArray *elements  = [xpathParser searchWithXPathQuery:nodeString];
//}
-(void)delComand
{
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.muArr.count==0) {
        _txLab.textColor = [UIColor colorWithHexString:@"#dedede"];
    }else{
        
        _txLab.textColor = [UIColor clearColor];
    }
    return self.muArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height + 15 + 30 + 25;
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.sectionHeaderHeight, tableView.frame.size.width)];
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //指定cellIdentifier为自定义的cell
    static NSString *CellIdentifier = @"SYGBJTableViewCell";
    //自定义cell类
    SYGCommandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SYGCommandTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    
    
    CMBaseClass *cm = [self.muArr objectAtIndex:indexPath.row];
    NSDictionary *myDic = [NSDictionary dictionaryWithDictionary:cm.fidinfo];
    cell.myHeadImage.layer.cornerRadius = 25;
    cell.myHeadImage.layer.masksToBounds = YES;
    [cell.myHeadImage sd_setBackgroundImageWithURL:[NSURL URLWithString:[myDic objectForKey:@"avatar_small"]] forState:UIControlStateNormal];
    
    NSLog(@"%@",_dataArr[indexPath.row]);
    cell.myName.text = _dataArr[indexPath.row][@"fidinfo"][@"uname"];
    cell.dayLabel.text = [Passport formatterDate:_dataArr[indexPath.row][@"uidinfo"][@"last_login_time"]];
    
    [cell.SCButton setTitle:@"" forState:UIControlStateNormal];
//    [cell.SCButton setTitle:@"删除评论" forState:UIControlStateNormal];
    
    NSDictionary *uDic = [NSDictionary dictionaryWithDictionary:cm.uidinfo ];
    
    NSString *Info = [NSString stringWithFormat:@"%@",cm.info];
    NSLog(@"%@",Info);
    NSString *JJ = [self filterHTML:Info];
    [cell setIntroductionText:JJ];
    
    cell.GDLabel.text = cm.toComment;
    NSString *JXStr = cm.toComment;
    cell.GDLabel.attributedText = [emotionjiexi jiexienmojconent:JXStr font:[UIFont systemFontOfSize:16]];
    
    cell.otherImage.clipsToBounds = YES;
    cell.otherImage.layer.cornerRadius = 20.0;
    [cell.otherImage sd_setBackgroundImageWithURL:[NSURL URLWithString:uDic[@"avatar_small"]] forState:0];
    cell.PLNameLabel.text = uDic[@"uname"];
    [cell setIntroductionTextName:uDic[@"uname"]];
    //    NSLog(@"--------%@",NSStringFromCGRect(cell.PLNameLabel.frame));
    //
    //    //设置我的回答的位置
    //    CGFloat XX = cell.PLNameLabel.frame.size.width;
    //    cell.HFLabel.frame = CGRectMake(XX + 200, 10, 200, 20);
    
    return cell;
}
-(void)relaodWeb:(UIButton *)sender
{
    CMBaseClass *cm = [self.muArr objectAtIndex:sender.tag];
    NSDictionary *uidinfo = [[NSDictionary alloc]initWithDictionary:cm.uidinfo];
    NSLog(@"00%@",self.muArr);
    
    WebVC *web = [[WebVC alloc]initWithURL:[uidinfo objectForKey:@"space_link"]];
    
    [self.navigationController pushViewController:web animated:YES];
}
-(void)deleteClick:(UIButton *)btn
{
    TextCommandCell *cell = (TextCommandCell *)[[[btn superview]superview] superview];
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self delDataAtIndex:indexPath.row];
        
        [self.muArr removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //        NSIndexSet * set =[NSIndexSet indexSetWithIndex:indexPath.section];
        //        //NSIndexSet－－索引集合
        //        [tableView reloadSections:set withRowAnimation:UITableViewRowAnimationBottom];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}


//去掉HTML字符
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    // NSString * regEx = @"<([^>]*)>";
    // html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
