//
//  AmendBankViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 15/10/19.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define Coler [UIColor colorWithRed:136.f / 255 green:136.f / 255 blue:136.f / 255 alpha:1]
#define NUMBERS @"0123456789"

#import "AmendBankViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "BankTool.h"
#import "AreaTool.h"
#import "UIColor+HTMLColors.h"


@interface AmendBankViewController (){
    UIButton *provinceButton;
    UIButton *CSButton;
    
}
@property (strong ,nonatomic)UITextField *bankNumberField;
@property (strong ,nonatomic)UITextField *telNumberField;
@property (strong ,nonatomic)UILabel     *bankNameLabel;
@property (strong ,nonatomic)UITextField *addressField;
@property (strong ,nonatomic)UITextField *userNameField;
@property (strong ,nonatomic)UILabel     *provinceLabel;
@property (strong ,nonatomic)UILabel     *cityLabel;
@property (strong ,nonatomic)UILabel     *AreaLabel;

@property (strong ,nonatomic)UIButton    *allButton;

@property (strong ,nonatomic)NSDictionary *allDic;


@end

@implementation AmendBankViewController


-(NSArray *)bankArr{
    
    if (!_bankArr) {
        
        _bankArr = @[@"中国银行",@"中国工商银行",@"中国农业银行",@"中国建设银行",@"交通银行",@"招商银行",@"民生银行",@"中信银行",@"北京银行",@"广东发展银行",@"上海浦东银行",@"上海浦发银行",@"中国邮政储蓄银行"];
    }
    return _bankArr;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"修改银行卡";
    [self addNav];
    [self initer];
    //获取数据，已做缓存
    [self getDatafromkBacDevice];
    _bankCardDetailArr = [[NSMutableArray alloc]init];
    [_bankCardDetailArr removeAllObjects];
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 60)];
     SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 12, 22)];
    [backButton setImage:[UIImage imageNamed:@"iconfont-FH"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"修改银行卡";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

-  (void)initer {
    UILabel *bankNumber = [[UILabel alloc] initWithFrame:CGRectMake(20, 220, MainScreenWidth / 4, 40)];
    bankNumber.text = @"银行卡号:";
    [self.view addSubview:bankNumber];
    
    _bankNumberField = [[UITextField alloc] initWithFrame:CGRectMake(20 + MainScreenWidth / 4 , 220, MainScreenWidth / 4 * 3, 40)];
    if (self.addOrAmend) {
        _bankNumberField.text = _dic[@"account"];
    } else {
        _bankNumberField.placeholder = @"请输入银行卡号";
    }
    
    _bankNumberField.textColor = Coler;
    [self.view addSubview:_bankNumberField];
    
    //添加分割线
    UILabel *ALabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 99.5, MainScreenWidth, 1)];
    ALabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:ALabel];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 260, MainScreenWidth/ 4, 40)];
    nameLabel.text = @"姓名:";
    [self.view addSubview:nameLabel];
    
    _userNameField = [[UITextField alloc] initWithFrame:CGRectMake(20 + MainScreenWidth / 4, 260, MainScreenWidth / 4 * 3, 40)];
    if (self.addOrAmend) {
        _userNameField.text = _dic[@"accountmaster"];
    } else {
        _userNameField.placeholder = @"请输入名字";
    }
    _userNameField.textColor = Coler;
    [self.view addSubview:_userNameField];
    
    //添加分割线
    UILabel *BLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 139.5, MainScreenWidth, 1)];
    BLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:BLabel];
    
    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 300, MainScreenWidth / 4, 40)];
    numberLabel.text = @"联系电话:";
    [self.view addSubview:numberLabel];
    
    _telNumberField = [[UITextField alloc] initWithFrame:CGRectMake(20 + MainScreenWidth / 4, 300, MainScreenWidth / 4 * 3, 40)];
    if (self.addOrAmend) {
        _telNumberField.text = _dic[@"tel_num"];
    } else {
        _telNumberField.placeholder = @"请输入电话号码";
    }
    _telNumberField.textColor = Coler;
    [self.view addSubview:_telNumberField];
    
    //添加分割线
    UILabel *CLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 179.5, MainScreenWidth, 1)];
    CLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:CLabel];
    
    UILabel *bankNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, MainScreenWidth / 4, 40)];
    bankNameLabel.text = @"银行名字:";
    [self.view addSubview:bankNameLabel];
    //添加分割线
    UILabel *DLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 219.5, MainScreenWidth, 1)];
    DLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:DLabel];
    
    _bankNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + MainScreenWidth / 4, 60, MainScreenWidth / 2, 40)];
    
    if (self.addOrAmend) {
        _bankNameLabel.text = _dic[@"accounttype"];
    } else {
        //        _telNumberField.placeholder = @"";
    }
    
    _bankNameLabel.textColor = Coler;
    [self.view addSubview:_bankNameLabel];
    
    UIButton *bankButton = [[UIButton alloc] initWithFrame:CGRectMake(20 + MainScreenWidth / 4 * 3, 70, 20, 20)];
    [bankButton setBackgroundImage:[UIImage imageNamed:@"向下@2x"] forState:UIControlStateNormal];
    [self.view addSubview:bankButton];
    
    //添加大的按钮
    UIButton *bankB = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2, 60, MainScreenWidth / 2 , 40)];
    bankB.backgroundColor = [UIColor clearColor];
    [bankB addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    bankB.tag = 5;
    [self.view addSubview:bankB];
    
    UILabel *bankAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, MainScreenWidth / 4, 40)];
    bankAddressLabel.text = @"开户地址:";
    [self.view addSubview:bankAddressLabel];
    
    _addressField = [[UITextField alloc] initWithFrame:CGRectMake(20 + MainScreenWidth / 4, 180, MainScreenWidth / 4 *3, 40)];
    if (self.addOrAmend) {
        _addressField.text = _dic[@"location"];
    } else {
        _addressField.placeholder = @"请输入具体地址";
    }
    
    _addressField.textColor = Coler;
    [self.view addSubview:_addressField];
    
    //添加分割线
    UILabel *ELabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 259.5, MainScreenWidth, 1)];
    ELabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:ELabel];
    
    UILabel *pLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, MainScreenWidth / 8, 40)];
    pLabel.text = @"省";
    [self.view addSubview:pLabel];
    
    _provinceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + MainScreenWidth / 8, 100, MainScreenWidth / 4, 40)];
    [self.view addSubview:_provinceLabel];
    
    UIButton *pButton = [[UIButton alloc] initWithFrame:CGRectMake(20 + MainScreenWidth / 8 * 3, 110, 20, 20)];
    [pButton setBackgroundImage:[UIImage imageNamed:@"向下@2x"] forState:UIControlStateNormal];
    //    pButton.tag = 1;
    //    [pButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pButton];
    
    UIButton *SButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, MainScreenWidth / 2 - 100 + 20, 40)];
    SButton.backgroundColor = [UIColor clearColor];
    SButton.tag = 1;
    [SButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SButton];
    
    UILabel *cLabel = [[UILabel alloc] initWithFrame:CGRectMake( 20 + MainScreenWidth / 2, 100, MainScreenWidth / 8, 40)];
    cLabel.text = @"市";
    [self.view addSubview:cLabel];
    
    _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + MainScreenWidth / 8 * 5, 100, MainScreenWidth / 4, 40)];
    [self.view addSubview:_cityLabel];
    
    //市btn
    UIButton *cButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth-35, 110, 20, 20)];
    
    [cButton setBackgroundImage:[UIImage imageNamed:@"向下@2x"] forState:UIControlStateNormal];
    
    [self.view addSubview:cButton];
    
    CSButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 + 100, 100, MainScreenWidth / 2 - 100, 40)];
    CSButton.backgroundColor = [UIColor clearColor];
    CSButton.tag = 2;
    [CSButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:CSButton];
    
    
    
    //添加分割线
    UILabel *FLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 299.5, MainScreenWidth, 1)];
    FLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:FLabel];
    
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, MainScreenWidth / 8, 40)];
    aLabel.text = @"区";
    [self.view addSubview:aLabel];
    
    _AreaLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + MainScreenWidth / 8, 140, MainScreenWidth / 4, 40)];
    [self.view addSubview:_AreaLabel];
    
    UIButton *aButton = [[UIButton alloc] initWithFrame:CGRectMake(20 + MainScreenWidth / 8 * 3, 150, 20, 20)];
    [aButton setBackgroundImage:[UIImage imageNamed:@"向下@2x"] forState:UIControlStateNormal];
    //    aButton.tag = 3;
    //    [aButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aButton];
    
    //区btn
    UIButton *QButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 140, MainScreenWidth / 2, 40)];
    QButton.backgroundColor = [UIColor clearColor];
    QButton.tag = 3;
    [QButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:QButton];
    
    //添加分割线
    UILabel *GLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 339.5, MainScreenWidth, 1)];
    GLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:GLabel];
    
    UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 370, MainScreenWidth - 60, 40)];
    [sureButton setTitle:@"提交" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.tag = 4;
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.layer.cornerRadius = 5;
    sureButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [self.view addSubview:sureButton];
}
//获取网络数据
-(void)getDatafromkBacDevice{
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic =[[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    NSArray *YHArray = [BankTool bankWithDic:dic];
    if (_allDic) {//本地有数据
        _bankArray = YHArray;
    } else {
        [manager getBankCard:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            _allDic = responseObject;
            _bigArray = responseObject[@"data"][@"area"];
            _bankArray = responseObject[@"data"][@"bank"];
            //保存数据
            
            if (YHArray.count) {//有了 不需要缓存了
                
            } else {//没有 才需要缓存
                [AreaTool saveAreas:_bigArray];
                [BankTool saveBanks:_bankArray];
            }
            //保存数据
//        NSString *msg = [responseObject objectForKey:@"msg"];
//            if ([msg isEqual:@"ok"]) {
//                [self addBankView];
//            } else {
//                
//            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    
}

- (void)buttonPressed:(UIButton *)button {
    
    if (button.tag == 5) {
        //添加window
        //添加全屏view
        _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
        _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.5];
        [self.view addSubview:_allView];
        
        //添加中间的按钮
        _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
        [_allButton setBackgroundColor:[UIColor clearColor]];
        [_allButton addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
        [_allView addSubview:_allButton];
        
        //创建view
        CGFloat PWrith = MainScreenWidth / 3 * 2;
        _provinceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PWrith, MainScreenHeight - 150)];
        _provinceView.center = self.view.center;
        [_allView addSubview:_provinceView];
        
        //在View 上面添加滚动试图
        UIScrollView *provinceScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, PWrith, MainScreenHeight - 150)];
        provinceScrollView.backgroundColor = [UIColor whiteColor];
        //        provinceScrollView.center = self.view.center;
        provinceScrollView.contentSize = CGSizeMake(0, _provinceArray.count * 30 + 200);
        [_provinceView addSubview:provinceScrollView];
        
        //添加头上的图标
        UIView *TView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PWrith, 50)];
        TView.backgroundColor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
        [_provinceView addSubview:TView];
        
        //添加图片
        UIButton *JGButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [JGButton setBackgroundImage:[UIImage imageNamed:@"警告@2x"] forState:UIControlStateNormal];
        [TView addSubview:JGButton];
        
        //添加文本
        UILabel *JGLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, PWrith - 60, 50)];
        JGLabel.textColor = [UIColor whiteColor];
        JGLabel.font = [UIFont systemFontOfSize:22];
        JGLabel.text = @"请选择银行卡";
        [TView addSubview:JGLabel];
        
        for (int i = 0; i < self.bankArr.count; i++) {
            
            provinceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 30 * i + 5 * i, MainScreenWidth, 30)];
            [provinceButton setTitle:self.bankArr[i] forState:UIControlStateNormal];
            [provinceButton addTarget:self action:@selector(pressedBankButton:) forControlEvents:UIControlEventTouchUpInside];
            provinceButton.tag = i;
            provinceButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [provinceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            provinceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            provinceButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            [provinceScrollView addSubview:provinceButton];
            
            //添加分割线
            UILabel *HLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30 + 30 * i + 5 * i, PWrith, 1)];
            HLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [provinceScrollView addSubview:HLabel];
        }
    }
    
    NSArray *DQArray = [AreaTool areaWithDic:nil];
    if (DQArray.count) {
        _bigArray = DQArray;
    }
    if (button.tag == 1) {//省的分类
        //添加window
        //添加全屏view
        _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
        _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.5];
        [self.view addSubview:_allView];
        
        //添加中间的按钮
        _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
        [_allButton setBackgroundColor:[UIColor clearColor]];
        [_allButton addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
        
        [_allView addSubview:_allButton];
        
        //遍历数组
        _provinceArray = [NSMutableArray array];
        for (int i = 0; i < _bigArray.count; i++) {
            if ([_bigArray[i][@"pid"] isEqualToString:@"0"]) {//说明是省份
                NSString *province = _bigArray[i][@"title"];
                [_provinceArray addObject:province];
            }
        }
        //创建view
        CGFloat PWrith = MainScreenWidth / 3 * 2;
        _provinceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PWrith, MainScreenHeight - 150)];
        _provinceView.center = self.view.center;
        [_allView addSubview:_provinceView];
        
        //在View 上面添加滚动试图
        UIScrollView *provinceScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, PWrith, MainScreenHeight - 150)];
        provinceScrollView.backgroundColor = [UIColor whiteColor];
        //        provinceScrollView.center = self.view.center;
        provinceScrollView.contentSize = CGSizeMake(0, _provinceArray.count * 30 + 200);
        [_provinceView addSubview:provinceScrollView];
        
        //添加头上的图标
        UIView *TView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PWrith, 50)];
        TView.backgroundColor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
        [_provinceView addSubview:TView];
        
        //添加图片
        UIButton *JGButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [JGButton setBackgroundImage:[UIImage imageNamed:@"警告@2x"] forState:UIControlStateNormal];
        [TView addSubview:JGButton];
        
        //添加文本
        UILabel *JGLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, PWrith - 60, 50)];
        JGLabel.textColor = [UIColor whiteColor];
        JGLabel.font = [UIFont systemFontOfSize:22];
        JGLabel.text = @"请选择省份";
        [TView addSubview:JGLabel];
    
        for (int i = 0; i < _provinceArray.count; i++) {
            
            provinceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 30 * i + 5 * i, MainScreenWidth, 30)];
            [provinceButton setTitle:_provinceArray[i] forState:UIControlStateNormal];
            [provinceButton addTarget:self action:@selector(pressedProvinceBank:) forControlEvents:UIControlEventTouchUpInside];
            provinceButton.tag = i;
            provinceButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [provinceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            provinceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            provinceButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            [provinceScrollView addSubview:provinceButton];
            
            //添加分割线
            UILabel *HLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30 + 30 * i + 5 * i, PWrith, 1)];
            HLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [provinceScrollView addSubview:HLabel];
        }
    }
    if (button.tag == 2) {//城市的分类
        if (!_provinceLabel.text.length) {
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请按照顺写填写" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertV show];
            return;
        }
        NSString *provinceId = [NSString string];
        for (int i = 0 ; i < _bigArray.count; i ++) {
            if ([_bigArray[i][@"title"] isEqualToString:_provinceLabel.text]) {//说明取到当前省份的id
                provinceId = _bigArray[i][@"area_id"];
            }
        }
        _cityArray = [NSMutableArray array];
        for (int i = 0 ; i < _bigArray.count; i++) {
            if ([_bigArray[i][@"pid"] isEqualToString:provinceId]) {
                //说明是改省份下面的城市
                NSString *city = _bigArray[i][@"title"];
                [_cityArray addObject:city];
            }
        }
        //添加全屏view
        _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
        _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.5];
        [self.view addSubview:_allView];
        
        //添加中间的按钮
        _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
        [_allButton setBackgroundColor:[UIColor clearColor]];
        [_allButton addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
        
        [_allView addSubview:_allButton];
        
        CGFloat CWrith = MainScreenWidth / 3 * 2;
        _cityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CWrith, MainScreenHeight - 150)];
        _cityView.center = self.view.center;
        [_allView addSubview:_cityView];
        
        //添加头上的图标
        UIView *TView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CWrith, 50)];
        TView.backgroundColor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
        [_cityView addSubview:TView];
        
        //添加图片
        UIButton *JGButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [JGButton setBackgroundImage:[UIImage imageNamed:@"警告@2x"] forState:UIControlStateNormal];
        [TView addSubview:JGButton];
        
        //添加文本
        UILabel *JGLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, CWrith - 60, 50)];
        JGLabel.textColor = [UIColor whiteColor];
        JGLabel.font = [UIFont systemFontOfSize:22];
        JGLabel.text = @"请选择城市";
        [TView addSubview:JGLabel];
        
        //在View 上面添加滚动试图
        UIScrollView *cityScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, CWrith, MainScreenHeight - 200)];
        cityScrollView.backgroundColor = [UIColor whiteColor];
        cityScrollView.contentSize = CGSizeMake(0, _cityArray.count * 30 + 100);
        [_cityView addSubview:cityScrollView];
        
        for (int i = 0; i < _cityArray.count; i++) {
            provinceButton = [[UIButton alloc] initWithFrame:CGRectMake(0,30 * i + i * 5, MainScreenWidth, 30)];
            [provinceButton setTitle:_cityArray[i] forState:UIControlStateNormal];
            [provinceButton addTarget:self action:@selector(pressedMoreCityButton:) forControlEvents:UIControlEventTouchUpInside];
            provinceButton.tag = i;
            [provinceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            provinceButton.titleLabel.font = [UIFont systemFontOfSize:14];
            provinceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            provinceButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            
            [cityScrollView addSubview:provinceButton];
            
            //添加分割线
            UILabel *HLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30 + 30 * i + 5 * i, CWrith, 1)];
            HLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [cityScrollView addSubview:HLabel];
            
        }
    }
    
    if (button.tag == 3) {//地区的分类
        if (!_cityLabel.text.length) {
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请按照顺写填写" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertV show];
            return;
        }
        NSString *cityId = [NSString string];
        for (int i = 0 ; i < _bigArray.count; i ++) {
            if ([_bigArray[i][@"title"] isEqualToString:_cityLabel.text]) {
                //说明取到当前市的id
                cityId = _bigArray[i][@"area_id"];
            }
        }
        _areaArray = [NSMutableArray array];
        for (int i = 0 ; i < _bigArray.count; i++) {
            if ([_bigArray[i][@"pid"] isEqualToString:cityId]) {
                //获得当前市下面的区名
                NSString *area = _bigArray[i][@"title"];
                [_areaArray addObject:area];
            }
        }
        
        //添加全屏view
        _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
        _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.5];
        [self.view addSubview:_allView];
        
        //添加中间的按钮
        _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
        [_allButton setBackgroundColor:[UIColor clearColor]];
        [_allButton addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
        
        [_allView addSubview:_allButton];
        
        
        CGFloat AWrith = MainScreenWidth / 3 * 2;
        _areaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AWrith, MainScreenHeight - 150)];
        _areaView.center = self.view.center;
        [_allView addSubview:_areaView];
        
        //添加头上的图标
        UIView *TView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AWrith, 50)];
        TView.backgroundColor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
        [_areaView addSubview:TView];
        
        //添加图片
        UIButton *JGButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [JGButton setBackgroundImage:[UIImage imageNamed:@"警告@2x"] forState:UIControlStateNormal];
        [TView addSubview:JGButton];
        
        //添加文本
        UILabel *JGLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, AWrith - 60, 50)];
        JGLabel.textColor = [UIColor whiteColor];
        JGLabel.font = [UIFont systemFontOfSize:22];
        JGLabel.text = @"请选择城区";
        [TView addSubview:JGLabel];
        
        //在View 上面添加滚动试图
        UIScrollView *cityScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, AWrith, MainScreenHeight - 200)];
        cityScrollView.backgroundColor = [UIColor whiteColor];
        cityScrollView.contentSize = CGSizeMake(0, _areaArray.count * 30 + 100);
        [_areaView addSubview:cityScrollView];
        
        for (int i = 0; i < _areaArray.count; i++) {
            
            provinceButton = [UIButton buttonWithType:UIButtonTypeSystem];
            provinceButton.frame = CGRectMake(0, 30 * i + 5 * i, AWrith, 30);
            [provinceButton setTitle:_areaArray[i] forState:UIControlStateNormal];
            [provinceButton addTarget:self action:@selector(pressedMoreAreaButton:) forControlEvents:UIControlEventTouchUpInside];
            provinceButton.tag = i;
            [provinceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            provinceButton.titleLabel.font = [UIFont systemFontOfSize:14];
            provinceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            provinceButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            [cityScrollView addSubview:provinceButton];
            
            //添加分割线
            UILabel *HLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30 + 30 * i + 5 * i, AWrith, 1)];
            HLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [cityScrollView addSubview:HLabel];
        }
    }
}


- (void)addBankView {
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:_allView];
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
    
    [_allView addSubview:_allButton];
    
    
    CGFloat BWrith = MainScreenWidth / 3 * 2;
    //创建个View
    _bankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BWrith, MainScreenHeight - 150)];
    _bankView.center = self.view.center;
    _bankView.backgroundColor = [UIColor whiteColor];
    [_allView addSubview:_bankView];
    
    //添加头上的图标
    UIView *TView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BWrith, 50)];
    TView.backgroundColor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
    [_bankView addSubview:TView];
    
    //添加图片
    UIButton *JGButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [JGButton setBackgroundImage:[UIImage imageNamed:@"警告@2x"] forState:UIControlStateNormal];
    [TView addSubview:JGButton];
    
    //添加文本
    UILabel *JGLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, BWrith - 60, 50)];
    JGLabel.textColor = [UIColor whiteColor];
    JGLabel.font = [UIFont systemFontOfSize:22];
    JGLabel.text = @"请选择开户行";
    [TView addSubview:JGLabel];
    
    for (int i = 0; i < 12 ; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 30 * i + 50 + 5 * i, BWrith, 30);
        [button setTitle:_bankArray[i] forState:UIControlStateNormal];
        button.tag = i;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //按钮的文字靠左
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [button addTarget:self action:@selector(pressedBankButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bankView addSubview:button];
        
        //添加分割线
        UILabel *HLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50 + 30 + 30 * i + 5 * i, BWrith, 1)];
        HLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_bankView addSubview:HLabel];
        
    }
}

- (void)sureButtonPressed:(UIButton *)button {
    
    NSLog(@"-----%@",_dic);
    if ([_dic isEqual:[NSNull null]]) {
        
    } else {
        _bankID = _dic[@"id"];
    }
    
    
    if ([_dic isEqual:[NSNull null]] ) {//说明这里应该是添加银行卡
        ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
        NSMutableDictionary *dic =[[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
        //地区的字符串
        NSString *location = [NSString stringWithFormat:@"%@%@%@",_provinceLabel.text,_cityLabel.text,_AreaLabel.text];
        
        if (self.bankNumberField.text.length  && self.userNameField.text.length  && self.bankNameLabel.text.length  && self.telNumberField.text.length && self.addressField.text.length && location.length) {
            [dic setObject:self.bankNumberField.text forKey:@"account"];
            [dic setObject:self.userNameField.text forKey:@"accountmaster"];
            [dic setObject:self.bankNameLabel.text forKey:@"accounttype"];
            [dic setObject:self.telNumberField.text forKey:@"tel_num"];
            [dic setObject:_addressField.text forKey:@"bankofdeposit"];
            [dic setObject:location forKey:@"location"];
            [dic setObject:_provinceLabel.text forKey:@"province"];
            [dic setObject:_cityLabel.text forKey:@"city"];
            [dic setObject:_AreaLabel.text forKey:@"area"];

        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"信息不完整" delegate:self cancelButtonTitle:nil otherButtonTitles:@"返回", nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];
            return;
        }
        
        NSLog(@"%@",dic);
        
        [manager addBankCard:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *msg = [responseObject objectForKey:@"msg"];
            if ([msg isEqual:@"ok"]) {
                //添加银行卡成功
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"添加成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    }else {//说明这里是修改银行卡
        
        ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
        NSMutableDictionary *dic =[[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
        //地区的字符串
        NSString *location = [NSString stringWithFormat:@"%@%@%@",_provinceLabel.text,_cityLabel.text,_AreaLabel.text];
        
        if (self.bankNumberField.text.length != 0 && self.userNameField.text.length != 0 && self.bankNameLabel.text.length != 0 && self.telNumberField.text.length != 0 && self.addressField.text.length != 0 && location.length != 0 ) {
            [dic setObject:self.bankNumberField.text forKey:@"account"];
            [dic setObject:self.userNameField.text forKey:@"accountmaster"];
            [dic setObject:self.bankNameLabel.text forKey:@"accounttype"];
            [dic setObject:self.telNumberField.text forKey:@"tel_num"];
            
            [dic setObject:_addressField.text forKey:@"bankofdeposit"];
            [dic setObject:_bankID forKey:@"id"];
            
            [dic setObject:location forKey:@"location"];
            [dic setObject:_idProvince forKey:@"province"];
            [dic setObject:_idCity forKey:@"city"];
            [dic setObject:_idArea forKey:@"area"];
            
        } else {
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"信息不完整" delegate:self cancelButtonTitle:nil otherButtonTitles:@"返回", nil];
            //            [alert show];
            //            return;
        }
        
        
        [manager addBankCard:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *msg = [responseObject objectForKey:@"msg"];
            if ([msg isEqualToString:@"ok"]) {
                //修改银行卡成功
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"修改成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"修改失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        
    }
    
    
}

- (void)hehe
{
    
    
}

- (void)pressedBankButton:(UIButton *)sender
{
    
    NSString *buttonTitle = _bankArr[sender.tag];
    _bankNameLabel.text = buttonTitle;
    [_bankView removeFromSuperview];
    [_allView removeFromSuperview];
    [_allButton removeFromSuperview];
    
    
}


- (void)pressedProvinceBank:(UIButton *)button
{
    _cityLabel.text = @"";
    _AreaLabel.text = @"";
    NSString *str;
    str =[NSString stringWithFormat:@"%@",_provinceArray[button.tag]];
    if ([str rangeOfString:@"市"].location != NSNotFound){
        _cityLabel.text = str;
        
        CSButton.enabled = NO;
        
    }else{
        
        CSButton.enabled = YES;
    }
    _provinceLabel.text = str;
    [_provinceView removeFromSuperview];
    [_allView removeFromSuperview];
    [_allButton removeFromSuperview];
    
    //获得当前选中省份的id
    for (int i = 0; i < _bigArray.count; i++) {
        if ([_bigArray[i][@"title"] isEqualToString:_provinceLabel.text]) {//找到对应省份的id
            _idProvince = _bigArray[i][@"area_id"];
        }
    }
}
- (void)pressedMoreCityButton:(UIButton *)button
{
    NSString *str;
    str = [NSString stringWithFormat:@"%@",_provinceLabel.text ];
    if ([str rangeOfString:@"市"].location != NSNotFound){
        return;
    }
    _cityLabel.text = _cityArray[button.tag];
    [_cityView removeFromSuperview];
    [_allView removeFromSuperview];
    [_allButton removeFromSuperview];
    for (int i = 0; i < _bigArray.count; i++) {
        
        if ([_bigArray[i][@"title"] isEqualToString:_cityLabel.text]) {
            _idCity = _bigArray[i][@"area_id"];
        }
    }
}

- (void)pressedMoreAreaButton:(UIButton *)button
{
    _AreaLabel.text = _areaArray[button.tag];
    [_areaView removeFromSuperview];
    [_allView removeFromSuperview];
    [_allButton removeFromSuperview];
    
    
    for (int i = 0; i < _bigArray.count; i++) {
        if ([_bigArray[i][@"title"] isEqualToString:_AreaLabel.text]) {
            _idArea = _bigArray[i][@"area_id"];
        }
    }
    
}

- (void)go {//使全局view 消失
    _allView.hidden = YES;
    _allButton.hidden = YES;
    
}


- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}




@end
