//
//  GLClassViewController.m
//  dafengche
//
//  Created by IOS on 16/12/12.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "GLClassViewController.h"
#import "MyHttpRequest.h"
#import "teacherList.h"
#import "classTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "MJRefreshBaseView.h"
#import "LiveDetailsViewController.h"
#import "classViewController.h"
#import "SYGClassTool.h"
#import "SYGClassTableViewCell.h"
#import "UIButton+WebCache.h"
#import "GLReachabilityView.h"
#import "UIColor+HTMLColors.h"
#import "classClassifyVc.h"
#import "blumViewController.h"
#import "LiveCategorryViewController.h"
#import "MBProgressHUD+Add.h"
#import "AppDelegate.h"
#import "classDetailVC.h"
#import "MBProgressHUD+Add.h"
#import "GLLiveTableViewCell.h"
#import "ClassRevampCell.h"
#import "SYG.h"
#import "UIButton+WebCache.h"
#import "Passport.h"


#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define iOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

@interface GLClassViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray * dataArray2;
    classViewController * cvc;
    UIView *_view;
    UILabel *_lable;
    NSString *_title;
    NSString *_teacher_id;
}
@property(nonatomic,assign)NSInteger numder;

@end

@implementation GLClassViewController

- (instancetype)initWithData:(NSArray *)arr title:(NSString *)title teacher_id:(NSString *)teacher_id
{
    if (self=[super init]) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObjectsFromArray:arr];
        _title = title;
        _teacher_id = teacher_id;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)requestData:(NSInteger)num {
    
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    //    [dic setValue:[NSNumber numberWithInteger:num] forKey:@"page"];
    [dic setValue:@"20" forKey:@"count"];
    [dic setValue:[NSString stringWithFormat:@"%ld",num] forKey:@"page"];
//    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
//    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [manager getpublicPort:dic mod:@"Teacher" act:@"teacherVideoList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray * array = [responseObject objectForKey:@"data"];
        
        if (num == 1) {
            if (array.count) {
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:array];
            }
        }else{

            
            if (array.count) {
            
            [_dataArray addObjectsFromArray:array];
            
        }else{
            
            [MBProgressHUD showError:@"没有更多数据" toView:self.view];
        }
    }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView reloadData];
    }];
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
    
    //创建view
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    NSInteger num = _title.length;
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"讲师全部课程";
    [navView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 30+17*num, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,16+17*num)];
    [backButton setTitle:@" " forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    //设置button上字体的偏移量
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10.0 , 0.0, 0)];
    [navView addSubview:backButton];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, MainScreenWidth, MainScreenHeight - 64 + 10) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 110;
    _tableView.showsVerticalScrollIndicator = NO;
    _lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 100,MainScreenWidth, 15)];
    [_tableView addSubview:_lable];
    [_tableView insertSubview:_lable atIndex:0];
    _lable.font = [UIFont systemFontOfSize:14];
    _lable.text = @"数据为空";
    _lable.textAlignment = NSTextAlignmentCenter;
    _lable.textColor = [UIColor clearColor];
    _lable.hidden = YES;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    //下拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [_tableView headerBeginRefreshing];
    
    //上拉加载
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
//    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,5,0,0)];
//    }
    
    //设置表格分割线的长度（跟两边的距离）
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,2,0,0)];
    }
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [navView addSubview:lineLab];
}

- (void)headerRerefreshing
{
    _numder = 1;
    [self requestData:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        
        if (_dataArray.count==0) {
            
            _lable.textColor = [UIColor colorWithHexString:@"#dedede"];
            
        }else{
            
            _lable.textColor = [UIColor clearColor];
        }
    });
}

- (void)footerRefreshing
{
    //先隐藏
    _numder++;
    [self requestData:_numder];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
}

- (void)backPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)gokind{
    
    NSArray *arr = @[@"ios",@"java",@"phh"];
    LiveCategorryViewController * vc = [[LiveCategorryViewController alloc]initwithTitle:@"直播" array:arr id:@"2"];
    rootViewController * ntvc;

    [ntvc isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellID = @"cellClass";
    //自定义cell类
    ClassRevampCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //自定义cell类
    if (cell == nil) {
        cell = [[ClassRevampCell alloc] initWithReuseIdentifier:CellID];
    }
    
    NSDictionary *dict = _dataArray[indexPath.row];
    
    NSLog(@"%@",dict);
    NSString *urlStr = dict[@"imageurl"];
    [cell.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
    
    if ([[dict stringValueForKey:@"is_tlimit"] integerValue] == 0) {
        cell.audition.hidden = YES;
        cell.titleLabel.frame = CGRectMake(CGRectGetMaxX(cell.imageButton.frame) + 13, 13, MainScreenWidth - 100, 14);
    } else {//试听
        cell.audition.hidden = NO;
    }
    
    cell.titleLabel.text = dict[@"video_title"];
    
    NSString *introStr = [self filterHTML:dict[@"user"][@"uname"]];
    cell.teacherLabel.text = introStr;
    if (dict[@"teacher_name"] == nil ) {
        cell.teacherLabel.text = @"老师：";
    } else {
        cell.teacherLabel.text = [NSString stringWithFormat:@"老师：%@",dict[@"teacher_name"]];
    }
    cell.studyNum.text = [NSString stringWithFormat:@"报名人数：%@",dict[@"video_order_count"]];
    
    NSString *timeStr = [Passport formatterDate:dict[@"ctime"]];
    NSString *sectionStr = [NSString stringWithFormat:@"%@",dict[@"video_comment_count"]];
    NSString *priceStr = [NSString stringWithFormat:@"%@",dict[@"mzprice"][@"price"]];
    
    NSInteger type = 1;
    if (type == 1) {
        cell.kinsOf.text = [NSString stringWithFormat:@"章节数：%@  ¥：%@ ",sectionStr,priceStr];
        
    } else if (type == 2) {
        cell.kinsOf.text = [NSString stringWithFormat:@"%@开课  ¥：%@ ",timeStr,priceStr];
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *Title = _dataArray[indexPath.row][@"video_title"];
    classDetailVC *cvc = [[classDetailVC alloc]initWithMemberId:_dataArray[indexPath.row][@"id"] andPrice:_dataArray[indexPath.row][@"v_price"] andTitle:Title];
    cvc.img = _dataArray[indexPath.row][@"imageurl"];
    [self.navigationController pushViewController:cvc animated:YES];
}
//去掉HTML字符
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];

        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    }
    return html;
}

@end
