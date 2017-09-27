//
//  StoreViewController.m
//  dafengche
//
//  Created by IOS on 16/10/11.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "StoreViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"

#import "HomeInstitutionViewController.h"
#import "HeaderCRView.h"
#import "SDCycleScrollView.h"
#import "mainCollectionViewCell.h"
#import "UIColor+HTMLColors.h"
#import "ShopDetailViewController.h"
#import "StoreCategorryViewController.h"
#import "MyHttpRequest.h"
#import "UIImageView+WebCache.h"

#import "MJRefresh.h"
#import "MBProgressHUD+Add.h"
#import "StoresViewController.h"


@interface StoreViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,SDCycleScrollViewDelegate>
{
    UICollectionReusableView *_headerView;
    NSString *_ID;
    NSString *_title;

    
}
@property (nonatomic ,strong)UICollectionView *collectionView;
@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)NSMutableArray *LBdataArray;


@end

static NSString *cellID = @"cell";

@implementation StoreViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [self requestLBData];

    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self requestData];
}

-(void)requestLBData
{
    
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSDictionary *parameter;
    
    parameter=@{@"place":@"app_goods_banner"};
    [manager getpublicPort:parameter mod:@"Home" act:@"getAdvert" success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"===__===%@",responseObject);
        _LBdataArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"获取数据失败" toView:self.view];
    }];
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
    [self addCollectionView];
}

-(instancetype)initWithDatID:(NSString *)ID title:(NSString *)title{
    
    self = [super init];
    
    if (self) {
        
        _ID = ID;
        _title = title;
    }
    return self;
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
}
-(void)requestData {
    
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *key = [ user objectForKey:@"oauthToken"];
    NSString *passWord = [ user objectForKey:@"oauthTokenSecret"];
    
    NSDictionary *parameter=@{@"oauth_token": [NSString stringWithFormat:@"%@",key],@"oauth_token_secret": [NSString stringWithFormat:@"%@",passWord] ,@"goods_category_id": _ID };
    
    [manager getpublicPort:parameter mod:@"Goods" act:@"getGoodsCate" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"===__===%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        if ([responseObject[@"data"] count] == 0) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"暂时没有%@分类",_title] toView:self.view];
            [_collectionView reloadData];
            return;
            
        }else{
            _dataArray = [NSMutableArray arrayWithArray:responseObject[@"data"][@"rank"]];
            [_collectionView reloadData];
        }
        
        NSLog(@"%@",_dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"获取数据失败" toView:self.view];
    }];
}

- (void)addNav {
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = [NSString stringWithFormat:@"%@分类",_title];
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 90, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,76)];
    [backButton setTitle:@" " forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    //设置button上字体的偏移量
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10.0 , 0.0, 0)];
    [SYGView addSubview:backButton];
    
    //添加分类按钮
    UIButton *SXButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth-35, 30, 20, 20)];
    [SXButton setBackgroundImage:[UIImage imageNamed:@"fenleisyg"] forState:UIControlStateNormal];
    [SXButton addTarget:self action:@selector(ShopCateButton) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:SXButton];
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
}

- (void)backPressed {
    [self.navigationController pushViewController:[StoresViewController new] animated:YES];
}

//分类
-(void)ShopCateButton{

    self.navigationController.navigationBar.hidden = NO;
    StoreCategorryViewController *goods = [[StoreCategorryViewController alloc]init];
    [self.navigationController pushViewController:goods animated:YES];
}

- (void)addCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake((MainScreenWidth - 1.5) / 3, (MainScreenWidth-2)/3 + 53);
    layout.minimumInteritemSpacing = 0.5;
    layout.minimumLineSpacing = 1;
    //设置item最小行间距
   // layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    //超出屏幕部分的滑动（关键一句）
    _collectionView.alwaysBounceVertical = YES;
    /*----------------------------------------网络请求写这里------------------------------------------------------*/
    //头部视图注册
   [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    //注册cell
    [_collectionView registerClass:[mainCollectionViewCell class] forCellWithReuseIdentifier:@"shopCell"];
    
    //上拉刷新，下拉加载
    [self refreshing];

//    [self.collectionView registerClass:[HeaderCRView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"12"];
    
}

//下拉刷新,上拉加载
-(void)refreshing{
    
    __weak typeof(self) weakSelf = self;
    [_collectionView removeFooter];
    [_collectionView addHeaderWithCallback:^{
        NSLog(@"刷新");
        [weakSelf requestData];
        [weakSelf.collectionView headerEndRefreshing];
    }];
    [_collectionView addFooterWithCallback:^{
        [weakSelf requestData];
        [weakSelf.collectionView footerEndRefreshing];
    }];
}

#pragma mark --- UICollectionViewDataSource

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    // This will schedule calls to layoutAttributesForElementsInRect: as the
    // collectionView is scrolling.
    return YES;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
       _headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];;
        _headerView.frame = CGRectMake(0, 0, MainScreenWidth , 230*MainScreenWidth/375);
        reusableview = _headerView;
        _headerView.backgroundColor = [UIColor blackColor];
        [self addHeaderView];
    }
    return reusableview;
}

#pragma mark UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = {MainScreenWidth - 2 * SpaceBaside, 230*MainScreenWidth/375};
    return size;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    mainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shopCell" forIndexPath:indexPath];
    //ItemModel *model = self.itemDataSource[indexPath.section][indexPath.row];
    cell.title.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"goods_category"]];
//    [cell.imageV setImage:[UIImage imageNamed:@"大家好"]];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:_dataArray[indexPath.row][@"cover"]]];
    cell.icon.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"title"]];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSString *ID = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"goods_id"]];
    ShopDetailViewController *shopDetail = [[ShopDetailViewController alloc]initWithID:ID];
    [self.navigationController pushViewController:shopDetail animated:YES];
}

#pragma mark - 添加滚动视图
-(void)addHeaderView{
    
    // 情景二：采用网络图片实现
    NSMutableArray *imagesURLStrings = [NSMutableArray array];
    for (int i =0; i<_LBdataArray.count; i++) {
        [imagesURLStrings addObject:[NSString stringWithFormat:@"%@",_LBdataArray[i][@"banner"]]];
    }
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, MainScreenWidth, 230*MainScreenWidth/375) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    cycleScrollView3.imageURLStringsGroup = imagesURLStrings;
    cycleScrollView3.delegate = self;
    [_headerView addSubview:cycleScrollView3];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    ShopDetailViewController *shopDetail = [[ShopDetailViewController alloc]init];
    [self.navigationController pushViewController:shopDetail animated:YES];
    NSLog(@"---点击了第%ld张图片", (long)index);
    
}

@end
