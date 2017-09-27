//
//  HonourCell.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/3/2.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HonourCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UIButton *userFace;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userText;
@property (weak, nonatomic) IBOutlet UILabel *quizNumber;

@end
