//
//  ZXFLTableViewCell.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/24.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXFLTableViewCell : UITableViewCell

@property (strong ,nonatomic)UIButton *imageButton;

@property (strong ,nonatomic)UILabel *NameLabel;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

@end
