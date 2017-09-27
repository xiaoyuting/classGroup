//
//  HomeMoreViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/10/10.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "HomeMoreViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "HomeInstitutionViewController.h"
#import "HeaderCRView.h"

#import "InstatutionCollectionViewCell.h"



@interface HomeMoreViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong ,nonatomic)UICollectionView *collectionView;

@end

static NSString *cellID = @"cell";

@implementation HomeMoreViewController

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
    [self addCollectionView];

}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25, MainScreenWidth - 60, 30)];
    WZLabel.text = @"更多";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake((MainScreenWidth - 3 * SpaceBaside) / 2, 180);
    layout.headerReferenceSize = CGSizeMake(MainScreenWidth - 2 * SpaceBaside, 180);

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SpaceBaside, 64, MainScreenWidth - 2 * SpaceBaside, MainScreenHeight - 64) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[InstatutionCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView"];
    
}

#pragma mark --- UICollectionViewDataSource

//头部视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView" forIndexPath:indexPath];
        reusableview.frame = CGRectMake(0, 0, MainScreenWidth , 180);
        reusableview.backgroundColor = [UIColor redColor];
        
        UIButton *imageButton = [[UIButton alloc] initWithFrame:reusableview.bounds];
        [imageButton setBackgroundImage:Image(@"你好") forState:UIControlStateNormal];
        [reusableview addSubview:imageButton];
        
        
    }
    return reusableview;
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 30;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    InstatutionCollectionViewCell *cell = (InstatutionCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
//    cell.title.text = @"实用英语";
//    [cell.imageV setImage:[UIImage imageNamed:@"你好"]];
//    cell.price.text = @"￥128";
    cell.backgroundColor = [UIColor whiteColor];
    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",indexPath.item);
}

@end
