//
//  teacherDetailTabelViewCellTableViewCell.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/24.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "startView.h"
@interface teacherDetailTabelViewCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgUrl;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *introduceLab;
@property (weak, nonatomic) IBOutlet UILabel *watchLab;
@property (weak, nonatomic) IBOutlet UILabel *studyB;
@property (weak, nonatomic) IBOutlet startView *star;

@end
