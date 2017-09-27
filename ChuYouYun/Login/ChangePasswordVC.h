//
//  ChangePasswordVC.h
//  ChuYouYun
//
//  Created by Johnbenjamin on 15/5/22.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UITextField *surePasswordTxt;

@property (retain, nonatomic) NSString *phoneStr;
@property (retain, nonatomic) NSString *codeStr;

@end
