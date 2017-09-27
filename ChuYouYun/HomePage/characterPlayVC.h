//
//  characterPlayVC.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/24.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, itemCha) {
    Left_ItemsCha = 0,
    Right_ItemsCha
};


@interface characterPlayVC : UIViewController
@property(nonatomic,retain)NSString * class_id;
@property(nonatomic,retain)NSString * video_title;
@property(nonatomic,retain)NSString * blumId;
@property(nonatomic,retain)NSString * blumTitle;
@property(nonatomic,retain)NSString * collectStr;
@property(nonatomic,retain)NSMutableDictionary * dict;
@property(nonatomic,assign)NSInteger ROW;
@property(nonatomic,retain)NSString * videoAddress;

@property(nonatomic,retain)NSString * videoAddress2;
@property(nonatomic,retain)NSMutableDictionary * dict2;
@property(nonatomic,retain)NSMutableArray * checkArray;
@property(nonatomic,retain)NSMutableArray * dataArray;

//创建UIButton
-(UIButton *)button:(NSString *)title image:(NSString *)image frame:(CGRect)frame;
//创建label方法
-(UILabel *)label:(NSString *)title frame:(CGRect)frame;
//创建导航按钮
-(void)addItem:(NSString *)title position:(itemCha)position image:(NSString *)image action:(SEL)action;
-(void)additems:(NSString *)title position:(itemCha)position image:(NSString *)image action:(SEL)action;
//添加自定义导航标题视图
-(void)addTitleView:(NSString *)title;
- (id)initWithMemberId:(NSString *)MemberId andTitle:(NSString *)title andROW:(NSInteger)row;

@end
