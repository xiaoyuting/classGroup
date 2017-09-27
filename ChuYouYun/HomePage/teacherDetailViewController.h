//
//  teacherDetailViewController.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/23.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, item) {
    Left_Item = 0,
    Right_Item
};

#import "rootViewController.h"
@interface teacherDetailViewController : UIViewController
{
    rootViewController * rvc;
}
@property(nonatomic,retain)NSString * tid;
@property (nonatomic,retain)NSString * nid;//用户名
@property(nonatomic,retain)NSString * headImage;
@property(nonatomic,retain)NSString * relateCourse;
@property(nonatomic,retain)NSString * teacherIron;
@property(nonatomic,retain)NSMutableArray * dataArray1;
@property(nonatomic,retain)NSMutableArray * dataArray2;
//创建UIButton
-(UIButton *)button:(NSString *)title image:(NSString *)image frame:(CGRect)frame;
//创建导航按钮
-(void)addItem:(NSString *)title position:(item)position image:(NSString *)image action:(SEL)action;
-(void)additems:(NSString *)title position:(item)position image:(NSString *)image action:(SEL)action;

@end
