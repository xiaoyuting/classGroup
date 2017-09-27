//
//  ClassCharaViewController.h
//  ThinkSNS（探索版）
//
//  Created by 智艺创想 on 16/10/11.
//  Copyright © 2016年 zhishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassCharaViewController : UIViewController


@property(nonatomic,retain)NSMutableArray * dataArray;
@property(nonatomic,retain)NSString * class_id;
@property(nonatomic,retain)NSString * blum_title;
- (id)initWithId:(NSString *)Id andTitle:(NSString *)blum_title;

@end
