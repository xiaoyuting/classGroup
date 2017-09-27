//
//  classTableViewCell.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/26.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "startView.h"
@interface classTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet startView *star;
@property (weak, nonatomic) IBOutlet UILabel *studyBLab;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *inroLab;
@property (weak, nonatomic) IBOutlet UILabel *watchLab;

@end
