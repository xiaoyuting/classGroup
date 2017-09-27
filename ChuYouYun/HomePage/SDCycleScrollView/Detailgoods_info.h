//
//  Detailgoods_info.h
//  dafengche
//
//  Created by IOS on 16/10/26.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Detailgoods_info <NSObject>

@end

@interface Detailgoods_info : NSObject

//积分商品ID标识
@property (nonatomic, copy) NSArray *goods_id;
//积分商品ID标识
@property (nonatomic, copy) NSString *goods_info;
//积分商品名称
@property (nonatomic, copy) NSString *title;
//商品封面的URL链接
@property (nonatomic, copy) NSString *cover;
//需要消耗的积分数量
@property (nonatomic, assign) int price;
//该积分商品库存量
@property (nonatomic, assign) int stock;
//简介
@property (nonatomic, copy) NSString *info;
//运费
@property (nonatomic, assign) int fare;

//商品状态   API获取的该字段永远为 1
@property (nonatomic, assign) int status;
//商品上架时间
@property (nonatomic, copy) NSString *ctime;
//商品分类名称
@property (nonatomic, copy) NSString *goods_category;

@end
