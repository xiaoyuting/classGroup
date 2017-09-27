//
//  EditAdressViewController.m
//  dafengche
//
//  Created by IOS on 16/11/17.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#define DeviceHight [UIScreen mainScreen].bounds.size.height
#define DeviceWidth [UIScreen mainScreen].bounds.size.width
#import "EditAdressViewController.h"

#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "GLTextView.h"
#import "AdddressModle.h"
#import "MyHttpRequest.h"
#import "CityPickerViewController.h"
#import "SkyerCityPicker.h"

#import "HXProvincialCitiesCountiesPickerview.h"

#import "HXAddressManager.h"

@interface EditAdressViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    UITextField *_TF;
    UITextField *_TF1;
    UITextField *_TF2;
    UITextField *_TF3;
    UIButton *sureBtn;
    NSArray *_array;
    GLTextView *textV ;
    AdddressModle *_model;
    NSString *_province;
    NSString *_city;
    NSString *_address_id;
    NSString *_area;
    NSString *_address;
    NSString *_name;
    NSString *_phone;
    NSString *_is_default;
    UIButton *_setBtn;
    UIImageView * _imgV;
    
    
}

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)UITextField *TF3;
;

@property (strong ,nonatomic)NSArray *lookArray;

@property (strong ,nonatomic)UIScrollView *headScrollow;

//存放数据
@property (nonatomic , retain)NSArray *dataArray;

@property (nonatomic , retain)NSString *detilAdress;

@property (nonatomic,strong) HXProvincialCitiesCountiesPickerview *regionPickerView;



@end

@implementation EditAdressViewController


-(instancetype)initWithName:(NSString *)name adress:(NSString *)adress phone:(NSString *)phone area:(NSString *)area is_default:(NSString *)is_default address_id:(NSString *)address_id{

    if (self = [super init]) {
        
        _name = name;
        _address = adress;
        _area = area;
        _phone = phone;
        _is_default = is_default;
        _address_id = address_id;
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

-(void)requestData
{
    NSLog(@"========%@%@%@==%@",_address,_phone,_name,_is_default);
    
    QKHTTPManager * manager = [QKHTTPManager manager];
    
    //http://dafengche.51eduline.com/?app=api&mod=Address&act=addAdress&oauth_token=44da0cedbcda40ce2fabfafb51ae4622&oauth_token_secret=34e7b83af30a98d365ec47610761dae1&province=12&city=21&area=214&address=42156&nanme=1245&phone=15538983107&is_default
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *key = [user objectForKey:@"oauthToken"];
    NSString *passWord = [user objectForKey:@"oauthTokenSecret"];
    _detilAdress = textV.text;
    //    //去掉左右的空格
    //    [_province stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    [_city stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    [_area stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    [_detilAdress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    _detilAdress = [_detilAdress stringByReplacingOccurrencesOfString:@" " withString:@""];
    //
    //    [_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    [_phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    [_is_default stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    _name = [_name stringByReplacingOccurrencesOfString:@" " withString:@""];
    //
    NSString *scheme  = @"http://dafengche.51eduline.com/?app=api&mod=Address&act=setAdress";
    
   // NSDictionary *parameter=@{@"oauth_token": key,@"oauth_token_secret": passWord ,@"province": _province,@"city": _city,@"area": _area,@"address": _detilAdress,@"nanme": _name,@"phone": _phone,@"address_id":_address_id,@"is_default": _is_default};
    _province = [NSString stringWithFormat:@"%@",_province];
    _city = [NSString stringWithFormat:@"%@",_city];
    _area = [NSString stringWithFormat:@"%@",_area];
    _detilAdress = [NSString stringWithFormat:@"%@",_detilAdress];
    _name = [NSString stringWithFormat:@"%@",_name];
    _phone = [NSString stringWithFormat:@"%@",_phone];
    _address_id = [NSString stringWithFormat:@"%@",_address_id];
    _is_default = [NSString stringWithFormat:@"%@",_is_default];
    NSLog(@"%@",_name);
    NSDictionary *parameter=@{@"oauth_token": key,@"oauth_token_secret":passWord,@"province": _province,@"city": _city,@"area": _area,@"address": _detilAdress,@"name": _name,@"phone": _phone,@"address_id":_address_id,@"is_default": _is_default};

    [manager getpublicPort:parameter mod:@"Address" act:@"setAdress" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"===__===%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:responseObject[@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"新增收货地址失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
    
    //    [manager addAddress:dic mod:@"Address" act:@"addAdress" province:_province city:_city area:_area address:textV.text nanme:_name phone:_phone is_default:_is_default success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        NSLog(@"===__===%@",responseObject);
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //
    //    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addNav];
    [self creatbody];
    
}

#pragma 添加详情
//------ body部分-------
-(void)creatbody{
    
    NSArray *arr = @[@"  收货人",@"  联系电话",@"  所在区域"];
    NSArray *placedarr = @[@"请输入您的名字",@"请填写电话号码",@"请选择区域"];
    
    NSArray *textArr = @[_name,_phone,_area];

    for (int i = 0; i<3; i++) {
        
        _TF = [[UITextField alloc]initWithFrame:CGRectMake(15,90+i*60*verticalrate +10*i, DeviceWidth - 30,60*verticalrate)];
        _TF.borderStyle = UITextBorderStyleNone;
        _TF.text = textArr[i];
        _TF.textColor = [UIColor colorWithHexString:@"#999999"];
        _TF.font = [UIFont systemFontOfSize:15*horizontalrate];
        [self.view addSubview:_TF];
        [_TF addTarget:self action:@selector(totalWealthDidChange:) forControlEvents:UIControlEventAllEvents];
        _TF.tag = i;
        //设置输入框内容的字体样式和大小
        _TF.font = [UIFont fontWithName:@"Arial" size:15*horizontalrate];
        //设置字体颜色
        _TF.textColor = [UIColor colorWithHexString:@"#333333"];
        //UITextField左右视图
        UILabel * leftView=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100*horizontalrate, 60*horizontalrate)];
        leftView.contentMode = UIViewContentModeLeft;
        leftView.textAlignment = NSTextAlignmentLeft;
        leftView.text = arr[i];
        leftView.font = [UIFont systemFontOfSize:15*MainScreenWidth/320];
        leftView.textColor = [UIColor colorWithHexString:@"#333333"] ;
        //占位符字体颜色
        NSDictionary *dic = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"], NSFontAttributeName:[UIFont systemFontOfSize:14*MainScreenWidth/320]};
        
        _TF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",placedarr[i]]attributes:dic];
        _TF.leftView=leftView;
        _TF.leftViewMode=UITextFieldViewModeAlways;
        [_TF.layer setBorderColor:[UIColor colorWithHexString:@"#cdcdcd"].CGColor];
        [_TF.layer setBorderWidth:0.5];
        [_TF.layer setMasksToBounds:YES];
        if (i==2) {
            UIButton *btn = [[UIButton alloc]initWithFrame:_TF.frame];
            [self.view addSubview:btn];
            [btn addTarget:self action:@selector(btnSelect) forControlEvents:UIControlEventTouchUpInside];
            _TF3 = _TF;
        }
        
    }
    UILabel * detailAdress=[[UILabel alloc]initWithFrame:CGRectMake(15, _TF.current_y_h + 10, 80*horizontalrate, 40*horizontalrate)];
    detailAdress.contentMode = UIViewContentModeLeft;
    detailAdress.textAlignment = NSTextAlignmentLeft;
    detailAdress.text = @"详细地址";
    detailAdress.font = [UIFont systemFontOfSize:15*MainScreenWidth/320];
    detailAdress.textColor = [UIColor colorWithHexString:@"#333333"] ;
    [self.view addSubview:detailAdress];
    
    textV = [[GLTextView alloc]initWithFrame:CGRectMake(detailAdress.current_x_w +5*horizontalrate, detailAdress.current_y +5, MainScreenWidth - detailAdress.current_x_w - 20*horizontalrate, 100)];
    [self.view addSubview:textV];
    textV.text = _address;
    
    // [textV addTarget:self action:@selector(TexvDidChange:) forControlEvents:UIControlEventAllEvents];
    
    textV.backgroundColor = [UIColor whiteColor];
    [textV setPlaceholder:@"请填写详细地址"];
    [textV setFont:[UIFont systemFontOfSize:15*horizontalrate]];
    [textV.layer setBorderColor:[UIColor colorWithHexString:@"#cdcdcd"].CGColor];
    [textV.layer setBorderWidth:0.5];
    [textV.layer setMasksToBounds:YES];
    //最后一个
    
    UIImage * buttonImage = [UIImage imageNamed:@"点评返回@2x"];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, textV.current_y_h+10*horizontalrate,MainScreenWidth, 40*horizontalrate)];
    titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLab.text = @"设为默认地址";
    titleLab.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:titleLab];
    titleLab.backgroundColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:15*MainScreenWidth/320];
    
    _imgV = [[UIImageView alloc]initWithFrame:CGRectMake(MainScreenWidth - 20 -20,titleLab.current_y +10, 20, 20)];
    CGPoint center = _imgV.center;
    center.y = titleLab.current_y +titleLab.current_h/2;
    _imgV.center = center;
    if ([_is_default isEqualToString: @"1"]) {
        _imgV.image = [UIImage imageNamed:@"check_cb_on"];
        
    }else{
        
        _imgV.image = [UIImage imageNamed:@"check_cb_no"];
        
    }
    [self.view addSubview:_imgV];
    
    _setBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, textV.current_y_h+10*horizontalrate,MainScreenWidth -20, 40*horizontalrate)];
    [_setBtn addTarget:self action:@selector(gonew) forControlEvents:UIControlEventTouchUpInside];
    [_setBtn addTarget:self action:@selector(gonew) forControlEvents:UIControlEventTouchUpInside];
    _setBtn.backgroundColor = [UIColor clearColor];
    [_setBtn.layer setBorderColor:[UIColor colorWithHexString:@"#333333"].CGColor];
    [_setBtn.layer setBorderWidth:0.5];
    _setBtn.tag = 0;
    [self.view addSubview:_setBtn];
    [_setBtn addTarget:self action:@selector(setD:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)setD:(UIButton *)sender{
    
    
    if ([_is_default isEqualToString: @"1"]) {
        _imgV.image = [UIImage imageNamed:@"check_cb_no"];
        _is_default = @"2";
    }else{
        _imgV.image = [UIImage imageNamed:@"check_cb_on"];
        _is_default = @"1";
    }

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

-(void)gonew{
    NSLog(@"w");
    
}

-(void)TexvDidChange:(UITextView *)sender{
    
    
}
//监听textFiled
-(void)totalWealthDidChange:(UITextField *)sender{
    if (sender.tag == 0) {
        _TF1 =sender;
        _TF1.text = sender.text;
        _name = sender.text;
    }else if(sender.tag == 1)
    {
        _TF2 =sender;
        _TF2.text = sender.text;
        _phone = sender.text;
        
    }else if(sender.tag == 2){
        
        _TF3 =sender;
        _TF3.text = sender.text;
        _address = sender.text;
    }
}
- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"修改收货地址";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 170, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,156)];
    [backButton setTitle:@" " forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    //设置button上字体的偏移量
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10.0 , 0.0, 0)];
    [SYGView addSubview:backButton];
    
    UIButton *SXButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50, 32, 40, 20)];
    //    [SXButton setBackgroundImage:[UIImage imageNamed:@"资讯分类@2x"] forState:UIControlStateNormal];
    [SXButton setTitle:@"修改" forState:UIControlStateNormal];
    SXButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [SXButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [SXButton addTarget:self action:@selector(saveAdress) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:SXButton];
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
}

//新的pickview
- (HXProvincialCitiesCountiesPickerview *)regionPickerView {
    if (!_regionPickerView) {
        _regionPickerView = [[HXProvincialCitiesCountiesPickerview alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        __weak typeof(self) wself = self;
        _regionPickerView.completion = ^(NSString *provinceName,NSString *cityName,NSString *countyName) {
            _detilAdress = [NSString stringWithFormat:@"%@ %@ %@",provinceName,cityName,countyName];
            _province = provinceName;
            _city = cityName;
            _area = countyName;
            wself.TF3.text = wself.detilAdress;
            
        };
        [self.navigationController.view addSubview:_regionPickerView];
    }
    return _regionPickerView;
}

//分类
-(void)saveAdress{
    
    [self requestData];
    NSLog(@"分类");
}
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)btnSelect {
    
    [self.view endEditing:YES];
    
    NSString *address = _TF.text;
    NSArray *array = [address componentsSeparatedByString:@" "];
    
    NSString *province = @"";//省
    NSString *city = @"";//市
    NSString *county = @"";//县
    if (array.count > 2) {
        province = array[0];
        city = array[1];
        county = array[2];
    } else if (array.count > 1) {
        province = array[0];
        city = array[1];
    } else if (array.count > 0) {
        province = array[0];
    }
    
    [self.regionPickerView showPickerWithProvinceName:province cityName:city countyName:county];
}

@end
