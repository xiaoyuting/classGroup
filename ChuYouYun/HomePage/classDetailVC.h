//
//  classDetailVC.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/28.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ASIHTTPRequest;

typedef NS_ENUM(NSInteger, itemss) {
    Left_Itemss = 0,
    Right_Itemss
};

@interface classDetailVC : UIViewController {
    
    ASIHTTPRequest *videoRequest;
    unsigned long long Recordull;
}
@property(nonatomic,retain)NSString *cid;
@property(nonatomic,retain)NSString * videoTitle;
@property(nonatomic,retain)NSString * price;
@property(nonatomic,retain)NSString * img;
@property(nonatomic,retain)NSString * course_title;
@property(nonatomic,retain)NSString * video_address;
@property(nonatomic,retain)NSMutableDictionary * dict;
@property(nonatomic,retain)NSString * collectStr;
@property (strong ,nonatomic)NSDictionary *moneyDic;

@property (strong ,nonatomic)NSString *isLoad;


//大风车
@property (strong ,nonatomic)UIButton *collectButton;
@property (strong ,nonatomic)UIButton *buyButton;


//创建UIButton
-(UIButton *)button:(NSString *)title image:(NSString *)image frame:(CGRect)frame;
//创建导航按钮
-(void)addItem:(NSString *)title position:(itemss)position image:(NSString *)image action:(SEL)action;
-(void)additems:(NSString *)title position:(itemss)position image:(NSString *)image action:(SEL)action;

- (instancetype)initWithMemberId:(NSString *)MemberId andPrice:(NSString *)price andTitle:(NSString *)title;
@end
