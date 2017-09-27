//
//  WDTableViewCell.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/16.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIButton *HeadImage;

@property (strong ,nonatomic)UILabel *NameLabel;

@property (strong ,nonatomic)UILabel *TimeLabel;

@property (strong ,nonatomic)UILabel *JTLabel;

@property (strong ,nonatomic)UIView *TPView;

@property (strong ,nonatomic)UILabel *PLLabel;

@property (strong ,nonatomic)UILabel *GKLabel;

@property (strong ,nonatomic)UIView *backView;

@property (strong ,nonatomic)UIButton *GKButton;

@property (strong ,nonatomic)UIButton *PLButton;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

//给用户介绍赋值并且实现自动换行
-(void)setIntroductionText:(NSString*)text;

- (void)imageWithArray:(NSArray *)array;

@end
