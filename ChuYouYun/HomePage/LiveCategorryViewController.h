//
//  LiveCategorryViewController.h
//  ChuYouYun
//
//  Created by IOS on 16/11/16.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveCategorryViewController : UIViewController

@property(nonatomic,retain)NSMutableArray * dataArray2;
//创建UIButton
-(UIButton *)button:(NSString *)title image:(NSString *)image frame:(CGRect)frame;
//创建导航按钮
//-(void)addItem:(NSString *)title position:(items)position image:(NSString *)image action:(SEL)action;

-(instancetype)initwithTitle:(NSString *)title array:(NSArray *)array id:(NSString *)numstr;


@end
