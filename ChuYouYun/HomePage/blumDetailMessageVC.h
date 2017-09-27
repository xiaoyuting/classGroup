//
//  blumDetailMessageVC.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/13.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface blumDetailMessageVC : UIViewController
@property(nonatomic,retain)NSMutableArray * dataArray;
@property(nonatomic,retain)NSMutableDictionary * dict;
@property(nonatomic,retain)NSString * blum_id;
@property(nonatomic,retain)NSString * blum_title;
- (id)initWithId:(NSString *)Id andTitle:(NSString *)title;
@end
