//
//  SendMSGToChatViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/4/7.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "SendMSGToChatViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "DLViewController.h"

@interface SendMSGToChatViewController ()
{
    CGRect WDrect;
}

@property (strong ,nonatomic)UIView *SYGView;

@end

@implementation SendMSGToChatViewController
-(void)viewWillAppear:(BOOL)animated
{
    WDrect = [UIScreen mainScreen].applicationFrame;
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
-(id)initWithChatUserid:(NSString *)uId uFace:(NSString *)urlStr toUserID:(NSString *)toUserId sendToID:(NSString *)sendToID
{
    self =[super init];
    if (self) {
        self.list_is = uId;
        self.uface = urlStr;
        self.toUid = toUserId;
        self.sendTo = sendToID;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNav];
    self.navigationItem.title = @"发私信";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardDidShowNotification object:nil];
    self.textField.delegate = self;

}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    _SYGView = SYGView;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 12, 22)];
    [backButton setImage:[UIImage imageNamed:@"iconfont-FH"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"发私信";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}




- (IBAction)sendClick:(id)sender
{
    [self sendMessage];
}
-(void)keyboardWillChangeFrame:(NSNotification *)notif
{
    NSLog(@"no   %@",notif);
    CGRect re = [[notif.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    NSLog(@"re   %f",re.origin.y);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = CGRectMake(0.0f, WDrect.origin.y-re.size.height, WDrect.size.width, WDrect.size.height);
    
    [UIView commitAnimations];
    
}
-(void)sendMessage
{
    
    //应该判断是否登录
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下

        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
        
    }

    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    NSString *speak =  self.textField.text;
    [dic setObject:speak forKey:@"content"];
    [dic setObject:_sendTo forKey:@"to"];
    [manager sendToChat:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        if (![msg isEqual:@"ok"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"您刚才发送的信息内容为:%@",speak] message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"信息发送成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.delegate = self;
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 185 - (WDrect.size.height - 216.0);
    NSLog(@"-------%d",offset);
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.textField.frame=CGRectMake(0, 64, 320, 480-64-216-44);
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
    {
        self.view.frame = CGRectMake(0.0f, -offset, WDrect.size.width, WDrect.size.height);
    }else
    {
        self.view.frame = CGRectMake(0.0f, +offset, WDrect.size.width, WDrect.size.height);
        _SYGView.frame = CGRectMake(0, -offset , MainScreenWidth, 64);
    
    }
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 185 - (WDrect.size.height - 216.0);
    NSLog(@"-------%d",offset);
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.textField.frame=CGRectMake(0, 64, 320, 480-64-216-44);
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset < 0)
    {
        self.view.frame = CGRectMake(0.0f, 0, WDrect.size.width, WDrect.size.height);
        _SYGView.frame = CGRectMake(0, 0, MainScreenWidth, 64);
    }else
    {
        self.view.frame = CGRectMake(0.0f, 0, WDrect.size.width, WDrect.size.height);
        _SYGView.frame = CGRectMake(0, 0 , MainScreenWidth, 64);
        
    }
    [UIView commitAnimations];

}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
