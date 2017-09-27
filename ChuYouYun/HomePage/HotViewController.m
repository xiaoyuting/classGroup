//
//  HotViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/27.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "HotViewController.h"
#import "MJRefresh.h"
#import "QuestionsCell.h"
#import "ZhiyiHTTPRequest.h"
#import "NQBaseClass.h"
#import "UIButton+WebCache.h"
#import "NQWdComment.h"
#import "Passport.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "WDTableViewCell.h"
#import "SYGWDViewController.h"
#import "SYG.h"

@interface HotViewController ()
{
    CGRect rect;
    NSInteger _page;
    NSString *quizPage;
    NSString *_str;
    NSString *_tagid;
}
@end

@implementation HotViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(id)initWithwdType:(NSString *)wdType quizStr:(NSString *)str tagid:(NSString *)tag
{
    self = [super init];
    if (self) {
        quizPage = wdType;
        _str = str;
        _tagid = tag;
    }
    return self;
}


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"一周热门";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 300, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,286)];
    [backButton setTitle:@" " forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    //设置button上字体的偏移量
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10.0 , 0.0, 0)];
    [SYGView addSubview:backButton];
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNav];
    self.navigationItem.title = @"一周热门";
    rect = [UIScreen mainScreen].applicationFrame;
    // Do any additional setup after loading the view.
    self.muArr = [[NSMutableArray alloc ]initWithCapacity:0];
//    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
//    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
//    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, rect.size.width, rect.size.height) style:UITableViewStyleGrouped];
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [self setUpRefresh];
    if (!(quizPage ==nil)) {
        [self reloadNewQuestionOfPage];
    }else if (!(_str==nil))
    {
        [self reloadNewQuestionOfStr:_str];
    }else if (!(_tagid == nil))
    {
        [self reloadNewQuestionOfTag:_tagid];
    }
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
    if (!(quizPage = nil)) {
        [self reloadNewQuestionOfPage];
    }else if(!(_str == nil))
    {
        [self reloadNewQuestionOfStr:_str];
    }else if (!(_tagid == nil))
    {
        [self reloadNewQuestionOfTag:_tagid];
    }

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
        [self.tableview headerEndRefreshing];
    });
}

- (void)footerRefreshing
{
    _page++;
    if (!(quizPage = nil)) {
        [self reloadNewQuestionOfPage];
    }else if(!(_str == nil))
    {
        [self reloadNewQuestionOfStr:_str];
    }else if (!(_tagid == nil))
    {
        [self reloadNewQuestionOfTag:_tagid];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
        [self.tableview footerEndRefreshing];
    });
}
-(void)reloadNewQuestionOfPage
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
//    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
//    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:@"2" forKey:@"wdtype"];
    [dic setObject:[NSString stringWithFormat:@"%ld",_page] forKey:@"page"];
    [dic setObject:[NSString stringWithFormat:@"10"] forKey:@"count"];
    [manager QuizOfHot:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        NSLog(@"err   %@",error);
    }];
}
-(void)reloadNewQuestionOfStr:(NSString *)str
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:_str forKey:@"str"];
    [dic setObject:[NSString stringWithFormat:@"%ld",_page] forKey:@"page"];
    [dic setObject:[NSString stringWithFormat:@"10"] forKey:@"count"];
    [manager QuizOfHot:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        NSLog(@"err   %@",error);
    }];
}
-(void)reloadNewQuestionOfTag:(NSString *)tag
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:_tagid forKey:@"tagid"];
    [dic setObject:[NSString stringWithFormat:@"%ld",_page] forKey:@"page"];
    [dic setObject:[NSString stringWithFormat:@"10"] forKey:@"count"];
    [manager QuizOfHot:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        NSLog(@"err   %@",error);
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDTableViewCell *cell = [self tableView:self.tableview cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height + 30;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"arr   %ld",self.muArr.count);
    return self.muArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellStr = @"WDTableViewCell";
    WDTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (cell == nil) {
        cell = [[WDTableViewCell alloc] initWithReuseIdentifier:cellStr];
    }
    //    NSLog(@"%@",self.muArr);
    if ([self.muArr[indexPath.row][@"userface"] isEqual:[NSNull null]]) {
        
    }else {
        [cell.HeadImage sd_setBackgroundImageWithURL:[NSURL URLWithString:self.muArr[indexPath.row][@"userface"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"站位图"]];
    }
    
    cell.HeadImage.clipsToBounds = YES;
    cell.HeadImage.layer.cornerRadius = 20.0;
    cell.NameLabel.text = [NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"uname"]];
    cell.TimeLabel.text = self.muArr[indexPath.row][@"ctime"];
    [cell setIntroductionText:self.muArr[indexPath.row][@"wd_description"]];
    //图片
    //    [cell imageWithArray:self.muArr[indexPath.row][@"wd_comment"][@"userface"]];
    cell.GKLabel.text = [NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"wd_browse_count"]];
    cell.PLLabel.text = [NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"wd_comment_count"]];
    
    return cell;
 
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"------%@",self.muArr[indexPath.row]);
    SYGWDViewController *SYGWDVC = [[SYGWDViewController alloc] initWithQuizID:self.muArr[indexPath.row][@"id"] title:[NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"wd_title"]] description:[NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"wd_description"]] uname:[NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"uname"]] userface:[NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"userface"]] ctime:[NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"ctime"]]];
    [self.navigationController pushViewController:SYGWDVC animated:YES];

    
}


@end
