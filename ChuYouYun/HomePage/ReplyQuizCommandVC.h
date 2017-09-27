//
//  ReplyQuizCommandVC.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/3/4.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplyQuizCommandVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UIButton *userFace;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userQuiz;
@property (weak, nonatomic) IBOutlet UILabel *QuizDate;
@property (strong, nonatomic)NSDictionary *reDic;
@property (strong, nonatomic)NSMutableArray *muArr;

-(id)initWithReplyDic:(NSDictionary *)dic;
@end
