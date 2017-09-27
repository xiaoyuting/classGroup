//
//  ZXKSViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/29.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "ZXKSViewController.h"
#import "AppDelegate.h"
#import "ZXKSTableViewCell.h"
#import "SYG.h"
#import "SJXQViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "UIButton+WebCache.h"
#import "MJRefresh.h"
#import "TIXingLable.h"
#import "UIColor+HTMLColors.h"
#import "MBProgressHUD+Add.h"
#import "SYGTextField.h"


@interface ZXKSViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    BOOL isSecet;
    TIXingLable *_txLab;
}

@property (strong ,nonatomic)UIView *allView;

@property (strong ,nonatomic)UIButton *allButton;

@property (strong ,nonatomic)UIView *buyView;

@property (strong ,nonatomic)NSArray *SYGArray;

@property (strong ,nonatomic)SYGTextField *searchText;

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSString *ID;//记录分类里面的id

@property (strong ,nonatomic)NSMutableArray *dataArray;

@property (assign ,nonatomic)NSInteger number;

@property (strong ,nonatomic)UIButton *backButton;

@end

@implementation ZXKSViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    //接受通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eaxm:) name:@"HaiTianEaxm" object:nil];
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
    [self addSearchView];
    [self addTableView];
    [self NetWorkCate];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    
    
//    _SYGArray = @[@"全部",@"外语考试",@"公务员考试",@"建筑考试"];
    
    //添加试图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    imageView.image = [UIImage imageNamed:@"在线考试空白@2x"];
    [self.view addSubview:imageView];
    imageView.hidden = NO;
    imageView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    //接受通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eaxm:) name:@"HaiTianEaxm" object:nil];
}

- (void)eaxm:(NSNotification *)Not {
    NSLog(@"%@",Not.userInfo);
    _user_eaxm = (NSString *)Not.userInfo;
    NSLog(@"%@",_user_eaxm);
    if ([_user_eaxm isEqualToString:@"123"]) {
        _backButton.hidden = NO;
    }
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
    [self.view addSubview:SYGView];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [_backButton setImage:[UIImage imageNamed:@"焦点按钮@2x"] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:_backButton];
//    _backButton = backButton;
    _backButton.hidden = NO;
    if ([_user_eaxm isEqualToString:@"123"]) {
        _backButton.hidden = NO;
    }
    
    
    UIButton *SXButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 30, 32, 20, 20)];
    [SXButton setBackgroundImage:[UIImage imageNamed:@"资讯分类@2x"] forState:UIControlStateNormal];
    [SXButton addTarget:self action:@selector(SXButton) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:SXButton];

    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"考试";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
    
//    NSString *ID = [[UIDevice currentDevice]identifierForVendor].UUIDString;
//    NSLog(@"%@",ID);
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addSearchView {
    _searchText = [[SYGTextField alloc] initWithFrame:CGRectMake(10, 69, MainScreenWidth - 20, 30)];
    _searchText.placeholder = @"搜索";
    _searchText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _searchText.delegate = self;
    _searchText.returnKeyType = UIReturnKeySearch;
    _searchText.font = Font(15);
    [_searchText setValue:Font(16) forKeyPath:@"_placeholderLabel.font"];
    [_searchText sygDrawPlaceholderInRect:CGRectMake(0, 10, 0, 0)];
    _searchText.layer.borderWidth = 5;
    _searchText.layer.cornerRadius = 5;
    _searchText.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _searchText.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,15, 30)];
    _searchText.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_searchText];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 30, 20)];
    [button setImage:Image(@"大风车_搜索_小号") forState:UIControlStateNormal];
    [_searchText.leftView addSubview:button];
    button.hidden = YES;
//    [_searchText addSubview:_searchText];

}

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 105, MainScreenWidth, MainScreenHeight - 105 + 38) style:UITableViewStyleGrouped];
    _tableView.rowHeight = 82 + 10;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _txLab = [[TIXingLable alloc]initWithFrame:CGRectMake(0, 100*MainScreenHeight/667, MainScreenWidth, 30)];
    [_tableView insertSubview:_txLab atIndex:0];
    //添加刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [_tableView headerBeginRefreshing];
    
    //上拉加载
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
}


- (void)headerRerefreshing
{

    [self AANetWork:nil WithNumber:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        if (_dataArray.count==0) {
            _txLab.textColor = [UIColor colorWithHexString:@"#dedede"];
        }else{
            _txLab.textColor = [UIColor clearColor];
        }
    });
    
    
}


- (void)footerRefreshing
{
    
    _number++;
    [self AANetWork:nil WithNumber:_number];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });

}



#pragma mark --- 

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    ZXKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ZXKSTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataWithDict:dict];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSLog(@"----%@",_dataArray[indexPath.row]);
    
    //创建通知
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KSTime:) name:@"notificationTime" object:nil];

    
    SJXQViewController *SJXQVC = [[SJXQViewController alloc] init];
    SJXQVC.ID = _dataArray[indexPath.row][@"exam_id"];
    SJXQVC.titleStr = _dataArray[indexPath.row][@"exam_name"];
    SJXQVC.personCount = _dataArray[indexPath.row][@"count"];
    SJXQVC.startTimeStr = _dataArray[indexPath.row][@"exam_begin_time"];
    SJXQVC.endTimeStr = _dataArray[indexPath.row][@"exam_end_time"];
    SJXQVC.is_test = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"is_test"]];
    SJXQVC.describe = _dataArray[indexPath.row][@"exam_describe"];
    SJXQVC.pager_id = _dataArray[indexPath.row][@"paper_id"];
    SJXQVC.test_number = _dataArray[indexPath.row][@"test_number"];
//    SJXQVC.test_number = @"0";
    SJXQVC.exam_times_mode = _dataArray[indexPath.row][@"exam_times_mode"];

    [self.navigationController pushViewController:SJXQVC animated:YES];
    
}
- (void)SXButton {
    isSecet = !isSecet;
    
    if (isSecet == YES) {//创建
        [self addMoreView];
    }else {//移除
        [self removeMoreView];
    }
}

- (void)addMoreView {
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:_allView];
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
    
    [_allView addSubview:_allButton];
    
    
    
    _buyView = [[UIView alloc] init];
    _buyView.frame = CGRectMake(MainScreenWidth, 64, 100, _SYGArray.count * 40 + 5 * (_SYGArray.count - 1));
    _buyView.backgroundColor = [UIColor colorWithRed:254.f / 255 green:255.f / 255 blue:255.f / 255 alpha:1];
    _buyView.layer.cornerRadius = 3;
    [_allView addSubview:_buyView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(MainScreenWidth - 100, 64, 100, _SYGArray.count * 40 + 5 * (_SYGArray.count - 1));
        //在view上面添加东西
        for (int i = 0 ; i < _SYGArray.count ; i ++) {
            UIButton *button = [[UIButton alloc ] initWithFrame:CGRectMake(0, i * 40 + i * 5, 100, 40)];
            [button setTitle:_SYGArray[i][@"exam_category_name"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:64.f / 255 green:64.f / 255 blue:64.f / 255 alpha:1] forState:UIControlStateNormal];
            button.layer.cornerRadius = 5;
            button.tag = [_SYGArray[i][@"exam_category_id"] integerValue];
            [button addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [_buyView addSubview:button];
            
            
        }
        
        //添加中间的分割线
        for (int i = 0; i < _SYGArray.count; i ++) {
            UIButton *XButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 43 * i , 100, 1)];
            XButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [_buyView addSubview:XButton];
        }
        
        
        
    }];
    
    
}

- (void)removeMoreView {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(MainScreenWidth, 64, 100, _SYGArray.count * 40 + 5 * (_SYGArray.count - 1));
        _allView.alpha = 0;
        _allButton.alpha = 0;
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_buyView removeFromSuperview];
        
    });
    
    
}

- (void)miss {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(MainScreenWidth, 64, 100, _SYGArray.count * 40 + 5 * (_SYGArray.count - 1));
        _allView.alpha = 0;
        _allButton.alpha = 0;
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_buyView removeFromSuperview];
        isSecet = NO;
        
    });
    
    
}

- (void)SYGButton:(UIButton *)button {
    
    isSecet = NO;
    NSLog(@"%@",button.titleLabel.text);
    [self miss];
    
    //将分类的id传过去
    _ID = [NSString stringWithFormat:@"%ld",button.tag];
    NSLog(@"%@",_ID);

    [self AANetWork:nil WithNumber:1];
    _number = 1;

}


//分类里面的请求
- (void)NetWorkCate {
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    
    [manager KSXTFXFL:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",operation);
        _SYGArray = responseObject[@"data"];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        [MBProgressHUD showError:@"数据加载失败" toView:self.view];
        
    }];
    
    
}


- (void)AANetWork:(NSString *)string WithNumber:(NSInteger)num {
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if (_ID == nil) {//没有分类
        [dic setObject:@"0" forKey:@"category_id"];
    }else {//有分类
        [dic setObject:_ID forKey:@"category_id"];
    }
    
    if (_searchText.text.length > 0) {
         [dic setObject:_searchText.text forKey:@"title"];
    }
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {//没有登录的情况下

        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setValue:[NSNumber numberWithInteger:num] forKey:@"page"];
    [dic setValue:@"10" forKey:@"count"];
    
    NSLog(@"%@",dic);
    
    [manager KSXTTab:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"======  %@",responseObject);
        NSLog(@"%@",operation);
        NSArray *LJArray = responseObject[@"data"];
        if (!LJArray.count) {//没有数据了
            
            if (num == 1) {//说明是第一页就没有数据
                
//                [self imageView];//调用懒加载
//                _imageView.hidden = NO;
//                _imageView.alpha = 1;
//                _dataArray = nil;
//                [_tableView reloadData];
//                return ;
            }
            
        }
        
        if (num == 1) {
            _dataArray = [NSMutableArray arrayWithArray:LJArray];
            
        }else {
            NSArray *SYGArray = [NSArray arrayWithArray:LJArray];
            [_dataArray addObjectsFromArray:SYGArray];
            
        }
        
//        [_imageView removeFromSuperview];
//        _imageView.alpha = 0;
        [_tableView reloadData];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"===== dededede  %@    %@",error,operation. responseString);
        
    }];
    
}

#pragma mark --- 监听
- (void)textChange:(NSNotification *)Not {
    
    NSLog(@"%@",_searchText.text);
    
    //这里网络请求 然后刷新表格
    if (_searchText.text.length > 0) {
        
    } else {//没有的时候
        
    }
    
    [self AANetWork:nil WithNumber:1];
}

#pragma mark --- 键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    
}



@end
