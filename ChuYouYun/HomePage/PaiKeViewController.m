//
//  PaiKeViewController.m
//  dafengche
//
//  Created by IOS on 16/10/18.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "PaiKeViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "PaiKeTableViewCell.h"
#import "MyHttpRequest.h"
#import "Passport.h"
#import "MBProgressHUD+Add.h"


@interface PaiKeViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{

    NSArray *_menuarr;
    UIButton *menubtn;
    int numsender;
    int tempNumber;


}

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSArray *lookArray;

@property (strong ,nonatomic)NSArray *dataArray;

@property (strong ,nonatomic)UIScrollView *headScrollow;

///顶部btn集合
@property (strong, nonatomic) NSArray *btns;

@end

@implementation PaiKeViewController

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
-(void)requestData:(NSInteger)num andTimespan:(NSString *)timespan
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSString *scheme  = @"http://dafengche.51eduline.com/?app=api&mod=School&act=getArrange";
    NSDictionary *parameter=@{@"school_id":_schoolID,@"page":@"1",@"count": @"20",@"timespan":timespan};
    
    [manager getpublicPort:parameter mod:@"School" act:@"getArrange" success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"===__===%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        _lookArray = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        [MBProgressHUD showSuccess:responseObject[@"msg"] toView:self.view];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"新增收货地址失败" toView:self.view];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addNav];
    [self addscrollow];
    [self creatMenu];
    [self addTableView];
    [self netWorkGetArrange];

}
-(void)addscrollow{
    _headScrollow = [[UIScrollView alloc]initWithFrame:CGRectMake(0,66, MainScreenWidth,40*MainScreenWidth/375)];
    _headScrollow.delegate = self;
    _headScrollow.alwaysBounceVertical = NO;
    _headScrollow.pagingEnabled = NO;
    _headScrollow.backgroundColor = [UIColor whiteColor];
    //同时单方向滚动
    _headScrollow.directionalLockEnabled = YES;
    _headScrollow.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:_headScrollow];
    _headScrollow.showsVerticalScrollIndicator = NO;
    _headScrollow.showsHorizontalScrollIndicator = NO;
    _headScrollow.delegate = self;

}
- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headScrollow.current_y_h+15*MainScreenWidth/375, MainScreenWidth, MainScreenHeight - _headScrollow.current_y_h-15) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50*MainScreenWidth/320;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;

    
}
#pragma mark -- UITableViewDatasoure

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"PaiKeTableViewCell";
    PaiKeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[PaiKeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.startLab.text = [Passport glTime:@"1479198346"];
        cell.endLab.text = [Passport glTime:@"1479201946"];
//        cell.imageView.image = [UIImage imageNamed:@"你好"];
//        cell.textLabel.text = @"123dsfghj";
    }
    //cell.textLabel.text = _lookArray[indexPath.row][@"video_title"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"点击了ecell");
    //classDetailVC *classDVc = [[classDetailVC alloc] initWithMemberId:_lookArray[indexPath.row][@"id"] andPrice:nil andTitle:_lookArray[indexPath.row][@"video_title"]];
    //classDVc.isLoad = @"123";
    // [self.navigationController pushViewController:classDVc animated:YES];
    
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}
- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"排课";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
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
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)creatMenu{
    //自定义segment区域
    NSMutableArray *marr = [NSMutableArray array];
    _menuarr = [NSArray arrayWithObjects:@"10月12日",@"10月12日",@"10月12日",@"10月12日", @"10月12日",nil];
    UIColor *ffbbcolor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
    for (int i=0; i<_menuarr.count; i++) {
        menubtn = [[UIButton alloc]init];
        menubtn.frame = CGRectMake(65*horizontalrate*i+(i+1)*(MainScreenWidth- (65*horizontalrate * 4))/(4 + 1), 0, 65*horizontalrate, 40*MainScreenWidth/375);
        [menubtn setTitle:_menuarr[i] forState:UIControlStateNormal];
        [_headScrollow addSubview:menubtn];
        menubtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [menubtn setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
        menubtn.tag = 100+i;
        menubtn.titleLabel.font = [UIFont systemFontOfSize:15*MainScreenWidth/375];
        [menubtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            [menubtn setTitleColor:ffbbcolor forState:UIControlStateNormal];
        }
        [marr addObject:menubtn];
    }
    self.btns = [marr copy];
    int tempNum;
    tempNum = (int)_menuarr.count;
    _headScrollow.contentSize = CGSizeMake(65*horizontalrate*tempNum+(tempNum+1)*(MainScreenWidth- (65*horizontalrate * 4))/(4 + 1), _headScrollow.bounds.size.height);

}
-(void)change:(UIButton *)sender{
    
    int tempNum;
    tempNum = (int)_menuarr.count;
    //请求数据
//    [self requestData:tempNum andTimespan:@""];
    for (int i=0; i<_menuarr.count; i++) {
        [self.btns[i] setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
    }
    numsender = (int)sender.tag-100;
    if (numsender>1) {
        if (numsender == 2) {
            if (numsender > tempNumber) {
                
                [UIView animateWithDuration:0.2 animations:^{
                    _headScrollow.contentOffset = CGPointMake(65*horizontalrate*1+(0+1)*(MainScreenWidth- (65*horizontalrate * 4))/(4 + 1), 0);
                    [sender setTitleColor:[UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1] forState:UIControlStateNormal];
                }];
                
            }else if (numsender < tempNumber){
                [UIView animateWithDuration:0.2 animations:^{
                    _headScrollow.contentOffset = CGPointMake(0, 0);
                    [sender setTitleColor:[UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1] forState:UIControlStateNormal];
                }];
            }
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            [sender setTitleColor:[UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1] forState:UIControlStateNormal];
            //_headScrollow.contentOffset = CGPointMake(65*horizontalrate*1+(0+1)*(MainScreenWidth- (65*horizontalrate * 4))/(4 + 1), 0);
        }];

    }else{
        
    [UIView animateWithDuration:0.2 animations:^{
        [sender setTitleColor:[UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1] forState:UIControlStateNormal];
        _headScrollow.contentOffset = CGPointMake(0, 0);
        
    }];
}
    tempNumber = numsender;
}


#pragma mark --- 网络请求

- (void)netWorkGetArrange {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    [dic setObject:@"1" forKey:@"page"];
    [dic setObject:@"20" forKey:@"count"];
    [dic setObject:[NSString stringWithFormat:@"%@",_schoolID] forKey:@"school_id"];
    [dic setObject:@"1479198346" forKey:@"timespan"];
    
    [manager BigWinCar_getArrange:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"----%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 1) {
            _dataArray = responseObject[@"data"];
            return;
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    

}


@end
