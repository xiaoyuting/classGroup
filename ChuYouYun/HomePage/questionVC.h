//
//  questionVC.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/13.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface questionVC : UIViewController
@property(nonatomic,retain)NSString * course_id;
@property(nonatomic,retain)NSMutableArray * dataArray;
@property(nonatomic,retain)NSMutableArray * dataArray2;
- (id)initWithId:(NSString *)Id;
@end
