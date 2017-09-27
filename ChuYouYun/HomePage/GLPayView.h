//
//  GLPayView.h
//  dafengche
//
//  Created by IOS on 16/12/22.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface GLPayView : UIView
  
-(instancetype)initWithFrame:(CGRect)frame Buydic:(NSDictionary *)buydic withBuyMod:buymod withBuyAct:(NSString *)buyact withYHJdic:(NSDictionary *)YHJdic withYHJmod:(NSString *)YHJmod withYHJAct:(NSString *)YHJact withPrice:(NSString *)price;


@end
