//
//  SenUIDAndPDViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/2.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseClass.h"

@interface SenUIDAndPDViewController : UIViewController
{
    BaseClass *base;
}


@property (weak, nonatomic) IBOutlet UIView *waitView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (retain, nonatomic) NSString *codeStr;
@property (retain, nonatomic) NSString *phoneStr;

@end
