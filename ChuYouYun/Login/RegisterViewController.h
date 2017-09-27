//
//  RegisterViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/23.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseClass.h"

@interface RegisterViewController : UIViewController<UITextFieldDelegate>
{
    BaseClass *base;
}


@property (weak, nonatomic) IBOutlet UIView *waitView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;


@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *UserPassword;
@property (weak, nonatomic) IBOutlet UIView *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerToPhone;
@property (weak, nonatomic) IBOutlet UIButton *reBtn;

@end
