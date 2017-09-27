//
//  GLLiveViewController.m
//  dafengche
//
//  Created by IOS on 17/3/3.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
//定义宏，判断ios7
#define IOS7 [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
//定义宏，判断ios7
#define IOS7 [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0

#import "GLLiveViewController.h"
#import "UIColor+HTMLColors.h"
#import "UIView+Utils.h"
#import "GLCollectionViewCell.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "BigWindCar.h"
#import "MyHttpRequest.h"
#import "MBProgressHUD+Add.h"



@interface GLLiveViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray *_menuarr;
    UIButton *_menubtn;
    int numsender;
    int tempNumber;
    UILabel *_colorLine;
    NSString *_ID;
    NSUInteger index;
    
}
//UIScrollView
@property (strong ,nonatomic)UIScrollView *headScrollow;

//UICollectionView
@property (nonatomic, strong) UICollectionView *bigCollectionView;

@property (strong ,nonatomic)NSMutableArray *dataArr;
@property (strong ,nonatomic)NSMutableArray *headerArray;

///顶部btn集合
@property (strong, nonatomic) NSArray *btns;


@end

@implementation GLLiveViewController

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
- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"直播大厅";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 170, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,156)];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _headerArray = [NSMutableArray  array];
    [self addNav];
    [self requestData];

    // ---------------- 隐藏navigationBar的下划线 ----------------
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //    //消除阴影
    //    self.navigationController.navigationBar.shadowImage = [UIImage new];

    //菜单栏
    [self addscrollow];
    //UICollectionViewDataSource
    [self.view addSubview:self.bigCollectionView];
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addUICollectionView{

}

-(void)addscrollow{
    
    //防止向下偏移
    self.automaticallyAdjustsScrollViewInsets=NO;
    _headScrollow = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64, MainScreenWidth,40)];
    _headScrollow.delegate = self;
    _headScrollow.alwaysBounceVertical = NO;
    _headScrollow.pagingEnabled = NO;
    _headScrollow.backgroundColor = [UIColor whiteColor];
    //同时单方向滚动
    _headScrollow.directionalLockEnabled = YES;
    _headScrollow.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:_headScrollow];
    _headScrollow.showsVerticalScrollIndicator = NO;
    _headScrollow.showsHorizontalScrollIndicator = NO;
    _headScrollow.delegate = self;
//    [self creatMenu];
}

-(void)creatMenu{
    
    //自定义segment区域
    NSMutableArray *marr = [NSMutableArray array];
    UIColor *ffbbcolor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
    for (int i=0; i < _headerArray.count ; i++) {
        _menubtn = [[UIButton alloc]init];
        _menubtn.frame = CGRectMake(i*MainScreenWidth/5, 0, MainScreenWidth/5, 40);
        [_menubtn setTitle:_headerArray[i] forState:UIControlStateNormal];
        [_headScrollow addSubview:_menubtn];
        _menubtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_menubtn setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
        _menubtn.tag = 100+i;
        _menubtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_menubtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            [_menubtn setTitleColor:ffbbcolor forState:UIControlStateNormal];
        }
        [marr addObject:_menubtn];
    }
    self.btns = [marr copy];
    int tempNum;
    tempNum = 10;
    _headScrollow.contentSize = CGSizeMake((_headerArray.count) * MainScreenWidth/5, 0);
    _colorLine = [[UILabel alloc]initWithFrame:CGRectMake(0, _headScrollow.frame.size.height - 2, MainScreenWidth/5, 2)];
    _colorLine.backgroundColor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
    [_headScrollow addSubview:_colorLine];
    CGPoint center = _colorLine.center;
    center.x = MainScreenWidth / (2 * tempNum);
    _colorLine.center = center;
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0,_headScrollow.current_y_h,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineLab];
    lineLab.alpha = 0.7;
}

-(void)change:(UIButton *)sender{
    
    int tempNum;
    tempNum = 10;
    for (int i=0; i< _headerArray.count; i++) {
        [self.btns[i] setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.5 animations:^{
        
        [_bigCollectionView setContentOffset:CGPointMake((sender.tag - 100) * _bigCollectionView.frame.size.width, 0)];
        [self scrollViewDidEndScrollingAnimation:self.bigCollectionView];
        CGPoint center = _colorLine.center;
        center.x = sender.center.x;
        _colorLine.center = center;
        [sender setTitleColor:[UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1] forState:UIControlStateNormal];
    }];
}

- (UICollectionView *)bigCollectionView
{
    if (_bigCollectionView == nil) {
        // 高度 = 屏幕高度 - 导航栏高度64 - 频道视图高度44
        CGFloat h = MainScreenHeight - _headScrollow.current_y_h;
        CGRect frame = CGRectMake(0, _headScrollow.current_y_h+1, MainScreenWidth, h-1);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _bigCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        _bigCollectionView.backgroundColor = [UIColor whiteColor];
        _bigCollectionView.delegate = self;
        _bigCollectionView.dataSource = self;
        [_bigCollectionView registerClass:[GLCollectionViewCell class] forCellWithReuseIdentifier:@"GLCollectionViewCell"];
        // 设置cell的大小和细节
        flowLayout.itemSize = _bigCollectionView.bounds.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        _bigCollectionView.pagingEnabled = YES;
        _bigCollectionView.showsHorizontalScrollIndicator = NO;
    }
    return _bigCollectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _headerArray.count;
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLCollectionViewCell" forIndexPath:indexPath];
    cell.urlString = [NSString stringWithFormat:@"%ld",indexPath.row];
    //    [self addChildViewController:(UIViewController *)cell.newsTVC];
    // 如果不加入响应者链，则无法利用NavController进行Push/Pop等操作。
    [self addChildViewController:(UIViewController *)cell.newsTVC];
    return cell;
}

#pragma mark - UICollectionViewDelegate
/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat value = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (value < 0) {return;} // 防止在最左侧的时候，再滑，下划线位置会偏移，颜色渐变会混乱。
    
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    NSLog(@"===leftIndex===%ld",leftIndex);
    
    if (rightIndex >= 10) {  // 防止滑到最右，再滑，数组越界，从而崩溃
        rightIndex = 10 - 1;
    }
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft  = 1 - scaleRight;
    
    if (scaleLeft == 1 && scaleRight == 0) {
        return;
    }
}

/** 手指滑动BigCollectionView，滑动结束后调用 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.bigCollectionView]) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
    }
}

/** 手指点击smallScrollView */

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    // 获得索引
    UIButton *btn;
    
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        index = scrollView.contentOffset.x / MainScreenWidth;
    }
    btn = self.btns[index];
    
    // 滚动标题栏到中间位置
    int tempNum;
    tempNum = (int)10;
    for (int i=0; i<10; i++) {
        [self.btns[i] setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
    }
    CGFloat offsetx   =  btn.center.x - MainScreenWidth * 0.5;
    CGFloat offsetMax = _headScrollow.contentSize.width - _headScrollow.frame.size.width;
    
    // 在最左和最右时，标签没必要滚动到中间位置。
    if (offsetx < 0)		 {
        offsetx = 0;
    }
    
    if (offsetx > offsetMax) {
        offsetx = offsetMax;
    }
    
    // 下划线滚动并着色
    [UIView animateWithDuration:0.5 animations:^{
        [_headScrollow setContentOffset:CGPointMake(offsetx, 0) animated:NO];
        CGPoint center = _colorLine.center;
        center.x = btn.center.x;
        _colorLine.center = center;
        [self.btns[index] setTitleColor:[UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1] forState:UIControlStateNormal];
    }];
}


#pragma mark ---- 直播分类


-(void)requestData{
    
    QKHTTPManager * manager = [QKHTTPManager manager];
    [manager getpublicPort:nil mod:@"Home" act:@"getCateList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"===__===%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        
//        _dataArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
//        NSLog(@"%@",_dataArray);
//        [self addBtn];
        NSArray *array = responseObject[@"data"];
        for (int i = 0 ; i < array.count ; i ++) {
            NSString *title = array[i][@"title"];
            NSLog(@"%@",title);
            [_headerArray addObject:title];
            
        }
        
        NSLog(@"%@",_headerArray);
        
        [self creatMenu];
        [_bigCollectionView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD showError:@"获取数据失败" toView:self.view];
    }];
}




@end
