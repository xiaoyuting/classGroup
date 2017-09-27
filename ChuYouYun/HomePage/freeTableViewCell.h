//
//  freeTableViewCell.h
//  youfuwaiqin
//
//  Created by 我家有福 on 16/4/20.
//  Copyright © 2016年 wojiayoufu. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString* const indentifier = @"cellID";

@interface freeTableViewCell : UITableViewCell

@property (strong,nonatomic) UILabel *moneyLab;
@property (strong,nonatomic) UILabel *cateGaryLab;
@property (strong,nonatomic) UILabel *firstLab;
@property (strong,nonatomic) UILabel *secondLab;
@property (strong,nonatomic) UILabel *lastLab;
@property (strong,nonatomic) UIImageView *imageV;


@end
