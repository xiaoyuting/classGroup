//
//  SYGPFTableViewCell.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/1.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYGPFTableViewCell : UITableViewCell

@property (strong ,nonatomic)UILabel *PFLabel;

@property (strong ,nonatomic)UIButton *PFButton;

@property (strong ,nonatomic)UILabel *XXRSLabel;

@property (strong ,nonatomic)UILabel *Number;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

@end
