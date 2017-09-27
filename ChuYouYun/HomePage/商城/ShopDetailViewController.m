//
//  ShopDetailViewController.m
//  dafengche
//
//  Created by IOS on 16/10/12.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//
#define rate MainScreenWidth/375
#define verticalrate  MainScreenHeight/667

#import "ShopDetailViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "UIView+Utils.h"
#import "MyHttpRequest.h"
#import "UIImageView+WebCache.h"
#import "ManageAddressViewController.h"
#import "DLViewController.h"
#import "MBProgressHUD+Add.h"


@interface ShopDetailViewController (){
    
    //标题
    UILabel *_titleLab;

    //兑换的个数
    UILabel *_Num;
    int _numValue;
    UIButton *_sureBtn;
    NSString *_IDStr;
    
    NSString *_num;
    UILabel *_moeyLab;
    UILabel *_numlab;
    //中间
    UILabel *_numlable;
    //快递运费
    UILabel *_peisong1;
    //地址
    UILabel *_jianjie1;
    //ID
    NSString * _goods_id;
    UIImageView *imgV;
    
    NSString *_adress;
    NSDictionary *_dic;
    NSString *_adress_id;

    
}

@property (strong ,nonatomic)UIScrollView *mainScrollView;
@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)NSMutableArray *GLdataArray;

@property (strong ,nonatomic)NSDictionary   *addressDict;


@end

@implementation ShopDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];

    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    if (_peisong1) {
        if (_addressDict == nil) {
            [self setDefaultRequest];
        } else {
        }
    }
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

-(instancetype)initWithID:(NSString *)IDStr{

    self = [super init];
    
    if (self) {
        
        _IDStr = IDStr;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefaultRequest];

    [self addScrollow];
    [self addNav];
    [self addDetail];
    [self reqData];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAddress:) name:@"NSNotificationGetAddress" object:nil];
}
//获取默认地址
-(void)setDefaultRequest{
    
    
    QKHTTPManager * manager = [QKHTTPManager manager];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    
    //判断是否登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
//        [MBProgressHUD showError:@"请先登录" toView:self.view];
    } else {
        [dict setObject:UserOathToken forKey:@"oauth_token"];
        [dict setObject:UserOathTokenSecret forKey:@"oauth_token_secret"];
    }
    [dict setObject:@"1" forKey:@"is_default"];
    
    [manager getpublicPort:dict mod:@"Address" act:@"getAddressList" success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"===__===%@",responseObject);

        NSString *msg = responseObject[@"msg"];
    
        if ([msg isEqualToString:@"ok"]) {
            
            NSString *str1 = [[[responseObject arrayValueForKey:@"data"] objectAtIndex:0] stringValueForKey:@"province"];
            NSString *str2 = [[[responseObject arrayValueForKey:@"data"] objectAtIndex:0] stringValueForKey:@"city"];
            NSString *str3 = [[[responseObject arrayValueForKey:@"data"] objectAtIndex:0] stringValueForKey:@"area"];
            
            _adress = [NSString stringWithFormat:@"%@ %@ %@",str1,str2,str3];
            _adress_id = [[[responseObject arrayValueForKey:@"data"] objectAtIndex:0] stringValueForKey:@"address_id"];
            //运费
            NSString *yf = [NSString stringWithFormat:@"%@",_adress];
            _peisong1.text = yf;
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

-(void)reqData
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *key = [ user objectForKey:@"oauthToken"];
    NSString *passWord = [ user objectForKey:@"oauthTokenSecret"];
    NSLog(@"%@==%@==%@==%d",key,passWord,_IDStr,_numValue);

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (UserOathTokenSecret == nil) {
    } else {
        [dict setObject:UserOathToken forKey:@"oauth_token"];
        [dict setObject:UserOathTokenSecret forKey:@"oauth_token_secret"];
    }


    [dict setObject:_IDStr forKey:@"goods_id"];
    
    NSLog(@"%@",dict);
    [manager getpublicPort:dict mod:@"Goods" act:@"getDetail" success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"===__===%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            _dic = [NSDictionary dictionaryWithDictionary:responseObject];
        }
        
        if (![responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        
        _titleLab.text = [[responseObject dictionaryValueForKey:@"data"] stringValueForKey:@"title"];
        NSString *str1 = [[responseObject dictionaryValueForKey:@"data"] stringValueForKey:@"price"];
        NSString *str2 = [[responseObject dictionaryValueForKey:@"data"] stringValueForKey:@"fare"];
        _moeyLab.text = [NSString stringWithFormat:@"所需积分  %@    运费%@ ",str1,str2];
        
        _goods_id = [[responseObject dictionaryValueForKey:@"data"] stringValueForKey:@"goods_id"];

        //兑换人数
        _numlab.text = [[responseObject dictionaryValueForKey:@"data"] stringValueForKey:@"num"];
        //仓库剩余
        _numlable.text = [[responseObject dictionaryValueForKey:@"data"] stringValueForKey:@"stock"];
        //运费
        NSString *yf = @"";
        if (_adress != nil) {
            yf = [NSString stringWithFormat:@"%@",_adress];
        }
        _peisong1.text = yf;
        _jianjie1.text = [[responseObject dictionaryValueForKey:@"data"] stringValueForKey:@"info"];
        NSString *urlStr = [[responseObject dictionaryValueForKey:@"data"] stringValueForKey:@"cover"];
        [imgV sd_setImageWithURL:[NSURL URLWithString:urlStr]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [MBProgressHUD showError:@"获取数据失败" toView:self.view];
    }];
}

-(void)addScrollow{
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,-20, MainScreenWidth, MainScreenHeight+20)];
    _mainScrollView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _mainScrollView.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight);
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mainScrollView];
//    _mainScrollView.scrollEnabled = YES;
}

-(void)requestData
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    //判断是否登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *key = [ user objectForKey:@"oauthToken"];
    NSString *passWord = [ user objectForKey:@"oauthTokenSecret"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:_goods_id forKey:@"goods_id"];
    [dic setObject:[NSString stringWithFormat:@"%d",_numValue] forKey:@"num"];
    
    if (_adress_id == nil) {
        
    } else {
        [dic setObject:_adress_id forKey:@"address_id"];
    }
    
    [manager getpublicPort:dic mod:@"Goods" act:@"exchange" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = responseObject[@"msg"];
        NSLog(@"%@",operation);

        if ([responseObject[@"code"] integerValue] == 1) {
            [MBProgressHUD showError:@"兑换成功" toView:self.view];
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"兑换失败" toView:self.view];
    }];
}
- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64*rate)];
    SYGView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 24,24)];
    [backButton setImage:[UIImage imageNamed:@"icon_back_to_home"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
//    backButton.backgroundColor = [UIColor cyanColor];
}
-(void)addDetail{
    
    imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenWidth*500/640)];
    [_mainScrollView addSubview:imgV];
    imgV.image = [UIImage imageNamed:@"站位图"];
    //title
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, imgV.current_y_h+10, MainScreenWidth-30, 20*verticalrate)];
    _titleLab.text = @"小天才手表";
    [_mainScrollView addSubview:_titleLab];
    _titleLab.font = [UIFont systemFontOfSize:13*verticalrate];
    //detail
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(10, _titleLab.current_y_h+10, MainScreenWidth-20, 50*verticalrate)];
    [_mainScrollView addSubview:backview];
    backview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _moeyLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150*rate ,50*verticalrate)];
    _moeyLab.text = @"所需积分  2300";
    _moeyLab.font = [UIFont systemFontOfSize:12*rate];
    _moeyLab.textColor = [UIColor redColor];
    [backview addSubview:_moeyLab];
    
    _numlab = [[UILabel alloc]initWithFrame:CGRectMake(backview.frame.size.width-60*rate, 3, 60*rate, 20*verticalrate)];
    [backview addSubview:_numlab];
    _numlab.text = @"90";
    _numlab.textColor = [UIColor colorWithHexString:@"#333333"];
    _numlab.textAlignment = NSTextAlignmentCenter;
    _numlab.font = [UIFont systemFontOfSize:10*rate];
    UILabel *numlab1 = [[UILabel alloc]initWithFrame:CGRectMake(_numlab.frame.origin.x, _numlab.current_y_h, 60*rate, 25*verticalrate)];
    [backview addSubview:numlab1];
    numlab1.text = @"兑换人数";
    numlab1.textColor = [UIColor colorWithHexString:@"#333333"];
    numlab1.textAlignment = NSTextAlignmentCenter;
    numlab1.font = [UIFont systemFontOfSize:11*rate];
    
    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(backview.frame.size.width-61*rate, 3*verticalrate, 1, 44*verticalrate)];
    [backview addSubview:lineLab];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    
    //中间
    _numlable = [[UILabel alloc]initWithFrame:CGRectMake(backview.frame.size.width-121*rate, 3*verticalrate, 60*rate, 20*verticalrate)];
    [backview addSubview:_numlable];
    _numlable.text = @"80";
    _numlable.textColor = [UIColor colorWithHexString:@"#333333"];
    _numlable.textAlignment = NSTextAlignmentCenter;
    _numlable.font = [UIFont systemFontOfSize:11*rate];
    
    UILabel *numlable1 = [[UILabel alloc]initWithFrame:CGRectMake(_numlable.frame.origin.x, _numlable.current_y_h, 60*rate, 25*verticalrate)];
    [backview addSubview:numlable1];
    numlable1.text = @"仓库剩余";
    numlable1.textColor = [UIColor colorWithHexString:@"#333333"];
    numlable1.textAlignment = NSTextAlignmentCenter;
    numlable1.font = [UIFont systemFontOfSize:11*rate];
    
    //添加快递详情
    //配送
    UILabel *peisong = [[UILabel alloc]initWithFrame:CGRectMake(13, backview.current_y_h+10*verticalrate,50*rate, 20*verticalrate)];
    [_mainScrollView addSubview:peisong];
    peisong.text = @"配送";
    peisong.textAlignment = NSTextAlignmentLeft;
    peisong.textColor = [UIColor grayColor];
    peisong.font = [UIFont systemFontOfSize:15*rate];

    _peisong1 = [[UILabel alloc]initWithFrame:CGRectMake(peisong.current_x_w , backview.current_y_h+10*verticalrate,(MainScreenWidth -peisong.current_x_w-10)*rate, 20*verticalrate)];
    [_mainScrollView addSubview:_peisong1];
    _peisong1.text = @"";
    _peisong1.font = [UIFont systemFontOfSize:14*rate];
    _peisong1.textAlignment = NSTextAlignmentLeft;
    _peisong1.textColor = [UIColor colorWithHexString:@"#333333"];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(peisong.current_x_w , backview.current_y_h+10*verticalrate,(MainScreenWidth -peisong.current_x_w-10)*rate, 20*verticalrate)];
    [_mainScrollView addSubview:btn];
    [btn addTarget:self action:@selector(adress) forControlEvents:UIControlEventTouchUpInside];

    //简介
    UILabel *jianjie = [[UILabel alloc]initWithFrame:CGRectMake(13, peisong.current_y_h+15*verticalrate + 30,50*rate, 20*verticalrate)];
    [_mainScrollView addSubview:jianjie];
    jianjie.text = @"简介";
    jianjie.font = [UIFont systemFontOfSize:15*rate];

    jianjie.textAlignment = NSTextAlignmentLeft;
    jianjie.textColor = [UIColor grayColor];
    
    
    _jianjie1 = [[UILabel alloc]initWithFrame:CGRectMake(jianjie.current_x_w , jianjie.current_y - 30,(MainScreenWidth -jianjie.current_x_w-10)*rate , 20*verticalrate + 60)];
    [_mainScrollView addSubview:_peisong1];
    _jianjie1.text = @" ";
    _jianjie1.font = [UIFont systemFontOfSize:14*rate];
    _jianjie1.textAlignment = NSTextAlignmentLeft;
    _jianjie1.textColor = [UIColor colorWithHexString:@"#333333"];
    [_mainScrollView addSubview:_jianjie1];
    _jianjie1.numberOfLines = 0;

    //数量
    UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(13, jianjie.current_y_h+15*verticalrate + 30,50*rate, 20*verticalrate)];
    [_mainScrollView addSubview:number];
    number.text = @"数量";
    number.textAlignment = NSTextAlignmentLeft;
    number.textColor = [UIColor grayColor];
    number.font = [UIFont systemFontOfSize:15*rate];
    
    //加，减
    UIButton *cutBtn = [[UIButton alloc]initWithFrame:CGRectMake(number.current_x_w, number.current_y, 15*rate, 20*verticalrate)];
    cutBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_mainScrollView addSubview:cutBtn];
    [cutBtn setTitle:@"-" forState:UIControlStateNormal];
    [cutBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    
    _Num = [[UILabel alloc]initWithFrame:CGRectMake(cutBtn.current_x_w,cutBtn.current_y,50*rate, 20*verticalrate)];
    [_mainScrollView addSubview:_Num];
    [cutBtn.titleLabel setFont:[UIFont systemFontOfSize:14*verticalrate]];

    cutBtn.tag = 1;
    [cutBtn addTarget:self action:@selector(changeNum:) forControlEvents:UIControlEventTouchUpInside];
    _numValue = 1;
    _Num.text = [NSString stringWithFormat:@"%d",_numValue];;
    _Num.textColor = [UIColor colorWithHexString:@"#333333"];
    _Num.font = [UIFont systemFontOfSize:14*verticalrate];
    _Num.textAlignment = NSTextAlignmentCenter;
    
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(_Num.current_x_w, _Num.current_y, 15*rate, 20*verticalrate)];
    addBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_mainScrollView addSubview:addBtn];
    addBtn.tag = 2;
    [addBtn addTarget:self action:@selector(changeNum:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    UILabel *lastLab = [[UILabel alloc]initWithFrame:CGRectMake(addBtn.current_x_w+2,addBtn.current_y,50*rate, 20*verticalrate)];
    [_mainScrollView addSubview:lastLab];
    [addBtn.titleLabel setFont:[UIFont systemFontOfSize:14*verticalrate]];

    lastLab.text = @"  件";
    lastLab.textColor = [UIColor colorWithHexString:@"#333333"];
    lastLab.font = [UIFont systemFontOfSize:15*verticalrate];
    lastLab.textAlignment = NSTextAlignmentLeft;
    //北京lab
    UILabel *backlab = [[UILabel alloc]initWithFrame:CGRectMake(0, lastLab.current_y_h +20*verticalrate, MainScreenWidth, 15*verticalrate)];
    [_mainScrollView addSubview:backlab];
    backlab.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
//    //详情lab
//    UILabel *detailLab = [[UILabel alloc]initWithFrame:CGRectMake(13, backlab.current_y_h +10*verticalrate, MainScreenWidth, 20*verticalrate)];
//    detailLab.text = @"详情";
//    detailLab.font = [UIFont systemFontOfSize:17*verticalrate];
//    detailLab.textColor = [UIColor colorWithHexString:@"#333333"];
//    [_mainScrollView addSubview:detailLab];
//    //蓝色lab背景
//    UILabel *backlab1 = [[UILabel alloc]initWithFrame:CGRectMake(13, detailLab.current_y_h +2*verticalrate, MainScreenWidth-26, 3*verticalrate)];
//    [_mainScrollView addSubview:backlab1];
//    backlab1.backgroundColor = [UIColor blueColor];
//    //详情图片
//    UIImageView *detailImgV = [[UIImageView alloc]initWithFrame:CGRectMake(13, backlab1.current_y_h +10*verticalrate, MainScreenWidth - 26,(MainScreenWidth - 26)*710/600)];
//    [_mainScrollView addSubview:detailImgV];
//    detailImgV.image = [UIImage imageNamed:@"大家好"];
//    _mainScrollView.contentSize = CGSizeMake(MainScreenWidth, detailImgV.current_y_h+20);

    //确定按钮
    _sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, MainScreenHeight - 40*verticalrate, MainScreenWidth, 40*verticalrate)];
    [_sureBtn setTitle:@"兑换" forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [_sureBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _sureBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:_sureBtn];
    [_sureBtn.titleLabel setFont:[UIFont systemFontOfSize:15*verticalrate]];
}

-(void)adress{

    [self.navigationController pushViewController:[ManageAddressViewController new] animated:YES];
}
//确定
-(void)sure{

    [self requestData];
    NSLog(@"sure");
}

-(void)changeNum:(UIButton *)sender{

    
    if (sender.tag==1) {
        if (_numValue==0) {
            return;
        }
        _numValue--;
        _Num.text = [NSString stringWithFormat:@"%d",_numValue];

    }else{
        _numValue++;
        _Num.text = [NSString stringWithFormat:@"%d",_numValue];

    }
    if (_numValue==0) {
        _sureBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
    }else
        _sureBtn.backgroundColor = [UIColor redColor];
}
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark ---- 通知

- (void)getAddress:(NSNotification *)not {
    
    NSLog(@"%@",not.object);
    NSDictionary *dict = not.object;
    NSLog(@"%@",_peisong1.text);
    _peisong1.text = [NSString stringWithFormat:@"%@%@ %@",dict[@"province"],dict[@"city"],dict[@"address"]];
    _adress_id = dict[@"address_id"];
    _addressDict = dict;
    
    NSLog(@"%@",_peisong1.text);
}


@end
