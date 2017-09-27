//
//  ZhongChouTableViewCell.h
//  dafengche
//
//  Created by IOS on 16/10/13.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^GLBtnClickBlock)(void);

@interface ZhongChouTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *backView;

@property (weak, nonatomic) IBOutlet UIImageView *mainImagV;

@property (weak, nonatomic) IBOutlet UILabel *mainTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *nextTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *firstLab;

@property (weak, nonatomic) IBOutlet UILabel *secondTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *LastLab;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
@property (weak, nonatomic) IBOutlet UIButton *btnCliked;

/** 使用优惠券按钮点击回调block */
@property (nonatomic, copy  ) GLBtnClickBlock  btnClickBlock;

@end
