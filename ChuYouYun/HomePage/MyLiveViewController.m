//
//  MyLiveViewController.m
//  ChuYouYun
//
//  Created by IOS on 16/11/14.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "MyLiveViewController.h"
#import "MyHttpRequest.h"
#import "teacherList.h"
#import "classTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "MJRefreshBaseView.h"
#import "LiveDetailsViewController.h"
#import "classViewController.h"
#import "SYGClassTool.h"
#import "SYGClassTableViewCell.h"
#import "UIButton+WebCache.h"
#import "GLReachabilityView.h"
#import "UIColor+HTMLColors.h"
#import "classClassifyVc.h"
#import "blumViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "MBProgressHUD+Add.h"
#import "GLLiveTableViewCell.h"
#import "ZhiBoMainViewController.h"

#import "ClassRevampCell.h"

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define iOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

@interface MyLiveViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSMutableArray * dataArray2;
    classViewController * cvc;
    UIView *_view;
    UILabel *_lable;
    
}

@property(nonatomic,assign)NSInteger numder;

@end

@implementation MyLiveViewController

- (id)initWithId:(NSString *)Id
{
    if (self=[super init]) {
        _cateory_id = Id;
    }
    return self;
}

-(void)reachGO{
    
    if([GLReachabilityView isConnectionAvailable]==1){
        
        _view.frame = CGRectMake(0, 0, 0, 0);
        
        _view.hidden = YES;
        
    }else{
        
        _view.frame = CGRectMake(0, 64, MainScreenWidth, 30);
        
        _view.hidden = NO;
        
    }
    
    [self.view bringSubviewToFront:_view];
//    _tableView.frame = CGRectMake(0,64, MainScreenWidth, MainScreenHeight - 64);
    [_tableView reloadData];
    
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
    
    //创建view
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    navView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:navView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"我的直播";
    [navView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    //添加分类按钮
    UIButton *FLButton = [UIButton buttonWithType:UIButtonTypeSystem];
    FLButton.frame = CGRectMake(MainScreenWidth-35, 30, 20, 20);
//    [FLButton setBackgroundImage:[UIImage imageNamed:@"fenleisyg"] forState:UIControlStateNormal];
//    [FLButton addTarget:self action:@selector(gokind) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:FLButton];

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 100, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,86)];
    [backButton setTitle:@" " forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    //设置button上字体的偏移量
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10.0 , 0.0, 0)];
    [navView addSubview:backButton];
    
    _view = (UIView *)[GLReachabilityView popview];
   // [self.view addSubview:_view];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, MainScreenWidth, MainScreenHeight - 64 + 20 + 18 ) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 110;
    _tableView.showsVerticalScrollIndicator = NO;
    _lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 100,MainScreenWidth, 15)];
    [_tableView addSubview:_lable];
    [_tableView insertSubview:_lable atIndex:0];
    _lable.font = [UIFont systemFontOfSize:14];
    _lable.text = @"数据为空，刷新重试";
    _lable.textAlignment = NSTextAlignmentCenter;
    _lable.textColor = [UIColor clearColor];
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    dataArray2 = [[NSMutableArray alloc]init];
    
    //下拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [_tableView headerBeginRefreshing];
    
    
    //设置表格分割线的长度（跟两边的距离）
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,2,0,0)];
    }
}
-(void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)gokind{
    
    NSArray *arr = @[@"ios",@"java",@"phh"];
    classClassifyVc * vc = [[classClassifyVc alloc]initwithTitle:@"直播" array:arr id:@"2"];
    rootViewController * ntvc;
    
    [ntvc isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)refreshHeader
{
    [_tableView headerBeginRefreshing];
}


- (void)headerRerefreshing
{
    [self reachGO];
    _numder = 1;
    [self requestData:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        if (_dataArray.count==0) {
            _lable.textColor = [UIColor colorWithHexString:@"#dedede"];
            
        }else{
            _lable.textColor = [UIColor clearColor];
        }
    });
}

- (void)footerRefreshing
{
    //先隐藏
    _numder++;
    [self requestData:_numder];
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
    [dic setValue:@"20" forKey:@"count"];
   // [dic setValue:_num forKey:@"pType"];
    [dic setValue:@"" forKey:@"cate_id"];
    [dic setValue:@"" forKey:@"keyword"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    //从本地取数据出来
    NSArray *classArray = [SYGClassTool classWithDic:dic];
    NSLog(@"--------1------------%@",classArray);

    [manager getpublicPort:dic mod:@"Live" act:@"getMyLiveList" success:^(AFHTTPRequestOperation *operation, id responseObject) {

        //存入到本地
        
        NSLog(@"%@",responseObject);
        NSLog(@"%@",operation);
        
        if (classArray.count) {
            NSLog(@"不缓存");
        } else {
            [SYGClassTool saveClasses:responseObject[@"data"]];
        }
        
        NSMutableArray * array = [responseObject objectForKey:@"data"];
        if(IsNilOrNull(array))
        {
            UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, MainScreenWidth, 50)];
            hintLabel.textAlignment = NSTextAlignmentCenter;
            hintLabel.text = @"没有课程";
            hintLabel.font = [UIFont systemFontOfSize:24];
            hintLabel.textColor = [UIColor purpleColor];
            [self.view addSubview:hintLabel];
            
        }
        else{
            NSArray *listArr = responseObject[@"data"];
            if(num==1)
            {
                _dataArray = [NSMutableArray arrayWithArray:listArr];
            } else {
                
                NSArray * arr = [NSArray arrayWithArray:listArr];
                if (arr.count) {
                    [_dataArray addObjectsFromArray:arr];

                }else{
                
                    [MBProgressHUD showError:@"没有更多数据" toView:self.view];

                }
            }
            
            [_tableView reloadData];
        }
        
        
        if (_dataArray.count != 0) {//当数据不为空的时候才能上拉加载
            //上拉加载
            [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
            if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
                [_tableView setSeparatorInset:UIEdgeInsetsMake(0,5,0,0)];
            }
        }
        
        
        if (_dataArray.count == 0) {
            //添加空白处理
            if (num == 1) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
                imageView.image = [UIImage imageNamed:@"直播（空白）"];
                [self.view addSubview:imageView];
            }
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"加载失败");
        [_dataArray addObjectsFromArray:classArray];
        [_tableView reloadData];
        
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellID = @"GLLiveTableViewCell";
    //自定义cell类
    ClassRevampCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //自定义cell类
    if (cell == nil) {
        cell = [[ClassRevampCell alloc] initWithReuseIdentifier:CellID];
    }
    
    NSLog(@"----%@",_dataArray[0]);
    
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataWithDict:dict withType:@"2"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *Cid = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"live_id"];
    NSString *Title = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"video_title"];
    NSString *ImageUrl = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"cover"];
    NSString *price = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"t_price"];
    
    self.navigationController.navigationBar.hidden = NO;

    ZhiBoMainViewController *zhiBoMainVc = [[ZhiBoMainViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)indexPath.row andprice:price];
    [self.navigationController pushViewController:zhiBoMainVc animated:YES];
}
//去掉HTML字符
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    }
    return html;
}
@end
