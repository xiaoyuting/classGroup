//
//  classifyViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/24.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "classifyViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "HotViewController.h"
#import "honourViewController.h"
#import "questionViewController.h"
#import "MyHttpRequest.h"
#import "MBProgressHUD+Add.h"
#import "SYG.h"

#import "YunKeTang_questionViewController.h"


@interface classifyViewController ()
{
        CGRect rect;
    NSMutableArray *marr ;
}
@property(nonatomic,retain)NSMutableArray * dataArray2;

@end

@implementation classifyViewController

-(void)viewWillAppear:(BOOL)animated
{

    self.navigationController.navigationBar.hidden = NO;
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

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
     SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"分类选择";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 300, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,286)];
    [backButton setTitle:@" " forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    //设置button上字体的偏移量
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10.0 , 0.0, 0)];
    [SYGView addSubview:backButton];
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
}

- (void)backPressed {
    
    NSString *str1;
    NSString *str2;
    str1 = [NSString stringWithFormat:@"%d",0];
    str2 = [NSString stringWithFormat:@"%@",@"问答"];
//    questionViewController *q = [[questionViewController alloc]initWithQuiztype:str1 WithName:str2];
    YunKeTang_questionViewController *vc = [[YunKeTang_questionViewController alloc]initWithQuiztype:str1 WithName:str2];
    [self.navigationController pushViewController:vc animated:YES];}

-(void)getData{

    //网络请求下自己账户中得金额
    QKHTTPManager * manager = [QKHTTPManager manager];
    [manager getAskCategory:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //数据加载成功
        [_dataArray2 removeAllObjects];
        NSArray *array = [responseObject objectForKey:@"data"];
        [_dataArray2 addObjectsFromArray:array];
        //添加button的试图
        UIView *FLView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, MainScreenWidth, MainScreenHeight)];
        FLView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:FLView];
        
        NSArray *WZArray = @[@"一周热门",@"光荣榜"];

        marr = [[NSMutableArray alloc]init];

        for (NSDictionary * dics in _dataArray2) {
            [marr addObject:[NSString stringWithFormat:@"%@",dics[@"title"]]];
        }
        [marr addObjectsFromArray:WZArray];
        
        for (int i = 0 ; i < marr.count ; i ++) {
            
            NSString *str;
            
            if (i<marr.count) {
           
                str = [NSString stringWithFormat:@"%@",marr[i]];

            }else{
                
                str = [NSString stringWithFormat:@"%@",WZArray[i]];
            }
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(22 + (i % 2) * ((MainScreenWidth-66)/2+22), (i / 2) * 40 + (i / 2) * 35, MainScreenWidth/2-33, 40)];
            //[button setBackgroundImage:[UIImage imageNamed:FLArray[i]] forState:UIControlStateNormal];
            [FLView addSubview:button];
            [button setTitle:str forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button.layer setBorderColor:[UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1].CGColor];
            [button.layer setBorderWidth:1];
            [button.layer setMasksToBounds:YES];
            button.layer.cornerRadius = 20;
            button.tag = i;
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];}

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"数据加载失败" toView:self.view];
    }];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _dataArray2 = [[NSMutableArray alloc]init];
    [self getData];
    [self addNav];
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)btnClick:(UIButton *)btn
{
    
    NSInteger n = btn.tag;
    if (n<0) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    
        if (n==marr.count-2) {
            
        HotViewController *hot = [[HotViewController alloc]initWithwdType:[NSString stringWithFormat:@"2"] quizStr:nil tagid:nil];
        [self.navigationController pushViewController:hot animated:YES];
            
        }else if (n==marr.count -1){
            
        honourViewController *ho = [[honourViewController alloc]init];
            
        [self.navigationController pushViewController:ho animated:YES];
            
        }else{
        
            NSString *str1;
            NSString *str2;
            str1 = [NSString stringWithFormat:@"%ld",n];
            str2 = [NSString stringWithFormat:@"%@",btn.titleLabel.text];
        
            YunKeTang_questionViewController *vc = [[YunKeTang_questionViewController alloc] initWithQuiztype:str1 WithName:str2];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
    }
}


@end
