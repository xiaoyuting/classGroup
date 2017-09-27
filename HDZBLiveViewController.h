//
//  HDZBLiveViewController.h
//  ChuYouYun
//
//  Created by IOS on 16/9/8.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDZBLiveViewController : UIViewController

@property (strong ,nonatomic)NSString *ID;
@property (strong ,nonatomic)NSString *secitonID;
@property (strong ,nonatomic)NSString *account;
@property (strong ,nonatomic)NSString *domain;


-(void)initwithTitle:(NSString *)title nickName:(NSString *)nickName watchPassword:(NSString *)watchPassword roomNumber:(NSString *)roomNumber;

@end
