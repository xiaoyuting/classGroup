//
//  playQuestonVC.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/6.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define ViewBackColor [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1]
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4,4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕


#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕

#define iPhone6PlusBIG ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus放大版屏幕
#import "playQuestonVC.h"
#import "questionCell.h"
#import "MyHttpRequest.h"
#import "courseNoteModel.h"
#import "UIImageView+WebCache.h"
#import "MakeQuestions.h"
@interface playQuestonVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    NSMutableArray * dataArray;
}
@end

@implementation playQuestonVC
-(id)initWithId:(NSString *)Id
{
    if (self=[super init]) {
        _course_id = Id;
        NSLog(@"``````````````%@",_course_id);
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self requestData];
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBackColor;
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    if (iPhone4SOriPhone4) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-290+145 - 200) style:UITableViewStylePlain];
    }
    if (iPhone5o5Co5S) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-300+145 - 200) style:UITableViewStylePlain];
    }
    else if (iPhone6)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-380+145 - 200) style:UITableViewStylePlain];
    }
    else if (iPhone6Plus)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-430+145 - 200) style:UITableViewStylePlain];
    }
    
    _tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
    [self requestData];

}

- (void)requestData
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:@"1" forKey:@"kztype"];
    [dic setValue:_course_id forKey:@"kzid"];
    [dic setValue:@"1" forKey:@"type"];
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"100" forKey:@"count"];
    [manager getClassNoteAndQuestionAndComment:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"()()()()()()_(%@",responseObject);
        dataArray = [responseObject objectForKey:@"data"];
        NSMutableArray * listArr = [[NSMutableArray alloc]initWithCapacity:0];
        if (IsNilOrNull(dataArray)) {
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 50)];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(MainScreenWidth/2-60, 3, MainScreenWidth, 30)];
            label.text = @"骚年，快来提个问题吧!";
            label.textColor = [UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1];
            label.font = [UIFont systemFontOfSize:15];
            [view addSubview:label];
            _tableView.tableFooterView = view;
        }
        else
        {
            for (int i = 0; i<dataArray.count; i++) {
                courseNoteModel * list = [[courseNoteModel alloc]initWithDictionarys:dataArray[i]];
                [listArr addObject:list];
            }
            dataArray=listArr;
            [_tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (IsNilOrNull(dataArray)) {
        return 0;
    }
    return dataArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    courseNoteModel * list = dataArray[indexPath.row];
    NSString * labelstr = list.qst_description;
    
    CGSize labelSize = {0,0};
    labelSize = [labelstr sizeWithFont:[UIFont systemFontOfSize:14]
                 
                     constrainedToSize:CGSizeMake(225.0, 5000)
                 
                         lineBreakMode:UILineBreakModeWordWrap];
    return labelSize.height+90;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellStr = @"cell";
    questionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        NSArray * xibArr = [[NSBundle mainBundle]loadNibNamed:@"questionCell" owner:nil options:nil];
        for (id obj in xibArr) {
            cell = (questionCell *)obj;
            break;
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    courseNoteModel * list = dataArray[indexPath.row];
    [cell.iconImg setImageWithURL:[NSURL URLWithString:list.userFace]];
    cell.iconImg.layer.cornerRadius = 31;
    cell.iconImg.layer.masksToBounds = YES;
    cell.nameLb.text = list.userName;
    cell.noteTitle.text = list.qst_title;
    //时间戳转化
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
    
    cell.timeLab.text = result;
    cell.contentLab.numberOfLines=0;
    cell.contentLab.text = list.qst_description;
    cell.note_count.text = list.qst_comment_count;
    cell.DZ_count.text = list.qst_help_count;
    [cell.TongWenButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.TongWenButton.tag= indexPath.row;
    
    return cell;
}


- (void)buttonClicked:(id)sender
{
    UIButton * button = (UIButton *)sender;
    courseNoteModel * list = dataArray[button.tag];
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:list.qst_id forKey:@"rid"];
    [dic setValue:@"1" forKey:@"type"];
    [manager getClassNoteAndQuestionVote:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"data"] intValue]==1)
        {
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
    v_headerBtn.frame = CGRectMake(MainScreenWidth-100, 10, 87, 22);
    UIView *v_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 30)];//创建一个视图（v_headerView）
    [v_headerBtn setImage:[UIImage imageNamed:@"AQ.png"] forState:UIControlStateNormal];
    [v_headerBtn addTarget:self action:@selector(questionBtn) forControlEvents:UIControlEventTouchUpInside];
    [v_headerView addSubview:v_headerBtn];
    return v_headerView;
}

- (void)questionBtn
{
    MakeQuestions * qvc = [[MakeQuestions alloc]init];
    qvc.courseId = _course_id;
    [self.navigationController pushViewController:qvc animated:YES];
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
