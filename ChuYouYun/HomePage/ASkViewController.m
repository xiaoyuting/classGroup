//
//  ASkViewController.m
//  ChuYouYun
//
//  Created by IOS on 16/5/30.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "ASkViewController.h"
#import "UIColor+HTMLColors.h"
#import "NewView.h"
#import "HotView.h"
#import "WaitReplay.h"


#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width


@interface ASkViewController ()<UIScrollViewDelegate>

@property (strong ,nonatomic)UIScrollView *scrollow;

///头部视图
@property (strong, nonatomic) UIView *headerView;
///顶部btn集合
@property (strong, nonatomic) NSArray *btns;
///btn下面横条
@property (strong, nonatomic) UIView *underLine;


@end

@implementation ASkViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"问答";
    //scrollow
    [self setupHeaderRegion];
    [self setupCustomViewRegion];

}

#pragma mark - 设置头部区域
- (void)setupHeaderRegion{
    
    //自定义segment区域
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0 +(MainScreenWidth/3)*i,64, MainScreenWidth/3, 40)];
        if(i == 1){
            //mainBtn
            [btn setTitle:@"最热" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#50a6fc"] forState:UIControlStateNormal];

        }else if(i == 2){
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

            [btn setTitle:@"待回复" forState:UIControlStateNormal];
        }else{
        
            [btn setTitle:@"最新" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];


        }

        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        //UIColor *color = [UIColor colorWithHexString:@"#50a6fc"];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(selectedOneCustomView:) forControlEvents:UIControlEventTouchUpInside];
        [arr addObject:btn];
    }
    self.btns = [arr copy];
    //下划线设置
    self.underLine = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth/6-25,100,50, 1)];
    self.underLine.backgroundColor = [UIColor colorWithHexString:@"#50a6fc"];
    [self.view insertSubview:self.underLine aboveSubview:self.btns[0]];
}

#pragma mark - 设置三板块view
- (void)setupCustomViewRegion{
    
    self.scrollow = [[UIScrollView alloc] initWithFrame:CGRectMake(0,104, MainScreenWidth, MainScreenHeight -104)];
    self.scrollow.backgroundColor = [UIColor clearColor];
    self.scrollow.contentSize = CGSizeMake(MainScreenWidth*3, self.scrollow.bounds.size.height);
    self.scrollow.delegate = self;
    self.scrollow.pagingEnabled = YES;
    self.scrollow.showsHorizontalScrollIndicator = NO;
    self.scrollow.contentOffset = CGPointMake(MainScreenWidth, 0);
    [self.view addSubview:self.scrollow];
    
    //我
    NewView *mineView = [[NewView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, self.scrollow.bounds.size.height)];
    [self.scrollow addSubview:mineView];
    //主版块main
    HotView *mainView = [[HotView alloc] initWithFrame:CGRectMake(MainScreenWidth, 0, MainScreenWidth, self.scrollow.bounds.size.height)];
    
    [self.scrollow addSubview:mainView];
    //发现
    WaitReplay *findView = [[WaitReplay alloc] initWithFrame:CGRectMake(MainScreenWidth*2, 0, MainScreenWidth, self.scrollow.bounds.size.height)];
    [self.scrollow addSubview:findView];
}

//滚动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    CGRect frame = self.underLine.frame;
    frame.origin.x = offset.x/3+MainScreenWidth/6-25;
    self.underLine.frame = frame;
}

#pragma mark - 头部区域btn点击事件
- (void)selectedOneCustomView:(UIButton *)sender{
    for (int i=0; i<3; i++) {
       
        UIButton *btn = self.btns[i];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i==sender.tag) {
            [btn setTitleColor:[UIColor colorWithHexString:@"#50a6fc"] forState:UIControlStateNormal];

        }
    }

    NSLog(@"选择了 %ld",sender.tag);
    self.scrollow.contentOffset = CGPointMake(MainScreenWidth*(sender.tag), 0);
    switch (sender.tag) {
        case 0:{//我
            CGRect frame = self.underLine.frame;
            frame.origin.x = MainScreenWidth/6-25;
            [UIView animateWithDuration:0.2 animations:^{
                self.underLine.frame = frame;
            }];
            break;
        }
        case 1:{//主版块
            CGRect frame = self.underLine.frame;
            frame.origin.x = MainScreenWidth/3+MainScreenWidth/6-25;
            [UIView animateWithDuration:0.2 animations:^{
                self.underLine.frame = frame;
            }];
        }
            break;
        case 2:{//发现
            CGRect frame = self.underLine.frame;
            frame.origin.x = MainScreenWidth*2/3+MainScreenWidth/6-25;
            [UIView animateWithDuration:0.2 animations:^{
                self.underLine.frame = frame;
            }];
        }
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
