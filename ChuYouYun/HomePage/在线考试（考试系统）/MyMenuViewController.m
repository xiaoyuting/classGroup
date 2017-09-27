//
//  MyMenuViewController.m
//  ChuYouYun
//
//  Created by 赛新科技 on 2017/4/6.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "MyMenuViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "PhotosView.h"
#import "MBProgressHUD+Add.h"
#import "SYG.h"
#import "Passport.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import "ZhiyiHTTPRequest.h"

#import "XZTTableViewCell.h"



@interface MyMenuViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    
    BOOL flag;
    BOOL isPlaying;
    UIImage  *image;
    AVPlayer *player;
}

@property (strong ,nonatomic)UIButton *XXButton;//箭头的按钮

@property (strong ,nonatomic)UIView *allView;

@property (strong ,nonatomic)UIButton *allButton;

@property (strong ,nonatomic)UIView *buyView;

@property (strong ,nonatomic)NSArray *SYGArray;//存放分类的数组

@property (strong ,nonatomic)NSMutableArray *titleNameArray;//存放分类名字的数组

@property (strong ,nonatomic)NSMutableArray *titleIdArray;//分类的id 数组

@property (strong, nonatomic) NSTimer *timer;
@property (strong ,nonatomic)NSString *playUrl;//音频播放

@property (strong ,nonatomic)UILabel *TimeLabel;//显示时间的文本

@property (assign ,nonatomic)NSInteger timePastting;//记录流逝的时间

@property (strong ,nonatomic)UILabel *titleLabel;//题目的文本

@property (strong ,nonatomic)NSString *TString;//题目的文字

@property (strong ,nonatomic)UILabel *WZLabel;//题目类型的文本

@property (strong ,nonatomic)UITableView *tableView;//表格试图

@property (strong ,nonatomic)UIView *headView;//表格头部视图

@property (assign ,nonatomic)CGFloat headH;//头部视图返回的高度

@property (strong ,nonatomic)UIView *footView;//表格底部试图

@property (assign ,nonatomic)CGFloat footH;//底部视图返回的高度

@property (strong ,nonatomic)UILabel *footTitle;//底部试图显示文本

@property (strong ,nonatomic)NSMutableArray *XZArray;//选择中的数组

@property (strong ,nonatomic)NSMutableArray *AnswerArray;//存放答案的数组

@property (strong ,nonatomic)NSMutableArray *DXAnswerArray;//存放单选答案的数组

@property (strong ,nonatomic)NSMutableArray *DDXAnswerArray;//存放多选答案的数组

@property (strong ,nonatomic)NSMutableArray *TKAnswerArray;//存放填空答案的数组

@property (strong ,nonatomic)NSMutableArray *PDAnswerArray;//存放判断答案的数组

@property (strong ,nonatomic)NSMutableArray *ZGAnswerArray;//存放主观答案的数组

@property (assign ,nonatomic)BOOL isYes;//这个状态判断多选数组里面是否全为0 （这个是传答案到数组里面的时候）//监听多选题是否为没有答案

@property (strong ,nonatomic)NSArray *dataSourceArray;//数据来源

@property (strong ,nonatomic)UIView *downView;//底部时间试图

@property (strong ,nonatomic)UIView *DDXView;//多选试图

@property (strong ,nonatomic)NSString *typeStr;//这个是当前试卷的类型 （单选 ，多选）等

@property (strong ,nonatomic)UIView *DXView;//单选试图

@property (strong ,nonatomic)UIView *XZView;//选择题的试图

@property (strong ,nonatomic)UIView *DXTopView;//多选的顶部试图

@property (strong ,nonatomic)UIScrollView *TKView;//这个是填空的试图
@property (strong ,nonatomic)NSMutableArray *textFieldNumArray;//填空题每道题的输入框的个数

@property (strong ,nonatomic)UIView *TKTopView;//填空的顶部试图

@property (strong ,nonatomic)UILabel *TKTitleLabel;//填空试图上面的题目
@property (strong ,nonatomic)UIView *TKPhotoView;//填空题的图片
@property (strong ,nonatomic)UIImageView *TKImageView;//填空题的图片视图


@property (strong ,nonatomic)UITextField *TKTextField;//填空题的输入框
@property (strong ,nonatomic)UIView *TKtextFieldView;

@property (strong ,nonatomic)UIButton *TJButton;//填空题的提交按钮

@property (strong ,nonatomic)UIButton *TKFalseButton;//填空题的错误正确按钮

@property (strong ,nonatomic)UIView *TKJXView;//填空题的解析界面

@property (strong ,nonatomic)UILabel *CKDALabel;//参考答案文本

@property (strong ,nonatomic)UILabel *TKJXLabel;//填空题的解析文本

@property (strong ,nonatomic)UIScrollView *ZGView;//主观视图

@property (strong ,nonatomic)UIView *ZGTopView;//主观的顶部试图

@property (strong ,nonatomic)UILabel *ZGTitleLabel;//主观题的题目

@property (strong ,nonatomic)UITextView *textView;//主观视图的输入文本

@property (strong ,nonatomic)UILabel *ZGTXLabel;//主观提醒文本

@property (strong ,nonatomic)UIView *ZGXSView;//主观题的试图

@property (strong ,nonatomic)UIScrollView *ZGScrollView;//主观题的滚动试图

@property (strong ,nonatomic)PhotosView *photosView;//主观题 添加图片的View
@property (strong ,nonatomic)UIImageView *contentImageView;//题干里面的图片
@property (strong ,nonatomic)UIImageView *ZGImageView;
//@property (strong ,nonatomic)NSMutableArray *imagePhotoArray;//存放图片的数组

@property (strong ,nonatomic)UIButton *TJImageButton;//主观题 界面上添加按钮的图片

@property (strong ,nonatomic)UIView *ZGJXView;
@property (strong ,nonatomic)UILabel *ZGJXLabel;//主观题的解析界面

@property (strong ,nonatomic)NSMutableArray *imageIDArray;//存放图片id的数组

@property (strong ,nonatomic)NSArray *imageArray;//存放图片的数组

@property (strong ,nonatomic)NSString *formStr;//从答题卡界面传过来的哪种类型的题 从而显示其界面

@property (assign ,nonatomic)NSInteger formNumber;//从答题卡界面传过来是第几题

@property (strong ,nonatomic)NSArray *singleArray;//单选题数据

@property (strong ,nonatomic)NSArray *multipleArray;//多选题数据

@property (strong ,nonatomic)NSArray *gapArray;//填空题数据

@property (strong ,nonatomic)NSArray *judgeArray;//判断题的数据

@property (strong ,nonatomic)NSArray *SubjectiveArray;//主观题的数据

@property (strong ,nonatomic)NSMutableArray *SubjectiveImageArray;//主观题的图片的数组

@property (strong ,nonatomic)NSArray *allArray;//全部数据的数组

@property (assign ,nonatomic)NSInteger Number;//记录是第几题

@property (strong ,nonatomic)NSString *isGoOutEduline;//监听是否是退出程序


#pragma mark ---  数据储存 (各种题型 题干的图片)
@property (strong ,nonatomic)NSMutableArray *tableViewImageArray;//单选 多选 判断 题干的图片
@property (strong ,nonatomic)NSMutableArray *TKImageArray;
@property (strong ,nonatomic)NSMutableArray *ZGImageArray;
@property (assign ,nonatomic)NSInteger       TKImageNum;//记录填空题题干图片的数量
@property (assign ,nonatomic)CGFloat         TKTextSecitonH;
@property (assign ,nonatomic)CGFloat         TKImageViewH;
@property (assign ,nonatomic)NSInteger       SecitionNum;//每行图片的个数
@property (strong ,nonatomic)NSString       *TKAllTextFile;
@property (strong ,nonatomic)NSMutableArray *ZGUpImageArray;//主观题上传的图片的数组
@property (strong ,nonatomic)NSMutableArray *ZGUpImageIDArray;


@property (assign ,nonatomic)NSInteger       ZGImageNum;//主观题 题干里面的图片
@property (assign ,nonatomic)CGFloat         ZGImageViewH;

@property (strong ,nonatomic)NSString       *TKLastTextFile;//填空题最后题的答案
@property (strong ,nonatomic)NSString       *ZGTextStr;//主观题的输入框的文字
@property (strong ,nonatomic)NSMutableArray *imageUrlArray;
@property (strong ,nonatomic)NSString *imageUrl;

#pragma mark --- 答题卡回来
@property (assign ,nonatomic)NSInteger DTKNumber;
@property (strong ,nonatomic)NSString *isTKStr;


#pragma mark --- 答案的数据源

@property (strong ,nonatomic)NSMutableArray *DXRightAnswer;//单选的标准答案

@property (strong ,nonatomic)NSMutableArray *DDXRightAnswer;//多远的标准答案

@property (strong ,nonatomic)NSMutableArray *TKRightAnswer;//填空的标准答案

@property (strong ,nonatomic)NSMutableArray *PDRightAnswer;//判断的标准答案

@property (strong ,nonatomic)NSMutableArray *userDXAnswer;

@property (strong ,nonatomic)NSMutableArray *userDDXAnswer;

@property (strong ,nonatomic)NSMutableArray *userTKAnswer;

@property (strong ,nonatomic)NSMutableArray *userPDAnswer;

@property (strong ,nonatomic)NSMutableArray *userZGAnswer;

@property (strong ,nonatomic)NSMutableArray *userImageArray;


@end

@implementation MyMenuViewController


-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}


-(void)viewWillDisappear:(BOOL)animated {
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self getRigthAnswer];
    [self addNav];
    [self getFlag];//赋值
    [self addDownView];
    //    [self addXZView];
    
    [self addTableView];
    [self addTKView];
    [self addZGView];

    [self getFlag];//赋值
    [self firstView];
    
}


- (void)interFace {
    
    NSLog(@"%ld",(long)_allTime);
    NSLog(@"dataSource-------%@",_dataSource);
    NSLog(@"%@",_myDXAnswerArray);
    
    self.view.backgroundColor = [UIColor whiteColor];
    flag = YES;
    isPlaying = NO;
    _typeStr = @"1";//改默认为单选题
    _headH = 80;//头部返回初始高度
    _footH = 100;
    _Number = 0;
    _DTKNumber = 0;
    
    _titleNameArray = [NSMutableArray array];
    _titleIdArray = [NSMutableArray array];
    _imageUrlArray = [NSMutableArray array];
    _TKImageArray = [NSMutableArray array];
    
    //输入框的个数
    _textFieldNumArray = [NSMutableArray array];
    
    if (_imagePhotoArray == nil) {
        _imagePhotoArray = [NSMutableArray array];
    }
    
    NSArray *FuckArray = _dataSource[@"data"][@"question"];
    
    NSInteger Count = FuckArray.count;
    
    for (int i = 0 ; i < Count; i ++) {
        NSString *Str = FuckArray[i][@"question_type_id"];
        if ([Str isEqualToString:@"1"]) {//单选题
            _singleArray = FuckArray[i][@"question_list"];
        } else if ([Str isEqualToString:@"2"]) {//多选题
            _multipleArray = FuckArray[i][@"question_list"];
        } else if ([Str isEqualToString:@"3"]) {//提空题
            _gapArray = FuckArray[i][@"question_list"];
        } else if ([Str isEqualToString:@"4"]) {//判断题
            _judgeArray = FuckArray[i][@"question_list"];
        } else if ([Str isEqualToString:@"5"]) {//主观题
            _SubjectiveArray = FuckArray[i][@"question_list"];
        }
        
        [_titleNameArray addObject:FuckArray[i][@"question_type_title"]];
        [_titleIdArray addObject:FuckArray[i][@"question_type_id"]];
    }
    
    NSLog(@"%@",_titleNameArray);
    
    //音频url
    _playUrl = _dataSource[@"data"][@"mp_path"];
    
    //将输入框的个数提出来
    if (_gapArray.count) {
        for (int i = 0; i < _gapArray.count; i ++) {
            NSString *numStr = _gapArray[i][@"question_option_count"];
            [_textFieldNumArray addObject:numStr];
        }
    }
    
    NSLog(@"%@",_textFieldNumArray);
    
    
    NSLog(@"%@",_myDXAnswerArray);
    
    //选中的按钮
    _XZArray = [NSMutableArray array];
    for (int i = 0 ; i < 40 ; i ++) {
        [_XZArray addObject:@"0"];
        
    }
    NSLog(@"-----%@",_XZArray);
    
    
    _AnswerArray = [NSMutableArray array];//初始化存放答案的数组
    _DXAnswerArray = [NSMutableArray array];
    _DDXAnswerArray = [NSMutableArray array];
    _TKAnswerArray = [NSMutableArray array];
    _PDAnswerArray = [NSMutableArray array];
    _ZGAnswerArray = [NSMutableArray array];
    
    //创建存放图片id的数组
    _imageIDArray = [NSMutableArray array];
    _ZGUpImageArray = [NSMutableArray array];
    _ZGUpImageIDArray = [NSMutableArray array];
    //    _imageArray = [NSMutableArray array];
    _SubjectiveImageArray = [NSMutableArray array];
    
    
    //数据赋值
    _DXAnswerArray = (NSMutableArray *)_myDXAnswerArray;
    _DDXAnswerArray= (NSMutableArray *) _myDDXAnswerArray;
    _TKAnswerArray = (NSMutableArray *)_myTKAnswerArray;
    _PDAnswerArray = (NSMutableArray *)_myPDAnswerArray;
    _ZGAnswerArray = (NSMutableArray *)_myZGAnswerArray;
    
    //图片
    _ZGUpImageArray = _myZGUpImageArray;
    _ZGUpImageIDArray = _myZGUpImageIDArray;
    
    
    //初始化
    _userDXAnswer = [NSMutableArray array];
    _userDDXAnswer = [NSMutableArray array];
    _userTKAnswer = [NSMutableArray array];
    _userPDAnswer = [NSMutableArray array];
    _userZGAnswer = [NSMutableArray array];
    
}

- (void)getFlag {
    _myDXAnswerArray = (NSMutableArray *)_userDXAnswer;
    _myDDXAnswerArray= (NSMutableArray *) _userDDXAnswer;
    _myTKAnswerArray = (NSMutableArray *)_userTKAnswer;
    _myPDAnswerArray = (NSMutableArray *)_userPDAnswer;
    _myZGAnswerArray = (NSMutableArray *)_userZGAnswer;
    
    
    
    //图片
    _ZGUpImageArray = _myZGUpImageArray;
    _ZGUpImageIDArray = _myZGUpImageIDArray;
}

#pragma mark --- 导航视图
- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"焦点按钮@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 25, 25, 50, 30)];
    WZLabel.text = @"单选";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    _WZLabel = WZLabel;
    
    //添加旁边向下的按钮
    UIButton *XXButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 + 29, 35, 15, 10)];
    [XXButton setBackgroundImage:Image(@"考试箭头@2x") forState:UIControlStateNormal];
    [SYGView addSubview:XXButton];
    _XXButton = XXButton;
    
    //添加按钮
    UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 25, MainScreenWidth - 240, 30)];
    titleButton.backgroundColor = [UIColor clearColor];
    [titleButton addTarget:self action:@selector(titleButton) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:titleButton];
    
    //添加按钮
    UIButton *musicButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 100, 25, 30, 30)];
    musicButton.backgroundColor = [UIColor clearColor];
    [musicButton setTitle:@"🎵" forState:UIControlStateNormal];
    [musicButton addTarget:self action:@selector(musicButton) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:musicButton];
    musicButton.hidden = YES;
    NSLog(@"%@",_playUrl);
    if ([_playUrl isEqual:[NSNumber numberWithInt:0]]) {
        musicButton.hidden = YES;
    }
    
    //添加音频
    
    NSLog(@"%@",_formType);
    
    
    if (_formType == nil) {
        //http://edu.htph.com.cn/voa.mp3
        
        if (![_playUrl isEqual:[NSNumber numberWithInt:0]]) {
            NSLog(@"%@",_playUrl);
            NSURL *url = [NSURL URLWithString:_playUrl];
            
            AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
            player = [[AVPlayer alloc]initWithPlayerItem:songItem];
        }
        
    } else {
        //        if ([_playUrl integerValue] != 0) {
        //            NSLog(@"%@",_playUrl);
        //            NSURL *url = [NSURL URLWithString:_playUrl];
        //
        //            AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
        //            player = [[AVPlayer alloc]initWithPlayerItem:songItem];
        //        }
        
    }
    
}


#pragma mark ---最先进来的 决定最先显示那个视图
- (void)firstView {
    if (_singleArray.count) {
        _dataSourceArray = _singleArray;
        _typeStr = @"1";
        [self tableViewApper];
    } else if (_multipleArray.count) {
        _dataSourceArray = _multipleArray;
        _typeStr = @"2";
        [self tableViewApper];
    } else if (_gapArray.count) {
        _dataSourceArray = _gapArray;
        _typeStr = @"3";
        [self TKViewApper];
    } else if (_judgeArray.count) {
        _dataSourceArray = _judgeArray;
        _typeStr = @"4";
        [self tableViewApper];
    } else if (_SubjectiveArray.count) {
        _dataSourceArray = _SubjectiveArray;
        _typeStr = @"5";
        [self ZGViewApper];
    }
    
}


#pragma mark --- 底部时间界面
- (void)addDownView {
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 58, MainScreenWidth, 58)];
    downView.backgroundColor = [UIColor colorWithRed:242.f / 255 green:242.f / 255 blue:242.f / 255 alpha:1];
    [self.view addSubview:downView];
    _downView = downView;
    [self.view bringSubviewToFront:downView];
    
    //添加一个分割线
    UILabel *HLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    HLabel.backgroundColor = [UIColor colorWithRed:217.f / 2255 green:217.f / 255 blue:217.f / 255 alpha:1];
    HLabel.backgroundColor = [UIColor lightGrayColor];
    [downView addSubview:HLabel];
    
    
    //上一题按钮
    UIButton *upButton = [[UIButton alloc] initWithFrame:CGRectMake(22, 17, 24, 24)];
    [upButton setBackgroundImage:Image(@"考试左@2x") forState:UIControlStateNormal];
    [upButton addTarget:self action:@selector(upButton) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:upButton];
    
    //下一题按钮
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 24 - 22, 17, 24, 24)];
    [nextButton setBackgroundImage:Image(@"考试右@2x") forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButton) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:nextButton];
    
    //剩余文本
    UILabel *SYLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 60, 19, 80, 20)];
    SYLabel.text = @"剩余时长：";
    if (_allTime == 0) {
        SYLabel.text = @"没有限制";
    }
    SYLabel.text = @"已考完";
    SYLabel.font = Font(15);
    SYLabel.textColor = XXColor;
    SYLabel.textAlignment = NSTextAlignmentRight;
    [downView addSubview:SYLabel];
    
    //时间文本
    UILabel *TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 + 20, 19, 80, 20)];
    TimeLabel.font = Font(15);
    TimeLabel.textColor = XXColor;
    [downView addSubview:TimeLabel];
    _TimeLabel = TimeLabel;
    
    
    
}


#pragma mark --- 视图显示与隐藏

- (void)tableViewApper {
    _tableView.hidden = NO;
    _TKView.hidden = YES;
    _ZGView.hidden = YES;
}

- (void)TKViewApper {
    _tableView.hidden = YES;
    _TKView.hidden = NO;
    _ZGView.hidden = YES;
}

- (void)ZGViewApper {
    _tableView.hidden = YES;
    _TKView.hidden = YES;
    _ZGView.hidden = NO;
}


- (void)getRigthAnswer {
    //单选的正确答案
    
    NSMutableArray *DXRightAnswer = [NSMutableArray array];
    for (int i = 0 ; i < _singleArray.count ; i ++) {
        NSString *answerStr = _singleArray[i][@"question_answer"];
        if (answerStr != nil) {
            [DXRightAnswer addObject:answerStr];
        }
        
        NSString *userA = _singleArray[i][@"user_answer"];
        if (userA != nil) {
            [_userDXAnswer addObject:userA];
        }
        
        
    }
    
    NSLog(@"----%@",_userDXAnswer);
    _DXRightAnswer = DXRightAnswer;
    
    //多选
    NSMutableArray *DDXRightAnswer = [NSMutableArray array];
    for (int  i = 0 ; i < _multipleArray.count; i ++) {
        NSString *answerStr = _multipleArray[i][@"question_answer"];
        if (answerStr != nil) {
            [DDXRightAnswer addObject:answerStr];
        }
        
        NSString *userA = _multipleArray[i][@"user_answer"];
        if (userA != nil) {
            [_userDDXAnswer addObject:userA];
        }
        
    }
    _DDXRightAnswer = DDXRightAnswer;
    NSLog(@"DDX---%@",_DDXRightAnswer);
    NSLog(@"%@",_typeStr);
    NSLog(@"%@",_userDDXAnswer);
    //填空
    NSMutableArray *TKRightAnswer = [NSMutableArray array];
    NSLog(@"%ld",_multipleArray.count);
    for (int  i = 0 ; i < _gapArray.count; i ++) {
        NSString *answerStr = _gapArray[i][@"question_answer"];
        
        if (answerStr != nil) {
            [TKRightAnswer addObject:answerStr];
        }
        
        NSString *userA = _gapArray[i][@"user_answer"];
        if (userA != nil) {
            [_userTKAnswer addObject:userA];
        }
    }
    _TKRightAnswer = TKRightAnswer;
    
    //判断
    NSMutableArray *PDRightAnswer = [NSMutableArray array];
    for (int  i = 0 ; i < _judgeArray.count; i ++) {
        NSString *answerStr = _judgeArray[i][@"question_answer"];
        
        if (answerStr != nil) {
            [PDRightAnswer addObject:answerStr];
        }
        
        NSString *userA = _judgeArray[i][@"user_answer"];
        if (userA != nil) {
            [_userPDAnswer addObject:userA];
        }
    }
    NSLog(@"------%@",_userPDAnswer);
    _PDRightAnswer = PDRightAnswer;
    
    //主观题
    
    for (int  i = 0 ; i < _SubjectiveArray.count; i ++) {
        NSString *answerStr = _SubjectiveArray[i][@"question_answer"];
        
        if (answerStr != nil) {
            [PDRightAnswer addObject:answerStr];
        }
        
        NSString *userA = _SubjectiveArray[i][@"user_answer"];
        if (userA != nil) {
            [_userZGAnswer addObject:userA];
        }
        
        NSArray *imageArray = _SubjectiveArray[i][@"attach_id"];
        if ([imageArray[0] isEqual:[NSNumber numberWithInteger:0]] || [imageArray[0] isEqualToString:@"fasle"]) {
            [_userImageArray addObject:@""];
        } else {
            
            for (int i = 0; i < imageArray.count; i ++) {
                [_userImageArray addObject:imageArray[i]];
            }
            
        }
        
    }
    
    NSLog(@"%@",_userDXAnswer);
    NSLog(@"----%@",_userTKAnswer);
    NSLog(@"%@",_userPDAnswer);
    NSLog(@"%@",_userZGAnswer);
    
    NSLog(@"%@",_userImageArray);
    
    NSLog(@"%@",_userDXAnswer);
    
    NSLog(@"%@  %@",_DXRightAnswer,DDXRightAnswer);
    
}


#pragma mark --- 添加各种视图
#pragma mark --- 选择题界面以及判断题界面
- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight  - 58 - 64 ) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
}

# pragma mark --- 表格试图

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height + 15;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *HHH = nil;
    
    if (_dataSourceArray.count > _Number) {
        HHH = _dataSourceArray[_Number][@"option_list"];
    }
    if ([HHH isEqual:[NSNull null]]) {
        return 0;
    }
    
    return HHH.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _headH;
}

//添加表格头部试图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSLog(@"%ld",_Number);
    //在这里显示对应题的题型名字
    NSString *typeStr = _dataSourceArray[_Number][@"question_type"];
    
    if ([typeStr isEqualToString:@"1"]) {
        _WZLabel.text = @"单选";
    } else if ([typeStr isEqualToString:@"2"]) {
        _WZLabel.text = @"多选";
    } else if ([typeStr isEqualToString:@"3"]) {
        _WZLabel.text = @"填空";
    } else if ([typeStr isEqualToString:@"4"]) {
        _WZLabel.text = @"判断";
    } else if ([typeStr isEqualToString:@"5"]) {
        _WZLabel.text = @"主观";
    }
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 30)];
    _headView.backgroundColor = [UIColor whiteColor];
    
    //题目
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth - 20, 100)];
    NSString *titleStr = [self filterHTML:_dataSourceArray[_Number][@"question_content"]];
    _titleLabel.text = titleStr;
    
    _titleLabel.font = Font(18);
    _titleLabel.textColor = [UIColor colorWithRed:125.f / 255 green:125.f / 255 blue:125.f / 255 alpha:1];
    _titleLabel.numberOfLines = 0;
    
    CGRect labelSize = [_titleLabel.text boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} context:nil];
    
    _titleLabel.frame = CGRectMake(_titleLabel.frame.origin.x,_titleLabel.frame.origin.y, self.view.bounds.size.width - 20, labelSize.size.height);
    [_headView addSubview:_titleLabel];
    
    //题干里面的图片视图
    _tableViewImageArray = (NSMutableArray *)[self filterHTMLImage:_dataSourceArray[_Number][@"question_content"]];
    _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, labelSize.size.height + 20, MainScreenWidth, 50)];
    
    NSInteger imageNum = _tableViewImageArray.count;
    CGFloat imageH = 80;
    CGFloat imageW = MainScreenWidth / 2;
    
    _contentImageView.backgroundColor = [UIColor whiteColor];
    [_headView addSubview:_contentImageView];
    
    //计算出自适应的高度
    if (_tableViewImageArray.count != 0) {//有图片 显示图片
        //计算尺寸
        if (imageNum % 2) {
            _contentImageView.frame = CGRectMake(0, labelSize.size.height + 20, MainScreenWidth, imageH * (imageNum / 2));
        } else {
            _contentImageView.frame = CGRectMake(0, labelSize.size.height + 20, MainScreenWidth, imageH * (imageNum /2) + 1);
        }
        
        _headView.frame = CGRectMake(0, 0, self.view.bounds.size.width, labelSize.size.height + 20 + CGRectGetHeight(_contentImageView.frame));
        for (int i = 0 ; i < _tableViewImageArray.count ; i ++) {
            NSInteger SecitionNum = 2;
            NSString *imageUrl = _tableViewImageArray[i];
            UIImageView *tableViewImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageW * (i % SecitionNum), imageH * (i / SecitionNum) , imageW, imageH)];
            [tableViewImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Image(@"站位图")];
            [_contentImageView addSubview:tableViewImage];
            //            tableViewImage.contentMode = UIViewContentModeScaleAspectFit;
        }
        _headH = _headView.bounds.size.height;
        
    } else {// 没有图片 确定位置
        _contentImageView.frame = CGRectMake(0, 0, 0, 0);
        _headView.frame = CGRectMake(0, 0, self.view.bounds.size.width, labelSize.size.height + 20);
        _headH = _headView.bounds.size.height;
    }
    
    return _headView;
}

//表格底部视图的高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return _footH;
}


//添加表格底部试图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100)];
    _footView.backgroundColor = [UIColor whiteColor];
    
    //参考答案
    UILabel *CKDALabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth, 30)];
    CKDALabel.text = [NSString stringWithFormat:@"参考答案：%@",_dataSourceArray[_Number][@"question_answer"]];
    CKDALabel.textColor = BlackNotColor;
    [_footView addSubview:CKDALabel];
    
    //添加答错的界面
    //添加按钮
    UIButton *falseButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 100, 10, 90, 30)];
    falseButton.layer.cornerRadius = 5;
    falseButton.backgroundColor = [UIColor redColor];
    [falseButton setTitle:@" 答错了!" forState:UIControlStateNormal];
    falseButton.titleLabel.font = Font(15);
    [falseButton setImage:Image(@"考试系统难过@2x") forState:UIControlStateNormal];
    falseButton.imageEdgeInsets =  UIEdgeInsetsMake(0,10,0,60);
    [_footView addSubview:falseButton];
    
    if (_dataSourceArray == _singleArray) {//单选
        NSString *myStr = _myDXAnswerArray[_Number];
        NSString *rightStr = nil;
        if (_DXRightAnswer.count) {
            rightStr = _DXRightAnswer[_Number];
        }
        if ([myStr isEqualToString:rightStr]) {
            //            falseButton.hidden = YES;
            [falseButton setTitle:@" 答对了" forState:UIControlStateNormal];
            [falseButton setImage:Image(@"考试系统开心@2x") forState:UIControlStateNormal];
        }
    } else if (_dataSourceArray == _multipleArray) {//多选
        NSString *myDDStr = _myDDXAnswerArray[_Number];
        NSString *myStr = [myDDStr stringByReplacingOccurrencesOfString:@"-" withString:@","];
        NSLog(@"-----%@",myStr);
        NSString *rightStr = nil;
        if (_DDXRightAnswer.count) {
            rightStr = _DDXRightAnswer[_Number];
        }
        NSLog(@"%@  %@",myStr,rightStr);
        if ([myStr isEqualToString:rightStr]) {
            [falseButton setTitle:@" 答对了" forState:UIControlStateNormal];
            [falseButton setImage:Image(@"考试系统开心@2x") forState:UIControlStateNormal];
        } else {
            
        }
        
    } else if (_dataSourceArray == _judgeArray) {//判断题
        NSString *myStr = _myPDAnswerArray[_Number];
        NSString *rightStr = nil;
        if (_PDRightAnswer.count) {
            rightStr = _PDRightAnswer[_Number];
        }
        if ([myStr isEqualToString:rightStr]) {
            //            falseButton.hidden = YES;
            [falseButton setTitle:@" 答对了" forState:UIControlStateNormal];
            [falseButton setImage:Image(@"考试系统开心@2x") forState:UIControlStateNormal];
        }
        
    }

    
    
    //添加自适应文本
    _footTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, MainScreenWidth - 20, 100)];
    _footTitle.text = _dataSourceArray[_Number][@"question_qsn_guide"];
    _footTitle.font = Font(18);
    _footTitle.textColor = BlackNotColor;
    
    _footTitle.numberOfLines = 0;
    CGRect labelSize = [_footTitle.text boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} context:nil];
    
    _footTitle.frame = CGRectMake(_footTitle.frame.origin.x,_footTitle.frame.origin.y, self.view.bounds.size.width - 20, labelSize.size.height);
    
    //计算出自适应的高度
    _footView.frame = CGRectMake(0, 0, self.view.bounds.size.width, labelSize.size.height + 60);
    [_footView addSubview:_footTitle];
    _footH = _footView.bounds.size.height;
    
    return _footView;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    XZTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[XZTTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    [_XZArray removeAllObjects];
    for (int i = 0 ; i < 40; i ++ ) {
        [_XZArray addObject:@"0"];
    }
    
    if (_dataSourceArray == _singleArray) {//单选
        
        NSLog(@"%@",_myDXAnswerArray);
        NSString *myStr = _myDXAnswerArray[_Number];
        
        if ([myStr isEqualToString:@""]) {//空
            
        } else if ([myStr isEqualToString:@"A"]) {//
            [_XZArray replaceObjectAtIndex:0 withObject:@"1"];
        } else if ([myStr isEqualToString:@"B"]) {
            [_XZArray replaceObjectAtIndex:1 withObject:@"1"];
        } else if ([myStr isEqualToString:@"C"]) {
            [_XZArray replaceObjectAtIndex:2 withObject:@"1"];
        } else if ([myStr isEqualToString:@"D"]) {
            [_XZArray replaceObjectAtIndex:3 withObject:@"1"];
        } else if ([myStr isEqualToString:@"E"]) {
            [_XZArray replaceObjectAtIndex:4 withObject:@"1"];
        } else if ([myStr isEqualToString:@"F"]) {
            [_XZArray replaceObjectAtIndex:5 withObject:@"1"];
        }
        
    } else if (_dataSourceArray == _multipleArray) {//多选
        
        NSString *answerStr = _myDDXAnswerArray[_Number];
        
        NSArray *aArray = [answerStr componentsSeparatedByString:@","];
        NSLog(@"%@",aArray);
        
        [_XZArray removeAllObjects];
        for (int i = 0; i < 40 ; i ++) {
            [_XZArray addObject:@"0"];
        }
        
        for (int i = 0; i < aArray.count; i ++) {
            NSString *str = aArray[i];
            if ([str isEqualToString:@"A"]) {
                [_XZArray replaceObjectAtIndex:0 withObject:@"1"];
            } else if ([str isEqualToString:@"B"]) {
                [_XZArray replaceObjectAtIndex:1 withObject:@"1"];
            } else if ([str isEqualToString:@"C"]) {
                [_XZArray replaceObjectAtIndex:2 withObject:@"1"];
            } else if ([str isEqualToString:@"D"]) {
                [_XZArray replaceObjectAtIndex:3 withObject:@"1"];
            } else if ([str isEqualToString:@"E"]) {
                [_XZArray replaceObjectAtIndex:4 withObject:@"1"];
            } else if ([str isEqualToString:@"F"]) {
                [_XZArray replaceObjectAtIndex:5 withObject:@"1"];
            } else if ([str isEqualToString:@"G"]) {
                [_XZArray replaceObjectAtIndex:6 withObject:@"1"];
            } else if ([str isEqualToString:@"H"]) {
                [_XZArray replaceObjectAtIndex:7 withObject:@"1"];
            } else {
                
            }
        }
        
    } else if (_dataSourceArray == _judgeArray) {//判断
        NSString *myStr = _myPDAnswerArray[_Number];
        
        if ([myStr isEqualToString:@""]) {//空
            
        } else if ([myStr isEqualToString:@"A"]) {//
            [_XZArray replaceObjectAtIndex:0 withObject:@"1"];
        } else if ([myStr isEqualToString:@"B"]) {
            [_XZArray replaceObjectAtIndex:1 withObject:@"1"];
        } else if ([myStr isEqualToString:@"C"]) {
            [_XZArray replaceObjectAtIndex:2 withObject:@"1"];
        }
        
    }

    
    [cell setIntroductionText:_dataSourceArray[_Number][@"option_list"][indexPath.row][@"option_content"]];
    NSString *ABCDStr = [NSString stringWithFormat:@"%@",_dataSourceArray[_Number][@"option_list"][indexPath.row][@"option_content"]];
    if (indexPath.row == 0) {
        
        [cell setIntroductionText:[NSString stringWithFormat:@"A、%@",ABCDStr]];
    } else if (indexPath.row == 1) {
        [cell setIntroductionText:[NSString stringWithFormat:@"B、%@",ABCDStr]];
    } else if (indexPath.row == 2) {
        [cell setIntroductionText:[NSString stringWithFormat:@"C、%@",ABCDStr]];
    } else if (indexPath.row == 3) {
        [cell setIntroductionText:[NSString stringWithFormat:@"D、%@",ABCDStr]];
    } else if (indexPath.row == 4) {
        [cell setIntroductionText:[NSString stringWithFormat:@"E、%@",ABCDStr]];
    } else if (indexPath.row == 5) {
        [cell setIntroductionText:[NSString stringWithFormat:@"F、%@",ABCDStr]];
    } else if (indexPath.row == 6) {
        [cell setIntroductionText:[NSString stringWithFormat:@"G、%@",ABCDStr]];
    }
    
    NSLog(@"--------%@",_XZArray);
    if ([_XZArray[indexPath.row] intValue] == 1) {
        [cell.XZButton setBackgroundImage:Image(@"选择题选中@2x") forState:UIControlStateNormal];
    } else if ([_XZArray[indexPath.row] intValue] == 2) {//解析正确答案
        
        [cell.XZButton setBackgroundImage:Image(@"考试系统选择正确答案@2x") forState:UIControlStateNormal];
    } else {
        [cell.XZButton setBackgroundImage:Image(@"选择题未选中@2x") forState:UIControlStateNormal];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    return;
}


#pragma mark --- 填空题界面
- (void)addTKView {
    
    if (_gapArray.count ==  0) {
        return;
    }
    _dataSourceArray = _gapArray;
    //添加(填空题)的试图
    UIScrollView *TKView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 - 58)];
    TKView.backgroundColor = [UIColor whiteColor];
    TKView.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight * 2);
    [self.view addSubview:TKView];
    _TKView.userInteractionEnabled = YES;
    TKView.delegate = self;
    _TKView = TKView;
    _TKView.hidden = YES;
    
    //填空题的最上面的视图
    _TKTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100)];
    [_TKView addSubview:_TKTopView];
    
    //填空题的题干
    _TKTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth - 20, 100)];
    NSString *TSting = _dataSourceArray[_Number][@"question_content"];
    NSString *titleStr = [self filterHTML:TSting];
    [self TKSetIntroductionText:titleStr];
    _TKTitleLabel.font = Font(18);
    _TKTitleLabel.textColor = [UIColor colorWithRed:125.f / 255 green:125.f / 255 blue:125.f / 255 alpha:1];
    [_TKTopView addSubview:_TKTitleLabel];
    
    
    _TKImageArray = (NSMutableArray *)[self filterHTMLImage:_dataSourceArray[_Number][@"question_content"]];
    NSLog(@"%@",_TKImageArray);
    
    //填空题的图片视图
    _TKPhotoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_TKTitleLabel.frame), MainScreenWidth, 80)];
    _TKPhotoView.backgroundColor = [UIColor whiteColor];
    [_TKTopView addSubview:_TKPhotoView];
    
    _SecitionNum = 2;
    _TKImageNum = _TKImageArray.count;
    _TKImageViewH = 80;
    CGFloat imageW = MainScreenWidth / 2;
    
    
    NSLog(@"hegiht---%f",_TKTitleLabel.frame.size.height);
    NSLog(@"------%ld",_TKImageNum);
    
    if (_TKImageArray.count) {
        //计算出图片视图的大小
        if (_TKImageNum % _SecitionNum == 0) {
            _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTitleLabel.frame), MainScreenWidth, _TKImageViewH * (_TKImageNum / _SecitionNum));
            _TKTopView.frame = CGRectMake(0, 0, MainScreenWidth, _TKTitleLabel.frame.size.height + _TKImageViewH * (_TKImageNum / _SecitionNum ) + 40);
        } else {
            _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTitleLabel.frame), MainScreenWidth, _TKImageViewH * (_TKImageNum / _SecitionNum) + 1);
            _TKTopView.frame = CGRectMake(0, 0, MainScreenWidth, _TKTitleLabel.frame.size.height + _TKImageViewH * (_TKImageNum / _SecitionNum + 1) + 40);
        }
        
        for (int i = 0 ; i < _TKImageArray.count; i ++) {
            
            NSString *imageUrl = _TKImageArray[i];
            UIImageView *TKImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageW * (i % _SecitionNum), _TKImageViewH * (i / _SecitionNum) , imageW, _TKImageViewH)];
            [TKImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Image(@"站位图")];
            [_TKPhotoView addSubview:TKImageView];
            TKImageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        
    } else {
        _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTitleLabel.frame), MainScreenWidth, 0);
        _TKTopView.frame = CGRectMake(0, 0, MainScreenWidth, _TKTitleLabel.frame.size.height + 20);
    }
    
    
    //输入框的视图
    UIView *textFieldView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth - 20, 300)];
    textFieldView.backgroundColor = [UIColor whiteColor];
    [_TKView addSubview:textFieldView];
    textFieldView.userInteractionEnabled = YES;
    
    NSLog(@"%ld",_textFieldNumArray.count);
    
    _TKTextSecitonH = 50;
    
    if (_textFieldNumArray.count) {
        
        NSLog(@"%ld",_textFieldNumArray.count);
        if (![_textFieldNumArray[_Number] isEqualToString:@"0"]) {
            
            //最终视图的位置以及大小
            textFieldView.frame = CGRectMake(10,CGRectGetMaxY(_TKTopView.frame), MainScreenWidth - 20, [_textFieldNumArray[_Number] integerValue] * _TKTextSecitonH);
            
            NSString *userTKStr = nil;
            NSArray *spArray = [NSArray array];
            if (_userTKAnswer.count) {
                userTKStr = _userTKAnswer[0];
                spArray = [userTKStr componentsSeparatedByString:@","];
            }
            
            NSLog(@"%@",spArray);
            for (int i = 0 ; i < [_textFieldNumArray[_Number] integerValue]; i ++) {
                
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, i * _TKTextSecitonH, MainScreenWidth - 40, 40)];
                textField.layer.cornerRadius = 5;
                textField.layer.borderWidth = 1;
                textField.layer.borderColor = PartitionColor.CGColor;
                [textFieldView addSubview:textField];
                textField.userInteractionEnabled = YES;
                if (spArray.count != 0 && spArray.count > i) {
                    textField.text = spArray[i];
                }
            }
        }
    }
    _TKtextFieldView = textFieldView;
    
    //添加解析界面
    [self addTKJXView];
    
}

-(void)TKSetIntroductionText:(NSString*)text{
    //获得当前cell高度
    //文本赋值
    _TKTitleLabel.text = text;
    //设置label的最大行数
    _TKTitleLabel.numberOfLines = 0;
    
    CGRect labelSize = [_TKTitleLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} context:nil];
    
    _TKTitleLabel.frame = CGRectMake(_TKTitleLabel.frame.origin.x,_TKTitleLabel.frame.origin.y, MainScreenWidth - 20, labelSize.size.height);
    
    //计算出自适应的高度
    _TKTopView.frame = CGRectMake(0, 0, MainScreenWidth, labelSize.size.height + 20 + 10);
    
}


//添加填空题的解析界面
- (void)addTKJXView {
    UIView *TKJXView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_TKtextFieldView.frame), MainScreenWidth, 200)];
    TKJXView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_TKView addSubview:TKJXView];
    _TKJXView = TKJXView;
    
    //添加答错的界面
    //添加按钮
    UIButton *falseButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 90, 30)];
    falseButton.layer.cornerRadius = 5;
    falseButton.backgroundColor = [UIColor redColor];
    [falseButton setTitle:@" 答错了!" forState:UIControlStateNormal];
    falseButton.titleLabel.font = Font(15);
    [falseButton setImage:Image(@"考试系统难过@2x") forState:UIControlStateNormal];
    falseButton.imageEdgeInsets =  UIEdgeInsetsMake(0,10,0,60);
    [TKJXView addSubview:falseButton];
    
    if (_myTKAnswerArray.count) {
        if (_Number < _myTKAnswerArray.count) {
            
            NSLog(@"%@",_dataSourceArray[_Number][@"question_answer"]);
            if ([_dataSourceArray[_Number][@"question_answer"] isEqualToString:_myTKAnswerArray[_Number]]) {
                [falseButton setTitle:@" 答对了" forState:UIControlStateNormal];
                [falseButton setImage:Image(@"考试系统开心@2x") forState:UIControlStateNormal];
            }
        }
    }
    _TKFalseButton = falseButton;
    
    //参考答案
    UILabel *CKDALabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(falseButton.frame), MainScreenWidth, 50)];
    NSString *CKDAStr = [NSString stringWithFormat:@"参考答案：%@",_dataSourceArray[_Number][@"question_answer"]];
    CKDALabel.textColor = BlackNotColor;
    [TKJXView addSubview:CKDALabel];
    CKDALabel.numberOfLines = 0;
    _CKDALabel = CKDALabel;
    [self TKJXAnswerIntroductionText:CKDAStr];
    
    
    //添加自适应文本(填空解析文本）
    UILabel *TKJXLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, MainScreenWidth - 20, 100)];
    TKJXLabel.text = [NSString stringWithFormat:@"答案解析：%@",_dataSourceArray[_Number][@"question_qsn_guide"]];
    TKJXLabel.font = Font(18);
    TKJXLabel.textColor = BlackNotColor;
    
    [TKJXView addSubview:TKJXLabel];
    _TKJXLabel = TKJXLabel;
    _TKJXView = TKJXView;
    
    [self TKJXTitleIntroductionText:_TKJXLabel.text];
    
}


//填空题答案文本
-(void)TKJXAnswerIntroductionText:(NSString*)text{
    //获得当前cell高度
    //文本赋值
    _CKDALabel.text = text;
    //设置label的最大行数
    _CKDALabel.numberOfLines = 0;
    
    NSLog(@"%@",text);
    CGRect labelSize = [_CKDALabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil];
    
    _CKDALabel.frame = CGRectMake(_CKDALabel.frame.origin.x,_CKDALabel.frame.origin.y, MainScreenWidth - 20, labelSize.size.height + 20);
}


//填空题解析文本的自适应
-(void)TKJXTitleIntroductionText:(NSString*)text{
    //获得当前cell高度
    //文本赋值
    _TKJXLabel.text = text;
    //设置label的最大行数
    _TKJXLabel.numberOfLines = 0;
    
    NSLog(@"%@",text);
    CGRect labelSize = [_TKJXLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} context:nil];
    
    _TKJXLabel.frame = CGRectMake(_TKJXLabel.frame.origin.x,CGRectGetMaxY(_CKDALabel.frame), MainScreenWidth - 20, labelSize.size.height);
    
    //计算出自适应的高度
    
    _TKJXView.frame = CGRectMake(0, CGRectGetMaxY(_TKtextFieldView.frame) + 20, self.view.bounds.size.width, labelSize.size.height + CGRectGetHeight(_CKDALabel.frame) + CGRectGetHeight(_TKFalseButton.frame) + 30);
    
}

#pragma mark --- 添加主观题视图

- (void)addZGView {
    
    if (_SubjectiveArray.count == 0) {
        return;
    }
    _dataSourceArray = _SubjectiveArray;
    
    //初始化存放上传图片的ID 以及 图片数组
    for (int i = 0 ; i < _dataSourceArray.count ; i ++) {//主观题的个数
        NSArray *imageArray = [NSArray array];
        [_ZGUpImageArray addObject:imageArray];
        
        NSArray *imageIDArray = [NSArray array];
        [_ZGUpImageIDArray addObject:imageIDArray];
    }
    
    NSLog(@"%@ %@",_ZGUpImageIDArray,_ZGUpImageArray);
    
    //这里改变上面View的颜色
    
    //添加主观题的界面
    _ZGView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 - 58)];
    _ZGView.backgroundColor = [UIColor colorWithRed:242.f / 255 green:242.f / 255 blue:242.f / 255 alpha:1];
    [self.view addSubview:_ZGView];
    _ZGView.hidden = YES;
    _ZGView.contentSize = CGSizeMake(MainScreenWidth , MainScreenHeight * 2);
    
    //添加题目
    _ZGTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100)];
    _ZGTopView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_ZGView addSubview:_ZGTopView];
    _ZGTopView.backgroundColor = [UIColor whiteColor];
    
    
    _ZGTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth - 20, 100)];
    NSString *title = nil;
    
    if (_Number >= _SubjectiveArray.count) {
    } else {
        title = [self filterHTML:_dataSourceArray[_Number][@"question_content"]];
    }
    
    _ZGTitleLabel.font = Font(18);
    [self ZGSetIntroductionText:title];
    NSLog(@"%ld  %ld",_Number,_SubjectiveArray.count);
    
    
    _ZGTitleLabel.textColor = [UIColor colorWithRed:125.f / 255 green:125.f / 255 blue:125.f / 255 alpha:1];
    [_ZGTopView addSubview:_ZGTitleLabel];
    
    //添加图片视图
    _ZGImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_ZGTitleLabel.frame), MainScreenWidth, 100)];
    _ZGImageView.backgroundColor = [UIColor whiteColor];
    [_ZGTopView addSubview:_ZGImageView];
    
    //计算图片视图的大小
    _ZGImageArray =(NSMutableArray *)[self filterHTMLImage:_dataSourceArray[_Number][@"question_content"]];
    
    _ZGImageNum = _ZGImageArray.count;
    _ZGImageViewH = 80;
    _SecitionNum = 2;
    
    if (_ZGImageArray.count) {
        //计算出图片视图的大小
        if (_ZGImageNum % _SecitionNum == 0) {
            _ZGImageView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTitleLabel.frame) + SpaceBaside, MainScreenWidth, _ZGImageViewH * (_ZGImageNum / _SecitionNum));
            _ZGTopView.frame = CGRectMake(0, 0, MainScreenWidth, _ZGTitleLabel.frame.size.height + _ZGImageViewH * (_ZGImageNum / _SecitionNum ) + 40);
        } else {
            _ZGImageView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTitleLabel.frame) + SpaceBaside, MainScreenWidth, _ZGImageViewH * (_ZGImageNum / _SecitionNum) + 1);
            _ZGTopView.frame = CGRectMake(0, 0, MainScreenWidth, _ZGTitleLabel.frame.size.height + _ZGImageViewH * (_ZGImageNum / _SecitionNum + 1) + 40);
        }
        
        for (int i = 0 ; i < _ZGImageArray.count; i ++) {
            
            NSString *imageUrl = _ZGImageArray[i];
            UIImageView *ZGImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 * (i % _SecitionNum), _ZGImageViewH * (i / _SecitionNum) , MainScreenWidth / 2, _ZGImageViewH)];
            [ZGImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Image(@"站位图")];
            [_ZGImageView addSubview:ZGImageView];
            ZGImageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        
    } else {
        _ZGImageView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTitleLabel.frame), MainScreenWidth, 0);
        _ZGTopView.frame = CGRectMake(0, 0, MainScreenWidth, _ZGTitleLabel.frame.size.height + 20);
    }
    
    //添加叙述view
    UIView *XSView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_ZGTopView.frame), MainScreenWidth, 500)];
    XSView.backgroundColor = [UIColor whiteColor];
    [_ZGView addSubview:XSView];
    _ZGXSView = XSView;
    
    
    //添加textView
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10,10, MainScreenWidth - 20, 100)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.font = Font(16);
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _textView.layer.cornerRadius = 5;
    [XSView addSubview:_textView];
    if (_myZGAnswerArray.count > 0) {
        _textView.text = _myZGAnswerArray[0];
    }
    
    
    //添加展示图片的View
    _photosView = [[PhotosView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_textView.frame) + SpaceBaside, MainScreenWidth, 230)];
    _photosView.backgroundColor = [UIColor whiteColor];
    _photosView.hidden = NO;
    _photosView.userInteractionEnabled = YES;
    [XSView addSubview:_photosView];
    if (_ZGUpImageArray.count) {
        
    } else {//没有图片的时候
         _photosView.frame = CGRectMake(0,  CGRectGetMaxY(_textView.frame) + SpaceBaside, MainScreenWidth, 10);
        _ZGXSView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTopView.frame), MainScreenWidth, 130);
    }
    
    //添加答案解析的界面
    UIView *ZGJXView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_ZGXSView.frame), MainScreenWidth, 200)];
    ZGJXView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_ZGView addSubview:ZGJXView];
    _ZGJXView = ZGJXView;
    
    _ZGJXLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth - 20, 50)];
    NSString *ZGJXStr = [NSString stringWithFormat:@"%@",_dataSourceArray[_Number][@"question_qsn_guide"]];
    [_ZGJXView addSubview:_ZGJXLabel];
    _ZGJXLabel.font = Font(14);
    [self ZGJXIntroductionText:ZGJXStr];
    
}

//主观题里面的资源提取
-(void)ZGSetIntroductionText:(NSString*)text{
    //获得当前cell高度
    //文本赋值
    _ZGTitleLabel.text = text;
    //设置label的最大行数
    _ZGTitleLabel.numberOfLines = 0;
    
    CGRect labelSize = [_ZGTitleLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} context:nil];
    
    _ZGTitleLabel.frame = CGRectMake(_ZGTitleLabel.frame.origin.x,_ZGTitleLabel.frame.origin.y, MainScreenWidth - 20, labelSize.size.height);
    
    //计算出自适应的高度
    _ZGTopView.frame = CGRectMake(0, 0, MainScreenWidth, labelSize.size.height + 20);
    
}


//解析界面
- (void)ZGJXIntroductionText:(NSString *)text {
    NSLog(@"%@",text);
    //设置label的最大行数
    _ZGJXLabel.numberOfLines = 0;
    NSLog(@"%@",_ZGJXLabel.text);
    CGRect labelSize = [text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
    NSLog(@"%@",NSStringFromCGRect(labelSize));
    
    _ZGJXLabel.text = text;
    
    _ZGJXLabel.frame = CGRectMake(_ZGJXLabel.frame.origin.x,_ZGJXLabel.frame.origin.y, MainScreenWidth - 20, labelSize.size.height);
    _ZGJXView.frame = CGRectMake(0, CGRectGetMaxY(_ZGXSView.frame), MainScreenWidth, labelSize.size.height + 20);
    
}



- (void)backPressed {
    //    _isGoOutEduline = @"1234";
    [self.navigationController popViewControllerAnimated:YES];
    //销毁 音乐
    [player replaceCurrentItemWithPlayerItem:nil];
    player = [[AVPlayer alloc] initWithPlayerItem:nil];
    player = nil;
}

- (void)musicButton {
    if (isPlaying) {
        [player pause];
        isPlaying = NO;
    } else {
        isPlaying = YES;
        [player play];
    }
}



- (void)titleButton {
    
    if (flag) {
        [UIView animateWithDuration:0.25 animations:^{
            _XXButton.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
            flag = NO;
        }];
        [self addMoreView];
    }
    else {
        [UIView animateWithDuration:0.25 animations:^{
            _XXButton.transform = CGAffineTransformMakeRotation(0);
        } completion:^(BOOL finished) {
            flag = YES;
        }];
        [self removeMoreView];
    }
    
    
    
}


#pragma mark --- 顶部选项界面

- (void)addMoreView {
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:_allView];
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
    
    [_allView addSubview:_allButton];
    
    
    
    _buyView = [[UIView alloc] init];
    _buyView.frame = CGRectMake(MainScreenWidth / 2 - 70, 0, 140, _titleNameArray.count * 40 + 5 * (_titleNameArray.count - 1));
    _buyView.backgroundColor = [UIColor colorWithRed:0.f / 255 green:0.f / 255 blue:0.f / 255 alpha:0.7];
    _buyView.layer.cornerRadius = 3;
    [_allView addSubview:_buyView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(MainScreenWidth / 2 - 70, 64, 140, _titleNameArray.count * 40 + 5 * (_titleNameArray.count - 1));
        //在view上面添加东西
        for (int i = 0 ; i < _titleNameArray.count ; i ++) {
            UIButton *button = [[UIButton alloc ] initWithFrame:CGRectMake(0, i * 40 + i * 5, 140, 40)];
            [button setTitle:_titleNameArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:156.f / 255 green:156.f / 255 blue:156.f / 255 alpha:1] forState:UIControlStateNormal];
            button.layer.cornerRadius = 5;
            button.tag = [_titleIdArray[i] integerValue];
            button.tag = i + 1;
            button.titleLabel.font = Font(18);
            [button addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [_buyView addSubview:button];
            
        }
        
        
    }];
    
    
}


- (void)removeMoreView {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(MainScreenWidth / 2 - 70, 0, 140, _titleNameArray.count * 40 + 5 * (_titleNameArray.count - 1));
        _allView.alpha = 0;
        _allButton.alpha = 0;
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_buyView removeFromSuperview];
        
    });
    
    
}

- (void)miss {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(MainScreenWidth / 2 - 70, 0, 140, _titleNameArray.count * 40 + 5 * (_titleNameArray.count - 1));
        _allView.alpha = 0;
        _allButton.alpha = 0;
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_buyView removeFromSuperview];
        [self titleButton];
        
    });
    
}

- (void)SYGButton:(UIButton *)button {
    
    NSLog(@"%@",_titleNameArray);
    NSLog(@"%@",button.titleLabel.text);
    NSString *title = button.titleLabel.text;
    
    if ([title rangeOfString:@"单选"].location != NSNotFound) {
        _WZLabel.text = @"单选";
        _typeStr = @"1";
        _dataSourceArray = _singleArray;
        [self tableViewApper];
    } else if ([title rangeOfString:@"多"].location != NSNotFound) {
        _WZLabel.text = @"多选";
        _typeStr = @"2";
        _dataSourceArray = _multipleArray;
        [self tableViewApper];
    } else if ([title rangeOfString:@"填空"].location != NSNotFound) {
        _WZLabel.text = @"填空";
        _typeStr = @"3";
        _dataSourceArray = _gapArray;
        [self TKViewApper];
        //        [self oneTKViewApper];
    } else if ([title rangeOfString:@"判断"].location != NSNotFound) {
        _WZLabel.text = @"判断";
        _typeStr = @"4";
        _dataSourceArray = _judgeArray;
        [self tableViewApper];
    } else if ([title rangeOfString:@"主观"].location != NSNotFound) {
        _WZLabel.text = @"主观";
        _typeStr = @"5";
        _dataSourceArray = _SubjectiveArray;
        [self ZGViewApper];
    }
    [self miss];
    
    //将_Number 置为0
    _Number = 0;
    
    [_tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
    
}

- (void)upButton {
    
    if (_formStr) {//从答题卡回来 （重设置）
        _DTKNumber = 0;
    }
    
    if (_dataSourceArray == _singleArray) {//说明是单选题
        
        if (_Number == 0) {//说明是最第一题了
            [MBProgressHUD showSuccess:@"已经是第一题了" toView:self.view];
            return;
        } else {
            NSLog(@"123");
        }
        
    } else if (_dataSourceArray == _multipleArray) {//多选时
        
        if (_Number == 0) {//说明是多选题的第一题
            
            if (_singleArray.count) {
                _dataSourceArray = _singleArray;
                _Number = _singleArray.count;
                _typeStr = @"1";
                [self tableViewApper];
            } else {
                [MBProgressHUD showError:@"已经是第一题了" toView:self.view];
                return;
            }
        }
    } else if (_dataSourceArray == _gapArray) {//提空题
        
        if (_Number == 0) {//说明是提空题第一题
            
            if (_multipleArray.count) {
                _dataSourceArray = _multipleArray;
                _Number = _multipleArray.count;
                _typeStr = @"1";
                [self tableViewApper];
            } else if (_singleArray.count) {
                _dataSourceArray = _singleArray;
                _Number = _singleArray.count;
                _typeStr = @"2";
                [self tableViewApper];
            } else {
                [MBProgressHUD showError:@"已经是第一题了" toView:self.view];
                return;
            }
            
        } else {
            
            _dataSourceArray = _gapArray;
            _typeStr = @"3";
            [self TKViewApper];
            [self TKViewApperWithUp];
            
        }
        
    } else if (_dataSourceArray == _judgeArray) {//判断题
        
        if (_Number == 0) {
            
            if (_gapArray.count) {
                _dataSourceArray = _gapArray;
                _typeStr = @"3";
                [self TKViewApper];
                _Number = _gapArray.count;
                [self TKViewApperWithUp];
                
            } else if (_multipleArray.count) {
                _dataSourceArray = _multipleArray;
                _Number = _multipleArray.count;
            } else if (_singleArray.count) {
                _dataSourceArray = _singleArray;
                _Number = _singleArray.count;
            } else {
                [MBProgressHUD showError:@"已经是第一题了" toView:self.view];
                return;
            }
            
        } else { //判断题
            _typeStr = @"4";
            [self tableViewApper];
            
            if ([_formWhere isEqualToString:@"123"]) {
                if (_myZGAnswerArray.count > _Number - 1) {
                    _textView.text = _myZGAnswerArray[_Number - 1];
                }
            } else if (_formStr != nil) {
                
                if (_ZGAnswerArray.count == 0) {
                    
                } else {
                    _textView.text = _ZGAnswerArray[_Number - 1];
                }
            } else {
                
                if (_Number - 1 >= _ZGAnswerArray.count) {
                    
                } else {
                    _textView.text = _ZGAnswerArray[_Number - 1];
                }
                if (_textView.text.length > 0) {
                    _ZGTXLabel.hidden = YES;
                }
            }
            
        }
    } else if (_dataSourceArray == _SubjectiveArray) {//主观题
        if (_Number == 0) {
            if (_judgeArray.count) {
                _dataSourceArray = _judgeArray;
                _Number = _judgeArray.count;
                _typeStr = @"4";
                [self tableViewApper];
            } else if (_gapArray.count) {
                _dataSourceArray = _gapArray;
                _Number = _gapArray.count;
                _typeStr = @"3";
                [self TKViewApper];
            } else if (_multipleArray.count) {
                _dataSourceArray = _multipleArray;
                _Number = _multipleArray.count;
                _typeStr = @"2";
                [self tableViewApper];
            } else if (_singleArray.count) {
                _dataSourceArray = _singleArray;
                _Number = _singleArray.count;
                _typeStr = @"1";
                [self tableViewApper];
            } else {
                [MBProgressHUD showError:@"已经是第一题了" toView:self.view];
                return;
            }
            
        } else {//显示的主观题
            
            [self ZGViewApper];
            _typeStr = @"5";
            _WZLabel.text = @"主观";
            //将主观题的视图以及资源显示出来
            [self ZGViewApperWithUp];
            
        }
    }
    
    
    _Number --;
    
    NSLog(@"---%@",_DXAnswerArray);
    if ([_typeStr integerValue] == 1) {//当前为单选题
        NSString *answerStr = nil;
        
        if (_DXAnswerArray.count) {
            NSLog(@"%ld  %ld",_Number,_DXAnswerArray.count);
            if (_Number >= _DXAnswerArray.count) {
            } else {
                answerStr = _DXAnswerArray[_Number];
            }
        }
        [_XZArray removeAllObjects];
        for (int i = 0; i < 40 ; i ++) {
            [_XZArray addObject:@"0"];
        }
        if ([answerStr isEqualToString:@""]) {//空
            
        } else if ([answerStr isEqualToString:@"1"]) {//
            [_XZArray replaceObjectAtIndex:0 withObject:@"1"];
        } else if ([answerStr isEqualToString:@"2"]) {
            [_XZArray replaceObjectAtIndex:1 withObject:@"1"];
        } else if ([answerStr isEqualToString:@"3"]) {
            [_XZArray replaceObjectAtIndex:2 withObject:@"1"];
        } else if ([answerStr isEqualToString:@"4"]) {
            [_XZArray replaceObjectAtIndex:3 withObject:@"1"];
        }
    } else if ([_typeStr integerValue] == 2) {//多选题
        NSLog(@"%@",_DDXAnswerArray);
        NSString *answerStr = nil;
        if (_DDXAnswerArray.count > _Number) {
            answerStr = _DDXAnswerArray[_Number];
        }
        [_XZArray removeAllObjects];
        for (int i = 0; i < 40 ; i ++) {
            [_XZArray addObject:@"0"];
        }
        
        //          [TSting componentsSeparatedByString:@"_____"];
        //            NSLog(@"----%@",[TSting componentsSeparatedByString:@"______"]);
        
        if (![answerStr isEqualToString:@""]) {
            
            if (answerStr.length == 1) {//说明只有一个答案
                if ([answerStr isEqualToString:@"A"]) {//
                    [_XZArray replaceObjectAtIndex:0 withObject:@"1"];
                } else if ([answerStr isEqualToString:@"B"]) {
                    [_XZArray replaceObjectAtIndex:1 withObject:@"1"];
                } else if ([answerStr isEqualToString:@"C"]) {
                    [_XZArray replaceObjectAtIndex:2 withObject:@"1"];
                } else if ([answerStr isEqualToString:@"D"]) {
                    [_XZArray replaceObjectAtIndex:3 withObject:@"1"];
                } else if ([answerStr isEqualToString:@"E"]) {
                    [_XZArray replaceObjectAtIndex:4 withObject:@"1"];
                } else if ([answerStr isEqualToString:@"F"]) {
                    [_XZArray replaceObjectAtIndex:5 withObject:@"1"];
                } else if ([answerStr isEqualToString:@"G"]) {
                    [_XZArray replaceObjectAtIndex:6 withObject:@"1"];
                } else if ([answerStr isEqualToString:@"H"]) {
                    [_XZArray replaceObjectAtIndex:7 withObject:@"1"];
                }
                
                
            } else if (answerStr.length > 1) {
                NSArray *byArray = [answerStr componentsSeparatedByString:@"-"];
                for (int i = 0 ; i < byArray.count ; i ++) {
                    NSString *byStr = byArray[i];
                    if ([byStr isEqualToString:@"A"]) {
                        [_XZArray replaceObjectAtIndex:0 withObject:@"1"];
                    } else if ([byStr isEqualToString:@"B"]) {
                        [_XZArray replaceObjectAtIndex:1 withObject:@"1"];
                    } else if ([byStr isEqualToString:@"C"]) {
                        [_XZArray replaceObjectAtIndex:2 withObject:@"1"];
                    } else if ([byStr isEqualToString:@"D"]) {
                        [_XZArray replaceObjectAtIndex:3 withObject:@"1"];
                    } else if ([byStr isEqualToString:@"E"]) {
                        [_XZArray replaceObjectAtIndex:4 withObject:@"1"];
                    } else if ([byStr isEqualToString:@"F"]) {
                        [_XZArray replaceObjectAtIndex:5 withObject:@"1"];
                    } else if ([byStr isEqualToString:@"G"]) {
                        [_XZArray replaceObjectAtIndex:6 withObject:@"1"];
                    } else if ([byStr isEqualToString:@"H"]) {
                        [_XZArray replaceObjectAtIndex:7 withObject:@"1"];
                    }
                }
            }
        }
        
    } else if ([_typeStr integerValue] == 3) {//填空
        NSString *answerStr = nil;
        NSLog(@"----%@",_userTKAnswer);
        if (_userTKAnswer.count >= _Number && _userTKAnswer.count > 0) {
            answerStr = _userTKAnswer[_Number];
        }
        
        NSArray *spArray = [answerStr componentsSeparatedByString:@","];
        NSLog(@"999----%@",spArray);
        
        for (int i = 0; i < spArray.count; i ++) {
            NSLog(@"%@",_TKtextFieldView.subviews);
            NSArray *subArray = _TKtextFieldView.subviews;
            UITextField *text = nil;
            if (subArray.count > i) {
                text = subArray[i];
            }
            
            if ([spArray[i] isEqualToString:@""]) {
                
            } else {
                text.text = spArray[i];
            }
            
        }
        
    } else if ([_typeStr integerValue] == 4) {//判断
        NSString *answerStr = nil;
        if (_PDAnswerArray.count >= _Number + 1 ) {
            answerStr = _PDAnswerArray[_Number];
        }
        [_XZArray removeAllObjects];
        for (int i = 0; i < 40 ; i ++) {
            [_XZArray addObject:@"0"];
        }
        
        if ([answerStr isEqualToString:@""]) {//空
            
        } else if ([answerStr isEqualToString:@"1"]) {//
            [_XZArray replaceObjectAtIndex:0 withObject:@"1"];
        } else if ([answerStr isEqualToString:@"2"]) {
            [_XZArray replaceObjectAtIndex:1 withObject:@"1"];
        } else if ([answerStr isEqualToString:@"3"]) {
            [_XZArray replaceObjectAtIndex:2 withObject:@"1"];
        }
        
    } else if ([_typeStr integerValue] == 5) {//主观
        NSString *answerStr = nil;
        if (_myZGAnswerArray.count >= _Number + 1) {
            answerStr = _myZGAnswerArray[_Number];
        }
        _textView.text = answerStr;
        if (answerStr == nil) {
            _ZGTXLabel.hidden = NO;
        } else {
            _ZGTXLabel.hidden = YES;
        }
        
        //图片视图
        NSArray *imageArray = [NSArray array];
        if (_ZGUpImageArray.count >= _Number + 1) {
            imageArray = _ZGUpImageArray[_Number];
        }
        
        NSLog(@"-----%@",imageArray);
        if (imageArray == nil) {//为空的时候 就是没有图片
            
        } else {
            //移除之前的视图
            [self.photosView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            for (int i = 0; i < imageArray.count ; i ++) {
                UIImage *image = imageArray[i];
                [self.photosView addImage:image];
            }
        }
        
        //解析界面
        NSString *ZGJXStr = [NSString stringWithFormat:@"参考答案：%@",_dataSourceArray[_Number][@"question_qsn_guide"]];
        [self ZGJXIntroductionText:ZGJXStr];
        
    }
    
    
    NSLog(@"%@",_ZGUpImageIDArray);
    
    [_tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//这个方法再次刷新 保证头部的空间跟自适应 一致
        [_tableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
    
    
}


- (void)nextButton {
    
    if (_formStr) {//从答题卡回来的话 (重设置)
        _DTKNumber = 0;
    }
    
    if (_dataSourceArray == _singleArray) {//说明是单选题
        
        if (_Number == _singleArray.count - 1) {//说明是最后一题了
            _dataSourceArray = _multipleArray;
            _typeStr = @"1";
            
            if (_multipleArray.count) {
                _dataSourceArray = _multipleArray;
                _typeStr = @"2";
                _Number = -1;
                [self tableViewApper];
            } else if (_gapArray.count) {
                _dataSourceArray = _gapArray;
                _isTKStr = @"12";
                _typeStr = @"3";
                _Number = -1;
                [self TKViewApper];
                [self TKViewApperWithNext];
                
            } else if (_judgeArray.count) {
                _dataSourceArray = _judgeArray;
                _typeStr = @"4";
                _Number = -1;
                [self tableViewApper];
            } else if (_SubjectiveArray.count) {
                _dataSourceArray = _SubjectiveArray;
                _typeStr = @"5";
                _Number = -1;
                [self ZGViewApper];
                _WZLabel.text = @"主观";
                [self ZGViewApperWithNext];
                
            } else {
                [MBProgressHUD showError:@"已经是最后一题了" toView:self.view];
                return;
            }
            
            _Number = -1;
        }
        
    } else if (_dataSourceArray == _multipleArray) {//多选题
        if (_Number == _multipleArray.count - 1) {//说明是最后一题了
            
            if (_gapArray.count) {
                _dataSourceArray = _gapArray;
                _Number = -1;
                _typeStr = @"3";
                [self TKViewApper];
                [self TKViewApperWithNext];
                
            } else if (_judgeArray.count) {
                _dataSourceArray = _judgeArray;
                _Number = -1;
                _typeStr = @"4";
                [self tableViewApper];
            } else if (_SubjectiveArray.count) {
                _dataSourceArray = _SubjectiveArray;
                _Number = -1;
                _typeStr = @"5";
                [self ZGViewApper];
                [self ZGViewApperWithNext];
            } else {
                [MBProgressHUD showError:@"已经是最后一题了" toView:self.view];
                return;
            }
            _Number = -1;
        }
        
    } else if (_dataSourceArray == _gapArray) {//提空题
        if (_Number == _gapArray.count - 1) {//说明是最后一题了
            if (_judgeArray.count) {
                _dataSourceArray = _judgeArray;
                _Number = -1;
                _typeStr = @"4";
                [self tableViewApper];
                
            } else if (_SubjectiveArray.count) {
                _dataSourceArray = _SubjectiveArray;
                _Number = -1;
                _WZLabel.text = @"主观";
                _typeStr = @"5";
                [self ZGViewApper];
                [self ZGViewApperWithNext];
                
            } else {
                [MBProgressHUD showError:@"已经是最后一题了" toView:self.view];
                return;
            }
            
        } else {//此时还是填空题
            
            _typeStr = @"3";
            _WZLabel.text = @"填空";
            [self TKViewApperWithNext];
        }
        
    } else if (_dataSourceArray == _judgeArray) {//判断题
        
        if (_SubjectiveArray == nil) {
            if (_Number == _judgeArray.count - 1) {
                [MBProgressHUD showSuccess:@"已经是最后一题了" toView:self.view];
                return;
            } else {
                NSLog(@"------");
            }
            
        } else {
            
            if (_Number == _judgeArray.count - 1) {//说明是最后一道题
                
                _dataSourceArray = _SubjectiveArray;
                _Number = -1;
                [self ZGViewApper];
                _typeStr = @"5";
                _WZLabel.text = @"主观";
                [self ZGViewApperWithNext];
                //将主观题的视图以及资源显示出来
            } else {//继续判断题
                _typeStr = @"4";
                [self tableViewApper];
            }
            
        }
        
    } else if (_dataSourceArray == _SubjectiveArray) {
        if (_Number == _SubjectiveArray.count - 1) {
            
            [MBProgressHUD showSuccess:@"已经是最后一题了" toView:self.view];
            return;
        } else {//主观题
            
            _typeStr = @"5";
            _WZLabel.text = @"主观";
            [self ZGViewApperWithNext];
        }
    }
    
    
    _Number ++;
    
    [_tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//这个方法再次刷新 保证头部的空间跟自适应 一致
        [_tableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
    
}



- (void)TKViewApperFromCPBGView {
    
    NSLog(@"-----%ld ",_Number);
    
    NSString *TSting = nil;
    
    if (_dataSourceArray.count > _Number + 1 ) {
        TSting = _dataSourceArray[_Number][@"question_content"];
    }
    
    //填空题干文本
    NSString *titleStr = [self filterHTML:TSting];
    [self TKSetIntroductionText:titleStr];
    
    //将之前的移除掉
    _TKPhotoView.frame = CGRectMake(0, 0, 0, 0);
    [_TKPhotoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //填空题的题干图片视图
    _TKImageArray = (NSMutableArray *)[self filterHTMLImage:_dataSourceArray[_Number][@"question_content"]];
    if (_TKImageArray.count) {
        //计算出图片视图的大小
        if (_TKImageNum % _SecitionNum == 0) {
            _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTitleLabel.frame), MainScreenWidth, _TKImageViewH * (_TKImageNum / 2));
            _TKTopView.frame = CGRectMake(0, 0, MainScreenWidth, _TKTitleLabel.frame.size.height + _TKImageViewH * (_TKImageNum / 2 ) + 40);
        } else {
            _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTitleLabel.frame), MainScreenWidth, _TKImageViewH * (_TKImageNum / 2) + 1);
            _TKTopView.frame = CGRectMake(0, 0, MainScreenWidth, _TKTitleLabel.frame.size.height + _TKImageViewH * (_TKImageNum / 2 + 1) + 40);
        }
        
        for (int i = 0 ; i < _TKImageArray.count; i ++) {
            
            NSString *imageUrl = _TKImageArray[i];
            UIImageView *TKImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 * (i % _SecitionNum), _TKImageViewH * (i / _SecitionNum) , MainScreenWidth / 2, _TKImageViewH)];
            [TKImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Image(@"站位图")];
            [_TKPhotoView addSubview:TKImageView];
            TKImageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        
    } else {
        _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTitleLabel.frame), MainScreenWidth, 0);
        _TKTopView.frame = CGRectMake(0, 0, MainScreenWidth, _TKTitleLabel.frame.size.height + 20);
    }
    //输入框的位置以及大小
    //在移除之前 先添加答案
    
    //移除之前的输入框
    [_TKtextFieldView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _TKtextFieldView.frame = CGRectMake(0, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth, 500);
    
    
    if (_textFieldNumArray.count) {
        
        if (![_textFieldNumArray[_Number + 1] isEqualToString:@"0"]) {
            //最终视图的位置以及大小
            _TKtextFieldView.frame = CGRectMake(10,CGRectGetMaxY(_TKTopView.frame), MainScreenWidth - 20, [_textFieldNumArray[_Number] integerValue] * _TKTextSecitonH);
            
            NSLog(@" %@  %ld %ld",_TKAnswerArray,_TKAnswerArray.count,_Number);
            
            
            if (_TKAnswerArray.count > _Number) {
                NSString *answerStr = nil;
                NSLog(@"----%@",_TKAnswerArray);
                if (_TKAnswerArray.count > _Number + 1) {
                    answerStr = _TKAnswerArray[_Number];
                }
                
                NSArray *spArray = [answerStr componentsSeparatedByString:@","];
                NSLog(@"999----%@",spArray);
                
                for (int i = 0 ; i < [_textFieldNumArray[_Number] integerValue]; i ++) {
                    
                    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, i * _TKTextSecitonH, MainScreenWidth - 40, 40)];
                    textField.layer.cornerRadius = 5;
                    textField.layer.borderWidth = 1;
                    textField.layer.borderColor = PartitionColor.CGColor;
                    [_TKtextFieldView addSubview:textField];
                    textField.userInteractionEnabled = YES;
                    if (spArray.count > i) {
                        textField.text = spArray[i];
                    }
                }
            } else {
                //最终视图的位置以及大小
                _TKtextFieldView.frame = CGRectMake(10,CGRectGetMaxY(_TKTopView.frame), MainScreenWidth - 20, [_textFieldNumArray[_Number] integerValue] * _TKTextSecitonH);
                for (int i = 0 ; i < [_textFieldNumArray[_Number] integerValue]; i ++) {
                    
                    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, i * _TKTextSecitonH, MainScreenWidth - 40, 40)];
                    textField.layer.cornerRadius = 5;
                    textField.layer.borderWidth = 1;
                    textField.layer.borderColor = PartitionColor.CGColor;
                    [_TKtextFieldView addSubview:textField];
                    textField.userInteractionEnabled = YES;
                }
            }
        }
    }
    
    
    //添加解析视图
    
    
    if ([_TKRightAnswer[_Number] isEqualToString:_myTKAnswerArray[_Number]]) {
        [_TKFalseButton setTitle:@" 答对了" forState:UIControlStateNormal];
        [_TKFalseButton setImage:Image(@"考试系统开心@2x") forState:UIControlStateNormal];
    } else {
        [_TKFalseButton setTitle:@" 答错了" forState:UIControlStateNormal];
        [_TKFalseButton setImage:Image(@"考试系统难过@2x") forState:UIControlStateNormal];
    }
    
    _TKJXView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSString *CDKAStr = [NSString stringWithFormat:@"正确答案：%@",_dataSourceArray[_Number][@"question_answer"]];
    [self TKJXAnswerIntroductionText:CDKAStr];
    
    
    NSString *JXStr = [NSString stringWithFormat:@"答案解析：%@",_dataSourceArray[_Number][@"question_qsn_guide"]];
    [self TKJXTitleIntroductionText:JXStr];
    
    //让试图滚回顶部
    [_TKView setContentOffset:CGPointMake(0,0) animated:NO];

    
}


- (void)ZGViewApperFormCPBGView {
    
    
    NSString *title = nil;
    title = [self filterHTML:_dataSourceArray[_Number][@"question_content"]];
    _ZGTitleLabel.font = Font(18);
    [self ZGSetIntroductionText:title];
    
    //移除之前的图
    [_TKPhotoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //计算图片视图的大小
    _ZGImageArray =(NSMutableArray *)[self filterHTMLImage:_dataSourceArray[_Number][@"question_content"]];
    _ZGImageNum = _ZGImageArray.count;
    _ZGImageViewH = 80;
    _SecitionNum = 2;
    
    if (_ZGImageArray.count) {
        //计算出图片视图的大小
        if (_ZGImageNum % _SecitionNum == 0) {
            _ZGImageView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTitleLabel.frame) + SpaceBaside, MainScreenWidth, _ZGImageViewH * (_ZGImageNum / _SecitionNum));
            _ZGTopView.frame = CGRectMake(0, 0, MainScreenWidth, _ZGTitleLabel.frame.size.height + _ZGImageViewH * (_ZGImageNum / _SecitionNum ) + 40);
        } else {
            _ZGImageView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTitleLabel.frame) + SpaceBaside, MainScreenWidth, _ZGImageViewH * (_ZGImageNum / _SecitionNum) + 1);
            _ZGTopView.frame = CGRectMake(0, 0, MainScreenWidth, _ZGTitleLabel.frame.size.height + _ZGImageViewH * (_ZGImageNum / _SecitionNum + 1) + 40);
        }
        
        for (int i = 0 ; i < _ZGImageArray.count; i ++) {
            
            NSString *imageUrl = _ZGImageArray[i];
            UIImageView *ZGImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 * (i % _SecitionNum), _ZGImageViewH * (i / _SecitionNum) , MainScreenWidth / 2, _ZGImageViewH)];
            [ZGImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Image(@"站位图")];
            [_ZGImageView addSubview:ZGImageView];
            ZGImageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        
    } else {
        _ZGImageView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTitleLabel.frame), MainScreenWidth, 0);
        _ZGTopView.frame = CGRectMake(0, 0, MainScreenWidth, _ZGTitleLabel.frame.size.height + 20);
    }
    
    
    NSLog(@"----%@",_ZGAnswerArray);
    _ZGTextStr = _textView.text;
    //输入框以及上传图片的视图
    if (_ZGAnswerArray.count && _ZGAnswerArray[_Number] != nil ) {
        _textView.text = _ZGAnswerArray[_Number];
    } else {
        _textView.text = @"";
    }
    
    //添加叙述view
    _ZGXSView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTopView.frame), MainScreenWidth, 500);
    if (_textView.text.length > 0) {
        _ZGTXLabel.hidden = YES;
    } else {
        _ZGTXLabel.hidden = NO;
    }
    
    
    NSLog(@"%@",_ZGAnswerArray);
    NSLog(@"%@",_ZGUpImageArray);
    NSLog(@"%@",_ZGUpImageArray);
    NSLog(@"%ld",_Number);
    //添加展示图片的View
    _photosView.frame = CGRectMake(0, CGRectGetMaxY(_textView.frame) + SpaceBaside, MainScreenWidth, 230);
    //移除之前的图
    [_photosView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSLog(@"%@",_ZGUpImageArray[_Number]);
    if (_ZGUpImageArray[_Number] != nil) {//说明有图片
        NSArray *imageArray = _ZGUpImageArray[_Number];
        for (int i = 0; i < imageArray.count ; i ++) {
            UIImage *image = imageArray[i];
            [_photosView addImage:image];
        }
    }
    
    //解析界面
    NSString *ZGJXStr = [NSString stringWithFormat:@"参考答案：%@",_dataSourceArray[_Number][@"question_qsn_guide"]];
    [self ZGJXIntroductionText:ZGJXStr];
    
}



#pragma mark --- 上一题
- (void)TKViewApperWithUp {
    
    NSString *TSting = nil;
    
    if (_dataSourceArray.count > _Number - 1 ) {
        TSting = _dataSourceArray[_Number - 1][@"question_content"];
    }
    
    //填空题干文本
    NSString *titleStr = [self filterHTML:TSting];
    [self TKSetIntroductionText:titleStr];
    
    //将之前的移除掉
    _TKPhotoView.frame = CGRectMake(0, 0, 0, 0);
    [_TKPhotoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //填空题的题干图片视图
    _TKImageArray = (NSMutableArray *)[self filterHTMLImage:_dataSourceArray[_Number - 1][@"question_content"]];
    if (_TKImageArray.count) {
        //计算出图片视图的大小
        if (_TKImageNum % _SecitionNum == 0) {
            _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTitleLabel.frame), MainScreenWidth, _TKImageViewH * (_TKImageNum / 2));
            _TKTopView.frame = CGRectMake(0, 0, MainScreenWidth, _TKTitleLabel.frame.size.height + _TKImageViewH * (_TKImageNum / 2 ) + 40);
        } else {
            _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTitleLabel.frame), MainScreenWidth, _TKImageViewH * (_TKImageNum / 2) + 1);
            _TKTopView.frame = CGRectMake(0, 0, MainScreenWidth, _TKTitleLabel.frame.size.height + _TKImageViewH * (_TKImageNum / 2 + 1) + 40);
        }
        
        for (int i = 0 ; i < _TKImageArray.count; i ++) {
            
            NSString *imageUrl = _TKImageArray[i];
            UIImageView *TKImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 * (i % _SecitionNum), _TKImageViewH * (i / _SecitionNum) , MainScreenWidth / 2, _TKImageViewH)];
            [TKImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Image(@"站位图")];
            [_TKPhotoView addSubview:TKImageView];
            TKImageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        
    } else {
        _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTitleLabel.frame), MainScreenWidth, 0);
        _TKTopView.frame = CGRectMake(0, 0, MainScreenWidth, _TKTitleLabel.frame.size.height + 20);
    }
    //输入框的位置以及大小
    [_TKtextFieldView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _TKtextFieldView.frame = CGRectMake(0, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth, 500);
    
    
    if (_textFieldNumArray.count) {
        
        NSLog(@"%ld",_textFieldNumArray.count);
        if (![_textFieldNumArray[_Number - 1] isEqualToString:@"0"]) {
            
            //最终视图的位置以及大小
            _TKtextFieldView.frame = CGRectMake(10,CGRectGetMaxY(_TKTopView.frame), MainScreenWidth - 20, [_textFieldNumArray[_Number - 1] integerValue] * _TKTextSecitonH);
            
            for (int i = 0 ; i < [_textFieldNumArray[_Number - 1] integerValue]; i ++) {
                
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, i * _TKTextSecitonH, MainScreenWidth - 40, 40)];
                textField.layer.cornerRadius = 5;
                textField.layer.borderWidth = 1;
                textField.layer.borderColor = PartitionColor.CGColor;
                [_TKtextFieldView addSubview:textField];
                textField.userInteractionEnabled = YES;
                
            }
        }
        
    }
    
    //解析界面
    if ([_TKRightAnswer[_Number - 1] isEqualToString:_myTKAnswerArray[_Number - 1]]) {
        [_TKFalseButton setTitle:@" 答对了" forState:UIControlStateNormal];
        [_TKFalseButton setImage:Image(@"考试系统开心@2x") forState:UIControlStateNormal];
    } else {
        [_TKFalseButton setTitle:@" 答错了" forState:UIControlStateNormal];
        [_TKFalseButton setImage:Image(@"考试系统难过@2x") forState:UIControlStateNormal];
    }
    
    _TKJXView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSString *CDKAStr = [NSString stringWithFormat:@"正确答案：%@",_dataSourceArray[_Number - 1][@"question_answer"]];
    [self TKJXAnswerIntroductionText:CDKAStr];
    
    
    NSString *JXStr = [NSString stringWithFormat:@"答案解析：%@",_dataSourceArray[_Number - 1][@"question_qsn_guide"]];
    [self TKJXTitleIntroductionText:JXStr];
    
    //让试图滚回顶部
    [_TKView setContentOffset:CGPointMake(0,0) animated:NO];
    
}

- (void)ZGViewApperWithUp {
    
    NSString *title = nil;
    title = [self filterHTML:_dataSourceArray[_Number - 1][@"question_content"]];
    _ZGTitleLabel.font = Font(18);
    [self ZGSetIntroductionText:title];
    
    //移除之前的图
    [_TKPhotoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //计算图片视图的大小
    _ZGImageArray =(NSMutableArray *)[self filterHTMLImage:_dataSourceArray[_Number - 1][@"question_content"]];
    
    _ZGImageNum = _ZGImageArray.count;
    _ZGImageViewH = 80;
    _SecitionNum = 2;
    
    if (_ZGImageArray.count) {
        //计算出图片视图的大小
        if (_ZGImageNum % _SecitionNum == 0) {
            _ZGImageView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTitleLabel.frame) + SpaceBaside, MainScreenWidth, _ZGImageViewH * (_ZGImageNum / _SecitionNum));
            _ZGTopView.frame = CGRectMake(0, 0, MainScreenWidth, _ZGTitleLabel.frame.size.height + _ZGImageViewH * (_ZGImageNum / _SecitionNum ) + 40);
        } else {
            _ZGImageView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTitleLabel.frame) + SpaceBaside, MainScreenWidth, _ZGImageViewH * (_ZGImageNum / _SecitionNum) + 1);
            _ZGTopView.frame = CGRectMake(0, 0, MainScreenWidth, _ZGTitleLabel.frame.size.height + _ZGImageViewH * (_ZGImageNum / _SecitionNum + 1) + 40);
        }
        
        for (int i = 0 ; i < _ZGImageArray.count; i ++) {
            
            NSString *imageUrl = _ZGImageArray[i];
            UIImageView *ZGImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 * (i % _SecitionNum), _ZGImageViewH * (i / _SecitionNum) , MainScreenWidth / 2, _ZGImageViewH)];
            [ZGImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Image(@"站位图")];
            [_ZGImageView addSubview:ZGImageView];
            ZGImageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        
    } else {
        _ZGImageView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTitleLabel.frame), MainScreenWidth, 0);
        _ZGTopView.frame = CGRectMake(0, 0, MainScreenWidth, _ZGTitleLabel.frame.size.height + 20);
    }
    
    //输入框以及上传图片的视图
    
    //添加叙述view
    _ZGXSView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTopView.frame), MainScreenWidth, 500);
    
    //添加展示图片的View
    _photosView.frame = CGRectMake(0, CGRectGetMaxY(_textView.frame) + SpaceBaside, MainScreenWidth, 230);
    
    if (_ZGUpImageArray.count && _ZGUpImageArray.count > _Number) {//有图片
        
    } else {
        _photosView.frame = CGRectMake(0, CGRectGetMaxY(_textView.frame) + SpaceBaside, MainScreenWidth, 10);
        _ZGXSView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTopView.frame), MainScreenWidth, 130);
    }

    [_ZGView setContentOffset:CGPointMake(0,0) animated:NO];
}

#pragma mark --- 下一题
- (void)TKViewApperWithNext{
    
    NSString *TSting = nil;
    
    if (_dataSourceArray.count > _Number + 1 ) {
        TSting = _dataSourceArray[_Number + 1][@"question_content"];
    }
    
    //填空题干文本
    NSString *titleStr = [self filterHTML:TSting];
    [self TKSetIntroductionText:titleStr];
    
    //将之前的移除掉
    _TKPhotoView.frame = CGRectMake(0, 0, 0, 0);
    [_TKPhotoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //填空题的题干图片视图
    _TKImageArray = (NSMutableArray *)[self filterHTMLImage:_dataSourceArray[_Number + 1][@"question_content"]];
    if (_TKImageArray.count) {
        //计算出图片视图的大小
        if (_TKImageNum % _SecitionNum == 0) {
            _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTitleLabel.frame), MainScreenWidth, _TKImageViewH * (_TKImageNum / 2));
            _TKTopView.frame = CGRectMake(0, 0, MainScreenWidth, _TKTitleLabel.frame.size.height + _TKImageViewH * (_TKImageNum / 2 ) + 40);
        } else {
            _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTitleLabel.frame), MainScreenWidth, _TKImageViewH * (_TKImageNum / 2) + 1);
            _TKTopView.frame = CGRectMake(0, 0, MainScreenWidth, _TKTitleLabel.frame.size.height + _TKImageViewH * (_TKImageNum / 2 + 1) + 40);
        }
        
        for (int i = 0 ; i < _TKImageArray.count; i ++) {
            
            NSString *imageUrl = _TKImageArray[i];
            UIImageView *TKImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 * (i % _SecitionNum), _TKImageViewH * (i / _SecitionNum) , MainScreenWidth / 2, _TKImageViewH)];
            [TKImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Image(@"站位图")];
            [_TKPhotoView addSubview:TKImageView];
            TKImageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        
    } else {
        _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTitleLabel.frame), MainScreenWidth, 0);
        _TKTopView.frame = CGRectMake(0, 0, MainScreenWidth, _TKTitleLabel.frame.size.height + 20);
    }
    //输入框的位置以及大小
    //在移除之前 先添加答案
    if (_Number == -1) {
        
    } else {
    }
    
    //移除之前的输入框
    [_TKtextFieldView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _TKtextFieldView.frame = CGRectMake(0, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth, 500);
    
    
    if (_textFieldNumArray.count) {
        
        if (![_textFieldNumArray[_Number + 1] isEqualToString:@"0"]) {
            //最终视图的位置以及大小
            _TKtextFieldView.frame = CGRectMake(10,CGRectGetMaxY(_TKTopView.frame), MainScreenWidth - 20, [_textFieldNumArray[_Number + 1] integerValue] * _TKTextSecitonH);
            
            NSLog(@" %@  %ld %ld",_TKAnswerArray,_TKAnswerArray.count,_Number);
            
            
            if (_userTKAnswer.count > _Number + 1) {
                NSString *answerStr = nil;
                NSLog(@"----%@",_userTKAnswer);
                if (_userTKAnswer.count > _Number + 1) {
                    answerStr = _userTKAnswer[_Number + 1];
                }
                
                NSArray *spArray = [answerStr componentsSeparatedByString:@","];
                NSLog(@"999----%@",spArray);
                
                for (int i = 0 ; i < [_textFieldNumArray[_Number + 1] integerValue]; i ++) {
                    
                    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, i * _TKTextSecitonH, MainScreenWidth - 40, 40)];
                    textField.layer.cornerRadius = 5;
                    textField.layer.borderWidth = 1;
                    textField.layer.borderColor = PartitionColor.CGColor;
                    [_TKtextFieldView addSubview:textField];
                    textField.userInteractionEnabled = YES;
                    if (spArray.count > i) {
                        textField.text = spArray[i];
                    }
                }
            } else {
                //最终视图的位置以及大小
                _TKtextFieldView.frame = CGRectMake(10,CGRectGetMaxY(_TKTopView.frame), MainScreenWidth - 20, [_textFieldNumArray[_Number + 1] integerValue] * _TKTextSecitonH);
                for (int i = 0 ; i < [_textFieldNumArray[_Number + 1] integerValue]; i ++) {
                    
                    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, i * _TKTextSecitonH, MainScreenWidth - 40, 40)];
                    textField.layer.cornerRadius = 5;
                    textField.layer.borderWidth = 1;
                    textField.layer.borderColor = PartitionColor.CGColor;
                    [_TKtextFieldView addSubview:textField];
                    textField.userInteractionEnabled = YES;
                }
            }
        }
    }
    
    
    //添加解析视图
    
    
    if ([_TKRightAnswer[_Number + 1] isEqualToString:_myTKAnswerArray[_Number + 1]]) {
        [_TKFalseButton setTitle:@" 答对了" forState:UIControlStateNormal];
        [_TKFalseButton setImage:Image(@"考试系统开心@2x") forState:UIControlStateNormal];
    } else {
        [_TKFalseButton setTitle:@" 答错了" forState:UIControlStateNormal];
        [_TKFalseButton setImage:Image(@"考试系统难过@2x") forState:UIControlStateNormal];
    }
    
    _TKJXView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSString *CDKAStr = [NSString stringWithFormat:@"正确答案：%@",_dataSourceArray[_Number + 1][@"question_answer"]];
    [self TKJXAnswerIntroductionText:CDKAStr];
    
    
    NSString *JXStr = [NSString stringWithFormat:@"答案解析：%@",_dataSourceArray[_Number + 1][@"question_qsn_guide"]];
    [self TKJXTitleIntroductionText:JXStr];
    
    //让试图滚回顶部
    [_TKView setContentOffset:CGPointMake(0,0) animated:NO];
}

- (void)ZGViewApperWithNext {
    
    
    NSString *title = nil;
    
    title = [self filterHTML:_dataSourceArray[_Number + 1][@"question_content"]];
    _ZGTitleLabel.font = Font(18);
    [self ZGSetIntroductionText:title];
    
    //移除之前的图
    [_TKPhotoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //计算图片视图的大小
    _ZGImageArray =(NSMutableArray *)[self filterHTMLImage:_dataSourceArray[_Number + 1][@"question_content"]];
    
    _ZGImageNum = _ZGImageArray.count;
    _ZGImageViewH = 80;
    _SecitionNum = 2;
    
    if (_ZGImageArray.count) {
        //计算出图片视图的大小
        if (_ZGImageNum % _SecitionNum == 0) {
            _ZGImageView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTitleLabel.frame) + SpaceBaside, MainScreenWidth, _ZGImageViewH * (_ZGImageNum / _SecitionNum));
            _ZGTopView.frame = CGRectMake(0, 0, MainScreenWidth, _ZGTitleLabel.frame.size.height + _ZGImageViewH * (_ZGImageNum / _SecitionNum ) + 40);
        } else {
            _ZGImageView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTitleLabel.frame) + SpaceBaside, MainScreenWidth, _ZGImageViewH * (_ZGImageNum / _SecitionNum) + 1);
            _ZGTopView.frame = CGRectMake(0, 0, MainScreenWidth, _ZGTitleLabel.frame.size.height + _ZGImageViewH * (_ZGImageNum / _SecitionNum + 1) + 40);
        }
        
        for (int i = 0 ; i < _ZGImageArray.count; i ++) {
            
            NSString *imageUrl = _ZGImageArray[i];
            UIImageView *ZGImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 * (i % _SecitionNum), _ZGImageViewH * (i / _SecitionNum) , MainScreenWidth / 2, _ZGImageViewH)];
            [ZGImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Image(@"站位图")];
            [_ZGImageView addSubview:ZGImageView];
            ZGImageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        
    } else {
        _ZGImageView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTitleLabel.frame), MainScreenWidth, 0);
        _ZGTopView.frame = CGRectMake(0, 0, MainScreenWidth, _ZGTitleLabel.frame.size.height + 20);
    }
    
    
    NSLog(@"----%@",_ZGAnswerArray);
    _ZGTextStr = _textView.text;
    //输入框以及上传图片的视图
    if (_myZGAnswerArray.count && _myZGAnswerArray[_Number + 1] != nil ) {
        _textView.text = _myZGAnswerArray[_Number + 1];
    } else {
        _textView.text = @"";
    }
    
    //添加叙述view
    _ZGXSView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTopView.frame), MainScreenWidth, 500);
    if (_textView.text.length > 0) {
        _ZGTXLabel.hidden = YES;
    } else {
        _ZGTXLabel.hidden = NO;
    }
    
    
    NSLog(@"%@",_ZGAnswerArray);
    NSLog(@"%@",_ZGUpImageArray);
    NSLog(@"%@",_ZGUpImageArray);
    NSLog(@"%ld",_Number);
    //添加展示图片的View
    _photosView.frame = CGRectMake(0, CGRectGetMaxY(_textView.frame) + SpaceBaside, MainScreenWidth, 230);
    //移除之前的图
    [_photosView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSLog(@"%@",_ZGUpImageArray[_Number + 1]);
    if (_ZGUpImageArray[_Number + 1] != nil) {//说明有图片
        NSArray *imageArray = _ZGUpImageArray[_Number + 1];
        for (int i = 0; i < imageArray.count ; i ++) {
            UIImage *image = imageArray[i];
            [_photosView addImage:image];
        }
    } else {
        _photosView.frame = CGRectMake(0, CGRectGetMaxY(_textView.frame) + SpaceBaside, MainScreenWidth, 10);
        _ZGXSView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTopView.frame), MainScreenWidth, 130);
    }
    
    //解析界面
    NSString *ZGJXStr = [NSString stringWithFormat:@"参考答案：%@",_dataSourceArray[_Number + 1][@"question_qsn_guide"]];
    [self ZGJXIntroductionText:ZGJXStr];
    
    [_ZGView setContentOffset:CGPointMake(0,0) animated:NO];
}



#pragma mark --- 提取资源

//去掉HTML字符
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO) {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    }
    return html;
}


- (void)whereAddImage:(NSArray *)imageArray {
    
    CGFloat Space = 10;
    NSInteger Num = 3;
    CGFloat imageW = (MainScreenWidth - (Num + 1) * Space) / Num;
    CGFloat imageH = imageW;
    
    
    NSInteger allNum = imageArray.count;
    NSLog(@"-----%ld",allNum);
    _TJImageButton.frame = CGRectMake(Space + Space * (allNum % Num) + imageW * (allNum % Num), (imageH + Space) * (allNum / Num) + 130, imageW, imageH);
    if (allNum == 1) {//当只有一个的时候
        //添加图片的按钮应该和图片一样大
        _TJImageButton.frame = CGRectMake(150 + Space * 2, 130, 150, 150);
        
    }
    
}

#pragma mark --- 提取字段里面的图片地址

//获取webView中的所有图片URL
- (NSArray *)filterHTMLImage:(NSString *) webString {
    NSMutableArray * imageurlArray = [NSMutableArray arrayWithCapacity:1];
    //标签匹配
    NSString *parten = @"<img (.*?)>";
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:0 error:&error];
    NSLog(@"%@",reg);
    NSLog(@"%@",webString);
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
        NSLog(@"%@",imagekUrl);
        NSString *imageUrl2 = [imagekUrl substringFromIndex:2];
        NSLog(@"----%@",imageUrl2);
        //拼接图片地址
        NSString *result = [NSString stringWithFormat:@"%s/%@",BasidUrl,imageUrl2];
        
        //将提取出的图片URL添加到图片数组中
        [imageurlArray addObject:result];
    }
    NSLog(@"%@",imageurlArray);
    return imageurlArray;
}







@end
