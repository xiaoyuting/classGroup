//
//  SendMSGToChatViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/4/7.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendMSGToChatViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *CView;
@property (weak, nonatomic) IBOutlet UIButton *send;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (assign, nonatomic)NSString *list_is;
@property (assign, nonatomic)NSString *toUid;
@property (strong, nonatomic)NSString *uface;
@property (strong, nonatomic)NSString *sendTo;
-(id)initWithChatUserid:(NSString *)uId uFace:(NSString *)urlStr toUserID:(NSString *)toUserId sendToID:(NSString *)sendToID;
@end
