//
//  FinanceViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/3.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "FinanceViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"


@interface FinanceViewController ()

@property (strong ,nonatomic)UIScrollView *scrollView;

@end

@implementation FinanceViewController

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
    [self addScrollView];
    [self addInfoView];
    
    
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"点评返回@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"独立财务账户";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
    
    //添加横线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:button];
    
}


- (void)addScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
}

- (void)addInfoView {
    
    UILabel *reminL = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 20,MainScreenWidth - 2 * SpaceBaside, 60)];
    reminL.text = @"您可以填写您想修改的域名，我们的工作人员将在收到申请的15个工作日内审核您的申请并及时与您联系，请耐心等待，谢谢";
    reminL.numberOfLines = 3;
    reminL.font = Font(14);
    [_scrollView addSubview:reminL];

    
    
    CGFloat ViewW = MainScreenWidth - 2 *SpaceBaside;
    CGFloat ViewH = 40;
    
    NSArray *textArray = @[@"选择开户行:",@"对公账号:",@"账号开户人:",@"联系电话:",@"申请理由:",@"认证附件:"];
    
    for (int i = 0 ; i < 6; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SpaceBaside, 80 + SpaceBaside + (ViewH + SpaceBaside) * i, ViewW, ViewH)];
        if (i == 4) {
            view.frame = CGRectMake(SpaceBaside, 80 + SpaceBaside + (ViewH + SpaceBaside) * i, ViewW, ViewH * 2);
        }
        if (i == 5) {
            view.frame = CGRectMake(SpaceBaside, 80 + SpaceBaside + (ViewH + SpaceBaside) * i + ViewH, ViewW, ViewH * 2);
        }
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        [_scrollView addSubview:view];
        
        //添加文本
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 0, 80, ViewH)];
        textLabel.text = textArray[i];
        textLabel.font = Font(14);
        textLabel.textColor = [UIColor grayColor];
        [view addSubview:textLabel];
        
        
        if (i == 0) {
            
            //添加银行
            UILabel *bankL = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, MainScreenWidth - 2 * SpaceBaside - 40, ViewH)];
            bankL.text = @"请选择开户银行";
            bankL.font = Font(14);
            [view addSubview:bankL];
            
            UIButton *downButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 2 * SpaceBaside - 40, 0,40, 40)];
            [downButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
            [view addSubview:downButton];
            
        }
        
        //往上面添加东西
        if (i == 5) {//认证附件
            UIButton *adjunctButton = [[UIButton alloc] initWithFrame:CGRectMake(120, SpaceBaside / 2, 80, 30)];
            [adjunctButton setTitle:@"选中附件" forState:UIControlStateNormal];
            adjunctButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
            adjunctButton.layer.borderWidth = 1;
            adjunctButton.layer.cornerRadius = 3;
            adjunctButton.titleLabel.font = Font(15);
            adjunctButton.layer.borderColor = [UIColor grayColor].CGColor;
            [adjunctButton setTitleColor:BlackNotColor forState:UIControlStateNormal];
            [view addSubview:adjunctButton];
            
            
            //添加文本
            UILabel *adjunLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 35, MainScreenWidth - 120 - 2 * SpaceBaside, 40)];
            adjunLabel.text = @"申请独立财务账户需提交以下材料:营业执照、税务登记证、组织机构代码、对公账号相关信息";
            adjunLabel.textColor = [UIColor grayColor];
            adjunLabel.font = Font(10);
            adjunLabel.numberOfLines = 3;
            [view addSubview:adjunLabel];
            
        }
  
    }

//    //按钮
    
    CGFloat applyButtonY = SpaceBaside + 100 + (SpaceBaside + ViewH) * 6 + 2 * ViewH ;
    
    UIButton *videoButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, applyButtonY, MainScreenWidth - 2 * SpaceBaside, 40)];
    videoButton.layer.cornerRadius = 5;
    videoButton.backgroundColor = BasidColor;
    [videoButton setTitle:@"提交申请" forState:UIControlStateNormal];
    [_scrollView addSubview:videoButton];
    
    
}


#pragma mark -- 事件监听
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
