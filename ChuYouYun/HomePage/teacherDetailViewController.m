//
//  teacherDetailViewController.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/23.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "teacherDetailViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "Helper.h"
#import "MyHttpRequest.h"
#import "UIImageView+WebCache.h"
#import "teacherDetailTabelViewCellTableViewCell.h"
#import "teacherList.h"
#import "classDetailVC.h"
#import "MainViewController.h"

//#import "MBProgressHUD.h"
//#import "MMProgressHUD.h"

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))
#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4,4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕


#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕

#define iPhone6PlusBIG ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus放大版屏幕
@interface teacherDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView * headerImage;
    CGRect viewHeight;
    UILabel * nameLabel;
    UILabel * relatedCourseLabel;
    UILabel * courseCountLabel;
    UILabel * lastCourseLabel;
    UILabel * lastCourseNameLabel;
    UILabel * teacherIronLabel;
    UITableView * _tableView;
    UIView * view ;
    UILabel *v_headerLab;
    NSArray *array;

}

@end

@implementation teacherDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [super viewWillAppear:animated];
    [self requestData];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = _nid;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"options.png"] forBarMetrics:UIBarMetricsDefault];
    [self addItem:nil position:Left_Item image:@"Arrow000" action:@selector(pressBtn)];
    [self additems:@"" position:Right_Item image:@"TA的主页.png" action:@selector(goInPerson)];

   [self createFirstView];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 130;
//    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = view;

    
     v_headerLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, MainScreenWidth, 30)];
//    [self requestData];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - 自定义label
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 30)];//创建一个视图（v_headerView）
    UIImageView *v_headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 23)];//创建一个UIimageView（v_headerImageView）
    [v_headerView addSubview:v_headerImageView];//将v_headerImageView添加到创建的视图（v_headerView）中
    v_headerLab.backgroundColor = [UIColor clearColor];//设置v_headerLab的背景颜色
    v_headerLab.textColor = [UIColor darkGrayColor];
    v_headerLab.text = @"课程";
    v_headerLab.font = [UIFont systemFontOfSize:18];//设置v_headerLab的字体样式和大小
    v_headerLab.shadowColor = [UIColor whiteColor];//设置v_headerLab的字体的投影
    [v_headerLab setShadowOffset:CGSizeMake(0, 1)];//设置v_headerLab的字体投影的位置
    [v_headerView addSubview:v_headerLab];
    return v_headerView;
}

//创建讲师介绍view
-(void)createFirstView
{
   
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight-330)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    //头像
    headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 76, 76)];
    headerImage.layer.masksToBounds = YES;
    headerImage.layer.cornerRadius = 38;
    NSString *str = [NSString stringWithFormat:@"%@",_headImage];
    [headerImage setImageWithURL:[NSURL URLWithString:str]];
    [view addSubview:headerImage];
    //姓名
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 15, 80, 30)];
    nameLabel.text = _nid;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:18];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:nameLabel];
    //相关课程
    relatedCourseLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 60, 65, 30)];
    relatedCourseLabel.text = @"相关课程:";
    relatedCourseLabel.textColor = [UIColor darkGrayColor];
    relatedCourseLabel.font = [UIFont systemFontOfSize:15];
    relatedCourseLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:relatedCourseLabel];

    //相关课程数量
      courseCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(163, 60, 15, 30)];
      courseCountLabel.text = _relateCourse;
      courseCountLabel.textColor = [UIColor colorWithRed:16.0/255.0f green:105.0/255.0f blue:165.0/255.0f alpha:1];
      courseCountLabel.font = [UIFont systemFontOfSize:13];
      courseCountLabel.textAlignment = NSTextAlignmentLeft;
      [view addSubview:  courseCountLabel];
 
    //最近课程
    lastCourseLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 60, 65, 30)];
    lastCourseLabel.text = @"最近课程:";
    lastCourseLabel.textColor = [UIColor darkGrayColor];
    lastCourseLabel.font = [UIFont systemFontOfSize:15];
    lastCourseLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:  lastCourseLabel];

    //最近课程名字
    lastCourseNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(255, 60, MainScreenWidth-255, 30)];
    
    lastCourseNameLabel.textColor = [UIColor colorWithRed:16.0/255.0f green:105.0/255.0f blue:165.0/255.0f alpha:1];
    lastCourseNameLabel.font = [UIFont systemFontOfSize:13.5];
    lastCourseNameLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:  lastCourseNameLabel];
    
    //讲师介绍
    teacherIronLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 100,MainScreenWidth-20, view.frame.size.height-100)];
      NSString * urlString = [NSString stringWithFormat:@"%@",_teacherIron];
    NSString *strUrl = [urlString stringByReplacingOccurrencesOfString:@"" withString:@""];
    teacherIronLabel.text = strUrl;
    teacherIronLabel.textColor = [UIColor blackColor];
    teacherIronLabel.font = [UIFont systemFontOfSize:14];
    teacherIronLabel.lineBreakMode = UILineBreakModeWordWrap;
    teacherIronLabel.numberOfLines = 0;
    teacherIronLabel.textAlignment = NSTextAlignmentLeft;
    CGSize size = CGSizeMake(MainScreenWidth-20, 2000);
    CGSize labelSize = [teacherIronLabel.text sizeWithFont:teacherIronLabel.font constrainedToSize:size];
    [view addSubview:teacherIronLabel];

}

- (CGFloat )tableView:(UITableView  *)tableView heightForHeaderInSection:(NSInteger )section
{
    return -40;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray1.count;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[MMProgressHUD dismissWithSuccess:@"" title:@"加载成功"];
    static NSString * CellStr  = @"cell";
    teacherDetailTabelViewCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellStr];
    if (!cell) {
        NSArray * xibArr = [[NSBundle mainBundle]loadNibNamed:@"teacherDetailTabelViewCellTableViewCell" owner:nil options:nil];
        for (id obj in xibArr) {
            cell = (teacherDetailTabelViewCellTableViewCell *)obj;
            break;
        }
        
    }
    NSLog(@"55%@",_dataArray1);
    teacherList * list = _dataArray1[indexPath.row];
    cell.nameLab.text = list.video_title;
    cell.introduceLab.text =list.video_inro;
    cell.watchLab.text = list.video_order_count;
    
    NSString *img = [NSString stringWithFormat:@"%@",array[indexPath.row][@"small_ids"]];
    [cell.imgUrl sd_setImageWithURL:[NSURL URLWithString:img]];
    
    NSMutableDictionary * dic= list.mzprice;
    cell.studyB.text=[NSString stringWithFormat:@"%@元",[dic objectForKey:@"price"]];
        NSString * starStr = [NSString stringWithFormat:@"%@",list.video_score];
    float length = [starStr floatValue]/20;
    [cell.star setStar:length];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"222%@",_dataArray1);
    teacherList * list = _dataArray1[indexPath.row];
    NSMutableDictionary * dic = list.mzprice;
    NSString * str = [dic objectForKey:@"price"];
    classDetailVC * cvc = [[classDetailVC alloc]initWithMemberId:list.cid andPrice:str andTitle:list.video_title];
    cvc.videoTitle = list.video_title;
    NSLog(@"%@",list.imgUrl);
    cvc.img = array[indexPath.row][@"big_ids"];
    cvc.video_address = array[indexPath.row][@"video_address"];
    [self.navigationController pushViewController:cvc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//请求数据
- (void)requestData
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_tid forKey:@"teacher_id"];
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:_relateCourse forKey:@"cateId"];
    [manager getTeacher:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"---->>%@",responseObject);
        _dataArray1 = [responseObject objectForKey:@"data"];
        array = [responseObject objectForKey:@"data"];
        NSMutableArray * listArr = [[NSMutableArray alloc]initWithCapacity:0];
        
        if(IsNilOrNull(_dataArray1))
        {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"没有相关视频" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
            //添加提示
            
            UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(teacherIronLabel.frame) + 100, MainScreenWidth, 50)];
            hintLabel.textColor = [UIColor purpleColor];
            hintLabel.text = @"没有课程";
            hintLabel.font = [UIFont systemFontOfSize:24];
            hintLabel.textAlignment = NSTextAlignmentCenter;
            [view addSubview:hintLabel];
            
        }

        else{
        for (int i=0; i<_dataArray1.count; i++) {
            teacherList * list = [[teacherList alloc]initWithDictionarys:_dataArray1[i]];
            lastCourseNameLabel.text = _dataArray1[0][@"video_title"];
            [listArr addObject:list];
        }
        _dataArray1 = listArr;
        [_tableView reloadData];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//进入主页
- (void)goInPerson
{
    if ([_dataArray1 isEqual:[NSNull null]]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有课程" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    } else {
        MainViewController *mainVC = [[MainViewController alloc] init];
        
        mainVC.array = array;
        [self.navigationController pushViewController:mainVC animated:YES];
    }
   
}
//返回按钮
- (void)pressBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}


//创建右侧按钮
-(void)additems:(NSString *)title position:(item)position image:(NSString *)image action:(SEL)action
{
    UIButton * button = [self button:title image:image frame:CGRectMake(0, 0, 70, 16)];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:button];
    if (position==Right_Item) {
        self.navigationItem.rightBarButtonItem = item;
    }else{
        self.navigationItem.leftBarButtonItem = item;
    }
    
}

//创建btn用于 创建导航按钮时用
-(UIButton *)button:(NSString *)title image:(NSString *)image frame:(CGRect)frame
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    //设置字体大小
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setBackgroundImage:[Helper imageNamed:image cache:YES] forState:UIControlStateNormal];
    return button;
}
//创建导航条上的按钮
-(void)addItem:(NSString *)title position:(item)position image:(NSString *)image action:(SEL)action
{
    UIButton * button = [self button:title image:image frame:CGRectMake(0, 0, 44, 22)];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:button];
    if (position==Left_Item) {
        self.navigationItem.leftBarButtonItem = item;
    }else{
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
