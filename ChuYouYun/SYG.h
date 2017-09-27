//
//  SYG.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/5.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+HTMLColors.h"
#import "UIView+Utils.h"
#import "NSDictionary+Json.h"
#import "Passport.h"
#import "MBProgressHUD+Add.h"
#import "SYGTextField.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"


#ifndef ChuYouYun_SYG_h
#define ChuYouYun_SYG_h

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define SpaceBaside 10

#define WideEachUnit MainScreenWidth / 375
#define HigtEachUnit  MainScreenHeight / 667

#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4 4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕

#define iPhone6PlusBIG ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus放大版屏幕

#define UserOathToken [[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"]
#define UserOathTokenSecret [[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"]

#define BasidUrl "http://el3.51eduline.com"


#define Image(name) [UIImage imageNamed:name]
#define BasidColor [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1]
#define PartitionColor [UIColor colorWithRed:225.f / 255 green:225.f / 255 blue:225.f / 255 alpha:1]
#define BackColor [UIColor colorWithRed:240.f / 255 green:240.f / 255 blue:240.f / 255 alpha:1]
#define XXColor [UIColor colorWithRed:153.f / 255 green:153.f / 255 blue:153.f / 255 alpha:1]
#define JHColor [UIColor colorWithRed:255.f / 255 green:127.f / 255 blue:0.f / 255 alpha:1]

//考试系统正确答案
#define FalseColor [UIColor colorWithRed:246.f / 255 green:62.f / 255 blue:51.f / 255 alpha:1]

//考试系统错误答案
#define TrueColor [UIColor colorWithRed:96.f / 255 green:181.f / 255 blue:23.f / 255 alpha:1]

//一般分类里面的字的颜色(不是纯黑的颜色)
#define BlackNotColor [UIColor colorWithRed:64.f / 255 green:64.f / 255 blue:64.f / 255 alpha:1]


#define Font(number) [UIFont systemFontOfSize:number]
#define Color(color) [UIColor color]

#define basidUrl @"http://el3.51eduline.com/index.php?"


#endif
