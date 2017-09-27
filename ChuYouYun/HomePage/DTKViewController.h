//
//  DTKViewController.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/13.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

//创建代理
@protocol DTKViewControllerDelegate <NSObject>

@optional

//代理方法
- (void)getAllYouWantType:(NSString *)string WithNumber:(NSInteger)number;

@end

@interface DTKViewController : UIViewController

@property (strong ,nonatomic)id<DTKViewControllerDelegate> delegate;//让自己成为自己的代理

@property (strong ,nonatomic)NSDictionary *dataSource;

@property (strong ,nonatomic)NSArray *singleArray;//单选题数据

@property (strong ,nonatomic)NSArray *multipleArray;//多选题数据

@property (strong ,nonatomic)NSArray *gapArray;//填空题数据

@property (strong ,nonatomic)NSArray *judgeArray;//判断题的数据

@property (strong ,nonatomic)NSMutableArray *DXAnswerArray;//存放单选答案的数组

@property (strong ,nonatomic)NSMutableArray *DDXAnswerArray;//存放多选答案的数组

@property (strong ,nonatomic)NSMutableArray *TKAnswerArray;//存放填空答案的数组

@property (strong ,nonatomic)NSMutableArray *PDAnswerArray;//存放判断答案的数组

@property (assign ,nonatomic)NSInteger timePassing;//记录考试用的时间

@end
