//
//  StoreMoreViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/6/6.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "StoreMoreViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"
#import "MJRefresh.h"

#import "ShopDetailViewController.h"


@interface StoreMoreViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_ISONArr;
    NSMutableArray *_muArray;
}

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)UILabel *WZlabel;

@end

@implementation StoreMoreViewController

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
    [self addTableView];
    [self requestData];
    
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _ISONArr = @[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"];
    _muArray = [NSMutableArray arrayWithArray:_ISONArr];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textField:) name:UITextFieldTextDidChangeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textView:) name:UITextViewTextDidChangeNotification object:nil];
    
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
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = _moreDic[@"cate_name"];
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    _WZlabel = WZLabel;
    [SYGView addSubview:WZLabel];
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
}

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float width = MainScreenWidth/3 - 40/3 + 120;
    NSInteger num = [_moreDic[@"data_list"] count];
//    if ([_muArray[indexPath.section] isEqualToString: @"0"]) {
//        if (num>6) {
//            num =6;
//        }
//    }
    num = num -1;
    num = num/3+1;
    NSLog(@"%ld",num);
    return width *num ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 5;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    
    NSInteger num = [_moreDic[@"data_list"] count];
//    if ([_muArray[indexPath.section] isEqualToString: @"0"]) {
//        if (num>6) {
//            num = 6;
//        }else{
//            [_muArray replaceObjectAtIndex:indexPath.section withObject:@"2"];
//        }
//    }
    
    NSLog(@"%@",_moreDic[@"data_list"]);
    for (int i = 0; i<num; i++) {
        float width = MainScreenWidth/3 - 40/3;
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10 +width*(i%3) +(i%3)*10,10+(120+width)*(i/3), width,width)];
        [img sd_setImageWithURL:[NSURL URLWithString:_moreDic[@"data_list"][i][@"cover"]]];
        [cell.contentView addSubview:img];
        
        UILabel *titlelab = [[UILabel alloc]initWithFrame:CGRectMake( 10 +width*(i%3) +(i%3)*10, img.current_y_h + 10, width - 30, 20)];
        titlelab.textColor = [UIColor blackColor];
        [cell.contentView addSubview:titlelab];
        titlelab.font = Font(15);
        titlelab.text = [NSString stringWithFormat:@"%@",_moreDic[@"data_list"][i][@"title"]];
        
        UILabel *lastlab = [[UILabel alloc]initWithFrame:CGRectMake(10 +width*(i%3) +(i%3)*10,titlelab.current_y_h +5, width - 20,35)];
        lastlab.textColor = [UIColor grayColor];
        [cell.contentView addSubview:lastlab];
        lastlab.font = Font(14);
        lastlab.numberOfLines = 2;
        lastlab.text = [NSString stringWithFormat:@"%@",_moreDic[@"data_list"][i][@"info"]];
        
        UILabel *pricelab = [[UILabel alloc]initWithFrame:CGRectMake(10 +width*(i%3) +(i%3)*10, lastlab.current_y_h + 10, width, 20)];
        pricelab.textColor = [UIColor grayColor];
        [cell.contentView addSubview:pricelab];
        pricelab.font = Font(13);
        pricelab.text = [NSString stringWithFormat:@"%@积分,剩余%@名额",_moreDic[@"data_list"][i][@"price"],_moreDic[@"data_list"][i][@"fare"]];
        
        UIButton *bttn  = [[UIButton alloc]initWithFrame:CGRectMake(10 +width*(i%3) +(i%3)*10,10+(120+width)*(i/3), width,width)];
        [cell.contentView addSubview:bttn];
        [bttn addTarget:self action:@selector(sendBtn:) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"%@",_moreDic[@"data_list"][i][@"goods_id"]);
        
        NSInteger num = [[NSString stringWithFormat:@"%@",_moreDic[@"data_list"][i][@"goods_id"]] integerValue];
        bttn.tag = 10000 + num;
        NSLog(@"%ld",num);
    }
    return cell;
}




#pragma mark --- 事件点击

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sendBtn:(UIButton *)sender{
    
    NSString *ID = [NSString stringWithFormat:@"%ld",sender.tag - 10000];
    ShopDetailViewController *shopDetail = [[ShopDetailViewController alloc]initWithID:ID];
    [self.navigationController pushViewController:shopDetail animated:YES];
}


-(void)requestData {
    
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    
    if (_mallID == nil) {
        
    } else {
        [dic setValue:_mallID forKey:@"cate_id"];
        [dic setValue:@"list" forKey:@"type"];
    }
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"50" forKey:@"count"];
    [dic setValue:@"1" forKey:@"floor_count"];
    if (_mallID != nil) {
        [dic setValue:@"1" forKey:@"floor_count"];
    }
    
    if (UserOathToken == nil) {
        
    } else {
        [dic setValue:UserOathToken forKey:@"oauth_token"];
        [dic setValue:UserOathTokenSecret forKey:@"oauth_token_secret"];
    }
    
    NSLog(@"%@",dic);
    [MBProgressHUD showError:@"数据加载中...." toView:self.view];
    
    [manager getpublicPort:dic mod:@"Goods" act:@"index" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"===__===%@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            [MBProgressHUD showError:@"加载完成...." toView:self.view];
            _moreDic = responseObject[@"data"][@"list"][0];
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }

        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"获取数据失败" toView:self.view];
    }];
}





@end
