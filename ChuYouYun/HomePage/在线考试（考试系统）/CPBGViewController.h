//
//  CPBGViewController.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/14.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPBGViewController : UIViewController

@property (strong ,nonatomic)NSDictionary *dataSource;

@property (strong ,nonatomic)NSMutableArray *DXAnswerArray;//存放单选答案的数组

@property (strong ,nonatomic)NSMutableArray *DDXAnswerArray;//存放多选答案的数组

@property (strong ,nonatomic)NSMutableArray *TKAnswerArray;//存放填空答案的数组

@property (strong ,nonatomic)NSMutableArray *PDAnswerArray;//存放判断答案的数组

@property (strong ,nonatomic)NSMutableArray *ZGAnserArray;//存放主观答案的数组

@property (strong ,nonatomic)NSArray *DXRightAnswer;//单选的标准答案

@property (strong ,nonatomic)NSArray *DDXRightAnswer;//多远的标准答案

@property (strong ,nonatomic)NSArray *TKRightAnswer;//填空的标准答案

@property (strong ,nonatomic)NSArray *PDRightAnswer;//判断的标准答案

@property (strong ,nonatomic)NSString *endTimeStr;

@property (assign ,nonatomic)NSInteger timePassing;

@property (strong ,nonatomic)NSString *examID;

@property (strong ,nonatomic)NSString *gradeStr;//及格的分数

@property (strong ,nonatomic)NSArray *SubjectiveArray;//主观题

@property (strong ,nonatomic)NSMutableArray *imageIDArray;//图片的id数组

@property (strong ,nonatomic)NSMutableArray *imagePhotoArray;

@property (strong ,nonatomic)NSMutableArray *ZGUpImageArray;
@property (strong ,nonatomic)NSMutableArray *ZGUpImageIDArray;

@property (assign ,nonatomic)NSInteger timeOut;

@end
