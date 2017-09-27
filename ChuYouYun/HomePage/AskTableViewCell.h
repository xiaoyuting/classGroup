//
//  AskTableViewCell.h
//  ChuYouYun
//
//  Created by IOS on 16/5/30.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString* const indentifier = @"AskTableViewCell";

@interface AskTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *aconImage;

@property (strong, nonatomic) UILabel     *nameLab;

@property (strong, nonatomic) UILabel     *timeLab;

@property (strong, nonatomic) UILabel     *textLab;

@property (strong, nonatomic) UIButton    *speakBtn;

@property (strong, nonatomic) UIButton    *lookBtn;


@end
