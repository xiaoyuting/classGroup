//
//  FSXViewController.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/19.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSXViewController : UIViewController <UIAlertViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic)UIView *CView;

@property (strong, nonatomic)UIButton *send;

@property (strong, nonatomic)UITextField *textField;

@property (assign, nonatomic)NSString *list_is;

@property (assign, nonatomic)NSString *toUid;

@property (strong, nonatomic)NSString *uface;

@property (strong, nonatomic)NSString *sendTo;

-(id)initWithChatUserid:(NSString *)uId uFace:(NSString *)urlStr toUserID:(NSString *)toUserId sendToID:(NSString *)sendToID;

@end
