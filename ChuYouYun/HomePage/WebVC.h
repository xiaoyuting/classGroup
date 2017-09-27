//
//  WebVC.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/4/20.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebVC : UIViewController
@property(assign , nonatomic)NSString *urlString;
-(id)initWithURL:(NSString *)urlStr;
@end
