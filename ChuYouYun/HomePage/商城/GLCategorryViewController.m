//
//  GLCategorryViewController.m
//  dafengche
//
//  Created by IOS on 16/11/29.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "GLCategorryViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "MyHttpRequest.h"
#import "GLCategorry.h"
#import "teacherViewController.h"
#import "SYG.h"
#import "SearchGetViewController.h"
#import "GLReachabilityView.h"
#import "HomeSearchViewController.h"
#import "OnlyClassSearchViewController.h"


@interface GLCategorryViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{
    
    UIButton *_btn;
    
    int numsender;
    
    NSArray *_ISONArr;
    NSMutableArray *_muArray;

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

@implementation GLCategorryViewController

-(void)requestData
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    manager.requestSerializer.timeoutInterval = 10.0;

    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:@"50" forKey:@"count"];

    NSArray *CategorryArray = [GLCategorry gLCategorryWithDic:dic];
    NSLog(@"%@",CategorryArray);

    if([GLReachabilityView isConnectionAvailable]!=1){
        
            //数组倒序
        NSArray* reversedArray = [[CategorryArray reverseObjectEnumerator] allObjects];
            
        _dataArray = [NSMutableArray arrayWithArray:reversedArray];
        NSLog(@"%@",_dataArray);
            
        [self creatBtn];
        _cateGorryArr = [NSMutableArray arrayWithArray:_dataArray[0][@"childs"]];
        [_tableView reloadData];
        
        return;
    }
    
    if (CategorryArray.count) {
        //数组倒序
        NSArray* reversedArray = [[CategorryArray reverseObjectEnumerator] allObjects];
        
        _dataArray = [NSMutableArray arrayWithArray:reversedArray];
        NSLog(@"%@",_dataArray);
        
        [self creatBtn];
        _cateGorryArr = [NSMutableArray arrayWithArray:_dataArray[0][@"childs"]];
        [_tableView reloadData];
        return;
    }
    
    [manager getpublicPort:dic mod:@"Home" act:@"getCateList" success:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (CategorryArray.count) {//本地已经有数据了
            NSLog(@"不需要");
        } else {
            //保存数据
            [GLCategorry savegLCategorry:responseObject[@"data"]];
        }
        _dataArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        NSLog(@"%@",_dataArray);
        [self creatBtn];
        _cateGorryArr = [NSMutableArray arrayWithArray:_dataArray[0][@"childs"]];
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //取出本地的数据
        if (_dataArray.count==0) {
            
            //数组倒序
            NSArray* reversedArray = [[CategorryArray reverseObjectEnumerator] allObjects];
            _dataArray = [NSMutableArray arrayWithArray:reversedArray];
            [self creatBtn];
            if (_dataArray.count) {
                _cateGorryArr = [NSMutableArray arrayWithArray:_dataArray[0][@"childs"]];
            }
        }
        
        [_tableView reloadData];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"获取数据失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{

    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _ISONArr = @[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"];
    _muArray = [NSMutableArray arrayWithArray:_ISONArr];

    NSArray *CategorryArray = [GLCategorry gLCategorryWithDic:nil];
    NSLog(@"%@",CategorryArray);
    if (CategorryArray.count) {//有缓存
        [self interFace];
        [self addNav];
        [self addscrollow];
        [self addTableView];
        
        NSArray* reversedArray = [[CategorryArray reverseObjectEnumerator] allObjects];
        _dataArray = [NSMutableArray arrayWithArray:reversedArray];
        [self creatBtn];
        _cateGorryArr = [NSMutableArray arrayWithArray:_dataArray[0][@"childs"]];
        [_tableView reloadData];
        
    } else {//没有缓存
        [self interFace];
        [self addNav];
        [self addscrollow];
        [self addTableView];
        [self requestData];
    }
    
}


- (void)addTableView {
    
}

-(void)addscrollow{

    _headScrollow = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64,80*MainScreenWidth/375,MainScreenHeight - 64 -11)];
    //需要传入按钮的个数
    _headScrollow.contentSize = CGSizeMake(80*MainScreenWidth/375, 14*_headScrollow.current_h/9);
    _headScrollow.delegate = self;
    _headScrollow.alwaysBounceVertical = NO;
    _headScrollow.pagingEnabled = YES;
    UIColor *color = [UIColor colorWithHexString:@"#f2f4f5"];
    _headScrollow.backgroundColor = color;
    
    //同时单方向滚动
    _headScrollow.directionalLockEnabled = YES;
    _headScrollow.scrollsToTop = NO;
    
    //滚动条
    _headScrollow.showsVerticalScrollIndicator = NO;
    _headScrollow.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:_headScrollow];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(_headScrollow.current_x_w + 10, _headScrollow.current_y + 10, MainScreenWidth - _headScrollow.current_x_w - 10, MainScreenHeight - _headScrollow.current_y - 60) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
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
    SYGView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:SYGView];
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"科目";
    [WZLabel setTextColor:BasidColor
     ];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 30, 28, 23, 23)];
    [searchButton setBackgroundImage:Image(@"yunketang_search") forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(goToSearch) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:searchButton];
    
}

- (void)goToSearch {
    HomeSearchViewController *homeSearchVc = [[HomeSearchViewController alloc] init];
    [self.navigationController pushViewController:homeSearchVc animated:YES];
}

-(void)setbtnTitle{
    
    for (int i=0; i<self.btns.count; i++)  {
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
        UIButton *menuBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,i*_headScrollow.current_h/11, _headScrollow.current_w, _headScrollow.current_h/11)];
        [menuBtn setTitle:_dataArray[i][@"title"] forState:UIControlStateNormal];
        [self.view addSubview:_btn];
        [menuBtn setTitleColor:[UIColor colorWithHexString:@"#9d9e9e"] forState:UIControlStateNormal];
        menuBtn.titleLabel.font = [UIFont systemFontOfSize:12*verticalrate];
        [_headScrollow addSubview:menuBtn];
        [marr addObject:menuBtn];
        [menuBtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            menuBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
            [menuBtn setTitleColor:BasidColor forState:UIControlStateNormal];
        }
        menuBtn.tag = 100+i;
    }
    self.btns = [marr copy];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30*verticalrate;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10*horizontalrate;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int num = (int)[_cateGorryArr[indexPath.section][@"childs"] count] - 1;
    num = num/3 + 1;
    NSLog(@"%d",num);
    if (num) {
        
        if ([_cateGorryArr[indexPath.section][@"childs"] count]>9) {
            
            if ([_muArray[indexPath.row] isEqualToString: @"1"]) {
                return 30*num*verticalrate;
            }else{
                return 30*3*verticalrate;
            }
        }else{
        return 30*num*verticalrate;
        }
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
     cell.selectionStyle = NO;
    NSInteger tepNum = [_cateGorryArr[indexPath.section][@"childs"] count];
    NSInteger num = (tepNum-1)/3;
    num = (num +1)*3;
    for (int i=0; i<num; i++) {
        
        if ([_muArray[indexPath.row] isEqualToString: @"1"]) {

            _btn = [[UIButton alloc]initWithFrame:CGRectMake((i%3)*(_tableView.current_w-10*horizontalrate)/3, i/3*30*verticalrate, (_tableView.current_w-10*horizontalrate)/3, 30*verticalrate)];
            if (i%3) {
                _btn.frame = CGRectMake((i%3)*(_tableView.current_w-10*horizontalrate)/3 - 0.5*(i%3), i/3*30*verticalrate, (_tableView.current_w-10*horizontalrate)/3, 30*verticalrate);
            }
            if (i>2) {
                _btn.frame = CGRectMake(_btn.current_x,i/3*30*verticalrate - 0.5*(i/3), (_tableView.current_w-10*horizontalrate)/3, 30*verticalrate);
            }
            if (i<tepNum) {
                [_btn setTitle:_cateGorryArr[indexPath.section][@"childs"][i][@"title"] forState:UIControlStateNormal];
                [_btn addTarget:self action:@selector(sendID:) forControlEvents:UIControlEventTouchUpInside];
                _btn.tag = 1000 + [_cateGorryArr[indexPath.section][@"childs"][i][@"id"] integerValue];
            }
            [_btn.layer setBorderColor:[UIColor colorWithHexString:@"#deddde"].CGColor];
            [_btn.layer setBorderWidth:0.5];
            [_btn.layer setMasksToBounds:YES];
            [cell.contentView addSubview:_btn];
            _btn.titleLabel.font = [UIFont systemFontOfSize:13*verticalrate];
            [_btn setTitleColor:[UIColor colorWithHexString:@"#6d6d6e"] forState:UIControlStateNormal];
       
        }else{
            if (i>8) {
                
            }else{
                _btn = [[UIButton alloc]initWithFrame:CGRectMake((i%3)*(_tableView.current_w-10*horizontalrate)/3, i/3*30*verticalrate, (_tableView.current_w-10*horizontalrate)/3, 30*verticalrate)];
                if (i%3) {
                    _btn.frame = CGRectMake((i%3)*(_tableView.current_w-10*horizontalrate)/3 - 0.5*(i%3), i/3*30*verticalrate, (_tableView.current_w-10*horizontalrate)/3, 30*verticalrate);
                }
                if (i>2) {
                    _btn.frame = CGRectMake(_btn.current_x,i/3*30*verticalrate - 0.5*(i/3), (_tableView.current_w-10*horizontalrate)/3, 30*verticalrate);
                }
                
                if (i== 8) {
                    if (tepNum>9) {
                        [_btn setTitle:@"更多" forState:UIControlStateNormal];
                        [_btn addTarget:self action:@selector(changeCell:) forControlEvents:UIControlEventTouchUpInside];
                        _btn.tag = indexPath.row + 100;
                    }
                }else{
                    if (i<tepNum) {
                        [_btn setTitle:_cateGorryArr[indexPath.section][@"childs"][i][@"title"] forState:UIControlStateNormal];
                        
                        [_btn addTarget:self action:@selector(sendID:) forControlEvents:UIControlEventTouchUpInside];
                        _btn.tag = 1000 + [_cateGorryArr[indexPath.section][@"childs"][i][@"id"] integerValue];
                    }
                }
                
                [_btn.layer setBorderColor:[UIColor colorWithHexString:@"#deddde"].CGColor];
                [_btn.layer setBorderWidth:0.5];
                [_btn.layer setMasksToBounds:YES];
                [cell.contentView addSubview:_btn];
                _btn.titleLabel.font = [UIFont systemFontOfSize:13*verticalrate];
                [_btn setTitleColor:[UIColor colorWithHexString:@"#6d6d6e"] forState:UIControlStateNormal];
            }
        }
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
-(void)sendID:(UIButton *)sender{
    
//    NSLog(@"%@",sender.titleLabel.text);
//    NSString *title = sender.titleLabel.text;
//    NSString *cate_ID = [NSString stringWithFormat:@"%ld",sender.tag - 1000];
//    NSLog(@"%@",cate_ID);
//    SearchGetViewController *searchGetVc = [[SearchGetViewController alloc] init];
//    searchGetVc.typeStr = @"1";
//    searchGetVc.cateStr = title;
//    searchGetVc.cate_ID = cate_ID;
//    [self.navigationController pushViewController:searchGetVc animated:YES];
    
    
    NSLog(@"%@",sender.titleLabel.text);
    NSString *title = sender.titleLabel.text;
    NSString *cate_ID = [NSString stringWithFormat:@"%ld",sender.tag - 1000];
    NSLog(@"%@",cate_ID);
    OnlyClassSearchViewController *searchGetVc = [[OnlyClassSearchViewController alloc] init];
    searchGetVc.typeStr = @"1";
    searchGetVc.cateStr = title;
    searchGetVc.cate_ID = cate_ID;
    [self.navigationController pushViewController:searchGetVc animated:YES];
    
    
}

-(void)changeCell:(UIButton *)sender{
    
    NSInteger num = sender.tag - 100;
    [_muArray replaceObjectAtIndex:num withObject:@"1"];
    [_tableView reloadData];
}

-(void)change:(UIButton *)sender{
    
    _ISONArr = @[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"];
    _muArray = [NSMutableArray arrayWithArray:_ISONArr];
    if (_cateGorryArr.count) {
        [_cateGorryArr removeAllObjects];
    }
    _cateGorryArr = [NSMutableArray arrayWithArray:_dataArray[sender.tag - 100][@"childs"]];
    [_tableView reloadData];
    
    for (int i=0; i<_dataArray.count; i++) {
        [self.btns[i] setTitleColor:[UIColor colorWithHexString:@"#9d9e9e"] forState:UIControlStateNormal];
        UIButton *b = self.btns[i];
        b.backgroundColor = [UIColor clearColor];
        b.titleLabel.font = Font(12*horizontalrate);

        if (sender.tag -100 == i) {
            [UIView animateWithDuration:0.2 animations:^{
                [sender setTitleColor:BasidColor forState:UIControlStateNormal];
                UIButton *b = self.btns[i];
                b.titleLabel.font = Font(13*horizontalrate);
                b.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
            }];
        }
    }
}

//全部分类
-(void)allCategorry{
    
    [self.navigationController pushViewController:[teacherViewController new] animated:YES];
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rowBtn:(UIButton *)sender{
    
    NSLog(@"%ld",sender.tag);
}

@end
