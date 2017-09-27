//
//  RecordViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/6/21.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import "RecordViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "MBProgressHUD+Add.h"
#import "XZTTableViewCell.h"
#import "PhotosView.h"
#import "UIImageView+WebCache.h"

@interface RecordViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL flag;
    UIImage  *image;
}


@property (strong ,nonatomic)UIButton *XXButton;//箭头的按钮

@property (strong ,nonatomic)UIView *allView;

@property (strong ,nonatomic)UIButton *allButton;

@property (strong ,nonatomic)UIView *buyView;

@property (strong ,nonatomic)NSArray *SYGArray;//存放分类的数组

@property (strong ,nonatomic)NSMutableArray *titleNameArray;//存放分类名字的数组

@property (strong ,nonatomic)NSMutableArray *titleIdArray;//分类的id 数组

@property (strong, nonatomic) NSTimer *timer;

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

@property (strong ,nonatomic)UIView *TKTopView;//填空的顶部试图

@property (strong ,nonatomic)UILabel *TKTitleLabel;//填空试图上面的题目

@property (strong ,nonatomic)UIView *TKPhotoView;//填空题的图片
@property (strong ,nonatomic)UIImageView *TKImageView;//填空题的图片视图
@property (strong ,nonatomic)NSMutableArray *TKImageArray;//填空题的存放图片数组

@property (strong ,nonatomic)UITextField *TKTextField;//填空题的输入框

@property (strong ,nonatomic)UIButton *TJButton;//填空题的提交按钮

@property (strong ,nonatomic)UIButton *TKFalseButton;//填空题的错误正确按钮

@property (strong ,nonatomic)UIView *TKJXView;//填空题的解析界面

@property (strong ,nonatomic)UILabel *CKDALabel;//参考答案文本

@property (strong ,nonatomic)UILabel *TKJXLabel;//填空题的解析文本

@property (strong ,nonatomic)UIView *ZGView;//主观视图

@property (strong ,nonatomic)UIView *ZGTopView;//主观的顶部试图

@property (strong ,nonatomic)UILabel *ZGTitleLabel;//主观题的题目

@property (strong ,nonatomic)UITextView *textView;//主观视图的输入文本

@property (strong ,nonatomic)UILabel *ZGTXLabel;//主观提醒文本

@property (strong ,nonatomic)UIView *ZGXSView;//主观题的试图

@property (strong ,nonatomic)UIScrollView *ZGScrollView;//主观题的滚动试图

@property (strong ,nonatomic)PhotosView *photosView;//主观题 添加图片的View

@property (strong ,nonatomic)UIImageView *contentImageView;//题干里面的图片
@property (strong ,nonatomic)UIImageView *ZGImageView;


@property (strong ,nonatomic)UIButton *TJImageButton;//主观题 界面上添加按钮的图片

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


@property (strong ,nonatomic)NSMutableArray *imageUrlArray;
@property (strong ,nonatomic)NSString *imageUrl;


@end

@implementation RecordViewController


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
    [self interFace];
    [self addNav];
    [self addDownView];
    [self addXZView];
    [self getRigthAnswer];
    
    [self addTableView];
    [self addTKView];
    [self addPDView];
    [self addZGView];

    [self firstView];
    
}

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

//显示表格试图出来
- (void)tableViewApper {
    _tableView.hidden = NO;
    _TKView.hidden = YES;
    _ZGView.hidden = YES;
}

//显示填空试图出来
- (void)TKViewApper {
    _tableView.hidden = YES;
    _TKView.hidden = NO;
    _ZGView.hidden = YES;
    
    _Number = 0;
    
    NSString *TSting = _dataSourceArray[_Number][@"question_content"];
    
    NSString *titleStr = [self filterHTML:TSting];
    [self TKSetIntroductionText:titleStr];
    
    _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth, 80);
    
    _TKImageArray = nil;
    _TKImageArray = [self filterHTMLImage:TSting];
    NSLog(@"----%@",_TKImageArray);
    //    if (_TKImageArray.count) {
    //        [_TKImageView sd_setImageWithURL:[NSURL URLWithString:_TKImageArray[0]]];
    //    } else {
    //        _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth, 0);
    //        [_TKImageView sd_setImageWithURL:[NSURL URLWithString:@""]];
    //    }
    
    if (_TKImageArray.count) {
        //将之前的试图移除
        [_TKPhotoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        for (int i = 0 ; i < _TKImageArray.count; i ++) {
            UIImageView *TKImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90 * i, MainScreenWidth, 80)];
            TKImageView.contentMode = UIViewContentModeScaleAspectFit;
            [TKImageView sd_setImageWithURL:[NSURL URLWithString:_TKImageArray[i]]];
            [_TKPhotoView addSubview:TKImageView];
            _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth, 90 * _TKImageArray.count);
        }
    } else {
        [_TKPhotoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth, 0);
    }
    
    
    
    
    
    _TKTextField.frame = CGRectMake(0, CGRectGetMaxY(_TKPhotoView.frame), MainScreenHeight, 50);
    _TKJXView.frame = CGRectMake(0, CGRectGetMaxY(_TKTextField.frame), MainScreenWidth, CGRectGetHeight(_TKJXLabel.frame));
    
    [_tableView reloadData];//使顶部的题目的类型显示正确

}

//显示主题试图出来
- (void)ZGViewApper {
    _tableView.hidden = YES;
    _TKView.hidden = YES;
    _ZGView.hidden = NO;
    _WZLabel.text = @"主观";
    
}



- (void)interFace {
    
//    NSLog(@"%ld",(long)_allTime);
    NSLog(@"dataSource-------%@",_dataSource);
//    NSLog(@"%@",_myDXAnswerArray);
    
    self.view.backgroundColor = [UIColor whiteColor];
    flag = YES;
    _typeStr = @"1";//改默认为单选题
    _headH = 80;//头部返回初始高度
    
    _footH = 100;
    
    _Number = 0;
    
    _titleNameArray = [NSMutableArray array];
    _titleIdArray = [NSMutableArray array];
    _imageUrlArray = [NSMutableArray array];
    _TKImageArray = [NSMutableArray array];
    
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
    
    
    
    _dataSourceArray = _singleArray;//默认为单选题开始
    
    if (_singleArray.count) {
        _dataSourceArray = _singleArray;
        [self tableViewApper];
    } else if (_multipleArray.count) {
        _dataSourceArray = _multipleArray;
        [self tableViewApper];
    } else if (_gapArray.count) {
        _dataSourceArray = _gapArray;
        [self TKViewApper];
    } else if (_judgeArray.count) {
        _dataSourceArray = _judgeArray;
        [self tableViewApper];
    } else if (_SubjectiveArray.count) {
        _dataSourceArray = _SubjectiveArray;
        [self ZGViewApper];
    }

    
    
    
    NSLog(@"%@",_dataSourceArray);
    
    _SYGArray = _dataSource[@"data"][@"question_type"];
    
    
    _timePastting = 0;
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timePast) userInfo:nil repeats:YES];
    
    //选中的按钮
    _XZArray = [NSMutableArray array];
    for (int i = 0 ; i < 9 ; i ++) {
        [_XZArray addObject:@"0"];
        
    }
    NSLog(@"-----%@",_XZArray);
    
    _AnswerArray = [NSMutableArray array];//初始化存放答案的数组
    _DXAnswerArray = [NSMutableArray array];
    _DDXAnswerArray = [NSMutableArray array];
    _TKAnswerArray = [NSMutableArray array];
    _PDAnswerArray = [NSMutableArray array];
    _ZGAnswerArray = [NSMutableArray array];
    
    _userDXAnswer = [NSMutableArray array];
    _userDDXAnswer = [NSMutableArray array];
    _userTKAnswer = [NSMutableArray array];
    _userPDAnswer = [NSMutableArray array];
    _userZGAnswer = [NSMutableArray array];
    _userImageArray = [NSMutableArray array];
    
    //创建存放图片id的数组
    _imageIDArray = [NSMutableArray array];
    //    _imageArray = [NSMutableArray array];
    _SubjectiveImageArray = [NSMutableArray array];
    
}

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
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 20, 25, 40, 30)];
    WZLabel.text = @"单选";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:18];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    _WZLabel = WZLabel;
    
    //添加旁边向下的按钮
    UIButton *XXButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 + 24, 35, 15, 10)];
    [XXButton setBackgroundImage:Image(@"考试箭头@2x") forState:UIControlStateNormal];
    [SYGView addSubview:XXButton];
    _XXButton = XXButton;
    
    //添加按钮
    UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 25, MainScreenWidth - 240, 30)];
    titleButton.backgroundColor = [UIColor clearColor];
    [titleButton addTarget:self action:@selector(titleButton) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:titleButton];
    
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
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
    
//    //剩余文本
//    UILabel *SYLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 60, 19, 80, 20)];
//    SYLabel.text = @"剩余时长：";
//    SYLabel.font = Font(15);
//    SYLabel.textColor = XXColor;
//    SYLabel.textAlignment = NSTextAlignmentRight;
//    [downView addSubview:SYLabel];
    
    //时间文本
    UILabel *TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 + 20, 19, 80, 20)];
    TimeLabel.font = Font(15);
    TimeLabel.textColor = XXColor;
    [downView addSubview:TimeLabel];
    _TimeLabel = TimeLabel;
    
}

- (void)upButton {
    
    if (_dataSourceArray == _singleArray) {//说明是单选题
        
        if (_Number == 0) {//说明是最第一题了
            [MBProgressHUD showSuccess:@"已经是第一题了" toView:self.view];
            return;
        }
        
    } else if (_dataSourceArray == _multipleArray) {//多选时
        
        if (_Number == 0) {//说明是多选题的第一题
            
            if (_singleArray.count) {
                _dataSourceArray = _singleArray;
                _Number = _singleArray.count;
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
                [self tableViewApper];
            } else if (_singleArray.count) {
                _dataSourceArray = _singleArray;
                _Number = _singleArray.count;
                [self tableViewApper];
            } else {
                [MBProgressHUD showError:@"已经是第一题了" toView:self.view];
                return;
            }
            
        } else {
            
            NSString *TSting = nil;
            if (_dataSourceArray.count > _Number - 1) {
                TSting = _dataSourceArray[_Number - 1][@"question_content"];
            }
            NSString *titleStr = [self filterHTML:TSting];
            [self TKSetIntroductionText:titleStr];
            
            _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth, 80);
            
            _TKImageArray = nil;
            _TKImageArray = [self filterHTMLImage:TSting];
            NSLog(@"----%@",_TKImageArray);
            
            if (_TKImageArray.count) {
                //将之前的试图移除
                [_TKPhotoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                for (int i = 0 ; i < _TKImageArray.count; i ++) {
                    UIImageView *TKImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90 * i, MainScreenWidth, 80)];
                    TKImageView.contentMode = UIViewContentModeScaleAspectFit;
                    [TKImageView sd_setImageWithURL:[NSURL URLWithString:_TKImageArray[i]]];
                    [_TKPhotoView addSubview:TKImageView];
                    _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth, 90 * _TKImageArray.count);
                }
            } else {
                [_TKPhotoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth, 0);
            }


            
            //设置输入框的位置和提交按钮的位置
            _TKTextField.frame = CGRectMake(15, CGRectGetMaxY(_TKPhotoView.frame), MainScreenWidth - 80, 30);


            if (_userTKAnswer.count > _Number - 1) {
                 _TKTextField.text = _userTKAnswer[_Number - 1];
            }
            _TJButton.frame = CGRectMake(MainScreenWidth - 60, CGRectGetMaxY(_TKPhotoView.frame), 50, 30);
            if (_TKRightAnswer.count > _Number - 1) {
                _CKDALabel.text = [NSString stringWithFormat:@"参考答案：%@",_TKRightAnswer[_Number - 1]];
            }
            
            
            if (_TKRightAnswer.count > _Number - 1 && _userTKAnswer.count > _Number - 1) {
                if ([_TKRightAnswer[_Number - 1] isEqualToString:_userTKAnswer[_Number - 1]]) {
                    [_TKFalseButton setTitle:@" 答对了" forState:UIControlStateNormal];
                    [_TKFalseButton setImage:Image(@"考试系统开心@2x") forState:UIControlStateNormal];
                } else {
                    [_TKFalseButton setTitle:@" 答错了" forState:UIControlStateNormal];
                    [_TKFalseButton setImage:Image(@"考试系统难过@2x") forState:UIControlStateNormal];
                }
            }
            
            NSString *JXString = nil;
            if (_dataSourceArray.count > _Number - 1) {
                JXString = [NSString stringWithFormat:@"题目解析：%@",_dataSourceArray[_Number - 1][@"question_qsn_guide"]];
            }
            
            [self TKJXTitleIntroductionText:JXString];
            
            _TKJXView.frame = CGRectMake(0, CGRectGetMaxY(_TJButton.frame) + 30, MainScreenWidth, CGRectGetHeight(_TKJXLabel.frame));
            
            //视图的位置
            _TKView.contentOffset = CGPointMake(0, 0);

        }
        
    } else if (_dataSourceArray == _judgeArray) {//判断题
        
        if (_Number == 0) {
            
            if (_gapArray.count) {
                _dataSourceArray = _gapArray;
                _Number = _gapArray.count;
                
                //现在是填空题，显示填空题的试图
                _tableView.hidden = YES;
                _TKView.hidden = NO;
                _ZGView.hidden = YES;
                
                
                NSString *TSting = _dataSourceArray[_Number - 1][@"question_content"];
                NSString *titleStr = [self filterHTML:TSting];
                [self TKSetIntroductionText:titleStr];
                

                _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth, 80);
                _TKImageArray = nil;
                _TKImageArray = [self filterHTMLImage:TSting];
                NSLog(@"----%@",_TKImageArray);
                
                if (_TKImageArray.count) {
                    //将之前的试图移除
                    [_TKPhotoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    for (int i = 0 ; i < _TKImageArray.count; i ++) {
                        UIImageView *TKImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90 * i, MainScreenWidth, 80)];
                        TKImageView.contentMode = UIViewContentModeScaleAspectFit;
                        [TKImageView sd_setImageWithURL:[NSURL URLWithString:_TKImageArray[i]]];
                        [_TKPhotoView addSubview:TKImageView];
                        _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth, 90 * _TKImageArray.count);
                    }
                } else {
                    [_TKPhotoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth, 0);
                }


                
                //设置输入框的位置和提交按钮的位置
                _TKTextField.frame = CGRectMake(15, CGRectGetMaxY(_TKPhotoView.frame), MainScreenWidth - 80, 30);
                _TKTextField.text = _userTKAnswer[_Number - 1];
                _TJButton.frame = CGRectMake(MainScreenWidth - 60, CGRectGetMaxY(_TKPhotoView.frame), 50, 30);
                _CKDALabel.text = [NSString stringWithFormat:@"参考答案：%@",_TKRightAnswer[_Number - 1]];
                
                if ([_TKRightAnswer[_Number - 1] isEqualToString:_userTKAnswer[_Number - 1]]) {
                    [_TKFalseButton setTitle:@" 答对了" forState:UIControlStateNormal];
                    [_TKFalseButton setImage:Image(@"考试系统开心@2x") forState:UIControlStateNormal];
                } else {
                    [_TKFalseButton setTitle:@" 答错了" forState:UIControlStateNormal];
                    [_TKFalseButton setImage:Image(@"考试系统难过@2x") forState:UIControlStateNormal];
                }
                
                
                NSString *JXString = [NSString stringWithFormat:@"题目解析：%@",_dataSourceArray[_Number - 1][@"question_qsn_guide"]];
                [self TKJXTitleIntroductionText:JXString];
                
                _TKJXView.frame = CGRectMake(0, CGRectGetMaxY(_TJButton.frame) + 30, MainScreenWidth, CGRectGetHeight(_TKJXLabel.frame));
                

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
            
            
       } else {
           
            //设置输入框的位置
            _textView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTitleLabel.frame), MainScreenWidth - 80, 30);
//            _textView.backgroundColor = [UIColor redColor];
            
            _ZGXSView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTopView.frame), MainScreenWidth, 300);
           if (_userZGAnswer.count > _Number - 1) {
                _textView.text = _userZGAnswer[_Number - 1];
           }
            NSString *JXStr = [NSString stringWithFormat:@"参考答案：%@", _dataSourceArray[_Number - 1][@"question_qsn_guide"]];
            [self ZGJXIntroductionText:JXStr];
            
        }
    } else if (_dataSourceArray == _SubjectiveArray) {//主观题
        if (_Number == 0) {
            if (_judgeArray.count) {
                _dataSourceArray = _judgeArray;
                _Number = _judgeArray.count;
                [self tableViewApper];
            } else if (_gapArray.count) {
                _dataSourceArray = _gapArray;
                _Number = _gapArray.count;
                [self TKViewApper];
            } else if (_multipleArray.count) {
                _dataSourceArray = _multipleArray;
                _Number = _multipleArray.count;
                [self tableViewApper];
            } else if (_singleArray.count) {
                _dataSourceArray = _singleArray;
                _Number = _singleArray.count;
                [self tableViewApper];
            } else {
                [MBProgressHUD showError:@"已经是第一题了" toView:self.view];
                return;
            }
            
        } else {
            
            NSString *TSting = _dataSourceArray[_Number - 1][@"question_content"];
            NSString *title = [self filterHTML:TSting];
            [self ZGSetIntroductionText:title];
            
            [self KKKK:_dataSourceArray[_Number - 1][@"question_content"]];
            
            if (_imageUrl == nil) {
                _ZGImageView.frame = CGRectMake(0, 0, 0, 0);
                _ZGXSView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTopView.frame), MainScreenWidth, 300);
            } else {
                [_ZGImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl]];
                _ZGXSView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTopView.frame) + 50, MainScreenWidth, 300);
            }

            
            //设置输入框的位置
            _photosView.hidden = NO;
            
            _ZGXSView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTopView.frame), MainScreenWidth, 300);

           
            if (_userZGAnswer.count) {
                 _textView.text = _userZGAnswer[_Number - 1];
            }
            NSString *JXStr = [NSString stringWithFormat:@"参考答案：%@", _dataSourceArray[_Number - 1][@"question_qsn_guide"]];
            [self ZGJXIntroductionText:JXStr];
            
            
            
        }
    }
    
    
    _Number --;
    
    //前往上一题的时候就把之前答案数组的最后一个元素移除
    
    if ([_typeStr isEqualToString:@"1"]) {//当前为单选题
        
    } else if ([_typeStr isEqualToString:@"2"]) {//当前为多选题
        
    } else if ([_typeStr isEqualToString:@"3"]) {//填空
        NSLog(@"%@",_TKAnswerArray);

    } else if ([_typeStr isEqualToString:@"4"]) {//判断
        
//        NSString *answerStr = _PDAnswerArray[_Number];
//        [_XZArray removeAllObjects];
//        for (int i = 0; i < 8 ; i ++) {
//            [_XZArray addObject:@"0"];
//        }
//        
//        if ([answerStr isEqualToString:@""]) {//空
//            
//        } else if ([answerStr isEqualToString:@"1"]) {//
//            [_XZArray replaceObjectAtIndex:0 withObject:@"1"];
//        } else if ([answerStr isEqualToString:@"2"]) {
//            [_XZArray replaceObjectAtIndex:1 withObject:@"1"];
//        } else if ([answerStr isEqualToString:@"3"]) {
//            [_XZArray replaceObjectAtIndex:2 withObject:@"1"];
//        }
        
    } else if ([_typeStr isEqualToString:@"5"]) {
        
    }
    
    
    [_tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//这个方法再次刷新 保证头部的空间跟自适应 一致
        [_tableView reloadData];
    });
}

- (void)nextButton {
    
    if (_dataSourceArray == _singleArray) {//说明是单选题
        
        if (_Number == _singleArray.count - 1) {//说明是最后一题了
            
            if (_multipleArray.count) {
                _dataSourceArray = _multipleArray;
                [self tableViewApper];
            } else if (_gapArray.count) {
                _dataSourceArray = _gapArray;
                [self TKViewApper];
            } else if (_judgeArray.count) {
                _dataSourceArray = _judgeArray;
                [self tableViewApper];
            } else if (_SubjectiveArray.count) {
                _dataSourceArray = _SubjectiveArray;
                [self ZGViewApper];
                _WZLabel.text = @"主观";
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
                
                //显示填空题的试图
                _tableView.hidden = YES;
                _TKView.hidden = NO;
                _ZGView.hidden = YES;
                
                
                NSString *TSting = _dataSourceArray[_Number + 1][@"question_content"];
                
                NSString *titleStr = [self filterHTML:TSting];
                [self TKSetIntroductionText:titleStr];
                
                //图片的位置
                _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth, 80);
                [_TKPhotoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                
                //设置输入框的位置和提交按钮的位置
                _TKTextField.frame = CGRectMake(15, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth - 80, 30);
                
                _TKTextField.text = _userTKAnswer[_Number + 1];
                
                _TJButton.frame = CGRectMake(MainScreenWidth - 60, CGRectGetMaxY(_TKTopView.frame), 50, 30);
                
                _CKDALabel.text = [NSString stringWithFormat:@"参考答案：%@",_TKRightAnswer[_Number + 1]];
                
                if ([_TKRightAnswer[_Number + 1] isEqualToString:_userTKAnswer[_Number + 1]]) {
                    [_TKFalseButton setTitle:@" 答对了" forState:UIControlStateNormal];
                    [_TKFalseButton setImage:Image(@"考试系统开心@2x") forState:UIControlStateNormal];
                } else {
                    [_TKFalseButton setTitle:@" 答错了" forState:UIControlStateNormal];
                    [_TKFalseButton setImage:Image(@"考试系统难过@2x") forState:UIControlStateNormal];
                }
                
                
                NSString *JXString = [NSString stringWithFormat:@"题目解析：%@",_dataSourceArray[_Number + 1][@"question_qsn_guide"]];
                [self TKJXTitleIntroductionText:JXString];
                
//                _TKJXView.frame = CGRectMake(0, CGRectGetMaxY(_TKJXLabel.frame), MainScreenWidth, CGRectGetHeight(_TKJXLabel.frame));
                _TKJXView.frame = CGRectMake(0, CGRectGetMaxY(_TJButton.frame) + 30, MainScreenWidth, CGRectGetHeight(_TKJXLabel.frame));
                _TKJXLabel.frame = CGRectMake(0, CGRectGetMaxY(_CKDALabel.frame), MainScreenWidth, 80);
                

            } else if (_judgeArray.count) {
                _dataSourceArray = _judgeArray;
                [self tableViewApper];
            } else if (_SubjectiveArray.count) {
                _dataSourceArray = _SubjectiveArray;
                [self ZGViewApper];
            } else {
                [MBProgressHUD showError:@"已经是最后一题了" toView:self.view];
                return;
            }
            _Number = -1;
            
        }
        
    } else if (_dataSourceArray == _gapArray) {//提空题
        
        NSLog(@"Number----%ld",_Number);
        
        if (_Number == _gapArray.count - 1) {//说明是最后一题了
            
            if (_judgeArray.count) {
                _dataSourceArray = _judgeArray;
                _Number = -1;
                [self tableViewApper];
                _typeStr = @"4";
            } else if (_SubjectiveArray.count) {
                _dataSourceArray = _SubjectiveArray;
                _Number = -1;
                [self ZGViewApper];
                _typeStr = @"5";
                _WZLabel.text = @"主观";
            } else {
                [MBProgressHUD showError:@"已经是最后一题了" toView:self.view];
                return;
            }
            
        } else {//此时还是填空题
            
            
            NSString *TSting = _dataSourceArray[_Number + 1][@"question_content"];
            NSString *titleStr = [self filterHTML:TSting];
            [self TKSetIntroductionText:titleStr];
            
            //图片的位置
            _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth, 80);
            
            
            _TKImageArray = nil;
            _TKImageArray = [self filterHTMLImage:TSting];
            NSLog(@"----%@",_TKImageArray);
            
            if (_TKImageArray.count) {
                //将之前的试图移除
                [_TKPhotoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                for (int i = 0 ; i < _TKImageArray.count; i ++) {
                    UIImageView *TKImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90 * i, MainScreenWidth, 80)];
                    TKImageView.contentMode = UIViewContentModeScaleAspectFit;
                    [TKImageView sd_setImageWithURL:[NSURL URLWithString:_TKImageArray[i]]];
                    [_TKPhotoView addSubview:TKImageView];
                    _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth, 90 * _TKImageArray.count);
                }
            } else {
                [_TKPhotoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth, 0);
            }

            
            //设置输入框的位置和提交按钮的位置
            _TKTextField.frame = CGRectMake(15, CGRectGetMaxY(_TKPhotoView.frame), MainScreenWidth - 80, 30);

            _TKTextField.text = _userTKAnswer[_Number + 1];
            
            _TJButton.frame = CGRectMake(MainScreenWidth - 60, CGRectGetMaxY(_TKPhotoView.frame), 50, 30);
            _CKDALabel.text = [NSString stringWithFormat:@"参考答案：%@",_TKRightAnswer[_Number + 1]];
            
            [self TKJXAnswerIntroductionText:_CKDALabel.text];
            
            
            if ([_TKRightAnswer[_Number + 1] isEqualToString:_userTKAnswer[_Number + 1]]) {
                [_TKFalseButton setTitle:@" 答对了" forState:UIControlStateNormal];
                [_TKFalseButton setImage:Image(@"考试系统开心@2x") forState:UIControlStateNormal];
            } else {
                [_TKFalseButton setTitle:@" 答错了" forState:UIControlStateNormal];
                [_TKFalseButton setImage:Image(@"考试系统难过@2x") forState:UIControlStateNormal];
            }
            
            NSString *JXString = [NSString stringWithFormat:@"题目解析：%@",_dataSourceArray[_Number + 1][@"question_qsn_guide"]];
            [self TKJXTitleIntroductionText:JXString];
            
            _TKJXView.frame = CGRectMake(0, CGRectGetMaxY(_TJButton.frame) + 30, MainScreenWidth, CGRectGetHeight(_TKJXLabel.frame));
            _TKJXLabel.frame = CGRectMake(0, CGRectGetMaxY(_CKDALabel.frame), MainScreenWidth, 80);
            
            //让视图滑最上面
            _TKView.contentOffset = CGPointMake(0, 0);
            
        }
        
        NSLog(@"---%ld ---%ld",_gapArray.count,_Number);
        
    } else if (_dataSourceArray == _judgeArray) {//判断题
        
        if (_SubjectiveArray == nil) {
            if (_Number == _judgeArray.count - 1) {
                [MBProgressHUD showSuccess:@"已经是最后一题了" toView:self.view];
                [self addAnswerPD];
                return;
            }
            
        } else {
            
            if (_Number == _judgeArray.count - 1) {//说明是最后一道题
 
                _dataSourceArray = _SubjectiveArray;
                _Number = -1;
                _tableView.hidden = YES;
                _TKView.hidden = YES;
                _ZGView.hidden = NO;
                _WZLabel.text = @"主观";
                
                if (_userZGAnswer.count > _Number + 1) {
                    if ([_userZGAnswer[_Number + 1] isEqualToString:@""]) {
                        _textView.text = @"未填";
                    } else {
                        _textView.text = _userZGAnswer[_Number + 1];
                    }
                    
                } else {
                    _textView.text = @"未填";
                }
                
                //图片显示出来
                
                NSArray *imageA = _SubjectiveArray[0][@"attach_id"];
                for (int i = 0; i < imageA.count; i ++) {
                    
                    UIImageView *imageView = [[UIImageView alloc] init];
                    [imageView sd_setImageWithURL:_userImageArray[i]];
                    NSLog(@"%@",imageView);
                    [_photosView addImageView:imageView];
                }
                
                
            } else {
                
                
            }
            
        }
        
    } else if (_dataSourceArray == _SubjectiveArray) {
        if (_Number == _SubjectiveArray.count - 1) {
            [MBProgressHUD showSuccess:@"已经是最后一题了" toView:self.view];
            [self addAnswerZG];
            return;
        } else {//主观题
            
            
            NSString *TSting = _dataSourceArray[_Number + 1][@"question_content"];
            NSString *title = [self filterHTML:TSting];
            [self ZGSetIntroductionText:title];
            
            //            [self getImageurlFromHtml: _dataSourceArray[_Number + 1][@"question_content"]];
            [self KKKK:_dataSourceArray[_Number + 1][@"question_content"]];
            
            if (_imageUrl == nil) {
                _ZGImageView.frame = CGRectMake(0, 0, 0, 0);
                _ZGXSView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTopView.frame), MainScreenWidth, 300);
            } else {
                [_ZGImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl]];
                _ZGXSView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTopView.frame) + 50, MainScreenWidth, 300);
            }
            
            //设置输入框的位置
            
            _ZGXSView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTopView.frame), MainScreenWidth, 300);
            if (_userZGAnswer.count > _Number + 1) {
                if ([_userZGAnswer[_Number + 1] isEqualToString:@""]) {
                    _textView.text = @"未填";
                } else {
                    _textView.text = _userZGAnswer[_Number + 1];
                }

            } else {
                _textView.text = @"未填";
            }
            
            //显示图片
            
            NSArray *imageA = [NSArray array];
            if (_SubjectiveArray.count > _Number + 1) {
                imageA = _SubjectiveArray[_Number + 1][@"attach_id"];
            }
            for (int i = 0; i < imageA.count; i ++) {
                
                UIImageView *imageView = [[UIImageView alloc] init];
                [imageView sd_setImageWithURL:_userImageArray[i]];
                NSLog(@"%@",imageView);
                [_photosView addImageView:imageView];
            }
            
            
//            if ([_formWhere isEqualToString:@"123"]) {
//                _textView.text = _myZGAnswerArray[_Number + 1];
//            } else if (_formStr != nil) {
//                _textView.text = _ZGAnswerArray[_Number + 1];
//            } else {
//                
//                if (_ZGAnswerArray.count > _Number + 1) {
//                    _textView.text = _ZGAnswerArray[_Number + 1];
//                }
//                
//            }
//            
//            在最后一题可以不用隐藏了
//                        if (_Number >= _SubjectiveArray.count - 1) {
//                            _photosView.hidden = NO;
//                        } else {
//                             _photosView.hidden = YES;
//                             _TJImageButton.frame = CGRectMake(10, 130, 80, 80);
//                        }
//            
//            
//            _photosView.hidden = NO;
//            _photosView.hidden = YES;
            
            
            NSString *JXStr = [NSString stringWithFormat:@"参考答案：%@", _dataSourceArray[_Number + 1][@"question_qsn_guide"]];
            [self ZGJXIntroductionText:JXStr];
            
        }
        
    }
    
    
    _Number ++;
    
    if (_tableView.hidden == YES) {
        return;
    }
    
    [_tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//这个方法再次刷新 保证头部的空间跟自适应 一致
        [_tableView reloadData];
    });
}

//添加单选答案
- (void)addAnswerDX {
    
    //将数组全部设为0 （这个方法在网络请求成功里面调用）
    [_XZArray removeAllObjects];
    for (int i = 0 ; i < 8; i ++) {
        [_XZArray addObject:@"0"];
    }
    
    NSLog(@"_XZArray-----%@",_XZArray);
}

//添加多选答案
- (void)addAnswerDDX {

    
}

//添加填空题的答案
- (void)addAnswerTK {

}

//添加判断题的答案
- (void)addAnswerPD {
    
    //将数组全部设为0 （这个方法在网络请求成功里面调用）
    [_XZArray removeAllObjects];
    for (int i = 0 ; i < 8; i ++) {
        [_XZArray addObject:@"0"];
    }
    
}

//主观题的答案添加
- (void)addAnswerZG {
    NSLog(@"-----%@",_textView.text);
    
    
    NSLog(@"%ld",_Number);
    NSLog(@"%ld",_ZGAnswerArray.count);
    
//    [_photosView removeImage];
    //清空照片
    _imageArray = nil;
    _TJImageButton.frame = CGRectMake(10, 130, 80, 80);
    
}


#pragma mark --- 选择题界面
- (void)addXZView {
    
    _DXView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 - 58)];
    _DXView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_DXView];
    
    
}


- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight  - 58 - 64 ) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_DXView addSubview:_tableView];
    
}

#pragma mark --- 填空题界面
- (void)addTKView {
    //添加(填空题)的试图
    UIScrollView *TKView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 - 58)];
    TKView.backgroundColor = [UIColor whiteColor];
    TKView.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight * 2);
    [self.view addSubview:TKView];
    _TKView = TKView;
    _TKView.hidden = YES;
//    if ([_formType isEqualToString:@"3"]) {//测评报告过来 (让填空题的试图显示出来）
//        _TKView.hidden = NO;
//        _tableView.hidden = YES;
//        _ZGView.hidden = YES;
//    }
    
    _TKTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100)];
    [_TKView addSubview:_TKTopView];
    
    _TKTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth - 20, 100)];
    NSString *TSting = _dataSourceArray[_Number][@"question_content"];
    NSString *titleStr = [self filterHTML:TSting];
    
    [self TKSetIntroductionText:titleStr];
    _TKTitleLabel.font = Font(18);
    _TKTitleLabel.textColor = [UIColor colorWithRed:125.f / 255 green:125.f / 255 blue:125.f / 255 alpha:1];
    [_TKTopView addSubview:_TKTitleLabel];
    
    
    
    //填空题的图片视图
    _TKPhotoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth, 80)];
//    _TKPhotoView.backgroundColor = [UIColor redColor];
    [_TKView addSubview:_TKPhotoView];
    
    //添加imageView
    _TKImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 80)];
    _TKImageView.backgroundColor = [UIColor whiteColor];
    [_TKPhotoView addSubview:_TKImageView];
    
    _TKImageArray = [self filterHTMLImage:_dataSourceArray[_Number][@"question_content"]];
    _TKImageView.contentMode = UIViewContentModeScaleAspectFit;
    NSLog(@"%@",_TKImageArray);
//    if (_TKImageArray.count) {
//        [_TKImageView sd_setImageWithURL:[NSURL URLWithString:_TKImageArray[0]]];
//    } else {
//        _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth, 0);
//    }
    
    if (_TKImageArray.count) {
        //要将之前的移除
        
        
        for (int i = 0 ; i < _TKImageArray.count; i ++) {
            UIImageView *TKImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90 * i, MainScreenWidth, 80)];
            TKImageView.contentMode = UIViewContentModeScaleAspectFit;
            [TKImageView sd_setImageWithURL:[NSURL URLWithString:_TKImageArray[i]]];
            [_TKPhotoView addSubview:TKImageView];
            _TKPhotoView.frame = CGRectMake(0, 90 * i, MainScreenWidth, 90 * _TKImageArray.count);
            
        }
    } else {
        _TKPhotoView.frame = CGRectMake(0, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth, 0);
    }

    

    
    
    //添加输入框
    _TKTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_TKPhotoView.frame), MainScreenWidth - 80, 30)];
    _TKTextField.layer.cornerRadius = 5;
    _TKTextField.layer.borderWidth = 1;
    _TKTextField.layer.borderColor = PartitionColor.CGColor;
    _TKTextField.placeholder = @"如果有两个答案请用,隔开";
    _TKTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    //设置显示模式为永远显示(默认不显示)
    _TKTextField.leftViewMode = UITextFieldViewModeAlways;
    _TKTextField.textColor = XXColor;
    

    if (_userTKAnswer.count) {
        _TKTextField.text = _userTKAnswer[0];
    }
    [TKView addSubview:_TKTextField];
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TKTextField:) name:UITextFieldTextDidChangeNotification object:nil];
    
    //添加提交按钮
    UIButton *TJButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, CGRectGetMaxY(_TKPhotoView.frame), 50, 30)];
    [TJButton setTitle:@"提交" forState:UIControlStateNormal];
    [TJButton setTitleColor:BasidColor forState:UIControlStateNormal];
    TJButton.layer.cornerRadius = 5;
    TJButton.layer.borderWidth = 1;
    TJButton.layer.borderColor = BasidColor.CGColor;
    [TKView addSubview:TJButton];
    _TJButton = TJButton;
    TJButton.hidden = YES;
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



//监听输入框的变化，控制按钮的颜色
- (void)TKTextField:(NSNotification *)not {
    if (_TKTextField.text.length > 0) {
        _TJButton.backgroundColor = BasidColor;
        [_TJButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        _TJButton.backgroundColor = [UIColor whiteColor];
        [_TJButton setTitleColor:BasidColor forState:UIControlStateNormal];
    }
    NSLog(@"%@",_TKTextField.text);
}

//添加填空题的解析界面
- (void)addTKJXView {
    UIView *TKJXView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_TKTopView.frame) + 50, MainScreenWidth, 110)];
    TKJXView.backgroundColor = [UIColor whiteColor];
    [_TKView addSubview:TKJXView];
    _TKJXView = TKJXView;
    
    //添加分割线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    button.backgroundColor = PartitionColor;
    [TKJXView addSubview:button];
    
    //参考答案
    UILabel *CKDALabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth, 30)];
    CKDALabel.text = [NSString stringWithFormat:@"参考答案：%@",_dataSourceArray[_Number][@"question_answer"]];
    CKDALabel.font = Font(16);
    _CKDALabel = CKDALabel;
    [self TKJXAnswerIntroductionText:CKDALabel.text];
    CKDALabel.textColor = BlackNotColor;
    [TKJXView addSubview:CKDALabel];

    
    //添加答错的界面
    //添加按钮
    UIButton *falseButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 100, 10, 90, 30)];
    falseButton.layer.cornerRadius = 5;
    falseButton.backgroundColor = [UIColor redColor];
    [falseButton setTitle:@" 答错了!" forState:UIControlStateNormal];
    falseButton.titleLabel.font = Font(15);
    [falseButton setImage:Image(@"考试系统难过@2x") forState:UIControlStateNormal];
    falseButton.imageEdgeInsets =  UIEdgeInsetsMake(0,10,0,60);
    [TKJXView addSubview:falseButton];
//    if ([_dataSourceArray[_Number][@"question_answer"] isEqualToString:_myTKAnswerArray[_Number]]) {
//        [falseButton setTitle:@" 答对了" forState:UIControlStateNormal];
//        [falseButton setImage:Image(@"考试系统开心@2x") forState:UIControlStateNormal];
//    }
    _TKFalseButton = falseButton;
    
    
    
    //添加自适应文本(填空解析文本）
    UILabel *TKJXLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_CKDALabel.frame), MainScreenWidth - 20, 100)];
    TKJXLabel.text = [NSString stringWithFormat:@"题目解析：%@",_dataSourceArray[_Number][@"question_qsn_guide"]];
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
    CGRect labelSize = [_CKDALabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 130, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil];
    
    _CKDALabel.frame = CGRectMake(_CKDALabel.frame.origin.x,_CKDALabel.frame.origin.y, MainScreenWidth - 130, labelSize.size.height);
//    _CKDALabel.backgroundColor = [UIColor redColor];
    
    //计算出自适应的高度
    
//    _TKJXView.frame = CGRectMake(0, CGRectGetMaxY(_TKTextField.frame) + 50, self.view.bounds.size.width, labelSize.size.height + 60);
    
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
    
    _TKJXLabel.frame = CGRectMake(_TKJXLabel.frame.origin.x,_TKJXLabel.frame.origin.y, MainScreenWidth - 20, labelSize.size.height);
    
    //计算出自适应的高度
    
    _TKJXView.frame = CGRectMake(0, CGRectGetMaxY(_TKTopView.frame) + 50, self.view.bounds.size.width, labelSize.size.height + 60);
    
}



//键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark --- 判断题界面

- (void)addPDView {
    //添加判断题的视图
    
}

#pragma mark ---- 主观题界面

- (void)addZGView {
    //这里改变上面View的颜色
    
    //添加主观题的界面
    _ZGView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 - 58)];
    _ZGView.backgroundColor = [UIColor colorWithRed:242.f / 255 green:242.f / 255 blue:242.f / 255 alpha:1];
    [self.view addSubview:_ZGView];
    _ZGView.hidden = YES;
//    if ([_formType isEqualToString:@"5"]) {//测评报告过来 (让填空题的试图显示出来）
//        _TKView.hidden = YES;
//        _tableView.hidden = YES;
//        _ZGView.hidden = NO;
//    }
    
    //添加滚动试图
    _ZGScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 60)];
    _ZGScrollView.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight + 400 );
    [_ZGView addSubview:_ZGScrollView];
    
    
    
    //添加题目
    _ZGTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100)];
    _ZGTopView.backgroundColor = [UIColor colorWithRed:242.f / 255 green:242.f / 255 blue:242.f / 255 alpha:1];
    [_ZGScrollView addSubview:_ZGTopView];
    
    
    _ZGTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth - 20, 100)];
    NSString *title = [self filterHTML:_SubjectiveArray[_Number][@"question_content"]];
//    [self getImageurlFromHtml:_SubjectiveArray[_Number][@"question_content"]];
    [self KKKK:_SubjectiveArray[_Number][@"question_content"]];
    [self ZGSetIntroductionText:title];
    _ZGTitleLabel.font = Font(18);
    _ZGTitleLabel.textColor = [UIColor colorWithRed:125.f / 255 green:125.f / 255 blue:125.f / 255 alpha:1];
    [_ZGTopView addSubview:_ZGTitleLabel];
    
    
    
    
    
    //添加叙述view
    UIView *XSView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_ZGTopView.frame), MainScreenWidth, 300)];
    XSView.backgroundColor = [UIColor whiteColor];
    [_ZGScrollView addSubview:XSView];
    _ZGXSView = XSView;
    
    //添加图片的试图
    _ZGImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, MainScreenWidth, 50)];
    [XSView addSubview:_ZGImageView];
    _ZGImageView.backgroundColor = [UIColor colorWithRed:242.f / 255 green:242.f / 255 blue:242.f / 255 alpha:1];
    
    if (_imageUrl == nil) {
        _ZGImageView.frame = CGRectMake(0, 0, 0, 0);
        
    } else  {
        [_ZGImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl]];
        _ZGTopView.frame = CGRectMake(0, 0, MainScreenWidth, 150);
    }
    

    
    //添加textView
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_ZGImageView.frame), MainScreenWidth, 100)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.font = Font(16);
//    _textView.text = _userZGAnswer[0];
    
    [XSView addSubview:_textView];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextView:) name:UITextViewTextDidChangeNotification object:nil];
    
    //添加个文本
    _ZGTXLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, MainScreenWidth, 20)];
    _ZGTXLabel.text = @"详细叙述提交内容，切换下一题自动提交";
    _ZGTXLabel.textColor = [UIColor lightGrayColor];
    [_textView addSubview:_ZGTXLabel];
    _ZGTXLabel.hidden = YES;
    
    //从测评报告过来显示主观题自己的答案
//    if ([_formWhere isEqualToString:@"123"]) {
//        _textView.text = _myZGAnswerArray[_Number];
//        if (_textView.text.length != 0) {
//            _ZGTXLabel.hidden = YES;
//        }
//    }
    
    _textView.text = @"未填";
    if (_userZGAnswer.count > _Number) {
        _textView.text = _userZGAnswer[_Number];
    }
    if (_textView.text.length != 0) {
        _ZGTXLabel.hidden = YES;
    }

    
    
    //添加展示图片的View
    _photosView = [[PhotosView alloc] initWithFrame:CGRectMake(0, 100, MainScreenWidth, 230)];
    _photosView.backgroundColor = [UIColor whiteColor];
    _photosView.userInteractionEnabled = YES;
    [XSView addSubview:_photosView];
    

    NSArray *imageA = _SubjectiveArray[0][@"attach_id"];
    for (int i = 0; i < imageA.count; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:_userImageArray[i]];
        NSLog(@"%@",imageView);
        [_photosView addImageView:imageView];
    }
    
    //添加主观题的解析界面
    _ZGJXLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_ZGXSView.frame), MainScreenWidth - 20, 230)];
    NSString *HHHStr = [NSString stringWithFormat:@"参考答案：%@",_dataSourceArray[_Number][@"question_qsn_guide"]];

    [_ZGScrollView addSubview:_ZGJXLabel];
    _ZGJXLabel.numberOfLines = 0;
    _ZGJXLabel.font = Font(16);
    NSLog(@"HHHStr-----%@",HHHStr);
    NSLog(@"_ZGJXLabel-----%@",_ZGJXLabel.text);
    [self ZGJXIntroductionText:HHHStr];
    _ZGJXLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:_downView];
    
}

//解析界面
- (void)ZGJXIntroductionText:(NSString *)text {
    NSLog(@"%@",text);
    //设置label的最大行数
    _ZGJXLabel.numberOfLines = 0;
    NSLog(@"%@",_ZGJXLabel.text);
    CGRect labelSize = [text boundingRectWithSize:CGSizeMake(MainScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil];
    NSLog(@"%@",NSStringFromCGRect(labelSize));
    
    _ZGJXLabel.text = text;
    
//    _ZGJXLabel.frame = CGRectMake(_ZGJXLabel.frame.origin.x,_ZGJXLabel.frame.origin.y, MainScreenWidth, labelSize.size.height);
    
    //计算出自适应的高度
    _ZGJXLabel.frame = CGRectMake(10, CGRectGetMaxY(_ZGXSView.frame) + 30, MainScreenWidth - 20, labelSize.size.height);
    
    
}

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




- (void)TJImageButton:(UIButton *)button {//添加图片
    
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册里选" otherButtonTitles:@"相机拍照", nil];
    action.delegate = self;
    [action showInView:self.view];
    
    
}


- (void)TextView:(NSNotification *)not {
    if (_textView.text.length > 0) {
        _ZGTXLabel.hidden = YES;
    } else {
        _ZGTXLabel.hidden = NO;
    }
    NSLog(@"length----%ld",_textView.text.length);
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
    
    //    [roadTitleLab.text rangeOfString:@"qingjoin"].location !=NSNotFound
    if ([title rangeOfString:@"单选"].location != NSNotFound) {
        _WZLabel.text = @"单选";
        _typeStr = @"1";
        _dataSourceArray = _singleArray;
        [self tableViewApper];
    } else if ([title rangeOfString:@"多项"].location != NSNotFound) {
        _WZLabel.text = @"多选";
        _typeStr = @"2";
        _dataSourceArray = _multipleArray;
        [self tableViewApper];
    } else if ([title rangeOfString:@"填空"].location != NSNotFound) {
        _WZLabel.text = @"填空";
        _typeStr = @"3";
        _dataSourceArray = _gapArray;
        [self TKViewApper];
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

# pragma mark --- 表格试图

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height + 15;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    NSLog(@"%@",_dataSourceArray[@"question_list"]);
    
    NSArray *HHH = nil;
    NSLog(@"%ld",_Number);
    NSLog(@"%@",_dataSourceArray[_Number]);
    NSLog(@"%@",_dataSourceArray[_Number][@"option_list"]);
    if (_dataSourceArray.count > _Number) {
        HHH = _dataSourceArray[_Number][@"option_list"];
    }
    
    //    if (!_XZArray.count) {
    //
    //    } else {
    //        for (int i = 0 ; i < HHH.count ; i ++) {
    //            [_XZArray addObject:@"0"];
    //
    //        }
    //        NSLog(@"-----%@",_XZArray);
    //    }
    
    if ([HHH isEqual:[NSNull null]]) {
        return 0;
    } else {
        return HHH.count;
    }
    
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return _headH;
}

//添加表格头部试图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
//    //在这里显示对应题的题型名字
//    NSString *typeStr = _dataSourceArray[_Number][@"question_type"];
//    
//    if ([typeStr isEqualToString:@"1"]) {
//        _WZLabel.text = @"单选";
//    } else if ([typeStr isEqualToString:@"2"]) {
//        _WZLabel.text = @"多选";
//    } else if ([typeStr isEqualToString:@"3"]) {
//        _WZLabel.text = @"填空";
//    } else if ([typeStr isEqualToString:@"4"]) {
//        _WZLabel.text = @"判断";
//    } else if ([typeStr isEqualToString:@"5"]) {
//        _WZLabel.text = @"主观";
//    }
//    
//    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 30)];
//    _headView.backgroundColor = [UIColor whiteColor];
//    
//    //题目
//    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth - 20, 100)];
//    NSString *titleStr = [self filterHTML:_dataSourceArray[_Number][@"question_content"]];
//    _titleLabel.text = titleStr;
//    [self KKKK:_dataSourceArray[_Number][@"question_content"]];
//    
//    
//    _titleLabel.font = Font(18);
//    _titleLabel.textColor = [UIColor colorWithRed:125.f / 255 green:125.f / 255 blue:125.f / 255 alpha:1];
//    
//    
//    _titleLabel.numberOfLines = 0;
//    
//    CGRect labelSize = [_titleLabel.text boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} context:nil];
//    
//    _titleLabel.frame = CGRectMake(_titleLabel.frame.origin.x,_titleLabel.frame.origin.y, self.view.bounds.size.width - 20, labelSize.size.height);
//    
//    _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, labelSize.size.height + 20, MainScreenWidth, 50)];
//    if (_imageUrl == nil) {
//        _contentImageView.frame = CGRectMake(0, 0, 0, 0);
//    }
//    
//    _contentImageView.backgroundColor = [UIColor whiteColor];
//    [_headView addSubview:_contentImageView];
//    
//    //计算出自适应的高度
//    if (_imageUrl != nil) {
//        _headView.frame = CGRectMake(0, 0, self.view.bounds.size.width, labelSize.size.height + 20 + CGRectGetHeight(_contentImageView.frame));
//        [_contentImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl]];
//        _headH = _headView.bounds.size.height + 50;
//        
//        //清空图片
//        //        _imageUrl = nil;
//    } else {
//        _headView.frame = CGRectMake(0, 0, self.view.bounds.size.width, labelSize.size.height + 20);
//        _headH = _headView.bounds.size.height;
//    }
//    
//    return _headView;
    
    
    //在这里显示对应题的题型名字
    NSString *typeStr = nil;
    if (_dataSourceArray.count > _Number) {
        typeStr = _dataSourceArray[_Number][@"question_type"];
    }
    
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
    NSString *titleStr = nil;
    if (_dataSourceArray.count > _Number) {
        titleStr = [self filterHTML:_dataSourceArray[_Number][@"question_content"]];
    }
    _titleLabel.text = titleStr;
    //    _titleLabel.text = _dataSourceArray[_Number][@"question_content"];
    
//    NSLog(@"%@",_dataSourceArray[_Number][@"question_content"]);
    
    if (_dataSourceArray.count > _Number) {
            [self KKKK:_dataSourceArray[_Number][@"question_content"]];
    }

    
    
    
    //    NSString * htmlString = @"<html><body> 这里是显示的内容 \n <font size=\"16\" color=\"red\">这里是显示的内容</font> </body></html>";
    //    NSString *htmlString = [NSString stringWithFormat:@"<html><body>%@ \n <font size=\"16\" color=\"red\"></font> </body></html>",titleStr];
    //    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    //    _titleLabel.attributedText = attrStr;
    //
    
    _titleLabel.font = Font(18);
    _titleLabel.textColor = [UIColor colorWithRed:125.f / 255 green:125.f / 255 blue:125.f / 255 alpha:1];
    
    
    _titleLabel.numberOfLines = 0;
    
    CGRect labelSize = [_titleLabel.text boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} context:nil];
    
    _titleLabel.frame = CGRectMake(_titleLabel.frame.origin.x,_titleLabel.frame.origin.y, self.view.bounds.size.width - 20, labelSize.size.height);
    
    //    //添加试图
    //    _contentImageView.frame = [[UIView alloc] initWithFrame:CGRectMake(0, labelSize.size.height + 20, MainScreenWidth, 50)];
    _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, labelSize.size.height + 20, MainScreenWidth, 50)];
    //    _contentImageView.contentMode = UIViewContentModeCenter;
    if (_imageUrl == nil) {
        _contentImageView.frame = CGRectMake(0, 0, 0, 0);
    }
    
    _contentImageView.backgroundColor = [UIColor whiteColor];
    [_headView addSubview:_contentImageView];
    
    //计算出自适应的高度
    if (_imageUrl != nil) {
        _headView.frame = CGRectMake(0, 0, self.view.bounds.size.width, labelSize.size.height + 20 + CGRectGetHeight(_contentImageView.frame));
        [_contentImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl]];
        _headH = _headView.bounds.size.height + 50;
        
        //清空图片
        //        _imageUrl = nil;
    } else {
        _headView.frame = CGRectMake(0, 0, self.view.bounds.size.width, labelSize.size.height + 20);
        _headH = _headView.bounds.size.height;
    }
    
    [_headView addSubview:_titleLabel];
    
    return _headView;

    
}

//表格底部视图的高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return  _footH;
}


//添加表格底部试图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100)];
    _footView.backgroundColor = [UIColor whiteColor];
    
    //参考答案
    UILabel *CKDALabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth, 30)];
//    CKDALabel.text = [NSString stringWithFormat:@"参考答案：%@",_dataSourceArray[_Number][@"question_answer"]];
    if (_dataSourceArray.count > _Number) {
        CKDALabel.text = [NSString stringWithFormat:@"参考答案：%@",_dataSourceArray[_Number][@"question_answer"]];
    }
    
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
    
    if (_dataSourceArray == _judgeArray) {//判断
        NSString *myStr = nil;
        if (_userPDAnswer.count) {
            myStr = _userPDAnswer[_Number];
        }
        
//        NSLog(@"%d---%@",_userPDAnswer,_Number);
        
        NSString *rightStr = nil;
        if (_PDRightAnswer.count > _Number) {
            rightStr = _PDRightAnswer[_Number];
        }
        NSLog(@"%@ %@",myStr,rightStr);
        if ([myStr isEqualToString:rightStr]) {
            [falseButton setTitle:@" 答对了" forState:UIControlStateNormal];
            [falseButton setImage:Image(@"考试系统开心@2x") forState:UIControlStateNormal];
        }
    }
    
    if (_dataSourceArray == _singleArray) {//单选
        NSString *myStr = nil;
        if (_userDXAnswer.count) {
            myStr = _userDXAnswer[_Number];
        }
        NSString *rightStr = nil;
        if (_DXRightAnswer.count) {
            rightStr = _DXRightAnswer[_Number];
        }
        if ([myStr isEqualToString:rightStr]) {
            [falseButton setTitle:@" 答对了" forState:UIControlStateNormal];
            [falseButton setImage:Image(@"考试系统开心@2x") forState:UIControlStateNormal];
        }
    }
    
    if (_dataSourceArray == _multipleArray) {//多选
        NSString *myStr = nil;
        if (_userDDXAnswer.count) {
            myStr = _userDDXAnswer[_Number];
        }
        NSString *rightStr = nil;
        if (_DDXRightAnswer.count) {
            rightStr = _DDXRightAnswer[_Number];
        }
        if ([myStr isEqualToString:rightStr]) {
            [falseButton setTitle:@" 答对了" forState:UIControlStateNormal];
            [falseButton setImage:Image(@"考试系统开心@2x") forState:UIControlStateNormal];
        }
        
    }
    
    
    //添加自适应文本
    _footTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, MainScreenWidth - 20, 100)];
//    _footTitle.text = [NSString stringWithFormat:@"题目解析：%@",_dataSourceArray[_Number][@"question_qsn_guide"]];
    if (_dataSourceArray.count > _Number) {
        _footTitle.text = [NSString stringWithFormat:@"题目解析：%@",_dataSourceArray[_Number][@"question_qsn_guide"]];
    }
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
    
    //答题卡过来进行判断
    if ([_typeStr isEqualToString:@"1"]) {//单选
        NSString *answerStr = nil;
        if (_userDXAnswer.count) {
            answerStr = nil;
            if (_userDXAnswer.count > _Number) {
                answerStr = _userDXAnswer[_Number];
            }
        }
        [_XZArray removeAllObjects];
        for (int i = 0; i < 40 ; i ++) {
            [_XZArray addObject:@"0"];
        }
        if ([answerStr isEqualToString:@""]) {//空
            
        } else if ([answerStr isEqualToString:@"A"]) {//
            [_XZArray replaceObjectAtIndex:0 withObject:@"1"];
        } else if ([answerStr isEqualToString:@"B"]) {
            [_XZArray replaceObjectAtIndex:1 withObject:@"1"];
        } else if ([answerStr isEqualToString:@"C"]) {
            [_XZArray replaceObjectAtIndex:2 withObject:@"1"];
        }
        
    } else if ( [_typeStr isEqualToString:@"2"]) {//多选
        NSString *answerStr = _userDDXAnswer[_Number];
        [_XZArray removeAllObjects];
        for (int i = 0; i < 40 ; i ++) {
            [_XZArray addObject:@"0"];
        }
        if ([answerStr isEqualToString:@""]) {//空
            
        } else if ([answerStr isEqualToString:@"A"]) {//
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
        }
  
        
    } else if ([_typeStr isEqualToString:@"4"]) {//判断
        
        NSString *answerStr = nil;
       if (_userPDAnswer.count > _Number) {
            answerStr = _userPDAnswer[_Number];
        }
        [_XZArray removeAllObjects];
        for (int i = 0; i < 40 ; i ++) {
            [_XZArray addObject:@"0"];
        }
        
        if ([answerStr isEqualToString:@""]) {//空
            
        } else if ([answerStr isEqualToString:@"A"]) {//
            [_XZArray replaceObjectAtIndex:0 withObject:@"1"];
        } else if ([answerStr isEqualToString:@"B"]) {
            [_XZArray replaceObjectAtIndex:1 withObject:@"1"];
        } else if ([answerStr isEqualToString:@"C"]) {
            [_XZArray replaceObjectAtIndex:2 withObject:@"1"];
        }

    
        
    }
//    NSLog(@"-------%@",_XZArray);
    
    
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

//        if (<#condition#>) {
//            <#statements#>
//        }
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
    NSLog(@"%@",_userPDAnswer);
    NSLog(@"%@",_userZGAnswer);
    
     NSLog(@"%@",_userImageArray);
    
//    //替换答案
//    for (int i = 0; i < _userDXAnswer.count; i ++) {
//        NSString *Str = _userDXAnswer[i];
//        if ([Str isEqualToString:@"A"]) {
//            [_userDXAnswer replaceObjectAtIndex:i withObject:@"1"];
//        } else if ([Str isEqualToString:@"B"]) {
//             [_userDXAnswer replaceObjectAtIndex:i withObject:@"2"];
//        } else if ([Str isEqualToString:@"C"]) {
//             [_userDXAnswer replaceObjectAtIndex:i withObject:@"3"];
//        } else if ([Str isEqualToString:@"D"]) {
//             [_userDXAnswer replaceObjectAtIndex:i withObject:@"4"];
//        }
//    }
    
    NSLog(@"%@",_userDXAnswer);
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
        
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        
        
    }
    // NSString * regEx = @"<([^>]*)>";
    // html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

-(NSArray *) getImageurlFromHtml:(NSString *) webString
{
    
    NSLog(@"----%@",webString);
    
    NSMutableArray * imageurlArray = [NSMutableArray arrayWithCapacity:1];
    
    //标签匹配
    NSString *parten = @"<img(.*?)>";
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:0 error:&error];
    
    NSArray* match = [reg matchesInString:webString options:0 range:NSMakeRange(0, [webString length] - 1)];
    
    for (NSTextCheckingResult * result in match) {
        
        //过去数组中的标签
        NSRange range = [result range];
        NSString * subString = [webString substringWithRange:range];
        
        
        //从图片中的标签中提取ImageURL
        NSRegularExpression *subReg = [NSRegularExpression regularExpressionWithPattern:@"http://(.*?)\"" options:0 error:NULL];
        NSArray* match = [subReg matchesInString:subString options:0 range:NSMakeRange(0, [subString length] - 1)];
        NSTextCheckingResult * subRes = match[0];
        NSRange subRange = [subRes range];
        subRange.length = subRange.length -1;
        NSString * imagekUrl = [subString substringWithRange:subRange];
        
        //将提取出的图片URL添加到图片数组中
        [imageurlArray addObject:imagekUrl];
    }
    NSLog(@"-----%@",imageurlArray);
    return imageurlArray;
}


- (void)KKKK:(NSString *)webString {
    
    _imageUrl = nil;
    
    //    NSString *string = @"<a href=\"http\">这是要截取的内容</a>";
    NSRange startRange = [webString rangeOfString:@"src=\"/"];
    NSRange endRange = [webString rangeOfString:@"\" alt="];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    NSString *result;
    NSString *result1;
    NSString *result2;
    NSString *baisurl = @"http://edu.htph.com.cn/";
    
    
    NSLog(@"%ld  %ld",webString.length,range.length);
    if (range.length == 0) {
        return;
    }
    if (webString.length >= range.length) {
        result1 = [webString substringWithRange:range];
        NSLog(@"%@",result1);
        
        //       result2 = [result1 substringWithRange:NSMakeRange(1, result1.length - 2)];
        
        if ([result2 rangeOfString:@"http"].location !=NSNotFound) {
            result = [NSString stringWithFormat:@"%@%@",baisurl,result1];
        } else {
            result = [NSString stringWithFormat:@"%@%@",baisurl,result1];
        }
        
        _imageUrl = result;
    }
    
    NSLog(@"%@",result);
}


#pragma mark --- 提空题

//获取webView中的所有图片URL
- (NSMutableArray *)filterHTMLImage:(NSString *) webString
{
    NSMutableArray * imageurlArray = [NSMutableArray arrayWithCapacity:1];
    
    //标签匹配
    NSString *parten = @"<img (.*?)>";
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:0 error:&error];
    
    NSLog(@"reg----%@  webString%@",reg,webString);
    if (webString == nil) {
        return nil;
    }
    
    NSArray* match = [reg matchesInString:webString options:0 range:NSMakeRange(0, [webString length] - 1)];
    
    for (NSTextCheckingResult * result in match) {
        
        //过去数组中的标签
        NSRange range = [result range];
        NSString * subString = [webString substringWithRange:range];
        NSString *baisurl = @"http://219.133.104.200/";
        
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
        NSLog(@"------%@",imagekUrl);
        NSString *imageUUrl = [imagekUrl substringFromIndex:2];
        NSString *UUrl = [NSString stringWithFormat:@"%@%@",baisurl,imageUUrl];
        //将提取出的图片URL添加到图片数组中
        [imageurlArray addObject:UUrl];
    }
    
    NSLog(@"%@",imageurlArray);
    
    return imageurlArray;
}




@end
