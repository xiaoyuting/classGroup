//
//  DDNewsCache.m
//  dafengche
//
//  Created by IOS on 17/3/3.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "DDNewsCache.h"

@implementation DDNewsCache


+ (instancetype)sharedInstance
{
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [NSMutableArray array];
    });
    return _instance;
}

@end
