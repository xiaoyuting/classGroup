//
//  TesttingPhoneCode.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/7.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TesttingPhoneCode : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *phoneCode;
@property (strong, nonatomic)NSString *codeStr;

@property (retain, nonatomic) NSString *phoneStr;

@end
