//
//  classDetailMessageVC.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/30.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface classDetailMessageVC : UIViewController
@property(nonatomic,retain)NSMutableArray * dataArray;
@property(nonatomic,retain)NSMutableDictionary * dict;
@property(nonatomic,retain)NSString * course_id;
@property(nonatomic,retain)NSString * studyB;
@property(nonatomic,retain)NSString * course_title;
@property(nonatomic,retain)NSMutableDictionary * DIC;
- (id)initWithId:(NSString *)Id andStudyB:(NSString *)studyb andTitle:(NSString *)title;
@end
