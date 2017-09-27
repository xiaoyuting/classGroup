//
//  HomeViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/9/20.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//


#import "HomeViewController.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "MBProgressHUD+Add.h"
#import "Passport.h"
#import "AppDelegate.h"

#import "HomeSearchViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "UIImageView+WebCache.h"
#import <MapKit/MapKit.h>
#import "UIButton+WebCache.h"
#import "SDCycleScrollView.h"


#import "HomeMoreViewController.h"
#import "msgViewController.h"
#import "SearchGetViewController.h"
#import "HomeInstitutionViewController.h"
#import "DLViewController.h"

#import "InstitutionMainViewController.h"
#import "ChangeCityViewController.h"

#import "classViewController.h"
#import "LiveViewController.h"
#import "LiveDetailsViewController.h"
#import "classDetailVC.h"
#import "LiveViewController.h"
#import "teacherViewController.h"
#import "TeacherDetilViewController.h"

#import "LiveMoreViewController.h"
#import "BigImageViewController.h"
#import "AllLiveViewController.h"
#import "AdViewController.h"
#import "TeacherMainViewController.h"
#import "ZhiBoMainViewController.h"
#import "OnlyClassSearchViewController.h"

#import "SYGTextField.h"




@interface HomeViewController ()<UISearchBarDelegate,MKMapViewDelegate,CLLocationManagerDelegate,UIScrollViewDelegate,SDCycleScrollViewDelegate>

{
    CGFloat classViewH;
    NSString *cityName;
}

@property (strong ,nonatomic)UIScrollView *allScrollView;

@property (strong ,nonatomic)UIButton *cityButton;

@property (strong ,nonatomic)UIScrollView *imageScrollView;

@property (strong ,nonatomic)UIScrollView *cateScrollView;

@property (strong ,nonatomic)UIView *todayView;

@property (strong ,nonatomic)UIScrollView *liveScrollView;
@property (strong ,nonatomic)NSMutableArray *timeArray;//记录直播的时间

@property (assign ,nonatomic)NSInteger currentIndex;

@property (strong ,nonatomic)NSArray *imageDataArray;

@property (strong ,nonatomic)NSMutableArray *imageArray;
@property (strong ,nonatomic)NSMutableArray *bannerurlArray;

@property (strong ,nonatomic)NSMutableArray *imageViewArray;

@property (strong ,nonatomic)UIPageControl *pageControl;

@property (strong ,nonatomic)UIPageControl *catePageControl;

@property (assign ,nonatomic)NSInteger cateIndex;

@property (strong ,nonatomic)UIView *mayLiveView;

@property (strong ,nonatomic)UIView *forView;
@property (strong ,nonatomic)UIView *oneView;
@property (strong ,nonatomic)UIView *twoView;
@property (strong ,nonatomic)UIView *threeView;
@property (strong ,nonatomic)UIView *fourView;
@property (strong ,nonatomic)UIView *fiveView;
@property (strong ,nonatomic)UIView *sixView;
@property (strong ,nonatomic)UIView *sevenView;
@property (strong ,nonatomic)UIView *eightView;




@property (strong ,nonatomic)UIView *childView;
@property (strong ,nonatomic)UIView *primaryView;
@property (strong ,nonatomic)UIView *collegeView;
@property (strong ,nonatomic)UIView *workplaceView;
@property (strong ,nonatomic)UIView *jessicaView;
@property (strong ,nonatomic)UIScrollView *teacherScrollView;
@property (strong ,nonatomic)UIScrollView *enterScrollView;

@property (strong ,nonatomic)UILabel *teacherTitle;

@property (strong ,nonatomic)UILabel *enterTitle;

@property (strong ,nonatomic)NSTimer *timer;

@property (assign ,nonatomic)NSInteger timeNumber;

@property (assign ,nonatomic)BOOL     isRefresh;//是否继续刷新

//定位
@property (nonatomic, strong) CLLocationManager * locationManager;

@property (nonatomic, strong) MKMapView * mapView;

@property (strong ,nonatomic)UITableView *cityTableView;

@property (strong ,nonatomic)NSArray *cityDataArray;

@property (strong ,nonatomic)UIButton *allButton;

@end

@implementation HomeViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.navigationController.navigationBar.hidden = YES;
    
    if (_allScrollView.subviews.count < 3) {
        [self netWorkHomeGetAdvert];//再次刷新
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
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
    [self addNSNotfition];
    [self CLLocation];
    [self interFace];
    [self addNav];

    [self addAllScrollView];
    
    [self addImageScrollView];
    [self addCateScrollView];
    [self addLiveScrollView];
    [self addMayLiveView];
    
    [self addForView];
    
//    [self addTeacherTitle];
//    [self addTeacherScrollView];
//    [self addEnterTitle];
//    [self addEnterScrollView];
    
    [self netWorkHomeGetAdvert];

}

#pragma mark --- 通知
- (void)addNSNotfition {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NSNotficationCityInfo:) name:@"NSNotificationCityInfo" object:nil];
}

- (void)NSNotficationCityInfo:(NSNotification *)Not {
    NSString *title = Not.userInfo[@"title"];
    [_cityButton setTitle:title forState:UIControlStateNormal];
}

- (void)interFace {
    
    self.view.backgroundColor = [UIColor whiteColor];
    classViewH = SpaceBaside * 2 + 50 + (MainScreenWidth - SpaceBaside * 3) / 2 * 1.2 * 2 + SpaceBaside;
    
    _imageArray = [NSMutableArray array];
    _imageViewArray = [NSMutableArray array];
    _timeArray = [NSMutableArray array];
    _bannerurlArray = [NSMutableArray array];
    
    
    self.currentIndex = 0;
    _cateIndex = 0;
    _timeNumber = 0;
    _isRefresh = NO;
    
    //定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(NetWorkAgain) userInfo:nil repeats:YES];
    
}


- (void)NetWorkAgain {
    
    _timeNumber ++;
    if (_allScrollView.subviews.count < 10) {
        [self netWorkHomeGetAdvert];//再次刷新
        _isRefresh = YES;
    }
    
    if (_isRefresh) {
    } else {
        if (_timeNumber > 5) {
            [_timer invalidate];
            _timer = nil;
        }
    }

}

- (void)isGetLocation {
    //判定是否支持定位
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                                  message:@"当前应用不支持定位，请在设置界面开启"
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            
                                                        }];
        [alertController addAction:action];
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
    } else {
        
    }
    
}

- (void)CLLocation {
    
    //判定是否支持定位
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                                  message:@"当前应用不支持定位，请在设置界面开启"
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            
                                                        }];
        [alertController addAction:action];
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
    }

    //先配置定位
    self.locationManager = ({
        CLLocationManager * locationManager = [[CLLocationManager alloc] init];
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
        locationManager.delegate = self;
        
        //其他配置
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 1000;
        
        //开始定位
        [locationManager startUpdatingLocation];
        locationManager;
    });

}



- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    //添加搜索
//     UITextField *searchText = [[UITextField alloc] initWithFrame:CGRectMake(30, 25, MainScreenWidth - 80, 30)];
//    searchText.placeholder = @"搜索科目、老师、机构、课程";
////    [searchText setValue:Font(14) forKeyPath:@"_placeholderLabel.font"];
//    searchText.layer.borderWidth = 1;
//    searchText.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
//    searchText.backgroundColor = [UIColor whiteColor];
//    searchText.layer.cornerRadius = 5;
//    searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
//    
//    searchText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//    searchText.leftViewMode = UITextFieldViewModeAlways;
//    
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, 6, 18, 18)];
//    [button setImage:Image(@"yunketang_search") forState:UIControlStateNormal];
//    [searchText.leftView addSubview:button];
//    [SYGView addSubview:searchText];
    
//    //添加搜索
    SYGTextField *searchText = [[SYGTextField alloc] initWithFrame:CGRectMake(90, 25, MainScreenWidth - 150 , 30)];
    searchText.placeholder = @"搜索科目、老师、课程、机构";
    searchText.font = Font(14);
    [searchText setValue:Font(16) forKeyPath:@"_placeholderLabel.font"];
    [searchText sygDrawPlaceholderInRect:CGRectMake(0, 10, 0, 0)];
    searchText.layer.borderWidth = 1;
    searchText.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    searchText.backgroundColor = [UIColor whiteColor];
    searchText.layer.cornerRadius = 5;
    searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    searchText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    searchText.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, 6, 18, 18)];
    [button setImage:Image(@"yunketang_search") forState:UIControlStateNormal];
    [searchText.leftView addSubview:button];
    [SYGView addSubview:searchText];

    
    //添加透明的按钮
    UIButton *searchButton = [[UIButton alloc] initWithFrame:searchText.bounds];
    searchButton.backgroundColor = [UIColor clearColor];
    [searchButton addTarget:self action:@selector(homeSearchButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [searchText addSubview:searchButton];
    
    //添加城市按钮
    UIButton *cityButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, 25, 80, 30)];
    cityButton.titleLabel.font = Font(14);
    cityButton.backgroundColor = BasidColor;
    [cityButton setImage:[UIImage imageNamed:@"白色向下@2x"] forState:UIControlStateNormal];
    cityButton.imageEdgeInsets =  UIEdgeInsetsMake(5,51,4,10);
    cityButton.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 20);
   // cityButton.hidden = YES;

    [cityButton setTitle:@"定位中" forState:UIControlStateNormal];
    [cityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cityButton addTarget:self action:@selector(cityButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:cityButton];
    _cityButton = cityButton;
    
    //添加信息按钮
    UIButton *messageButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 40, 30, 20, 20)];
    [messageButton setBackgroundImage:Image(@"iconfont-bf-message@2x") forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(messageButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:messageButton];
    
}

- (void)addAllScrollView {
    
    _allScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight * 2)];
    _allScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _allScrollView.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight * 8 + 200);
    _allScrollView.showsHorizontalScrollIndicator = NO;
    _allScrollView.showsVerticalScrollIndicator = NO;
    _allScrollView.delegate = self;
    [self.view addSubview:_allScrollView];
    
}

- (void)addImageScrollView {
    
    _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 200)];
    _imageScrollView.backgroundColor = [UIColor whiteColor];
    _imageScrollView.pagingEnabled = YES;
    _imageScrollView.showsHorizontalScrollIndicator = NO;
    _imageScrollView.showsVerticalScrollIndicator = NO;
    _imageScrollView.contentSize = CGSizeMake(MainScreenWidth * 3, 200);
    [_allScrollView addSubview:_imageScrollView];
    
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, MainScreenWidth, 200*MainScreenWidth/375) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    if (iPhone5o5Co5S) {
        cycleScrollView3.frame = CGRectMake(0, 0, MainScreenWidth, 230 * MainScreenWidth / 357);
    } else if (iPhone6) {
        cycleScrollView3.frame = CGRectMake(0, 0, MainScreenWidth, 190 * MainScreenWidth / 357);
    } else if (iPhone6Plus) {
        cycleScrollView3.frame = CGRectMake(0, 0, MainScreenWidth, 180 * MainScreenWidth / 357);
    }
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    cycleScrollView3.imageURLStringsGroup = _imageArray;
    cycleScrollView3.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView3.delegate = self;
    [_imageScrollView addSubview:cycleScrollView3];

    
    
}


- (void)addCateScrollView {
    
    _cateScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageScrollView.frame), MainScreenWidth, 200)];
    _cateScrollView.backgroundColor = [UIColor whiteColor];
    _cateScrollView.pagingEnabled = YES;
    _cateScrollView.delegate = self;
    _cateScrollView.showsHorizontalScrollIndicator = NO;
    _cateScrollView.showsVerticalScrollIndicator = NO;
    if (_cateArray.count % 10 == 0) {
        _cateScrollView.contentSize = CGSizeMake(MainScreenWidth * (_cateArray.count / 10), 0);
    } else {
        _cateScrollView.contentSize = CGSizeMake(MainScreenWidth * (_cateArray.count / 10 + 1), 0);
    }
    [_allScrollView addSubview:_cateScrollView];
    
    //添加按钮
    
    NSInteger Num = 5;
    CGFloat ButtonW = (MainScreenWidth - (Num + 1) * SpaceBaside) / Num;
    CGFloat ButtonH = ButtonW;
    CGFloat allW = ButtonW;
    CGFloat allH = ButtonH + 20;//20 为显示字
    NSInteger oneCount = 10;
    NSInteger twoCount;
    if (_cateArray.count <= 10) {
        oneCount = _cateArray.count;
    }
    
    for (int i = 0 ; i < oneCount; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside + (i % Num) * (ButtonW + SpaceBaside), SpaceBaside + (i / Num) * (allH + SpaceBaside), allW, allH)];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = Font(16);
//        [button setTitle:_cateArray[i][@"title"] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        NSString *urlStr = _cateArray[i][@"icon"];
        [button sd_setImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
        
        button.imageEdgeInsets =  UIEdgeInsetsMake(5,5,allH - allW + 5,5);
//        button.titleEdgeInsets = UIEdgeInsetsMake(ButtonH,-100 ,0 ,0);

        button.imageView.layer.cornerRadius = ButtonW / 2 - 5;
        button.imageView.layer.masksToBounds = YES;
        button.tag = i;
        [button addTarget:self action:@selector(cateButton:) forControlEvents:UIControlEventTouchUpInside];
        [_cateScrollView addSubview:button];
        
        //添加名字
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, ButtonH, ButtonW, 20)];
//        name.text = _cateArray[i][@"title"];
        name.text = [[_cateArray objectAtIndex:i] stringValueForKey:@"title"];
        name.font = Font(12);
        name.textAlignment = NSTextAlignmentCenter;
        name.textColor = BlackNotColor;
        [button addSubview:name];
        
        
        _cateScrollView.frame = CGRectMake(0, CGRectGetMaxY(_imageScrollView.frame), MainScreenWidth,2 * allH + 5 * SpaceBaside);
    }
    
    if (_cateArray.count > 10) {
        twoCount = _cateArray.count;
    } else {
        twoCount = 10;
    }
    
    for (int i = 10 ; i < twoCount; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside + MainScreenWidth  + (i % Num) * (ButtonW + SpaceBaside), SpaceBaside + ((i - 10 )/ Num) * (allH + SpaceBaside),allW, allH)];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = Font(16);
        [button setTitle:@"运动" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        NSString *urlStr = _cateArray[i][@"icon"];
        NSString *urlStr = [[_cateArray objectAtIndex:i] stringValueForKey:@"icon"];;
        [button sd_setImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
        
        button.imageEdgeInsets =  UIEdgeInsetsMake(0,0,allH - allW,0);
//        button.titleEdgeInsets = UIEdgeInsetsMake(ButtonH,-50 ,0 ,0);
        
        button.tag = i;
        [button addTarget:self action:@selector(cateButton:) forControlEvents:UIControlEventTouchUpInside];
        [_cateScrollView addSubview:button];
        
        //添加名字
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, ButtonH, ButtonW, 20)];
//        name.text = _cateArray[i][@"title"];
        name.text = [[_cateArray objectAtIndex:i] stringValueForKey:@"title"];
        name.font = Font(12);
        name.textAlignment = NSTextAlignmentCenter;
        name.textColor = BlackNotColor;
        [button addSubview:name];
        
        
    }

    _catePageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(MainScreenWidth / 2 - 40, CGRectGetMaxY(_cateScrollView.frame) - 25, 80, 20)];
    _catePageControl.pageIndicatorTintColor = [UIColor grayColor];
    _catePageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    _catePageControl.currentPage = _cateIndex;
    _catePageControl.numberOfPages = _cateArray.count / 10 + 1;
    if (_cateArray.count % 10 == 0) {
        _catePageControl.numberOfPages = _cateArray.count / 10 ;
    } else {
        _catePageControl.numberOfPages = _cateArray.count / 10 + 1;
    }
    if (_catePageControl.numberOfPages == 1) {
        _catePageControl.hidden = YES;
    }
    
    [self.allScrollView addSubview:_catePageControl];

}

- (void)addTodayView {
    _todayView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_cateScrollView.frame) + SpaceBaside , MainScreenWidth, 30)];
    _todayView.backgroundColor = [UIColor whiteColor];
    [_allScrollView addSubview:_todayView];
    
    //添加按钮
    UILabel *todayLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 0, MainScreenWidth - 2 * SpaceBaside, 30)];
    todayLabel.text = @"这是今日头条";
    todayLabel.font = Font(15);
    [_todayView addSubview:todayLabel];
    
}


- (void)addLiveScrollView {
    
    //标题
    UILabel *liveLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, CGRectGetMaxY(_cateScrollView.frame), 120, 30)];
    liveLabel.text = @"直播大厅";
//    liveLabel.font = Font(15);
    [_allScrollView addSubview:liveLabel];
    liveLabel.userInteractionEnabled = YES;
    
    
    _liveScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cateScrollView.frame) + 30, MainScreenWidth , 200)];
    _liveScrollView.backgroundColor = [UIColor whiteColor];
    _liveScrollView.showsHorizontalScrollIndicator = NO;
    _liveScrollView.showsVerticalScrollIndicator = NO;
    _liveScrollView.contentSize = CGSizeMake(MainScreenWidth * 2, 200);
    _liveScrollView.userInteractionEnabled = YES;
    [_allScrollView addSubview:_liveScrollView];
    
    CGFloat ButtonW = 120;
    CGFloat ButtonH = 80;
    NSInteger Num = _liveArray.count;
    
    //添加线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, 14, Num * (SpaceBaside + ButtonW), 2)];
    lineButton.backgroundColor = BasidColor;
    [_liveScrollView addSubview:lineButton];
    
    
    //添加时间轴
    for (int i = 0 ; i < Num; i ++) {
        UIButton *timeButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside + (SpaceBaside + ButtonW) * i, 10, 40, 8)];
//        NSArray *sectionsArray = _liveArray[i][@"sections"];
        NSArray *sectionsArray = [[_liveArray objectAtIndex:i] arrayValueForKey:@"sections"];;
        NSString *startTime = nil;
        NSString *startHour = nil;
        if (sectionsArray.count) {
            NSLog(@"%@",_liveArray[i]);
            startTime = [Passport formatterTime:[[sectionsArray objectAtIndex:0] stringValueForKey:@"startDate"]];
            NSLog(@"%@",startTime);
            startHour = [startTime substringWithRange:NSMakeRange(11, 5)];
            [_timeArray addObject:startHour];
            [timeButton setTitle:startHour forState:UIControlStateNormal];
        } else {
            timeButton.hidden = YES;
        }
        
        timeButton.backgroundColor = [UIColor whiteColor];
        [timeButton setTitleColor:BasidColor forState:UIControlStateNormal];
        [timeButton setImage:Image(@"直播圆点") forState:UIControlStateNormal];
        timeButton.titleLabel.font = Font(10);
        [_liveScrollView addSubview:timeButton];
        
//        if (_timeArray.count && i > 0) {
//            NSString *oldTimeStr = _timeArray[i - 1];
//            if ([oldTimeStr isEqualToString:startHour]) {//说明时间重合
//                timeButton.hidden = YES;
//            }
//        }
    }
    
    //添加直播的课程
    for (int i = 0 ; i < Num; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside + i * (ButtonW + SpaceBaside), 30, ButtonW, ButtonH)];
        NSString *urlStr = [[_liveArray objectAtIndex:i] stringValueForKey:@"imageurl"];;
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
        [_liveScrollView addSubview:button];
        button.tag = i;
        button.userInteractionEnabled = YES;
        [button addTarget:self action:@selector(liveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        NSArray *sectionsArray = [[_liveArray objectAtIndex:i] arrayValueForKey:@"sections"];;;
        
        //添加介绍
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside + i * (ButtonW + SpaceBaside), 30 + ButtonH, ButtonW, 40)];
        if (sectionsArray.count) {
            label.text = [[_liveArray objectAtIndex:i] stringValueForKey:@"video_title"];
        }
        label.font = Font(14);
        label.numberOfLines = 1;
        [_liveScrollView addSubview:label];
        
        //添加人数报名
        UILabel *person = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside + i * (ButtonW + SpaceBaside), 30 + ButtonH + 40, ButtonW, 10)];
        person.text = [NSString stringWithFormat:@"%@人报名",[[_liveArray objectAtIndex:i] stringValueForKey:@"video_order_count"]];
        person.font = Font(12);
        person.textColor = [UIColor grayColor];
        [_liveScrollView addSubview:person];

        //添加透明的按钮
        UIButton *liveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_liveScrollView.frame), CGRectGetHeight(_liveScrollView.frame))];
        liveButton.backgroundColor = [UIColor clearColor];
        [liveButton addTarget:self action:@selector(liveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        liveButton.tag = i;
        liveButton.enabled = YES;
        [_liveScrollView addSubview:liveButton];
        liveButton.hidden = YES;
        
    }
    
    
    //添加更多按钮
    UIButton *liveMoreButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 50, CGRectGetMaxY(_liveScrollView.frame) - 40, 100, 30)];
    [liveMoreButton setTitle:@"进入大厅" forState:UIControlStateNormal];
    liveMoreButton.titleLabel.font = Font(14);
    [liveMoreButton setTitleColor:BlackNotColor forState:UIControlStateNormal];
    [liveMoreButton setImage:Image(@"首页更多") forState:UIControlStateNormal];
    liveMoreButton.imageEdgeInsets =  UIEdgeInsetsMake(0,80,0,0);
    liveMoreButton.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 20);
    [liveMoreButton addTarget:self action:@selector(moreButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    liveMoreButton.tag = 100;
    [_allScrollView addSubview:liveMoreButton];
    
    //设置滚动的范围
    _liveScrollView.contentSize = CGSizeMake(Num * ButtonW + (Num + 1) * SpaceBaside, 0);
    
    
    //直播数据为空的时候 就隐藏
    if (_liveArray.count == 0) {
        _liveScrollView.frame = CGRectMake(0, CGRectGetMaxY(_cateScrollView.frame) + 30, MainScreenWidth, 0);
        liveLabel.hidden = YES;
    }

    

}

- (void)addMayLiveView {

    _mayLiveView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_liveScrollView.frame), MainScreenWidth, classViewH)];
    _mayLiveView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_allScrollView addSubview:_mayLiveView];

    //添加标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, MainScreenWidth - SpaceBaside * 2, 30)];
    titleLabel.text = @"";
    if (_likeArray.count > 0) {
        titleLabel.text = @"猜你喜欢";
    }
    if (iPhone6Plus) {
        if (_likeArray.count == 0) {
            titleLabel.text = @"";
        }
    } else {
        if (_likeArray.count == 0) {
            titleLabel.text = @"";
        }
    }
    [_mayLiveView addSubview:titleLabel];

    //添加更多按钮
    UIButton *liveButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 70, SpaceBaside, 60, 30)];
    [liveButton setTitle:@"更多" forState:UIControlStateNormal];
    liveButton.titleLabel.font = Font(14);
    [liveButton setTitleColor:BlackNotColor forState:UIControlStateNormal];
    [liveButton setImage:Image(@"首页更多") forState:UIControlStateNormal];
    liveButton.imageEdgeInsets =  UIEdgeInsetsMake(0,40,0,0);
    liveButton.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 20);
    [liveButton addTarget:self action:@selector(moreButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    liveButton.tag = 200;
    [_mayLiveView addSubview:liveButton];
    liveButton.hidden = YES;
    
    //添加View
    for (int i = 0 ; i < _likeArray.count ; i ++) {
        NSInteger Num = 2;
        
        CGFloat viewW = (MainScreenWidth - SpaceBaside * 3) / 2;
        CGFloat viewH = viewW * 1.2;
        
        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(SpaceBaside + SpaceBaside * (i % Num) + viewW * (i % Num), CGRectGetMaxY(liveButton.frame) + SpaceBaside + (viewH + SpaceBaside) * (i / Num), viewW, viewH)];
        buttonView.layer.cornerRadius = 5;
        buttonView.layer.masksToBounds = YES;
        buttonView.backgroundColor = [UIColor whiteColor];
        [_mayLiveView addSubview:buttonView];
        
        //在View 上面添加东西
        UIImageView *buttonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH / 2)];
//        NSString *urlStr = _likeArray[i][@"imageurl"];
        NSString *urlStr = [[_likeArray objectAtIndex:i] stringValueForKey:@"imageurl"];
        [buttonImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
        [buttonView addSubview:buttonImageView];
        
        //添加介绍
        UILabel *nameButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside,viewW / 2 + SpaceBaside * 2, viewW - SpaceBaside * 2, 50)];
//        nameButtonLabel.text = _likeArray[i][@"video_title"];
        nameButtonLabel.text = [[_likeArray objectAtIndex:i] stringValueForKey:@"video_title"];
        nameButtonLabel.numberOfLines = 2;
        nameButtonLabel.textColor = BlackNotColor;
        [buttonView addSubview:nameButtonLabel];
        
        //添加价格
        UILabel *priceButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, viewW / 2 + 80, viewW - SpaceBaside * 2, 20)];
        if ([_likeArray[i][@"price"] integerValue] == 0) {
            priceButtonLabel.text = @"免费";
            priceButtonLabel.textColor = [UIColor greenColor];
        } else {
//            priceButtonLabel.text = [NSString stringWithFormat:@"￥%@",_likeArray[i][@"price"]];
            priceButtonLabel.text = [NSString stringWithFormat:@"￥%@",[[_likeArray objectAtIndex:i] stringValueForKey:@"price"]];
            priceButtonLabel.textColor = [UIColor redColor];
        }

        [buttonView addSubview:priceButtonLabel];
        
        //往View 上面添加button
        UIButton *viewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(buttonView.frame), CGRectGetHeight(buttonView.frame))];
        viewButton.backgroundColor = [UIColor clearColor];
        viewButton.tag = i;
        [viewButton addTarget:self action:@selector(mayLike_imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:viewButton];
    }
}

- (void)addForView {
    
    _forView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mayLiveView.frame), MainScreenWidth,  3.5 * classViewH)];
    _forView.backgroundColor = [UIColor redColor];
    [_allScrollView addSubview:_forView];
    
    //判断为空的时候
    if (_videoArray.count == 0) {
        _forView.frame = CGRectMake(0, CGRectGetMaxY(_mayLiveView.frame), MainScreenWidth,0);
        return;
    }
    
    for (int k = 0 ; k < _videoArray.count ; k ++) {
        
//        NSArray *listInfoArray = _videoArray[k][@"video_list"];
        NSArray *listInfoArray = [[_videoArray objectAtIndex:k] arrayValueForKey:@"video_list"];
        NSInteger listNum = listInfoArray.count;
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0, k * classViewH, MainScreenWidth, classViewH)];
        if (k == 0) {
            if (listNum % 2 == 0) {
                childView.frame = CGRectMake(0, 0,MainScreenWidth , (listNum / 2) * (classViewH / 2));
            } else {
                childView.frame = CGRectMake(0, 0,MainScreenWidth , (listNum / 2 + 1) * (classViewH / 2));
            }
            _oneView = childView;
        } else if (k == 1) {
            if (listNum % 2 == 0) {
                childView.frame = CGRectMake(0, CGRectGetMaxY(_oneView.frame),MainScreenWidth , (listNum / 2) * (classViewH / 2));
            } else {
                childView.frame = CGRectMake(0, CGRectGetMaxY(_oneView.frame),MainScreenWidth , (listNum / 2 + 1) * (classViewH / 2));
            }
            _twoView = childView;
        } else if (k == 2) {
            if (listNum % 2 == 0) {
                childView.frame = CGRectMake(0, CGRectGetMaxY(_twoView.frame),MainScreenWidth , (listNum / 2) * (classViewH / 2));
            } else {
                childView.frame = CGRectMake(0, CGRectGetMaxY(_twoView.frame),MainScreenWidth , (listNum / 2 + 1) * (classViewH / 2));
            }
            _threeView = childView;
        } else if (k == 3) {
            if (listNum % 2 == 0) {
                childView.frame = CGRectMake(0, CGRectGetMaxY(_threeView.frame),MainScreenWidth , (listNum / 2) * (classViewH / 2));
            } else {
                childView.frame = CGRectMake(0, CGRectGetMaxY(_threeView.frame),MainScreenWidth , (listNum / 2 + 1) * (classViewH / 2));
            }
            _fourView = childView;
        } else if (k == 4) {
            if (listNum % 2 == 0) {
                childView.frame = CGRectMake(0, CGRectGetMaxY(_fourView.frame),MainScreenWidth , (listNum / 2) * (classViewH / 2));
            } else {
                childView.frame = CGRectMake(0, CGRectGetMaxY(_fourView.frame),MainScreenWidth , (listNum / 2 + 1) * (classViewH / 2));
            }
            _fiveView = childView;
        } else if (k == 5) {
            if (listNum % 2 == 0) {
                childView.frame = CGRectMake(0, CGRectGetMaxY(_fiveView.frame),MainScreenWidth , (listNum / 2) * (classViewH / 2));
            } else {
                childView.frame = CGRectMake(0, CGRectGetMaxY(_fiveView.frame),MainScreenWidth , (listNum / 2 + 1) * (classViewH / 2));
            }
            _sixView = childView;
        } else if (k == 6) {
            if (listNum % 2 == 0) {
                childView.frame = CGRectMake(0, CGRectGetMaxY(_sixView.frame),MainScreenWidth , (listNum / 2) * (classViewH / 2));
            } else {
                childView.frame = CGRectMake(0, CGRectGetMaxY(_sixView.frame),MainScreenWidth , (listNum / 2 + 1) * (classViewH / 2));
            }
            _sevenView = childView;
        } else if (k == 7) {
            if (listNum % 2 == 0) {
                childView.frame = CGRectMake(0, CGRectGetMaxY(_sevenView.frame),MainScreenWidth , (listNum / 2) * (classViewH / 2));
            } else {
                childView.frame = CGRectMake(0, CGRectGetMaxY(_sevenView.frame),MainScreenWidth , (listNum / 2 + 1) * (classViewH / 2));
            }
            _eightView = childView;
        }
        childView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_forView addSubview:childView];
        //添加标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, MainScreenWidth - SpaceBaside * 2, 30)];
        if ([[_videoArray objectAtIndex:k] arrayValueForKey:@"video_list"].count == 0) {
        } else {
            titleLabel.text = [[_videoArray objectAtIndex:k] stringValueForKey:@"title"];
        }
        
        [childView addSubview:titleLabel];
        //添加更多按钮
        UIButton *liveButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 70, SpaceBaside, 60, 30)];
        [liveButton setTitle:@"更多" forState:UIControlStateNormal];
        liveButton.titleLabel.font = Font(14);
        [liveButton setTitleColor:BlackNotColor forState:UIControlStateNormal];
        [liveButton setImage:Image(@"首页更多") forState:UIControlStateNormal];
        liveButton.imageEdgeInsets =  UIEdgeInsetsMake(0,40,0,0);
        liveButton.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 20);
        [liveButton addTarget:self action:@selector(forViewMoreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        liveButton.tag = k;
        [childView addSubview:liveButton];
        
        //确定最终的尺寸
        _forView.frame = CGRectMake(0, CGRectGetMaxY(_mayLiveView.frame), MainScreenWidth, CGRectGetMaxY(childView.frame));
    
        NSArray *listArray = [[_videoArray objectAtIndex:k] arrayValueForKey:@"video_list"];;
        //添加View
        for (int i = 0 ; i < listArray.count ; i ++) {
            NSInteger Num = 2;
            
            CGFloat viewW = (MainScreenWidth - SpaceBaside * 3) / 2;
            CGFloat viewH = viewW * 1.2;
            
            UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(SpaceBaside + SpaceBaside * (i % Num) + viewW * (i % Num), CGRectGetMaxY(liveButton.frame) + SpaceBaside + (viewH + SpaceBaside) * (i / Num), viewW, viewH)];
            buttonView.layer.cornerRadius = 5;
            buttonView.layer.masksToBounds = YES;
            buttonView.backgroundColor = [UIColor whiteColor];
            [childView addSubview:buttonView];
            
            //在View 上面添加东西
            UIImageView *buttonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH / 2)];
            NSString *urlStr = [[listArray objectAtIndex:i] stringValueForKey:@"imageurl"];;
            [buttonImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
            [buttonView addSubview:buttonImageView];
            
            //添加介绍
            UILabel *nameButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside,viewW / 2 + SpaceBaside * 2, viewW - SpaceBaside * 2, 50)];
            nameButtonLabel.text = [[listArray objectAtIndex:i] stringValueForKey:@"video_title"];
            nameButtonLabel.numberOfLines = 2;
            nameButtonLabel.textColor = BlackNotColor;
            [buttonView addSubview:nameButtonLabel];
            
            //添加价格
            UILabel *priceButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, viewW / 2 + 80, viewW - SpaceBaside * 2, 20)];
            if ([[[listArray objectAtIndex:i] stringValueForKey:@"v_price"] integerValue] == 0) {
                priceButtonLabel.text = @"免费";
                priceButtonLabel.textColor = [UIColor greenColor];
            } else {
                priceButtonLabel.text = [NSString stringWithFormat:@"￥%@",[[listArray objectAtIndex:i] stringValueForKey:@"v_price"]];
                priceButtonLabel.textColor = [UIColor redColor];
            }

            [buttonView addSubview:priceButtonLabel];
            
            
            //添加机构名
            UILabel *schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewW / 2, viewW / 2 + 80, viewW / 2, 20)];
            schoolLabel.text = @"大风车";
            schoolLabel.textAlignment = NSTextAlignmentRight;
            schoolLabel.font = Font(15);
            schoolLabel.textColor = [UIColor grayColor];
            [buttonView addSubview:schoolLabel];
            schoolLabel.hidden = YES;
            
            //往View 上面添加button
            UIButton *viewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(buttonView.frame), CGRectGetHeight(buttonView.frame))];
            viewButton.backgroundColor = [UIColor clearColor];
            [viewButton addTarget:self action:@selector(forViewimageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [buttonView addSubview:viewButton];
            
            //添加tag值
            viewButton.tag = k * 10 + i;
        }
    }
}

- (void)addTeacherTitle {
    
    _teacherTitle = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, CGRectGetMaxY(_forView.frame) + SpaceBaside, MainScreenWidth - SpaceBaside * 2, 30)];
    _teacherTitle.text = @"名师推荐";
    if (_teacherArray.count == 0) {
        _teacherTitle.text = @"";
    } else {
        
    }
    [_allScrollView addSubview:_teacherTitle];
    
    //添加名师的更多
    UIButton *teacherButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 70, CGRectGetMaxY(_forView.frame) + SpaceBaside, 60, 30)];
    [teacherButton setTitle:@"更多" forState:UIControlStateNormal];
    teacherButton.titleLabel.font = Font(14);
    [teacherButton setTitleColor:BlackNotColor forState:UIControlStateNormal];
    [teacherButton setImage:Image(@"首页更多") forState:UIControlStateNormal];
    teacherButton.imageEdgeInsets =  UIEdgeInsetsMake(0,40,0,0);
    teacherButton.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 20);
    [teacherButton addTarget:self action:@selector(moreButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    teacherButton.tag = 800;
    [_allScrollView addSubview:teacherButton];
}

- (void)addTeacherScrollView {
    
    _teacherScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_teacherTitle.frame), MainScreenWidth, 200)];
    if (iPhone6) {
        _teacherScrollView.frame = CGRectMake(0, CGRectGetMaxY(_teacherTitle.frame), MainScreenWidth, 160);
    } else if (iPhone6Plus) {
        _teacherScrollView.frame = CGRectMake(0, CGRectGetMaxY(_teacherTitle.frame), MainScreenWidth, 180);
    } else if (iPhone5o5Co5S) {
        _teacherScrollView.frame = CGRectMake(0, CGRectGetMaxY(_teacherTitle.frame), MainScreenWidth, 150);
    }
    _teacherScrollView.contentSize = CGSizeMake(MainScreenWidth * 2, 0);
    _teacherScrollView.backgroundColor = [UIColor whiteColor];
    _teacherScrollView.showsHorizontalScrollIndicator = NO;
    _teacherScrollView.showsVerticalScrollIndicator = NO;
    _teacherScrollView.pagingEnabled = YES;
    [_allScrollView addSubview:_teacherScrollView];
    _teacherScrollView.scrollEnabled = NO;
    
    for (int i = 0 ; i < _teacherArray.count; i ++) {
        CGFloat viewW = (MainScreenWidth - SpaceBaside * 4) / 3;
        CGFloat viewH = viewW + 60;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SpaceBaside + (SpaceBaside + viewW ) * i, SpaceBaside, viewW, viewH)];
        view.backgroundColor = [UIColor whiteColor];
        [_teacherScrollView addSubview:view];
        
        UIButton *teacherButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, SpaceBaside, viewW - SpaceBaside * 2, viewW - SpaceBaside * 2)];
        teacherButton.imageView.layer.cornerRadius = 40;
        teacherButton.layer.masksToBounds = YES;
        NSString *urlStr = [[_teacherArray objectAtIndex:i] stringValueForKey:@"headimg"];
        [teacherButton sd_setImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];

//        teacherButton.backgroundColor = [UIColor redColor];
        [view addSubview:teacherButton];
        
        //添加名字
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, viewW, viewW, 20)];
        nameLabel.text = [[_teacherArray objectAtIndex:i] stringValueForKey:@"name"];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = Font(14);
        [view addSubview:nameLabel];
        
        //添加介绍
        UILabel *introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,viewW + 20, viewW, 40)];
        introduceLabel.text = [[_teacherArray objectAtIndex:i] stringValueForKey:@"label"];
        introduceLabel.font = Font(13);
        introduceLabel.textAlignment = NSTextAlignmentCenter;
        introduceLabel.numberOfLines = 2;
        [view addSubview:introduceLabel];

        //往View 上面添加button
        UIButton *viewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))];
        viewButton.backgroundColor = [UIColor clearColor];
        viewButton.tag = i;
        [viewButton addTarget:self action:@selector(teacherButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:viewButton];
    }
}

- (void)addEnterTitle {
    
    _enterTitle = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, CGRectGetMaxY(_teacherScrollView.frame) + SpaceBaside, MainScreenWidth - SpaceBaside * 2, 30)];
    _enterTitle.text = @"入驻机构";
    if (_schoolArray.count == 0) {
        _enterTitle.text = @"";
    } else {
        
    }
    [_allScrollView addSubview:_enterTitle];
    
    //添加名师的更多
    UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 70, CGRectGetMaxY(_teacherScrollView.frame) + SpaceBaside, 60, 30)];
    [enterButton setTitle:@"更多" forState:UIControlStateNormal];
    enterButton.titleLabel.font = Font(14);
    [enterButton setTitleColor:BlackNotColor forState:UIControlStateNormal];
    [enterButton setImage:Image(@"首页更多") forState:UIControlStateNormal];
    enterButton.imageEdgeInsets =  UIEdgeInsetsMake(0,40,0,0);
    enterButton.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 20);
    [enterButton addTarget:self action:@selector(moreButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    enterButton.tag = 900;
    [_allScrollView addSubview:enterButton];
}

- (void)addEnterScrollView {
    _enterScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_enterTitle.frame), MainScreenWidth, 160)];
    _enterScrollView.contentSize = CGSizeMake(MainScreenWidth * 2, 0);
    _enterScrollView.backgroundColor = [UIColor whiteColor];
    _enterScrollView.showsHorizontalScrollIndicator = NO;
    _enterScrollView.pagingEnabled = YES;
    _enterScrollView.showsVerticalScrollIndicator = NO;
    [_allScrollView addSubview:_enterScrollView];
    
    _enterScrollView.scrollEnabled = NO;
    
    NSLog(@"%@",_schoolArray);
    
    CGFloat viewW = (MainScreenWidth - SpaceBaside * 8) / 4;
    
    for (int i = 0 ; i < _schoolArray.count ; i ++) {

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SpaceBaside + (SpaceBaside * 2 + viewW ) * i, SpaceBaside * 2, viewW, viewW)];
        view.backgroundColor = [UIColor whiteColor];
        [_enterScrollView addSubview:view];

        NSString *urlStr = [[_schoolArray objectAtIndex:i] stringValueForKey:@"logo"];
        UIButton *teacherButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewW, viewW)];
        [teacherButton sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
        teacherButton.tag = i;
        [teacherButton addTarget:self action:@selector(institutionVc:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:teacherButton];
    }
    _enterScrollView.frame = CGRectMake(0, CGRectGetMaxY(_enterTitle.frame), MainScreenWidth,viewW + 40);
    _allScrollView.contentSize = CGSizeMake(MainScreenWidth, CGRectGetMaxY(_enterScrollView.frame)+ classViewH + 300);
}

#pragma mark --- CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //NSLog(@%@,placemark.name);//具体位置
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             cityName = city;
             NSLog(@"定位完成:%@",cityName);
            [_cityButton setTitle:cityName forState:UIControlStateNormal];
             //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
             [manager stopUpdatingLocation];
         }else if (error == nil && [array count] == 0) {
             [MBProgressHUD showError:@"定位失败" toView:self.view];
             [_cityButton setTitle:@"定位失败" forState:UIControlStateNormal];
         }else if (error != nil) {
             [MBProgressHUD showError:@"定位失败" toView:self.view];
             [_cityButton setTitle:@"定位失败" forState:UIControlStateNormal];
         }
     }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"shibai");
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                              message:@"当前应用不支持定位，请在设置界面开启"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        
                                                    }];
    [alertController addAction:action];
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];

    [_cityButton setTitle:@"定位失败" forState:UIControlStateNormal];
    
}
//
//#pragma mark --- 滚动视图
//- (void)pageLeft {
//    
//    _currentIndex = (--_currentIndex + self.imageArray.count) % self.imageArray.count;
//    [self dynamicLoadingImage];
//}
//- (void)pageRight {
//    
//    _currentIndex = (++_currentIndex + self.imageArray.count) % self.imageArray.count;
//    [self dynamicLoadingImage];
//}
//- (void)dynamicLoadingImage {
//    
//    //1.设置当前pageControl下标
//    self.pageControl.currentPage = self.currentIndex;
//    //2.循环配置图片
//    for (int i = 0; i <= 1; i ++) {
//        //2.1获取当前下标
//        NSInteger index = (_currentIndex + i + _imageArray.count) % _imageArray.count;
//        //        2.2取出相应的ImageView
////        UIImageView *imageView = self.imageViewArray[i + 1];
//         UIImageView *imageView = self.imageViewArray[i];
//        //        2.3进行图片关联
////        imageView.image = Image(_imageArray[index]);
//        [imageView sd_setImageWithURL:_imageArray[index]];
//    }
//    //设置偏移量
//    [self.imageScrollView setContentOffset:CGPointMake(CGRectGetWidth(_imageScrollView.bounds), 0) animated:YES];
//
//}



#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"%@",_imageArray);
    NSLog(@"---点击了第%ld张图片", (long)index);
    
    AdViewController *adVc = [[AdViewController alloc] init];
    adVc.adStr = _bannerurlArray[index];
    [self.navigationController pushViewController:adVc animated:YES];
}

#pragma mark --- ScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (_cateScrollView.contentOffset.x >= MainScreenWidth && _cateScrollView.contentOffset.x <= 2 * MainScreenWidth) {
        _cateIndex = 1;
    } else if (_cateScrollView.contentOffset.x > 0) {
        _cateIndex = 0;
    } else if (_cateScrollView.contentOffset.x >= 2 * MainScreenWidth && _cateScrollView.contentOffset.x <= 3 * MainScreenWidth) {
        _cateIndex = 2;
    }
    
    _catePageControl.currentPage = _cateIndex;
    
    
}

#pragma mark --- 事件监听
- (void)cityButtonClick {

    //跳转 到切换城市的界面
    ChangeCityViewController *changeCityVc = [[ChangeCityViewController alloc] init];
    changeCityVc.cityTitle = _cityButton.titleLabel.text;
    [self.navigationController pushViewController:changeCityVc animated:YES];
 
}

- (void)homeSearchButtonCilck {
    
    HomeSearchViewController *homeSearchVc = [[HomeSearchViewController alloc] init];
    [self.navigationController pushViewController:homeSearchVc animated:NO];
    
}

- (void)messageButtonCilck {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        msgViewController *msg = [[msgViewController alloc]init];
        [self.navigationController pushViewController:msg animated:YES];
        
    } else {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
    }

}

#pragma mark --- 手势
- (void)imageClick:(UITapGestureRecognizer *)tap {

//    NSLog(@"%ld",tap.view.tag);
}


//分类 点击
- (void)cateButton:(UIButton *)button {

    NSDictionary *dict = _cateArray[button.tag];
    NSLog(@"----%@",dict);
    NSString *title = [dict stringValueForKey:@"title"];
    NSString *ID = [dict stringValueForKey:@"id"];
    SearchGetViewController *searchGetVc = [[SearchGetViewController alloc] init];
    searchGetVc.typeStr = @"1";
    searchGetVc.cateStr = title;
    searchGetVc.cate_ID = ID;
    [self.navigationController pushViewController:searchGetVc animated:YES];
}

- (void)moreButtonCilck:(UIButton *)button {

    switch (button.tag) {
        case 100:
            [self inLive];
            break;
        case 800:
            [self inHomeTeaMore];
            break;
        case 900:
            [self inHomeInStMore];
            break;
        default:
            break;
    }
    
}

- (void)forViewMoreButtonClick:(UIButton *)button {
    [self inGetSearchWithClass:button];
}


#pragma mark --- 更多相应事件
- (void)inLiveMore {
    LiveMoreViewController *liveMoreVc = [[LiveMoreViewController alloc] init];
    [self.navigationController pushViewController:liveMoreVc animated:YES];
}

- (void)inHomeMore {
    
    HomeMoreViewController *homeMVc = [[HomeMoreViewController alloc] init];
    [self.navigationController pushViewController:homeMVc animated:YES];
}

- (void)inHomeTeaMore {
    teacherViewController *teacherVc = [[teacherViewController alloc] init];
    [self.navigationController pushViewController:teacherVc animated:YES];
}
- (void)inHomeInStMore {
    HomeInstitutionViewController *homeInStVc = [[HomeInstitutionViewController alloc] init];
    [self.navigationController pushViewController:homeInStVc animated:YES];
}

#pragma mark --- 手势

#pragma mark --- 具体点击

- (void)liveButtonClick:(UIButton *)button {
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
    } else {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    
    NSLog(@"%ld",button.tag);
    NSInteger Tag = button.tag;
    
//    NSArray *sectonsArray = _liveArray[button.tag][@"sections"];
    NSArray *sectonsArray = [[_liveArray objectAtIndex:Tag] arrayValueForKey:@"sections"];
    NSString *Cid = nil;
    if (sectonsArray.count) {
        Cid = [NSString stringWithFormat:@"%@",[[sectonsArray objectAtIndex:0] stringValueForKey:@"live_id"]];
    } else {
//        [MBProgressHUD showError:@"直播为空" toView:self.view];
//        return;
    }

    NSLog(@"---%@",_liveArray[Tag]);
    NSString *Price = [[_liveArray objectAtIndex:Tag] stringValueForKey:@"price"];
    NSString *Title = [[_liveArray objectAtIndex:Tag] stringValueForKey:@"video_title"];
    NSString *ImageUrl = [[_liveArray objectAtIndex:Tag] stringValueForKey:@"imageurl"];
    
    ZhiBoMainViewController *zhiBoMainVc = [[ZhiBoMainViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)Tag andprice:Price];
    [self.navigationController pushViewController:zhiBoMainVc animated:YES];

}

//猜你喜欢 点击
- (void)mayLike_imageButtonClick:(UIButton *)button {
    NSInteger Tag = button.tag;
    
    NSString *Cid = [NSString stringWithFormat:@"%@",[[_likeArray objectAtIndex:Tag] stringValueForKey:@"id"]];
    NSString *Price = [[_likeArray objectAtIndex:Tag] stringValueForKey:@"price"];
    NSString *Title = [[_likeArray objectAtIndex:Tag] stringValueForKey:@"video_title"];
    NSString *VideoAddress = [[_likeArray objectAtIndex:Tag] stringValueForKey:@"video_address"];
    if ([VideoAddress isEqualToString:@""]) {//为空就返回
//        [MBProgressHUD showError:@"播放地址为空" toView:self.view];
//        return;
    }
    NSString *ImageUrl = [[_likeArray objectAtIndex:Tag] stringValueForKey:@"imageurl"];
    ZhiBoMainViewController *zhiBoMainVc = [[ZhiBoMainViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)Tag andprice:Price];
    [self.navigationController pushViewController:zhiBoMainVc animated:YES];
}

- (void)forViewimageButtonClick:(UIButton *)button {

    NSInteger Tag = button.tag;
    NSInteger oneNum = Tag / 10;
    NSInteger twoNum = Tag % 10;
    
    
//    NSLog(@"%@",_videoArray[oneNum][@"video_list"][twoNum]);
    
    if ([_videoArray[oneNum][@"video_list"][twoNum][@"type"] integerValue] == 1) {//点播
        
        NSString *Cid = [NSString stringWithFormat:@"%@",_videoArray[oneNum][@"video_list"][twoNum][@"id"]];
        NSString *Price = _videoArray[oneNum][@"video_list"][twoNum][@"price"];
        NSString *Title = _videoArray[oneNum][@"video_list"][twoNum][@"video_title"];
        NSString *VideoAddress = _videoArray[oneNum][@"video_list"][twoNum][@"video_address"];
        if ([VideoAddress isEqualToString:@""]) {//为空就返回
        }
        NSString *ImageUrl = _videoArray[oneNum][@"video_list"][twoNum][@"imageurl"];
        
        classDetailVC * classDetailVc = [[classDetailVC alloc]initWithMemberId:Cid andPrice:Price andTitle:Title];
        classDetailVc.videoTitle = Title;
        classDetailVc.img = ImageUrl;
        classDetailVc.video_address = VideoAddress;
        [self.navigationController pushViewController:classDetailVc animated:YES];
    } else {//直播
        NSString *Cid = nil;
        Cid = _videoArray[oneNum][@"video_list"][twoNum][@"id"];
        NSString *Price = _videoArray[oneNum][@"video_list"][twoNum][@"price"];
        NSString *Title = _videoArray[oneNum][@"video_list"][twoNum][@"video_title"];
        NSString *ImageUrl = _videoArray[oneNum][@"video_list"][twoNum][@"imageurl"];
        
        ZhiBoMainViewController *zhiBoMainVc = [[ZhiBoMainViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)Tag andprice:Price];
        [self.navigationController pushViewController:zhiBoMainVc animated:YES];
    }
    

    
}

- (void)inGetSearchWithClass:(UIButton *)button {
    
//    NSDictionary *dict = _videoArray[button.tag];
//    SearchGetViewController *getSearchVc = [[SearchGetViewController alloc] init];
//    getSearchVc.typeStr = @"1";
//    getSearchVc.cateStr = dict[@"title"];
//    getSearchVc.cate_ID = dict[@"zy_currency_category_id"];
//    [self.navigationController pushViewController:getSearchVc animated:YES];
    
    NSDictionary *dict = [_videoArray objectAtIndex:button.tag];
    OnlyClassSearchViewController *getSearchVc = [[OnlyClassSearchViewController alloc] init];
    getSearchVc.typeStr = @"1";
    getSearchVc.cateStr = [dict stringValueForKey:@"title"];
    getSearchVc.cate_ID = [dict stringValueForKey:@"zy_currency_category_id"];
    [self.navigationController pushViewController:getSearchVc animated:YES];
}

- (void)inLive {
//    LiveViewController *liveVc = [[LiveViewController alloc] init];
//    [self.navigationController pushViewController:liveVc animated:YES];
    
    AllLiveViewController *allLiveVc = [[AllLiveViewController alloc] init];
    [self.navigationController pushViewController:allLiveVc animated:YES];
}

- (void)inClass {
    classViewController *classVc = [[classViewController alloc] init];
    [self.navigationController pushViewController:classVc animated:YES];
}

- (void)inTeacher {
    teacherViewController *teacherVc = [[teacherViewController alloc] init];
    [self.navigationController pushViewController:teacherVc animated:YES];
}

//讲师
- (void)teacherButtonClick:(UIButton *)button {
    
    NSString *ID = [[_teacherArray objectAtIndex:button.tag] stringValueForKey:@"teacher_id"];
    TeacherMainViewController *teacherMainVc = [[TeacherMainViewController alloc] initWithNumID:ID];
    [self.navigationController pushViewController:teacherMainVc animated:YES];
}

//机构
- (void)institutionVc:(UIButton *)button {
    
    InstitutionMainViewController *institutionMainVc = [[InstitutionMainViewController alloc] init];
    institutionMainVc.schoolID = [[_schoolArray objectAtIndex:button.tag] stringValueForKey:@"school_id"];
    institutionMainVc.uID = [[_schoolArray objectAtIndex:button.tag] stringValueForKey:@"uid"];
    institutionMainVc.address = [[_schoolArray objectAtIndex:button.tag] stringValueForKey:@"location"];
    [self.navigationController pushViewController:institutionMainVc animated:YES];
}



#pragma mark --- 网络请求

//首页的数据
- (void)netWorkHomeIndex {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [manager BigWinCar_HomeIndex:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",operation);
//        [MBProgressHUD showSuccess:@"加载成功...." toView:self.view];
        _likeArray = responseObject[@"data"][@"like"];
        _liveArray = responseObject[@"data"][@"live"];
        _schoolArray = responseObject[@"data"][@"school"];
        _teacherArray = responseObject[@"data"][@"teacher"];
        _videoArray = responseObject[@"data"][@"video"];
        
        
        NSLog(@"%@",_liveArray);
        
        [self addLiveScrollView];
        [self addMayLiveView];
        
        [self addForView];
        
        [self addTeacherTitle];
        [self addTeacherScrollView];
        [self addEnterTitle];
        [self addEnterScrollView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"加载失败...." toView:self.view];
    }];
}


//首页分类的数据
- (void)netWorkHomeGetRecCateList {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:@"20" forKey:@"count"];
    [manager BigWinCar_HomeGetRecCateList:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        _cateArray = responseObject[@"data"];
        [self addCateScrollView];
        [self netWorkHomeIndex];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}


//首页广告图
- (void)netWorkHomeGetAdvert {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:@"app_home" forKey:@"place"];
    
//    [MBProgressHUD showSuccess:@"加载中...." toView:self.view];
    
    [manager BigWinCar_HomeGetAdvert:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1) {
            _imageDataArray = responseObject[@"data"];
        } else {
            return;
        }
        
        for (int i = 0; i < _imageDataArray.count; i ++) {
            NSString * imageName = [[_imageDataArray objectAtIndex:i] stringValueForKey:@"banner"];
            NSURL *url = [NSURL URLWithString:imageName];
        
            NSString *bannerurl = [[_imageDataArray objectAtIndex:i] stringValueForKey:@"bannerurl"];
            [_bannerurlArray addObject:bannerurl];
            if (_imageArray.count == _imageDataArray.count) {//已经可以了
                
            } else {
                [self.imageArray addObject:url];
            }
        }
        
        
        if (_imageArray.count == _imageDataArray.count) {
            [self addImageScrollView];
        }
        
        [self netWorkHomeGetRecCateList];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}





@end
