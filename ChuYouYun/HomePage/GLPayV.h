//
//  GLPayV.h
//  dafengche
//
//  Created by IOS on 16/12/23.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLPayV : UIView

-(instancetype)initWithFrame:(CGRect)frame ALiPayUrl:(NSString *)aliPay  WXPayUrl:(NSString *)WXPay withPrice:(NSString *)price;


@end
