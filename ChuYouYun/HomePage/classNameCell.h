//
//  classNameCell.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/31.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "startView.h"
@interface classNameCell : UITableViewCell
@property (weak, nonatomic) IBOutlet startView *star;
@property (weak, nonatomic) IBOutlet UILabel *studyCount;
@property (weak, nonatomic) IBOutlet UILabel *firstTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *secondTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *studyB;

@end
