//
//  SystemTextViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/31.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemTextViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *systemText;
@property (weak, nonatomic) IBOutlet UILabel *dateText;
@property (assign, nonatomic)NSString *systemStr;
@property (assign, nonatomic)NSString *dateStr;
-(id)initWithBody:(NSString *)body time:(NSString *)date;
@end
