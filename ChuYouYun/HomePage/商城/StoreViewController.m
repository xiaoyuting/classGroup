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


@interface StoreViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,SDCycleScrollViewDelegate>
{
    UICollectionReusableView *_headerView;
    
}
@property (nonatomic ,strong)UICollectionView *collectionView;
@property (strong ,nonatomic)NSMutableArray *dataArray;


@end

static NSString *cellID = @"cell";

@implementation StoreViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self requestData];
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

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
}
-(void)requestData
{
    
    QKHTTPManager * manager = [QKHTTPManager manager];
    
    //http://dafengche.51eduline.com/?app=api&mod=Address&act=addAdress&oauth_token=44da0cedbcda40ce2fabfafb51ae4622&oauth_token_secret=34e7b83af30a98d365ec47610761dae1&province=12&city=21&area=214&address=42156&nanme=1245&phone=15538983107&is_default
    

    NSDictionary *parameter=@{@"type": @"",@"cate_id": @"" ,@"floor_count":@"-1",@"count": @"6",@"page": @"1"};

    NSString *scheme  = @"http://dafengche.51eduline.com/?app=api&mod=Goods&act=index";
    
    [manager GET:scheme parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"===__===%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        
        _dataArray = [NSMutableArray arrayWithArray:responseObject[@"data"][@"list"]];
        NSLog(@"%@",_dataArray);
        [_collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"获取数据失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 70, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,56)];
    [backButton setTitle:@"商城" forState:UIControlStateNormal];
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
    [self.navigationController popViewControllerAnimated:YES];
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
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView1"];

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
    
    _headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];

        if (kind == UICollectionElementKindSectionHeader){
            
            NSLog(@"---------%ld",indexPath.section);
            if (indexPath.section==0) {
                _headerView.frame = CGRectMake(0, 0, MainScreenWidth , 230*MainScreenWidth/375);
                reusableview = _headerView;
                _headerView.backgroundColor = [UIColor blackColor];
                [self addHeaderView];
                
            }else{
                
                _headerView.frame = CGRectMake(0, 0, MainScreenWidth, 30);
                reusableview = _headerView;
                _headerView.backgroundColor = [UIColor blackColor];
            }
        }
        return reusableview;
}

#pragma mark UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        CGSize size = {MainScreenWidth - 2 * SpaceBaside, 230*MainScreenWidth/375 + 30};
        return size;

    }else{
        CGSize size = {MainScreenWidth - 2 * SpaceBaside,30};
        return size;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return _dataArray.count;
    
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_dataArray[section][@"data_list"] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    mainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shopCell" forIndexPath:indexPath];
    cell.title.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.section][@"data_list"][indexPath.row][@"title"]];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:_dataArray[indexPath.section][@"data_list"][indexPath.row][@"cover"]]];
    cell.icon.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.section][@"data_list"][indexPath.row][@"info"]];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSString *ID = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"goods_id"]];
    ShopDetailViewController *shopDetail = [[ShopDetailViewController alloc]initWithID:ID];
    [self.navigationController pushViewController:shopDetail animated:YES];
}

#pragma mark - 添加滚动视图

-(void)addHeaderView{
    // 情景二：采用网络图片实现
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"

                                  ];
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, MainScreenWidth, 230*MainScreenWidth/375) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
    cycleScrollView3.imageURLStringsGroup = imagesURLStrings;
    cycleScrollView3.backgroundColor = [UIColor cyanColor];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, cycleScrollView3.current_y_h, MainScreenWidth, 30)];
    lab.text = @"   兑换排行榜";
    [_headerView addSubview:lab];

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
