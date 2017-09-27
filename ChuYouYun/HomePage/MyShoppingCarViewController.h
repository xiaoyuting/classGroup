//
//  MyShoppingCarViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/29.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyShoppingCarViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *affirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *sum;
@property (weak, nonatomic) IBOutlet UILabel *surplus;
@property (weak, nonatomic) IBOutlet UIButton *enterBtn;
@property (strong, nonatomic)NSMutableDictionary *addDic;
@property (strong, nonatomic)NSMutableArray *muArr;
@property (strong, nonatomic)NSMutableArray *editArr;
@property (strong, nonatomic)NSMutableDictionary *muDic;

@property (strong ,nonatomic)NSMutableArray  *shopArray;
@property (strong ,nonatomic)NSMutableDictionary *allDic;

@end
