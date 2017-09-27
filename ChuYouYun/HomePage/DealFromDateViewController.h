//
//  DealFromDateViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/12.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealFromDateViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *muArr;
@property (strong, nonatomic)NSString *now;
@property (strong, nonatomic)NSString *fromDate;
-(id)initWithQueryDateNowDate:(NSString *)nowDate fromDate:(NSString *)fDate;
@end
