//
//  SYGDPTableViewCell.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/18.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYGDPTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIButton *HeadImageButton; //头像

@property (strong ,nonatomic)UIButton *XJButton;//星级

@property (strong ,nonatomic)UILabel *NameLabel;//名字

@property (strong ,nonatomic)UILabel *JTLabel;//具体内容

@property (strong ,nonatomic)UILabel *TimeLabel;//时间

@property (strong ,nonatomic)UIButton *DZButton;//点赞按钮

@property (strong ,nonatomic)UILabel *DZLabel;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

//给用户介绍赋值并且实现自动换行
-(void)setIntroductionText:(NSString*)text;

@end
