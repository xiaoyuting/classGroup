//
//  JYJLTableViewCell.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/14.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYJLTableViewCell : UITableViewCell

@property (strong ,nonatomic)UILabel *typeLabel;

@property (strong ,nonatomic)UILabel *timeLabel;

@property (strong ,nonatomic)UILabel *nameLabel;

@property (strong ,nonatomic)UILabel *moneyLabel;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

@end
