//
//  UserLoginViewController.h
//  Right
//
//  Created by ZhiYiForMac on 15/1/20.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseClass.h"


#define shareQQ "UMShareToQQ"
#define shareSina @"UMShareToSina"
#define shareRenRen @"UMShareToRenren"

@interface UserLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic)BaseClass *base;

+ (NSString *)createFile:(NSString *)strPath;
@end
