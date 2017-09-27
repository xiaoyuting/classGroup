//
//  LiveMoreViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/9.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "LiveMoreViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "rootViewController.h"

#import "LiveMoreCell.h"


@interface LiveMoreViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)UIButton *HDButton;
@property (strong ,nonatomic)UIButton *seletedButton;
@property (assign ,nonatomic)CGFloat buttonW;

@end

@implementation LiveMoreViewController

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
    [self addWZView];
    [self addTableView];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
//    _dataArray = [NSMutableArray array];
//    _oldContentY = 0;
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
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 60, 30)];
    WZLabel.text = @"直播课";
    [WZLabel setTextColor:BasidColor];
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addWZView {
    UIView *WZView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 34)];
    WZView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:WZView];
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [self.view addSubview:lineLab];
    //添加按钮
    NSArray *titleArray = @[@"今天",@"11月10",@"11月11",@"11月12",@"11月13"];
    
    CGFloat ButtonH = 20;
    CGFloat ButtonW = MainScreenWidth / titleArray.count;
    _buttonW = ButtonW;
    for (int i = 0; i < titleArray.count; i ++) {
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(ButtonW * i, 7, ButtonW, ButtonH);
        button.tag = i;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor colorWithRed:89.f / 255 green:89.f / 255 blue:89.f / 255 alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [button addTarget:self action:@selector(WZButton:) forControlEvents:UIControlEventTouchUpInside];
        [WZView addSubview:button];
        if (i == 0) {
            [self WZButton:button];
        }
        
    }
    
    //添加横线
    _HDButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 27 + 3, ButtonW, 1)];
    _HDButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [WZView addSubview:_HDButton];
    
    
}

- (void)WZButton:(UIButton *)button {
    
    self.seletedButton.selected = NO;
    button.selected = YES;
    self.seletedButton = button;
    
    [UIView animateWithDuration:0.25 animations:^{
        _HDButton.frame = CGRectMake(button.tag * _buttonW, 27 + 3, _buttonW, 1);
    }];

}



- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 98, MainScreenWidth, MainScreenHeight - 98) style:UITableViewStyleGrouped];
    _tableView.rowHeight = 100;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}

#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    LiveMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //自定义cell类
    if (cell == nil) {
        cell = [[LiveMoreCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
//    NSDictionary *dict = _dataArray[indexPath.row];
//    [cell dataSourceWith:dict];
    
    return cell;
    
}

#pragma mark --- 得到日期




@end
