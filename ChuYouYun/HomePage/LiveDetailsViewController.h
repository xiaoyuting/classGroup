//
//  LiveDetailsViewController.h
//  ChuYouYun
//
//  Created by IOS on 16/7/29.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASIHTTPRequest;


@interface LiveDetailsViewController : UIViewController{
    
    ASIHTTPRequest *videoRequest;
    unsigned long long Recordull;
}
@property(nonatomic,retain)NSString *cid;
@property(nonatomic,retain)NSString * videoTitle;
@property(nonatomic,retain)NSString * img;
@property(nonatomic,retain)NSString * course_title;
@property(nonatomic,retain)NSString * price;
@property(nonatomic,retain)NSString * video_address;
@property(nonatomic,retain)NSMutableDictionary * dict;
@property(nonatomic,retain)NSString * collectStr;
//创建UIButton
//-(UIButton *)button:(NSString *)title image:(NSString *)image frame:(CGRect)frame;
////创建导航按钮
//-(void)addItem:(NSString *)title position:(itemss)position image:(NSString *)image action:(SEL)action;
//-(void)additems:(NSString *)title position:(itemss)position image:(NSString *)image action:(SEL)action;

- (id)initWithMemberId:(NSString *)MemberId andImage:(NSString *)imgUrl andTitle:(NSString *)title andNum:(int)num andprice:(NSString *)price;


@end
