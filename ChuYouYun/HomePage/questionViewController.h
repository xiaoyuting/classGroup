//
//  questionViewController.h
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/21.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface questionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *NBtn;
@property (weak, nonatomic) IBOutlet UIButton *fieryBtn;
@property (weak, nonatomic) IBOutlet UIButton *wattingBtn;
@property (weak, nonatomic) IBOutlet UIView *clickview;
@property (weak, nonatomic) IBOutlet UIView *questionView;
@property (weak, nonatomic) IBOutlet UIView *navView;

@property (weak, nonatomic) IBOutlet UIView *btnView;


@property (weak, nonatomic) NSString *wdType;
@property (weak,nonatomic)  NSString * name;
-(id)initWithQuiztype:(NSString *)wdtype WithName:(NSString *)nameTitle;
//-(id)initWithQuiztype:(NSString *)wdtype title:(NSString *)titleLab;

@end
