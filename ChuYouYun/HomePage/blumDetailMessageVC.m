//
//  blumDetailMessageVC.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/13.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//
#define ViewBackColor [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1]
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4,4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕


#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕

#define iPhone6PlusBIG ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus放大版屏幕

#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

#import "blumDetailMessageVC.h"
#import "MyHttpRequest.h"
#import "blumNameCell.h"
#import "blumDetailList.h"
#import "classInroCell.h"
#import "teacherCell.h"
#import "UIImageView+WebCache.h"
#import "blumTagCell.h"
#import "SYGXQTeacherTableViewCell.h"
#import "UIButton+WebCache.h"
#import "SYGKCJJTableViewCell.h"
#import "SYGPFTableViewCell.h"
#import "UIColor+HTMLColors.h"

@interface blumDetailMessageVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSString * strId;
    
}
@end

@implementation blumDetailMessageVC

-(id)initWithId:(NSString *)Id andTitle:(NSString *)title
{
    if (self=[super init]) {
        _blum_id = Id;
        _blum_title=title;
        
    }
    return self;
}
static NSString * cellStr = @"cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBackColor;
    if (iPhone4SOriPhone4) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-290+145 - 200 + 2 + 50) style:UITableViewStylePlain];
    }
    if (iPhone5o5Co5S) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-300+145 - 200 + 2 + 50) style:UITableViewStylePlain];
    }
    else if (iPhone6)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-380+145 - 200 + 2 + 50) style:UITableViewStylePlain];
    }
    else if (iPhone6Plus)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-430+145 - 200 + 2 + 50) style:UITableViewStylePlain];
    }else {//ipad适配
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-730+145 - 200 + 2 + 50) style:UITableViewStylePlain];
    }
    
    _tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
    [self requestData];
}

#pragma mark - 自定义分区标题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UILabel * v_headerLab = [[UILabel alloc] initWithFrame:CGRectMake(7, 2, MainScreenWidth, 38)];
        UIView *v_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 30)];//创建一个视图（v_headerView）
//        UIImageView *v_headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 23)];//创建一个UIimageView（v_headerImageView）
//        [v_headerView addSubview:v_headerImageView];//将v_headerImageView添加到创建的视图（v_headerView）中
        v_headerLab.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];//设置v_headerLab的背景颜色
        v_headerLab.font = [UIFont systemFontOfSize:17];//设置v_headerLab的字体样式和大小
        v_headerLab.shadowColor = [UIColor whiteColor];//设置v_headerLab的字体的投影
        [v_headerLab setShadowOffset:CGSizeMake(0, 1)];//设置v_headerLab的字体投影的位置
        
        v_headerLab.text = _blum_title;
        v_headerLab.textColor = [UIColor blackColor];
        [v_headerView addSubview:v_headerLab];
        return v_headerView;
        
    }else {
        return nil;
    }

    return nil;
}

#pragma mark - 让每个分区headerView一起滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView)
    {
        CGFloat sectionHeaderHeight = 40;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

-(void)requestData
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_blum_id forKey:@"id"];
    [manager albumDetail:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        _dict = [responseObject objectForKey:@"data"];
        
        NSString *moneyString = _dict[@"mzprice"][@"price"];
        
        NSLog(@"**%@",_dict);
        strId = _dict[@"id"];
        [_tableView reloadData];
        [self requestData2];
        
        //通知传值
//        NSNotification *noti = [NSNotification notificationWithName:@"" object:nil userInfo:_dict];
//        //通过通知中心发送通知
//        [[NSNotificationCenter defaultCenter] postNotification:noti];
      
     [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationName" object:nil userInfo:_dict];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


-(void)requestData2
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:strId forKey:@"id"];
    [manager albumTeacher:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _dataArray = [responseObject objectForKey:@"data"];
        NSMutableArray * listArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (int i=0; i<_dataArray.count; i++) {
            blumDetailList * list = [[blumDetailList alloc]initWithDictionarys:_dataArray[i]];
            [listArr addObject:list];
        }
        _dataArray=listArr;
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2) {
        return _dataArray.count;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 40;
    }else {
        return 0;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==2) {
        UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }else if (indexPath.section == 1) {
        UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }else if (indexPath.section == 0) {
        return 50;
    } else {
        return 100;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {

        static NSString * cellStr = @"SYGPFTableViewCell";
        SYGPFTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        
        if (cell == nil) {
            cell = [[SYGPFTableViewCell alloc] initWithReuseIdentifier:cellStr];
        }

        NSLog(@"88%@",_dict);
        NSString *XJ = _dict[@"album_score"];
        NSString *JJ = [NSString stringWithFormat:@"10%@@2x",XJ];
        [cell.PFButton setBackgroundImage:[UIImage imageNamed:JJ] forState:UIControlStateNormal];
        
        NSInteger HHHH = [XJ integerValue];
        if (HHHH == 0) {
            [cell.PFButton setBackgroundImage:[UIImage imageNamed:@"100@2x"] forState:UIControlStateNormal];
        }

        cell.Number.text = [NSString stringWithFormat:@"%@",_dict[@"album_order_count"]];
        
        return cell;
    }
    
    if (indexPath.section==1) {
        static NSString * cellStr = @"SYGKCJJTableViewCell";
        SYGKCJJTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        
        if (cell == nil) {
            cell = [[SYGKCJJTableViewCell alloc] initWithReuseIdentifier:cellStr];
        }
        [cell setIntroductionText:_dict[@"album_intro"]];
        NSLog(@"%@",_dict[@"album_intro"]);
        return cell;
    }
    
    if (indexPath.section==2) {
        static NSString * cellStr = @"SYGXQTeacherTableViewCell";
        SYGXQTeacherTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        
        if (cell == nil) {
            cell = [[SYGXQTeacherTableViewCell alloc] initWithReuseIdentifier:cellStr];
        }
        blumDetailList * list = _dataArray[indexPath.row];

        [cell.HeadImage sd_setBackgroundImageWithURL:[NSURL URLWithString:list.headImg] forState:UIControlStateNormal];
        cell.HeadImage.layer.cornerRadius = 20;
        cell.HeadImage.layer.masksToBounds = YES;
        
        cell.NameLabel.text = list.name;
        
        [cell setIntroductionText:list.inro];
        
        
        
        return cell;
    }
    
    if(indexPath.section==3)
    {
        blumTagCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            NSArray * xibArr = [[NSBundle mainBundle]loadNibNamed:@"blumTagCell" owner:nil options:nil];
            for (id obj in xibArr) {
                cell = (blumTagCell *)obj;
                break;
            }
        }

        //得到字符串
        NSString *ZLString = _dict[@"str_tag"];
        if ([ZLString isEqualToString:@""]) {//空的时候
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 20 , 80, 30)];
            [button setTitle:@"暂无标签" forState:UIControlStateNormal];
//            button.layer.cornerRadius = 3;
//            button.layer.borderWidth = 1;
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.layer.borderColor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1].CGColor;
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:[UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1] forState:UIControlStateNormal];
            [cell.contentView addSubview:button];
            
            return cell;
            
        }else {//有标题的时候
            
            
            NSArray *array = [ZLString componentsSeparatedByString:@","];
            NSLog(@"SYGHH%@",array);
            
            for (int i = 0; i < array.count ; i ++) {
                UIButton *button = [[UIButton alloc] init];
                button.frame = CGRectMake(20 + 80 * (i % 4) + 10 * (i % 4), 20 + 30 * (i / 4) + 10 * (i / 4), 80, 30);
                if (iPhone4SOriPhone4 || iPhone5o5Co5S) {
                    button.frame = CGRectMake(20 + 80 * (i % 3) + 10 * (i % 3), 20 + 30 * (i / 3) + 10 * (i / 3), 80, 30);
                }else {
                    button.frame = CGRectMake(20 + 80 * (i % 4) + 10 * (i % 4), 20 + 30 * (i / 4) + 10 * (i / 4), 80, 30);
                }

                button.layer.cornerRadius = 3;
                button.layer.borderWidth = 1;
                button.titleLabel.font = [UIFont systemFontOfSize:14];
                button.layer.borderColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1].CGColor;
                button.backgroundColor = [UIColor whiteColor];
                [button setTitle:array[i] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] forState:UIControlStateNormal];
                [cell.contentView addSubview:button];

            }
            return cell;

        }
        
        
    }
    return nil;
}


@end
