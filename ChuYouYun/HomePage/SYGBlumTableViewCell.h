//
//  SYGBlumTableViewCell.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/1/22.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYGBlumTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIButton *imageButton;

@property (strong ,nonatomic)UIButton *playButton;

@property (strong ,nonatomic)UILabel *titleLabel;

@property (strong ,nonatomic)UIButton *XJButton;

@property (strong ,nonatomic)UILabel *contentLabel;

//@property (strong ,nonatomic)UIButton *GKButton;

@property (strong ,nonatomic)UILabel *XBLabel;

@property (strong ,nonatomic)UIButton *KSButton;

@property (strong ,nonatomic)UILabel *KSLabel;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)setVlaues:(NSDictionary *)dict;
@end
