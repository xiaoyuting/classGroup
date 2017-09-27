//
//  OrderDetailViewController.h
//  dafengche
//
//  Created by 智艺创想 on 16/12/5.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailViewController : UIViewController

@property (strong ,nonatomic)NSDictionary *orderDict;
@property (strong ,nonatomic)NSString *isInstOrOrder;
    
@property (strong ,nonatomic)NSString *isNoRefund;

@end
