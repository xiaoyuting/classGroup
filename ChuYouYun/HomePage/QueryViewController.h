//
//  QueryViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/28.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueryViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *actionTime;
@property (weak, nonatomic) IBOutlet UITextField *upTo;
@property (strong, nonatomic)NSString *dateStr;
@end
