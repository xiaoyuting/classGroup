//
//  GLDiscountTableViewCell.h
//  dafengche
//
//  Created by IOS on 16/9/30.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLDiscountModel.h"

typedef void(^GLBtnClickBlock)(void);

@interface GLDiscountTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *MoneyLab;

@property (weak, nonatomic) IBOutlet UILabel *firstLab;

@property (weak, nonatomic) IBOutlet UILabel *SecondLab;

@property (weak, nonatomic) IBOutlet UILabel *ThirdLab;

@property (weak, nonatomic) IBOutlet UIButton *UseBtn;

/** 使用优惠券按钮点击回调block */
@property (nonatomic, copy  ) GLBtnClickBlock  btnClickBlock;

/** 下载信息模型 */
@property (nonatomic, strong) GLDiscountModel      *fileInfo;
@property (weak, nonatomic) IBOutlet UILabel *backLab;
@property (weak, nonatomic) IBOutlet UILabel *Money;

@end
