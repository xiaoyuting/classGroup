//
//  AllOrderViewController.h
//  dafengche
//
//  Created by 智艺创想 on 16/11/16.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllOrderViewController : UIViewController

@property (strong ,nonatomic)UIButton *HDButton;
@property (strong ,nonatomic)UIButton *seletedButton;
@property (assign ,nonatomic)CGFloat buttonW;

@property (strong ,nonatomic)NSString *typeStr;
@property (strong ,nonatomic)NSDictionary *orderDict;

@end
