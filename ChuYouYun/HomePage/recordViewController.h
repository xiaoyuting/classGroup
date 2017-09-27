//
//  recordViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/27.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface recordViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *muArr;

@end
