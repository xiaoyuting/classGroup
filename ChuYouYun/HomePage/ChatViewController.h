//
//  ChatViewController.h
//  ChuYouYun
//
//  Created by IOS on 16/8/8.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController


@property (strong ,nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *msgArr;
@property (strong, nonatomic)NSMutableArray *dataArr;
@property (strong, nonatomic)NSMutableArray *to_user_infoArr;
@property (strong ,nonatomic)NSMutableArray *magArr;

@end
