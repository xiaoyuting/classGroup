//
//  ZhongChouViewController.m
//  dafengche
//
//  Created by IOS on 16/10/13.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "ZhongChouViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "UIView+Utils.h"
#import "ZhongChouTableViewCell.h"
#import "GLZCTableViewCell.h"

@interface ZhongChouViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIScrollViewAccessibilityDelegate>

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSArray *lookArray;

@property (strong ,nonatomic)UIScrollView *scrollView;
@property (strong ,nonatomic)UIPageControl *pageControl;

@property (strong ,nonatomic)NSMutableArray *imageArr;

@property (assign ,nonatomic)NSInteger currentIndex;

@end

@implementation ZhongChouViewController


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
    [self addTableView];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
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
    WZLabel.text = @"众筹";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
    UIButton *SXButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 30, 32, 20, 20)];
    [SXButton setBackgroundImage:[UIImage imageNamed:@"资讯分类@2x"] forState:UIControlStateNormal];
    [SXButton addTarget:self action:@selector(ShopCateButton) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:SXButton];
}
//分类
-(void)ShopCateButton{
    
    NSLog(@"分类");
}
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 120;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f7f8f8"];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [_tableView registerClass:[GLZCTableViewCell class] forCellReuseIdentifier:@"GLZCTableViewCell"];

}
#pragma mark -- 添加滚动轮播图

- (void)addTeacherScrollView{
    _imageArr = [NSMutableArray array];
    
    //_imageArr = @[@"你好",@"我好",@"他好",@"你好",@"大家好"];
    
    _scrollView.contentSize = CGSizeMake(MainScreenWidth * 4, 0);
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    for (int i = 0 ; i < 4; i ++) {
        
        UIButton *firstBtn = [[UIButton alloc] initWithFrame:CGRectMake(10+MainScreenWidth*i, 0,(MainScreenWidth-42)/2,(MainScreenWidth-42)*85/278)];
        firstBtn.tag = 10+i*2;
        [firstBtn addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *secondBtn = [[UIButton alloc] initWithFrame:CGRectMake(firstBtn.current_x_w+22, 0, (MainScreenWidth-42)/2, (MainScreenWidth-42)*85/278)];
        secondBtn.tag = 10+i*2+1;
        [secondBtn addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [firstBtn setImage:Image(@"你好") forState:UIControlStateNormal];
        [_scrollView addSubview:firstBtn];
        [secondBtn setImage:Image(@"我好") forState:UIControlStateNormal];
        [_scrollView addSubview:secondBtn];
        
    }
}

-(void)touchBtn:(UIButton *)sender{
    
    NSLog(@"%ld",sender.tag);
}

#pragma mark -- UITableViewDatasoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!indexPath.section) {
        
        return 130*MainScreenWidth/375;
    }else{
        if (MainScreenWidth <375) {
            return 120;
        }else
            return 120*MainScreenWidth/375;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!section) {
        
        return MainScreenWidth/2+39;
    }else
        return 39;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        
        return 1;
    }else
        return 3;
    //return _lookArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section>0) {
        
        if (MainScreenWidth<375) {
            ZhongChouTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZhongChouTableViewCell"];

            if (!cell) {
            NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"ZhongChouTableViewCell" owner:nil options:nil];
            cell = [cellArr objectAtIndex:0];
            cell.btnClickBlock = ^{
                NSLog(@"000000000");
                //[weakSelf initData];
            };
                
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
            }
            return cell;

        }else{
        
            static NSString *cellID = @"GLZCTableViewCell";

            GLZCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];

//        if (!cell) {
            cell = [[GLZCTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];

                cell.buttonClickBlock = ^{
                    NSLog(@"000000000");
                    //[weakSelf initData];
                };
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        }
           // cell.backgroundColor = [UIColor cyanColor];
 
        return cell;
            
        }
    }else{
        
        static NSString *cellID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,MainScreenWidth, (MainScreenWidth-42)*85/278)];
        [self addTeacherScrollView];
       // _scrollView.backgroundColor = [UIColor cyanColor];

        self.currentIndex = 0;
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(MainScreenWidth/2 - 50,_scrollView.current_y_h + 10, 40, 20)];
        self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
        self.pageControl.currentPage = self.currentIndex;
        self.pageControl.numberOfPages = 4;
        self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:102/255.0 green:51/255.0 blue:0/255.0 alpha:1];
        //self.pageControl.backgroundColor = [UIColor cyanColor];
        [cell.contentView addSubview:_scrollView];
        [cell addSubview:self.pageControl];

        return cell;
    }
    return nil;
}

#pragma mark 结束拖拽代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //动画改变当前页码
    [UIView animateWithDuration:0.5 animations:^{
        
        
    }completion:^(BOOL finished) {
        
        NSLog(@"%f",_scrollView.contentOffset.x/MainScreenWidth);
        self.pageControl.currentPage = _scrollView.contentOffset.x/MainScreenWidth;

    }];}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"点击了ecell");
}
#pragma mark -- 头部视图

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (!section) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenWidth/2+40)];
        UIButton *headerImgBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenWidth/2)];
        //[headerImgBtn setImage:[UIImage imageNamed:@"女生.png"] forState:UIControlStateNormal];
        [headerImgBtn setBackgroundImage:[UIImage imageNamed:@"大家好"] forState:UIControlStateNormal];
        [view addSubview:headerImgBtn];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UILabel *titlleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, headerImgBtn.current_y_h, MainScreenWidth-30, 40)];
        titlleLab.text = @"热门众筹";
        //titlleLab.font = [UIFont systemFontOfSize:14];
        titlleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        [view addSubview:titlleLab];
        return view;
        
    }else{
        
        UIView *otherview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 40)];
        UILabel *titlleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 40)];
        titlleLab.text = @"文学创作";
        // titlleLab.font = [UIFont systemFontOfSize:15];
        titlleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        [otherview addSubview:titlleLab];
        //更多按钮
        UILabel *titlelable = [[UILabel alloc]initWithFrame:CGRectMake(MainScreenWidth-50, 12, 27, 15)];
        titlelable.text = @"更多";
        titlelable.font = [UIFont systemFontOfSize:13];
        titlelable.textColor = [UIColor colorWithHexString:@"#999999"];
        [otherview addSubview:titlelable];
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(titlelable.current_x_w+2, 12, 15, 15)];
        imgV.image = [UIImage imageNamed:@"首页更多"];
        [otherview addSubview:imgV];
        UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(MainScreenWidth-50, 12, 44, 15)];
        [otherview addSubview:moreBtn];
        return otherview;
        
    }
    
    return nil;
}


- (void)getLookRecode {
    
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
#pragma mark - 保存为dic.plist
    //获取完整路径
    NSString *plistPath = [libPath stringByAppendingPathComponent:@"LookRecode.plist"];
    
    //    NSDictionary *dicHH = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *dicArray = [NSArray arrayWithContentsOfFile:plistPath];
    
    
    _lookArray = dicArray;
    NSLog(@"%@",_lookArray);
    
    [_tableView reloadData];
    
}


@end
