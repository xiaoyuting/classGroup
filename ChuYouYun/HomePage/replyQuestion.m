//
//  replyQuestion.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/24.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "replyQuestion.h"
#import "ZhiyiHTTPRequest.h"
#import "MJRefresh.h"
#import "QuestionsCell.h"
#import "NQBaseClass.h"
#import "UIButton+WebCache.h"
#import "Passport.h"
#import "NQWdComment.h"
#import "NQTags.h"
#import "QuizDetailViewController.h"
#import "WHFWendaTool.h"
#import "WDTableViewCell.h"
#import "SYGWDViewController.h"
#import "UIColor+HTMLColors.h"
#import "MBProgressHUD+Add.h"


#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define iOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]


@interface replyQuestion ()
{
    CGRect rect;
    NSInteger _page;
    UILabel *_lable;

}
@end

@implementation replyQuestion

-(void)viewWillAppear:(BOOL)animated
{
    
}
-(id)initWithwdType:(NSString *)wdType
{
    self = [super init];
    if (self) {
        self.wdType = wdType;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
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
    //_lable.text = @"数据为空，刷新重试";
    _lable.textAlignment = NSTextAlignmentCenter;
    _lable.font = [UIFont systemFontOfSize:14];
    _lable.textColor = [UIColor clearColor];
    _lable.hidden = YES;
    
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
    [dic setObject:@"3" forKey:@"type"];
    [dic setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    [dic setObject:@"20" forKey:@"count"];
    
    NSArray *WHFArray = [WHFWendaTool wendaWithDic:dic];
    
    [manager reloadNewQuesttion:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"hh%@",responseObject);
        if (WHFArray.count) {
            NSLog(@"你好哈");
        } else {
             [WHFWendaTool saveWendaes:responseObject[@"data"]];
        }
       
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {
            _tableview.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kong"]];

        } else {
            _allArray = responseObject[@"data"];
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
                self.muArr = [NSMutableArray arrayWithArray:_allArray];
                
            }else {
                NSArray *SYGArray = [NSArray arrayWithArray:_allArray];
                [self.muArr addObjectsFromArray:SYGArray];
                
            }

            [_tableview reloadData];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // self.muArr = WHFArray;
        //[_tableview reloadData];
        [MBProgressHUD showError:@"数据加载失败" toView:self.view];

        
    }];

}



-(void)reloadForNewQuestionOfPage:(NSInteger)page
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:self.wdType forKey:@"wdtype"];
    [dic setObject:@"3" forKey:@"type"];
    [dic setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    [dic setObject:@"10" forKey:@"count"];
    [manager reloadNewQuesttion:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {

    if (![responseObject[@"data"] count]) {
        _tableview.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kong"]];
        _lable.textColor = [UIColor clearColor];

        }
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
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.muArr.count > 5) {
        self.tableview.showsVerticalScrollIndicator = NO;
    }
    
    return self.muArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 3;
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

    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:[self.muArr objectAtIndex:indexPath.row]];
    NSString *userId = dic[@"id"];
//    QuizDetailViewController *q = [[QuizDetailViewController alloc] initWithQuizID:userId title:[NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"wd_title"]] description:[NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"wd_description"]] uname:[NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"uname"]] userface:[NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"userface"]] ctime:[NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"ctime"]]];
//    [self.navigationController pushViewController:q animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    SYGWDViewController *SYGWDVC = [[SYGWDViewController alloc] initWithQuizID:userId title:[NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"wd_title"]] description:[NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"wd_description"]] uname:[NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"uname"]] userface:[NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"userface"]] ctime:[NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"ctime"]]];
    [self.navigationController pushViewController:SYGWDVC animated:YES];
    
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
