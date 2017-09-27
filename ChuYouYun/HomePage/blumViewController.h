//
//  blumViewController.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/21.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rootViewController.h"
typedef NS_ENUM(NSInteger, itemblum) {
    Left_Itemb = 0,
    Right_Itemb
};

@interface blumViewController : UIViewController
{
    rootViewController * ntvc;
}
@property(nonatomic,retain)NSMutableArray * dataArray;
@property(nonatomic,retain)NSString * cateory_id;
@property(nonatomic,retain)NSString * cateory;

//机构
@property (strong ,nonatomic)NSString *institutionStr;


//创建UIButton
-(UIButton *)button:(NSString *)title image:(NSString *)image frame:(CGRect)frame;
//创建导航按钮
-(void)addItem:(NSString *)title position:(itemblum)position image:(NSString *)image action:(SEL)action;

- (id)initWithMemberId:(NSString *)MemberId;




@end
