//
//  blumDetailList.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/23.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface blumDetailList : NSObject
@property(nonatomic,retain)NSString * star;
@property(nonatomic,retain)NSString * firstTime;
@property(nonatomic,retain)NSString * secondTime;
@property(nonatomic,retain)NSString * peopleCount;
@property(nonatomic,retain)NSArray * mzPrice;
@property(nonatomic,retain)NSString * name;
@property(nonatomic,retain)NSString * inro;
@property(nonatomic,retain)NSString * headImg;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dicts;
- (instancetype)initWithDictionarys:(NSDictionary *)dict;
- (NSDictionary *)DictionaryRepresentation;
@end
