//
//  YEViewController.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/15.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YEViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSMutableDictionary *userDic;

@end
