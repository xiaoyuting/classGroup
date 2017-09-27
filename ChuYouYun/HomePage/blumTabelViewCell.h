//
//  blumTabelViewCell.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/12.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "startView.h"
@interface blumTabelViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *stubyB;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *inroLab;
@property (weak, nonatomic) IBOutlet UILabel *watchLab;
@property (weak, nonatomic) IBOutlet UILabel *video_countLab;
@property (weak, nonatomic) IBOutlet startView *star;


@end
