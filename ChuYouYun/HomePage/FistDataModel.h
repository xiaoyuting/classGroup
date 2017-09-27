//
//  FistDataModel.h
//  dafengche
//
//  Created by IOS on 16/10/10.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FistDataModel : NSObject

//机构、代表优惠券所属的机构
@property (nonatomic, copy) NSString *sid;
//1优惠券，2打折卡，3会员卡，4充值卡
@property (nonatomic, copy) NSString *type;

//优惠券编码
@property (nonatomic, copy) NSString *code;
//会员折扣
@property (nonatomic, copy) NSString *discount;
//课程ID
@property (nonatomic, copy) NSString *video_id;
//优惠价格
@property (nonatomic, copy) NSString *price;
//有效期	单位：天
@property (nonatomic, copy) NSString *exp_date;
//	使用状态 1:已使用 0:未使用
@property (nonatomic, copy) NSString *status;
//优惠券发放时间 时间戳
@property (nonatomic, copy) NSString *ctime;
//优惠券的标识
@property (nonatomic, copy) NSString *coupon_id;
//优惠券领取时间	 时间戳
@property (nonatomic, copy) NSString *stime;
//优惠券过期时间	 时间戳
@property (nonatomic, copy) NSString *etime;



@end
