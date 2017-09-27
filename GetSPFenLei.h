//
//  GetSPFenLei.h
//  dafengche
//
//  Created by IOS on 16/10/26.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetSPFenLei : NSObject

//积分商品分类ID
@property (nonatomic, assign) int  goods_category_id	;
//	积分商品名称
@property (nonatomic, copy) NSString *title;

//当前分类的子分类
@property (nonatomic, copy) NSArray *childs;



@end
