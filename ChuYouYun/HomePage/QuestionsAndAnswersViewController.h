//
//  QuestionsAndAnswersViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/30.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface QuestionsAndAnswersViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *myView;

@property (weak, nonatomic) IBOutlet UIButton *mySpecial;
@property (weak, nonatomic) IBOutlet UIButton *myCourse;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic)UIActivityIndicatorView *activity;
@end
