//
//  GWCViewController.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/16.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GWCViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *affirmBtn;
@property (strong, nonatomic) UILabel *sum;
@property (strong, nonatomic) UILabel *surplus;
@property (strong, nonatomic) UIButton *enterBtn;
@property (strong, nonatomic)NSMutableDictionary *addDic;
@property (strong, nonatomic)NSMutableArray *muArr;
@property (strong, nonatomic)NSMutableArray *editArr;
@property (strong, nonatomic)NSMutableDictionary *muDic;

@property (strong ,nonatomic)NSMutableArray  *shopArray;
@property (strong ,nonatomic)NSMutableDictionary *allDic;

@end
