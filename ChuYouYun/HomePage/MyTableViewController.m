//
//  MyTableViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/3/10.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "MyTableViewController.h"
#import "MyViewController.h"
#import "UIButton+WebCache.h"
#import "CourseCell.h"
#import "msgViewController.h"
#import "settingViewController.h"
#import "MyShoppingCarViewController.h"
#import "CourseViewController.h"
#import "QuestionsAndAnswersViewController.h"
#import "NoteViewController.h"
#import "AttentionViewController.h"
#import "MyMsgViewController.h"
#import "receiveCommandViewController.h"
#import "FansViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "Passport.h"
#import "CData.h"
#import "MJRefresh.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "questionViewController.h"
#import "NoteViewController.h"
#import "UIImage+WebP.h"
#import "MyBuyCell.h"
#import "classDetailVC.h"
#import "teacherList.h"
@interface MyTableViewController ()
{
    NSInteger _number;
    CGRect rect;
}
@end

@implementation MyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    rect = [UIScreen mainScreen].applicationFrame;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height-60) style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:237.0/255.0 alpha:1];
    self.tableView.userInteractionEnabled = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    [self.view addSubview:self.tableView];
    //下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [self.tableView headerBeginRefreshing];
}
- (void)headerRerefreshing
{
    [self reloadData:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    });
}
- (void)footerRefreshing
{
    _number++;
    [self reloadData:_number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
    });
}
-(void)reloadData:(NSInteger)number
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)number] forKey:@"page"];
    [dic setObject:@"10" forKey:@"count"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [manager getClass:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"66^^^^%@",responseObject);
        NSMutableArray *muArr = [[NSMutableArray alloc]initWithCapacity:0];
        if (![[responseObject objectForKey:@"data"] isEqual:[NSNull null]] ) {
            muArr = [responseObject objectForKey:@"data"];
        }else
        {
//            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake((rect.size.width-200)/2, 10, 200, 21)];
//            lbl.font = [UIFont systemFontOfSize:16];
//            lbl.textAlignment = NSTextAlignmentCenter;
//            lbl.text = @"骚年，书架还是空的哦~";
//            lbl.textColor = [UIColor colorWithRed:36.0/255.0 green:102.0/255.0 blue:167.0/255.0 alpha:1];
//            [self.view addSubview:lbl];
        }
        NSMutableArray *listArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (int i=0; i<muArr.count; i++) {
            CData * list = [[CData alloc]initWithDictionary:muArr[i]];
            [listArr addObject:list];
            if (number == 1) {
                self.dataArr = [NSMutableArray arrayWithArray:listArr];
            }else
            {
                [self.dataArr addObject:list];
            }

        }
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [manager userSpecial:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)delDataAtIndex:(NSInteger)indexRow
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    CData *list = [_dataArr objectAtIndex:indexRow];
    NSLog(@"id   %@",list.dataIdentifier);
    [dic setObject:list.dataIdentifier forKey:@"id"];
    [dic setObject:@"1" forKey:@"type"];
    [dic setObject:@"1" forKey:@"rtype"];
    
    [manager userDelCourse:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *code = [responseObject objectForKey:@"code"];
        NSLog(@"code    %@",code);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Cell";
    MyBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"MyBuyCell" owner:nil options:nil];
        cell = [cellArr objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    CData *list = [_dataArr objectAtIndex:indexPath.row];
    [cell.cImage sd_setImageWithURL:[NSURL URLWithString:list.bigIds] placeholderImage:nil];
    cell.cName.text = list.videoTitle;
    cell.Ctext.text = list.videoIntro;
    cell.Ctext.numberOfLines = 0;
    cell.record.text = list.videoOrderCount;
    [cell starCount:(NSInteger)list.videoScore];
    [cell.muchBtn setTitle:[NSString stringWithFormat:@"%@元",list.tPrice]forState:0];
    [cell.muchBtn setEnabled:NO];
    return cell;
}

//删除课程
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        [self delDataAtIndex:indexPath.row];
//        
//        [_dataArr removeObjectAtIndex:indexPath.row];
//        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        NSIndexSet * set =[NSIndexSet indexSetWithIndex:indexPath.section];
//        //NSIndexSet－－索引集合
//        [tableView reloadSections:set withRowAnimation:UITableViewRowAnimationBottom];
//        
//    }
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        
//    }
//}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",_dataArr[0]);
    CData *cd = [_dataArr objectAtIndex:indexPath.row];
    classDetailVC *cvc = [[classDetailVC alloc]initWithMemberId:cd.dataIdentifier andPrice:cd.vPrice andTitle:cd.videoIntro];
    cvc.videoTitle = cd.videoTitle;
    cvc.img = cd.bigIds;
    cvc.video_address = cd.videoAddress;
    [self.navigationController pushViewController:cvc animated:YES];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
