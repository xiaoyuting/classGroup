//
//  classViewController.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/21.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tolerateClassVC.h"
#import "salesClassVC.h"
#import "commentClassVC.h"
#import "allClassVC.h"
#import "rootViewController.h"
typedef NS_ENUM(NSInteger, item) {
    Left_Item = 0,
    Right_Item
};

@interface classViewController : UIViewController
{
    rootViewController * ntvc;
}

//创建UIButton
-(UIButton *)button:(NSString *)title image:(NSString *)image frame:(CGRect)frame;
//创建导航按钮
-(void)addItem:(NSString *)title position:(item)position image:(NSString *)image action:(SEL)action;
@property(nonatomic,retain)tolerateClassVC * tvc;
@property(nonatomic,retain)salesClassVC * svc;
@property(nonatomic,retain)commentClassVC * cvc;
@property(nonatomic,retain)allClassVC * avc;
@property(nonatomic,retain)NSMutableArray * dataArray;
@property(nonatomic,retain)NSString * cateory;
- (id)initWithMemberId:(NSString *)MemberId;

@property (strong ,nonatomic)NSString *formStr;

@end
