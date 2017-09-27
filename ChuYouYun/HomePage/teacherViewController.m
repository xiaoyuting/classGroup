//
//  teacherViewController.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/21.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "teacherViewController.h"
#import "teacherTableViewCell.h"
#import "MyHttpRequest.h"
#import "teacherList.h"
#import "SYG.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "teacherDetailViewController.h"
#import "TeacherTool.h"
#import "SYGTeacherDViewController.h"
#import "GLReachabilityView.h"
#import "UIColor+HTMLColors.h"
#import "TeacherDetilViewController.h"
#import "MBProgressHUD+Add.h"
#import "GLTeaTableViewCell.h"


#import "TeacherMainViewController.h"


#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))
@interface teacherViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UITableView * _tableView;
    int  _page;//页数
    UIView *_view;
    UILabel *_lable;
    UISearchBar *searchBar;
    
}
@property(nonatomic,assign)NSInteger numder;

@property (strong ,nonatomic)UISearchBar *searchBar;

@property (strong ,nonatomic)UIImageView *imageView;

@end

@implementation teacherViewController


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
    
    _view = (UIView *)[GLReachabilityView popview];
    [self.view addSubview:_view];
    [self addNav];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight-28) style:UITableViewStyleGrouped];
    _lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 100,MainScreenWidth, 12)];
    [_tableView addSubview:_lable];
    [_tableView insertSubview:_lable atIndex:0];
    _lable.text = @"数据为空，刷新重试";
    _lable.textAlignment = NSTextAlignmentCenter;
    _lable.textColor = [UIColor clearColor];
    _lable.font = [UIFont systemFontOfSize:14];
    _lable.hidden = YES;

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 130;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView.showsVerticalScrollIndicator =
    NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    
    //添加搜索
    
//     searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth-45, 44)];
//    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(searchBar.frame.origin.x+searchBar.frame.size.width, 64, 35, 44)];
//    [btn setTitle:@"取消" forState:UIControlStateNormal];
//   [btn setTitleColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] forState:UIControlStateNormal]; 
//    [self.view addSubview:btn];
//    btn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [btn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
//    searchBar.placeholder = @"搜索";
//    searchBar.delegate = self;
//    searchBar.layer.borderWidth = 0.1;
//    searchBar.layer.borderColor = [UIColor whiteColor].CGColor;
//    searchBar.barTintColor = [UIColor groupTableViewBackgroundColor];
//    //    searchBar.tintColor = [UIColor redColor];
//    searchBar.searchBarStyle = UISearchBarStyleMinimal;
//    [self.view addSubview:searchBar];
//    _searchBar = searchBar;

    
    
    //下拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [_tableView headerBeginRefreshing];
    
    //上拉加载
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,10,0,0)];
    }
    
    //设置表格分割线的长度（跟两边的距离）
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,10,0,0)];
    }
    [self reachGO];
}
- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"讲师";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 70, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,56)];
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
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancel{

    searchBar.text = @"";
    //隐藏键盘
    [_searchBar resignFirstResponder];
    //这里进行网络请求
    if (![GLReachabilityView isConnectionAvailable]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络连接已断开,请查看网络设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self searchNet:1];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    

}
//
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{

    if (searchBar.text.length) {
        
        [self searchNet:1];
        [_tableView reloadData];
        
    }else{
        
        [self searchNet:0];
        [_tableView reloadData];
    }
}
- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event{
    _searchBar.text = @"";
    if ([_searchBar isFirstResponder]) {
        [self searchNet:1];
    }
    //隐藏键盘
    [_searchBar resignFirstResponder];
}

- (void)searchNet:(NSInteger) num {
    
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    //    [dic setValue:[NSNumber numberWithInteger:num] forKey:@"page"];
    [dic setValue:_searchBar.text forKey:@"name"];
    [dic setValue:@"20" forKey:@"count"];
    
    [manager getTeacherListSX:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        NSMutableArray * array = [responseObject objectForKey:@"data"];
        if(array.count == 0){
            //添加空处理
            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 108, MainScreenWidth, MainScreenHeight - 108 - 60)];
            _imageView.image = [UIImage imageNamed:@"讲师@2x"];
            //[self.view addSubview:_imageView];
            [_tableView insertSubview:_imageView atIndex:0];
            _imageView.hidden = NO;
            
        }else{
            
            _imageView.hidden = YES;
            [_tableView reloadData];
        }
        _dataArray = responseObject[@"data"];
        
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)titleSet {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)reachGO{
    
    if([GLReachabilityView isConnectionAvailable]==1){

    }else{
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"无网络连接" toView:self.view];
    }
}

- (void)headerRerefreshing
{
    [self reachGO];
    _imageView.hidden = YES;
    _numder = 1;
    [self requestData:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        if (_dataArray.count == 0) {
            _lable.textColor = [UIColor colorWithHexString:@"#dedede"];

        }else{
            _lable.textColor = [UIColor clearColor];

        }
    });
}

- (void)footerRefreshing
{
    _numder++;
    if (_searchBar.text.length > 0) {
        //这里调用搜索老师的方法
        [self searchNet:_numder];
        
    }else {
        [self requestData:_numder];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
    
}

-(void)requestData:(NSInteger)num
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:[NSNumber numberWithInteger:num] forKey:@"page"];
    [dic setValue:@"10" forKey:@"count"];
    
    NSArray *TeacherArray = [TeacherTool teacherWithDic:dic];
    
    if([GLReachabilityView isConnectionAvailable]==0){
        
        //取出本地的数据
        if (_dataArray.count==0) {
            
            _dataArray = [NSMutableArray arrayWithArray:TeacherArray];
            
        }
        [_tableView reloadData];
        return;
    }

    [manager getTeacherList:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);

        if (TeacherArray.count) {//本地已经有数据了
            NSLog(@"不需要");
        } else {
            //保存数据
            [TeacherTool saveTeacheres:responseObject[@"data"]];
        }
        NSMutableArray * array;
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            array = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        }
        if(IsNilOrNull(array))
        {
            
        }else{

            if(num==1)
            {
                _dataArray = [NSMutableArray arrayWithArray:array];
            }
            else{
                [_dataArray addObjectsFromArray:array];

            }
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //取出本地的数据
        if (_dataArray.count==0) {
            
            _dataArray = [NSMutableArray arrayWithArray:TeacherArray];

        }
        [_tableView reloadData];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"获取数据失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }];

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellStr = @"GLTeaTableViewCell";
    GLTeaTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellStr];
    if (cell == nil) {
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        cell = [[GLTeaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellStr];
    }
//    cell.contentLab.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"inro"]];
    cell.backgroundColor = [UIColor whiteColor];

    cell.nameLab.text = [NSString stringWithFormat:@"%@",[[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"name"]];
    NSLog(@"===33333==%@",_dataArray[indexPath.row]);
    
    
    if ([[[_dataArray objectAtIndex:indexPath.row] dictionaryValueForKey:@"school_info"] count]) {
        cell.JGLab.text = [NSString stringWithFormat:@"%@",[[[_dataArray objectAtIndex:indexPath.row] dictionaryValueForKey:@"school_info"] stringValueForKey:@"title"]];
    }
    
    
    
    cell.img.image = [UIImage imageNamed:@"站位图"];//展位图
    NSString *url = [NSString stringWithFormat:@"%@",[[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"headimg"]];
    [cell.img sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"站位图"]];
    cell.img.layer.cornerRadius = 50;
    cell.img.layer.masksToBounds = YES;
    
    NSString *tagstr1 = [NSString stringWithFormat:@"%@年教龄",_dataArray[indexPath.row][@"teacher_age"]];
    CGRect frames = cell.tagLab1.frame;
    frames.size.width = tagstr1.length *10 +5;
    cell.tagLab1.frame = frames;
    cell.tagLab1.text = tagstr1;
    cell.tagLab1.font = Font(10);
    if ([tagstr1 isEqualToString:@"<null>"]) {
        cell.tagLab1.text = @"未知";
    } else {
        cell.tagLab1.text = tagstr1;
    }
    
    NSString *tagstr2 = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"teach_evaluation"]];
    CGRect frame2 = cell.tagLab2.frame;
    frame2.size.width = tagstr2.length *10 +5;
    frame2.origin.x = frames.origin.x + frames.size.width + 10;
    cell.tagLab2.frame = frame2;
    cell.tagLab2.text = tagstr2;
    cell.tagLab2.font = Font(10);
    if (cell.tagLab2.text.length > 4) {
        cell.tagLab2.text = [tagstr2 substringToIndex:4];
        frame2.size.width = 4 *10 +5;
        frame2.origin.x = frames.origin.x + frames.size.width + 10;
        cell.tagLab2.frame = frame2;
    }
    
    NSLog(@"%@",tagstr2);
    if ([tagstr2 isEqualToString:@"<null>"]) {
        cell.tagLab2.text = @"未知";
    } else {
        cell.tagLab2.text = tagstr2;
    }
    
    NSString *tagstr3 = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"graduate_school"]];
    CGRect frame3 = cell.tagLab3.frame;
    frame3.size.width = tagstr3.length *10 +5;
    frame3.origin.x = frame2.origin.x + frame2.size.width + 10;
    cell.tagLab3.font = Font(10);
    
    cell.tagLab3.frame = frame3;
    NSLog(@"----%@",tagstr3);
    if (tagstr3.length > 4) {
        cell.tagLab3.text = [tagstr3 substringToIndex:4];
        frame3.size.width = 4 *10 +5;
        frame3.origin.x = frame2.origin.x + frame2.size.width + 10;
        cell.tagLab3.frame = frame3;
    }
    
    
    if ([tagstr3 isEqualToString:@"<null>"]) {
        cell.tagLab3.text = @"未知";
    } else {
        cell.tagLab3.text = tagstr3;
    }

    
    
//    
//    if (cell.tagLab3.text.length > 4) {
//        cell.tagLab3.text = [tagstr2 substringToIndex:4];
//        frame3.size.width = 4 *10 +5;
//        frame3.origin.x = frames.origin.x + frames.size.width + 10;
//        cell.tagLab3.frame = frame2;
//    }

    
    
//    NSString *tagstr4 = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"school_info"][@"title"]];
//    CGRect frame4 = cell.tagLab4.frame;
//    frame4.size.width = tagstr4.length *13 +5;
//    frame4.origin.x = frame3.origin.x + frame3.size.width + 5;
//    cell.tagLab4.frame = frame4;
//    cell.tagLab4.text = tagstr4;
    
    cell.contentLab.text = nil;
    if ([_dataArray[indexPath.row][@"inro"] isEqual:[NSNull null]]) {
        cell.contentLab.text = @"";
    } else {
        cell.contentLab.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"inro"]];
    }
    cell.contentLab.font = Font(14);

    NSString *area = [NSString stringWithFormat:@"%@",[[[_dataArray objectAtIndex:indexPath.row] dictionaryValueForKey:@"ext_info"] stringValueForKey:@"location"]];

    cell.areaLab.text = [NSString stringWithFormat:@"%@",area];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // [GLReachabilityView isConnectionAvailable];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    TeacherDetilViewController *Tvc = [[TeacherDetilViewController alloc]initWithNumID:_dataArray[indexPath.row][@"id"]];
//    [self.navigationController pushViewController:Tvc animated:YES];
    
    
    TeacherMainViewController *teacherMainVc = [[TeacherMainViewController alloc] initWithNumID:_dataArray[indexPath.row][@"id"]];
    [self.navigationController pushViewController:teacherMainVc animated:YES];
}

//移除警告框
- (void)removeAlert:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
}

@end
