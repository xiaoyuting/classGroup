//
//  blumNameCell.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/23.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "startView.h"
@interface blumNameCell : UITableViewCell
@property (weak, nonatomic) IBOutlet startView *star;
@property (weak, nonatomic) IBOutlet UILabel *studyCountLab;
@property (weak, nonatomic) IBOutlet UILabel *firstTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *secondTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *truePriceLab;
@property (weak, nonatomic) IBOutlet UILabel *originPriceLab;

@end
