//
//  questionViewController.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/21.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "questionViewController.h"
#import "NewQuestion.h"
#import "HotQuestion.h"
#import "replyQuestion.h"
#import "classifyViewController.h"
#import "SearchViewController.h"
#import "hooseClassify.h"
#import "SearchView.h"
#import "FBViewController.h"
#import "DLViewController.h"
#import "GLReachabilityView.h"
#import "UIColor+HTMLColors.h"
#import "AppDelegate.h"

#import "YunKeTang_questionViewController.h"


@interface questionViewController ()
{
    NewQuestion *newQ;
    HotQuestion *hotQ;
    replyQuestion *replyQ;
    CGRect rect;
    UILabel *_linelable;
}

@property (strong ,nonatomic)NSString *titleStr;

@end

@implementation questionViewController

-(id)initWithQuiztype:(NSString *)wdtype WithName:(NSString *)nameTitle
{
    self = [super init];
    if (self) {
        self.wdType = wdtype;
        self.name = nameTitle;
    }
    [self setNameTitle];
    return self;
}

- (void)backPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
}
-(void)setNameTitle{

    self.title = self.name;

}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if ([_name containsString:@"-"]) {
        self.title = [_name substringFromIndex:1];
    }else
    self.title = @"问答";
    //返回
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 22)];
    [backButton setImage:[UIImage imageNamed:@"iconfont-FH"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:back];

    UILabel *rightlab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 22)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightlab];
    //分类
    //添加分类按钮
    UIButton *FLButton = [UIButton buttonWithType:UIButtonTypeSystem];
    FLButton.frame = CGRectMake(15, 30, 20, 20);
    [FLButton setBackgroundImage:[UIImage imageNamed:@"fenleisyg"] forState:UIControlStateNormal];
    [FLButton addTarget:self action:@selector(calssifyClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *kind = [[UIBarButtonItem alloc] initWithCustomView:FLButton];

    self.navigationItem.leftBarButtonItems = @[back,right,kind];

    UIButton *searchbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [searchbutton addTarget:self action:@selector(gosearch) forControlEvents:UIControlEventTouchUpInside];

    [searchbutton setBackgroundImage:[UIImage imageNamed:@"我去"]  forState:UIControlStateNormal];
    UIBarButtonItem *speak = [[UIBarButtonItem alloc] initWithCustomView:searchbutton];
    

    [self.navigationItem setRightBarButtonItem:speak];
    
    UILabel *leftlab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,1, 22)];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftlab];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btn setBackgroundImage:[UIImage imageNamed:@"他去"] forState:0];
    UIBarButtonItem *write = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(gowrite) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.rightBarButtonItems = @[speak,left,write];

    newQ = [[NewQuestion alloc]initWithwdType:self.wdType];
    hotQ = [[HotQuestion alloc]initWithwdType:self.wdType];
    replyQ = [[replyQuestion alloc]initWithwdType:self.wdType];
    
    newQ.view.frame = CGRectMake(0, 0, self.questionView.frame.size.width, self.questionView.frame.size.height);
    [self.questionView addSubview:newQ.view];
    [self addChildViewController:newQ];
    _linelable = [[UILabel alloc]init];
    _linelable.backgroundColor = [UIColor colorWithHexString:@"#2069CF"];
    [self.btnView addSubview:_linelable];
    _linelable.frame = CGRectMake(40, 30, 30, 1);
    
}

- (void)backButton {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)questionClick:(id)sender
{
    self.clickview.backgroundColor = [UIColor clearColor];

    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            if ([self.questionView isKindOfClass:hotQ.class]) {
                [hotQ.view removeFromSuperview];
            }else if ([self.questionView isKindOfClass:replyQ.class])
            {
                [replyQ.view removeFromSuperview];
            }
            [self.questionView addSubview:newQ.view];
            [self addChildViewController:newQ];
            
            [self.NBtn setTitleColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] forState:0];
            [self.fieryBtn setTitleColor:[UIColor blackColor] forState:0];
            [self.wattingBtn setTitleColor:[UIColor blackColor] forState:0];
            [UIView animateWithDuration:0.3 animations:^{
                self.clickview.frame = CGRectMake(self.NBtn.frame.origin.x, 40, 30, 1);
                self.clickview.backgroundColor = [UIColor clearColor];
                _linelable.frame = CGRectMake(self.NBtn.frame.origin.x, self.NBtn.frame.origin.y+self.NBtn.frame.size.height +6, 30, 1);

            }];
        }
            break;
        case 2:
        {
            if ([self.questionView isKindOfClass:[newQ class]]) {
                [newQ.view removeFromSuperview];
            }else if ([self.questionView isKindOfClass:[replyQ class]])
            {
                [replyQ.view removeFromSuperview];
            }
            hotQ.view.frame = CGRectMake(0, 0, self.questionView.frame.size.width, self.questionView.frame.size.height);
            [self.questionView addSubview:hotQ.view];
            [self addChildViewController:hotQ];
            
            [self.NBtn setTitleColor:[UIColor blackColor] forState:0];
            [self.fieryBtn setTitleColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] forState:0];
            [self.wattingBtn setTitleColor:[UIColor blackColor] forState:0];
            [UIView animateWithDuration:0.3 animations:^{
                self.clickview.frame = CGRectMake(self.fieryBtn.frame.origin.x, 40, 30, 1);
                _linelable.frame = CGRectMake(self.fieryBtn.frame.origin.x, self.fieryBtn.frame.origin.y+self.fieryBtn.frame.size.height +6, 30, 1);

            }];
        }
            break;
        case 3:
        {
            if ([self.questionView isKindOfClass:newQ.class]) {
                [newQ.view removeFromSuperview];
            }else if ([self.questionView isKindOfClass:hotQ.class])
            {
                [hotQ.view removeFromSuperview];
            }
            replyQ.view.frame = CGRectMake(0, 0, self.questionView.frame.size.width, self.questionView.frame.size.height);
            [self.questionView addSubview:replyQ.view];
            [self addChildViewController:replyQ];
            
            [self.NBtn setTitleColor:[UIColor blackColor] forState:0];
            [self.fieryBtn setTitleColor:[UIColor blackColor] forState:0];
            [self.wattingBtn setTitleColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] forState:0];
            [UIView animateWithDuration:0.3 animations:^{
                self.clickview.frame = CGRectMake(self.wattingBtn.frame.origin.x, 40, 45, 1);
                _linelable.frame = CGRectMake(self.wattingBtn.frame.origin.x, self.wattingBtn.frame.origin.y+self.wattingBtn.frame.size.height +6, 45, 1);

            }];

        }
            break;

        default:
            break;
    }
}

-(void)calssifyClick{
    
    classifyViewController *classfy = [[classifyViewController alloc]init];
    
    [self.navigationController pushViewController:classfy animated:YES];
    
}
- (IBAction)classifyClick:(id)sender
{
    classifyViewController *classfy = [[classifyViewController alloc]init];
    [self.navigationController pushViewController:classfy animated:YES];
}

-(void)gowrite{
    
    FBViewController *FBVC = [[FBViewController alloc] init];
    if ([GLReachabilityView isConnectionAvailable]==1) {
        
        [self.navigationController pushViewController:FBVC animated:YES];
        
    }
    
    
    YunKeTang_questionViewController *qVc = [[YunKeTang_questionViewController alloc] init];
    [self.navigationController pushViewController:qVc animated:YES];

}
- (IBAction)writeClick:(id)sender {

    FBViewController *FBVC = [[FBViewController alloc] init];
    
    if ([GLReachabilityView isConnectionAvailable]==1) {

    [self.navigationController pushViewController:FBVC animated:YES];
    
    }
}
-(void)gosearch{
    SearchView *seach = [[SearchView alloc]init];
    if ([GLReachabilityView isConnectionAvailable]==1) {
        [self.navigationController pushViewController:seach animated:YES];
    }
    
}
- (IBAction)searchClick:(id)sender
{
    SearchView *seach = [[SearchView alloc]init];
    if ([GLReachabilityView isConnectionAvailable]==1) {
        [self.navigationController pushViewController:seach animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
