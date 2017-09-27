//
//  blumCommentVC.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/13.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface blumCommentVC : UIViewController
@property(nonatomic,retain)NSString * blum_id;
@property(nonatomic,retain)NSMutableArray * dataArray;
- (id)initWithId:(NSString *)Id;
@end
