//
//  BlumClassifyVc.h
//  ChuYouYun
//
//  Created by 智艺创想 on 15/10/15.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlumClassifyVc : UIViewController

@property(nonatomic,retain)NSMutableArray * dataArray2;

@property (assign ,nonatomic)NSInteger SYGInterger;

//创建UIButton
-(UIButton *)button:(NSString *)title image:(NSString *)image frame:(CGRect)frame;




@end
