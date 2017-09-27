//
//  videoPlayVC.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/4.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
typedef NS_ENUM(NSInteger, itemssd) {
    Left_Itemssd = 0,
    Right_Itemssd
};

@interface videoPlayVC : UIViewController
@property(nonatomic,strong)MPMoviePlayerController * moviePlayer;
@property(nonatomic,retain)NSString * playVideoTitle;
@property(nonatomic,retain)NSString * nid;
@property(nonatomic,retain)NSString * playVideoAddress;
@property(nonatomic,retain)NSString * collectStr;
//创建UIButton
-(UIButton *)button:(NSString *)title image:(NSString *)image frame:(CGRect)frame;
//创建label方法
-(UILabel *)label:(NSString *)title frame:(CGRect)frame;
//创建导航按钮
-(void)addItem:(NSString *)title position:(itemssd)position image:(NSString *)image action:(SEL)action;
-(void)additems:(NSString *)title position:(itemssd)position image:(NSString *)image action:(SEL)action;
//添加自定义导航标题视图
-(void)addTitleView:(NSString *)title;
- (id)initWithMemberId:(NSString *)MemberId;
@end
