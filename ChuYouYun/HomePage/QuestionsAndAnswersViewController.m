//
//  QuestionsAndAnswersViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/30.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width


#import "QuestionsAndAnswersViewController.h"
#import "DAViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"


@interface QuestionsAndAnswersViewController ()
{
    CGRect rect;
}
@property(strong, nonatomic)DAViewController *answerTab;
@property (strong ,nonatomic)UIButton *btn;
@property (strong ,nonatomic)UIView *HDView;

@end

@implementation QuestionsAndAnswersViewController


- (void)viewWillAppear:(BOOL)animated {
  
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
//    self.myCourse.titleLabel.textColor = [UIColor blackColor];
    [self.myCourse setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
    [self addNav];
    _lineView.hidden = YES;
    NSLog(@"%@",NSStringFromCGRect(_lineView.frame));
    
    _HDView = [[UIView alloc] initWithFrame:CGRectMake(65, 98, 60, 1)];
    _HDView.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [self.view addSubview:_HDView];
    
    
    UIView *HHView = [[UIView alloc] initWithFrame:CGRectMake(0, 104, MainScreenWidth, 1)];
    HHView.backgroundColor = [UIColor colorWithRed:220.f / 255 green:220.f / 255 blue:223.f / 255 alpha:1];
    [self.view addSubview:HHView];
    
    
    
    rect = [UIScreen mainScreen].applicationFrame;
    self.navigationItem.title = @"我的问答";
    // Do any additional setup after loading the view from its nib.
//    tableView = [[DAViewController alloc]initWithQuizType:@"me"];
    self.answerTab = [[UIStoryboard storyboardWithName:@"DAViewController" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"DAView"];
    self.answerTab.view.frame = CGRectMake(0, 0, self.myView.frame.size.width, self.myView.frame.size.height);
    [self.answerTab requestData:@"me"];
    [self.myView addSubview:self.answerTab.view];
    [self addChildViewController:self.answerTab];
    self.myView.layer.borderColor = [UIColor redColor].CGColor;
    
}


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 12, 22)];
    [backButton setImage:[UIImage imageNamed:@"iconfont-FH"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"我的问答";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}




- (IBAction)changeBtn:(id)sender {
    self.activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(rect.origin.x/2-30, rect.origin.y/2-30, 30, 30)];
    self.activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.activity.hidesWhenStopped = YES;
    [self.view addSubview:self.activity];
    [self.activity startAnimating];
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue setMaxConcurrentOperationCount:1];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(runIndicator) object:nil];
    [operationQueue addOperation:operation];
    
    
    
    
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0:
        {
            [self.answerTab requestData:@"me"];
            [self.mySpecial setTitleColor:BasidColor forState:UIControlStateNormal];
            [self.myCourse setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [UIView animateWithDuration:0.1 animations:^{
                _HDView.frame = CGRectMake(self.mySpecial.frame.origin.x + 5, 98, 60, 1);
            }];

        }
            break;
        case 1:
        {
            [self.answerTab requestData:@"question"];
            
            [self.myCourse setTitleColor:BasidColor forState:UIControlStateNormal];
            [self.mySpecial setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [UIView animateWithDuration:0.1 animations:^{
//                self.lineView.center = CGPointMake( self.myCourse.frame.origin.x+35 , 30);
                   _HDView.frame = CGRectMake(self.myCourse.frame.origin.x + 5, 98, 60, 1);
            }];
        }
            break;
        default:
            break;
    }

    
    
}
-(void)runIndicator
{
    [NSThread sleepForTimeInterval:1.5];
    [self.activity stopAnimating];
}


@end
