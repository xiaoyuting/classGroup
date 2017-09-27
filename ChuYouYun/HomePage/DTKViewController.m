//
//  DTKViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/13.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import "DTKViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "CPBGViewController.h"

@interface DTKViewController ()

@property (strong ,nonatomic)UIView *YDView;//引导视图

@property (strong ,nonatomic)UIView *DXView;//单选试图

@property (strong ,nonatomic)UIScrollView *scrollView;//整体的滚动试图

@property (strong ,nonatomic)UIView *DDXView;//多选试图

@property (strong ,nonatomic)UIView *TKView;//填空试图

@property (strong ,nonatomic)UIView *PDView;//判断试图

@property (strong ,nonatomic)UIView *ZGView;//主观视图

@property (assign ,nonatomic)NSInteger DXNumber;//单选题的个数

@property (assign ,nonatomic)NSInteger DDXNumber;//多选题的个数

@property (assign ,nonatomic)NSInteger TKNumber;//填空题的个数

@property (assign ,nonatomic)NSInteger PDNumber;//判断题的个数

@property (assign ,nonatomic)NSInteger DTNumber;//答题的个数

@property (assign ,nonatomic)NSInteger Min;//答题的分钟数

@end

@implementation DTKViewController


-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFace];
    [self addNav];
    [self addYDView];//引导试图
    [self addSrcollView];
    [self addDXView];//单选视图
    [self addDDXView];
    [self addTKView];
    [self addPDView];
//    [self addZGView];
}

- (void)initFace {
    self.view.backgroundColor = [UIColor whiteColor];

    _DTNumber = 0;
    
    _DXNumber = _DXAnswerArray.count;
    _DDXNumber = _DDXAnswerArray.count;
    _TKNumber = _TKAnswerArray.count;
    _PDNumber = _PDAnswerArray.count;
    
    NSLog(@"_DXAnswerArray-------%@",_DXAnswerArray);
    
    for (int i = 0; i < _DXNumber; i ++) {
        NSString *Str = _DXAnswerArray[i];
        if (![Str isEqualToString:@""]) {
            _DTNumber ++;
        }
    }
    
    for (int i = 0; i < _DDXNumber; i ++) {
        NSString *Str = _DDXAnswerArray[i];
        if (![Str isEqualToString:@""]) {
            _DTNumber ++;
        }

    }
    
    for (int i = 0; i < _TKNumber; i ++) {
        NSString *Str = _TKAnswerArray[i];
        if (![Str isEqualToString:@""]) {
            _DTNumber ++;
        }
        
    }
    
    for (int i = 0; i < _PDNumber; i ++) {
        NSString *Str = _PDAnswerArray[i];
        if (![Str isEqualToString:@""]) {
            _DTNumber ++;
        }
        
    }
    
    NSLog(@"_DTNumber-----%ld",_DTNumber);
    
    //计算用了多少分钟
    
    if (_timePassing % 60 == 0) {//能整除
        _Min = _timePassing / 60;
    } else {
        _Min = _timePassing / 60 + 1;
    }
    
    
    
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
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 30, 25, 60, 30)];
    WZLabel.text = @"答题卡";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
//    _WZLabel = WZLabel;
    
    //添加按钮
    UIButton *JJButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 90, 25, 80, 30)];
    JJButton.backgroundColor = [UIColor clearColor];
    [JJButton setTitle:@"确认交卷" forState:UIControlStateNormal];
    JJButton.titleLabel.font = Font(16);
    [JJButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [JJButton addTarget:self action:@selector(JJButton) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:JJButton];
    
    
    
}

//确认交卷
- (void)JJButton {

    CPBGViewController *CPBGVC = [[CPBGViewController alloc] init];
    CPBGVC.dataSource = _dataSource;
    CPBGVC.DXAnswerArray = _DXAnswerArray;
    NSLog(@"%@",_DXAnswerArray);
    CPBGVC.DDXAnswerArray = _DDXAnswerArray;
    CPBGVC.TKAnswerArray = _TKAnswerArray;
    CPBGVC.PDAnswerArray = _PDAnswerArray;
    [self.navigationController pushViewController:CPBGVC animated:YES];
    
}


- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addYDView {
    _YDView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 70)];
    _YDView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_YDView];
    
    //添加线
     UILabel *HLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 69, MainScreenWidth, 1)];
    HLabel.backgroundColor = [UIColor redColor];
    [_YDView addSubview:HLabel];
    
    NSArray *YDArray = @[@"已答题",@"未答题"];
    for (int i = 0 ; i < 2 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, 20 + (i % 2) * 20 , 25, 10)];
        button.backgroundColor = BasidColor;
        if (i == 1) {
            button.backgroundColor = [UIColor lightGrayColor];
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
    [_YDView addSubview:ZJLabel];
    
    NSString *Str1 = [NSString stringWithFormat:@"%@",_dataSource[@"data"][@"count"]];
    NSString *Str2 = [NSString stringWithFormat:@"%ld",_DTNumber];
    NSString *Str3 = [NSString stringWithFormat:@"%ld分钟",_Min];
    ZJLabel.text = [NSString stringWithFormat:@"共%@题，已答%@题，用时%@",Str1,Str2,Str3];
    if (iPhone4SOriPhone4 || iPhone5o5Co5S) {
        ZJLabel.font = Font(14);
    } else if (iPhone6) {
        ZJLabel.font = Font(16);
    } else {
        ZJLabel.font = Font(18);
    }
    
    //设置字体的颜色
    
    NSMutableAttributedString *noteStr1 = [[NSMutableAttributedString alloc] initWithString:ZJLabel.text];
    [noteStr1 addAttribute:NSForegroundColorAttributeName value:JHColor range:NSMakeRange(1, Str1.length)];
    [noteStr1 addAttribute:NSForegroundColorAttributeName value:JHColor range:NSMakeRange(5 + Str1.length, Str2.length)];
    [noteStr1 addAttribute:NSForegroundColorAttributeName value:JHColor range:NSMakeRange(9 + Str1.length + Str2.length, Str3.length)];
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
    
    for (int i = 0 ; i < Count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(Space + Space * 2 * (i % Num) + ButtonW * (i % Num),  50 + Space + (Space + ButtonH) * (i / Num), ButtonW, ButtonH)];
        button.backgroundColor = BasidColor;
        if ([_DXAnswerArray[i] isEqualToString:@""]) {
            button.backgroundColor = [UIColor lightGrayColor];
        }
        
        NSString *titleStr = [NSString stringWithFormat:@"%d",i + 1];
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
        button.tag = i + 1;
        [button addTarget:self action:@selector(getDelegate:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = ButtonW / 2 ;
        [_DXView addSubview:button];
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
        button.backgroundColor = BasidColor;
        
        if ([_DDXAnswerArray[i] isEqualToString:@""]) {
            button.backgroundColor = [UIColor lightGrayColor];
        }
        
        NSString *titleStr = [NSString stringWithFormat:@"%d",i + 1];
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
        button.tag = _DXNumber + i + 1;
        [button addTarget:self action:@selector(getDelegate:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = ButtonW / 2 ;
        [_DDXView addSubview:button];
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
        button.backgroundColor = BasidColor;
        
        if ([_TKAnswerArray[i] isEqualToString:@""]) {
            button.backgroundColor = [UIColor lightGrayColor];
        }
        
        NSString *titleStr = [NSString stringWithFormat:@"%d",i + 1];
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
        button.tag = _DXNumber + _DDXNumber + i + 1;
        [button addTarget:self action:@selector(getDelegate:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = ButtonW / 2 ;
        [_TKView addSubview:button];
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
        button.backgroundColor = BasidColor;
        
        if ([_PDAnswerArray[i] isEqualToString:@""]) {
            button.backgroundColor = [UIColor lightGrayColor];
        }
        
        NSString *titleStr = [NSString stringWithFormat:@"%d",i + 1];
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
        button.tag = _DXNumber + _DDXNumber + _TKNumber + i + 1;
        [button addTarget:self action:@selector(getDelegate:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = ButtonW / 2 ;
        [_PDView addSubview:button];
    }
    
    if (Count % Num == 0) {//能整除
        _PDView.frame = CGRectMake(0, CGRectGetMaxY(_TKView.frame), MainScreenWidth, 50 + Space + (Space + ButtonH) * (Count / Num));
    } else {//不能整除
        _PDView.frame = CGRectMake(0, CGRectGetMaxY(_TKView.frame), MainScreenWidth, 50 + Space + (Space + ButtonH) * (Count / Num + 1));
    }

    //设置滚动范围
     _scrollView.contentSize = CGSizeMake(MainScreenWidth, CGRectGetMaxY(_PDView.frame) + 70 + 64);
    
}


//主观视图
- (void)addZGView {
    _ZGView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_PDView.frame), MainScreenWidth, 250)];
    _ZGView.backgroundColor = [UIColor greenColor];
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
    NSInteger Count = 0;
    
    for (int i = 0 ; i < Count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(Space + Space * 2 * (i % Num) + ButtonW * (i % Num),  50 + Space + (Space + ButtonH) * (i / Num), ButtonW, ButtonH)];
        button.backgroundColor = BasidColor;
        NSString *titleStr = [NSString stringWithFormat:@"%d",i + 1];
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(getDelegate:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = ButtonW / 2 ;
        [_ZGView addSubview:button];
    }
    
    if (Count % Num == 0) {//能整除
        _ZGView.frame = CGRectMake(0, CGRectGetMaxY(_PDView.frame), MainScreenWidth, 50 + Space + (Space + ButtonH) * (Count / Num));
    } else {//不能整除
        _ZGView.frame = CGRectMake(0, CGRectGetMaxY(_PDView.frame), MainScreenWidth, 50 + Space + (Space + ButtonH) * (Count / Num + 1));
    }

    //设置滚动试图滚动的范围
    
    if (Count == 0) {
        _ZGView.frame = CGRectMake(0, CGRectGetMaxY(_PDView.frame), MainScreenWidth, 0);
    }
    
    _scrollView.contentSize = CGSizeMake(MainScreenWidth, CGRectGetMaxY(_ZGView.frame) + 70 + 64);
    
}


#pragma mark --- DTKViewControllerDelegate

- (void)getDelegate:(UIButton *)button
{
    
    NSInteger number = [button.titleLabel.text integerValue];
    
    NSInteger buttonTag = button.tag;
    
    NSLog(@"%ld",number);
    
    NSString *typeStr;
    
    if (buttonTag <= _DXNumber) {
        typeStr = @"1";
    } else if (buttonTag <= _DXNumber + _DDXNumber) {
        typeStr = @"2";
    } else if (buttonTag <= _DXNumber + _DDXNumber + _TKNumber) {
        typeStr = @"3";
    } else if (buttonTag <= _DXNumber +_DDXNumber + _TKNumber + _PDNumber) {
        typeStr = @"4";
    }
    
   
    
    if (self.delegate) {
        [self.delegate getAllYouWantType:typeStr WithNumber:number];
    }
    
    [self backPressed];
}

@end
