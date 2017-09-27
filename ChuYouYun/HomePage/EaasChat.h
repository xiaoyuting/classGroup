//
//  EaasChat.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/4/15.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EaasChat : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *photo;
@property (weak, nonatomic) IBOutlet UITextField *speakText;
@property (weak, nonatomic) IBOutlet UIButton *send;
@property (strong, nonatomic)NSMutableArray *textArray;
@property (strong, nonatomic)NSMutableArray *fromArr;
@property (strong, nonatomic)NSMutableArray *dateArr;
@property (strong, nonatomic)UIImageView *myHead;
@property (strong, nonatomic)NSMutableArray *dateType;
@property (strong, nonatomic)UIImageView *touserImage;
@property (assign, nonatomic)NSString *list_is;
@property (assign, nonatomic)NSString *toUid;
@property (strong, nonatomic)NSString *uface;
@property (strong, nonatomic)NSString *sendTo;
@property (strong, nonatomic)UIImage *userFace;
@end
