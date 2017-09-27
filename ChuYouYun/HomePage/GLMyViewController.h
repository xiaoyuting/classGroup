//
//  GLMyViewController.h
//  dafengche
//
//  Created by IOS on 16/11/9.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTableViewController.h"
#import "MyCrouseTableViewController.h"

@interface GLMyViewController : UIViewController<UITableViewDataSource,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *tView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIButton *specialBtn;
@property (strong, nonatomic) UIButton *CrouseBtn;
@property (strong, nonatomic) UIView *line;
@property (strong, nonatomic)MyCrouseTableViewController *mySpecial;
@property (strong, nonatomic)MyTableViewController  *myCrouse;
@property (strong ,nonatomic)UIView *bView;
@property (strong ,nonatomic)NSDictionary *allInformation;
@property (strong ,nonatomic)UILabel *userName;
@property (strong ,nonatomic)UIView *bgIView;
@end
