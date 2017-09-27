//
//  GLMemberTableViewCell.h
//  dafengche
//
//  Created by IOS on 16/10/11.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLMemberBtnClickBlock)(void);

@interface GLMemberTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *aconImageV;
@property (weak, nonatomic) IBOutlet UILabel *firstLab;
@property (weak, nonatomic) IBOutlet UILabel *secondLab;
@property (weak, nonatomic) IBOutlet UILabel *thirdLab;
@property (weak, nonatomic) IBOutlet UILabel *lastLab;
@property (weak, nonatomic) IBOutlet UIButton *userBtn;
@property (weak, nonatomic) IBOutlet UILabel *backLab;

/** 使用优惠券按钮点击回调block */
@property (nonatomic, copy  ) GLMemberBtnClickBlock  btnClickBlock;

@end
