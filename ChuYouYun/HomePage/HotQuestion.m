//
//  HotQuestion.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/24.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "HotQuestion.h"
#import "ZhiyiHTTPRequest.h"
#import "MJRefresh.h"
#import "QuestionsCell.h"
#import "NQBaseClass.h"
#import "UIButton+WebCache.h"
#import "Passport.h"
#import "NQWdComment.h"
#import "NQTags.h"
#import "QuizDetailViewController.h"
#import "ZRWendaTool.h"
#import "WDTableViewCell.h"
#import "ImageCell.h"
#import "emotionjiexi.h"
#import "SYGWDViewController.h"
#import "UIColor+HTMLColors.h"
#import "MBProgressHUD+Add.h"


#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define iOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]

@interface HotQuestion ()
{
    CGRect rect;
    NSInteger _page;
    UILabel *_lable;
    
}
@end

@implementation HotQuestion

-(void)viewWillAppear:(BOOL)animated
{
    
}
-(id)initWithwdType:(NSString *)wdType
{
    self = [super init];
    if (self) {
        self.wdType = wdType;
        NSLog(@"=====+======%@",wdType);
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    rect = [UIScreen mainScreen].applicationFrame;
    self.muArr = [[NSMutableArray alloc ]initWithCapacity:0];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height - 40) style:UITableViewStyleGrouped];
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [self setUpRefresh];
    _lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 100,MainScreenWidth, 15)];
    [self.tableview addSubview:_lable];
    [self.tableview insertSubview:_lable atIndex:0];
    _lable.text = @"数据为空，刷新重试";
    _lable.textAlignment = NSTextAlignmentCenter;
    _lable.font = [UIFont systemFontOfSize:14];
    _lable.textColor = [UIColor clearColor];
    
    //这里重复刷新了 （刷新了两次）
//    if (self.wdType == nil) {
//        [self reloadNewQuestionOfPage:_page];
//    }else
//    {
//        [self reloadForNewQuestionOfPage:_page];
//    }
}
-(void)setUpRefresh
{
    //下拉刷新
    [self.tableview addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [self.tableview headerBeginRefreshing];
    
    //上拉加载
    [self.tableview addFooterWithTarget:self action:@selector(footerRefreshing)];
}

- (void)headerRerefreshing
{
    if (self.wdType == nil) {
        [self reloadNewQuestionOfPage:1];
    }else
    {
        [self reloadForNewQuestionOfPage:1];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
        [self.tableview headerEndRefreshing];
        if (self.muArr.count==0) {
            _lable.textColor = [UIColor colorWithHexString:@"#dedede"];
            
        }else{
            _lable.textColor = [UIColor clearColor];
        }

    });
}

- (void)footerRefreshing
{
    _page++;
    if (self.wdType == nil) {
        [self reloadNewQuestionOfPage:_page];
    }else
    {
        [self reloadForNewQuestionOfPage:_page];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
        [self.tableview footerEndRefreshing];
    });
}
-(void)reloadNewQuestionOfPage:(NSInteger)page
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:@"2" forKey:@"type"];
    [dic setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    [dic setObject:@"100" forKey:@"count"];
    
    NSArray *ZRArray = [ZRWendaTool wendaWithDic:dic];
    
    
    [manager reloadNewQuesttion:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"_________%@",responseObject);
        if (ZRArray.count) {
            NSLog(@"需不需");
        } else {
            [ZRWendaTool saveWendaes:responseObject[@"data"]];

        }
        
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"还没有最热的问题" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        } else {
            _userArray = responseObject[@"data"];
            NSMutableArray *muarr = [[NSMutableArray alloc]initWithCapacity:0];
            NSArray *arr = [NSArray arrayWithArray:[responseObject objectForKey:@"data"]];
            if (arr == 0) {
                return;
            }
            for (int i = 0; i <arr.count; i++) {
                NSDictionary *NB = [[NSDictionary alloc]initWithDictionary:[arr objectAtIndex:i]];
                [muarr addObject:NB];
            }
            
            if (page == 1) {
                self.muArr = [NSMutableArray arrayWithArray:_userArray];
                
            }else {
                NSArray *SYGArray = [NSArray arrayWithArray:_userArray];
                [self.muArr addObjectsFromArray:SYGArray];
                
            }

            [_tableview reloadData];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"--------%@",ZRArray);
        //self.muArr = ZRArray;
        //[_tableview reloadData];
    }];

    
}
-(void)reloadForNewQuestionOfPage:(NSInteger)page
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:self.wdType forKey:@"wdtype"];
    [dic setObject:@"2" forKey:@"type"];
    [dic setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    [dic setObject:@"20" forKey:@"count"];
    
    
    NSLog(@"%@",dic);
    [manager reloadNewQuesttion:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSMutableArray *muarr = [[NSMutableArray alloc]initWithCapacity:0];
        NSArray *arr = [NSArray arrayWithArray:[responseObject objectForKey:@"data"]];
        if (arr == 0) {
            return;
        }
        for (int i = 0; i <arr.count; i++) {
            NSDictionary *NB = [[NSDictionary alloc]initWithDictionary:[arr objectAtIndex:i]];
            [muarr addObject:NB];
        }
        self.muArr = muarr;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"数据加载失败" toView:self.view];

    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.muArr.count > 5) {
        self.tableview.showsVerticalScrollIndicator = NO;
    }
   
    return self.muArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDTableViewCell *cell = [self tableView:self.tableview cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height + 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellStr = @"WDTableViewCell";
    WDTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (cell == nil) {
        cell = [[WDTableViewCell alloc] initWithReuseIdentifier:cellStr];
    }
//    NSLog(@"%@",self.muArr);
    [cell.HeadImage sd_setBackgroundImageWithURL:[NSURL URLWithString:self.muArr[indexPath.row][@"userface"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"站位图"]];
    cell.HeadImage.clipsToBounds = YES;
    cell.HeadImage.layer.cornerRadius = 20.0;
    cell.NameLabel.text = self.muArr[indexPath.row][@"uname"];
//    cell.TimeLabel.text = [Passport formatterDate:self.muArr[indexPath.row][@"ctime"]];
    cell.TimeLabel.text = self.muArr[indexPath.row][@"ctime"];
    [cell setIntroductionText:self.muArr[indexPath.row][@"wd_description"]];
    //图片
    //    [cell imageWithArray:self.muArr[indexPath.row][@"wd_comment"][@"userface"]];
    cell.GKLabel.text = self.muArr[indexPath.row][@"wd_browse_count"];
    cell.PLLabel.text = self.muArr[indexPath.row][@"wd_comment_count"];

    NSString *HTMLStr = [self filterHTML:self.muArr[indexPath.row][@"wd_description"]];
    
    
    cell.JTLabel.attributedText = [emotionjiexi jiexienmojconent:HTMLStr font:[UIFont systemFontOfSize:16]];
    
//    NSMutableArray *HH = [ImageCell ImageCellWithString:HTMLStr];
//    NSLog(@"%@",HH);

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:[self.muArr objectAtIndex:indexPath.row]];
    NSString *userId = dic[@"id"];
    SYGWDViewController *SYGWDVC = [[SYGWDViewController alloc] initWithQuizID:userId title:[NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"wd_title"]] description:[NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"wd_description"]] uname:[NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"uname"]] userface:[NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"userface"]] ctime:[NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"ctime"]]];
    [self.navigationController pushViewController:SYGWDVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

//去掉HTML字符
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    // NSString * regEx = @"<([^>]*)>";
    // html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}




@end
