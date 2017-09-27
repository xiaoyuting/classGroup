//
//  DTViewController.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/6.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTViewController : UIViewController

@property (strong ,nonatomic)NSDictionary *dataSource;

@property (assign ,nonatomic)NSInteger allTime;

@property (strong ,nonatomic)NSString *formWhere;//从测评报告界面传过来的值

@property (strong ,nonatomic)NSString *formType;//从测评报告传值过来 的是什么类型的题型

@property (assign ,nonatomic)NSInteger formCPNumber;//从测试报告传过来 是第几题


@end
