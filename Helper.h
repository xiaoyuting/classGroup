//
//  Helper.h
//  FavoriteFree
//
//  Created by leisure on 14-4-22.
//  Copyright (c) 2014年 leisure. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Helper : NSObject

+(NSInteger)screenHeight;
+(NSInteger)screenWidth;
+(UIImage*)imageNamed:(NSString*)name cache:(BOOL)isCache;
+(NSString*)stringNowToDate:(NSDate*)toDate;
+(NSString*)stringNowToDate:(NSString*)toDate formater:(NSString*)formater;

//创建标签
+(UILabel *)label:(NSString*)title frame:(CGRect)frame;
//创建图片视图
+(UIImageView*)imageView:(CGRect)frame tag:(NSInteger)tag name:(NSString*)name;
@end






