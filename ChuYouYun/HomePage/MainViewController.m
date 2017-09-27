//
//  MainViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 15/9/17.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))
#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4,4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕


#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕

#define iPhone6PlusBIG ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus放大版屏幕



#import "MainViewController.h"
#import "MainTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "teacherList.h"
#import "classDetailVC.h"
#import "teacherDetailViewController.h"

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSArray *dataSource;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"讲师主页";
//    [self.navigationBar setBackIndicatorImage:IMGNAME(@"返回")];
//    [self.navigationBar setBackIndicatorTransitionMaskImage:IMGNAME(@"返回")];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 20)];
    [backButton setImage:[UIImage imageNamed:@"Arrow000"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bake = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:bake];
    
    [self initail];

}

- (void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initail
{

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight) style:UITableViewStyleGrouped ];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 129;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentfier = @"main";
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentfier];
    if (!cell) {
        cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:indentfier];
        
        
        NSArray * xibArr = [[NSBundle mainBundle]loadNibNamed:@"MainTableViewCell" owner:nil options:nil];
        for (id obj in xibArr) {
            cell = (MainTableViewCell *)obj;
            break;
        }
    }
    NSLog(@"++++%@",self.array[0]);
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",self.array[indexPath.row][@"video_title"]];
    NSLog(@"________%@",self.array[indexPath.row][@"video_title"]);
    
    cell.moneyLabel.text = [NSString stringWithFormat:@"%@金币",self.array[indexPath.row][@"mzprice"][@"price"]];
  
    cell.contentLabel.text = [NSString stringWithFormat:@"%@",self.array[indexPath.row][@"video_intro"]];
    cell.numberLabel.text = [NSString stringWithFormat:@"%@",self.array[indexPath.row][@"video_order_count"]];
    cell.likeLabel.text = [NSString stringWithFormat:@"%@",self.array[indexPath.row][@""]];
    NSString *url = [NSString stringWithFormat:@"%@",self.array[indexPath.row][@"small_ids"]];
    [cell.classImageView sd_setImageWithURL:[NSURL URLWithString:url]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *srt = self.array[indexPath.row][@"mzprice"][@"price"];
    NSString *titlie = self.array[indexPath.row][@"video_title"];
    
    classDetailVC * cvc = [[classDetailVC alloc]initWithMemberId:self.array[indexPath.row][@"id"] andPrice:srt andTitle:titlie];

    cvc.videoTitle = titlie;
    cvc.img = self.array[indexPath.row][@"big_ids"];
        cvc.video_address = self.array[indexPath.row][@"video_address"];
    [self.navigationController pushViewController:cvc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

@end
