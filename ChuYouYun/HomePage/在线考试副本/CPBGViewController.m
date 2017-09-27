//
//  CPBGViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/14.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import "CPBGViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "DTViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "TIXingLable.h"
#import "UIColor+HTMLColors.h"


@interface CPBGViewController ()

@property (strong ,nonatomic)UIView *YDView;//引导视图

@property (strong ,nonatomic)UIScrollView *scrollView;//整体的滚动试图

@property (strong ,nonatomic)UIView *DXView;//单选试图

@property (strong ,nonatomic)UIView *DDXView;//多选试图

@property (strong ,nonatomic)UIView *TKView;//填空试图

@property (strong ,nonatomic)UIView *PDView;//判断试图

@property (strong ,nonatomic)UIView *ZGView;//主观视图

@property (assign ,nonatomic)NSInteger Score;//总分

@property (assign ,nonatomic)NSInteger DXNumber;//单选题的个数

@property (assign ,nonatomic)NSInteger DDXNumber;//多选题的个数

@property (assign ,nonatomic)NSInteger TKNumber;//填空题的个数

@property (assign ,nonatomic)NSInteger PDNumber;//判断题的个数

@property (assign ,nonatomic)NSInteger ZGNumber;//主观题的个数

@property (assign ,nonatomic)NSInteger DXEveryScore;

@property (assign ,nonatomic)NSInteger DDXEveryScore;

@property (assign ,nonatomic)NSInteger TKEveryScore;

@property (assign ,nonatomic)NSInteger PDEveryScore;

@property (assign ,nonatomic)NSInteger getAllScore;

@property (assign ,nonatomic)NSInteger DXRightNum;

@property (assign ,nonatomic)NSInteger DDXRightNum;

@property (assign ,nonatomic)NSInteger TKRightNum;

@property (assign ,nonatomic)NSInteger PDRightNum;

@property (assign ,nonatomic)NSInteger AllRightNum;

@property (assign ,nonatomic)NSInteger AllNum;//试卷总题个数

@property (strong ,nonatomic)NSString *paperID;//试卷ID

@property (strong ,nonatomic)NSDictionary *allDic;

@property (strong ,nonatomic)UILabel *ZJLabel;//总结分数的文本

@property (strong ,nonatomic)NSString *DXStr;

@property (strong ,nonatomic)NSString *DDXStr;

@property (strong ,nonatomic)NSString *TKStr;

@property (strong ,nonatomic)NSString *PDStr;

@property (strong ,nonatomic)NSArray *singleArray;//单选题数据

@property (strong ,nonatomic)NSArray *multipleArray;//多选题数据

@property (strong ,nonatomic)NSArray *gapArray;//填空题数据

@property (strong ,nonatomic)NSArray *judgeArray;//判断题的数据

@property (strong ,nonatomic)NSMutableArray *singleIDArray;

@property (strong ,nonatomic)NSMutableArray *multipleIDArray;

@property (strong ,nonatomic)NSMutableArray *gapIDArray;

@property (strong ,nonatomic)NSMutableArray *judgeIDArray;

@property (strong ,nonatomic)NSMutableArray *SubjectiveIDArray;//主观题id

@property (strong ,nonatomic)NSString *questionList_DX;

@property (strong ,nonatomic)NSString *questionList_DDX;

@property (strong ,nonatomic)NSString *questionList_TK;

@property (strong ,nonatomic)NSString *questionList_PD;

@property (strong ,nonatomic)NSString *questionList_ZG;

@property (strong ,nonatomic)NSString *questionList_ALL;

@end

@implementation CPBGViewController

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
    [self getScore];
    [self initFace];
    [self addNav];
    [self addYDView];
    [self addSrcollView];
    [self addDXView];
    [self addDDXView];
    [self addTKView];
    [self addPDView];
    if (_SubjectiveArray.count) {
        [self addZGView];
    }
    [self getAnswerIdArray];
    [self getAnswerStr];
    [self NetWorkData];
    [self NetWorkDetail];
}

- (void)initFace {
    
    self.view.backgroundColor = [UIColor whiteColor];
    _Score = [_dataSource[@"data"][@"score"] integerValue];
    _paperID = _dataSource[@"data"][@"paper_id"];
    _AllNum = [_dataSource[@"data"][@"count"] integerValue];;
    NSLog(@"%@",_paperID);
    NSLog(@"%ld",_AllNum);
    _DXNumber = _DXAnswerArray.count;
    _DDXNumber = _DDXAnswerArray.count;
    _TKNumber = _TKAnswerArray.count;
    _PDNumber = _PDAnswerArray.count;
    _ZGNumber = _SubjectiveArray.count;
    
    //因为正确答案跟自己的答案个数都是一样的
    NSInteger DXRightNum = 0;
    NSInteger DXAllScore = 0;
    for (int i = 0 ; i < _DXRightAnswer.count ; i ++) {
        NSString *myStr = _DXAnswerArray[i];
        NSString *rightStr = _DXRightAnswer[i];
        
        if ([myStr isEqualToString:rightStr]) {//说明是对的
            DXRightNum ++;
            DXAllScore = DXRightNum *_DXEveryScore;
        }
    }
    _DXRightNum = DXRightNum;
    
    //多选
    NSInteger DDXRightNum = 0;
    NSInteger DDXAllScore = 0;
    for (int i = 0 ; i < _DDXRightAnswer.count ; i ++) {
        NSString *myStr = _DDXAnswerArray[i];
        NSString *rightStr = _DDXRightAnswer[i];
        
        if ([myStr isEqualToString:rightStr]) {//说明是对的
            DDXRightNum ++;
            DDXAllScore = DDXRightNum *_DDXEveryScore;
        }
    }

    _DDXRightNum = DDXRightNum;
    //填空
    
    
    NSInteger TKRightNum = 0;
    NSInteger TKAllScore = 0;
    for (int i = 0 ; i < _TKRightAnswer.count ; i ++) {
        NSString *myStr = _TKAnswerArray[i];
        NSString *rightStr = _TKRightAnswer[i];
        
        if ([myStr isEqualToString:rightStr]) {//说明是对的
            TKRightNum ++;
            TKAllScore = TKRightNum *_TKEveryScore;
        }
    }
    _TKRightNum = TKRightNum;
    
    NSInteger PDRightNum = 0;
    NSInteger PDAllScore = 0;
    for (int i = 0 ; i < _PDRightAnswer.count ; i ++) {
        NSString *myStr = _PDAnswerArray[i];
        NSString *rightStr = _PDRightAnswer[i];
        
        if ([myStr isEqualToString:rightStr]) {//说明是对的
            PDRightNum ++;
            PDAllScore = PDRightNum *_PDEveryScore;
        }
    }
    _PDRightNum = PDRightNum;
    _getAllScore = DXAllScore + DDXAllScore + TKAllScore + PDAllScore;
    _AllRightNum = 0;
    _AllRightNum = _DXRightNum + _DDXRightNum + _TKRightNum + _PDRightNum;

    //初始化ID数组
    _singleIDArray = [NSMutableArray array];
    _multipleIDArray = [NSMutableArray array];
    _gapIDArray = [NSMutableArray array];
    _judgeIDArray = [NSMutableArray array];
    _SubjectiveIDArray = [NSMutableArray array];
    
}

- (void)getScore {
    NSArray *FuckArray = _dataSource[@"data"][@"question"];
    
    NSInteger Count = FuckArray.count;
    
    for (int i = 0 ; i < Count; i ++) {
        NSString *Str = FuckArray[i][@"question_type_id"];
        if ([Str isEqualToString:@"1"]) {//单选题
            _singleArray = FuckArray[i][@"question_list"];
            
            NSInteger DXAllScore = [FuckArray[i][@"score"] integerValue];
            NSInteger DXAllNum = [FuckArray[i][@"sum"] integerValue];
            _DXEveryScore = DXAllScore / DXAllNum;
            NSLog(@"%ld",_DXEveryScore);
            
        } else if ([Str isEqualToString:@"2"]) {//多选题
            _multipleArray = FuckArray[i][@"question_list"];
            
            NSInteger DDXAllScore = [FuckArray[i][@"score"] integerValue];
            NSInteger DDXAllNum = [FuckArray[i][@"sum"] integerValue];
            _DDXEveryScore = DDXAllScore / DDXAllNum;
            NSLog(@"%ld",_DDXEveryScore);
            
            
        } else if ([Str isEqualToString:@"3"]) {//提空题
            _gapArray = FuckArray[i][@"question_list"];
            
            NSInteger TKAllScore = [FuckArray[i][@"score"] integerValue];
            NSInteger TKAllNum = [FuckArray[i][@"sum"] integerValue];
            _TKEveryScore = TKAllScore / TKAllNum;
            NSLog(@"%ld",_TKEveryScore);
            
        } else if ([Str isEqualToString:@"4"]) {//判断题
            _judgeArray = FuckArray[i][@"question_list"];
            
            NSInteger PDAllScore = [FuckArray[i][@"score"] integerValue];
            NSInteger PDAllNum = [FuckArray[i][@"sum"] integerValue];
            _PDEveryScore = PDAllScore / PDAllNum;
            NSLog(@"%ld",_PDEveryScore);
        }
        
    }

    
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
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 60, 30)];
    WZLabel.text = @"测评报告";
    [WZLabel setTextColor:BasidColor];
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    //    _WZLabel = WZLabel;

}


- (void)backPressed {
//    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)addYDView {
    _YDView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 70)];
    _YDView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_YDView];
    
    //添加线
    UILabel *HLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 69, MainScreenWidth, 1)];
    HLabel.backgroundColor = [UIColor redColor];
    [_YDView addSubview:HLabel];
    
    NSArray *YDArray = @[@"已答对",@"未答对"];
    for (int i = 0 ; i < 2 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, 20 + (i % 2) * 20 , 25, 10)];
        button.backgroundColor = TrueColor;
        if (i == 1) {
            button.backgroundColor = FalseColor;
        }
        [_YDView addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 20 + (i % 2) * 20 , 40, 10)];
        label.text = YDArray[i];
        label.font = Font(13);
        label.textColor = [UIColor lightGrayColor];
        [_YDView addSubview:label];
        
    }
    
    
    //添加总结
    UILabel *ZJLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 20, MainScreenWidth - 125, 30)];
    ZJLabel.backgroundColor = [UIColor whiteColor];
    ZJLabel.font = Font(17);
    [_YDView addSubview:ZJLabel];
    
    NSString *Str1 = [NSString stringWithFormat:@"%ld",_Score];
    NSString *Str2 = [NSString stringWithFormat:@"%@",_gradeStr];
    NSString *Str3 = [NSString stringWithFormat:@"%ld",_getAllScore];
    ZJLabel.text = [NSString stringWithFormat:@"总分%@分，及格%@分，你得%@分",Str1,Str2,Str3];
    if (iPhone4SOriPhone4 || iPhone5o5Co5S) {
        ZJLabel.font = Font(14);
    } else if (iPhone6) {
        ZJLabel.font = Font(16);
    } else {
        ZJLabel.font = Font(18);
    }

    //设置字体的颜色
    
    NSMutableAttributedString *noteStr1 = [[NSMutableAttributedString alloc] initWithString:ZJLabel.text];
    [noteStr1 addAttribute:NSForegroundColorAttributeName value:JHColor range:NSMakeRange(2, Str1.length)];
    [noteStr1 addAttribute:NSForegroundColorAttributeName value:JHColor range:NSMakeRange(6 + Str1.length, Str2.length)];
    [noteStr1 addAttribute:NSForegroundColorAttributeName value:JHColor range:NSMakeRange(10 + Str1.length + Str2.length, Str3.length)];
    [ZJLabel setAttributedText:noteStr1] ;
    
    
}

- (void)addSrcollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 134, MainScreenWidth, MainScreenHeight)];
    _scrollView.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight * 2);
    [self.view addSubview:_scrollView];
}


//单选视图
- (void)addDXView {
    _DXView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 250)];
    _DXView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_DXView];
    
    UIButton *YDButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, 6, 20)];
    YDButton.backgroundColor = BasidColor;
    [_DXView addSubview:YDButton];
    
    UILabel *DXLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 100, 20)];
    DXLabel.text = @"单选题";
    DXLabel.backgroundColor = [UIColor clearColor];
    [_DXView addSubview:DXLabel];
    
    //添加按钮
    NSInteger Num = 5;
    CGFloat ButtonH = 40;
    CGFloat ButtonW = 40;
    CGFloat Space = (MainScreenWidth - Num * ButtonW) / 10;
    NSInteger Count = _singleArray.count;
    NSLog(@"-----%ld",Count);
    
    for (int i = 0 ; i < Count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(Space + Space * 2 * (i % Num) + ButtonW * (i % Num),  50 + Space + (Space + ButtonH) * (i / Num), ButtonW, ButtonH)];
        button.backgroundColor = TrueColor;
        
        NSString *myStr = _DXAnswerArray[i];
        NSString *rightStr = _DXRightAnswer[i];
        
        if (![rightStr isEqualToString:myStr]) {//说明答案不正确
            button.backgroundColor = FalseColor;
        }
        
        NSString *titleStr = [NSString stringWithFormat:@"%d",i + 1];
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = ButtonW / 2 ;
        [_DXView addSubview:button];
        button.tag = i + 1;
        [button addTarget:self action:@selector(backDT:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (Count % Num == 0) {//能整除
        _DXView.frame = CGRectMake(0, 0, MainScreenWidth, 50 + Space + (Space + ButtonH) * (Count / Num));
    } else {//不能整除
        _DXView.frame = CGRectMake(0, 0, MainScreenWidth, 50 + Space + (Space + ButtonH) * (Count / Num + 1));
    }

    
}



//多选视图
- (void)addDDXView {
    _DDXView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_DXView.frame), MainScreenWidth, 250)];
    _DDXView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_DDXView];
    
    UIButton *YDButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, 6, 20)];
    YDButton.backgroundColor = BasidColor;
    [_DDXView addSubview:YDButton];
    
    UILabel *DXLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 100, 20)];
    DXLabel.text = @"多选题";
    DXLabel.backgroundColor = [UIColor clearColor];
    [_DDXView addSubview:DXLabel];
    
    //添加按钮
    NSInteger Num = 5;
    CGFloat ButtonH = 40;
    CGFloat ButtonW = 40;
    CGFloat Space = (MainScreenWidth - Num * ButtonW) / 10;
    NSInteger Count = _multipleArray.count;
    
    for (int i = 0 ; i < Count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(Space + Space * 2 * (i % Num) + ButtonW * (i % Num),  50 + Space + (Space + ButtonH) * (i / Num), ButtonW, ButtonH)];
        button.backgroundColor = TrueColor;
        
        NSString *myStr = _DDXAnswerArray[i];
        NSString *rightStr = _DDXRightAnswer[i];
        
        if (![rightStr isEqualToString:myStr]) {//说明答案不正确
            button.backgroundColor = FalseColor;
        }

        
        NSString *titleStr = [NSString stringWithFormat:@"%d",i + 1];
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = ButtonW / 2 ;
        [_DDXView addSubview:button];
        button.tag = _DXNumber + i + 1;
        [button addTarget:self action:@selector(backDT:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (Count % Num == 0) {//能整除
        _DDXView.frame = CGRectMake(0, CGRectGetMaxY(_DXView.frame), MainScreenWidth, 50 + Space + (Space + ButtonH) * (Count / Num));
    } else {//不能整除
        _DDXView.frame = CGRectMake(0, CGRectGetMaxY(_DXView.frame), MainScreenWidth, 50 + Space + (Space + ButtonH) * (Count / Num + 1));
    }
    

    
    
}


//填空视图
- (void)addTKView {
    _TKView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_DDXView.frame), MainScreenWidth, 250)];
    _TKView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_TKView];
    
    UIButton *YDButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, 6, 20)];
    YDButton.backgroundColor = BasidColor;
    [_TKView addSubview:YDButton];
    
    UILabel *DXLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 100, 20)];
    DXLabel.text = @"填空题";
    DXLabel.backgroundColor = [UIColor clearColor];
    [_TKView addSubview:DXLabel];
    
    //添加按钮
    NSInteger Num = 5;
    CGFloat ButtonH = 40;
    CGFloat ButtonW = 40;
    CGFloat Space = (MainScreenWidth - Num * ButtonW) / 10;
    NSInteger Count = _gapArray.count;
    
    for (int i = 0 ; i < Count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(Space + Space * 2 * (i % Num) + ButtonW * (i % Num),  50 + Space + (Space + ButtonH) * (i / Num), ButtonW, ButtonH)];
        button.backgroundColor = TrueColor;
        
        NSString *myStr = _TKAnswerArray[i];
        NSString *rightStr = _TKRightAnswer[i];
        
        if (![rightStr isEqualToString:myStr]) {//说明答案不正确
            button.backgroundColor = FalseColor;
        }

        
        NSString *titleStr = [NSString stringWithFormat:@"%d",i + 1];
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = ButtonW / 2 ;
        [_TKView addSubview:button];
        button.tag = _DXNumber + _DDXNumber + i + 1;
        [button addTarget:self action:@selector(backDT:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    if (Count % Num == 0) {//能整除
        _TKView.frame = CGRectMake(0, CGRectGetMaxY(_DDXView.frame), MainScreenWidth, 50 + Space + (Space + ButtonH) * (Count / Num));
    } else {//不能整除
        _TKView.frame = CGRectMake(0, CGRectGetMaxY(_DDXView.frame), MainScreenWidth, 50 + Space + (Space + ButtonH) * (Count / Num + 1));
    }

    
}

//判断视图
- (void)addPDView {
    _PDView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_TKView.frame), MainScreenWidth, 250)];
    _PDView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_PDView];
    
    UIButton *YDButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, 6, 20)];
    YDButton.backgroundColor = BasidColor;
    [_PDView addSubview:YDButton];
    
    UILabel *DXLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 100, 20)];
    DXLabel.text = @"判断题";
    DXLabel.backgroundColor = [UIColor clearColor];
    [_PDView addSubview:DXLabel];
    
    //添加按钮
    NSInteger Num = 5;
    CGFloat ButtonH = 40;
    CGFloat ButtonW = 40;
    CGFloat Space = (MainScreenWidth - Num * ButtonW) / 10;
    NSInteger Count = _judgeArray.count;
    
    for (int i = 0 ; i < Count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(Space + Space * 2 * (i % Num) + ButtonW * (i % Num),  50 + Space + (Space + ButtonH) * (i / Num), ButtonW, ButtonH)];
        button.backgroundColor = TrueColor;
        NSString *myStr = _PDAnswerArray[i];
        NSString *rightStr = _PDRightAnswer[i];
        
        if (![rightStr isEqualToString:myStr]) {//说明答案不正确
            button.backgroundColor = FalseColor;
        }

        
        NSString *titleStr = [NSString stringWithFormat:@"%d",i + 1];
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = ButtonW / 2 ;
        [_PDView addSubview:button];
        button.tag = _DXNumber + _DDXNumber + _TKNumber + i + 1;
        [button addTarget:self action:@selector(backDT:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (Count % Num == 0) {//能整除
        _PDView.frame = CGRectMake(0, CGRectGetMaxY(_TKView.frame), MainScreenWidth, 50 + Space + (Space + ButtonH) * (Count / Num));
    } else {//不能整除
        _PDView.frame = CGRectMake(0, CGRectGetMaxY(_TKView.frame), MainScreenWidth, 50 + Space + (Space + ButtonH) * (Count / Num + 1));
    }

    //设置滚动试图滚动的范围
    _scrollView.contentSize = CGSizeMake(MainScreenWidth, CGRectGetMaxY(_PDView.frame) + 70 + 64);
    
}


//主观视图
- (void)addZGView {
    _ZGView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_PDView.frame), MainScreenWidth, 250)];
    _ZGView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_ZGView];
    
    UIButton *YDButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, 6, 20)];
    YDButton.backgroundColor = BasidColor;
    [_ZGView addSubview:YDButton];
    
    UILabel *DXLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 100, 20)];
    DXLabel.text = @"主观题";
    DXLabel.backgroundColor = [UIColor clearColor];
    [_ZGView addSubview:DXLabel];
    
    //添加按钮
    NSInteger Num = 5;
    CGFloat ButtonH = 40;
    CGFloat ButtonW = 40;
    CGFloat Space = (MainScreenWidth - Num * ButtonW) / 10;
    NSInteger Count = _SubjectiveArray.count;
    
    for (int i = 0 ; i < Count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(Space + Space * 2 * (i % Num) + ButtonW * (i % Num),  50 + Space + (Space + ButtonH) * (i / Num), ButtonW, ButtonH)];
        button.backgroundColor = FalseColor;
//        if (i == x) {
//            button.backgroundColor = FalseColor;
//        }
        NSString *titleStr = [NSString stringWithFormat:@"%d",i + 1];
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = ButtonW / 2 ;
        button.tag = _DXNumber + _DDXNumber + _TKNumber + _ZGNumber + i + 1;
        [button addTarget:self action:@selector(backDT:) forControlEvents:UIControlEventTouchUpInside];
        [_ZGView addSubview:button];
    }
    
    if (Count % Num == 0) {//能整除
        _ZGView.frame = CGRectMake(0, CGRectGetMaxY(_PDView.frame), MainScreenWidth, 50 + Space + (Space + ButtonH) * (Count / Num));
    } else {//不能整除
        _ZGView.frame = CGRectMake(0, CGRectGetMaxY(_PDView.frame), MainScreenWidth, 50 + Space + (Space + ButtonH) * (Count / Num + 1));
    }

    
    //设置滚动试图滚动的范围
    _scrollView.contentSize = CGSizeMake(MainScreenWidth, CGRectGetMaxY(_ZGView.frame) + 70 + 64);
    
}

- (void)backDT:(UIButton *)button {

    NSInteger number = [button.titleLabel.text integerValue];
    NSLog(@"%ld",number);
    
    NSInteger buttonTag = button.tag;
    
    NSString *typeStr;
    
    if (buttonTag <= _DXNumber) {
        typeStr = @"1";
    } else if (buttonTag <= _DXNumber + _DDXNumber) {
        typeStr = @"2";
    } else if (buttonTag <= _DXNumber + _DDXNumber + _TKNumber) {
        typeStr = @"3";
    } else if (buttonTag <= _DXNumber +_DDXNumber + _TKNumber + _PDNumber) {
        typeStr = @"4";
    } else if (buttonTag <= _DXNumber +_DDXNumber + _TKNumber + _PDNumber + _ZGNumber) {
        typeStr = @"5";
    }
    DTViewController *DTVC = [[DTViewController alloc] init];
    DTVC.formWhere = @"123";
    DTVC.dataSource = _dataSource;
    DTVC.formType = typeStr;
    DTVC.formCPNumber = number;
    DTVC.myDXAnswerArray = _DXAnswerArray;
    DTVC.myDDXAnswerArray = _DDXAnswerArray;
    DTVC.myTKAnswerArray = _TKAnswerArray;
    DTVC.myPDAnswerArray = _PDAnswerArray;
    DTVC.myZGAnswerArray = _ZGAnserArray;
    [self.navigationController pushViewController:DTVC animated:YES];
}


//分类里面的请求
- (void)NetWorkData {
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)_getAllScore] forKey:@"user_score"];//得分
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)_timePassing] forKey:@"total_date"];
    [dic setObject:_endTimeStr forKey:@"total_date"];
    [dic setObject:_examID forKey:@"exam_id"];
    [dic setObject:_paperID forKey:@"paper_id"];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)_AllRightNum] forKey:@"rightcount"];
    [dic setObject:[NSString stringWithFormat:@"%ld",_AllNum - _AllRightNum] forKey:@"errorcount"];
//    [dic setObject:_questionList_ZG forKey:@"content_list"];//主观题
    
    
    //问题字符串
    [dic setObject:_questionList_ALL forKey:@"question_list"];
        [manager KSXTTJ:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}

- (void)NetWorkDetail {
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:_examID forKey:@"id"];
        [manager KSXTFXXQ:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        _allDic = responseObject[@"data"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error   %@",error);
        
        
    }];
    
}

- (void)getAnswerIdArray {
    //单选
    for (int i = 0; i < _singleArray.count; i ++) {
        NSString *DXStr = _singleArray[i][@"question_id"];
        NSLog(@"%@",DXStr);
        [_singleIDArray addObject:DXStr];
    }
    
    //多选
    for (int i = 0; i < _multipleArray.count; i ++) {
        NSString *DXStr = _multipleArray[i][@"question_id"];
        NSLog(@"%@",DXStr);
        [_multipleIDArray addObject:DXStr];
    }

//    NSLog(@"------%@",_multipleIDArray);
    //填空
    for (int i = 0; i < _gapArray.count; i ++) {
        NSString *DXStr = _gapArray[i][@"question_id"];
        NSLog(@"%@",DXStr);
        [_gapIDArray addObject:DXStr];
    }
    
    //判断

    for (int i = 0; i < _judgeArray.count; i ++) {
        NSString *DXStr = _judgeArray[i][@"question_id"];
        NSLog(@"%@",DXStr);
        [_judgeIDArray addObject:DXStr];
    }
    
    NSLog(@"%@",_judgeIDArray);
    
    //主观
    for (int i = 0; i < _SubjectiveArray.count ; i ++) {
        NSString *DXStr = _SubjectiveArray[i][@"question_id"];
        NSLog(@"%@",DXStr);
        [_SubjectiveIDArray addObject:DXStr];
    }
    NSLog(@"_SubjectiveIDArray-----%@",_SubjectiveIDArray);
    
}

//吧答案串起来
- (void)getAnswerStr {
    //单选
    
    NSLog(@"-_DXAnswerArray---%@",_DXAnswerArray);
    
    for (int i = 0 ; i < _DXAnswerArray.count ; i ++) {
        NSString *everyStr = _DXAnswerArray[i];
        if ([everyStr isEqualToString:@""]) {
            [_DXAnswerArray replaceObjectAtIndex:i withObject:@"未填"];
        }
    }
    
    for (int i = 0 ; i < _singleArray.count ; i ++) {
        
        _DXStr = [NSString stringWithFormat:@"%@-%@",_singleIDArray[i],_DXAnswerArray[i]];

        if (i == 0) {
            _questionList_DX = _DXStr;
        } else {
            _questionList_DX = [NSString stringWithFormat:@"%@+%@",_questionList_DX,_DXStr];
        }
        
          NSLog(@"_questionList---%@",_questionList_DX);
    }

    //多选
    
    for (int i = 0 ; i < _multipleArray.count ; i ++) {
        NSString *everyStr = _DDXAnswerArray[i];
        if ([everyStr isEqualToString:@""]) {
            [_DDXAnswerArray replaceObjectAtIndex:i withObject:@"未填"];
        }
    }
    
    for (int i = 0 ; i < _multipleArray.count ; i ++) {
        
        _DDXStr = [NSString stringWithFormat:@"%@-%@",_multipleIDArray[i],_DDXAnswerArray[i]];
        
        if (i == 0) {
            _questionList_DDX = _DDXStr;
        } else {
            _questionList_DDX = [NSString stringWithFormat:@"%@+%@",_questionList_DDX,_DDXStr];
        }
        
        NSLog(@"_questionList_DDX---%@",_questionList_DDX);

    }

    //填空
    
    for (int i = 0 ; i < _gapArray.count ; i ++) {
        NSString *everyStr = _TKAnswerArray[i];
        if ([everyStr isEqualToString:@""]) {
            [_TKAnswerArray replaceObjectAtIndex:i withObject:@"未填"];
        }
    }
    
    for (int i = 0 ; i < _gapArray.count ; i ++) {
        
        _TKStr = [NSString stringWithFormat:@"%@-%@",_gapIDArray[i],_TKAnswerArray[i]];
        
        if (i == 0) {
            _questionList_TK = _TKStr;
        } else {
            _questionList_TK = [NSString stringWithFormat:@"%@+%@",_questionList_TK,_TKStr];
        }
        
        NSLog(@"_questionList_TK---%@",_questionList_TK);
        
    }
    
    //判断
    for (int i = 0 ; i < _judgeArray.count ; i ++) {
        NSString *everyStr = _PDAnswerArray[i];
        if ([everyStr isEqualToString:@""]) {
            [_PDAnswerArray replaceObjectAtIndex:i withObject:@"未填"];
        }
    }
    for (int i = 0 ; i < _judgeArray.count ; i ++) {
        
        _PDStr = [NSString stringWithFormat:@"%@-%@",_judgeIDArray[i],_PDAnswerArray[i]];
        
        if (i == 0) {
            _questionList_PD = _PDStr;
        } else {
            _questionList_PD = [NSString stringWithFormat:@"%@+%@",_questionList_PD,_PDStr];
        }
        
        NSLog(@"_questionList_PD---%@",_questionList_PD);
        
    }
    
    if (_SubjectiveArray.count) {
        
    } else {//没有主管题的时候
        _questionList_ALL = [NSString stringWithFormat:@"%@+%@+%@+%@",_questionList_DX,_questionList_DDX,_questionList_TK,_questionList_PD];
        NSLog(@"_questionList_ALL-----%@",_questionList_ALL);
        return;
    }
    
    
    //主观题
    NSLog(@"%@",_imageIDArray);
    
    
    if (_imageIDArray.count == _SubjectiveArray.count) {//说明是慢的
        
    } else {
        if (!_imageIDArray.count) {
            for (int i = 0 ; i < _SubjectiveArray.count ; i ++) {
                [_imageIDArray addObject:@"SYG"];
            }
            
        }
        NSLog(@"_imageIDArray-----%@",_imageIDArray);
        
        for (int  i = 0 ; i < _SubjectiveArray.count ; i ++) {
            NSString *IDStr = _imageIDArray[i];
            if ([IDStr isEqualToString:@"SYG"]) {
                [_imageIDArray replaceObjectAtIndex:i withObject:@"0"];
            }
        }
        

    }


    NSLog(@"%@",_ZGAnserArray);
    if (!_ZGAnserArray.count) {
        for (int i = 0 ; i < _SubjectiveArray.count ; i ++) {
            [_ZGAnserArray addObject:@""];
        }
    }
    
    if (_ZGAnserArray.count< _SubjectiveArray.count ) {
        for (int i = _ZGAnserArray.count ; i < _SubjectiveArray.count ; i ++) {
            [_ZGAnserArray addObject:@""];
        }
    }
    
    for (int i = 0 ; i < _SubjectiveArray.count ; i ++) {
        
        _PDStr = [NSString stringWithFormat:@"%@+%@+%@",_SubjectiveIDArray[i],_ZGAnserArray[i],_imageIDArray[i]];
        
        if (i == 0) {
            _questionList_ZG = _PDStr;
        } else {
            _questionList_ZG = [NSString stringWithFormat:@"%@/%@",_questionList_ZG,_PDStr];
        }
        
        NSLog(@"_questionList_ZG---%@",_questionList_ZG);
        
    }

    //总问题的字符串
    _questionList_ALL = [NSString stringWithFormat:@"%@+%@+%@+%@+%@",_questionList_DX,_questionList_DDX,_questionList_TK,_questionList_PD,_questionList_ZG];
    NSLog(@"_questionList_ALL-----%@",_questionList_ALL);
    
    
}




@end
