//
//  GLZXViewController.m
//  dafengche
//
//  Created by IOS on 17/1/17.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//


#import "GLZXViewController.h"
#import "SYG.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "ZiXunTableViewCell.h"
#import "ZiXunsTableViewCell.h"
#import "ZhiyiHTTPRequest.h"
#import "ZXZXViewController.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "ZXDTViewController.h"
#import "MBProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "GLCollectionViewCell.h"


@interface GLZXViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray *_menuarr;
    UIButton *menubtn;
    int numsender;
    int tempNumber;
    UILabel *_colorLine;
    NSString *_ID;
    NSUInteger index;
    
}

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSArray *lookArray;

@property (strong ,nonatomic)UIScrollView *headScrollow;

@property (nonatomic, strong) UICollectionView *bigCollectionView;

///顶部btn集合
@property (strong, nonatomic) NSArray *btns;

@property (strong ,nonatomic)NSArray *dataArray;

@property (strong ,nonatomic)NSMutableArray *dataArr;

@property (assign ,nonatomic)NSInteger number;

@property (strong ,nonatomic)NSMutableArray *imgdataArray;

@end

@implementation GLZXViewController

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

- (UICollectionView *)bigCollectionView
{
    if (_bigCollectionView == nil) {
        // 高度 = 屏幕高度 - 导航栏高度64 - 频道视图高度44
        CGFloat h = MainScreenHeight - _headScrollow.current_y_h;
        CGRect frame = CGRectMake(0, _headScrollow.current_y_h, MainScreenWidth, h);
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
    NSLog(@"%ld",_dataArray.count);
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLCollectionViewCell" forIndexPath:indexPath];
    
    cell.urlString = @"";

    [self addChildViewController:(UIViewController *)cell.newsTVC];

    // 如果不加入响应者链，则无法利用NavController进行Push/Pop等操作。
//    [self addChildViewController:(UIViewController *)cell.newsTVC];
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

    if (rightIndex >= _dataArray.count) {  // 防止滑到最右，再滑，数组越界，从而崩溃
        rightIndex = _dataArray.count - 1;
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
    tempNum = (int)_dataArray.count;
    for (int i=0; i<_dataArray.count; i++) {
        [self.btns[i] setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
    }
    CGFloat offsetx   =  btn.center.x - MainScreenWidth * 0.5;
    CGFloat offsetMax = _headScrollow.contentSize.width - _headScrollow.frame.size.width;

    // 在最左和最右时，标签没必要滚动到中间位置。
    if (offsetx < 0)		 {offsetx = 0;}
    if (offsetx > offsetMax) {offsetx = offsetMax;}
    
    // 下划线滚动并着色
    [UIView animateWithDuration:0.5 animations:^{
        [_headScrollow setContentOffset:CGPointMake(offsetx, 0) animated:YES];
        CGPoint center = _colorLine.center;
        center.x = btn.center.x;
        _colorLine.center = center;
        [self.btns[index] setTitleColor:[UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1] forState:UIControlStateNormal];
    }];
}
-(void)creatMenu{
    
    //自定义segment区域
    NSMutableArray *marr = [NSMutableArray array];
    UIColor *ffbbcolor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
    NSLog(@"%@",_dataArray);
    for (int i=0; i<_dataArray.count; i++) {
        menubtn = [[UIButton alloc]init];
        menubtn.frame = CGRectMake(i*MainScreenWidth/5, 0, MainScreenWidth/5, 40);
        [menubtn setTitle:_dataArray[i][@"title"] forState:UIControlStateNormal];
        [_headScrollow addSubview:menubtn];
        menubtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [menubtn setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
        menubtn.tag = 100+i;
        menubtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [menubtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i==0) {
            [menubtn setTitleColor:ffbbcolor forState:UIControlStateNormal];
        }
        [marr addObject:menubtn];
    }
    self.btns = [marr copy];
    int tempNum;
    tempNum = (int)_dataArray.count;
    _headScrollow.contentSize = CGSizeMake((_dataArray.count) * MainScreenWidth/5, 40);
    _colorLine = [[UILabel alloc]initWithFrame:CGRectMake(0, _headScrollow.frame.size.height - 2, MainScreenWidth/5, 2)];
    _colorLine.backgroundColor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
    [_headScrollow addSubview:_colorLine];
    CGPoint center = _colorLine.center;
    center.x = MainScreenWidth / (2 * tempNum);
    _colorLine.center = center;
    [_bigCollectionView reloadData];
}

-(void)change:(UIButton *)sender{
    
    int tempNum;
    tempNum = (int)_dataArray.count;
    for (int i=0; i<_dataArray.count; i++) {
        [self.btns[i] setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.2 animations:^{
        
        [_bigCollectionView setContentOffset:CGPointMake((sender.tag - 100) * _bigCollectionView.frame.size.width, 0)];
        [self scrollViewDidEndScrollingAnimation:self.bigCollectionView];
        CGPoint center = _colorLine.center;
        center.x = sender.center.x;
        _colorLine.center = center;
        [sender setTitleColor:[UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1] forState:UIControlStateNormal];
    }];
    _number = 1;
    _ID = [NSString stringWithFormat:@"%@",_dataArray[sender.tag - 100][@"zy_topic_category_id"]];
}

- (void)backPressed {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)NetWork {
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [manager FXFL:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _dataArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        [self creatMenu];
//        [self addTableView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"数据加载失败" toView:self.view];
    }];
}

//详情里面的请求
- (void)getData:(NSString *)IDStr andNum:(NSInteger)num{
    
    QKHTTPManager *manager = [QKHTTPManager manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:@"1" forKey:@"order"];
    [dic setObject:[NSString stringWithFormat:@"%@",_ID] forKey:@"cid"];
    [dic setValue:[NSNumber numberWithInteger:num] forKey:@"page"];
    [dic setValue:@"10" forKey:@"count"];
    
    [manager getpublicPort:dic mod:@"News" act:@"getList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"======  %@",responseObject);
        NSArray *LJArray = responseObject[@"data"];
        if (num == 1) {
            _dataArr = [NSMutableArray arrayWithArray:LJArray];
        }else {
            NSArray *SYGArray = [NSArray arrayWithArray:LJArray];
            if (SYGArray.count==0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有更多数据了" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alert repeats:YES];
            }else{
                [_dataArr addObjectsFromArray:SYGArray];
            }
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"数据加载失败" toView:self.view];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self interFace];
    [self addNav];
    [self addscrollow];
    [self NetWork];
    [self.view addSubview:self.bigCollectionView];
}

-(void)addscrollow{
    
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
    
}

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headScrollow.current_y_h, MainScreenWidth, MainScreenHeight - _headScrollow.current_y_h) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 170;
    [self.view addSubview:_tableView];
    self.edgesForExtendedLayout = UIRectEdgeNone;// 推荐使用
    
    //添加刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing:)];
    [_tableView headerBeginRefreshing];
    
    //上拉加载
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
}

- (void)interFace {
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"资讯列表";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30,120, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,106)];
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

@end
