//
//  FLTableViewCell.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/3/29.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLTableViewCell : UITableViewCell

@property (strong ,nonatomic)UILabel *CLabel;

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

@end
