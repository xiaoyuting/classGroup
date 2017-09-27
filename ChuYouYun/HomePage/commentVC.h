//
//  commentVC.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/30.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commentVC : UIViewController
@property(nonatomic,retain)NSString * course_id;

- (id)initWithId:(NSString *)Id;

@end
