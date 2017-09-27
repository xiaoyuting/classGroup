//
//  SYGTeacherTableViewCell.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/18.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYGTeacherTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIButton *HeadImageButton;

@property (strong ,nonatomic)UILabel *NameLabel;

@property (strong ,nonatomic)UILabel *JJLabel;

@property (strong ,nonatomic)UILabel *KCLabel;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

@end
