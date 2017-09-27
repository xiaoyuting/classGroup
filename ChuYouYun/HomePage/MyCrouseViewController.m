//
//  MyCrouseViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/3.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "MyCrouseViewController.h"
#import "CourseCell.h"
#import "ZhiyiHTTPRequest.h"
#import "CData.h"
#import "CBaseClass.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "Passport.h"
#import "classDetailVC.h"
#import "UIButton+WebCache.h"
#import "SYGClassTableViewCell.h"

@interface MyCrouseViewController ()
{
    NSMutableArray *_dataArr;
    NSInteger _number;
    CGRect rect;
}

@property (strong ,nonatomic)NSArray *dataArray;

@end

@implementation MyCrouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 110;
    _dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    rect = [UIScreen mainScreen].applicationFrame;
    //下拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [_tableView headerBeginRefreshing];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,5,0,0)];
    }
    
    //设置表格分割线的长度（跟两边的距离）
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,2,0,0)];
    }
    
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
    
    NSString *userInfo = [Passport filePath];
    NSDictionary *userDic = [[NSDictionary alloc]initWithContentsOfFile:userInfo];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:@"1"forKey:@"page"];
    [dic setObject:@"10"forKey:@"count"];

    [manager userAttentionCrouse:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"++++%@",responseObject);
        _dataArray = responseObject[@"data"];
        NSMutableArray *muArr = [[NSMutableArray alloc]initWithCapacity:0];
        if (![[responseObject objectForKey:@"data"] isEqual:[NSNull null]] ) {
            muArr = [responseObject objectForKey:@"data"];
        }else
        {
            
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 64)];
            imageView.image = [UIImage imageNamed:@"收藏-课程@2x"];
            [self.view addSubview:imageView];

            
        }
        NSMutableArray *listArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (int i=0; i<muArr.count; i++) {
            
            CData * list = [[CData alloc]initWithDictionary:muArr[i]];
            [listArr addObject:list];
        }
        _dataArr = [NSMutableArray arrayWithArray:listArr];
        [_tableView reloadData];

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
    NSLog(@"%@",list.dataIdentifier);
    [dic setObject:@"1" forKey:@"type"];
    [dic setObject:@"2" forKey:@"rtype"];
    
    [manager userDelCourse:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *code = [responseObject objectForKey:@"code"];
        
        NSLog(@"code    %@",code);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_dataArray isEqual:[NSNull null]]) {
        return 0;
    }else {
        return _dataArray.count;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 146;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellStr = @"SYGClassTableViewCell";
    SYGClassTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[SYGClassTableViewCell alloc] initWithReuseIdentifier:cellStr];
    }
    
    NSLog(@"%@",_dataArray);

    [cell.imageButton setBackgroundImage:[UIImage imageNamed:@"站位图"] forState:UIControlStateNormal];
    [cell.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_dataArray[indexPath.row][@"cover"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"站位图"]];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"video_title"]];
    cell.contentLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"video_intro"]];
    cell.GKLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"video_order_count"]];
    cell.XBLabel.text = [NSString stringWithFormat:@"%@  元",_dataArray[indexPath.row][@"v_price"]];
    
    
    NSString *MoneyStr = [NSString stringWithFormat:@"%@  元",_dataArray[indexPath.row][@"v_price"]];
    NSString *XBStr = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"v_price"]];
    //变颜色
    NSMutableAttributedString *needStr = [[NSMutableAttributedString alloc] initWithString:MoneyStr];
    [needStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] range:NSMakeRange(0, XBStr.length)];
    //设置字体加错
    [needStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, XBStr.length)];
    [needStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, XBStr.length)];
    
    [cell.XBLabel setAttributedText:needStr] ;
    
    
    NSString * starStr = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"video_score"]];
    float length = [starStr floatValue];
    if (length == 1) {
        
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"101@2x"] forState:UIControlStateNormal];
    }
    
    if (length == 2) {
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"102@2x"] forState:UIControlStateNormal];
    }else {
        
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"100@2x"] forState:UIControlStateNormal];
    }
    
    if (length == 3) {
        
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"103@2x"] forState:UIControlStateNormal];
    }
    
    if (length == 4) {
        
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"104@2x"] forState:UIControlStateNormal];
    }
    
    if (length == 5) {
        
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"105@2x"] forState:UIControlStateNormal];
    }

    return cell;

    
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//删除
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//
//        [self delDataAtIndex:indexPath.row];
//
//        [_dataArr removeObjectAtIndex:indexPath.row];
//        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
////        NSIndexSet * set =[NSIndexSet indexSetWithIndex:indexPath.section];
////        //NSIndexSet－－索引集合
////        [tableView reloadSections:set withRowAnimation:UITableViewRowAnimationBottom];
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
    CData *list = [_dataArr objectAtIndex:indexPath.row];
    classDetailVC *bvc = [[classDetailVC alloc]initWithMemberId:list.dataIdentifier andPrice:list.vPrice andTitle:list.videoIntro];
    bvc.videoTitle = list.videoTitle;
    bvc.navigationItem.title = list.videoTitle;
    bvc.img = list.bigIds;
    bvc.video_address = list.videoAddress;
    [self.navigationController pushViewController:bvc animated:YES];
}




@end
