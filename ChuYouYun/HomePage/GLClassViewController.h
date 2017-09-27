//
//  GLClassViewController.h
//  dafengche
//
//  Created by IOS on 16/12/12.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLClassViewController : UIViewController


@property(nonatomic,retain)NSMutableArray * dataArray;
@property (nonatomic,retain)NSString * num;
@property(nonatomic,retain)NSArray * Dataarray;

@property (strong ,nonatomic)NSString *formStr;//标识字段


//机构
@property (strong ,nonatomic)NSString *institutionStr;

- (void)refreshHeader;

- (instancetype)initWithData:(NSArray *)arr title:(NSString *)title teacher_id:(NSString *)teacher_id;


@end
