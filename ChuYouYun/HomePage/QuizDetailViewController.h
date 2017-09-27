//
//  QuizDetailViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/28.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizDetailViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UIButton *userFace;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userQuiz;
@property (weak, nonatomic) IBOutlet UILabel *QuizDate;


@property (strong, nonatomic)NSString *qID;
@property (strong ,nonatomic)NSString *user_id;
-(id)initWithQuizID:(NSString *)qid;
//-(id)initWithQuizID:(NSString *)qid title:(NSString *)title  description:(NSString *)description;
-(id)initWithQuizID:(NSString *)qid title:(NSString *)title  description:(NSString *)description uname:(NSString *)uname userface:(NSString *)userface;
-(id)initWithQuizID:(NSString *)qid title:(NSString *)title  description:(NSString *)description uname:(NSString *)uname userface:(NSString *)userface ctime:(NSString *)ctime;
//-(id)initWithDescription:(NSString *)description;
@property (strong, nonatomic)NSMutableArray *muArr;
@property (strong, nonatomic)NSMutableArray *detailArr;

@property (strong ,nonatomic)NSString *wd_title;
@property (strong ,nonatomic)NSString *wd_description;
@property (strong,nonatomic) NSString *uname;
@property (strong ,nonatomic)NSString *userface;
@property (strong ,nonatomic)NSString *ctime;
@end
