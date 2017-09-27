//
//  NewQuestion.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/23.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "NewQuestion.h"
#import "ZhiyiHTTPRequest.h"
#import "MJRefresh.h"
#import "QuestionsCell.h"
#import "NQBaseClass.h"
#import "UIButton+WebCache.h"
#import "Passport.h"
#import "NQWdComment.h"
#import "NQTags.h"
#import "QuizDetailViewController.h"
#import "ZXWendaTool.h"
#import "WDTableViewCell.h"
#import "emotionjiexi.h"
#import "ImageCell.h"
#import "SYGWDViewController.h"
#import "GLReachabilityView.h"
#import "UIColor+HTMLColors.h"
#import "MBProgressHUD+Add.h"


#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define iOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define checkNull(__X__)        (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]

@interface NewQuestion ()
{
    CGRect rect;
    NSInteger _page;
    UIView *_view;
    UILabel *_lable;
}
@end

@implementation NewQuestion
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self setUpRefresh];
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
    
    _view = (UIView *)[GLReachabilityView popview];
    [self.view addSubview:_view];
    rect = [UIScreen mainScreen].applicationFrame;

    // Do any additional setup after loading the view.
    self.muArr = [[NSMutableArray alloc ] initWithCapacity:0];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height-99 - 16 + 50 - 70) style:UITableViewStyleGrouped];
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [self.view addSubview:_tableview];
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableview.separatorColor = [UIColor clearColor];
    _lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 100,MainScreenWidth, 15)];
    [self.tableview addSubview:_lable];
    [self.tableview insertSubview:_lable atIndex:0];
    _lable.text = @"数据为空，刷新重试";
    _lable.textAlignment = NSTextAlignmentCenter;
    _lable.font = [UIFont systemFontOfSize:14];
    _lable.textColor = [UIColor clearColor];
    [self setUpRefresh];
    
    //这里刷新了两次
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
    [self reachGO];
}

-(void)reachGO{
    
    if([GLReachabilityView isConnectionAvailable]==1){
        
        _view.frame = CGRectMake(0, 0, 0, 0);
        
        _view.hidden = YES;
        
    }else{
        
        _view.frame = CGRectMake(0, 0, MainScreenWidth, 30);
        
        _view.hidden = NO;
        
    }
    
    [self.view bringSubviewToFront:_view];
    
    self.tableview.frame = CGRectMake(0,_view.frame.size.height, MainScreenWidth,MainScreenHeight - 60);
    
    [self.tableview reloadData];
    
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
    [dic setObject:@"1" forKey:@"type"];
    [dic setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    [dic setObject:@"20" forKey:@"count"];
    
    NSLog(@"%@",dic);
    
    NSArray *ZXArray = [ZXWendaTool wendaWithDic:dic];
    
    
    [manager reloadNewQuesttion:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"##%@",responseObject);
        if (ZXArray.count) {
            NSLog(@"不缓存");
        } else {
             [ZXWendaTool saveWendaes:responseObject[@"data"]];
        }
        
       
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"还没有问答" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        } else {
            NSMutableArray *muarr = [[NSMutableArray alloc]initWithCapacity:0];
            NSArray *arr = [NSArray arrayWithArray:[responseObject objectForKey:@"data"]];
            _userArray = responseObject[@"data"];
            
            
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
            
            
//            self.muArr = muarr;
//            self.muArr = _userArray;
            
            [_tableview reloadData];
        }
        [_tableview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //取出本地数据
        [MBProgressHUD showError:@"数据加载失败" toView:self.view];

        //self.muArr = ZXArray;
        //[_tableview reloadData];
        
    }];
 
}



-(void)reloadForNewQuestionOfPage:(NSInteger)page
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:self.wdType forKey:@"wdtype"];
    [dic setObject:@"1" forKey:@"type"];
    [dic setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    [dic setObject:@"20" forKey:@"count"];
    
    NSLog(@"%@",dic);
    [manager reloadNewQuesttion:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SYG%@",responseObject);
        
        NSLog(@"Number----%ld",self.muArr.count);
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"还没有问答" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        } else {
            
            NSArray *pageArray = [NSArray arrayWithArray:responseObject[@"data"]];
            if (page == 1) {//说明是第一页的数据
                self.muArr = [NSMutableArray arrayWithArray:pageArray];
            } else {
                NSArray *pageArray = [NSArray arrayWithArray:responseObject[@"data"]];
                NSLog(@"%@",pageArray);
                if (pageArray.count == 0) {
                    return ;
                }
                [self.muArr addObjectsFromArray:pageArray];
            }
        }
        [_tableview reloadData];
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [MBProgressHUD showError:@"数据加载失败" toView:self.view];

    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (self.muArr.count > 5) {
//        self.tableview.showsVerticalScrollIndicator = NO;
//    }
        return self.muArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.tableview cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height + 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellStr = @"WDTableViewCell";
    WDTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (cell == nil) {
        cell = [[WDTableViewCell alloc] initWithReuseIdentifier:cellStr];
    }
    
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
    
    cell.JTLabel.text = [NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"wd_description"]];
    
    NSString *JTStr = [self filterHTML:self.muArr[indexPath.row][@"wd_description"]];
    
    cell.JTLabel.text = [NSString stringWithFormat:@"%@",JTStr];

    
    cell.JTLabel.attributedText = [emotionjiexi jiexienmojconent:JTStr font:[UIFont systemFontOfSize:16]];
//    NSMutableArray *HH = [ImageCell ImageCellWithString:self.muArr[indexPath.row][@"wd_description"]];
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"_________%@  ====  %@",self.muArr,[[self.muArr objectAtIndex:indexPath.row] class]);
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:[self.muArr objectAtIndex:indexPath.row]];

    NSLog(@"--------%@",dic);
    NSString *userId = dic[@"id"];
    NSLog(@"%@",self.muArr[indexPath.row][@"wd_description"]);

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
    return html;
}



@end
