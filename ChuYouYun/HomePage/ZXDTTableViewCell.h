//
//  ZXDTTableViewCell.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/24.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXDTTableViewCell : UITableViewCell

@property (strong ,nonatomic)UILabel *titleLabel;

@property (strong ,nonatomic)UILabel *timeLabel;

@property (strong ,nonatomic)UILabel *readLabel;

@property (strong ,nonatomic)UILabel *ZYLabel;

@property (strong ,nonatomic)UILabel *GDLabel;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

//给用户介绍赋值并且实现自动换行
-(void)setIntroductionText:(NSString*)text;

-(void)setZWText:(NSString*)text;

@end
