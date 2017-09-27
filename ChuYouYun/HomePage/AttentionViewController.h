//
//  AttentionViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/31.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttentionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong ,nonatomic)UITableView *tableView;

@property(assign, nonatomic)NSInteger row;
@property(strong, nonatomic)NSMutableArray *muArr;
@property (strong ,nonatomic)UIButton      *attentionType;

@property (strong ,nonatomic)NSArray *arr;
@end
