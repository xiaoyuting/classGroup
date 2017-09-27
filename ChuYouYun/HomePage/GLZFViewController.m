//
//  GLZFViewController.m
//  dafengche
//
//  Created by IOS on 16/12/14.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//


#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define pKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAOJ/ZIvJnJuXqdKNqZEqbL7TBu/Z8/fKlbk0dOonEMXMaIWlrpU58NlKp9sJr3Fm/wmQb8FRMLqidrkdYIXlNfN/dvRTFZ42WmmAYgDGFk1YZ6lQw4uMezOLrdi2XbRFjTu3V/oHv0z8UjnZao6UdHoBHV3RMwBFLL7TmBDMjHI1AgMBAAECgYEApU4ivN8lPG2hVPltM3SKL29m1bD1nPiu85+0YJyoYiRAeKImW+UQwhX5kiRsdlCcfId8+NNfxCcEjTBCnRZfm3rdwsYmL6yVpalWSxRoq+AZnJe1vi61Xl01Esevb9sgsRYlaGVRQLNUMCTGj2CGsHS6ik4e57YZn2fY7KF1v+ECQQD36TEhRXRHfZ+EdY1zYXnrJO3Rpq50OOIzAAw9tntcFrbhOF5eYI5RtGQHapraYzHJEjCY7ArGORui9CIcki75AkEA6eNVw7KZbO0Jcebkh1BxvBcdInQ9D+73yQunkb+X3gW99KprUnwXNxMHgpdVDORgn2ONNoPjmSNcMNuoHI4gHQJAdT4xX/zK2yyMDkbR2KlW0WAroKTliE2GnHv/TghJGuobHzRbXOLpK7bWP7Oo/HNBDkit9wRarBhB+7TdlQmFcQJAUjXyY4NXoo3/D+ZU1atVDwQg3Yd2Hy+kMSrDj9uEiioChwmQB8JOdrFdpm2DG7D6tYvMiyj4y08+jH3pLYBXkQJADP5np2RoScgIxNc28rTjFBBWbaWsu8xA6tRa0Rr+HMeYJLKoU0k/cgJM7/M09dt/QooJ6Od+2/nD7n3Yx+ML0A=="


#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4 4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕


#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕


#import "GLZFViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UIColor+HTMLColors.h"


@interface GLZFViewController ()

@property (strong ,nonatomic)UIButton *seletButton;
@property (strong ,nonatomic)UIButton *button;
@property (strong ,nonatomic)UIButton *topUpButton;

@property (strong ,nonatomic)NSString *tpyeStr;

@property (nonatomic , strong)UIButton *SYGButton;

@property (nonatomic , strong)UILabel *XYLabel;

@property (strong ,nonatomic)UILabel *HFLabel;

@end

@implementation GLZFViewController

-(NSArray *)array{
    
    NSMutableArray *marr = [[NSMutableArray alloc]init];
    
    if (!_array) {
        NSURL *url = [NSURL URLWithString:@"http://demo.51eduline.com/index.php?app=api&mod=User&act=getAlipayInfo&oauth_token=c5844240e84d14ccc27a6b466ae47df4&oauth_token_secret=5d4eea9d312c99ab7c3160b4c4047045"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        [marr addObject:[dic valueForKey:@"data"]];
        _array = [[NSArray alloc]initWithArray:marr];
    }
    return _array;
}

- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    
    [nv isHiddenCustomTabBarByBoolean:YES];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    //创建通知（此通知来监听TextField里面的变化）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afterClass:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 20)];
    [backButton setImage:[UIImage imageNamed:@"Arrow000"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bake = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:bake];
    [self initer];
}

- (void)initer
{
    self.title = @"充值";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 12, 22)];
    [backButton setImage:[UIImage imageNamed:@"iconfont-FH"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"充值";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
    NSArray *titleArray = @[@"支付宝支付",@"微信支付"];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:titleArray];
    segment.frame = CGRectMake(MainScreenWidth / 4 , 80, MainScreenWidth / 2 , 35);
    segment.selectedSegmentIndex = 0;
    [segment setTintColor:[UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1]];
    [segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    
    //充值金额
    UILabel *CZJELabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 80, 30)];
    CZJELabel.text = @"充值金额";
    [self.view addSubview:CZJELabel];
    
    //添加按钮
    NSArray *JEArray = @[@"10元",@"20元",@"50元",@"100元"];
    for (int i = 0 ; i < 4; i ++) {
        UIButton *JEButton = [UIButton buttonWithType:UIButtonTypeSystem];
        JEButton.frame = CGRectMake(100 + MainScreenWidth / 3 * (i % 2 ), 130 + (i / 2) * 30 + 15 * (i / 2),  60, 30);
        if (iPhone4SOriPhone4 || iPhone5o5Co5S) {
            JEButton.frame = CGRectMake(100 + MainScreenWidth / 4 * (i % 2 ), 130 + (i / 2) * 30 + 15 * (i / 2),  60, 30);
        }else {
            JEButton.frame = CGRectMake(100 + MainScreenWidth / 3 * (i % 2 ), 130 + (i / 2) * 30 + 15 * (i / 2),  60, 30);
        }
        JEButton.backgroundColor = [UIColor whiteColor];
        [JEButton setTitleColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] forState:UIControlStateNormal];
        [JEButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [JEButton setTitle:JEArray[i] forState:UIControlStateNormal];
        JEButton.layer.cornerRadius = 5;
        JEButton.titleLabel.font = [UIFont systemFontOfSize:20];
        JEButton.layer.borderColor = [UIColor blackColor].CGColor;
        [JEButton addTarget:self action:@selector(JEButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:JEButton];
        
    }
    
    //备注
    UILabel *remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 5, 210, MainScreenWidth / 5, 30)];
    remarkLabel.text = @"备注：";
    remarkLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:remarkLabel];
    
    //提示
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 5 * 2, 210, MainScreenWidth / 5 * 3, 30)];
    hintLabel.text = @"1元=10积分";
    hintLabel.textAlignment = NSTextAlignmentLeft;
    [hintLabel setTextColor:[UIColor orangeColor]];
    [self.view addSubview:hintLabel];
    
    //输入金额
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 , 250, 100 , 30)];
    moneyLabel.text = @"自定义金额";
    [moneyLabel setTextColor:[UIColor blackColor]];
    [self.view addSubview:moneyLabel];
    
    _moneyField = [[UITextField alloc] initWithFrame:CGRectMake(120,255 ,MainScreenWidth - 150, 20)];
    _moneyField.keyboardType = UIKeyboardTypeNumberPad;
    //    _moneyField.layer.borderWidth = 1;
    _moneyField.placeholder = @"请输入充值金额";
    _moneyField.delegate = self;
    //    _moneyField.layer.borderColor = [UIColor grayColor].CGColor;
    //    _moneyField.layer.cornerRadius = 3;
    [self.view addSubview:_moneyField];
    
    
    
    //
    UILabel *XYLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 290, 90, 30)];
    XYLabel.text = @"需要花费：";
    [self.view addSubview:XYLabel];
    
    UILabel *HFLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 290, MainScreenWidth - 120, 30)];
    [self.view addSubview:HFLabel];
    _HFLabel = HFLabel;
    //    HFLabel.backgroundColor = [UIColor blueColor];
    NSLog(@"%@",_moneyField.text);
    HFLabel.text = _moneyField.text;
    if (_moneyField.text.length > 0) {
        HFLabel.text = _moneyField.text;
    }else {
        _XYLabel = HFLabel;
    }
    
    //
    for (int i = 0; i < 2; i ++) {
        UILabel *HLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 245 + 40 * i, MainScreenWidth, 1)];
        HLabel.backgroundColor = [UIColor colorWithRed:224.f / 255 green:225.f / 255 blue:226.f / 255 alpha:1];
        [self.view addSubview:HLabel];
    }
    
    UILabel *ZLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 325, MainScreenWidth, 1)];
    ZLabel.backgroundColor = [UIColor colorWithRed:224.f / 255 green:225.f / 255 blue:226.f / 255 alpha:1];
    [self.view addSubview:ZLabel];
    
    
    //立即充值
    _topUpButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _topUpButton.frame = CGRectMake(50, 350, MainScreenWidth - 100, 40);
    [_topUpButton setTitle:@"立即充值" forState:UIControlStateNormal];
    [_topUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _topUpButton.layer.cornerRadius = 5;
    _topUpButton.backgroundColor = [UIColor colorWithRed:33.f / 255 green:81.f / 255 blue:196.f / 255 alpha:1];
    
    
    [self.view addSubview:_topUpButton];
    
    
    [_topUpButton addTarget:self action:@selector(topUpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    //默认值为
    _tpyeStr = @"zhifu";
    
}


- (void)afterClass:(NSNotification *)Not {
    
    
    NSLog(@"%@",self.moneyField.text);
    _HFLabel.text = [NSString stringWithFormat:@"%@元",_moneyField.text];
    
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    _HFLabel.text = _moneyField.text;
//}


- (void)change:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            //支付宝
        {
            _tpyeStr =@"zhifu";
            
        }
            break;
        case 1:
            //在线支付
            
        {
            _tpyeStr =@"zaixian";
            
        }
            
            break;
        default:
            break;
    }
}


- (void)topUpButtonPressed
{
    if (_moneyField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请选择充值金额" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        //充值
        if ([_tpyeStr isEqualToString:@"zhifu"]) {//支付宝
            [self orderPay];
        } else {//在线支付
            //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"充值失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            //        [alert show];
            [self wxpay];
        }
        
        
    }
    
}

//支付宝
- (void)orderPay {
    NSString *alipay_partner;
    NSString *private_key;
    NSString *seller_email;
    for (int i=0; i<self.array.count; i++) {
        for (NSDictionary *dic in self.array) {
            alipay_partner = [NSString stringWithFormat:@"%@",dic[@"alipay_partner"]];
            private_key = [NSString stringWithFormat:@"%@",dic[@"private_key"]];
            seller_email = [NSString stringWithFormat:@"%@",dic[@"seller_email"]];
        }
    }
    Order *order = [[Order alloc] init];
    order.subject = @"Eduline充值";
    order.body = @"购买元";
    order.partner = alipay_partner;
    order.sellerID = seller_email;
    order.outTradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    //NSLog(@"订单号：%@",order.outTradeNO);
    order.totalFee =_moneyField.text;
    order.notifyURL =  @"http://m.alipay.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showURL = @"m.alipay.com";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    //签名加密
    id<DataSigner> signer = CreateRSADataSigner(private_key);
    NSString *signedString = [signer signString:orderSpec];
    NSLog(@"%@",@"RSA");
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString!=nil) {
        //生成订单信息
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",[order description],signedString,@"RSA"];
        NSLog(@"orderString============%@",orderString);
        //打开客户端进行支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"aliPayEduline" callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSLog(@"%@",resultDic[@"memo"]);
            NSString *string;
            string = @"";
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                string = @"订单支付成功";
            }else if ([resultDic[@"resultStatus"] isEqualToString:@"8000"]){
                string = @"正在处理中";
                
            }else if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]){
                string = @"订单支付失败";
                
            }else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]){
                string = @"用户中途取消";
                
            }else if ([resultDic[@"resultStatus"] isEqualToString:@"6002"]){
                string = @"网络连接出错";
                
            }
            
            if (string.length) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                
            }
        }];
        
    }
}
//支付宝订单号生成方法
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

-(void)wxpay{
    
    //    /** 商家向财付通申请的商家id */
    //    @property (nonatomic, retain) NSString *partnerId;
    //    /** 预支付订单 */
    //    @property (nonatomic, retain) NSString *prepayId;
    //    /** 随机串，防重发 */
    //    @property (nonatomic, retain) NSString *nonceStr;
    //    /** 时间戳，防重发 */
    //    @property (nonatomic, assign) UInt32 timeStamp;
    //    /** 商家根据财付通文档填写的数据和签名 */
    //    @property (nonatomic, retain) NSString *package;
    //    /** 商家根据微信开放平台文档对数据做的签名 */
    //    @property (nonatomic, retain) NSString *sign;
    
    NSString * timeString = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSLog(@"=====%@",timeString);
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = @"1348203201";
    request.prepayId= @"1101000000140415649af9fc314aa427";
    request.package = @"Sign=WXPay";
    request.nonceStr= @"Q0BvU56qMuqWXlCVg5q2O7yV7POZFA9A";
    request.timeStamp= timeString.intValue;
    request.sign= @"135F7C56C3007E0B0BC74FB3685EBF1C";
    [WXApi sendReq:request];
}

- (void)jumpToBizPay {
    
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    NSString *urlString   = @"https://api.mch.weixin.qq.com/pay/unifiedorder";
    //https://api.mch.weixin.qq.com/pay/unifiedorder
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
            }
        }
    }
}

- (void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

//键盘消失
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)JEButton:(UIButton *)button {
    //    button.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    self.SYGButton.selected = NO;
    button.selected = YES;
    self.SYGButton = button;
    _XYLabel.text = button.titleLabel.text;
    NSString *str = button.titleLabel.text;
    NSString *string = [str substringToIndex:str.length-1];
    _moneyField.text = string;
    
    //    button.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
}



@end
