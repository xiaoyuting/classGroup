//
//  NoteViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/30.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "NoteViewController.h"
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

@interface NoteViewController ()
{
    CGRect rect;
    NSMutableArray *_dataArray;
   
}

@property (strong ,nonatomic)NSDictionary *dic;
@end

@implementation NoteViewController

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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的笔记";
    
    [self addNav];
    rect = [UIScreen mainScreen].applicationFrame;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, MainScreenWidth, 0)];
    
    self.muArr = [[NSMutableArray alloc]initWithCapacity:0];
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [_tableView headerBeginRefreshing];
    
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"点评返回@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"记笔记";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];

}

- (void)headerRerefreshing
{
    [self reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
    
}
-(void)reloadData
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
//    [dic setObject:@"420591e976ca09540022e8c51d16ca73" forKey:@"oauth_token"];
//    [dic setObject:@"99928518802affe98359b9646cdaca3b" forKey:@"oauth_token_secret"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
//    [dic setObject:@"1" forKey:@"page"];
//    [dic setObject:@"10" forKey:@"count"];
    [manager reloadNoteTitle:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        _dic = responseObject;
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {
            self.tableView.alpha = 0;
            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake((rect.size.width-200)/2, 70, 200, 21)];
            lbl.font = [UIFont systemFontOfSize:16];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.text = @"还没有笔记，快去逛逛吧~";
            lbl.textColor = [UIColor colorWithRed:36.0/255.0 green:102.0/255.0 blue:167.0/255.0 alpha:1];
            [self.view addSubview:lbl];

        } else
        {
            NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:0];
            arr = [responseObject objectForKey:@"data"];
            [self.muArr removeAllObjects];
            for (int i = 0; i<arr.count; i++) {
                NBaseClass *nb = [[NBaseClass alloc]initWithDictionary:arr[i]];
                [self.muArr addObject:nb];
            }
            _dataArray = [NSMutableArray arrayWithArray:self.muArr];
            NSLog(@"$$$%@",self.muArr);
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
    static NSString * Identifier = @"cell";
    NoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (!cell) {
            NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"NoteTableViewCell" owner:nil options:nil];
            cell = [cellArr objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.notehead.clipsToBounds =YES;
            cell.notehead.layer.cornerRadius = 25.0;
    }
    NBaseClass *nb = [self.muArr objectAtIndex:indexPath.row];
    cell.noteName.text = nb.uid;
    cell.noteDate.text = nb.strtime;
    cell.noteTitle.text = nb.noteTitle;
    cell.noBody.text = nb.noteDescription;
    cell.commentLbl.text = nb.noteCommentCount;
    cell.praiseLbl.text = nb.noteHelpCount;
    cell.noteName.text = nb.uname;
    cell.notehead.layer.cornerRadius = 25;
    [cell.notehead sd_setBackgroundImageWithURL:[NSURL URLWithString:nb.userface] forState:0 placeholderImage:[UIImage imageNamed:@"my_bg.png"]];
    cell.notehead.enabled = NO;
    
    cell.commandBtn.tag = indexPath.row;
    [cell.commandBtn addTarget:self action:@selector(commandClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.praiseBtn.tag = indexPath.row;
    [cell.praiseBtn addTarget:self action:@selector(praiseClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NBaseClass *nb = [self.muArr objectAtIndex:indexPath.row];
//    noteVC *note = [[noteVC alloc]initWithId:nb.internalBaseClassIdentifier isSelf:YES];
//    [self.navigationController pushViewController:note animated:YES];
    
    
    
//    NoteDetailsViewController *noteDetailsVC = [[NoteDetailsViewController alloc] init];
//    _dic[@"data"][indexPath.row] = noteDetailsVC.dic;
//    [self.navigationController pushViewController:noteDetailsVC animated:YES];
    
    
    
    
    
}





-(void)commandClick:(UIButton *)btn
{
    NoteTableViewCell *cell = (NoteTableViewCell *)[[[btn superview]superview]superview];
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    int command = (int)cell.commentLbl.text;
    command++;
    cell.commentLbl.text = [NSString stringWithFormat:@"%d",command];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(void)praiseClick:(UIButton *)btn
{
    NoteTableViewCell *cell = (NoteTableViewCell *)[[[btn superview]superview] superview];
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
