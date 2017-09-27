//
//  TopUpViewController.h
//  ChuYouYun
//
//  Created by 智艺创想 on 15/9/30.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"


@interface TopUpViewController : UIViewController<WXApiDelegate>

@property (strong ,nonatomic)NSString *moneyString;
@property (strong ,nonatomic)UIButton *alipayButton;
@property (strong ,nonatomic)UIButton *onlineButton;
@end
