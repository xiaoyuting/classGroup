//
//  MySpecialViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/3.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySpecialViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak ,nonatomic)NSMutableArray *muArrr;
@end
