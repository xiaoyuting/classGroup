//
//  characterPlayVC.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/24.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4,4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕


#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕

#define iPhone6PlusBIG ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus放大版屏幕
#define SPACE (self.view.frame.size.width-30*4)/4 //间隙
#import "characterPlayVC.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "UMSocial.h"
#import "blumPlayNoteVC.h"
#import "blumPlayQuestionVC.h"
#import "MyHttpRequest.h"
#import "Helper.h"
#import "MBProgressHUD.h"
#import "blumCatalogList.h"
#import "videoPlayChaCell.h"
#import "UIColor+HTMLColors.h"

@interface characterPlayVC ()<UIScrollViewDelegate,UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView * _scrollView;
    UIImageView * _arrowImageView;
    UIImageView * imageView;
    UIView * bgView;
    UIButton * collectBtn1;
    UIWebView * _webView;
    NSURLRequest * request;
    MBProgressHUD * HUD;
    UITableView * _tableView;
    UILabel *_lable;
}
@end

@implementation characterPlayVC

- (id)initWithMemberId:(NSString *)MemberId andTitle:(NSString *)title andROW:(NSInteger)row
{
    if (self=[super init]) {
        _blumId = MemberId;
        _blumTitle = title;
        _ROW = row;
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    self.navigationController.navigationBar.hidden = YES;
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    self.navigationController.navigationBar.hidden = NO;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadClassData];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, MainScreenWidth, 44)];
    view.backgroundColor = [UIColor whiteColor];
    view.userInteractionEnabled = YES;
    view.image = [UIImage imageNamed:@"options.png"];
    [self.view addSubview:view];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, 12, 44, 22);
    [button setImage:[UIImage imageNamed:@"Arrow000.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(MainScreenWidth/2-70, 8, 140, 30)];
    label.text = _video_title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    [view addSubview:label];
    
    //创建分享按钮
    if(iPhone4SOriPhone4||iPhone5o5Co5S)
    {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(MainScreenWidth/2+80,16 , 31, 15);
        [btn setImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(shareBtn) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    else if(iPhone6)
    {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(MainScreenWidth/2+100,16 , 31, 15);
        [btn setImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(shareBtn) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    else if (iPhone6Plus)
    {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(MainScreenWidth/2+125,16 , 31, 15);
        [btn setImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(shareBtn) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    } else {//ipad适配
        
        
        
    }
    
    
    
     [self requestData];
    //创建收藏按钮
    collectBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn1.frame = CGRectMake(MainScreenWidth-30, 15, 20, 17);
    [collectBtn1 addTarget:self action:@selector(collectionBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:collectBtn1];
  
  
    //利用webview播放视频
    if (iPhone4SOriPhone4||iPhone5o5Co5S) {
        
//        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, MainScreenHeight-370+64, MainScreenWidth, 40)];
//        [self.view addSubview:bgView];
//        
//        UIImageView * imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height)];
//        imageView2.image = [UIImage imageNamed:@"options.png"];
//        [bgView addSubview:imageView2];
//        
//        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 35, 50, 5)];
//        _arrowImageView.image = [UIImage imageNamed:@"arrow88.png"];
//        [bgView addSubview:_arrowImageView];
        
        //    UIWebView *myWeb = [[UIWebView alloc] initWithFrame:self.view.bounds];
        //
        //    NSURL *url = [NSURLURLWithString:@"
        //                                http://devimages.apple.com/iphone/samples/bipbop/gear1/prog_index.m3u8"];
        //                                http://devimages.apple.com/iphone/samples/bipbop/gear1/prog_index.m3u8//这里也可以是 mp4
        //
        //                  NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //
        //                  [myWeb setDelegate:self];
        //
        //                  [myWeb loadRequest:request];
        //                  
        //                  [self.view addSubview:myWeb];
        //
        UIWebView *myWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 200)];
        myWeb.backgroundColor = [UIColor redColor];
        NSURL *url = [NSURL URLWithString:self.videoAddress];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [myWeb setDelegate:self];
        [myWeb loadRequest:request];
        [self.view addSubview:myWeb];
        NSLog(@"%@",self.videoAddress);
     
    }
    else if (iPhone6)
    {
         NSLog(@"%@",self.videoAddress);
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, MainScreenHeight-390+64, MainScreenWidth, 40)];
        [self.view addSubview:bgView];
        
        UIImageView * imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height)];
        imageView2.image = [UIImage imageNamed:@"options.png"];
        [bgView addSubview:imageView2];
        
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(52, 35, 50, 5)];
        _arrowImageView.image = [UIImage imageNamed:@"arrow88.png"];
        [bgView addSubview:_arrowImageView];
        
    }
    else if(iPhone6Plus)
    {
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, MainScreenHeight-410+64, MainScreenWidth, 40)];
        [self.view addSubview:bgView];
        
        UIImageView * imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgView.bounds.size.width, bgView.bounds.size.height)];
        imageView2.image = [UIImage imageNamed:@"options.png"];
        [bgView addSubview:imageView2];
        
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(61, 35, 50, 5)];
        _arrowImageView.image = [UIImage imageNamed:@"arrow88.png"];
        [bgView addSubview:_arrowImageView];
    }
    for (int i=0; i<3; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        btn.frame = CGRectMake(SPACE+(SPACE+48)*i, (40-36)/2, 30, 36);
        
        btn.tag = 10080+i;
        btn.selected = NO;
        if (i==0) {
            [btn setTitle:@"章节" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
        }
        else if(i==1)
        {
            [btn setTitle:@"笔记" forState:UIControlStateNormal];
        }
        else if(i==2)
        {
            [btn setTitle:@"提问" forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
    }
    if (iPhone6) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+MainScreenHeight-350, MainScreenWidth, 290)];
    }
    else if(iPhone5o5Co5S||iPhone4SOriPhone4)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+MainScreenHeight-330, MainScreenWidth, 270)];
    }
    else if(iPhone6Plus)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+MainScreenHeight-370, MainScreenWidth, 310)];
    }
    
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView.contentSize = CGSizeMake(MainScreenWidth*3, 0);
    [self.view addSubview:_scrollView];

//    _videoVC = [[blumInCourseVC alloc]initWithId:_blumId andTitle:_blumTitle andClassID:_class_id andROW:_ROW ];
//    _videoVC.view.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
//    [self addChildViewController:_videoVC];
//    [_scrollView addSubview:_videoVC.view];
    
    blumPlayNoteVC * qvc = [[blumPlayNoteVC alloc]initWithId:_blumId];
    qvc.view.frame = CGRectMake(MainScreenWidth, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [self addChildViewController:qvc];
    [_scrollView addSubview:qvc.view];
    
    blumPlayQuestionVC * cvc = [[blumPlayQuestionVC alloc]initWithId:_blumId];
    cvc.view.frame = CGRectMake(MainScreenWidth*2, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [self addChildViewController:cvc];
    [_scrollView addSubview:cvc.view];
    
    
    if (iPhone5o5Co5S) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-300) style:UITableViewStylePlain];
    }
    else if (iPhone6)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-380) style:UITableViewStylePlain];
    }
    else if (iPhone6Plus)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-430) style:UITableViewStylePlain];
    }
    else if (iPhone4SOriPhone4)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-210) style:UITableViewStylePlain];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.tableFooterView = [[UIView alloc]init];
    [_scrollView addSubview:_tableView];
    _tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    _lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 100,MainScreenWidth, 12)];
    [_tableView addSubview:_lable];
    [_tableView insertSubview:_lable atIndex:0];
    _lable.text = @"数据为空，刷新重试";
    _lable.textAlignment = NSTextAlignmentCenter;
    _lable.textColor = [UIColor clearColor];
    _lable.font = [UIFont systemFontOfSize:14];

    [self requestData3];
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


-(void)requestData3
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_blumId forKey:@"id"];
    [manager albumCatalog:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _dataArray = [responseObject objectForKey:@"data"];
        NSMutableArray * listArr = [[NSMutableArray alloc]initWithCapacity:0];
        _checkArray = [[NSMutableArray alloc]initWithCapacity:0];
        
        for (int i=0; i<_dataArray.count; i++) {
            blumCatalogList * list = [[blumCatalogList alloc]initWithDictionarys:_dataArray[i]];
            [listArr addObject:list];
            
            if ([_dataArray[i][@"id"] isEqualToString:_class_id]) {
                [_checkArray addObject:@"1"];
            }
            else{
                [_checkArray addObject:@"0"];
            }
            
        }
        _dataArray = listArr;
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - 自定义分区标题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * v_headerLab = [[UILabel alloc] initWithFrame:CGRectMake(7, 2, MainScreenWidth, 38)];
    UIView *v_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 30)];//创建一个视图（v_headerView）
    UIImageView *v_headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 23)];//创建一个UIimageView（v_headerImageView）
    [v_headerView addSubview:v_headerImageView];//将v_headerImageView添加到创建的视图（v_headerView）中
    v_headerLab.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];//设置v_headerLab的背景颜色
    v_headerLab.font = [UIFont systemFontOfSize:17];//设置v_headerLab的字体样式和大小
    v_headerLab.shadowColor = [UIColor whiteColor];//设置v_headerLab的字体的投影
    [v_headerLab setShadowOffset:CGSizeMake(0, 1)];//设置v_headerLab的字体投影的位置
    if (section==0) {
        v_headerLab.text =_blumTitle;
        v_headerLab.textColor = [UIColor redColor];
        
    }
    [v_headerView addSubview:v_headerLab];
    
    return v_headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count==0) {
        _lable.textColor = [UIColor colorWithHexString:@"#dedede"];
        
    }else{
        _lable.textColor = [UIColor clearColor];
    }

    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellStr = @"cell";
    videoPlayChaCell *  cell= [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        NSArray * xibArr = [[NSBundle mainBundle]loadNibNamed:@"videoPlayChaCell" owner:nil options:nil];
        for (id obj in xibArr) {
            cell = (videoPlayChaCell *)obj;
            break;
        }
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    blumCatalogList * list = _dataArray[indexPath.row];
    cell.titleLab.text = list.classTitle;
    cell.countLab.text = [NSString stringWithFormat:@"章节%ld",(long)(indexPath.row+1)];
    
    if ([_checkArray[indexPath.row] intValue]==1) {
        cell.img.image = [UIImage imageNamed:@"椭圆-11_01"];
    }
    else{
        cell.img.image = [UIImage imageNamed:@"椭圆-11_01-02"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    blumCatalogList * list = _dataArray[indexPath.row];
    _class_id = list.classId;
    [self loadClassData];
    //小圈变色状态变化
    [_checkArray removeAllObjects];
    for (int i=0; i<_dataArray.count; i++) {
        [_checkArray addObject:@"0"];
    }
    [_checkArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
    [_tableView reloadData];
}



- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareBtn
{
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"574e8829e0f55a12f8001790"
                                      shareText:[NSString stringWithFormat:@"我正在出右云课堂app观看—%@",_video_title]
                                     shareImage:[UIImage imageNamed:@"chuyou.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToQQ,UMShareToDouban, UMShareToWechatTimeline,nil]
                                       delegate:self];
}

- (void)btnClick:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    switch (btn.tag) {
        case 10080:
            if (iPhone4SOriPhone4||iPhone5o5Co5S) {
                _arrowImageView.frame = CGRectMake(40, 35, 50, 5);
            }
            else if (iPhone6)
            {
                _arrowImageView.frame = CGRectMake(52, 35, 50, 5);
            }
            else if(iPhone6Plus)
            {
                _arrowImageView.frame = CGRectMake(62, 35, 50, 5);
                
            }
            
            _scrollView.contentOffset = CGPointMake(0, 0);
            break;
        case 10081:
            if (iPhone4SOriPhone4||iPhone5o5Co5S) {
                _arrowImageView.frame = CGRectMake(136, 35, 50, 5);
                
            }
            else if(iPhone6)
            {
                _arrowImageView.frame = CGRectMake(165, 35, 50, 5);
            }
            else if(iPhone6Plus)
            {
                _arrowImageView.frame = CGRectMake(183, 35, 50, 5);
                
            }
            _scrollView.contentOffset = CGPointMake(MainScreenWidth, 0);
            break;
        case 10082:
            if (iPhone4SOriPhone4||iPhone5o5Co5S) {
                _arrowImageView.frame = CGRectMake(235, 35, 50, 5);
                
            }
            else if(iPhone6)
            {
                _arrowImageView.frame = CGRectMake(276, 35, 50, 5);
            }
            else if (iPhone6Plus)
            {
                _arrowImageView.frame = CGRectMake(305, 35, 50, 5);
                
            }
            _scrollView.contentOffset = CGPointMake(MainScreenWidth*2, 0);
            break;
        default:
            break;
    }
    int p=_arrowImageView.frame.origin.x;
    if (iPhone4SOriPhone4||iPhone5o5Co5S) {
        switch (p) {
            case 40:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
            case 136:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
                break;
            case 235:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
            }
                
            default:
                break;
        }
    }
    
    else if(iPhone6)
    {
        switch (p) {
            case 52:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
            case 165:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
                break;
            case 276:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
            }
                
            default:
                break;
                
        }
    }
    else if(iPhone6Plus)
    {
        switch (p) {
            case 62:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
            case 183:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
                break;
            case 305:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
            }
                
            default:
                break;
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==_scrollView) {
        CGPoint point = scrollView.contentOffset;
        if (point.x==0) {
            if (iPhone4SOriPhone4||iPhone5o5Co5S) {
                _arrowImageView.frame = CGRectMake(40, 35, 50, 5);
            }
            else if(iPhone6)
            {
                _arrowImageView.frame = CGRectMake(52, 35, 50, 5);
                
            }
            else if (iPhone6Plus)
            {
                _arrowImageView.frame = CGRectMake(62, 35, 50, 5);
                
            }
            
            _scrollView.contentOffset = CGPointMake(0, 0);
        }
        else if(point.x==MainScreenWidth)
        {
            if (iPhone4SOriPhone4||iPhone5o5Co5S) {
                _arrowImageView.frame = CGRectMake(136, 35, 50, 5);
            }
            else if (iPhone6)
            {
                _arrowImageView.frame = CGRectMake(165, 35, 50, 5);
            }
            else if(iPhone6Plus)
            {
                _arrowImageView.frame = CGRectMake(183, 35, 50, 5);
                
            }
            
            _scrollView.contentOffset = CGPointMake(MainScreenWidth, 0);
        }
        else if(point.x==MainScreenWidth*2)
        {
            if (iPhone4SOriPhone4||iPhone5o5Co5S) {
                _arrowImageView.frame = CGRectMake(235, 35, 50, 5);
                
            }
            else if(iPhone6)
            {
                _arrowImageView.frame = CGRectMake(276, 35, 50, 5);
                
            }
            else if(iPhone6Plus)
            {
                _arrowImageView.frame = CGRectMake(305, 35, 50, 5);
                
            }
            _scrollView.contentOffset = CGPointMake(MainScreenWidth*2, 0);
        }
    }
    int p = _arrowImageView.frame.origin.x;
    if (iPhone4SOriPhone4||iPhone5o5Co5S) {
        switch (p) {
            case 40:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
            case 136:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
                break;
            case 235:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
            }
                
            default:
                break;
        }
        
    }
    else if (iPhone6)
    {
        switch (p) {
            case 52:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
            case 165:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
                break;
            case 276:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
            }
                
            default:
                break;
        }
        
    }
    else if (iPhone6Plus)
    {
        switch (p) {
            case 62:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
                break;
            case 183:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
            }
                break;
            case 305:
            {
                UIButton * btn = (UIButton *)[self.view viewWithTag:10080];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
                [btn2 setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
            }
                
            default:
                break;
        }
        
    }
}

- (void)requestData
{
    
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_blumId forKey:@"id"];
    [manager albumDetail:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _collectStr = [responseObject objectForKey:@"data"][@"iscollect"];
        
        if ([_collectStr intValue]==1) {
           [collectBtn1 setImage:[UIImage imageNamed:@"Like.png"] forState:UIControlStateNormal];
        }
        else
        {
             [collectBtn1 setImage:[UIImage imageNamed:@"Like_pressed.png"] forState:UIControlStateNormal];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (void)collectionBtn
    {
        if ([_collectStr intValue]==1) {
            QKHTTPManager * manager = [QKHTTPManager manager];
            NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
            [dic setValue:@"1" forKey:@"sctype"];
            [dic setValue:@"0" forKey:@"type"];
            [dic setValue:_blumId forKey:@"source_id"];
            [manager collect:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
               [collectBtn1 setImage:[UIImage imageNamed:@"Like_pressed.png"] forState:UIControlStateNormal];
                [self requestData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
        else
        {
            QKHTTPManager * manager1 =[QKHTTPManager manager];
            NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
            [dic setValue:@"1" forKey:@"sctype"];
            [dic setValue:@"1" forKey:@"type"];
            [dic setValue:_blumId forKey:@"source_id"];
            [manager1 collect:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
               [collectBtn1 setImage:[UIImage imageNamed:@"Like.png"] forState:UIControlStateNormal];
                [self requestData];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
        
    }

//创建btn用于 创建导航按钮时用
-(UIButton *)button:(NSString *)title image:(NSString *)image frame:(CGRect)frame
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    //设置字体大小
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setBackgroundImage:[Helper imageNamed:image cache:YES] forState:UIControlStateNormal];
    return button;
}

//创建右侧按钮
-(void)additems:(NSString *)title position:(itemCha)position image:(NSString *)image action:(SEL)action
{
    UIButton * button = [self button:title image:image frame:CGRectMake(0, 2, 20, 17)];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:button];
    if (position==Right_ItemsCha) {
        self.navigationItem.rightBarButtonItem = item;
    }else{
        self.navigationItem.leftBarButtonItem = item;
    }
    
}

-(void)loadClassData
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_class_id forKey:@"id"];
    [manager getClassDetail:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _dict = [responseObject objectForKey:@"data"];
        _videoAddress =_dict[@"video_address"];
        NSLog(@"%@",_videoAddress);
        if (iPhone4SOriPhone4||iPhone5o5Co5S) {
            _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight-370)];
            request = [NSURLRequest requestWithURL:[NSURL URLWithString:_videoAddress]];
            [self.view addSubview:_webView];
            [_webView loadRequest:request];
        }
        else if (iPhone6)
        {
            _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight-390)];
            request = [NSURLRequest requestWithURL:[NSURL URLWithString:_videoAddress]];
            [self.view addSubview:_webView];
            [_webView loadRequest:request];
        }
        else if(iPhone6Plus)
        {
            _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight-410)];
            request = [NSURLRequest requestWithURL:[NSURL URLWithString:_videoAddress]];
            [self.view addSubview:_webView];
            [_webView loadRequest:request];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


@end
