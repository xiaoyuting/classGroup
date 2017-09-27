//
//  SYGWDViewController.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/3/9.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYGWDViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (strong, nonatomic) UITableView *tableView;


@property (weak, nonatomic) UIButton *userFace;
@property (weak, nonatomic) UILabel *userName;
@property (weak, nonatomic) UILabel *userQuiz;
@property (weak, nonatomic) UILabel *QuizDate;

@property (strong, nonatomic)NSString *qID;
@property (strong ,nonatomic)NSString *user_id;
-(id)initWithQuizID:(NSString *)qid;

-(id)initWithQuizID:(NSString *)qid title:(NSString *)title  description:(NSString *)description uname:(NSString *)uname userface:(NSString *)userface;

-(id)initWithQuizID:(NSString *)qid title:(NSString *)title  description:(NSString *)description uname:(NSString *)uname userface:(NSString *)userface ctime:(NSString *)ctime;

@property (strong, nonatomic)NSMutableArray *muArr;

@property (strong, nonatomic)NSMutableArray *detailArr;

@property (strong ,nonatomic)NSString *wd_title;
@property (strong ,nonatomic)NSString *wd_description;
@property (strong,nonatomic) NSString *uname;
@property (strong ,nonatomic)NSString *userface;
@property (strong ,nonatomic)NSString *ctime;
@property (strong ,nonatomic)NSString *formStr;


@end
