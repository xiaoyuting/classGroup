//
//  MyCrouseTableViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/3/10.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCrouseTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *dataArr;
@property (strong ,nonatomic)NSMutableArray  *classArray;
@end
