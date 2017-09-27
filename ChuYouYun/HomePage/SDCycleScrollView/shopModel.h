//
//  shopModel.h
//  dafengche
//
//  Created by IOS on 16/10/12.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shopModel : NSObject

//商品发布者UID
@property (nonatomic, copy) NSString *uid;
//	积分商品名称
@property (nonatomic, copy) NSString *title;

//商品分类名称
@property (nonatomic, copy) NSString *goods_category;
//商品封面的URL链接
@property (nonatomic, copy) NSString *cover;
//需要消耗的积分数量
@property (nonatomic, copy) NSString *price;
//该积分商品库存量
@property (nonatomic, copy) NSString *stock;

//运费
@property (nonatomic, copy) NSString *fare;
//简介
@property (nonatomic, copy) NSString *info;
//商品状态   API获取的该字段永远为 1
@property (nonatomic, copy) NSString *status;
//商品上架时间
@property (nonatomic, copy) NSString *ctime;

//积分商品ID标识	
@property (nonatomic, copy) NSString *goods_id;

@end
