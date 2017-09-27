//
//  RegisterToPhoneViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/2.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterToPhoneViewController : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (strong, nonatomic)NSString *phoneNumber;
-(void)requestToTestingCodepage:(BOOL)page;
@end
