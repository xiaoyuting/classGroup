//
//  playNoteVC.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/6.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface playNoteVC : UIViewController
@property(nonatomic,retain)NSString * course_id;

- (id)initWithId:(NSString *)Id;
@end
