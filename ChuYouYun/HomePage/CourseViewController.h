//
//  CourseViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/29.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *mySpecial;
@property (weak, nonatomic) IBOutlet UIButton *myCourse;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *tView;

@end


