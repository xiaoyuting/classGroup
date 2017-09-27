//
//  blumCommentVC.m
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

#import "blumCommentVC.h"
#import "commtenCell.h"
#import "MyHttpRequest.h"
#import "courseNoteModel.h"
#import "UIImageView+WebCache.h"
#import "MakeBlumComment.h"
#import "SYGDPViewController.h"
#import "SYGDPTableViewCell.h"
#import "UIButton+WebCache.h"
#import "DLViewController.h"
#import "UIColor+HTMLColors.h"

@interface blumCommentVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    UILabel *lable;
}
@end

@implementation blumCommentVC
-(id)initWithId:(NSString *)Id
{
    if (self=[super init]) {
        _blum_id = Id;
        
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
    if (iPhone4SOriPhone4) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-290+145 - 200 + 50) style:UITableViewStylePlain];
    }
    if (iPhone5o5Co5S) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-300+145 - 200 + 50) style:UITableViewStylePlain];
    }
    else if (iPhone6)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-380+145 - 200 + 50) style:UITableViewStylePlain];
    }
    else if (iPhone6Plus)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-430+145 -200 + 50) style:UITableViewStylePlain];
    }else {//ipad 适配
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-430+145 -200 + 50) style:UITableViewStylePlain];
    }

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    lable = [[UILabel alloc]initWithFrame:CGRectMake(0,50*MainScreenHeight/667,MainScreenWidth, 14)];
    [_tableView insertSubview:lable atIndex:0];
    lable.text = @"数据为空，刷新重试";
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor clearColor];
    [self requestData];
}

- (void)requestData
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"100" forKey:@"count"];
    [dic setValue:_blum_id forKey:@"kzid"];
    [dic setValue:@"2" forKey:@"kztype"];
    [dic setValue:@"2" forKey:@"type"];
    [manager getClassNoteAndQuestionAndComment:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"-------%@",responseObject);
        _dataArray = [responseObject objectForKey:@"data"];
        NSMutableArray * listArr = [[NSMutableArray alloc]initWithCapacity:0];
        if (IsNilOrNull(_dataArray)) {
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 50)];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 200)];
            imageView.image = [UIImage imageNamed:@"点评@2x"];
            [view addSubview:imageView];
            _tableView.tableFooterView = view;
        }
        else
        {
            for (int i=0; i<_dataArray.count; i++) {
                courseNoteModel * list = [[courseNoteModel alloc]initWithDictionarys:_dataArray[i]];
                [listArr addObject:list];
            }
            _dataArray=listArr;
            [_tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog ( @"operation: %@" , operation. responseString);
        NSString *hh = @"\u8ba4\u8bc1\u5931\u8d25";
        NSLog(@"%@",hh);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count==0) {
        lable.textColor = [UIColor colorWithHexString:@"#dedede"];
        
    }else{
        lable.textColor = [UIColor clearColor];
    }
    if (IsNilOrNull(_dataArray)) {
        return 0;
    }
        return _dataArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    courseNoteModel * list = _dataArray[indexPath.row];
//    NSString * labelstr = list.review_description;
//    
//    CGSize labelSize = {0,0};
//    labelSize = [labelstr sizeWithFont:[UIFont systemFontOfSize:14]
//                 
//                     constrainedToSize:CGSizeMake(225.0, 5000)
//                 
//                         lineBreakMode:UILineBreakModeWordWrap];
//    return labelSize.height+90;
    UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height + 40;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    courseNoteModel * list = _dataArray[indexPath.row];
    
    static NSString * cellStr = @"cellSYG";
    SYGDPTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (cell == nil) {
        cell = [[SYGDPTableViewCell alloc] initWithReuseIdentifier:cellStr];
    }
    
    [cell.HeadImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:list.userFace] forState:UIControlStateNormal];
    cell.NameLabel.text = list.userName;
    
    //计算星级
    NSString * starStr = [NSString stringWithFormat:@"%@",list.star];
    float length = [starStr floatValue];
    if (length == 1) {
        
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"101@2x"] forState:UIControlStateNormal];
    }
    
    if (length == 2) {
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"102@2x"] forState:UIControlStateNormal];
    } else {
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"105@2x"] forState:UIControlStateNormal];
        
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
    
    cell.TimeLabel.text = result;
    [cell setIntroductionText:list.review_description];
    cell.DZLabel.text = list.review_comment_count;
    
    int c=[list.isvote intValue];
    if (c==0) {
        [cell.DZButton setImage:[UIImage imageNamed:@"棒@2x"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.DZButton setImage:[UIImage imageNamed:@"已棒@2x"] forState:UIControlStateNormal];
    }

    [cell.DZButton addTarget:self action:@selector(DZClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.DZButton.tag = indexPath.row;
    
    return cell;
}

#pragma ------点赞
- (void)DZClicked:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    courseNoteModel * list = _dataArray[btn.tag];
    int c=[list.isvote intValue];
    if (c==1) {
        QKHTTPManager * manager = [QKHTTPManager manager];
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:list.review_id forKey:@"kzid"];
        [dic setValue:@"1" forKey:@"type"];
        
        [manager getClassIsvote:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            [self requestData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    else if (c==0)
    {
        QKHTTPManager * manager = [QKHTTPManager manager];
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:list.review_id forKey:@"kzid"];
        [dic setValue:@"0" forKey:@"type"];
        [manager getClassIsvote:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            [self requestData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               NSLog ( @"operation: %@" , operation. responseString);
        }];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton * v_headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    v_headerBtn.frame = CGRectMake(MainScreenWidth-70, 10, 85, 22);
    UIView *v_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 30)];//创建一个视图（v_headerView）
    [v_headerBtn setImage:[UIImage imageNamed:@"552cc17f5bb87_32@2x.png"] forState:UIControlStateNormal];
    [v_headerBtn addTarget:self action:@selector(MakeCommentBtn) forControlEvents:UIControlEventTouchUpInside];
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


- (void)MakeCommentBtn
{

    //判断是否登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];

        
    }else {
        SYGDPViewController *SYGDPVC = [[SYGDPViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:SYGDPVC];
        SYGDPVC.ID = self.blum_id;
        SYGDPVC.isBlumStr = @"SYG";
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
    }

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
