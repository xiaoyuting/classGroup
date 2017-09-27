//
//  MyBankViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/28.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MyBankViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *addView;
@property (strong, nonatomic)NSString *str;
@property (strong ,nonatomic)NSDictionary *bankDic;
@end
