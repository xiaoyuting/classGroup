//
//  TestForPhoneViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/2.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestForPhoneViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *testingCode;
@property (weak, nonatomic) IBOutlet UIButton *repetitiveCode;
@property (weak, nonatomic) IBOutlet UIView *waitView;
@property (weak, nonatomic) IBOutlet UILabel *waitLabel;

@property (retain, nonatomic) NSString *phoneNum;

@end
