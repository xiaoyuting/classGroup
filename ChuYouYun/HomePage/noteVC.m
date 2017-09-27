//
//  noteVC.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/30.
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
#import "noteVC.h"
#import "MyHttpRequest.h"
#import "noteAndQuestionAndCommentCell.h"
#import "UIImageView+WebCache.h"
#import "courseNoteModel.h"
#import "MJRefresh.h"
#import "SYGNoteViewController.h"
#import "DLViewController.h"
#import "BJXQViewController.h"
#import "Passport.h"



@interface noteVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    
    NSDate * date;
    BOOL _isSelf;
}
@property(nonatomic,assign)NSInteger page;

@property (strong ,nonatomic)NSString *resultStr;

@property (strong ,nonatomic)UIImageView *imageView;

@end

@implementation noteVC

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self requestData];
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (id)initWithId:(NSString *)Id isSelf:(BOOL)isSelf
{
    if (self=[super init]) {
        _course_id = Id;
        _isSelf = isSelf;
    }
    return self;
}


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"点评返回@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"笔记";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNav];
    self.view.backgroundColor = ViewBackColor;
    if (_isSelf == YES) {
         _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight-64) style:UITableViewStylePlain];
    }else{
    if (iPhone4SOriPhone4) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-290+145 - 200) style:UITableViewStylePlain];
    }
    if (iPhone5o5Co5S) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-300+145 - 200) style:UITableViewStylePlain];
    }
    else if (iPhone6)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStylePlain];
    }
    else if (iPhone6Plus)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-430+145 - 200) style:UITableViewStylePlain];
    }
}
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    [self.view addSubview:_tableView];
     _tableView.tableFooterView = [[UIView alloc] init];
   [self requestData];
  
}

- (void)requestData
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:@"1" forKey:@"kztype"];
    [dic setValue:_course_id forKey:@"kzid"];
    [dic setValue:@"3" forKey:@"type"];
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"6" forKey:@"count"];
    [manager getClassNoteAndQuestionAndComment:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray * array = [responseObject objectForKey:@"data"];
        if (IsNilOrNull(array)) {
//            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 50)];
//            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(MainScreenWidth/2-60, 3, MainScreenWidth, 30)];
//            label.text = @"观看课程后才能记笔记！";
//            label.textColor = [UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1];
//            label.font = [UIFont systemFontOfSize:15];
//            [view addSubview:label];
//            _tableView.tableFooterView = view;
            
            
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, MainScreenWidth, MainScreenHeight - 100)];
            imageView.image = [UIImage imageNamed:@"笔记@2x"];
            [self.view addSubview:imageView];
            _imageView = imageView;
            _imageView.hidden = NO;
            
        }
        else
        {
            
            _imageView.hidden = YES;
            
            NSMutableArray * listArr = [[NSMutableArray alloc]initWithCapacity:0];
            for (int i = 0; i<array.count; i++) {
                courseNoteModel * list = [[courseNoteModel alloc]initWithDictionarys:array[i]];
                [listArr addObject:list];
            }
            _dataArray=listArr;
            [_tableView reloadData];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (IsNilOrNull(_dataArray)) {
        return 0;
    }
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    courseNoteModel * list = _dataArray[indexPath.row];
    NSString * labelstr = list.note_description;
    
    CGSize labelSize = {0,0};
    labelSize = [labelstr sizeWithFont:[UIFont systemFontOfSize:14]
                 
                     constrainedToSize:CGSizeMake(225.0, 5000)
                 
                         lineBreakMode:UILineBreakModeWordWrap];
    return labelSize.height+100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellStr = @"cell";
    noteAndQuestionAndCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        NSArray * xibArr = [[NSBundle mainBundle]loadNibNamed:@"noteAndQuestionAndCommentCell" owner:nil options:nil];
        for (id obj in xibArr) {
            cell = (noteAndQuestionAndCommentCell *)obj;
            break;
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    courseNoteModel * list = _dataArray[indexPath.row];
    [cell.iconImg setImageWithURL:[NSURL URLWithString:list.userFace]];
    cell.iconImg.layer.cornerRadius = 31;
    cell.iconImg.layer.masksToBounds = YES;
    cell.nameLb.text = list.userName;
    cell.noteTitle.text = list.note_title;
    //时间差计算
    NSDate * dt = [NSDate dateWithTimeIntervalSince1970:[list.note_time floatValue]];
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *regStr = [df stringFromDate:dt];
    NSTimeInterval  timeInterval = [dt timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        
        result = [NSString stringWithFormat:@"刚刚"];
        
    }
    else if((temp = timeInterval/60) <60){
        
        result = [NSString stringWithFormat:@"%ld分前",temp];
        
    }
    else if((temp = temp/60) <24){
        
        result = [NSString stringWithFormat:@"%ld小时前",temp];
        
    }
    else if((temp = temp/24) <30){
        
        result = [NSString stringWithFormat:@"%ld天前",temp];
        
    }
    else {
        
        result = regStr;
    }
    
//    cell.timeLab.text = result;
    
    //设置时间
    _resultStr = result;
    
    cell.timeLab.text = [Passport formatterDate:list.note_time];
    
    cell.contentLab.numberOfLines=0;
    cell.contentLab.text = list.note_description;
    cell.note_count.text = list.note_comment_count;
    cell.DZ_count.text = list.note_help_count;
    [cell.DZButton addTarget:self action:@selector(buttonClickeds:) forControlEvents:UIControlEventTouchUpInside];
    cell.DZButton.tag = indexPath.row;
    return cell;
}


- (void)buttonClickeds:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    courseNoteModel * list = _dataArray[btn.tag];
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:list.note_id forKey:@"rid"];
    [dic setValue:@"2" forKey:@"type"];
    [manager getClassNoteAndQuestionVote:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"data"] intValue]==1){
        [btn setImage:[UIImage imageNamed:@"Like00_pressed"] forState:UIControlStateNormal];
            [self requestData];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
  
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

#pragma mark - 自定义分区标题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton * v_headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    v_headerBtn.frame = CGRectMake(MainScreenWidth-70, 10, 85, 22);
    UIView *v_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 30)];//创建一个视图（v_headerView）
    [v_headerBtn setImage:[UIImage imageNamed:@"552cc17f5bb87_32@2x.png"] forState:UIControlStateNormal];
    [v_headerBtn addTarget:self action:@selector(MakeNoteBtn) forControlEvents:UIControlEventTouchUpInside];
    [v_headerView addSubview:v_headerBtn];
    return v_headerView;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    courseNoteModel * list = _dataArray[indexPath.row];
    NSString *timeStr = [Passport formatterDate:list.note_time];
    BJXQViewController *BJXQVC = [[BJXQViewController alloc] init];
    BJXQVC.ID = list.note_id;
    BJXQVC.headStr = list.userFace;
    BJXQVC.nameStr = list.userName;
    BJXQVC.timeStr = timeStr;
    BJXQVC.JTStr = list.note_description;
    BJXQVC.titleStr = list.note_title;
    
    [self.navigationController pushViewController:BJXQVC animated:YES];
    
}

- (void)MakeNoteBtn
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
        
    }
    
    SYGNoteViewController *SYGNoteVC = [[SYGNoteViewController alloc] init];
    SYGNoteVC.courseID = self.course_id;
    UINavigationController *SYGNav = [[UINavigationController alloc] initWithRootViewController:SYGNoteVC];
    [self presentViewController:SYGNav animated:YES completion:nil];
}



@end
