//
//  blumViewController.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/21.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define iOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))
#import "blumViewController.h"
#import "teacherList.h"
#import "MyHttpRequest.h"
#import "Helper.h"
#import "UIImageView+WebCache.h"
#import "classClassifyVc.h"
#import "blumList.h"
#import "blumTabelViewCell.h"
#import "MJRefresh.h"
#import "blumDetailVC.h"
#import "searchCourseVC.h"
#import "classDetailVC.h"
#import "BlumClassifyVc.h"
#import "classTableViewCell.h"
#import "classViewController.h"
#import "SYGBlumTool.h"
#import "SYGBlumTableViewCell.h"
#import "UIButton+WebCache.h"
#import "GLReachabilityView.h"
#import "UIColor+HTMLColors.h"
#import "LiveViewController.h"


@interface blumViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray *_array;
    UIView *_view;
    UILabel *_lable;
}
@property(nonatomic,assign)NSInteger numder;

@property (strong ,nonatomic)NSString *typeStr;

@property (strong ,nonatomic)UITableView *SYGTabelView;

@property (strong ,nonatomic)NSMutableArray *SYGArray;

@property (nonatomic,retain)NSString * num;

@property (strong ,nonatomic)NSString *SYGString;

@property (strong ,nonatomic)UISegmentedControl *SYGSegment;

@property (strong ,nonatomic)UIImageView *imageView;

@property (strong ,nonatomic)UIView *navView;

@end

@implementation blumViewController

- (id)initWithMemberId:(NSString *)MemberId
{
    if (self=[super init]) {
//        _cateory_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"User_id"];
//        NSLog(@"%@",MemberId);
        _cateory_id = MemberId;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    //隐藏
     self.navigationController.navigationBar.hidden = YES;
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SYG:) name:@"notificationSYG" object:nil];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
     self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self getPath];
//    [self addNav];
    [self isInstutionVc];
    [self addOrdTableView];

}


- (void)interFace {
    _view = (UIView *)[GLReachabilityView popview];
    [self.view addSubview:_view];
    //[GLReachabilityView isConnectionAvailable];
    _SYGArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SYG:) name:@"notificationSYG" object:nil];
    NSLog(@"%@",_institutionStr);

}

- (void)isInstutionVc {
    if ([_institutionStr isEqualToString:@"institutionStr"]) {//机构主页
        _navView.frame = CGRectMake(0, 0, 0, 0);
    } else {
        [self addNav];
    }
}

- (void)addNav {
    
    //创建view
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    _navView = navView;
    
    //添加分类按钮
    UIButton *FLButton = [UIButton buttonWithType:UIButtonTypeSystem];
    FLButton.frame = CGRectMake(15, 30, 20, 20);
    [FLButton setBackgroundImage:[UIImage imageNamed:@"fenleisyg"] forState:UIControlStateNormal];
    [FLButton addTarget:self action:@selector(calssifyClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:FLButton];
    
    
    //添加
    
    NSArray *titleArray = @[@"专辑",@"直播"];
    _SYGSegment = [[UISegmentedControl alloc] initWithItems:titleArray];
    _SYGSegment.frame = CGRectMake(MainScreenWidth / 2 - 60, 25, 120 , 30);
    _SYGSegment.selectedSegmentIndex = 0;
    [_SYGSegment setTintColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1]];
    [_SYGSegment addTarget:self action:@selector(typeChange:) forControlEvents:UIControlEventValueChanged];
    [navView addSubview:_SYGSegment];
    
    //添加分割线
    UILabel *FGLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 63.5, MainScreenWidth, 0.5)];
    FGLabel.backgroundColor = [UIColor colorWithRed:143.f / 255 green:143.f / 255 blue:143.f / 255 alpha:0.5];
    [navView addSubview:FGLabel];
}

- (void)SYG:(NSNotification *)SYGNot {
    
    NSLog(@"%@",SYGNot.userInfo);
    _SYGString = (NSString *)SYGNot.userInfo;
    if ([_SYGString isEqualToString:@"2"]) {//说明应该是从直播过来的
        
        _SYGSegment.selectedSegmentIndex = 0;
    }    
}

- (void)addOrdTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_navView.frame), MainScreenWidth, MainScreenHeight -93) style:UITableViewStyleGrouped];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _lable = [[UILabel alloc]initWithFrame:CGRectMake(0,50*MainScreenHeight/667,MainScreenWidth, 12)];
    [_tableView addSubview:_lable];
    [_tableView insertSubview:_lable atIndex:0];
    _lable.text = @"数据为空，刷新重试";
    _lable.textAlignment = NSTextAlignmentCenter;
    _lable.textColor = [UIColor clearColor];
    _lable.font = [UIFont systemFontOfSize:14];

    _tableView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 110;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,5,0,0)];
    }
    
    //设置表格分割线的长度（跟两边的距离）
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,2,0,0)];
    }
    
    //下拉刷新
    
    if (_tableView.hidden == NO) {//专辑
        
        [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshings)];
        [_tableView headerBeginRefreshing];
        
        //上拉加载
        [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    }
 
    
}


- (void)addSYGTabelView {
 
}

- (void)typeChange:(UISegmentedControl *)sender {
    
    UISegmentedControl* control = (UISegmentedControl*)sender;
    if (control.selectedSegmentIndex == 0) {//专辑
        NSLog(@"专辑");
        _tableView.hidden = NO;
        _SYGTabelView.hidden = YES;
        //这里网络请求
//        [self requestData:1];
    
        
    }else {//课程
        NSLog(@"直播");

        
//        classViewController *classVC = [[classViewController alloc] init];
//        classVC.formStr = @"888";
//        [self.navigationController pushViewController:classVC animated:NO];
        
        LiveViewController *liveVc = [[LiveViewController alloc] init];
//        classVC.formStr = @"888";
        [self.navigationController pushViewController:liveVc animated:NO];
        
        
    }

}

- (void)calssifyClick
{

    BlumClassifyVc * vc = [[BlumClassifyVc alloc]init];
    [ntvc isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController pushViewController:vc animated:YES];
    
    if (_tableView.hidden == NO) {//专辑
        vc.SYGInterger = 0;
        
    }else {//课程
        vc.SYGInterger = 1;
        
    }
    
}
-(void)cancelSearch
{
    searchCourseVC * svc = [[searchCourseVC alloc]init];
    [self.navigationController pushViewController:svc animated:YES];
}

-(void)reachGO{

    if([GLReachabilityView isConnectionAvailable]==1){
        
        _view.frame = CGRectMake(0, 0, 0, 0);
        _view.hidden = YES;
    }else{
        
        _view.frame = CGRectMake(0, 64, MainScreenWidth, 30);
        _view.hidden = NO;

    }
    [self.view bringSubviewToFront:_view];
    _tableView.frame = CGRectMake(0, 64+_view.frame.size.height, MainScreenWidth, MainScreenHeight - 93-_view.frame.size.height);
    [_tableView reloadData];

}
- (void)headerRerefreshings
{
    [self reachGO];
    [self requestData:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        if (_dataArray.count==0) {
            _lable.textColor = [UIColor colorWithHexString:@"#dedede"];
            
        }else{
            _lable.textColor = [UIColor clearColor];
        }

        
    });
    
    
}

- (void)footerRefreshing
{
    
    _numder++;
    [self requestData:_numder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
    

    
}


-(void)requestData:(NSInteger)num
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:_cateory_id forKey:@"cateId"];
    [dic setValue:[NSNumber numberWithInteger:num] forKey:@"page"];
    [dic setValue:@"20" forKey:@"count"];
    //取出缓存数据
    NSArray *blumsArray = [SYGBlumTool blumWithDic:dic];
//    NSLog(@"------%@",dic);

    
    [manager blum:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"///%@",responseObject);
        NSMutableArray * arr = [responseObject objectForKey:@"data"];
        [_array addObjectsFromArray:arr];
        
        //判断是否应该缓存，否则缓存数据就会重复
        if (blumsArray.count) {//已经有缓存,不再需要缓存
            NSLog(@"不需要");
        } else {
            //缓存数据
            [SYGBlumTool saveBlums:responseObject[@"data"]];
        }
       
        
        if(arr.count == 0)
        {
            if (num == 1) {
                NSLog(@"你好");
                //添加空白处理
                _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
                _imageView.image = [UIImage imageNamed:@"专辑@2x"];
                [self.view addSubview:_imageView];
                _imageView.hidden = NO;

            }
            
            
        }
        else{
            _imageView.hidden = YES;
            
            if (num == 1) {
                _dataArray = [NSMutableArray arrayWithArray:arr];
                
            }else {
                NSArray *SYGArray = [NSArray arrayWithArray:arr];
                [_dataArray addObjectsFromArray:SYGArray];
                
            }
            
            [_tableView reloadData];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog ( @"operation: %@" , operation. responseString);
        //当网络请求不成功的时候才走缓存的方法
        _dataArray = blumsArray;
        [_tableView reloadData];
  
        
    }];
 
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellStr = @"cellSYG";
    SYGBlumTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (cell == nil) {
        cell = [[SYGBlumTableViewCell alloc] initWithReuseIdentifier:cellStr];
    }
     [cell.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_dataArray[indexPath.row][@"cover"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"站位图"]];

    cell.titleLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"album_title"]];
    cell.contentLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"album_intro"]];
    cell.KSLabel.text = [NSString stringWithFormat:@"%@课时",_dataArray[indexPath.row][@"video_cont"]];
    cell.XBLabel.text = [NSString stringWithFormat:@"%@  元",_dataArray[indexPath.row][@"money_data"][@"overplus"]];
    NSString *MoneyStr = [NSString stringWithFormat:@"%@  元",_dataArray[indexPath.row][@"money_data"][@"overplus"]];
    NSString *XBStr = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"money_data"][@"overplus"]];
    //变颜色
    NSMutableAttributedString *needStr = [[NSMutableAttributedString alloc] initWithString:MoneyStr];
    [needStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] range:NSMakeRange(0, XBStr.length)];
    //设置字体加错
    [needStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, XBStr.length)];
    [needStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, XBStr.length)];
    [cell.XBLabel setAttributedText:needStr] ;
    
    NSString * starStr = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"album_score"]];
    NSLog(@"%@",_dataArray[indexPath.row][@"album_score"]);
    float length = [starStr floatValue];
    if (length == 1) {
        
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"101@2x"] forState:UIControlStateNormal];
    }

    if (length == 2) {
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"102@2x"] forState:UIControlStateNormal];
    } else {
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

     return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *blumID = _dataArray[indexPath.row][@"id"];
    NSString *blumTitle = _dataArray[indexPath.row][@"album_title"];
    
    blumDetailVC * bvc = [[blumDetailVC alloc]initWithMemberId:blumID andTitle:blumTitle];
    bvc.videoTitle = blumTitle;
    
    [self.navigationController pushViewController:bvc animated:YES];

}

-(void)addItem:(NSString *)title position:(itemblum)position image:(NSString *)image action:(SEL)action
{
    UIButton * button = [self button:title image:image frame:CGRectMake(0, 0, 52, 18)];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:button];
    if (position==Left_Itemb) {
        self.navigationItem.leftBarButtonItem = item;
    }else{
        self.navigationItem.rightBarButtonItem = item;
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

//创建文件路径 为缓存路径
- (void)getPath {
    NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:webPath])
    {
        [fileManager createDirectoryAtPath:webPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
}

@end
