//
//  alterPasswordViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/24.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface alterPasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *setPW;
@property (weak, nonatomic) IBOutlet UITextField *resetPW;

@property (retain, nonatomic) NSString *phoneStr;
@property (retain, nonatomic) NSString *codeStr;

@end
