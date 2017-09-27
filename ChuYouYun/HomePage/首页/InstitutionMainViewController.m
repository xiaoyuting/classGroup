//
//  InstitutionMainViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/10/13.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "InstitutionMainViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Add.h"

#import "InstitutionHomeViewController.h"
#import "InstationClassViewController.h"
#import "InstationTeacherViewController.h"
#import "InstMainAllClassViewController.h"

#import "InstitionDiscountViewController.h"
#import "LiveViewController.h"
#import "classDetailVC.h"
#import "MessageSendViewController.h"
#import "DLViewController.h"
#import "LiveDetailsViewController.h"


@interface InstitutionMainViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSInteger currentIndex;
    CGFloat buttonW;
    CGFloat moreViewH;
    
    CGFloat basidFrame;
    CGFloat classFrame;
    CGFloat teacherFrame;
    
    NSString *offSet;
    
}
@property (strong ,nonatomic)UIView *infoView;
@property (strong ,nonatomic)UITableView *cityTableView;
@property (strong ,nonatomic)NSArray *cityDataArray;
//@property (strong ,nonatomic)UIButton *allButton;
@property (strong ,nonatomic)UIButton *seletedButton;
@property (strong ,nonatomic)UISegmentedControl *mainSegment;
@property (strong ,nonatomic)UIView *downView;
@property (strong ,nonatomic)UILabel *WZLabel;

@property (strong ,nonatomic)UIButton *attentionButton;

@property (strong ,nonatomic)NSString *homeScrollHight;
@property (strong ,nonatomic)NSString *classScrollHight;

@end

@implementation InstitutionMainViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    NSLog(@"全部课程");
    [self getTheClassOffSet];
    [self getTheTeacherOffSet];
    
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
    [self getTheClassFrame];
    [self getTheTeacherFrame];

    [self interFace];
    [self addNav];
    [self addAllScrollView];

    [self netWorkInstitutionInfo];

}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    currentIndex = 0;
    _imageArray = @[@"你好",@"我好",@"他好",@"你好",@"大家好"];
    _titleInfoArray = @[@"简介"];
    
    //通知
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHomeScrollHight:) name:@"IntHomeScrollHight" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getClassScrollHight:) name:@"InsClassScrollHight" object:nil];
    
    
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25, MainScreenWidth - 100, 30)];
    WZLabel.text = @"机构主页";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    _WZLabel = WZLabel;
    
    //添加横线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:button];
    
}


- (void)addAllScrollView {
    
    _allScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64,  MainScreenWidth, MainScreenHeight - 50 - 64)];
//    _allScrollView.pagingEnabled = YES;
    _allScrollView.delegate = self;
    _allScrollView.bounces = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _allScrollView.contentSize = CGSizeMake(0, 1000);
    [self.view addSubview:_allScrollView];
}

- (void)addInfoView {
    _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 200)];
    _infoView.backgroundColor = [UIColor redColor];
    [_allScrollView addSubview:_infoView];
    
    //背景图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_infoView.bounds];
    imageView.image = Image(@"organ_default_bg");
    [_infoView addSubview:imageView];
    _imageView = imageView;
    
    //机构头像
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 30, 30, 60, 60)];
    headerImageView.image = Image(@"你好");
    NSString *urlStr = [_schoolDic stringValueForKey:@"logo"];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
    [_infoView addSubview:headerImageView];
    
    //添加名字
    UILabel *Name = [[UILabel alloc] initWithFrame:CGRectMake(50, 100,MainScreenWidth - 100, 20)];
    Name.text = [_schoolDic stringValueForKey:@"title"];
    Name.textAlignment = NSTextAlignmentCenter;
    Name.textColor = [UIColor whiteColor];
    [_infoView addSubview:Name];
    
    //添加介绍
    _schoolInfo = [[UILabel alloc] initWithFrame:CGRectMake(50, 130, MainScreenWidth - 100, 20)];
    [self setIntroductionText:[_schoolDic stringValueForKey:@"type"]];
    _schoolInfo.textAlignment = NSTextAlignmentCenter;
    _schoolInfo.font = Font(13);
    [_infoView addSubview:_schoolInfo];
    
    
    //添加粉丝、浏览、评价的界面
    UIView *kinsOfView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_schoolInfo.frame), MainScreenWidth, 40)];
    kinsOfView.backgroundColor = [UIColor clearColor];
    [_infoView addSubview:kinsOfView];
    
    NSArray *buttonArray = @[@"浏览",@"评价",@"粉丝"];
    
    CGFloat labelW = MainScreenWidth / 3;
    CGFloat labelH = 20;
    CGFloat buttonW = MainScreenWidth / 3;
    CGFloat buttonH = 20;
    
    NSString *Str0 = [NSString stringWithFormat:@"%@",[[_schoolDic dictionaryValueForKey:@"count"] stringValueForKey:@"view_count"]];
    NSString *Str1 = [NSString stringWithFormat:@"%@",[[_schoolDic dictionaryValueForKey:@"count"] stringValueForKey:@"comment_score"]];
    NSString *Str2 = [NSString stringWithFormat:@"%@",[[_schoolDic dictionaryValueForKey:@"count"] stringValueForKey:@"follower_count"]];
    
    NSArray *titleArray = @[Str0,Str1,Str2];
    
    
    for (int i = 0 ; i < 3 ; i ++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * labelW, 0, labelW, labelH)];
        label.text = titleArray[i];
        label.font = Font(12);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [kinsOfView addSubview:label];

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * buttonW, 20, buttonW, buttonH)];
        [button setTitle:buttonArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = Font(12);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [kinsOfView addSubview:button];
    }
    
}

#pragma mark -- 事件监听
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addControllerSrcollView {
    
    _controllerSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segleMentView.frame) + 10,  MainScreenWidth, MainScreenHeight * 3 + 500)];
    _controllerSrcollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _controllerSrcollView.pagingEnabled = YES;
    _controllerSrcollView.scrollEnabled = YES;
    _controllerSrcollView.delegate = self;
    _controllerSrcollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * 3,0);
    [_allScrollView addSubview:_controllerSrcollView];

    InstitutionHomeViewController * instHomeVc= [[InstitutionHomeViewController alloc]init];
    instHomeVc.view.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
    [self addChildViewController:instHomeVc];
    instHomeVc.address = _address;
    [_controllerSrcollView addSubview:instHomeVc.view];
    
    InstationClassViewController * classVc = [[InstationClassViewController alloc]init];
    classVc.view.frame = CGRectMake(MainScreenWidth, -64, MainScreenWidth, MainScreenHeight * 2 + 500);
    [self addChildViewController:classVc];
    [_controllerSrcollView addSubview:classVc.view];
    
    InstationTeacherViewController * teacherVc = [[InstationTeacherViewController alloc]init];
    teacherVc.view.frame = CGRectMake(MainScreenWidth * 2, -64, MainScreenWidth, MainScreenHeight * 2 + 500);
    [self addChildViewController:teacherVc];
    [_controllerSrcollView addSubview:teacherVc.view];
    
    //添加通知(通知所传达的地方必须要已经实体化，不然就不会相应通知的方法)
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_schoolID forKey:@"school_id"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationInstitionSchoolID" object:nil userInfo:dict];
    
}

- (void)addClassView {

    _classScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_infoView.frame) + SpaceBaside,  MainScreenWidth, 210)];
    if (iPhone5o5Co5S) {
        _classScrollView.frame = CGRectMake(0, CGRectGetMaxY(_infoView.frame) + SpaceBaside,  MainScreenWidth, 180);
    }
    _classScrollView.backgroundColor = [UIColor whiteColor];
    _classScrollView.pagingEnabled = YES;
    _classScrollView.scrollEnabled = NO;
    _classScrollView.delegate = self;
    _classScrollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (_classArray.count % 3 == 0) {
        _classScrollView.contentSize = CGSizeMake(MainScreenWidth * (_classArray.count / 3) , 0);
    } else {
        _classScrollView.contentSize = CGSizeMake(MainScreenWidth * (_classArray.count / 3 + 1) , 0);
    }
    [_allScrollView addSubview:_classScrollView];
    
    //添加标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, CGRectGetMaxY(_infoView.frame) + 20, MainScreenWidth - SpaceBaside * 2, 20)];
    titleLabel.text = @"课程";
    [_allScrollView addSubview:titleLabel];
    
    //添加更多课程
    UIButton *moreClassButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, CGRectGetMaxY(_infoView.frame) + 20, 50, 20)];
    [moreClassButton setTitle:@"更多" forState:UIControlStateNormal];
    [moreClassButton setTitleColor:BasidColor forState:UIControlStateNormal];
    moreClassButton.titleLabel.font = Font(16);
    [_allScrollView addSubview:moreClassButton];
    [moreClassButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    moreClassButton.hidden = YES;
    
    //添加View
    for (int i = 0 ; i < _classArray.count ; i ++) {
        NSInteger Num = 3;
        CGFloat viewW = (MainScreenWidth - SpaceBaside * (Num + 1)) / Num;
        CGFloat viewH = viewW * 1.2;
        
        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(SpaceBaside + SpaceBaside * i + viewW * i + (i / Num) * SpaceBaside,40, viewW, viewH)];
        if (iPhone5o5Co5S) {
            buttonView.frame = CGRectMake(SpaceBaside + SpaceBaside * i + viewW * i + (i / Num) * SpaceBaside,40, viewW, 120);
        }
        buttonView.layer.cornerRadius = 5;
        buttonView.layer.masksToBounds = YES;
        buttonView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        buttonView.layer.borderWidth = 2;
        buttonView.backgroundColor = [UIColor whiteColor];
        [_classScrollView addSubview:buttonView];
        
        
        //在View 上面添加东西
        UIImageView *buttonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH / 2)];
        NSString *urlStr = [[_classArray objectAtIndex:i] stringValueForKey:@"imageurl"];
        [buttonImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
        [buttonView addSubview:buttonImageView];
        
        //添加介绍
        UILabel *nameButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside,viewW / 2 + SpaceBaside, viewW - 2 * SpaceBaside, 50)];
        nameButtonLabel.text = [[_classArray objectAtIndex:i] stringValueForKey:@"video_title"];
        nameButtonLabel.numberOfLines = 2;
        nameButtonLabel.font = Font(14);
        nameButtonLabel.textColor = BlackNotColor;
        [buttonView addSubview:nameButtonLabel];
        
        //添加价格
        UILabel *priceButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, viewW / 2 + 50, viewW - SpaceBaside * 2, 20)];
        if ([_classArray[i][@"price"] integerValue] == 0) {
            priceButtonLabel.text = @"免费";
            priceButtonLabel.textColor = [UIColor greenColor];
        } else {
            priceButtonLabel.text = [NSString stringWithFormat:@"￥%@",_classArray[i][@"price"]];
            priceButtonLabel.textColor = [UIColor redColor];
        }
        priceButtonLabel.font = Font(14);
        [buttonView addSubview:priceButtonLabel];
        
        
        //往View 上面添加button
        UIButton *viewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(buttonView.frame), CGRectGetHeight(buttonView.frame))];
        viewButton.backgroundColor = [UIColor clearColor];
        viewButton.tag = i;
        [viewButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:viewButton];
        
    }
    if (_classArray.count == 0) {
        _classScrollView.frame = CGRectMake(0,  CGRectGetMaxY(_infoView.frame) + SpaceBaside, MainScreenWidth, 40);
    }
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(MainScreenWidth / 2 - 40, CGRectGetMaxY(_classScrollView.frame) - 30, 80, 20)];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    self.pageControl.currentPage = currentIndex;
    self.pageControl.numberOfPages = 4;
    [self.allScrollView addSubview:self.pageControl];
    self.pageControl.hidden = YES;
}


- (void)addDiscountView  {
    _discountView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_classScrollView.frame) + 10, MainScreenWidth, 40)];
    _discountView.backgroundColor = [UIColor whiteColor];
    [_allScrollView addSubview:_discountView];
    
    //添加标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 0, MainScreenWidth - SpaceBaside * 2, 40)];
    titleLabel.text = @"优惠券";
    [_discountView addSubview:titleLabel];
    
    //添加更多课程
    UIButton *moreClassButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 40)];
//    [moreClassButton setImage:Image(@"考试右") forState:UIControlStateNormal];
    moreClassButton.backgroundColor = [UIColor clearColor];
    [moreClassButton setTitleColor:BasidColor forState:UIControlStateNormal];
    moreClassButton.titleLabel.font = Font(16);
    [_discountView addSubview:moreClassButton];
    [moreClassButton addTarget:self action:@selector(discountMoreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    

    
    
    
}


#pragma mark --- 滚动试图

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat ContentX = _classScrollView.contentOffset.x;
    
    if (ContentX < MainScreenWidth) {
        self.pageControl.currentPage = 0;
    } else if (ContentX < 2 * MainScreenWidth) {
        self.pageControl.currentPage = 1;
    } else if (ContentX < 3 * MainScreenWidth) {
        self.pageControl.currentPage = 2;
    } else if (ContentX < 4 * MainScreenWidth) {
        self.pageControl.currentPage = 3;
    }
    
    CGFloat contentCrorX = _controllerSrcollView.contentOffset.x;
    if (contentCrorX < MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 0;
        _allScrollView.contentSize = CGSizeMake(0 , [_homeScrollHight floatValue] + 250);
    } else if (contentCrorX < 2 * MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 1;
        _allScrollView.contentSize = CGSizeMake(0 , [_classScrollHight floatValue] + 350);
    } else if (contentCrorX < 3 * MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 2;
        _allScrollView.contentSize = CGSizeMake(0, MainScreenHeight);
    }
    
}


- (void)addWZView {
    UIView *WZView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_infoView.frame), MainScreenWidth, 50)];
    WZView.backgroundColor = [UIColor whiteColor];
    [_allScrollView addSubview:WZView];
    _segleMentView = WZView;
    
    
    NSArray *titleArray = @[@"首页",@"课程",@"讲师"];
    _mainSegment = [[UISegmentedControl alloc] initWithItems:titleArray];
    _mainSegment.frame = CGRectMake(2 * SpaceBaside,SpaceBaside,MainScreenWidth - 4 * SpaceBaside, 30);
    _mainSegment.selectedSegmentIndex = 0;
    [_mainSegment setTintColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1]];
    [_mainSegment addTarget:self action:@selector(mainChange:) forControlEvents:UIControlEventValueChanged];
    [WZView addSubview:_mainSegment];
  
    basidFrame = CGRectGetMaxY(_mainSegment.frame);
    
}

- (void)addDownView {
    
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 50   , MainScreenWidth, 50)];
    _downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downView];
    
    //添加线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_downView addSubview:lineButton];
    
    
    CGFloat ButtonW = MainScreenWidth / 3;
    buttonW = ButtonW;
    CGFloat ButtonH = 30;

    NSArray *title = @[@"联系客服",@"机构信息",@"添加关注"];
    NSArray *image = @[@"机构客服@2x",@"机构信息@2x",@"机构关注@2x"];
    if ([_schoolDic[@"follow_state"][@"following"] integerValue] == 0) {
        image = @[@"机构客服@2x",@"机构信息@2x",@"机构未关注@2x"];
        title = @[@"联系客服",@"机构信息",@"添加关注"];
    } else {
        image = @[@"机构客服@2x",@"机构信息@2x",@"机构关注@2x"];
        title = @[@"联系客服",@"机构信息",@"取消关注"];
    }
    
    for (int i = 0 ; i < 3 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * ButtonW, SpaceBaside, ButtonW, ButtonH)];
        [button setTitle:title[i] forState:UIControlStateNormal];
        [button setTitleColor:BlackNotColor forState:UIControlStateNormal];
        [button setImage:Image(image[i]) forState:UIControlStateNormal];
        button.titleLabel.font = Font(13);
        button.tag = i * 1000;
        [button addTarget:self action:@selector(downButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_downView addSubview:button];
        
        if (i == 2) {
            _attentionButton = button;
        }
        
    }
    
}

- (void)addInstationMore {
    [self addMoreView];
}

- (void)addMoreView {
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:_allView];
//    [self.view insertSubview:_allView belowSubview:_downView];

    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
    [_allView addSubview:_allButton];
    
    
    moreViewH = _titleInfoArray.count * 40 + 5 * (_titleInfoArray.count - 1);
    
    _buyView = [[UIView alloc] init];
    _buyView.frame = CGRectMake(buttonW, MainScreenHeight, buttonW, moreViewH);
    _buyView.backgroundColor = [UIColor colorWithRed:254.f / 255 green:255.f / 255 blue:255.f / 255 alpha:1];
    _buyView.layer.cornerRadius = 3;
    [_allView addSubview:_buyView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(buttonW, MainScreenHeight - 50 - moreViewH, buttonW, moreViewH);
        //在view上面添加东西
        for (int i = 0 ; i < _titleInfoArray.count ; i ++) {
            
            UIButton *button = [[UIButton alloc ] initWithFrame:CGRectMake(0, i * 40 + i * 5, 100, 40)];
            [button setTitle:_titleInfoArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:64.f / 255 green:64.f / 255 blue:64.f / 255 alpha:1] forState:UIControlStateNormal];
            button.layer.cornerRadius = 5;
//            button.tag = [_SYGArray[i][@"exam_category_id"] integerValue];
            [button addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [_buyView addSubview:button];
        }
        
        //添加中间的分割线
        for (int i = 0; i < _titleInfoArray.count; i ++) {
            UIButton *XButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 43 * i , buttonW, 1)];
            XButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [_buyView addSubview:XButton];
        }
    }];
}

- (void)miss {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(buttonW, MainScreenHeight, buttonW, moreViewH);
        _allView.alpha = 0;
        _allButton.alpha = 0;
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_buyView removeFromSuperview];
        
    });
}

- (void)SYGButton:(UIButton *)button {
    [self miss];
    
    //这里应该要设置偏移量
    _controllerSrcollView.contentOffset = CGPointMake(0, 0);
    
}


#pragma mark --- 事件监听

- (void)moreButtonClick:(UIButton *)button {
    NSLog(@"123");
    InstMainAllClassViewController *instMainAllClassVc = [[InstMainAllClassViewController alloc] init];
    [self.navigationController pushViewController:instMainAllClassVc animated:YES];
    instMainAllClassVc.schoolID = _schoolID;
    instMainAllClassVc.classArray = _classArray;
    
}

- (void)discountMoreButtonClick {
    
    InstitionDiscountViewController *discountVc = [[InstitionDiscountViewController alloc] init];
    discountVc.schoolID = _schoolID;
    [self.navigationController pushViewController:discountVc animated:YES];
    
}

- (void)mainChange:(UISegmentedControl *)sender {

    switch (sender.selectedSegmentIndex) {
        case 0:
             _controllerSrcollView.contentOffset = CGPointMake(0, 0);
            _allScrollView.contentSize = CGSizeMake(0 , [_homeScrollHight floatValue] + 250);
            break;
        case 1:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth, 0);
            //设置滚动的范围
            _allScrollView.contentSize = CGSizeMake(0 , [_classScrollHight floatValue] + 350);
            break;
        case 2:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 2, 0);
            //设置滚动的范围
            _allScrollView.contentSize = CGSizeMake(0, MainScreenHeight);
            break;
            
        default:
            break;
    }
    
}

//课程跳转
- (void)imageButtonClick:(UIButton *)button {
    
    NSInteger buttonTag = button.tag;
    
    NSString *type = [[_classArray objectAtIndex:buttonTag] stringValueForKey:@"type"];
    if ([type integerValue] == 1) {
        
        NSString *Cid = [[_classArray objectAtIndex:buttonTag] stringValueForKey:@"id"];
        NSString *Price = [[_classArray objectAtIndex:buttonTag] stringValueForKey:@"price"];
        NSString *Title = [[_classArray objectAtIndex:buttonTag] stringValueForKey:@"video_title"];
        NSString *VideoAddress = [[_classArray objectAtIndex:buttonTag] stringValueForKey:@"video_address"];
        NSString *ImageUrl = [[_classArray objectAtIndex:buttonTag] stringValueForKey:@"imageurl"];
        
        classDetailVC * classDetailVc = [[classDetailVC alloc]initWithMemberId:Cid andPrice:Price andTitle:Title];
        classDetailVc.videoTitle = Title;
        classDetailVc.img = ImageUrl;
        classDetailVc.video_address = VideoAddress;
        [self.navigationController pushViewController:classDetailVc animated:YES];
        
    } else if ([type integerValue] == 2) {
        
        NSString *address = [[_classArray objectAtIndex:buttonTag] stringValueForKey:@"video_address"];
        NSString *Cid = [NSString stringWithFormat:@"%@",[[_classArray objectAtIndex:buttonTag] stringValueForKey:@"id"]];
        if (address == nil) {
            [MBProgressHUD showError:@"直播为空" toView:self.view];
            return;
        }
        
        NSString *Price = [[_classArray objectAtIndex:buttonTag] stringValueForKey:@"price"];
        NSString *Title = [[_classArray objectAtIndex:buttonTag] stringValueForKey:@"video_title"];
        NSString *ImageUrl = [[_classArray objectAtIndex:buttonTag] stringValueForKey:@"imageurl"];
        
        LiveDetailsViewController *cvc = [[LiveDetailsViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)buttonTag andprice:Price];
        [self.navigationController pushViewController:cvc animated:YES];
    }
    

    
}

- (void)downButtonClick:(UIButton *)button {
    
    switch (button.tag) {
        case 0:
            [self addPhoneOrMessage];
            break;
        case 1000:
            [self addInstationMore];
            break;
        case 2000:
            [self userIsAttention:button];
            break;
        default:
            break;
    }
    
}

//添加私信或者电话
- (void)addPhoneOrMessage {
    
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"私信" otherButtonTitles:@"呼叫", nil];
    action.delegate = self;
    [action showInView:self.view];

}

- (void)userIsAttention:(UIButton *)button {
    NSString *title = button.titleLabel.text;
    if ([title isEqualToString:@"取消关注"]) {
        [self NetWorkACancelAttention];
    } else if ([title isEqualToString:@"添加关注"]) {
        [self NetWorkAttention];
    }
}


#pragma mark --- UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){//私信
        [self sendMessage];

    }else if (buttonIndex == 1){//呼叫
        [self CallPhone];
    }
}

-(void)CallPhone{

    NSString *phoneStr = [_schoolDic stringValueForKey:@"phone"];
    NSLog(@"----%@",phoneStr);
    if (phoneStr == nil || [phoneStr isEqualToString:@""]) {
        [MBProgressHUD showError:@"电话号码为空，不能拨打" toView:self.view];
        return;
    }
    NSMutableString *phoneString = [[NSMutableString alloc] initWithFormat:@"tel:%@",phoneStr];
    UIWebView *callWebView = [[UIWebView alloc] init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneString]]];
    [self.view addSubview:callWebView];
    
}

- (void)sendMessage {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    
    MessageSendViewController *MSVC = [[MessageSendViewController alloc] init];
    MSVC.TID = _uID;
    MSVC.name = [_schoolDic stringValueForKey:@"title"];
    [self.navigationController pushViewController:MSVC animated:YES];

}

#pragma mark --- 文本自适应

-(void)setIntroductionText:(NSString*)text{
    //文本赋值
    _schoolInfo.text = text;
    //设置label的最大行数
    _schoolInfo.numberOfLines = 0;
    
    CGRect labelSize = [_schoolInfo.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
    
    _schoolInfo.frame = CGRectMake(50,130,MainScreenWidth - 100,labelSize.size.height);
    _infoView.frame = CGRectMake(0, 0, MainScreenWidth, 170 + labelSize.size.height );
    
    //重新添加背景 不然会变形
    _imageView.frame = CGRectStandardize(_infoView.frame);
}

#pragma mark --- 通知

- (void)getTheClassFrame {
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(getTheClassFrame:) name:@"NSNotificationInstClassScrollFrame" object:nil];
    
}

- (void)getTheClassFrame:(NSNotification *)Not {
    NSLog(@"%@",Not.userInfo);
    classFrame = [Not.userInfo[@"frame"] floatValue];
    
}

- (void)getTheTeacherFrame {
    
    
}

- (void)getTheClassOffSet {
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(getTheClassOffSet:) name:@"NSNotificationInsClassOffSet" object:nil];
    
    if (offSet) {
        _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * [offSet integerValue], 0);
        offSet = nil;
    }
}

- (void)getTheClassOffSet:(NSNotification *)Not {
    offSet = Not.userInfo[@"offSet"];
}

- (void)getTheTeacherOffSet {
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(getTheTeacherOffSet:) name:@"NSNotificationInsTeacherOffSet" object:nil];
    
    if (offSet) {
        _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * [offSet integerValue], 0);
        offSet = nil;
    }
}

- (void)getTheTeacherOffSet:(NSNotification *)Not {
    offSet = Not.userInfo[@"offSet"];
}

- (void)getHomeScrollHight:(NSNotification *)not {
    _homeScrollHight = (NSString *)not.object;
    _allScrollView.contentSize = CGSizeMake(0 , [_homeScrollHight floatValue] + 250);
}

- (void)getClassScrollHight:(NSNotification *)not {
    _classScrollHight = (NSString *)not.object;
    _allScrollView.contentSize = CGSizeMake(0 , [_classScrollHight floatValue] + 350);
}

#pragma mark --- 网络请求
//获取机构详情
- (void)netWorkInstitutionInfo {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    [dic setObject:_schoolID forKey:@"school_id"];
    
    [manager BigWinCar_GetSchoolInfo:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"11----%@",responseObject);
        
        if (![responseObject[@"msg"] isEqualToString:@"ok"]) {
            return;
        }
        _schoolDic = responseObject[@"data"];
        _WZLabel.text = _schoolDic[@"title"];
        _classArray = responseObject[@"data"][@"recommend_list"];
        [self addInfoView];
//        [self addClassView];
//        [self addDiscountView];
        [self addWZView];
        [self addDownView];
        [self addControllerSrcollView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


//关注机构
-(void)NetWorkAttention
{
    //先判断自己的uid
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
        _myUID = [[NSUserDefaults standardUserDefaults] objectForKey:@"User_id"];
        
    } else {
        [MBProgressHUD showError:@"请先登陆" toView:self.view];
    }

    if (_uID == nil) {
        [MBProgressHUD showError:@"不能关注自己的机构" toView:self.view];
        return;
    } else {
        if ([_myUID integerValue] == [_uID integerValue]) {
            [MBProgressHUD showError:@"不能关注自己的机构" toView:self.view];
            return;
        } else {
            [dic setObject:_uID forKey:@"user_id"];
        }
    }
    [manager BigWinCar_GetFollow_create:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"data"][@"following"] integerValue] == 1) {
            [MBProgressHUD showSuccess:@"关注成功" toView:self.view];
            [_attentionButton setTitle:@"取消关注" forState:UIControlStateNormal];
            [_attentionButton setImage:Image(@"机构未关注@2x") forState:UIControlStateNormal];
            return;
        }
         [MBProgressHUD showSuccess:@"关注失败" toView:self.view];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showSuccess:@"关注失败" toView:self.view];
    }];
    
}

//取消关注机构
-(void)NetWorkACancelAttention
{
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    } else {
        [MBProgressHUD showError:@"请先登陆" toView:self.view];
    }

    if (_uID == nil) {
        [MBProgressHUD showError:@"不能取消关注自己的机构" toView:self.view];
        return;
    } else {
        [dic setObject:_uID forKey:@"user_id"];
    }
    [manager BigWinCar_GetFollow_destroy:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"99%@",responseObject);
        if ([responseObject[@"data"][@"following"] integerValue] == 0) {
            [MBProgressHUD showSuccess:@"取消关注成功" toView:self.view];
            [_attentionButton setTitle:@"添加关注" forState:UIControlStateNormal];
            [_attentionButton setImage:Image(@"机构关注@2x") forState:UIControlStateNormal];
            return;
        }
        [MBProgressHUD showSuccess:@"取消关注失败" toView:self.view];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MBProgressHUD showSuccess:@"取消关注失败" toView:self.view];
    }];
}







@end
