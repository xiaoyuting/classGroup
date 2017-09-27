//
//  tolerateClassVC.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/26.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tolerateClassVC : UIViewController
@property(nonatomic,retain)NSMutableArray * dataArray;
@property (nonatomic,retain)NSString * num;
@property(nonatomic,retain)NSString * cateory_id;

- (void)refreshHeader;
- (id)initWithId:(NSString *)Id;

@property (strong ,nonatomic)NSString *typeStr;//决定表格的位置

@end
