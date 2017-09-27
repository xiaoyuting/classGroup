//
//  questionVC.m
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
#import "questionVC.h"
#import "questionCell.h"
#import "UIImageView+WebCache.h"
#import "MyHttpRequest.h"
#import "courseNoteModel.h"
@interface questionVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
}
@end

@implementation questionVC
- (id)initWithId:(NSString *)Id
{
    if (self=[super init]) {
        _course_id = Id;
    }
    return self;
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
        _dataArray = [responseObject objectForKey:@"data"];
        NSMutableArray * listArr = [[NSMutableArray alloc]initWithCapacity:0];
        if (IsNilOrNull(_dataArray)) {
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
            for (int i = 0; i<_dataArray.count; i++) {
                courseNoteModel * list = [[courseNoteModel alloc]initWithDictionarys:_dataArray[i]];
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

      courseNoteModel * list     = _dataArray[indexPath.row];
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
    courseNoteModel * list = _dataArray[indexPath.row];
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
    courseNoteModel * list = _dataArray[button.tag];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
