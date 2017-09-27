//
//  SYGNoteViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/1/6.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#define kRGB(R,G,B)       [UIColor colorWithRed:R/255.f green:G/255.f blue:254/255.f alpha:1];
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4,4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕


#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕


#import "SYGNoteViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "PlaceholderTextView.h"
#import "MyHttpRequest.h"

@interface SYGNoteViewController ()<UITextViewDelegate>

{
    PlaceholderTextView *view1;
    PlaceholderTextView * view2;
}

@property (strong ,nonatomic)UITextField *SYGTextField;


@end

@implementation SYGNoteViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initer];
    
}

- (void)initer {
    self.view.backgroundColor = [UIColor colorWithRed:237.f / 255 green:237.f / 255 blue:237.f / 255 alpha:1];
    self.navigationItem.title = @"记笔记";
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    
    
    
    //在导航栏上面添加按钮
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 25, 50, 30)];
    [addButton setTitle:@"保存" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:addButton];

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 12, 22)];
    [backButton setImage:[UIImage imageNamed:@"iconfont-FH"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"记笔记";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];

    
    
    _SYGTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 80, MainScreenWidth, 40)];
    _SYGTextField.placeholder = @"请输入笔记标题...";
    _SYGTextField.font = [UIFont systemFontOfSize:17];
    _SYGTextField.layer.borderWidth = 0.1;
    _SYGTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
    _SYGTextField.leftViewMode = UITextFieldViewModeAlways;
    _SYGTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _SYGTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_SYGTextField];
    [_SYGTextField becomeFirstResponder];
//    [UIColor colorWithRed:170.f / 255 green:170.f / 255 blue:170.f / 255 alpha:1];
    [_SYGTextField setValue:[UIColor colorWithRed:170.f / 255 green:170.f / 255 blue:170.f / 255 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    

    
    if (iPhone5o5Co5S) {
        view2=[[PlaceholderTextView alloc] initWithFrame:CGRectMake(0, 120, MainScreenWidth, 200)];
    }
    
    else if(iPhone4SOriPhone4)
    {
        view2=[[PlaceholderTextView alloc] initWithFrame:CGRectMake(0, 120, MainScreenWidth, 130)];
    }
    
    
    else if(iPhone6)
    {
        view2=[[PlaceholderTextView alloc] initWithFrame:CGRectMake(0, 120, MainScreenWidth, 270)];
    }
    else if(iPhone6Plus)
    {
        view2=[[PlaceholderTextView alloc] initWithFrame:CGRectMake(0, 120, MainScreenWidth, 340)];
    }
    
    view2.placeholder=@"请输入笔记内容...";
    view2.font=[UIFont systemFontOfSize:17];
    [view2 setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    view2.placeholderFont=[UIFont systemFontOfSize:13];
    view2.layer.borderWidth=0.3;
    view2.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [self.view addSubview:view2];
    [view2 setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    view2.contentInset = UIEdgeInsetsMake(0, 15, 0, -10);
    
    //添加笔记
    UILabel *BJLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(view2.frame) - 60 - 120, 70, 30)];
    BJLabel.text = @"笔记公开";
    BJLabel.font = [UIFont systemFontOfSize:16];
    BJLabel.textColor = [UIColor lightGrayColor];
    [view2 addSubview:BJLabel];
    
    //添加帮助
    UILabel *BZLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, CGRectGetMaxY(view2.frame) - 60 - 120, 200, 30)];
    BZLabel.text = @"可以帮助更多同学";
    BZLabel.font = [UIFont systemFontOfSize:14];
    BZLabel.textColor = [UIColor lightGrayColor];
    [view2 addSubview:BZLabel];
    
    //添加开关
    UISwitch *KGSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(view2.frame) - 90,  CGRectGetMaxY(view2.frame) - 60 - 120, 50, 30)];
    [KGSwitch setOn:YES];
    
    [view2 addSubview:KGSwitch];

}

- (void)addPressed {
    
    
    if (_SYGTextField.text.length==0) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"请输入标题" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alter show];
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alter repeats:YES];
        return;
    }
    else if(view2.text.length==0)
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"请输入内容" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alter show];
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alter repeats:YES];
        return;
        
    }
    else{
        QKHTTPManager * manager = [QKHTTPManager manager];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:_courseID forKey:@"kzid"];
        [dic setValue:_SYGTextField.text forKey:@"title"];
        [dic setValue:view2.text forKey:@"content"];
        
        if ([_isBlumStr isEqualToString:@"SYG"]) {//说明是专辑
            [dic setValue:@"2" forKey:@"kztype"];

        }else {//课程
            [dic setValue:@"1" forKey:@"kztype"];

        }

        
        [dic setValue:@"1" forKey:@"is_open"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
        NSLog(@"----%@",dic);
        [manager AddNote:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
//            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"提交成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//            
//            [alter show];
//             [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alter repeats:YES];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"提问失败，请重试" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [alter show];
            [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alter repeats:YES];
        }];
    }

    
}

- (void)backPressed {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

//移除警告框
- (void)removeAlert:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}


@end
