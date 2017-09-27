//
//  GLZFViewController.h
//  dafengche
//
//  Created by IOS on 16/12/14.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLZFViewController : UIViewController<UITextFieldDelegate>

@property (strong ,nonatomic)UIButton *alipayButton;
@property (strong ,nonatomic)UIButton *onlineButton;
@property (strong ,nonatomic)UITextField *moneyField;

@property (strong ,nonatomic)NSArray *array;


@end
