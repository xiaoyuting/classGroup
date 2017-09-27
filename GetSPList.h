//
//  GetSPList.h
//  dafengche
//
//  Created by IOS on 16/10/26.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetSPList : NSObject
//当前用户订单ID编号
@property (nonatomic, assign) int goods_order_id;
//当前用户订单购买用户UID
@property (nonatomic, copy) NSString *uid;

//当前用户订单所属机构
@property (nonatomic, copy) NSString *sid;
//当前用户订单购买的价格
@property (nonatomic, copy) NSString *price;
//商品封面的URL链接
@property (nonatomic, copy) NSString *cover;
//该积分商品库存量
@property (nonatomic, assign) int stock;

//运费
@property (nonatomic, assign) int fare;
//简介
@property (nonatomic, copy) NSString *info;
//商品状态   API获取的该字段永远为 1
@property (nonatomic, assign) int status;
//商品上架时间
@property (nonatomic, copy) NSString *ctime;

//积分商品ID标识
@property (nonatomic, copy) NSString *goods_id;


@end
