//
//  SMsgCell.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/5.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMsgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *body;

@property (weak, nonatomic) IBOutlet UILabel *date;

@end
