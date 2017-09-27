//
//  ZiXunViewController.m
//  dafengche
//
//  Created by IOS on 16/11/22.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "ZiXunViewController.h"
#import "SYG.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "ZiXunTableViewCell.h"
#import "ZiXunsTableViewCell.h"
#import "ZhiyiHTTPRequest.h"
#import "ZXZXViewController.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "ZXDTViewController.h"
#import "MBProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "GSMJRefresh.h"
#import "ZiXunsssTableViewCell.h"
#import "UIButton+WebCache.h"

#import "MessageWebViewController.h"
#import "InformationMainViewController.h"
#import "ZXZXTableViewCell.h"
#import "MessageMainViewController.h"



@interface ZiXunViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{
    
    NSArray *_menuarr;
    UIButton *menubtn;
    int numsender;
    int tempNumber;
    UILabel *_colorLine;
    NSString *_ID;
    CGFloat buttonX;//每个按钮的最开始的位置
    CGFloat allButtonX;//最后按钮的X轴上的偏移量
}

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSArray *lookArray;

@property (strong ,nonatomic)UIScrollView *headScrollow;

///顶部btn集合
@property (strong, nonatomic) NSArray *btns;

@property (strong ,nonatomic)NSArray *dataArray;

@property (strong ,nonatomic)NSMutableArray *dataArr;

@property (assign ,nonatomic)NSInteger number;

@property (strong ,nonatomic)NSMutableArray *imgdataArray;

@end

@implementation ZiXunViewController

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

- (void)NetWork {
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [manager FXFL:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _dataArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        [self creatMenu];
        [self addTableView];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"数据加载失败" toView:self.view];
        NSLog(@"error   %@",error);
    }];
}

//详情里面的请求
- (void)getData:(NSString *)IDStr andNum:(NSInteger)num{
    
    QKHTTPManager *manager = [QKHTTPManager manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:@"1" forKey:@"order"];
    [dic setObject:[NSString stringWithFormat:@"%@",_ID] forKey:@"cid"];
    [dic setValue:[NSNumber numberWithInteger:num] forKey:@"page"];
    [dic setValue:@"6" forKey:@"count"];
    NSLog(@"%@",dic);
//    [MBProgressHUD showError:@"数据加载中...." toView:self.view];
    
    [manager getpublicPort:dic mod:@"News" act:@"getList" success:^(AFHTTPRequestOperation *operation, id responseObject) {

         NSLog(@"======  %@",responseObject);
         NSArray *LJArray = responseObject[@"data"];
//        [MBProgressHUD showError:@"加载完成...." toView:self.view];

        if (num == 1) {
             _dataArr = [NSMutableArray arrayWithArray:LJArray];
         } else {
             
             NSString *msg = responseObject[@"msg"];
             
             if ([responseObject[@"code"] integerValue ] == 1) {
                  NSArray *SYGArray = [NSArray arrayWithArray:LJArray];
                  [_dataArr addObjectsFromArray:SYGArray];
             } else {
                 [MBProgressHUD showError:msg toView:self.view];
                 return ;
             }
         }
         [_tableView reloadData];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [MBProgressHUD showError:@"数据加载失败" toView:self.view];
     }];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self interFace];
    [self addNav];
    [self addscrollow];
    [self NetWork];
    [_tableView.header beginRefreshing];
}

-(void)addscrollow{
    
    _headScrollow = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64, MainScreenWidth,40)];
    _headScrollow.delegate = self;
    _headScrollow.alwaysBounceVertical = NO;
    _headScrollow.pagingEnabled = NO;
    _headScrollow.backgroundColor = [UIColor whiteColor];
    //同时单方向滚动
    _headScrollow.directionalLockEnabled = YES;
    _headScrollow.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:_headScrollow];
    _headScrollow.showsVerticalScrollIndicator = NO;
    _headScrollow.showsHorizontalScrollIndicator = NO;
    _headScrollow.delegate = self;
    
}
- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headScrollow.current_y_h, MainScreenWidth, MainScreenHeight - _headScrollow.current_y_h + 68) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 170;
    [self.view addSubview:_tableView];
    self.edgesForExtendedLayout = UIRectEdgeNone;// 推荐使用
    __weak typeof(self) weakSelf = self;
    // 把小菊花漏出来
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    _tableView.header = [GSMJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf headerRerefreshing:_ID];
    }];
    [_tableView.header beginRefreshing];

    //添加刷新
//    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing:)];
//    [_tableView headerBeginRefreshing];
    
//    //上拉加载
//    _tableView.footer = [GSMJRefreshAutoFooter footerWithRefreshingBlock:^{
//        
//        [weakSelf footerRefreshing];
//
//    }];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
//    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
}

- (void)headerRerefreshing:(NSString *)ID
{
    _number = 1;
    [self getData:ID andNum:_number];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
//        [_tableView headerEndRefreshing];
        [self.tableView.header endRefreshing];

//        if (_dataArray.count==0) {
//            _txlab.textColor = [UIColor colorWithHexString:@"#dedede"];
//        }else{
//            _txlab.textColor = [UIColor clearColor];
//        }
    });
}

- (void)footerRefreshing
{
    _number++;
    //[self NetWork:_typeStr WithNumber:_number];
    [self getData:_ID andNum:_number];
    //[self AANetWork:_typeStr WithNumber:_number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [self.tableView.footer endRefreshing];
    });
}

//移除警告框
- (void)removeAlert:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}

#pragma mark -- UITableViewDatasoure
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    ZXZXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ZXZXTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    [cell.imageButton setBackgroundImage:[UIImage imageNamed:@"站位图"] forState:UIControlStateNormal];
    [cell.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_dataArr[indexPath.row][@"image"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"站位图"]];
    cell.titleLabel.text = _dataArr[indexPath.row][@"title"];
    NSString *readStr = [NSString stringWithFormat:@"阅读：%@",_dataArr[indexPath.row][@"readcount"]];
    cell.readLabel.text = readStr;
    cell.timeLabel.text = _dataArr[indexPath.row][@"dateline"];
    cell.JTLabel.text = [NSString stringWithFormat:@"%@",_dataArr[indexPath.row][@"desc"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    MessageWebViewController *webVc = [[MessageWebViewController alloc] init];
//    webVc.ID = _dataArr[indexPath.row][@"id"];
//    [self.navigationController pushViewController:webVc animated:YES];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZXDTViewController *ZXDTVC = [[ZXDTViewController alloc] init];
    [self.navigationController pushViewController:ZXDTVC animated:YES];
    ZXDTVC.titleStr = _dataArr[indexPath.row][@"title"];
    ZXDTVC.timeStr = _dataArr[indexPath.row][@"dateline"];
    ZXDTVC.readStr = _dataArr[indexPath.row][@"readcount"];
    ZXDTVC.ZYStr = _dataArr[indexPath.row][@"desc"];
    ZXDTVC.GDStr = _dataArr[indexPath.row][@"text"];
    ZXDTVC.ID = _dataArr[indexPath.row][@"id"];
    ZXDTVC.imageUrl = _dataArr[indexPath.row][@"image"];
}

- (void)interFace {
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    buttonX = 0;
    allButtonX = 0;
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"资讯";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30,120, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,106)];
    [backButton setTitle:@" " forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    
    //设置button上字体的偏移量
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10.0 , 0.0, 0)];
    [SYGView addSubview:backButton];
    
    //添加测试按钮
    UIButton *testButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 20, 30, 30)];
    testButton.backgroundColor = [UIColor redColor];
    [SYGView addSubview:testButton];
    [testButton addTarget:self action:@selector(testButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    testButton.hidden = YES;

    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
}

- (void)testButtonCilck {
//    InformationMainViewController *vc = [[InformationMainViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    MessageMainViewController *message = [[MessageMainViewController alloc] init];
    [self.navigationController pushViewController:message animated:YES];
}

//分类
-(void)ShopCateButton{
    NSLog(@"分类");
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)creatMenu{
    
    //自定义segment区域
    NSMutableArray *marr = [NSMutableArray array];
    UIColor *ffbbcolor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];

    for (int i=0; i< _dataArray.count; i++) {
        menubtn = [[UIButton alloc]init];
//        menubtn.frame = CGRectMake(i*MainScreenWidth/5, 0, MainScreenWidth/5, 40);
        menubtn.frame = CGRectMake(buttonX, 0, MainScreenWidth/5, 40);
        [menubtn setTitle:_dataArray[i][@"title"] forState:UIControlStateNormal];
        [_headScrollow addSubview:menubtn];
        menubtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [menubtn setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
        menubtn.tag = 100+i;
        menubtn.titleLabel.font = [UIFont systemFontOfSize:14];
        if (iPhone5o5Co5S) {
           menubtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        } else if (iPhone6) {
           menubtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        } else if (iPhone6Plus) {
           menubtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        }
        
        
        //按钮的自适应
        
        CGRect labelSize = [menubtn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil];
        if (labelSize.size.width < MainScreenWidth / 5 ) {
            labelSize.size.width = MainScreenWidth / 5;
        }
        menubtn.frame = CGRectMake(menubtn.frame.origin.x, menubtn.frame.origin.y,labelSize.size.width, 40);
        buttonX = labelSize.size.width + menubtn.frame.origin.x;
        allButtonX = labelSize.size.width + menubtn.frame.origin.x;
        
        [menubtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            [menubtn setTitleColor:ffbbcolor forState:UIControlStateNormal];
        }
        [marr addObject:menubtn];
        
        if (i == _dataArray.count - 1) {
            
        } else {
            //添加横线
            for (int i = 0 ; i < _dataArray.count - 1 ; i ++) {
                UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, 12.5, 1, 15)];
                lineButton.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
                [_headScrollow addSubview:lineButton];
            }
        }

        
        
        
    }
    self.btns = [marr copy];
    int tempNum;
    tempNum = (int)_dataArray.count;
//    _headScrollow.contentSize = CGSizeMake((_dataArray.count) * MainScreenWidth/5, 40);
    _headScrollow.contentSize = CGSizeMake(allButtonX + 20, 5);
    _colorLine = [[UILabel alloc]initWithFrame:CGRectMake(0, _headScrollow.frame.size.height - 2, MainScreenWidth/5, 2)];
    _colorLine.backgroundColor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
    [_headScrollow addSubview:_colorLine];
    CGPoint center = _colorLine.center;
    center.x = MainScreenWidth / (2 * tempNum);
    _colorLine.center = center;
    _colorLine.hidden = YES;
}


#pragma mark --- 按钮长度的自适应

-(void)setIntroductionText:(NSString*)text{
    //文本赋值
//    self.JTLabel.text = text;
//    //设置label的最大行数
//    self.JTLabel.numberOfLines = 0;
//    
//    CGRect labelSize = [self.JTLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil];
//    
//    self.JTLabel.frame = CGRectMake(self.JTLabel.frame.origin.x, self.JTLabel.frame.origin.y, MainScreenWidth - 20, labelSize.size.height);
//    _otherView.frame = CGRectMake(10, CGRectGetMaxY(_JTLabel.frame) + 10, MainScreenWidth - 20, 70);

}




-(void)change:(UIButton *)sender{
    
    [self.tableView.header endRefreshing];
    //置顶
    _tableView.contentOffset = CGPointZero;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    int tempNum;
    tempNum = (int)_dataArray.count;
    for (int i=0; i<_dataArray.count; i++) {
        [self.btns[i] setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
    }
    // 滚动标题栏到中间位置
    CGFloat offsetx   =  sender.center.x - MainScreenWidth * 0.5;
    CGFloat offsetMax = _headScrollow.contentSize.width - _headScrollow.frame.size.width;
    
    // 在最左和最右时，标签没必要滚动到中间位置。
    if (offsetx < 0)		 {offsetx = 0;}
    if (offsetx > offsetMax) {offsetx = offsetMax;}
    
    [UIView animateWithDuration:0.5 animations:^{

        [_headScrollow setContentOffset:CGPointMake(offsetx, 0) animated:YES];
        CGPoint center = _colorLine.center;
        center.x = sender.center.x;
        _colorLine.center = center;
        [sender setTitleColor:[UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1] forState:UIControlStateNormal];
    }];
    
    _number = 1;
    _ID = [NSString stringWithFormat:@"%@",_dataArray[sender.tag - 100][@"zy_topic_category_id"]];
    [_tableView.header beginRefreshing];
    [self headerRerefreshing:_ID];
}

//去掉HTML字符
//-(NSString *)filterHTML:(NSString *)html
//{
//    NSScanner * scanner = [NSScanner scannerWithString:html];
//    NSString * text = nil;
//    while([scanner isAtEnd]==NO){
//        //找到标签的起始位置
//        [scanner scanUpToString:@"<" intoString:nil];
//        //找到标签的结束位置
//        [scanner scanUpToString:@">" intoString:&text];
//        //        //找到标签的起始位置
//        //        [scanner scanUpToString:@"<" intoString:nil];
//        //        //找到标签的结束位置
//        //        [scanner scanUpToString:@">" intoString:&text];
//        //替换字符
//        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
//        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
//    }
//    // NSString * regEx = @"<([^>]*)>";
//    // html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
//    return html;
//}

//获取webView中的所有图片URL
- (NSArray *) filterHTML:(NSString *) webString
{
    NSMutableArray * imageurlArray = [NSMutableArray arrayWithCapacity:1];
    //标签匹配
    NSString *parten = @"<img (.*?)>";
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:0 error:&error];
    NSArray* match = [reg matchesInString:webString options:0 range:NSMakeRange(0, [webString length] - 1)];
    for (NSTextCheckingResult * result in match) {
        
        //过去数组中的标签
        NSRange range = [result range];
        NSString * subString = [webString substringWithRange:range];

        //从图片中的标签中提取ImageURL
        NSRegularExpression *subReg = [NSRegularExpression regularExpressionWithPattern:@"\"(.*?)\"" options:0 error:NULL];
        NSArray* match = [subReg matchesInString:subString options:0 range:NSMakeRange(0, [subString length] - 1)];
        if (match.count==0) {
            return nil;
        }
        
        NSTextCheckingResult * subRes = match[0];
        NSRange subRange = [subRes range];
        subRange.length = subRange.length -1;
        NSString * imagekUrl = [subString substringWithRange:subRange];
        //将提取出的图片URL添加到图片数组中
        [imageurlArray addObject:imagekUrl];
    }
    return imageurlArray;
}

@end
