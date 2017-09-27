//
//  YunKeTang_questionViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/7/24.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "YunKeTang_questionViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "ZhiyiHTTPRequest.h"
#import "ZXWendaTool.h"

#import "WDTableViewCell.h"
#import "emotionjiexi.h"
#import "SYGWDViewController.h"
#import "SearchView.h"
#import "FBViewController.h"
#import "classifyViewController.h"


@interface YunKeTang_questionViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource> {
    NSInteger _page;
}

@property (strong ,nonatomic)UILabel *titleText;
@property (strong ,nonatomic)NSString *titleStr;
@property (strong ,nonatomic)SYGTextField *searchText;
@property (strong ,nonatomic)UITableView *tableView;

@property(strong, nonatomic)NSMutableArray *muArr;
@property (strong ,nonatomic)NSArray  *userArray;
@property(weak, nonatomic)NSString *wdType;

@property (strong ,nonatomic)UIView *allView;
@property (strong ,nonatomic)UIButton *allButton;
@property (strong ,nonatomic)UIView *buyView;
@property (strong ,nonatomic)NSArray *SYGArray;
@property (strong ,nonatomic)NSArray *titleArray;

@property (strong ,nonatomic)UIButton *classButton;
@property (strong ,nonatomic)NSString *typeStr;

@end

@implementation YunKeTang_questionViewController



-(id)initWithQuiztype:(NSString *)wdtype WithName:(NSString *)nameTitle
{
    self = [super init];
    if (self) {
        self.wdType = wdtype;
        _titleStr = nameTitle;
    }
    return self;
}

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
    [self addSearch];
    [self addTableView];
//    [self addControllerSrcollView];
}
- (void)interFace {
    
    self.view.backgroundColor = [UIColor whiteColor];
    _page = 1;
    _typeStr = @"1";
}

- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    _titleText = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];

    if (_titleStr == nil) {
        _titleText.text = @"问答";
    } else {
        _titleText.text = _titleStr;
    }
    [_titleText setTextColor:BasidColor];
    _titleText.textAlignment = NSTextAlignmentCenter;
    _titleText.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:_titleText];
    
    //添加横线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:button];
    
    //添加发表的按钮
    UIButton *publishButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 80, 30, 20, 20)];
    [publishButton setBackgroundImage:[UIImage imageNamed:@"他去@2x.png"] forState:UIControlStateNormal];
    [publishButton addTarget:self action:@selector(publishButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:publishButton];
    
    //添加分类的按钮
    UIButton *kindButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50, 20, 40, 40)];
    [kindButton setImage:[UIImage imageNamed:@"ic_class@3x"] forState:UIControlStateNormal];
    [kindButton addTarget:self action:@selector(kindButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:kindButton];
}


- (void)addSearch {
    _searchText = [[SYGTextField alloc] initWithFrame:CGRectMake(SpaceBaside, 69, MainScreenWidth - 10 * SpaceBaside, 30)];
    _searchText.placeholder = @"搜索你关心的问题";
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
    
    _searchText.rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,15, 30)];
    _searchText.rightViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_searchText];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(-15, 5, 30, 20)];
    [rightButton setImage:Image(@"ic_search@3x") forState:UIControlStateNormal];
    [_searchText.rightView addSubview:rightButton];
    
    
    
    
    //添加分割线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 8 * SpaceBaside, 74, 1, 20)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:lineButton];
    
    //添加按钮
    UIButton *classButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 70, 69, 60, 30)];
    [classButton setTitle:@"最新" forState:UIControlStateNormal];
    classButton.titleLabel.font = Font(15);
    [classButton setImage:Image(@"ic_dropdown@3x") forState:UIControlStateNormal];
    [classButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    classButton.imageEdgeInsets =  UIEdgeInsetsMake(0,60 - 10,0,0);
    classButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [classButton addTarget:self action:@selector(classButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:classButton];
    
    //添加透明的按钮
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth - 10 * SpaceBaside, 30)];
    clearButton.backgroundColor = [UIColor clearColor];
    [_searchText addSubview:clearButton];
    [clearButton addTarget:self action:@selector(clearButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    _classButton = classButton;
    
}

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 109, MainScreenWidth, MainScreenHeight - 109 + 36) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    //下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [self.tableView headerBeginRefreshing];
    //上拉加载
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
}


- (void)headerRerefreshing
{
    if (self.wdType == nil) {
        [self reloadNewQuestionOfPage:1];
    }else
    {
        [self reloadForNewQuestionOfPage:1];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        
    });
}

- (void)footerRefreshing
{
    _page++;
    if (self.wdType == nil) {
        [self reloadNewQuestionOfPage:_page];
    }else
    {
        [self reloadForNewQuestionOfPage:_page];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
    });
}


#pragma mark --- UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.muArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height + 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellStr = @"WDTableViewCell";
    WDTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (cell == nil) {
        cell = [[WDTableViewCell alloc] initWithReuseIdentifier:cellStr];
    }
    
    if ([self.muArr[indexPath.row][@"userface"] isEqual:[NSNull null]]) {
        
    }else {
        [cell.HeadImage sd_setBackgroundImageWithURL:[NSURL URLWithString:self.muArr[indexPath.row][@"userface"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"站位图"]];
    }
    
    cell.HeadImage.clipsToBounds = YES;
    cell.HeadImage.layer.cornerRadius = 20.0;
    cell.NameLabel.text = [[self.muArr objectAtIndex:indexPath.row] stringValueForKey:@"uname"];
    cell.TimeLabel.text = [[self.muArr objectAtIndex:indexPath.row] stringValueForKey:@"ctime"];

    [cell setIntroductionText:[[self.muArr objectAtIndex:indexPath.row] stringValueForKey:@"wd_description"]];
    //图片
    
    cell.GKLabel.text = [[self.muArr objectAtIndex:indexPath.row] stringValueForKey:@"wd_browse_count"];
    cell.PLLabel.text = [[self.muArr objectAtIndex:indexPath.row] stringValueForKey:@"wd_comment_count"];
    cell.JTLabel.text = [[self.muArr objectAtIndex:indexPath.row] stringValueForKey:@"wd_description"];
    
    NSString *JTStr = [Passport filterHTML:[[self.muArr objectAtIndex:indexPath.row] stringValueForKey:@"wd_description"]];
    cell.JTLabel.text = [NSString stringWithFormat:@"%@",JTStr];
    cell.JTLabel.attributedText = [emotionjiexi jiexienmojconent:JTStr font:[UIFont systemFontOfSize:16]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"_________%@  ====  %@",self.muArr,[[self.muArr objectAtIndex:indexPath.row] class]);
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:[self.muArr objectAtIndex:indexPath.row]];
    
    NSLog(@"--------%@",dic);
    NSString *userId = [dic stringValueForKey:@"id"];
    NSString *title = [dic stringValueForKey:@"wd_title"];
    NSString *description = [dic stringValueForKey:@"wd_description"];
    NSString *uname = [dic stringValueForKey:@"uname"];
    NSString *userFace = [dic stringValueForKey:@"userface"];
    NSString *ctime = [dic stringValueForKey:@"ctime"];
    
    SYGWDViewController *vc = [[SYGWDViewController alloc] initWithQuizID:userId title:title description:description uname:uname userface:userFace ctime:ctime];
    [self.navigationController pushViewController:vc animated:YES];
}





#pragma mark --- 事件点击
- (void)publishButtonCilck {
    FBViewController *FBVC = [[FBViewController alloc] init];
    [self.navigationController pushViewController:FBVC animated:YES];
}

- (void)kindButtonCilck {
    classifyViewController *classfy = [[classifyViewController alloc]init];
    [self.navigationController pushViewController:classfy animated:YES];
}

- (void)clearButtonCilck {
    SearchView *seach = [[SearchView alloc]init];
    [self.navigationController pushViewController:seach animated:YES];
}

- (void)classButtonCilck {
    [self addMoreView];
}

- (void)backPressed {
//    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}



#pragma mark --- 更多的视图

- (void)addMoreView {
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:_allView];
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
    
    [_allView addSubview:_allButton];
    
    _titleArray = @[@"最新",@"最热",@"待回答"];
    _buyView = [[UIView alloc] init];
    _buyView.frame = CGRectMake(MainScreenWidth, 110, 100, _titleArray.count * 40 + 5 * (_titleArray.count - 1));
    _buyView.backgroundColor = [UIColor colorWithRed:254.f / 255 green:255.f / 255 blue:255.f / 255 alpha:1];
    _buyView.layer.cornerRadius = 3;
    [_allView addSubview:_buyView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(MainScreenWidth - 100, 110, 100, _titleArray.count * 40 + 5 * (_titleArray.count - 1));
        //在view上面添加东西
        for (int i = 0 ; i < _titleArray.count ; i ++) {
            UIButton *button = [[UIButton alloc ] initWithFrame:CGRectMake(0, i * 40 + i * 5, 100, 40)];
            [button setTitle:_titleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:64.f / 255 green:64.f / 255 blue:64.f / 255 alpha:1] forState:UIControlStateNormal];
            button.layer.cornerRadius = 5;
            button.tag = i + 1;
            [button addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [_buyView addSubview:button];
            
            
        }
        
        //添加中间的分割线
        for (int i = 0; i < _titleArray.count; i ++) {
            UIButton *XButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 43 * i , 100, 1)];
            XButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [_buyView addSubview:XButton];
        }
        
        
        
    }];
    
    
}

- (void)removeMoreView {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(MainScreenWidth, 110, 100, _titleArray.count * 40 + 5 * (_titleArray.count - 1));
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
        
        _buyView.frame = CGRectMake(MainScreenWidth, 110, 100, _titleArray.count * 40 + 5 * (_titleArray.count - 1));
        _allView.alpha = 0;
        _allButton.alpha = 0;
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_buyView removeFromSuperview];
//        isSecet = NO;
        
    });
    
    
}

- (void)SYGButton:(UIButton *)button {
    
//    isSecet = NO;
//    NSLog(@"%@",button.titleLabel.text);
    [self miss];
    [_classButton setTitle:button.titleLabel.text forState:UIControlStateNormal];
    if (button.tag == [_typeStr integerValue]) {//说明还是没有变
    } else {
        _typeStr = [NSString stringWithFormat:@"%ld",button.tag];
        _page = 1;
    }
    if (_wdType == nil) {
        [self reloadNewQuestionOfPage:_page];
    } else {
        [self reloadForNewQuestionOfPage:_page];
    }

//
//    //将分类的id传过去
//    _ID = [NSString stringWithFormat:@"%ld",button.tag];
//    NSLog(@"%@",_ID);
//    
//    [self AANetWork:nil WithNumber:1];
//    _number = 1;
    
}



#pragma mark ---- 网络请求
-(void)reloadNewQuestionOfPage:(NSInteger)page
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:_typeStr forKey:@"type"];
    [dic setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    [dic setObject:@"20" forKey:@"count"];
    
    NSArray *ZXArray = [ZXWendaTool wendaWithDic:dic];
    [manager reloadNewQuesttion:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"##%@",responseObject);
        if (ZXArray.count) {
        } else {
            [ZXWendaTool saveWendaes:responseObject[@"data"]];
        }
        
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {
            [MBProgressHUD showError:@"还没有问答" toView:self.view];
            return;
        } else {
            NSMutableArray *muarr = [[NSMutableArray alloc]initWithCapacity:0];
            NSArray *arr = [NSArray arrayWithArray:[responseObject objectForKey:@"data"]];
            _userArray = responseObject[@"data"];
            
            if (arr == 0) {
                return;
            }
            for (int i = 0; i <arr.count; i++) {
                NSDictionary *NB = [[NSDictionary alloc]initWithDictionary:[arr objectAtIndex:i]];
                [muarr addObject:NB];
            }
            
            if (page == 1) {
                self.muArr = [NSMutableArray arrayWithArray:_userArray];
            }else {
                NSArray *SYGArray = [NSArray arrayWithArray:_userArray];
                [self.muArr addObjectsFromArray:SYGArray];
            }
            [_tableView reloadData];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"数据加载失败" toView:self.view];
    }];
    
}


-(void)reloadForNewQuestionOfPage:(NSInteger)page
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:self.wdType forKey:@"wdtype"];
    [dic setObject:_typeStr forKey:@"type"];
    [dic setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    [dic setObject:@"20" forKey:@"count"];
    
    NSLog(@"%@",dic);
    [manager reloadNewQuesttion:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {
            [MBProgressHUD showError:@"还没有问答" toView:self.view];
            return ;
        } else {
            
            NSArray *pageArray = [NSArray arrayWithArray:responseObject[@"data"]];
            if (page == 1) {//说明是第一页的数据
                self.muArr = [NSMutableArray arrayWithArray:pageArray];
            } else {
                NSArray *pageArray = [NSArray arrayWithArray:responseObject[@"data"]];
                if (pageArray.count == 0) {
                    return ;
                }
                [self.muArr addObjectsFromArray:pageArray];
            }
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"数据加载失败" toView:self.view];
    }];
}






@end
