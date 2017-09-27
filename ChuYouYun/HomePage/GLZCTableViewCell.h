//
//  GLZCTableViewCell.h
//  dafengche
//
//  Created by IOS on 16/10/17.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^GLButtonClickBlock)(void);

@interface GLZCTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *mainImagV;
@property (nonatomic,strong)UILabel *mainTitleLab;
@property (nonatomic,strong)UILabel *nextTitleLab;
@property (nonatomic,strong)UILabel *firstLab;
@property (nonatomic,strong)UILabel *secondTitleLab;
@property (nonatomic,strong)UILabel *LastLab;
@property (nonatomic,strong)UILabel *lineLab;
@property (nonatomic,strong)UIImageView *firstImagV;
@property (nonatomic,strong)UIImageView *secondImgV;
@property (nonatomic,strong)UIImageView *thirdImgV;
@property (nonatomic,assign)  CGRect frame;
@property (nonatomic,strong)  UILabel *backLab;
@property (strong, nonatomic) UIButton *UseBtn;

/** 使用优惠券按钮点击回调block */
@property (nonatomic, copy  ) GLButtonClickBlock  buttonClickBlock;

@end
