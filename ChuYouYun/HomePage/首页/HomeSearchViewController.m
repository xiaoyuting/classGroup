//
//  HomeSearchViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/9/28.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "HomeSearchViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "MBProgressHUD+Add.h"
#import "SYGTextField.h"

#import "HomeSearchCell.h"
#import "SearchGetViewController.h"



@interface HomeSearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)SYGTextField *searchText;

@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)NSMutableArray *dataSource;
@property (strong ,nonatomic)NSArray *netArray;
@property (strong ,nonatomic)NSArray *headerTitleArray;
@property (strong ,nonatomic)NSMutableArray *divArray;
@property (strong ,nonatomic)NSArray *hotSearchArray;

@property (strong ,nonatomic)UIButton *seletedButton;

@end

@implementation HomeSearchViewController

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
    [self addArray];
    [self addNav];
    [self addTypeView];
//    [self addHeaderView];
//    [self addTableView];
    [self netWorkHomeGetHotSearch];
}

- (void)addArray {
    
    _dataArray = [NSMutableArray array];
    _dataSource = [NSMutableArray array];
    _headerTitleArray = @[@"历史记录"];
    _typeStr = @"1";
    [self getDataSource];

}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _typeStr = @"0";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nameAndPassword:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    //返回按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50, 20, 40, 40)];
//    [backButton setImage:[UIImage imageNamed:@"点评返回@2x"] forState:UIControlStateNormal];
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    backButton.titleLabel.font = Font(15);
    [backButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    
    //添加分类筛选的按钮
    UIButton *typeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 25, 61, 30)];
    [typeButton setTitle:@"课程" forState:UIControlStateNormal];
    [typeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [typeButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
    typeButton.titleLabel.font = Font(14);
    
    typeButton.imageEdgeInsets =  UIEdgeInsetsMake(0,40,0,0);
    typeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 20);
    
    typeButton.layer.borderWidth = 1;
    typeButton.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [typeButton addTarget:self action:@selector(typeButton:) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:typeButton];
    _typeButton = typeButton;
    typeButton.hidden = YES;

    
//    //添加搜索
   _searchText = [[SYGTextField alloc] initWithFrame:CGRectMake(20, 25, MainScreenWidth - 80, 30)];
    _searchText.placeholder = @"搜索科目、老师、课程、机构";
    _searchText.font = Font(15);
    [_searchText setValue:Font(16) forKeyPath:@"_placeholderLabel.font"];
    [_searchText sygDrawPlaceholderInRect:CGRectMake(0, 10, 0, 0)];
    _searchText.delegate = self;
    _searchText.returnKeyType = UIReturnKeySearch;
    _searchText.layer.cornerRadius = 5;
    _searchText.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _searchText.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _searchText.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, 6, 18, 18)];
    [button setImage:Image(@"yunketang_search") forState:UIControlStateNormal];
    [_searchText.leftView addSubview:button];
    [SYGView addSubview:_searchText];

}

- (void)addTypeView {
    
    UIView *typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 30)];
    typeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:typeView];
    
    NSArray *typeArray = @[@"视频",@"直播",@"机构",@"老师"];
    
    CGFloat typeW = MainScreenWidth / typeArray.count;
    CGFloat buttonW = 60;
    CGFloat space = (typeW - buttonW)/ 2;
    CGFloat buttonH = 20;
    
    for (int i = 0 ; i < typeArray.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * typeW + space, 0, buttonW, buttonH)];
        [button setTitle:typeArray[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = Font(14);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitleColor:BlackNotColor forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 1;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = BasidColor.CGColor;
        button.tag = 521 + i;
        
        [typeView addSubview:button];
        [button addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            [self typeButtonClick:button];
        }
        
    }
    
    
}


- (void)typeButtonClick:(UIButton *)button {

    self.seletedButton.selected = NO;
    self.seletedButton.backgroundColor = [UIColor whiteColor];
    button.selected = YES;
    button.backgroundColor = BasidColor;
    self.seletedButton = button;

    _typeStr = [NSString stringWithFormat:@"%ld",button.tag - 520];
    if (button.tag == 521) {//课程
        
    } else if (button.tag == 522){//直播
        
    } else if (button.tag == 523) {//老师
        
    } else if (button.tag == 524) {//机构
        
    }


}



- (void)addHeaderView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 170)];
    _headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_headerView];
    _headerView.hidden = NO;
    
    //添加 文本
    UILabel *hotL = [[UILabel alloc] initWithFrame:CGRectMake(0, SpaceBaside, MainScreenWidth, 20)];
    hotL.text = @"热门推荐";
    hotL.font = Font(12);
    hotL.textColor = [UIColor grayColor];
    [_headerView addSubview:hotL];
    
    //添加热门学科
    CGFloat ButtonW = (MainScreenWidth - 4 * SpaceBaside ) / 3;
    CGFloat ButtonH = 40;
//    NSArray *titleArray = @[@"小学",@"初中",@"高中",@"大学",@"英语",@"数学",@"舞蹈",@"瑜伽",@"职业"];
    for (int i = 0 ; i < _hotSearchArray.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((SpaceBaside + ButtonW) * (i % 3), 35 + (ButtonH + SpaceBaside) * (i / 3), ButtonW, ButtonH)];
        [button setTitle:_hotSearchArray[i][@"sk_name"] forState:UIControlStateNormal];
        [button setTitleColor:BlackNotColor forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = Font(14);
        [_headerView addSubview:button];
        [button addTarget:self action:@selector(headerButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    //设置头部的大小
    if (_hotSearchArray.count % 3 == 0) {
        _headerView.frame = CGRectMake(0, 0, MainScreenWidth, 50 * (_hotSearchArray.count / 3) + 20);

    } else {
        _headerView.frame = CGRectMake(0, 0, MainScreenWidth, 50 * (_hotSearchArray.count / 3 + 1) + 20);
    }
}

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(SpaceBaside, 64 + 30, MainScreenWidth - 2 * SpaceBaside, MainScreenHeight - 64 - 30) style:UITableViewStyleGrouped];
    _tableView.rowHeight = 50;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = _headerView;
}

#pragma mark --- UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (_dataArray.count) {
        return @"搜索所得";
    }
    
    return _headerTitleArray[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_dataSource.count) {
        return 0;
    }
    NSArray *array = _dataSource[section];
    return array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellID = nil;
    CellID = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    //自定义cell类
    HomeSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //自定义cell类
    if (cell == nil) {
        cell = [[HomeSearchCell alloc] initWithReuseIdentifier:CellID];
    }

    
    if (!_dataArray.count && !_netArray.count) {
        
        cell.contentLabel.text = _dataSource[indexPath.section][indexPath.row];
        if (indexPath.section == 0) {
            if (indexPath.row == _divArray.count - 1) {
                cell.contentLabel.textAlignment = NSTextAlignmentCenter;
            }
        }

    } else {
        
        cell.contentLabel.text = _dataSource[indexPath.section][indexPath.row][@"video_title"];
        
        NSLog(@"dic---%@",_divArray);
        if (indexPath.section == 1) {
            if (indexPath.row == _divArray.count - 1) {
                cell.contentLabel.textAlignment = NSTextAlignmentCenter;
            }
        } else if (indexPath.section == 0) {
            cell.contentLabel.textAlignment = NSTextAlignmentLeft;
        }

    }
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    if (!_dataArray.count) {
        if (indexPath.row == _divArray.count - 1) {//清除缓存
            [self removeBenDi];
            return;
        }
    } else {//有推荐
        if (indexPath.section == 0) {//推荐的
            [self readIn];
        } else {
            if (indexPath.row == _divArray.count - 1) {//清除缓存
                [self removeBenDi];
                return;
            }
        }
    }

    NSLog(@"%@",_typeStr);
    SearchGetViewController *searchGetVc = [[SearchGetViewController alloc] init];
    searchGetVc.typeStr = _typeStr;
    if (_netArray.count) {
        searchGetVc.searchStr = _dataSource[indexPath.section][indexPath.row][@"video_title"];
    } else {
        searchGetVc.searchStr = _dataSource[indexPath.section][indexPath.row];
    }

    [self.navigationController pushViewController:searchGetVc animated:YES];

}


#pragma mark --- 事件监听

- (void)backPressed {
    
     [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark --- UITextField

- (void)nameAndPassword:(NSNotification *)Not {

    //这里随时进行网络请求

    if (_searchText.text.length > 0) {
//        for (int i = 0 ; i < 3 ; i ++) {
//            [_dataArray addObject:_searchText.text];
//        }
//        [_dataSource removeAllObjects];
//        
//        [_dataSource addObject:_dataArray];
        [self netWorkHomeSearch];

    } else if (_searchText.text.length == 0) {//没有的时候
        //置空数据
        _netArray = nil;
        [_dataSource removeAllObjects];
        [self getDataSource];
    }
    
    [_tableView reloadData];
}

- (void)getDataSource {
    
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *plistPath = [libPath stringByAppendingPathComponent:@"seekRecode.plist"];
    NSArray *lookArray = [NSArray arrayWithContentsOfFile:plistPath];
    lookArray = [NSArray arrayWithContentsOfFile:plistPath];
    NSMutableArray *divArray = [NSMutableArray arrayWithArray:lookArray];
    _divArray = divArray;
    if (divArray.count) {//当存储有值时 就在
        [divArray addObject:@"清除搜索历史"];
    }
    
    for (int i = 0 ; i < 1; i ++) {
        [_dataSource addObject:divArray];
    }
    [_tableView reloadData];

}

//存数据
- (void)readIn {
    
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *plistPath = [libPath stringByAppendingPathComponent:@"seekRecode.plist"];
    NSMutableArray *seekArray = [NSMutableArray arrayWithContentsOfFile:plistPath];

    if (!seekArray.count) {//说明是第一次
        
        NSMutableArray *div = [NSMutableArray arrayWithArray:seekArray];
        [div addObject:_searchText.text];
        [div writeToFile:plistPath atomically:YES];
   
    } else {
        for ( NSString *key in seekArray) {
            
            if ([key isEqualToString:_searchText.text]) {//有数据不保存
                return;
            }
        }
        
        if (_searchText.text.length == 0) {
            return;
        }
        
        NSMutableArray *div = [NSMutableArray arrayWithArray:seekArray];
        [div addObject:_searchText.text];
        [div writeToFile:plistPath atomically:YES];
        
    }

}

- (void)readInWithButton:(UIButton *)button {
    
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *plistPath = [libPath stringByAppendingPathComponent:@"seekRecode.plist"];
    NSMutableArray *seekArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    
    if (!seekArray.count) {//说明是第一次
        
        NSMutableArray *div = [NSMutableArray arrayWithArray:seekArray];
        [div addObject:button.titleLabel.text];
        [div writeToFile:plistPath atomically:YES];
        
    } else {
        
        for (NSString *key in seekArray) {
            if ([key isEqualToString:button.titleLabel.text]) {//有数据不保存
                return;
            }
        }
        
        NSMutableArray *div = [NSMutableArray arrayWithArray:seekArray];
        [div addObject:button.titleLabel.text];
        [div writeToFile:plistPath atomically:YES];
  
    }

}


- (void)removeBenDi {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *caches = [libPath stringByAppendingPathComponent:@"seekRecode.plist"];
    [manager removeItemAtPath:caches error:nil];
    [_divArray removeAllObjects];
    [_tableView reloadData];
    
}

#pragma mark --- 事件监听

- (void)typeButton:(UIButton *)button {
    [self addMoreView];
}

- (void)addMoreView {
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:_allView];
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
    
    [_allView addSubview:_allButton];

    //创建个VIew
    _buyView = [[UIView alloc] initWithFrame:CGRectMake(10, 64, 100, 0)];
    _buyView.backgroundColor = BasidColor;
    _buyView.layer.cornerRadius = 3;
    [_allView addSubview:_buyView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        //改变位置 动画
        _buyView.frame = CGRectMake(10 ,64 ,100, 128);
        
        //在view上面添加东西
        NSArray *GDArray = @[@"课程",@"机构",@"老师"];
        for (int i = 0 ; i < GDArray.count ; i ++) {
            UIButton *button = [[UIButton alloc ] initWithFrame:CGRectMake(0, i * 40 + i * 5, 100, 40)];
            [button setTitle:GDArray[i] forState:UIControlStateNormal];
            button.layer.cornerRadius = 5;
            button.tag = 521 + i;
            [button addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [_buyView addSubview:button];
        }
    }];
}

- (void)miss {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(10, 64, 100, 0);
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_buyView removeFromSuperview];
        
    });
 
}

- (void)SYGButton:(UIButton *)button {
    [_typeButton setTitle:button.titleLabel.text forState:UIControlStateNormal];
    _typeStr = [NSString stringWithFormat:@"%ld",button.tag - 520];
    [self miss];
    if (button.tag == 521) {//课程
        
        
    } else if (button.tag == 522){//老师
        _typeStr = @"4";
        
    } else if (button.tag == 523) {//机构
        
    }
    
    
}

- (void)headerButton:(UIButton *)button {

    SearchGetViewController *searchGetVc = [[SearchGetViewController alloc] init];
    searchGetVc.searchStr = button.titleLabel.text;
    searchGetVc.typeStr = _typeStr;
    [self.navigationController pushViewController:searchGetVc animated:YES];
    
    //添加记录
    [self readInWithButton:button];
}

#pragma mark --- 键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"123");
    //点搜索按钮
    if (_searchText.text.length > 0) {
        //将数据存在本地
        [self readIn];
        SearchGetViewController *searchGetVc = [[SearchGetViewController alloc] init];
        searchGetVc.searchStr = _searchText.text;
        searchGetVc.typeStr = _typeStr;
        [self.navigationController pushViewController:searchGetVc animated:YES];
    }
    
    [textField becomeFirstResponder];
    if ([textField.text isEqualToString:@"\n"]){
        return NO;
    }
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_searchText resignFirstResponder];
}


#pragma mark --- 网络请求
//获取搜索
- (void)netWorkHomeSearch {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    [dic setObject:@"1" forKey:@"page"];
    [dic setObject:@"20" forKey:@"count"];
    [dic setObject:_typeStr forKey:@"type"];
    [dic setObject:_searchText.text forKey:@"keyword"];
    NSLog(@"%@",dic);
    
    [manager BigWinCar_HomeSearch:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);

        if ([responseObject[@"code"] integerValue] != 1) {
            [MBProgressHUD showError:@"没有搜索的结果" toView:self.view];
            return;
        }
        NSArray *listArray = responseObject[@"data"][0][@"list"];
        _netArray = listArray;
        if (_netArray.count == 0) {
        }
        [_dataSource removeAllObjects];
        [_dataSource addObject:listArray];
        [_tableView reloadData];
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}
//获取热门搜索
- (void)netWorkHomeGetHotSearch {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    [dic setObject:@"9" forKey:@"count"];
    
    [manager BigWinCar_HomeGetHotKeyword:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] != 1) {
            [MBProgressHUD showError:@"请求失败" toView:self.view];
            _hotSearchArray = nil;
        } else {
            _hotSearchArray = responseObject[@"data"];
        }
        
        _hotSearchArray = responseObject[@"data"];
        if (_hotSearchArray.count == 0) {
            [MBProgressHUD showError:@"暂时没有数据" toView:self.view];
            return ;
        }
        [self addHeaderView];
        [self addTableView];
        [_tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"请求失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alter show];
        _hotSearchArray = nil;
        [self addHeaderView];
        [self addTableView];
        [_tableView reloadData];
    }];
    
}


@end
