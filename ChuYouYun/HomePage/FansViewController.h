//
//  FansViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/3.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FansViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic)NSMutableArray *muArr;
@property(assign, nonatomic)NSInteger row;
@end
