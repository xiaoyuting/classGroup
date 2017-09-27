//
//  GLDiscountModel.h
//  dafengche
//
//  Created by IOS on 16/9/30.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface GLDiscountModel : NSObject

/** 价格 */
@property (nonatomic,strong ) NSString        *MoneyStr;
/** 文件的附属图片 */
@property (nonatomic,strong ) UIImage         *fileimage;

/** 临时文件路径 */
@property (nonatomic,strong) NSString      *firstStr;
@property (nonatomic,strong) NSString      *secondStr;
@property (nonatomic,strong) NSString      *thirdStr;


@end
