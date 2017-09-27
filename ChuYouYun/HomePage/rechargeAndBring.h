//
//  rechargeAndBring.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/27.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rechargeAndBring : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *numberText;
@property (weak, nonatomic) IBOutlet UIButton *rAndB;
@property (assign , nonatomic)NSString *selfTitle;
@property (assign , nonatomic)NSString *btnTitle;
-(id)initWithRechargeAndBring:(BOOL)isWho;

@end
