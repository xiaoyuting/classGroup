//
//  NewView.m
//  ChuYouYun
//
//  Created by IOS on 16/5/30.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "NewView.h"
#import "AskTableViewCell.h"
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




#define DeviceHight [UIScreen mainScreen].bounds.size.height
#define DeviceWidth [UIScreen mainScreen].bounds.size.width

@implementation NewView

{
    CGRect rect;
    NSInteger _page;
    UIView *_view;
    
}
-(void)setUpRefresh
{
    //下拉刷新
    [self.homeTableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [self.homeTableView headerBeginRefreshing];
    
    //上拉加载
    [self.homeTableView addFooterWithTarget:self action:@selector(footerRefreshing)];
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
        [self.homeTableView reloadData];
        [self.homeTableView headerEndRefreshing];
    });
    [self reachGO];
}

-(void)reachGO{
    
    if([GLReachabilityView isConnectionAvailable]==1){
        
        _view.frame = CGRectMake(0, 0, 0, 0);
        
        _view.hidden = YES;
        
    }else{
        
        _view.frame = CGRectMake(0, 0, DeviceWidth, 30);
        
        _view.hidden = NO;
        
    }
    
    [self bringSubviewToFront:_view];
    
    self.homeTableView.frame = CGRectMake(0,_view.frame.size.height, DeviceWidth,DeviceHight - 25);
    
    [self.homeTableView reloadData];
    
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
        [self.homeTableView reloadData];
        [self.homeTableView footerEndRefreshing];
    });
}


-(void)reloadNewQuestionOfPage:(NSInteger)page
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:@"1" forKey:@"type"];
    [dic setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    [dic setObject:@"20" forKey:@"count"];
    
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
            
            [self.homeTableView reloadData];
        }
        [self.homeTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //取出本地数据
        self.muArr = ZXArray;
        [self.homeTableView reloadData];
        
    }];
    
}



-(void)reloadForNewQuestionOfPage:(NSInteger)page
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    //    NSLog(@"     %@",self.wdType);
    [dic setObject:self.wdType forKey:@"wdtype"];
    [dic setObject:@"1" forKey:@"type"];
    [dic setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    [dic setObject:@"20" forKey:@"count"];
    [manager reloadNewQuesttion:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"SYG%@",responseObject);
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"还没有问答" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        } else {
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
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"数据下载失败，请刷新重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"_________%@  ====  %@",self.muArr,[[self.muArr objectAtIndex:indexPath.row] class]);
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:[self.muArr objectAtIndex:indexPath.row]];
    
    NSLog(@"--------%@",dic);
    NSString *userId = dic[@"id"];
    NSLog(@"%@",self.muArr[indexPath.row][@"wd_description"]);
}

-(id)initWithwdType:(NSString *)wdType
{
    self = [super init];
    if (self) {
        self.wdType = wdType;
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    UIView *backView = [[UIView alloc]initWithFrame:self.frame];
    backView.backgroundColor = [UIColor purpleColor];
    backView.alpha = 0.5;
    self.backgroundColor = [UIColor purpleColor];
    [self addSubview:self.homeTableView];
    
}

- (HomeTableView *)homeTableView{
    if (!_homeTableView) {
        
        _homeTableView=[[HomeTableView alloc]initWithFrame:CGRectMake(0,0, DeviceWidth, DeviceHight)];
        [_homeTableView setDelegate:self];
        [_homeTableView setDataSource:self];
        [_homeTableView setRowHeight:260];
        _homeTableView.estimatedRowHeight = 44.0f;
        _homeTableView.rowHeight = UITableViewAutomaticDimension;
        
    }
    
    return _homeTableView;
}
#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1;
}
#pragma mark - UITableView dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIde=@"AskTableViewCell";
    AskTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    
    if (cell == nil) {
        cell=[[AskTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    
    if ([self.muArr[indexPath.row][@"userface"] isEqual:[NSNull null]]) {
        
    }else {
       // [cell.aconImage sd_setBackgroundImageWithURL:[NSURL URLWithString:self.muArr[indexPath.row][@"userface"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"站位图"]];
    }
    
    cell.aconImage.clipsToBounds = YES;
    cell.aconImage.layer.cornerRadius = 20.0;
    cell.nameLab.text = [NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"uname"]];
    cell.timeLab.text = self.muArr[indexPath.row][@"ctime"];
    
   // [cell setIntroductionText:self.muArr[indexPath.row][@"wd_description"]];
    //图片
    //    [cell imageWithArray:self.muArr[indexPath.row][@"wd_comment"][@"userface"]];
    [cell.speakBtn setTitle:[NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"wd_browse_count"]] forState:UIControlStateNormal];
    [cell.lookBtn setTitle:[NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"wd_comment_count"]] forState:UIControlStateNormal];

    cell.textLab.text = [NSString stringWithFormat:@"%@",self.muArr[indexPath.row][@"wd_description"]];
//    
//    NSString *JTStr = [self filterHTML:self.muArr[indexPath.row][@"wd_description"]];
//    
//    cell.JTLabel.text = [NSString stringWithFormat:@"%@",JTStr];
//    
//    
//    cell.JTLabel.attributedText = [emotionjiexi jiexienmojconent:JTStr font:[UIFont systemFontOfSize:16]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"cell height %f",cell.frame.size.height);
    
    //return cell.frame.size.height;
    
    return 150;
}

@end
