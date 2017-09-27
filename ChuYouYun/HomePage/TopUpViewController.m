//
//  TopUpViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 15/9/30.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#define pKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAOJ/ZIvJnJuXqdKNqZEqbL7TBu/Z8/fKlbk0dOonEMXMaIWlrpU58NlKp9sJr3Fm/wmQb8FRMLqidrkdYIXlNfN/dvRTFZ42WmmAYgDGFk1YZ6lQw4uMezOLrdi2XbRFjTu3V/oHv0z8UjnZao6UdHoBHV3RMwBFLL7TmBDMjHI1AgMBAAECgYEApU4ivN8lPG2hVPltM3SKL29m1bD1nPiu85+0YJyoYiRAeKImW+UQwhX5kiRsdlCcfId8+NNfxCcEjTBCnRZfm3rdwsYmL6yVpalWSxRoq+AZnJe1vi61Xl01Esevb9sgsRYlaGVRQLNUMCTGj2CGsHS6ik4e57YZn2fY7KF1v+ECQQD36TEhRXRHfZ+EdY1zYXnrJO3Rpq50OOIzAAw9tntcFrbhOF5eYI5RtGQHapraYzHJEjCY7ArGORui9CIcki75AkEA6eNVw7KZbO0Jcebkh1BxvBcdInQ9D+73yQunkb+X3gW99KprUnwXNxMHgpdVDORgn2ONNoPjmSNcMNuoHI4gHQJAdT4xX/zK2yyMDkbR2KlW0WAroKTliE2GnHv/TghJGuobHzRbXOLpK7bWP7Oo/HNBDkit9wRarBhB+7TdlQmFcQJAUjXyY4NXoo3/D+ZU1atVDwQg3Yd2Hy+kMSrDj9uEiioChwmQB8JOdrFdpm2DG7D6tYvMiyj4y08+jH3pLYBXkQJADP5np2RoScgIxNc28rTjFBBWbaWsu8xA6tRa0Rr+HMeYJLKoU0k/cgJM7/M09dt/QooJ6Od+2/nD7n3Yx+ML0A=="



#import "TopUpViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AppDelegate.h"

@interface TopUpViewController ()
@property (strong ,nonatomic)UIButton *topUpButton;
@property (strong ,nonatomic)NSString *typeStr;
@end

@implementation TopUpViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"即可充值";
    
    //支付宝和在线支付
    NSArray *titleArray = @[@"支付宝",@"在线支付"];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:titleArray];
    segment.frame = CGRectMake(MainScreenWidth / 4 , 80, MainScreenWidth / 2 , 30);
    segment.selectedSegmentIndex = 0;
    [segment setTintColor:[UIColor purpleColor]];
    [segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    
    //备注
    UILabel *remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 5, 150, MainScreenWidth / 5, 30)];
    remarkLabel.text = @"备注：";
    remarkLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:remarkLabel];
    
    //提示
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 5 * 2, 150, MainScreenWidth / 5 * 2, 30)];
    hintLabel.text = @"一元等于一元";
    hintLabel.textAlignment = NSTextAlignmentLeft;
    [hintLabel setTextColor:[UIColor orangeColor]];
    [self.view addSubview:hintLabel];
    
    //需要花费的金币
    UILabel *needMoney = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth / 5, 200, MainScreenWidth / 5 * 3, 30)];
    needMoney.text = [NSString stringWithFormat:@"需要花费金币：%@",_moneyString];
    [needMoney setTextColor:[UIColor purpleColor]];
    [self.view addSubview:needMoney];
    
    //立即充值
    _topUpButton.tag = 0;
    _topUpButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _topUpButton.frame = CGRectMake(50, 260, MainScreenWidth - 100, 40);
    [_topUpButton setTitle:@"立即充值" forState:UIControlStateNormal];
    _topUpButton.layer.cornerRadius = 5;
    _topUpButton.backgroundColor = [UIColor greenColor];
    _topUpButton.layer.borderWidth = 1;
    [_topUpButton addTarget:self action:@selector(topUpButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_topUpButton];
    
    _typeStr = @"支付宝支付";
    
}


- (void)change:(UISegmentedControl *)sender {
    
    NSLog(@"11111111");
    UISegmentedControl* control = (UISegmentedControl*)sender;
    
    switch (control.selectedSegmentIndex) {
        case 0:
            //支付宝
            
            _typeStr = @"支付宝支付";
            _topUpButton.tag = 0;
            break;
        case 1:
            //在线支付
            
            _typeStr = @"微信支付";
            _topUpButton.tag = 1;
            
            break;
        default:
            break;
    }
}

- (void)topUpButtonClik {
    
}



- (void)topUpButtonPressed:(UIButton *)sender
{
    //这里进行充值
    
    switch (sender.tag) {
            
        case 0:
            
            [self alipayPay];

            break;
            
        case 1:
            [self wxpay];
            break;
            
        default:
            
            break;
            
    }
}

//支付宝
- (void)alipayPay
{
    
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
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = @"10000100";
    request.prepayId= @"1101000000140415649af9fc314aa427";
    request.package = @"Sign=WXPay";
    request.nonceStr= @"a462b76e7436e98e0ed6e13c64b4fd1c";
    request.timeStamp= @"1397527777";
    request.sign= @"582282D72DD2B03AD892830965F428CB16E7A256";
    [WXApi sendReq:request];
}
#pragma mark - 微信回调
- (void)onResp:(BaseResp *)resp{
    //支付回调
    if ([resp isKindOfClass:[PayResp class]]){
        NSInteger message;
        PayResp*response=(PayResp*)resp;
        NSLog(@"微信回调  %@",response.returnKey);
        switch(response.errCode){
            case WXSuccess:{
                message = 1;//支付成功
            }
                break;
            case WXErrCodeUserCancel:{
                message = 2;//取消支付
            }
                break;
            default:{//支付失败
                message = 3;
            }
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXPay" object:self userInfo:@{@"message":@(message)}];
    }
}


- (void)buttonPressed:(UIButton *)button
{
    
}

- (void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
