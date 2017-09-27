//
//  classViewController.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/21.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "classViewController.h"
#import "Helper.h"
#import "allClassVC.h"
#import "commentClassVC.h"
#import "salesClassVC.h"
#import "tolerateClassVC.h"
#import "PopoverView.h"
#import "MyHttpRequest.h"
#import "teacherList.h"
#import "classClassifyVc.h"
#import "AppDelegate.h"
#import "searchCourseVC.h"
#import "blumViewController.h"

#import "LiveViewController.h"




#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

@interface classViewController ()<UIScrollViewDelegate>
{
    UIScrollView * _scrollView;
    NSInteger selectIndex;
    UITableView * _tableView;
    NSInteger page;
    UIView *_view;
}
@property(nonatomic,assign)id currentClassVC;

@property (strong ,nonatomic)UIView *allView;

@property (strong ,nonatomic)UIButton *allButton;

@property (strong ,nonatomic)UIView *XZView;

@property (strong ,nonatomic)NSString *SYGString;

@property (strong ,nonatomic)UISegmentedControl *segmented;


@end

@implementation classViewController
@synthesize svc;
@synthesize tvc;
@synthesize cvc;
@synthesize avc;
- (id)initWithMemberId:(NSString *)MemberId
{
    if (self=[super init]) {
//        _cateory = [[NSUserDefaults standardUserDefaults]objectForKey:@"User_id"];
        _cateory = MemberId;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
     self.navigationController.navigationBar.hidden = YES;
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];

}

- (void)viewWillDisappear:(BOOL)animated {
    
     self.navigationController.navigationBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = YES;
       //创建view
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64 + 40)];
    
    
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    //添加分类按钮
    UIButton *FLButton = [UIButton buttonWithType:UIButtonTypeSystem];
    FLButton.frame = CGRectMake(5, 20, 40, 40);
    [FLButton setBackgroundImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [FLButton addTarget:self action:@selector(calssifyClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:FLButton];
    
    //添加搜索功能
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 40, 30, 35, 25)];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"Search"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:searchButton];
    
    //添加
    
    NSArray *titleArray = @[@"课程",@"直播"];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:titleArray];
    segment.frame = CGRectMake(MainScreenWidth / 2 - 60, 25, 120 , 30);
    segment.selectedSegmentIndex = 0;
    [segment setTintColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1]];
    [segment addTarget:self action:@selector(typeChange:) forControlEvents:UIControlEventValueChanged];
    [navView addSubview:segment];
    _segmented = segment;

    
    //添加一天分割线
    
    //添加分割线
    UILabel *FGLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 63.5, MainScreenWidth, 0.5)];
    FGLabel.backgroundColor = [UIColor colorWithRed:143.f / 255 green:143.f / 255 blue:143.f / 255 alpha:0.5];
    [navView addSubview:FGLabel];
    
    
    //网络监听的弹窗

    for(int i =0;i<4;i++)
    {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        float space = (self.view.frame.size.width-35*5)/5;
         btn.frame = CGRectMake(space+(space+48)*i, (44-36)/2 + 64, 30, 36);
        btn.tag = 10080+i;
        btn.selected = NO;
        if (i==0) {
            [btn setTitle:@"默认" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
        }
        else if(i==1)
        {
            [btn setTitle:@"销量" forState:UIControlStateNormal];
        }
        else if(i==2)
        {
            [btn setTitle:@"评论" forState:UIControlStateNormal];
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(space+(space+48)*i+31,15 + 64, 3, 13);
            button.tag = 1;
            [navView addSubview:button];
        }
        else if(i==3)
        {
            [btn setTitle:@"全部" forState:UIControlStateNormal];
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(space+(space+48)*i+31, 17 + 64, 18,10);
            [button setImage:[UIImage imageNamed:@"all02"] forState:UIControlStateNormal];
            button.tag=2;
            

            [navView addSubview:button];

            
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        

            [navView addSubview:btn];
        
    }
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104,  MainScreenWidth, self.view.bounds.size.height)];

    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView.contentSize = CGSizeMake(MainScreenWidth*4, 0);
 
    tvc = [[tolerateClassVC alloc]initWithId:_cateory];
    tvc.view.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [self addChildViewController:tvc];
    [_scrollView addSubview:tvc.view];
    
    svc = [[salesClassVC alloc]initWithNumberId:_cateory];
    svc.view.frame = CGRectMake(MainScreenWidth, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [self addChildViewController:svc];
    [_scrollView addSubview:svc.view];
    
   cvc = [[commentClassVC alloc]initWithNumberIds:_cateory];
    cvc.view.frame = CGRectMake(MainScreenWidth*2, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [self addChildViewController:cvc];
    [_scrollView addSubview:cvc.view];
    
    avc = [[allClassVC alloc]initWithMemberIds:_cateory];
    avc.view.frame = CGRectMake(MainScreenWidth*3, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [self addChildViewController:avc];
    [_scrollView addSubview:avc.view];
    self.currentClassVC = avc;
    
    [self.view addSubview:_scrollView];
    selectIndex = 0;
   // [self reachabiltyGo];
    
    
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SYG:) name:@"notificationSYG" object:nil];

}


- (void)SYG:(NSNotification *)SYGNot {
    
    NSLog(@"%@",SYGNot.userInfo);
    _SYGString = (NSString *)SYGNot.userInfo;
    if ([_SYGString isEqualToString:@"2"]) {//说明应该是从直播过来的
        
        _segmented.selectedSegmentIndex = 0;
    }
}


- (void)typeChange:(UISegmentedControl *)sender {
    
    UISegmentedControl* control = (UISegmentedControl*)sender;
    if (control.selectedSegmentIndex == 0) {//专辑
        NSLog(@"专辑");

        if ([_formStr isEqualToString:@"123"]) {//从课程分类过来的
            blumViewController *blumVC = [[blumViewController alloc] init];
            [self.navigationController pushViewController: blumVC animated:NO];
        } else {
            [self.navigationController popViewControllerAnimated:NO];
        }
        //写通知

//        NSString *SYGString = @"2";
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationSYG" object:nil userInfo:SYGString];

    }else {//直播
        NSLog(@"直播");
        LiveViewController *liveVc = [[LiveViewController alloc] init];
        [self.navigationController pushViewController:liveVc animated:NO];
  
    }
    
}

-(void)cancelSearch
{
    searchCourseVC * svc = [[searchCourseVC alloc]init];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)calssifyClick
{
//    classClassifyVc * vc = [[classClassifyVc alloc]init];
//    [ntvc isHiddenCustomTabBarByBoolean:YES];
//    [self.navigationController pushViewController:vc animated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)btnClick:(id)sender
{

    UIButton * btn = (UIButton *)sender;
    switch (btn.tag) {
        case 10080:
        {
            self.currentClassVC = tvc;
            _scrollView.contentOffset = CGPointMake(0, 0);
            UIButton *btn =(UIButton *)[self.view viewWithTag:10080];
            [btn setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
            UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
            [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton *btn3 =(UIButton *)[self.view viewWithTag:10083];
            [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            UIButton * button = (UIButton *)[self.view viewWithTag:1];
            [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            
            UIButton * button1 = (UIButton *)[self.view viewWithTag:2];
            [button1 setImage:[UIImage imageNamed:@"all02"] forState:UIControlStateNormal];
            
        }
            break;
            case 10081:
        {
            self.currentClassVC = svc;
            _scrollView.contentOffset = CGPointMake(MainScreenWidth, 0);
            UIButton *btn =(UIButton *)[self.view viewWithTag:10080];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
            [btn1 setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
            UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
            [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton *btn3 =(UIButton *)[self.view viewWithTag:10083];
            [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton * button = (UIButton *)[self.view viewWithTag:1];
            [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            UIButton * button1 = (UIButton *)[self.view viewWithTag:2];
            [button1 setImage:[UIImage imageNamed:@"all02"] forState:UIControlStateNormal];
        }
            break;
            case 10082:
        {
            self.currentClassVC = cvc;
            _scrollView.contentOffset = CGPointMake(MainScreenWidth*2, 0);
            
            UIButton *btn =(UIButton *)[self.view viewWithTag:10080];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
            [btn2 setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1] forState:UIControlStateNormal];
            UIButton * button = (UIButton *)[self.view viewWithTag:1];
            [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            UIButton *btn3 =(UIButton *)[self.view viewWithTag:10083];
            [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            UIButton * button1 = (UIButton *)[self.view viewWithTag:2];
            [button1 setImage:[UIImage imageNamed:@"all02"] forState:UIControlStateNormal];
        }
            break;
            case 10083:
        {
            self.currentClassVC = avc;
            _scrollView.contentOffset = CGPointMake(MainScreenWidth*3, 0);
            UIButton *btn =(UIButton *)[self.view viewWithTag:10080];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton *btn1 =(UIButton *)[self.view viewWithTag:10081];
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton *btn2 =(UIButton *)[self.view viewWithTag:10082];
            [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton *btn3 =(UIButton *)[self.view viewWithTag:10083];
            [btn3 setTitleColor:[UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1]forState:UIControlStateNormal];
            UIButton * button = (UIButton *)[self.view viewWithTag:1];
            [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            UIButton * button1 = (UIButton *)[self.view viewWithTag:2];
            [button1 setImage:[UIImage imageNamed:@"all01"] forState:UIControlStateNormal];
            
#pragma mark --- 设置全部的动画的位置
//            CGPoint point = CGPointMake(btn3.frame.origin.x + btn3.frame.size.width/2, btn3.frame.origin.y + btn3.frame.size.height - 4 );
//
//            NSArray *imageArray = @[@"站位图",@"站位图",@"站位图"];
//            
//            NSArray * title = @[@"全部",@"免费",@"收费"];
//            PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:title images:nil];
//            pop.selectRowAtIndex = ^(NSInteger index)
//            {
//                if (index==0) {
//                    UIButton * button1 = (UIButton *)[self.view viewWithTag:10083];
//                    [button1 setTitle:@"全部" forState:UIControlStateNormal];
//                }
//                else if(index==1)
//                {
//                    UIButton * button1 = (UIButton *)[self.view viewWithTag:10083];
//                    [button1 setTitle:@"免费" forState:UIControlStateNormal];
//                }
//                else if (index==2)
//                {
//                    UIButton * button1 = (UIButton *)[self.view viewWithTag:10083];
//                    [button1 setTitle:@"收费" forState:UIControlStateNormal];
//                }
//                if (selectIndex!=index)
//                {
//                    selectIndex = index;
//                }
//                
////                [self refreshCurrentVC];
//                };
//                [pop show];
            
            _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
            _allView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
            [self.view addSubview:_allView];
            
            _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
            _allButton.backgroundColor = [UIColor clearColor];
            [_allButton addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
            [_allView addSubview:_allButton];
            
            //创建个VIew
            _XZView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth, 105, 80, 126)];
            _XZView.backgroundColor = [UIColor colorWithRed:254.f / 255 green:255.f / 255 blue:255.f / 255 alpha:1];
            _XZView.layer.cornerRadius = 3;
            [_allView addSubview:_XZView];
            
            [UIView animateWithDuration:0.25 animations:^{
                
                //改变位置 动画
                _XZView.frame = CGRectMake(MainScreenWidth - 80 ,105 ,80, 126);
                
                //在view上面添加东西
                NSArray *GDArray = @[@"全部",@"免费",@"收费"];
                for (int i = 0 ; i < 3 ; i ++) {
                    UIButton *button = [[UIButton alloc ] initWithFrame:CGRectMake(0, i * 40 + i * 2, 80, 40)];
                    [button setTitle:GDArray[i] forState:UIControlStateNormal];
//                    button.backgroundColor = [UIColor redColor];
                    button.layer.cornerRadius = 5;
                    button.tag =  i;
                    [button setTitleColor:[UIColor colorWithRed:64.f / 255 green:64.f / 255 blue:64.f / 255 alpha:1] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(SYGButtons:) forControlEvents:UIControlEventTouchUpInside];
                    button.titleLabel.font = [UIFont systemFontOfSize:14];
                    [_XZView addSubview:button];
                    
                }
                
                for (int i = 1; i < 3; i ++) {
                    UIButton *XButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 42 * i , 100, 1)];
                    XButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
                    [_XZView addSubview:XButton];
                }
            }];

        }
            break;
        default:
            break;
    }
     [self refreshCurrentVC];
}

- (void)miss {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _XZView.frame = CGRectMake(MainScreenWidth, 105, 80, 126);
        _allView.alpha = 0;
        _allButton.alpha = 0;
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allButton removeFromSuperview];
        [_allView removeFromSuperview];
        [_XZView removeFromSuperview];
        
    });
}


- (void)SYGButtons:(UIButton *)button {

    [self miss];
    
    if (button.tag == 0) {
            UIButton * button1 = (UIButton *)[self.view viewWithTag:10083];
            [button1 setTitle:@"全部" forState:UIControlStateNormal];
        }
        else if(button.tag == 1)
        {
            UIButton * button1 = (UIButton *)[self.view viewWithTag:10083];
            [button1 setTitle:@"免费" forState:UIControlStateNormal];
        }
        else if (button.tag == 2)
        {
            UIButton * button1 = (UIButton *)[self.view viewWithTag:10083];
            [button1 setTitle:@"收费" forState:UIControlStateNormal];
        }

    selectIndex = button.tag;
    [self refreshCurrentVC];
    
    
}

- (void)refreshCurrentVC
{
    if ([[self.currentClassVC num] integerValue]!=selectIndex) {
        [self.currentClassVC setNum:[NSString stringWithFormat:@"%ld",(long)selectIndex]];
        [self.currentClassVC performSelector:@selector(refreshHeader) withObject:nil];
    }
}

-(void)requestData
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [dic setValue:@"6" forKey:@"count"];
    [dic setValue:tvc.num forKey:@"pType"];
    [dic setValue:svc.num forKey:@"pType"];
    [dic setValue:cvc.num forKey:@"pType"];
    [dic setValue:avc.num forKey:@"pType"];
    
    [dic setValue:_cateory forKey:@"cateId"];
    [manager getClass:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray * array = [responseObject objectForKey:@"data"];
        if([array isEqual:[NSNull null]])
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"没有更多视频了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
                      
        }
        else{
            NSMutableArray * listArr = [[NSMutableArray alloc]initWithCapacity:0];
            for (int i=0; i<array.count; i++) {
                teacherList * list = [[teacherList alloc]initWithDictionarys:array[i]];
                [listArr addObject:list];
            }
            if(page==1)
            {
                _dataArray = [NSMutableArray arrayWithArray:listArr];
                page++;
            }
            else
            {
                
                NSArray * arr = [NSArray arrayWithArray:listArr];
                [_dataArray addObjectsFromArray:arr];
            }
            
            [_tableView reloadData];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
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


//创建导航条上的按钮
-(void)addItem:(NSString *)title position:(item)position image:(NSString *)image action:(SEL)action
{
    UIButton * button = [self button:title image:image frame:CGRectMake(0, 0, 52, 18)];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:button];
    if (position==Left_Item) {
        self.navigationItem.leftBarButtonItem = item;
    }else{
        self.navigationItem.rightBarButtonItem = item;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
