//
//  DuiHuanSP.h
//  dafengche
//
//  Created by IOS on 16/10/26.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Detailgoods_info.h"

@interface DuiHuanSP : NSObject
//当前用户订单ID编号
@property (nonatomic, assign) int goods_order_id;
//当前用户订单购买用户UID
@property (nonatomic, copy) NSString *uid;

//当前用户订单所属机构
@property (nonatomic, copy) NSString *sid;
//当前用户订单购买的价格
@property (nonatomic, copy) NSString *price;
//当前用户订单购买时间
@property (nonatomic, copy) NSString *ctime;
//积分商品ID标识
@property (nonatomic, strong) NSArray<Detailgoods_info> *goods_id;


@end
