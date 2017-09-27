//
//  DTViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/6.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import "DTViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "XZTTableViewCell.h"
#import "PhotosView.h"
#import "DTKViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "MBProgressHUD+Add.h"


@interface DTViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,DTKViewControllerDelegate>
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

@property (strong ,nonatomic)NSString *isGoOutEduline;//监听是否是退出程序


@end

@implementation DTViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    
    if ([_formStr isEqualToString:@"1"]) {//通过代理方法将答题卡的信息传回来
        _tableView.hidden = NO;
        _TKView.hidden = YES;
        _ZGView.hidden = YES;
        _dataSourceArray = _singleArray;
        _Number = _formNumber - 1;

    } else if ([_formStr isEqualToString:@"2"]) {
        _tableView.hidden = NO;
        _TKView.hidden = YES;
        _ZGView.hidden = YES;
        _dataSourceArray = _multipleArray;
        _Number = _formNumber - 1;
        
        
    } else if ([_formStr isEqualToString:@"3"]) {//填空题
        _tableView.hidden = YES;
        _TKView.hidden = NO;
        _ZGView.hidden = YES;
        _dataSourceArray = _gapArray;
        _Number = _formNumber - 1;
        
        [self TKViewGoOut];
        
    } else if ([_formStr isEqualToString:@"4"]) {
        _tableView.hidden = NO;
        _TKView.hidden = YES;
        _ZGView.hidden = YES;
        _dataSourceArray = _judgeArray;
        _Number = _formNumber - 1;
    } else if ([_formStr isEqualToString:@"5"]) {
        _tableView.hidden = YES;
        _TKView.hidden = YES;
        _ZGView.hidden = NO;
        _dataSourceArray = _SubjectiveArray;
        _Number = _formNumber - 1;
        [self ZGViewOut];
    }

    [_tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
    
}

//显示填空试图
- (void)TKViewGoOut {
    
    _tableView.hidden = YES;
    _TKView.hidden = NO;
    _ZGView.hidden = YES;
    
    NSString *TSting = _dataSourceArray[_Number][@"question_content"];
    
    [self TKSetIntroductionText:TSting];
    
    _TKTextField.text = _TKAnswerArray[_Number];
    
    //设置输入框的位置和提交按钮的位置
    _TKTextField.frame = CGRectMake(15, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth - 80, 30);
    _TJButton.frame = CGRectMake(MainScreenWidth - 60, CGRectGetMaxY(_TKTopView.frame), 50, 30);
}

//显示主观题试图
- (void)ZGViewOut {
    _textView.text = _ZGAnswerArray[_Number];
    
    NSString *TStr = _dataSourceArray[_Number][@"question_content"];
    [self ZGSetIntroductionText:TStr];
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
//    if (![_isGoOutEduline isEqualToString:@"123"]) {//说明是退出程序
//        //吧当前时间记录下来
//        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//        NSString *timeStr = [NSString stringWithFormat:@"%ld",_timePastting];
//        [defaults setObject:timeStr forKey:_examID];//考试时间
//        [defaults synchronize];
//        
//    }
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addNav];
    [self addDownView];
    [self addXZView];
    
    [self addTableView];
    [self addTKView];
    [self addPDView];
    [self addZGView];
//    [self NetWorkCate];
    [self getRigthAnswer];

}

- (void)interFace {
    
    NSLog(@"%ld",(long)_allTime);
    NSLog(@"dataSource-------%@",_dataSource);
    NSLog(@"%@",_myDXAnswerArray);
    
    self.view.backgroundColor = [UIColor whiteColor];
    flag = YES;
    _typeStr = @"1";//改默认为单选题
    _headH = 80;//头部返回初始高度
    
    _footH = 100;
    
    _Number = 0;
    
    _titleNameArray = [NSMutableArray array];
    _titleIdArray = [NSMutableArray array];
    
    NSLog(@"%@",_dataSource);
    
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
    
    NSLog(@"%@",_singleArray);
    
    _dataSourceArray = _singleArray;//默认为单选题开始
    
    NSLog(@"%@",_dataSourceArray);
    
    _SYGArray = _dataSource[@"data"][@"question_type"];
    
    
    _timePastting = 0;
    
//    NSString *time = [[NSUserDefaults standardUserDefaults] objectForKey:_examID];
//    NSLog(@"%@",time);
//    
//    if (time != nil) {//说明考试的时候退出程序了
//        _timePastting = [time integerValue];
//    }
//    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timePast) userInfo:nil repeats:YES];

    //选中的按钮
    _XZArray = [NSMutableArray array];
    for (int i = 0 ; i < 8 ; i ++) {
        [_XZArray addObject:@"0"];

    }
    NSLog(@"-----%@",_XZArray);
    
//    if ([_formWhere isEqualToString:@"123"]) {//解析答案的时候
//        [_XZArray replaceObjectAtIndex:1 withObject:@"1"];
//        [_XZArray replaceObjectAtIndex:2 withObject:@"2"];
//    }

    _AnswerArray = [NSMutableArray array];//初始化存放答案的数组
    _DXAnswerArray = [NSMutableArray array];
    _DDXAnswerArray = [NSMutableArray array];
    _TKAnswerArray = [NSMutableArray array];
    _PDAnswerArray = [NSMutableArray array];
    _ZGAnswerArray = [NSMutableArray array];
    
    //创建存放图片id的数组
    _imageIDArray = [NSMutableArray array];
//    _imageArray = [NSMutableArray array];
    _SubjectiveImageArray = [NSMutableArray array];
    
    if ([_formWhere isEqualToString:@"123"]) {
        [self WhichDataSource];
    }
    
}

//从测评报告界面过来 判断该用哪个数据源
- (void)WhichDataSource {
    if ([_formType isEqualToString:@"1"]) {//单选题
        _dataSourceArray = _singleArray;
        
    } else if ([_formType isEqualToString:@"2"]) {
        _dataSourceArray = _multipleArray;
       
    } else if ([_formType isEqualToString:@"3"]) {
        _dataSourceArray = _gapArray;
        //这里是填空题的试图，应该显示填空题的试图
        
        _tableView.hidden = YES;
        _TKView.hidden = NO;
        _ZGView.hidden = YES;
        
        _Number = _formCPNumber - 1;
        
        NSString *TSting = _dataSourceArray[_Number][@"question_content"];
        
        [self TKSetIntroductionText:TSting];
        
        //设置输入框的位置和提交按钮的位置
        _TKTextField.frame = CGRectMake(15, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth - 80, 30);
        _TJButton.frame = CGRectMake(MainScreenWidth - 60, CGRectGetMaxY(_TKTopView.frame), 50, 30);
        
        _TKJXView.frame = CGRectMake(0, CGRectGetMaxY(_TKTopView.frame) + 50, MainScreenWidth, 110);
        
        
    } else if ([_formType isEqualToString:@"4"]) {
        _dataSourceArray = _judgeArray;
    } else if ([_formType isEqualToString:@"5"]) {
        _dataSourceArray = _SubjectiveArray;
        
        _tableView.hidden = YES;
        _TKView.hidden = YES;
        _ZGView.hidden = NO;
    
        _Number = _formCPNumber - 1;
        NSLog(@"-----%@",_myZGAnswerArray);
        NSLog(@"%ld",_Number);
        _textView.text = _myZGAnswerArray[_Number];  
        
    }
    
    _Number = _formCPNumber - 1;
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
    WZLabel.font = [UIFont systemFontOfSize:20];
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
    
    //添加按钮
    UIButton *JJButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 25, 50, 30)];
    JJButton.backgroundColor = [UIColor clearColor];
    [JJButton setTitle:@"交卷" forState:UIControlStateNormal];
    [JJButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [JJButton addTarget:self action:@selector(JJButton) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:JJButton];
    
    if ([_formWhere isEqualToString:@"123"]) {
        JJButton.hidden = YES;
    }
    
    
    
}

//提交试卷
- (void)JJButton {
    
    //这里将没有做完的答案补全，以“”
    if (_DXAnswerArray.count != _singleArray.count) {//说明答案不全
        for (NSInteger i = _DXAnswerArray.count; i < _singleArray.count; i ++) {
            [_DXAnswerArray addObject:@""];
        }
    }
    
    NSLog(@"%@",_DXAnswerArray);
    
    if (_DDXAnswerArray.count != _multipleArray.count) {//说明答案不全
        for (NSInteger i = _DDXAnswerArray.count; i < _multipleArray.count; i ++) {
            [_DDXAnswerArray addObject:@""];
        }
    }
    
    if (_TKAnswerArray.count != _gapArray.count) {//说明答案不全
        for (NSInteger i = _TKAnswerArray.count; i < _gapArray.count; i ++) {
            [_TKAnswerArray addObject:@""];
        }
    }
    if (_PDAnswerArray.count != _judgeArray.count) {//说明答案不全
        for (NSInteger i = _PDAnswerArray.count; i < _judgeArray.count; i ++) {
            [_PDAnswerArray addObject:@""];
        }
    }
    
    if (_ZGAnswerArray.count != _SubjectiveArray.count) {//主观答案不全
        for (NSInteger i = _ZGAnswerArray.count; i < _SubjectiveArray.count; i ++) {
            [_ZGAnswerArray addObject:@""];
        }
    }
    
    DTKViewController *DTKVC = [[DTKViewController alloc] init];
    DTKVC.delegate = self;//成为代理
    DTKVC.dataSource = _dataSource;
    DTKVC.singleArray = _singleArray;
    DTKVC.multipleArray = _multipleArray;
    DTKVC.gapArray = _gapArray;
    DTKVC.judgeArray = _judgeArray;
    DTKVC.SubjectiveArray = _SubjectiveArray;
    
    DTKVC.DXAnswerArray = _DXAnswerArray;
    NSLog(@"----%@",_DXAnswerArray);
    DTKVC.DDXAnswerArray = _DDXAnswerArray;
    DTKVC.TKAnswerArray = _TKAnswerArray;
    DTKVC.PDAnswerArray = _PDAnswerArray;
    DTKVC.ZGAnswerArray = _ZGAnswerArray;
    
    //传正确答案
    DTKVC.DXRightAnswer = _DXRightAnswer;
    DTKVC.DDXRightAnswer = _DDXRightAnswer;
    DTKVC.TKRightAnswer = _TKRightAnswer;
    DTKVC.PDRightAnswer = _PDRightAnswer;
    
    //传图片id的数组
    DTKVC.imageIDArray = _imageIDArray;
    
    //传时间
    DTKVC.endTimeStr = _endTimeStr;
    
    DTKVC.timePassing = _timePastting;
    
    DTKVC.examID = _examID;
    
    DTKVC.gradeStr = _gradeStr;
    
    //监听自己控制消失是否为退出程序
//    _isGoOutEduline = @"123";
    if (_timePastting == 5201314) {//说明是时间到了交卷的
        DTKVC.timeOut = 5201314;
    }
    
    [self.navigationController pushViewController:DTKVC animated:YES];
}


- (void)backPressed {
//    _isGoOutEduline = @"1234";
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

    //剩余文本
    UILabel *SYLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 60, 19, 80, 20)];
    SYLabel.text = @"剩余时长：";
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
    //计算开始显示的时间
//    _allTime = _allTime * 60;
    
//    if (_sumTime) {
//        _allTime = _allTime - _sumTime;
//        
//        if (_allTime < 0) {//如果超时  直接现在考试已过
//            _allTime = 0;
//        }
//    }
    
    
    NSLog(@"-----%ld",_allTime);
    
    if (_allTime < 0) {
        _TimeLabel.text = @"00:00:00";
        
//        [self JJButton];
        
        
        return;
    }
    
    NSInteger startTime = _allTime;
    NSInteger startHour = startTime / 3600;
    NSInteger startMin = (startTime - startHour * 3600) / 60;
    NSInteger startSecond = startTime % 60;
    NSString *startString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",startHour,startMin,startSecond];
    _TimeLabel.text = startString;
    
}

- (void)timePast {
    
    if (_allTime == 0 || _allTime < 0) {
        return;
    }
    _timePastting ++;
    NSInteger endTime = _allTime - _timePastting;
    NSInteger endHour = endTime / 3600;
    NSInteger endMin = (endTime - endHour * 3600) / 60;
    NSInteger endSecond = endTime % 60;
    NSString *endString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",endHour,endMin,endSecond];
    _TimeLabel.text = endString;
    
    if ([_TimeLabel.text isEqualToString:@"00:00:00"]) {
        _timePastting = 5201314;
//        [self JJButton];
        
    }
    
}


- (void)upButton {
    
    if (_dataSourceArray == _singleArray) {//说明是单选题
        
        if (_Number == 0) {//说明是最第一题了
            [MBProgressHUD showSuccess:@"已经是第一题了" toView:self.view];
            return;
        }
        
    } else if (_dataSourceArray == _multipleArray) {//多选时
        
        if (_Number == 0) {//说明是多选题的第一题
            if (_singleArray != nil) {
                _dataSourceArray = _singleArray;
                _Number = _singleArray.count;
                [self showPDView];
            } else {
                [MBProgressHUD showError:@"已经是最前面一题了" toView:self.view];
                return;
            }
            
        }
    } else if (_dataSourceArray == _gapArray) {//提空题
        
        if (_Number == 0) {//说明是提空题第一题
            
            if (_multipleArray != nil) {
                _dataSourceArray = _multipleArray;
                _Number = _multipleArray.count;
                [self showPDView];
            } else if (_singleArray != nil) {
                _dataSourceArray = _singleArray;
                _Number = _singleArray.count;
                [self showPDView];
            } else {
                [MBProgressHUD showError:@"已经是最前面一题了" toView:self.view];
                return;
            }
            
        } else {
            
            NSString *TSting = _dataSourceArray[_Number - 1][@"question_content"];
            NSString *titleStr = [self filterHTML:TSting];
            [self TKSetIntroductionText:titleStr];
            
            //设置输入框的位置和提交按钮的位置
            _TKTextField.frame = CGRectMake(15, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth - 80, 30);
            
            if ([_formWhere isEqualToString:@"123"]) {
                 _TKTextField.text = _myTKAnswerArray[_Number - 1];
            }
            
            
            if (_formType == nil) {//就是还没有答题卡界面
                
                if (_TKAnswerArray.count >= _Number + 1) {
                     _TKTextField.text = _TKAnswerArray[_Number - 1];
                }
                
            }
            
            _TJButton.frame = CGRectMake(MainScreenWidth - 60, CGRectGetMaxY(_TKTopView.frame), 50, 30);
           _CKDALabel.text = [NSString stringWithFormat:@"参考答案：%@",_TKRightAnswer[_Number - 1]];
            
            if ([_TKRightAnswer[_Number - 1] isEqualToString:_myTKAnswerArray[_Number - 1]]) {
                [_TKFalseButton setTitle:@" 答对了" forState:UIControlStateNormal];
                [_TKFalseButton setImage:Image(@"考试系统开心@2x") forState:UIControlStateNormal];
            } else {
                [_TKFalseButton setTitle:@" 答错了" forState:UIControlStateNormal];
                [_TKFalseButton setImage:Image(@"考试系统难过@2x") forState:UIControlStateNormal];
            }
            
            NSString *JXString = _dataSourceArray[_Number - 1][@"question_qsn_guide"];
            [self TKJXTitleIntroductionText:JXString];
            
            _TKJXView.frame = CGRectMake(0, CGRectGetMaxY(_TJButton.frame) + 30, MainScreenWidth, CGRectGetHeight(_TKJXLabel.frame));
            
        }
        
    } else if (_dataSourceArray == _judgeArray) {//判断题
        NSLog(@"%ld",_Number);
        if (_Number == 0) {
            
            if (_gapArray != nil) {
                _dataSourceArray = _gapArray;
                _Number = _gapArray.count;
                [self showUpTKView];
            } else if (_multipleArray != nil) {
                _dataSourceArray = _multipleArray;
                _Number = _multipleArray.count;
                [self showPDView];
            } else if (_singleArray != nil) {
                _dataSourceArray = _singleArray;
                _Number = _singleArray.count;
                [self showPDView];
            } else {
                [MBProgressHUD showError:@"已经是最前面一题了" toView:self.view];
                return;
            }
      
        } else {
            NSLog(@"%ld",_Number - 1);
            NSString *TSting = _dataSourceArray[_Number - 1][@"question_content"];
            
            [self ZGSetIntroductionText:TSting];
            
            //设置输入框的位置
            //            _textView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTitleLabel.frame), MainScreenWidth - 80, 30);
            //            _textView.backgroundColor = [UIColor redColor];
            
            _ZGXSView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTopView.frame), MainScreenWidth, 300);
            
            if ([_formWhere isEqualToString:@"123"]) {
                _textView.text = _myZGAnswerArray[_Number - 1];
            } else if (_formStr != nil) {
                _textView.text = _ZGAnswerArray[_Number - 1];
            } else {
                if (_ZGAnswerArray.count) {
                     _textView.text = _ZGAnswerArray[_Number - 1];
                }
                if (_textView.text.length > 0) {
                    _ZGTXLabel.hidden = YES;
                }
            }

            NSString *JXStr = [NSString stringWithFormat:@"参考答案：%@", _dataSourceArray[_Number - 1][@"question_qsn_guide"]];
            [self ZGJXIntroductionText:JXStr];

        }
    } else if (_dataSourceArray == _SubjectiveArray) {//主观题
        if (_Number == 0) {
            
            if (_judgeArray != nil) {
                _dataSourceArray = _judgeArray;
                _Number = _judgeArray.count;
                [self showPDView];
            } else if (_gapArray != nil) {
                _dataSourceArray = _gapArray;
                _Number = _gapArray.count;
                [self showUpTKView];
            } else if (_multipleArray != nil) {
                _dataSourceArray = _multipleArray;
                _Number = _multipleArray.count;
                [self showPDView];
            } else if (_singleArray != nil) {
                _dataSourceArray = _singleArray;
                _Number = _singleArray.count;
                [self showPDView];
            } else {
                [MBProgressHUD showError:@"已经是最前面一题了" toView:self.view];
                return;
            }

        } else {
            
            NSString *TSting = _dataSourceArray[_Number - 1][@"question_content"];
            
            [self ZGSetIntroductionText:TSting];
            
            //设置输入框的位置
            
            _ZGXSView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTopView.frame), MainScreenWidth, 300);

            if ([_formWhere isEqualToString:@"123"]) {
                _textView.text = _myZGAnswerArray[_Number - 1];
            } else if (_formStr != nil) {
                _textView.text = _ZGAnswerArray[_Number - 1];
            } else {
                _textView.text = _ZGAnswerArray[_Number - 1];
                if (_textView.text.length > 0) {
                    _ZGTXLabel.hidden = YES;
                }
            }
            
            NSString *JXStr = [NSString stringWithFormat:@"参考答案：%@", _dataSourceArray[_Number - 1][@"question_qsn_guide"]];
            [self ZGJXIntroductionText:JXStr];
            
            

        }
    }

    
    _Number --;
    
    //前往上一题的时候就把之前答案数组的最后一个元素移除
    
    if ([_typeStr isEqualToString:@"1"]) {//当前为单选题
        
//        NSLog(@"-----%@",_DXAnswerArray[_Number]);

        if ([_formWhere isEqualToString:@"123"]) {
            
        } else {
            NSString *answerStr = nil;
            if (_DXAnswerArray.count) {
                 answerStr = _DXAnswerArray[_Number];
            }
            [_XZArray removeAllObjects];
            for (int i = 0; i < 8 ; i ++) {
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

        }

    } else if ([_typeStr isEqualToString:@"2"]) {//当前为多选题
        
        
        
//        [_DDXAnswerArray removeLastObject];
    } else if ([_typeStr isEqualToString:@"3"]) {//填空
        NSLog(@"%@",_TKAnswerArray);
//        _TKTextField.text = _TKAnswerArray[_Number];
        
        
//        [_TKAnswerArray removeLastObject];
    } else if ([_typeStr isEqualToString:@"4"]) {//判断
        
        NSString *answerStr = _PDAnswerArray[_Number];
        [_XZArray removeAllObjects];
        for (int i = 0; i < 8 ; i ++) {
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
            
            _Number = -1;
            if (_multipleArray != nil) {//多选
                _dataSourceArray = _multipleArray;
            } else if (_gapArray != nil) {//填空
                _dataSourceArray = _gapArray;
                [self showNextTKView];
            } else if (_judgeArray != nil) {//判断
                _dataSourceArray = _judgeArray;
                [self showPDView];
            } else if (_SubjectiveArray != nil) {//主观
                _dataSourceArray = _SubjectiveArray;
                [self showZGView];
            } else {//如果能走到这里来  说明 只有单选题 而且 是最后一题
                [MBProgressHUD showSuccess:@"已经是最后一题了" toView:self.view];
                return;
            }
           
        }
        
    } else if (_dataSourceArray == _multipleArray) {//多选题
        if (_Number == _multipleArray.count - 1) {//说明是最后一题了
            
            _Number = -1;
            if (_gapArray != nil) {//填空
                _dataSourceArray = _gapArray;
                [self showNextTKView];
            } else if (_judgeArray != nil) {//判断
                _dataSourceArray = _judgeArray;
                [self showPDView];
            } else if (_SubjectiveArray != nil) {//主观
                _dataSourceArray = _SubjectiveArray;
                [self showZGView];
            } else {//如果能走到这里来  说明 只有单选题 而且 是最后一题
                [MBProgressHUD showSuccess:@"已经是最后一题了" toView:self.view];
                return;
            }

        }
        
    } else if (_dataSourceArray == _gapArray) {//提空题
        if (_Number == _gapArray.count - 1) {//说明是最后一题了
            
            _Number = -1;
            if (_judgeArray != nil) {//判断
                _dataSourceArray = _judgeArray;
                [self showPDView];
            } else if (_SubjectiveArray != nil) {//主观
                _dataSourceArray = _SubjectiveArray;
                [self showZGView];
            } else {//如果能走到这里来  说明 只有单选题 而且 是最后一题
                [MBProgressHUD showSuccess:@"已经是最后一题了" toView:self.view];
                return;
            }
            
        } else {//此时还是填空题
            
            
            NSString *TSting = _dataSourceArray[_Number + 1][@"question_content"];
            NSString *titleStr = [self filterHTML:TSting];
            [self TKSetIntroductionText:titleStr];
            
            //设置输入框的位置和提交按钮的位置
            _TKTextField.frame = CGRectMake(15, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth - 80, 30);
            if ([_formWhere isEqualToString:@"123"]) {
                _TKTextField.text = _myTKAnswerArray[_Number + 1];
            }
            
            if (_formStr) {//答题卡过来
                NSLog(@"%ld",_Number);
                if ([_TKAnswerArray[_Number] isEqualToString:@""]) {
                    
                } else {
                    _TKTextField.text = _TKAnswerArray[_Number + 1];
                }
            }
            
//            if (_formType == nil) {//就是还没有答题卡界面
//                NSLog(@"%ld",_Number);
//                if (_TKAnswerArray.count >= _Number + 1) {
//                    NSLog(@"%@",_TKAnswerArray[_Number + 1]);
//                    _TKTextField.text = _TKAnswerArray[_Number + 1];
//                }
//            }
            
            _TJButton.frame = CGRectMake(MainScreenWidth - 60, CGRectGetMaxY(_TKTopView.frame), 50, 30);
            _CKDALabel.text = [NSString stringWithFormat:@"参考答案：%@",_TKRightAnswer[_Number + 1]];
            if ([_TKRightAnswer[_Number + 1] isEqualToString:_myTKAnswerArray[_Number + 1]]) {
                [_TKFalseButton setTitle:@" 答对了" forState:UIControlStateNormal];
                [_TKFalseButton setImage:Image(@"考试系统开心@2x") forState:UIControlStateNormal];
            } else {
                [_TKFalseButton setTitle:@" 答错了" forState:UIControlStateNormal];
                [_TKFalseButton setImage:Image(@"考试系统难过@2x") forState:UIControlStateNormal];
            }
            
            NSString *JXString = _dataSourceArray[_Number + 1][@"question_qsn_guide"];
            [self TKJXTitleIntroductionText:JXString];
            
            _TKJXView.frame = CGRectMake(0, CGRectGetMaxY(_TJButton.frame) + 30, MainScreenWidth, CGRectGetHeight(_TKJXLabel.frame));

        }
        
    } else if (_dataSourceArray == _judgeArray) {//判断题

        if (_Number == _judgeArray.count - 1) {//说明是最后一道题
            
            _Number = -1;
            if (_SubjectiveArray != nil) {//主观
                _dataSourceArray = _SubjectiveArray;
                [self showZGView];
            } else {//如果能走到这里来  说明  而且 是最后一题
                [MBProgressHUD showSuccess:@"已经是最后一题了" toView:self.view];
                _Number = 0;
                return;
            }

        } else {
            [self showPDView];
        }

    } else if (_dataSourceArray == _SubjectiveArray) {
        if (_Number == _SubjectiveArray.count - 1) {
            [MBProgressHUD showSuccess:@"已经是最后一题了" toView:self.view];
            _Number ++;
            [self addAnswerZG];
            return;
        } else {//主观题
            
            NSString *TSting = _dataSourceArray[_Number + 1][@"question_content"];
            
            [self ZGSetIntroductionText:TSting];

            //设置输入框的位置
            
            _ZGXSView.frame = CGRectMake(0, CGRectGetMaxY(_ZGTopView.frame), MainScreenWidth, 300);
            

            
            if ([_formWhere isEqualToString:@"123"]) {
                 _textView.text = _myZGAnswerArray[_Number + 1];
            }
            
//            else if (_formStr != nil) {
//                _textView.text = _ZGAnswerArray[_Number + 1];
//
//                
//            } else {
//                
//                if (_ZGAnswerArray.count > _Number + 1) {
//                }
//                
//            }
            
            if (_formStr) {//说明是从答题卡过来的
                
                if (![_ZGAnswerArray[_Number] isEqualToString:@""]) {//不为空
                    _textView.text = _ZGAnswerArray[_Number + 1];
                } else {//为空
                   
                }
            }
            

            //在最后一题可以不用隐藏了
//            if (_Number >= _SubjectiveArray.count - 1) {
//                _photosView.hidden = NO;
//            } else {
//                 _photosView.hidden = YES;
//                 _TJImageButton.frame = CGRectMake(10, 130, 80, 80);
//            }
            

             _photosView.hidden = NO;
            _photosView.hidden = YES;
            _TJImageButton.frame = CGRectMake(10, 130, 80, 80);
           
            
            NSString *JXStr = [NSString stringWithFormat:@"参考答案：%@", _dataSourceArray[_Number + 1][@"question_qsn_guide"]];
            [self ZGJXIntroductionText:JXStr];
            
        }
        
    }
    
    
    _Number ++;
    
    //把当前题的答案放入数组中
    if (_dataSourceArray == _singleArray) {//单选
//        if (!_DXAnswerArray.count < _DXRightAnswer.count) {//
//            [self addAnswerDX];
//        }
         [self addAnswerDX];
        
    } else if (_dataSourceArray == _multipleArray) {//多选
        NSLog(@"-----%@",_XZArray);
        if (_Number == 0) {
            [self addAnswerDX];
        } else {
             [self addAnswerDDX];
        }
 
    } else if (_dataSourceArray == _gapArray) {//填空题
        
        if (_Number == 0) {
            [self addAnswerDDX];
        } else {
            [self addAnswerTK];
        }
        
    }else if (_dataSourceArray == _judgeArray) {//判断题
        
        if (_Number == 0) {
            [self addAnswerTK];
        } else {
            [self addAnswerPD];
        }
    } else if (_dataSourceArray == _SubjectiveArray) {//主观题
        if (_Number == 0) {
            [self addAnswerPD];
        } else {
            [self addAnswerZG];
        }
    }
    
    [_tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//这个方法再次刷新 保证头部的空间跟自适应 一致
        [_tableView reloadData];
    });
    
    
}

- (void)showUpTKView {
    
    //现在是填空题，显示填空题的试图
    _tableView.hidden = YES;
    _TKView.hidden = NO;
    _ZGView.hidden = YES;
    
    
    NSString *TSting = _dataSourceArray[_Number - 1][@"question_content"];
    NSString *titleStr = [self filterHTML:TSting];
    [self TKSetIntroductionText:titleStr];
    
    //设置输入框的位置和提交按钮的位置
    _TKTextField.frame = CGRectMake(15, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth - 80, 30);
    if ([_formWhere isEqualToString:@"123"]) {
        _TKTextField.text = _myTKAnswerArray[_Number - 1];
    }
    
    if (_formType == nil) {//就是还没有答题卡界面
        if (_TKAnswerArray.count >= _Number + 1) {
            _TKTextField.text = _TKAnswerArray[_Number - 1];
            
        }
    }
    
    _TJButton.frame = CGRectMake(MainScreenWidth - 60, CGRectGetMaxY(_TKTopView.frame), 50, 30);
    _CKDALabel.text = [NSString stringWithFormat:@"参考答案：%@",_TKRightAnswer[_Number - 1]];
    
    if ([_TKRightAnswer[_Number - 1] isEqualToString:_myTKAnswerArray[_Number - 1]]) {
        [_TKFalseButton setTitle:@" 答对了" forState:UIControlStateNormal];
        [_TKFalseButton setImage:Image(@"考试系统开心@2x") forState:UIControlStateNormal];
    } else {
        [_TKFalseButton setTitle:@" 答错了" forState:UIControlStateNormal];
        [_TKFalseButton setImage:Image(@"考试系统难过@2x") forState:UIControlStateNormal];
    }
    
    
    NSString *JXString = _dataSourceArray[_Number - 1][@"question_qsn_guide"];
    [self TKJXTitleIntroductionText:JXString];
    
    _TKJXView.frame = CGRectMake(0, CGRectGetMaxY(_TJButton.frame) + 30, MainScreenWidth, CGRectGetHeight(_TKJXLabel.frame));
    
}

- (void)showNextTKView {
    _tableView.hidden = YES;
    _TKView.hidden = NO;
    _ZGView.hidden = YES;
    
    
    NSString *TSting = _dataSourceArray[_Number + 1][@"question_content"];
    
    NSString *titleStr = [self filterHTML:TSting];
    [self TKSetIntroductionText:titleStr];
    
    //设置输入框的位置和提交按钮的位置
    _TKTextField.frame = CGRectMake(15, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth - 80, 30);
    
    if ([_formWhere isEqualToString:@"123"]) {
        _TKTextField.text = _myTKAnswerArray[_Number + 1];
    }
    if (_formType == nil) {//就是还没有答题卡界面
        
        if (_TKAnswerArray.count > _Number + 1) {
            _TKTextField.text = _TKAnswerArray[_Number + 1];
        }
        NSLog(@"123");
    }
    
    //            if (_formStr) {//从答题卡过来的
    //
    //            }
    
    
    
    _TJButton.frame = CGRectMake(MainScreenWidth - 60, CGRectGetMaxY(_TKTopView.frame), 50, 30);
    
    _CKDALabel.text = [NSString stringWithFormat:@"参考答案：%@",_TKRightAnswer[_Number + 1]];
    
    if ([_TKRightAnswer[_Number + 1] isEqualToString:_myTKAnswerArray[_Number + 1]]) {
        [_TKFalseButton setTitle:@" 答对了" forState:UIControlStateNormal];
        [_TKFalseButton setImage:Image(@"考试系统开心@2x") forState:UIControlStateNormal];
    } else {
        [_TKFalseButton setTitle:@" 答错了" forState:UIControlStateNormal];
        [_TKFalseButton setImage:Image(@"考试系统难过@2x") forState:UIControlStateNormal];
    }
    
    
    NSString *JXString = _dataSourceArray[_Number + 1][@"question_qsn_guide"];
    [self TKJXTitleIntroductionText:JXString];
    
    _TKJXView.frame = CGRectMake(0, CGRectGetMaxY(_TKJXLabel.frame), MainScreenWidth, CGRectGetHeight(_TKJXLabel.frame));
}

- (void)showPDView {
    _tableView.hidden = NO;
    _TKView.hidden = YES;
    _ZGView.hidden = YES;
}
- (void)showZGView {
    _tableView.hidden = YES;
    _TKView.hidden = YES;
    _ZGView.hidden = NO;

}

//添加单选答案
- (void)addAnswerDX {
    
    NSLog(@"_XZArray-----%@",_XZArray);
    //遍历数组
    for (int i = 0 ; i < _XZArray.count ; i ++) {
        NSString *Str = _XZArray[i];
        if ([Str isEqualToString:@"1"]) {//选中的答案
            NSString *AStr = [NSString stringWithFormat:@"%d",i + 1];
            [_DXAnswerArray addObject:AStr];
            break;//  因为是单选 直接跳出循环
        } else {
            
            
            if (_DXAnswerArray.count == _DXRightAnswer.count) {//说明是来修改的
                NSString *AStr = [NSString stringWithFormat:@"%d",i + 1];
                [_DXAnswerArray replaceObjectAtIndex:_Number withObject:AStr];
            } else {
                if (i == _XZArray.count - 1) {//遍历如果没有答案的话，就在最后一个的时候传个空值在数组里面
                    [_DXAnswerArray addObject:@""];
                }
            }
            
            
           
            
        }
    }
    
    
    NSLog(@"_DXAnswerArray-------%@",_DXAnswerArray);
    
    //将数组全部设为0 （这个方法在网络请求成功里面调用）
    [_XZArray removeAllObjects];
    for (int i = 0 ; i < 8; i ++) {
        [_XZArray addObject:@"0"];
    }

    NSLog(@"_XZArray-----%@",_XZArray);
}

//添加多选答案
- (void)addAnswerDDX {
   
    _isYes = NO;//初始化数组的状态 （每次进来就会重置为NO）
     //遍历数组（这个方法是来监听数组中是否全为0）
    for (int i = 0 ; i < _XZArray.count ; i ++) {
        NSString *Str = _XZArray[i];
        if ([Str isEqualToString:@"0"]) {
            
        } else {
            _isYes = YES;
        }
    }
    
    if (_isYes == NO) {//数组全为0 的时候 说明需要传个空值到数组
        [_DDXAnswerArray addObject:@""];
        
    } else {//数组中有答案的时候
        
        //创建个可变数组
        NSMutableArray *DAArray = [NSMutableArray array];
        NSString *DAStr = nil;
        
        NSArray *ABCDArray = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H"];
        for (int i = 0 ; i < _XZArray.count ; i ++) {
            NSString *Str = _XZArray[i];
            if ([Str isEqualToString:@"1"]) {//选中的答案
                NSString *AStr;
                AStr = [NSString stringWithFormat:@"%@",ABCDArray[i]];
                [DAArray addObject:AStr];
                
            } else {
                
                
            }
        }
        
        //将答案全部加数组中 拆开答案用-隔开
        for (int i = 0 ; i < DAArray.count ; i ++) {
            if (i == 0) {
                DAStr = DAArray[0];
            } else {
                DAStr = [NSString stringWithFormat:@"%@-%@",DAStr,DAArray[i]];
                
            }
        }
        
        //将多选答案字符串添加到数组中
        [_DDXAnswerArray addObject:DAStr];
        

    }
    
    NSLog(@"_DXAnswerArray--------%@",_DXAnswerArray);
    NSLog(@"_DDXAnswerArray-------%@",_DDXAnswerArray);

}

//添加填空题的答案
- (void)addAnswerTK {
    NSLog(@"----%@",_TKTextField.text);
    
//    if (_TKAnswerArray.count < _Number) {
//         [_TKAnswerArray addObject:_TKTextField.text];
//    } else if (_Number == 0) {
//          [_TKAnswerArray addObject:_TKTextField.text];
//    } else {
//          [_TKAnswerArray replaceObjectAtIndex:_Number - 1 withObject:_TKTextField.text];
//    }
    
//     [_TKAnswerArray addObject:_TKTextField.text];
    
    if (_formStr) {//从答题卡过来 说明数据都是齐全的
        NSLog(@"NUmber----%ld",_Number);
        
        if (_Number == 0) {
            if ([_TKAnswerArray[_TKAnswerArray.count - 1] isEqualToString:@""]) {
                 [_TKAnswerArray replaceObjectAtIndex:_TKAnswerArray.count -1 withObject:_TKTextField.text];
            }
            
        } else {
            
            if ([_TKAnswerArray[_Number - 1] isEqualToString:@""]) {
                 [_TKAnswerArray replaceObjectAtIndex:_Number -1 withObject:_TKTextField.text];
            }
 
        }

    }
    
   
    NSLog(@"_TKAnswerArray-----%@",_TKAnswerArray);
    
    if (_formStr == nil && _formType == nil) {//最先答题的时候
        [_TKAnswerArray addObject:_TKTextField.text];
         _TKTextField.text = @"";
    }
    
//    if (_formType == nil) {//就是还没有答题卡界面
//        
//        
//        
//        if (_Number == 1) {
//            
//            if (_TKAnswerArray.count > 1) {
//                
//            } else {
//                 _TKTextField.text = @"";
//            }
//
//        }
//        
//    }
}

//添加判断题的答案
- (void)addAnswerPD {
    

    
    if (_formStr == nil && _formWhere == nil) {//还没有进入答题卡的时候
        //遍历数组
        for (int i = 0 ; i < _XZArray.count ; i ++) {
            NSString *Str = _XZArray[i];
            if ([Str isEqualToString:@"1"]) {//选中的答案
                NSString *AStr = [NSString stringWithFormat:@"%d",i + 1];
                [_PDAnswerArray addObject:AStr];
                break;//  因为是单选 直接跳出循环
            } else {
                
                if (i == _XZArray.count - 1) {//遍历如果没有答案的话，就在最后一个的时候传个空值在数组里面
                    [_PDAnswerArray addObject:@""];
                }
                
            }
        }
    }
//
//    if (_formStr) {//答题卡回来
//        
//    }
    
    NSLog(@"_PDAnswerArray-------%@",_PDAnswerArray);
    
    //将数组全部设为0 （这个方法在网络请求成功里面调用）
    [_XZArray removeAllObjects];
    for (int i = 0 ; i < 8; i ++) {
        [_XZArray addObject:@"0"];
    }

}

//主观题的答案添加
- (void)addAnswerZG {
    
    NSLog(@"textView-----%@",_textView.text);
   
    
    NSLog(@"%ld",_Number);
    NSLog(@"%ld",_ZGAnswerArray.count);
    
    
    if (_formStr) {//说明是答题卡过来  说明数据个数是全的
       
        if ([_ZGAnswerArray[_Number -1] isEqualToString:@""]) {//为空的时候替换
                [_ZGAnswerArray replaceObjectAtIndex:_Number - 1 withObject:_textView.text];
        } else {//不为空的时候不做操作
            
        }


        
    } else if (!_formStr) {//说明是最先答题
        [_ZGAnswerArray addObject:_textView.text];

    } else if ([_formWhere isEqualToString:@"123"]) {//测评报告来
        
    }

    
    
    NSLog(@"_ZGAnswerArray----%@",_ZGAnswerArray);
    if (_Number >= _SubjectiveArray.count - 1) {
         [self NetWorkGetImageID];
    } else {
//         [self NetWorkGetImageID];
    }
   
    [_photosView removeImage];
    //清空照片
    _imageArray = nil;
//    [_SubjectiveImageArray addObject:_imageArray];

//    NSLog(@"_SubjectiveImageArray------%@",_SubjectiveImageArray);
//    
//    NSLog(@"%@",_SubjectiveImageArray[0]);
    
//    [_photosView addImage:_SubjectiveImageArray[0]];
    
//    [_TJImageButton setBackgroundImage:Image(_SubjectiveImageArray[0][@"UIImage"]) forState:UIControlStateNormal];
    _TJImageButton.frame = CGRectMake(10, 130, 80, 80);
    
    if (_formType == nil) {//还没有去到答题卡界面
        
        if (_Number == 1) {
            
            if (_ZGAnswerArray.count > 1) {
                
            } else {
                _textView.text = @"";
            }
            
        }

    }
    
    if (_Number == _SubjectiveArray.count) {//这里是防止在最后一题的时候——Number一直上涨
        _Number --;
    }
   
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
    TKView.contentSize = CGSizeMake(0, MainScreenHeight * 2);
    [self.view addSubview:TKView];

    _TKView = TKView;
    _TKView.hidden = YES;
    if ([_formType isEqualToString:@"3"]) {//测评报告过来 (让填空题的试图显示出来）
        _TKView.hidden = NO;
        _tableView.hidden = YES;
        _ZGView.hidden = YES;
    }
    
    _TKTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100)];
    [_TKView addSubview:_TKTopView];
    
    _TKTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth - 20, 100)];
    NSString *TSting = _dataSourceArray[_Number][@"question_content"];
    NSString *titleStr = [self filterHTML:TSting];
    
    [self TKSetIntroductionText:titleStr];
    _TKTitleLabel.font = Font(18);
    _TKTitleLabel.textColor = [UIColor colorWithRed:125.f / 255 green:125.f / 255 blue:125.f / 255 alpha:1];
    [_TKTopView addSubview:_TKTitleLabel];

    
    
    //添加输入框
    _TKTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_TKTopView.frame), MainScreenWidth - 80, 30)];
    _TKTextField.layer.cornerRadius = 5;
    _TKTextField.layer.borderWidth = 1;
    _TKTextField.layer.borderColor = PartitionColor.CGColor;
    _TKTextField.placeholder = @"如果有两个答案请用,隔开";
    _TKTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    //设置显示模式为永远显示(默认不显示)
    _TKTextField.leftViewMode = UITextFieldViewModeAlways;
    _TKTextField.textColor = XXColor;
    if ([_formWhere isEqualToString:@"123"]) {
        _TKTextField.text = _myTKAnswerArray[_Number];
    }

//    _TKTextField.text = _myTKAnswerArray[_Number];
    [TKView addSubview:_TKTextField];
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TKTextField:) name:UITextFieldTextDidChangeNotification object:nil];
    
    //添加提交按钮
    UIButton *TJButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, CGRectGetMaxY(_TKTopView.frame), 50, 30)];
    [TJButton setTitle:@"提交" forState:UIControlStateNormal];
    [TJButton setTitleColor:BasidColor forState:UIControlStateNormal];
    TJButton.layer.cornerRadius = 5;
    TJButton.layer.borderWidth = 1;
    TJButton.layer.borderColor = BasidColor.CGColor;
    [TKView addSubview:TJButton];
    _TJButton = TJButton;
    
    if ([_formWhere isEqualToString:@"123"]) {
        [self addTKJXView];
    }
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
    CKDALabel.textColor = BlackNotColor;
    [TKJXView addSubview:CKDALabel];
    _CKDALabel = CKDALabel;
    
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
    if ([_dataSourceArray[_Number][@"question_answer"] isEqualToString:_myTKAnswerArray[_Number]]) {
        [falseButton setTitle:@" 答对了" forState:UIControlStateNormal];
        [falseButton setImage:Image(@"考试系统开心@2x") forState:UIControlStateNormal];
    }
    _TKFalseButton = falseButton;

    
    
    //添加自适应文本(填空解析文本）
    UILabel *TKJXLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, MainScreenWidth - 20, 100)];
    TKJXLabel.text = _dataSourceArray[_Number][@"question_qsn_guide"];
    TKJXLabel.font = Font(18);
    TKJXLabel.textColor = BlackNotColor;

    [TKJXView addSubview:TKJXLabel];
    _TKJXLabel = TKJXLabel;
    _TKJXView = TKJXView;

    [self TKJXTitleIntroductionText:_TKJXLabel.text];
    
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
    if ([_formType isEqualToString:@"5"]) {//测评报告过来 (让填空题的试图显示出来）
        _TKView.hidden = YES;
        _tableView.hidden = YES;
        _ZGView.hidden = NO;
    }
    
    //添加滚动试图
    _ZGScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 60)];
    _ZGScrollView.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight + 20 );
    [_ZGView addSubview:_ZGScrollView];
    
    
    
    //添加题目
    _ZGTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100)];
    _ZGTopView.backgroundColor = [UIColor colorWithRed:242.f / 255 green:242.f / 255 blue:242.f / 255 alpha:1];
    [_ZGScrollView addSubview:_ZGTopView];
    
    
    _ZGTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth - 20, 100)];
    NSString *TSting = _SubjectiveArray[_Number][@"question_content"];
    [self ZGSetIntroductionText:TSting];
    _ZGTitleLabel.font = Font(18);
    _ZGTitleLabel.textColor = [UIColor colorWithRed:125.f / 255 green:125.f / 255 blue:125.f / 255 alpha:1];
    [_ZGTopView addSubview:_ZGTitleLabel];
    
    
    //添加叙述view
    UIView *XSView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_ZGTopView.frame), MainScreenWidth, 300)];
    XSView.backgroundColor = [UIColor whiteColor];
    [_ZGScrollView addSubview:XSView];
    _ZGXSView = XSView;
    
    //添加textView
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, MainScreenWidth, 100)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.font = Font(16);
    
    
    [XSView addSubview:_textView];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextView:) name:UITextViewTextDidChangeNotification object:nil];
    
    //添加个文本
    _ZGTXLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, MainScreenWidth, 20)];
    _ZGTXLabel.text = @"详细叙述提交内容，切换下一题自动提交";
    _ZGTXLabel.textColor = [UIColor lightGrayColor];
    [_textView addSubview:_ZGTXLabel];
    
    //从测评报告过来显示主观题自己的答案
    if ([_formWhere isEqualToString:@"123"]) {
        _textView.text = _myZGAnswerArray[_Number];
        if (_textView.text.length != 0) {
            _ZGTXLabel.hidden = YES;
        }
    }

    
    //添加展示图片的View
    _photosView = [[PhotosView alloc] initWithFrame:CGRectMake(0, 100, MainScreenWidth, 230)];
    _photosView.backgroundColor = [UIColor whiteColor];
    _photosView.hidden = YES;
    _photosView.userInteractionEnabled = YES;
    [XSView addSubview:_photosView];
    
    
    //添加添加图片的按钮
    UIButton *TJButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 130, 80, 80)];
    [TJButton setBackgroundImage:Image(@"主观添加图片@2x") forState:UIControlStateNormal];
    [TJButton addTarget:self action:@selector(TJImageButton:) forControlEvents:UIControlEventTouchUpInside];
    [XSView addSubview:TJButton];
    _TJImageButton = TJButton;

    //添加主观题的解析界面
    _ZGJXLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_ZGXSView.frame), MainScreenWidth - 20, 230)];
    NSString *HHHStr = [NSString stringWithFormat:@"参考答案：%@",_dataSourceArray[_Number][@"question_qsn_guide"]];
//    _ZGJXLabel.text = HHHStr;
    [_ZGScrollView addSubview:_ZGJXLabel];
    _ZGJXLabel.numberOfLines = 0;
    _ZGJXLabel.font = Font(16);
    NSLog(@"HHHStr-----%@",HHHStr);
    NSLog(@"_ZGJXLabel-----%@",_ZGJXLabel.text);
    [self ZGJXIntroductionText:HHHStr];
    _ZGJXLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
  
    _ZGJXLabel.hidden = YES;
    if ([_formWhere isEqualToString:@"123"]) {//测评报告过来
        _ZGJXLabel.hidden = NO;
    }
    
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

    _ZGJXLabel.frame = CGRectMake(_ZGJXLabel.frame.origin.x,_ZGJXLabel.frame.origin.y, MainScreenWidth, labelSize.size.height);
    
    //计算出自适应的高度
    _ZGJXLabel.frame = CGRectMake(10, CGRectGetMaxY(_ZGXSView.frame), MainScreenWidth - 20, labelSize.size.height);

    
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


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){//进入相册
        //创建图片选取控制器
        UIImagePickerController * imagePickerVC =[[UIImagePickerController alloc]init];
        [imagePickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePickerVC setAllowsEditing:YES];
        imagePickerVC.delegate=self;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
        
        
        
    }else if (buttonIndex == 1){//相机拍照
        
        UIImagePickerController * imagePickerVC =[[UIImagePickerController alloc]init];
        [imagePickerVC setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePickerVC setAllowsEditing:YES];
        imagePickerVC.delegate=self;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
        
        
    }
}

//回调方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image = [info valueForKey:@"UIImagePickerControllerEditedImage"];
    [self.photosView addImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
    _photosView.hidden = NO;
    //设置添加图片按钮的位置
    
    CGFloat Space = 10;
    NSInteger Num = 3;
    CGFloat imageW = (MainScreenWidth - (Num + 1) * Space) / Num;
    CGFloat imageH = imageW;
    
    NSArray *imageArray = [_photosView totalImages];
    _imageArray = imageArray;
    NSInteger allNum = imageArray.count;
    NSLog(@"-----%ld",allNum);
    _TJImageButton.frame = CGRectMake(Space + Space * (allNum % Num) + imageW * (allNum % Num), (imageH + Space) * (allNum / Num) + 100, imageW, imageH);
    if (allNum == 1) {//当只有一个的时候
        //添加图片的按钮应该和图片一样大
        _TJImageButton.frame = CGRectMake(150 + Space * 2, 100, 150, 150);
        
    }
}



- (void)TextView:(NSNotification *)not {
    if (_textView.text.length > 0) {
        _ZGTXLabel.hidden = YES;
    } else {
        _ZGTXLabel.hidden = NO;
    }
    NSLog(@"length----%@",_textView.text);
}


//获得图片的ID
- (void)NetWorkGetImageID {
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];

    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    
    NSLog(@"%@",dic);

//    [manager KSXTTJImage:dic image:^(id<AFMultipartFormData> formData) {
//        //上传图片
//        NSArray *images = [self.photosView totalImages];
//    
//        if (images.count != 0) {
//            for (UIImage *imgae in images) {
//                NSData *dataImg=UIImageJPEGRepresentation(imgae, 0.5);
//                [formData appendPartWithFileData:dataImg name:@"face" fileName:@"image.png" mimeType:@"image/jpeg"];
//            }
//        }
//        
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"%@",responseObject);
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"%@",operation);
//    }];
    

    [manager POST:@"http://dafengche.51eduline.com/index.php?app=api&mod=Exam&act=addAttach" parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //上传图片
        NSArray *images = [self.photosView totalImages];
        
        if (images.count != 0) {
            for (UIImage *imgae in images) {
                NSData *dataImg=UIImageJPEGRepresentation(imgae, 0.5);
                [formData appendPartWithFileData:dataImg name:@"face" fileName:@"image.png" mimeType:@"image/jpeg"];
            }
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"data"]);
        if ([responseObject[@"code"] isEqual:[NSNumber numberWithInteger:1]]) {
            [_imageIDArray addObject:responseObject[@"data"][0]];
            NSLog(@"%@",_imageIDArray);
        }
      
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    

    
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
    
    NSLog(@"%@",button.titleLabel.text);
    _WZLabel.text = button.titleLabel.text;
    _typeStr = [NSString stringWithFormat:@"%ld",button.tag];
    NSLog(@"%@",_typeStr);
    [self miss];
    
    //这里判断点击的是哪种类型的相应展示哪种类型的界面
    
    if (button.tag == 1) {//单选题
        _TKView.hidden = YES;
        _tableView.hidden = NO;
        _ZGView.hidden = YES;
        _dataSourceArray = _singleArray;
    }
    if (button.tag == 2) {//多选题
        _TKView.hidden = YES;
        _tableView.hidden = NO;
        _ZGView.hidden = YES;
        _dataSourceArray = _multipleArray;
    }
    
    if (button.tag == 3) {//填空题
        _TKView.hidden = NO;
        _tableView.hidden = YES;
        _ZGView.hidden = YES;
        _dataSourceArray = _gapArray;
    }
    
    if (button.tag == 4) {//判断题
        _TKView.hidden = YES;
        _tableView.hidden = NO;
        _ZGView.hidden = YES;
        _dataSourceArray = _judgeArray;

    }
    
    if (button.tag == 5) {//主观题
        _ZGView.hidden = NO;
        _tableView.hidden = YES;
        _TKView.hidden = YES;
        _dataSourceArray = _SubjectiveArray;
    }
    
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

    NSArray *HHH = _dataSourceArray[_Number][@"option_list"];
    
//    if (!_XZArray.count) {
//        
//    } else {
//        for (int i = 0 ; i < HHH.count ; i ++) {
//            [_XZArray addObject:@"0"];
//            
//        }
//        NSLog(@"-----%@",_XZArray);
//    }
   
    return HHH.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
//    NSLog(@"%----- lf",_headView.bounds.size.height);
//    NSLog(@"--_HeadH-----%lf",_headH);
    return _headH;
}

//添加表格头部试图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
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
    
    //计算出自适应的高度
    _headView.frame = CGRectMake(0, 0, self.view.bounds.size.width, labelSize.size.height + 20);
    [_headView addSubview:_titleLabel];
    _headH = _headView.bounds.size.height;
    return _headView;
}

//表格底部视图的高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    if ([_formWhere isEqualToString:@"123"]) {//测评报告界面过来的
        return _footH;
    } else {
        return 0;
    }
    
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
        NSString *rightStr;
        if (_DXRightAnswer.count == 0) {
        } else {
            rightStr = _DXRightAnswer[_Number];
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
    
    if (_formWhere == nil) {//答题的时候返回nil
        return nil;
    } else {//解析答案的时候
        return _footView;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    XZTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[XZTTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }

    //答题卡过来进行判断
    if (_formStr && _dataSourceArray == _singleArray) {//单选
        NSString *answerStr = _DXAnswerArray[_Number];
        [_XZArray removeAllObjects];
        for (int i = 0; i < 8 ; i ++) {
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
        
    } else if (_formStr && _dataSourceArray == _multipleArray) {//多选
        
        NSString *answerStr = _DDXAnswerArray[_Number];
        
        NSArray *aArray = [answerStr componentsSeparatedByString:@"-"];
        NSLog(@"%@",aArray);
        
        [_XZArray removeAllObjects];
        for (int i = 0; i < 8 ; i ++) {
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
        

//        if ([answerStr isEqualToString:@""]) {//空
//            
//        } else if ([answerStr isEqualToString:@"1"]) {//
//            [_XZArray replaceObjectAtIndex:0 withObject:@"1"];
//        } else if ([answerStr isEqualToString:@"2"]) {
//            [_XZArray replaceObjectAtIndex:1 withObject:@"1"];
//        } else if ([answerStr isEqualToString:@"3"]) {
//            [_XZArray replaceObjectAtIndex:2 withObject:@"1"];
//        }

        
        
    } else if (_formStr && _dataSourceArray == _judgeArray) {//判断

//        if (_PDAnswerArray.count > _Number + 1) {
//        }
        
        NSString *answerStr = _PDAnswerArray[_Number];
        [_XZArray removeAllObjects];
        for (int i = 0; i < 8 ; i ++) {
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
        

        
    }
    
    if ([_formWhere isEqualToString:@"123"]) {//测评报告过来
        if (_dataSourceArray == _singleArray) {//单选
            NSString *myStr = _myDXAnswerArray[_Number];

            if ([myStr isEqualToString:@""]) {//空
                
            } else if ([myStr isEqualToString:@"A"]) {//
                [_XZArray replaceObjectAtIndex:0 withObject:@"1"];
            } else if ([myStr isEqualToString:@"B"]) {
                [_XZArray replaceObjectAtIndex:1 withObject:@"1"];
            } else if ([myStr isEqualToString:@"C"]) {
                [_XZArray replaceObjectAtIndex:2 withObject:@"1"];
            }

        } else if (_dataSourceArray == _multipleArray) {//多选
            
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
    

    //判断如果是解析答案的话，就设置为不能点击
    if ([_formWhere isEqualToString:@"123"]) {
        [_tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    
    if (_dataSourceArray == _singleArray) {//单选题
        
        [_XZArray removeAllObjects];
        for (int i = 0; i < 8; i++) {
            
            [_XZArray addObject:@"0"];
        }
        [_XZArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
        
        if (_formStr == nil) {//第一次答案的时候

            if (_Number == 0) {//单选第一题
                
                if (_DXAnswerArray.count) {
//                     [_DXAnswerArray replaceObjectAtIndex:_Number withObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
                    [_DXAnswerArray removeLastObject];
                }
                
            } else {
                
                if (_DXAnswerArray.count >= _Number + 1) {
                    [_DXAnswerArray removeLastObject];
                }
                
//                if (_DXAnswerArray[_Number] != nil) {
//                      [_DXAnswerArray replaceObjectAtIndex:_Number withObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
//                    [_DXAnswerArray removeLastObject];
//                }
                
            }
           
        }
        
        if ([_formStr isEqualToString:@"1"]) {//从答题卡过来 让可以重新改答案
             [_DXAnswerArray replaceObjectAtIndex:_Number withObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
        }
       
        NSLog(@"-----%@",_XZArray);

    } else if (_dataSourceArray == _multipleArray) {//多选题
        
        if ([_XZArray[indexPath.row] isEqualToString:@"1"]) {//当前就已经为选中了
            
            [_XZArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
        } else if ([_XZArray[indexPath.row] isEqualToString:@"0"]) {//当前没有选中
            
            [_XZArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
        }
        
    } else if (_dataSourceArray == _judgeArray) {//判断题的时候
        [_XZArray removeAllObjects];
        for (int i = 0; i < 8; i++) {
            
            [_XZArray addObject:@"0"];
        }
        [_XZArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
        if ([_formStr isEqualToString:@"4"]) {//从答题卡过来 让可以重新改答案
             [_PDAnswerArray replaceObjectAtIndex:_Number withObject:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
        }
    }
    
    [_tableView reloadData];
   
}

#pragma mark --- DTKViewControllerDelegate

- (void)getAllYouWantType:(NSString *)string WithNumber:(NSInteger)number {
    _formStr = string;
    
    _formNumber = number;
    NSLog(@"%@----- %ld",string,number);
}

#pragma mark --- 网络请求

//分类里面的请求
- (void)NetWorkCate {
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    
    [manager KSXTTXFL:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        _SYGArray = responseObject[@"data"];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error   %@",error);
        
        
    }];
    
    
}


- (void)getRigthAnswer {
    //单选的正确答案
    
    NSMutableArray *DXRightAnswer = [NSMutableArray array];
    for (int i = 0 ; i < _singleArray.count ; i ++) {
        NSString *answerStr = _singleArray[i][@"question_answer"];
        [DXRightAnswer addObject:answerStr];
      
    }
    _DXRightAnswer = DXRightAnswer;
    NSLog(@"%@",_DXRightAnswer);
    //多选
     NSMutableArray *DDXRightAnswer = [NSMutableArray array];
    for (int  i = 0 ; i < _multipleArray.count; i ++) {
        NSString *answerStr = _multipleArray[i][@"question_answer"];
        [DDXRightAnswer addObject:answerStr];
       
    }
    _DDXRightAnswer = DDXRightAnswer;

    //填空
    NSMutableArray *TKRightAnswer = [NSMutableArray array];
    NSLog(@"%ld",_multipleArray.count);
    for (int  i = 0 ; i < _gapArray.count; i ++) {
        NSString *answerStr = _gapArray[i][@"question_answer"];
        [TKRightAnswer addObject:answerStr];
      
    }
    _TKRightAnswer = TKRightAnswer;
    
    //判断
    NSMutableArray *PDRightAnswer = [NSMutableArray array];
    for (int  i = 0 ; i < _judgeArray.count; i ++) {
        NSString *answerStr = _judgeArray[i][@"question_answer"];
        [PDRightAnswer addObject:answerStr];
     
    }
    _PDRightAnswer = PDRightAnswer;
    
}

- (void)getEveryScore {
    
    
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
