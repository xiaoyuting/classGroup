//
//  honourViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/3/2.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface honourViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(strong, nonatomic)NSMutableArray *muArr;
@property(strong, nonatomic)UITableView *tableview;
@end
