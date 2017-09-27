//
//  XZTTableViewCell.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/6.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZTTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIButton *XZButton;

@property (strong ,nonatomic)UILabel *contentLabel;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

-(void)setIntroductionText:(NSString*)text;

@end
