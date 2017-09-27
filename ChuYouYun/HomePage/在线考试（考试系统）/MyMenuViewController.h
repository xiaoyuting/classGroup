//
//  MyMenuViewController.h
//  ChuYouYun
//
//  Created by 赛新科技 on 2017/4/6.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMenuViewController : UIViewController

@property (strong ,nonatomic)NSDictionary *dataSource;

@property (assign ,nonatomic)NSInteger allTime;

@property (assign ,nonatomic)NSInteger sumTime;

@property (strong ,nonatomic)NSString *formWhere;//从测评报告界面传过来的值

@property (strong ,nonatomic)NSString *formType;//从测评报告传值过来 的是什么类型的题型

@property (assign ,nonatomic)NSInteger formCPNumber;//从测试报告传过来 是第几题

@property (strong ,nonatomic)NSString *endTimeStr;

@property (strong ,nonatomic)NSString *examID;

@property (strong ,nonatomic)NSString *gradeStr;//及格的分数

@property (strong ,nonatomic)NSArray *myDXAnswerArray;

//@property (strong ,nonatomic)NSArray *DXRightAnswer;

@property (strong ,nonatomic)NSArray *myDDXAnswerArray;

@property (strong ,nonatomic)NSArray *myTKAnswerArray;

@property (strong ,nonatomic)NSArray *myPDAnswerArray;

@property (strong ,nonatomic)NSArray *myZGAnswerArray;


@property (strong ,nonatomic)NSString *examTime;//考试总时间

@property (strong ,nonatomic)NSMutableArray *imagePhotoArray;

@property (strong ,nonatomic)NSMutableArray *myZGUpImageArray;
@property (strong ,nonatomic)NSMutableArray *myZGUpImageIDArray;


@end
