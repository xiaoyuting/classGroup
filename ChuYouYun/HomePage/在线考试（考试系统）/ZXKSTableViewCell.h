//
//  ZXKSTableViewCell.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/5.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXKSTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIButton *imageButton;

@property (strong ,nonatomic)UILabel *titleLabel;

@property (strong ,nonatomic)UILabel *personLabel;

@property (strong ,nonatomic)UILabel *CJLabel;

@property (strong ,nonatomic)UILabel *timeLabel;

@property (strong ,nonatomic)UILabel *dateLabel;

@property (strong ,nonatomic)UILabel *ZDLabel;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)dataWithDict:(NSDictionary *)dict;

@end
