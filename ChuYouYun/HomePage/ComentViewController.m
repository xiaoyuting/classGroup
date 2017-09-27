//
//  ComentViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 15/9/17.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#define ViewBackColor [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1]
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4,4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕


#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕

#define iPhone6PlusBIG ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus放大版屏幕

#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

#import "ComentViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "UIColor+HTMLColors.h"

@interface ComentViewController ()
{

    UILabel *_lable;
}
@property (nonatomic ,strong)UIView *commentView;
@property (nonatomic ,strong)UILabel *commentLabel;
@property (nonatomic ,strong)UIView *allView;
@property (nonatomic ,strong)UITextView *textView;
@property (strong ,nonatomic)UIAlertView *alter;

@end

@implementation ComentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self comment];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"点评";
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [searchButton setTitle:@"发送" forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    [self.navigationItem setRightBarButtonItem:searchItem];
    [searchButton addTarget:self action:@selector(pressedButton) forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"****%@",self.dictt);
    //接收通知
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
    
}

- (void)tongzhi:(NSNotification *)not
{
    NSLog(@".....%@",not.userInfo);
}

- (void)pressedButton
{
    if (_textView.text.length > 0) {
        _alter = [[UIAlertView alloc] initWithTitle:nil message:@"点评成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [_alter show];
        NSTimer *timer;
    
        timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(doTime) userInfo:nil repeats:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"输入内容不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alter show];
    }

}

-(void)doTime

{

    //alert过1秒自动消失

    [_alter dismissWithClickedButtonIndex:0 animated:NO];

}


- (void)comment
{
    _commentView = [[UIView alloc] initWithFrame:CGRectMake(0,30, MainScreenWidth, MainScreenHeight)];
//    _commentView.backgroundColor = [UIColor redColor];
    _textView.scrollEnabled = NO;
    [self.view addSubview:_commentView];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100)];
    [_commentView addSubview:_textView];
    
    // 监听textView内容的文字改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:_textView];
    _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
    _commentLabel.text = @"请输入点评的内容";
    _commentLabel.textColor = [UIColor groupTableViewBackgroundColor];
    [_textView addSubview:_commentLabel];
    
    
}


- (void)textDidChange
{
    _commentLabel.hidden = (_textView.text.length != 0);
}

//将点评的内容实现
- (void)wirte
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
//    [dic setObject:self.qID forKey:@"wid"];
    [dic setObject:_textView.text forKey:@"content"];
    [manager reloadQuizComand:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        if (![msg isEqual:@"ok"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
