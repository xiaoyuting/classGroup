//
//  rootViewController.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/21.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "rootViewController.h"
#import "blumViewController.h"
#import "teacherViewController.h"
#import "questionViewController.h"
#import "MyViewController.h"
#import "classViewController.h"
#import "AppDelegate.h"
#import "Passport.h"
#import "videoPlayVC.h"
#import "MyNavigationController.h"
#import "MoreViewController.h"
#import "LiveViewController.h"
#import "HomeViewController.h"
#import "GLMyViewController.h"
#import "GLCategorryViewController.h"
#import "TeacherDetilViewController.h"




@interface rootViewController ()
{
    classViewController * cvc;
    blumViewController * bvc;
    teacherViewController * tvc;
    LiveViewController *qvc;
    MyViewController* mvc;
    
    UIImageView * _imageView;
}

@property (strong ,nonatomic)UIButton *seledButton;

@end

@implementation rootViewController
//创建子视图控制器
- (void)createViewController
{
    
    HomeViewController *homeVc = [[HomeViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVc];
    
//    blumViewController *weibo = [[blumViewController alloc]init];
//    UINavigationController * navi1 = [[UINavigationController alloc]initWithRootViewController:weibo];
    
//    classViewController *classVc = [[classViewController alloc] init];
//    UINavigationController *classNav = [[UINavigationController alloc] initWithRootViewController:classVc];
    
    GLCategorryViewController *storeVc = [[GLCategorryViewController alloc] init];
    UINavigationController *storeNav = [[UINavigationController alloc] initWithRootViewController:storeVc];
    
    teacherViewController * question = [[teacherViewController alloc]init];
    UINavigationController * navi3 = [[UINavigationController alloc]initWithRootViewController:question];
//    
//    LiveViewController * periodica = [[LiveViewController alloc]init];
//    UINavigationController * navi4 = [[UINavigationController alloc]initWithRootViewController:periodica];
   // periodica.title = @"问答";
    
    MoreViewController *moreVC = [[MoreViewController alloc] init];
    UINavigationController *navi6 = [[UINavigationController alloc] initWithRootViewController:moreVC];
    
    MyViewController * more = [[MyViewController alloc]init];
    UINavigationController * navi5 = [[UINavigationController alloc]initWithRootViewController:more];
    
    self.viewControllers = [NSArray arrayWithObjects:homeNav,storeNav,navi6,navi5, nil];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49)];
    _imageView.tag = 100;
    _imageView.image = [UIImage imageNamed:@"options.png"];
    [self.view addSubview:_imageView];
    
    //添加线
    UILabel *XLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0.5)];
    XLabel.backgroundColor = [UIColor colorWithRed:143.f / 255 green:143.f / 255 blue:143.f / 255 alpha:0.5];
    [_imageView addSubview:XLabel];
    
    
    NSArray *imageArray = @[@"tab_home'@2x",@"tab_classify1@2x",@"tab_found@2x",@"tab_my@2x"];
    NSArray *selectedArray = @[@"tab_home_pre@2x",@"tab_classify_pre1@2x",@"tab_found_pre@2x",@"tab_my_pre@2x"];
    
    //添加按钮
    CGFloat space = (self.view.frame.size.width-40*4)/5;
    for(int i=0;i<4;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(space+(space+40)*i, 0, 40, 49);
        //常态时按钮的图片
        UIImage * imageNol = [UIImage imageNamed:imageArray[i]];
        [btn setImage:imageNol forState:UIControlStateNormal];
        //选中状态时的图片
        UIImage * imageSelected = [UIImage imageNamed:selectedArray[i]];
        [btn setImage:imageSelected forState:UIControlStateSelected];
        
        [_imageView addSubview:btn];
        btn.tag= i+1;
        
        //设置第一个按钮为选中状态
        if (btn.tag==1) {
            [self pressBtn:btn];
        }
        //开启交互
        _imageView.userInteractionEnabled = YES;
        [btn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenTaberBar) name:@"hiddenTableBar" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backBtnClick) name:@"backBtnClick" object:nil];
    
}


-(void)backBtnClick
{
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    _imageView.alpha=1;
    // commitAnimations,将beginAnimation之后的所有动画提交并生成动画
    [UIView commitAnimations];
}

-(void)hiddenTaberBar
{
    [UIView beginAnimations:nil context:nil];
    //设置动画时长
    [UIView setAnimationDuration:0.5];
    _imageView.alpha=0;
    // commitAnimations,将beginAnimation之后的所有动画提交并生成动画
    [UIView commitAnimations];
}


- (void)pressBtn:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    self.selectedIndex = btn.tag-1;
//    UIImageView * imageView = (UIImageView *)[self.view viewWithTag:100];
//    NSArray * arr = [imageView subviews];
//    
//    for (UIButton *subBtn in  arr) {
//        if (subBtn.tag==btn.tag) {
//            subBtn.selected=YES;
//        }
//        else{
//            subBtn.selected = NO;
//        }
//    }
    self.seledButton.selected = NO;
    btn.selected = YES;
    self.seledButton = btn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *plistPath = [Passport filePath];
    NSDictionary * _users = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if ([[_users objectForKey:@"userface"] isEqual:[NSNull null]]) {
        
    }
    [self createViewController];
    //隐藏系统tabbar
    [self.tabBar setHidden:YES];
}

-(void)isHiddenCustomTabBarByBoolean:(BOOL)boolean
{
    _imageView.hidden = boolean;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
