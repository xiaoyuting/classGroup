//
//  classClassifyVc.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/28.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, items) {
    Left_Items = 0,
    Right_Items
};

@interface classClassifyVc : UIViewController
@property(nonatomic,retain)NSMutableArray * dataArray2;
//创建UIButton
-(UIButton *)button:(NSString *)title image:(NSString *)image frame:(CGRect)frame;
//创建导航按钮
-(void)addItem:(NSString *)title position:(items)position image:(NSString *)image action:(SEL)action;

-(instancetype)initwithTitle:(NSString *)title array:(NSArray *)array id:(NSString *)numstr;

@end
