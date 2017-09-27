//
//  CommandTableViewCell.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/31.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommandTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *head;
@property (weak, nonatomic) IBOutlet UIButton *titleImg;
@property (weak, nonatomic) IBOutlet UIButton *CommandImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *commandDate;
@property (weak, nonatomic) IBOutlet UILabel *commandLbl;

@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet UIButton *deleteComand;
@end
