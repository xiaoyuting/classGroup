//
//  RechanrgViewController.h
//  ChuYouYun
//
//  Created by 智艺创想 on 15/9/30.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechanrgViewController : UIViewController <UITextFieldDelegate>

@property (strong ,nonatomic)UIButton *alipayButton;
@property (strong ,nonatomic)UIButton *onlineButton;
@property (strong ,nonatomic)UITextField *moneyField;

@property (strong ,nonatomic)NSArray *array;

@end
