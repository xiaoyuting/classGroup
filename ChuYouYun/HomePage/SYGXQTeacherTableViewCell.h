//
//  SYGXQTeacherTableViewCell.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/1.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYGXQTeacherTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIButton *HeadImage;

@property (strong ,nonatomic)UILabel *NameLabel;

@property (strong ,nonatomic)UILabel *JTLabel;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

//给用户介绍赋值并且实现自动换行
-(void)setIntroductionText:(NSString*)text;

@end
