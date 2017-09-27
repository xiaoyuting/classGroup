//
//  MyCrouseTableViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/3/10.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "MyCrouseTableViewController.h"
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
#import "blumDetailVC.h"
#import "blumList.h"
#import "SYGBlumTableViewCell.h"

@interface MyCrouseTableViewController ()
{
    NSInteger _number;
    CGRect rect;
}
@end

@implementation MyCrouseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    rect = [UIScreen mainScreen].applicationFrame;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height-60) style:UITableViewStylePlain];
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:237.0/255.0 alpha:1];
    self.tableView.rowHeight = 110;
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
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
}
- (void)footerRefreshing
{
    _number++;
    [self reloadData:_number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
    
}

//获得购买的专辑
-(void)reloadData:(NSInteger)number
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)number] forKey:@"page"];
    [dic setObject:@"10" forKey:@"count"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [manager userSpecial:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"))))%@",responseObject);
        _classArray = responseObject[@"data"];
        NSMutableArray *muArr = [[NSMutableArray alloc]initWithCapacity:0];
        if (![[responseObject objectForKey:@"data"] isEqual:[NSNull null]] ) {
            NSLog(@"**%@",responseObject);
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
                [_dataArr addObject:list];
            }
            
        }
        
        [_tableView reloadData];
        
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
    [dic setObject:@"420591e976ca09540022e8c51d16ca73" forKey:@"oauth_token"];
    [dic setObject:@"99928518802affe98359b9646cdaca3b" forKey:@"oauth_token_secret"];
    CData *list = [_dataArr objectAtIndex:indexRow];
//    NSLog(@"id   %@",list.dataIdentifier);
    [dic setObject:list.dataIdentifier forKey:@"id"];
    [dic setObject:@"2" forKey:@"type"];
    [dic setObject:@"1" forKey:@"rtype"];
    
    [manager userDelCourse:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *code = [responseObject objectForKey:@"code"];
        
        NSLog(@"code    %@",code);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 130;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellStr = @"cellSYG";
    SYGBlumTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (cell == nil) {
        cell = [[SYGBlumTableViewCell alloc] initWithReuseIdentifier:cellStr];
    }
    
    //
    //    NSString * starStr = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"album_score"]];
    //    float length = [starStr floatValue];
    //    [cell.star setStar:length];
    
    [cell.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_classArray[indexPath.row][@"middle_ids"]] forState:UIControlStateNormal];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",_classArray[indexPath.row][@"album_title"]];
    cell.contentLabel.text = [NSString stringWithFormat:@"%@",_classArray[indexPath.row][@"album_intro"]];
    cell.KSLabel.text = [NSString stringWithFormat:@"%@课时",_classArray[indexPath.row][@"video_cont"]];
    cell.XBLabel.text = [NSString stringWithFormat:@"%@  元",_classArray[indexPath.row][@"money_data"][@"price"]];
    NSString *MoneyStr = [NSString stringWithFormat:@"%@  元",_classArray[indexPath.row][@"money_data"][@"price"]];
    NSString *XBStr = [NSString stringWithFormat:@"%@",_classArray[indexPath.row][@"money_data"][@"price"]];
    //变颜色
    NSMutableAttributedString *needStr = [[NSMutableAttributedString alloc] initWithString:MoneyStr];
    [needStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] range:NSMakeRange(0, XBStr.length)];
    //设置字体加错
    [needStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, XBStr.length)];
    [needStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, XBStr.length)];
    [cell.XBLabel setAttributedText:needStr] ;
    
    NSString * starStr = [NSString stringWithFormat:@"%@",_classArray[indexPath.row][@"album_score"]];
    float length = [starStr floatValue];
    if (length == 2) {
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"2star"] forState:UIControlStateNormal];
    } else {
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"5star"] forState:UIControlStateNormal];
        
    }
    if (length == 3) {
        
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"3star"] forState:UIControlStateNormal];
    }
    
    if (length == 5) {
        
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"5star"] forState:UIControlStateNormal];
    }
    
    return cell;
    
}

//删除专辑
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
    CData *cd = [_dataArr objectAtIndex:indexPath.row];
    blumDetailVC *bvc = [[blumDetailVC alloc]initWithMemberId:cd.dataIdentifier andTitle:cd.videoTitle];
    NSString *albumTitle = [NSString stringWithFormat:@"%@",_classArray[indexPath.row][@"album_title"]];
    bvc.videoTitle = albumTitle;
    bvc.navigationItem.title = cd.videoTitle;
    [self.navigationController pushViewController:bvc animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
