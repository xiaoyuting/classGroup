//
//  ZJViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 15/12/30.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "ZJViewController.h"
#import "MyCrouseTableViewController.h"
#import "MyTableViewController.h"
#import "MyViewController.h"
#import "UIButton+WebCache.h"
#import "CourseCell.h"
#import "msgViewController.h"
#import "settingViewController.h"
#import "MyShoppingCarViewController.h"
#import "CourseViewController.h"
#import "QuestionsAndAnswersViewController.h"
#import "NoteViewController.h"
#import "AttentionViewController.h"
#import "MyMsgViewController.h"
#import "receiveCommandViewController.h"
#import "FansViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "Passport.h"
#import "CData.h"
#import "SYG.h"
#import "MJRefresh.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "questionViewController.h"
#import "NoteViewController.h"
#import "UIImage+WebP.h"
#import "MyBuyCell.h"
#import "blumDetailVC.h"
#import "blumList.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYGBlumTableViewCell.h"
#import "BuyBlum.h"
#import "MBProgressHUD+Add.h"
#import "UIColor+HTMLColors.h"
#import "TIXingLable.h"
#import "ZFPlayerModel.h"
#import "LiveDetailsViewController.h"



@interface ZJViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSInteger _number;
    CGRect rect;
    TIXingLable *_txLab;
}

@property (strong ,nonatomic)NSArray *dataSource;

@end

@implementation ZJViewController



-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    
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
    [self initer];
    [self titleSet];
    [self addNav];
}

- (void)initer {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的直播";
    
    rect = [UIScreen mainScreen].applicationFrame;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, MainScreenWidth, MainScreenHeight + 35) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:237.0/255.0 alpha:1];
//    self.tableView.userInteractionEnabled = YES;
//    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.rowHeight = 110;
    self.dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    [self.view addSubview:self.tableView];
    _txLab = [[TIXingLable alloc]initWithFrame:CGRectMake(0, 100*MainScreenHeight/667, MainScreenWidth, 30)];
    _txLab.textColor = [UIColor clearColor];
    [self.tableView insertSubview:_txLab atIndex:0];
    
    //下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [self.tableView headerBeginRefreshing];
    
//    //上拉加载
//    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,5,0,0)];
    }
    
    //设置表格分割线的长度（跟两边的距离）
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,2,0,0)];
    }
    
}

- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"我的直播";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 100, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,86)];
    [backButton setTitle:@" " forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    //设置button上字体的偏移量
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10.0 , 0.0, 0)];
    [SYGView addSubview:backButton];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)titleSet {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:44.f / 255 green:132.f / 255 blue:214.f / 255 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    
    
}

- (void)headerRerefreshing
{
    [self reloadData:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        if (_classArray.count==0) {
            _txLab.textColor = [UIColor colorWithHexString:@"#dedede"];
        }else{
        
            _txLab.textColor = [UIColor clearColor];
        }
    });
    
}
- (void)footerRefreshing
{
    _number++;
    [self reloadData:_number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
    
}


#pragma mark --- 


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_classArray isEqual:[NSNull null]]) {

        return 0;
    }else {
         return _classArray.count;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellStr = @"cellSYG";
    SYGBlumTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (cell == nil) {
        cell = [[SYGBlumTableViewCell alloc] initWithReuseIdentifier:cellStr];
    }

    [cell.imageButton setBackgroundImage:[UIImage imageNamed:@"站位图"] forState:UIControlStateNormal];
    
    [cell.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_classArray[indexPath.row][@"cover"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"站位图"]];
//        [cell.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_dataArray[indexPath.row][@"image"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"站位图"]];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",_classArray[indexPath.row][@"title"]];
    cell.contentLabel.text = [NSString stringWithFormat:@"%@",[self filterHTML:_classArray[indexPath.row][@"info"]]];
    cell.KSLabel.text = [NSString stringWithFormat:@"%@课时",_classArray[indexPath.row][@"video_cont"]];
    cell.XBLabel.text = [NSString stringWithFormat:@"%@  元",_classArray[indexPath.row][@"price"]];
    NSString *MoneyStr = [NSString stringWithFormat:@"%@  元",_classArray[indexPath.row][@"price"]];
    NSString *XBStr = [NSString stringWithFormat:@"%@",_classArray[indexPath.row][@"price"]];
    //变颜色
    NSMutableAttributedString *needStr = [[NSMutableAttributedString alloc] initWithString:MoneyStr];
    [needStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] range:NSMakeRange(0, XBStr.length)];
    //设置字体加错
    [needStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, XBStr.length)];
    [needStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, XBStr.length)];
    [cell.XBLabel setAttributedText:needStr] ;
    
    NSString * starStr = [NSString stringWithFormat:@"%@",_classArray[indexPath.row][@"score"]];
    float length = [starStr floatValue];
    if (length == 1) {
        
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"101@2x"] forState:UIControlStateNormal];
    }
    
    if (length == 2) {
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"102@2x"] forState:UIControlStateNormal];
    }else {
        
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"100@2x"] forState:UIControlStateNormal];
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
    
    return cell;

    
    
 
}

-(void)reloadData:(NSInteger)number
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)number] forKey:@"page"];
    [dic setObject:@"10" forKey:@"count"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    //取出缓存数据
    NSArray *blumsArray = [BuyBlum blumWithDic:dic];
    NSLog(@"------%@",blumsArray);
    
    [MBProgressHUD showMessag:@"加载中。。。" toView:self.view];
    
    [manager getpublicPort:dic mod:@"Live" act:@"getMyLiveList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"))))%@",responseObject);
        _classArray = responseObject[@"data"];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"加载完成" toView:self.view];
        
        if (blumsArray.count) {//已经有缓存,不再需要缓存
            NSLog(@"不需要");
        } else {
            //缓存数据
            [BuyBlum saveBlums:responseObject[@"data"]];
        }
        
        
        NSMutableArray *muArr = [[NSMutableArray alloc]initWithCapacity:0];
        if (_classArray.count) {
            NSLog(@"**%@",responseObject);
            muArr = [responseObject objectForKey:@"data"];
        }else
        {
            
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
            imageView.image = [UIImage imageNamed:@"我的专辑@2x"];
            [self.view addSubview:imageView];
            
            
        }
        
        
        [_tableView reloadData];
        

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        _classArray = blumsArray;
        [_tableView reloadData];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"加载失败" toView:self.view];
        
    }];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *Cid = _classArray[indexPath.row][@"live_id"];
    // NSString *Price = _dataArray[indexPath.row][@"price"];
    NSString *Title = _classArray[indexPath.row][@"title"];
    // NSString *VideoAddress = _dataArray[indexPath.row][@"video_address"];
    NSString *ImageUrl = _classArray[indexPath.row][@"cover"];

    LiveDetailsViewController *cvc = [[LiveDetailsViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)indexPath.row andprice:_classArray[indexPath.row][@"v_price"]];
    // [[NSNotificationCenter defaultCenter]postNotificationName:@"hiddenTableBar" object:nil];
    [self.navigationController pushViewController:cvc animated:YES];

    
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
        
        //        //找到标签的起始位置
        //        [scanner scanUpToString:@"<" intoString:nil];
        //        //找到标签的结束位置
        //        [scanner scanUpToString:@">" intoString:&text];
        
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        
        
    }
    // NSString * regEx = @"<([^>]*)>";
    // html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}



@end
