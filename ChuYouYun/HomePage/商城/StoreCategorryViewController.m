//
//  StoreCategorryViewController.m
//  dafengche
//
//  Created by IOS on 16/10/19.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "StoreCategorryViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "MyHttpRequest.h"
#import "MBProgressHUD+Add.h"

#import "teacherViewController.h"
#import "StoreViewController.h"
#import "StoresViewController.h"

@interface StoreCategorryViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{

    UIButton *_btn;
    
    int numsender;
    NSString *_title;
    
}
@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)NSMutableArray *cateGorryArr;
@property (strong ,nonatomic)NSMutableArray *cellcateGorryArr;

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSArray *lookArray;

@property (strong ,nonatomic)UIScrollView *headScrollow;
///顶部btn集合
@property (strong, nonatomic) NSArray *btns;

@end

@implementation StoreCategorryViewController


-(void)requestData {
    [MBProgressHUD showError:@"数据加载中...." toView:self.view];
    QKHTTPManager * manager = [QKHTTPManager manager];
    [manager getpublicPort:nil mod:@"Goods" act:@"getGoodsCate" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD showError:@"加载完成...." toView:self.view];
        _dataArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        [self creatBtn];
        _cateGorryArr = [NSMutableArray arrayWithArray:_dataArray[0][@"childs"]];
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"获取数据失败" toView:self.view];
    }];
}

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
    [self addscrollow];
}

-(void)addscrollow{

    _headScrollow = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64,80*MainScreenWidth/320,MainScreenHeight - 64- 11)];
    //需要传入按钮的个数
    _headScrollow.contentSize = CGSizeMake(80*MainScreenWidth/320, 14*_headScrollow.current_h/9);
    _headScrollow.delegate = self;
    _headScrollow.alwaysBounceVertical = NO;
    _headScrollow.pagingEnabled = YES;
    UIColor *color = [UIColor colorWithHexString:@"#f2f4f5"];
    _headScrollow.backgroundColor = color;
    //同时单方向滚动
    _headScrollow.directionalLockEnabled = YES;
    //滚动条
    _headScrollow.showsVerticalScrollIndicator = NO;
    _headScrollow.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:_headScrollow];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(_headScrollow.current_x_w + 10, _headScrollow.current_y, MainScreenWidth - _headScrollow.current_x_w - 10, MainScreenHeight - _headScrollow.current_y - 60) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = 70*verticalrate;
}

- (void)interFace {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"商城分类";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 120, 24)];
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
    
    UIButton *allBtn = [[UIButton alloc]initWithFrame:CGRectMake(MainScreenWidth - 50, 30, 40, 20)];
    [allBtn setTitleColor:BasidColor forState:UIControlStateNormal];
    [allBtn setTitle:@"全部" forState:UIControlStateNormal];
    [allBtn addTarget:self action:@selector(allBtn) forControlEvents:UIControlEventTouchUpInside];
    allBtn.titleLabel.font = Font(17);
    [SYGView addSubview:allBtn];
}

-(void)allBtn{
    
    [self.navigationController pushViewController:[StoresViewController new] animated:YES];
}

-(void)setbtnTitle{
    
    for (int i=0; i<_dataArray.count; i++)  {
        UIButton *tempB = self.btns[i];
        [tempB setTitle:_dataArray[i][@"title"] forState:UIControlStateNormal];
    }
}

//按钮
-(void)creatBtn{
    
    if (_dataArray.count==0) {
        return;
    }
    if (self.btns.count) {
        [self setbtnTitle];
        return;
    }
    NSMutableArray *marr = [NSMutableArray array];
    for (int i=0; i<_dataArray.count; i++) {
        UIButton *menuBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, i*_headScrollow.current_h/9, _headScrollow.current_w, _headScrollow.current_h/9)];
        [menuBtn setTitle:_dataArray[i][@"title"] forState:UIControlStateNormal];
        [self.view addSubview:_btn];
        [menuBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        menuBtn.titleLabel.font = [UIFont systemFontOfSize:12*verticalrate];
        [_headScrollow addSubview:menuBtn];
        [marr addObject:menuBtn];
        [menuBtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            menuBtn.backgroundColor = [UIColor whiteColor];
            [menuBtn setTitleColor:BasidColor forState:UIControlStateNormal];
        }
        menuBtn.tag = 100+i;
    }
    _headScrollow.contentSize = CGSizeMake(80*MainScreenWidth/320, _dataArray.count*_headScrollow.current_h/9);
    self.btns = [marr copy];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30*verticalrate;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10*horizontalrate;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    int num = (int)[_cateGorryArr[indexPath.section][@"childs"] count] -1;
    num = num/3 + 1;
    NSLog(@"%d",num);
    if (num) {
        
        return 30*num*verticalrate;
        
    }else{
        
        return 30*verticalrate;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _cateGorryArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    
        for (int i=0; i<[_cateGorryArr[indexPath.section][@"childs"] count]; i++) {

            _btn = [[UIButton alloc]initWithFrame:CGRectMake((i%3)*(_tableView.current_w-10*horizontalrate)/3, i/3*30*verticalrate, (_tableView.current_w-10*horizontalrate)/3, 30*verticalrate)];
            if (i%3) {
                _btn.frame = CGRectMake((i%3)*(_tableView.current_w-10*horizontalrate)/3 - 0.5*(i%3), i/3*30*verticalrate, (_tableView.current_w-10*horizontalrate)/3, 30*verticalrate);
            }
            if (i>2) {
                _btn.frame = CGRectMake(_btn.current_x,i/3*30*verticalrate - 0.5*(i/3), (_tableView.current_w-10*horizontalrate)/3, 30*verticalrate);
            }
            [_btn setTitle:_cateGorryArr[indexPath.section][@"childs"][i][@"title"] forState:UIControlStateNormal];
            [_btn.layer setBorderColor:[UIColor colorWithHexString:@"#deddde"].CGColor];
            [_btn.layer setBorderWidth:0.5];
            [_btn.layer setMasksToBounds:YES];
            [cell.contentView addSubview:_btn];
            _btn.titleLabel.font = [UIFont systemFontOfSize:13*verticalrate];
            [_btn setTitleColor:[UIColor colorWithHexString:@"#6d6d6e"] forState:UIControlStateNormal];
            [_btn addTarget:self action:@selector(sendID:) forControlEvents:UIControlEventTouchUpInside];
            _btn.tag = 1000 + [_cateGorryArr[indexPath.section][@"childs"][i][@"goods_category_id"] integerValue];
            _title = _cateGorryArr[indexPath.section][@"childs"][i][@"title"];
        }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0, _tableView.current_w-10*horizontalrate, 30*verticalrate)];
    UILabel *colorline = [[UILabel alloc]initWithFrame:CGRectMake(0, 9*verticalrate, 2*horizontalrate, 12*verticalrate)];
    colorline.backgroundColor = BasidColor;
    [view addSubview:colorline];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(2*horizontalrate, 0, _tableView.current_w-10*horizontalrate, 30*verticalrate)];
    titleLab.text = [NSString stringWithFormat:@"  %@",_cateGorryArr[section][@"title"]];
    titleLab.textColor = [UIColor colorWithHexString:@"#9d9e9e"];
    //titleLab.backgroundColor = [UIColor cyanColor];
    titleLab.font = [UIFont systemFontOfSize:12*verticalrate];
    [view addSubview:titleLab];
    return view;
}

#pragma 响应事件
-(void)sendID:(UIButton *)button{
    
    NSInteger num = button.tag - 1000;
//    StoreViewController *shopDetail = [[StoreViewController alloc]initWithDatID:[NSString stringWithFormat:@"%ld",num] title:_title];
//    [self.navigationController pushViewController:shopDetail animated:YES];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%ld",num] forKey:@"ID"];
    [dict setObject:button.titleLabel.text forKey:@"title"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationMallID" object:dict];
    [self backPressed];
}

-(void)change:(UIButton *)sender{
    
    if (_cateGorryArr.count) {
        [_cateGorryArr removeAllObjects];
    }
    _cateGorryArr = [NSMutableArray arrayWithArray:_dataArray[sender.tag - 100][@"childs"]];
    [_tableView reloadData];
    for (int i=0; i<_dataArray.count; i++) {
        [self.btns[i] setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        UIButton *b = self.btns[i];
        b.backgroundColor = [UIColor clearColor];
        if (sender.tag -100 == i) {
            
            [UIView animateWithDuration:0.2 animations:^{
                [sender setTitleColor:BasidColor forState:UIControlStateNormal];
                UIButton *b = self.btns[i];
                b.backgroundColor = [UIColor whiteColor];
            }];
        }
    }
}

//全部分类
-(void)allCategorry{
    
    [self.navigationController pushViewController:[teacherViewController new] animated:YES];
   // [self.navigationController popViewControllerAnimated:YES];
}

//分类
-(void)ShopCateButton{
    
    NSLog(@"分类");
}

- (void)backPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rowBtn:(UIButton *)sender{

    NSLog(@"%ld",sender.tag);
}

@end
