//
//  commentClassVC.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/26.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commentClassVC : UIViewController
@property(nonatomic,retain)NSMutableArray * dataArray;
@property (nonatomic,retain)NSString * num;
@property(nonatomic,retain)NSString * cateory_id;

- (void)refreshHeader;
- (id)initWithNumberIds:(NSString *)numberIds;

@end
