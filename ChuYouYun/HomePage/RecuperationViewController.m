//
//  RecuperationViewController.m
//  ChuYouYun
//
//  Created by IOS on 16/9/12.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "RecuperationViewController.h"
#import "AppDelegate.h"
#import "ZhiyiHTTPRequest.h"
#import "DLViewController.h"
#import "MBProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "UIColor+HTMLColors.h"
#import "SYG.h"

@interface RecuperationViewController ()<UITextViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    
    NSMutableArray *_dataArray2;
}
@property (strong ,nonatomic)UIButton *seleButton;

@property (strong ,nonatomic)UITextView *titleTextView;

@property (strong ,nonatomic)NSString *typeStr;

@property (strong ,nonatomic)UILabel *TSLabel;

@property (strong ,nonatomic)NSMutableArray *marray;

@property (strong ,nonatomic)UITextField *textFiled;;



@property (assign ,nonatomic)BOOL  isSYG;


@end

@implementation RecuperationViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    self.navigationController.navigationBar.hidden = NO;
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleTextView:) name:UITextViewTextDidChangeNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray2 = [[NSMutableArray alloc]init];
    self.marray = [[NSMutableArray alloc]init];
    [self addNav];
    [self addTextView];
    
}

- (void)addNav {
    self.view.backgroundColor = [UIColor colorWithRed:242.f / 255 green:242.f / 255 blue:242.f / 255 alpha:1];
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UILabel *linelab = [[UILabel alloc]initWithFrame:CGRectMake(0,63,MainScreenWidth,1)];
    [SYGView addSubview:linelab];
    linelab.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    linelab.alpha = 0.8;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 60, 30)];
    WZLabel.text = @"意见反馈";
    [WZLabel setTextColor:BasidColor];
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTextView {
    

    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15,80, MainScreenWidth, 30)];
    [self.view addSubview:lab];
    lab.text = @"写点建议和反馈吧";
    lab.textAlignment = NSTextAlignmentLeft;
    lab.textColor = [UIColor colorWithHexString:@"#999999"];
    _titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 110, MainScreenWidth-20, 150 )];
    [self.view addSubview:_titleTextView];
    lab.font = [UIFont systemFontOfSize:14];
    
    [_titleTextView.layer setBorderColor:[UIColor colorWithRed:201.f / 255 green:201.f / 255 blue:201.f / 255 alpha:1].CGColor];
    
    [_titleTextView.layer setBorderWidth:1];
    [_titleTextView.layer setMasksToBounds:YES];
    _titleTextView.layer.cornerRadius = 5;
    

    //添加提示文本
    _TSLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 110+(self.marray.count/5)*48,MainScreenWidth - 25, 30)];
    _TSLabel.text = @"详细描述问题（内容长度大于3个字符）";
    _TSLabel.textColor = [UIColor lightGrayColor];
    _TSLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_TSLabel];
    
    _textFiled = [[UITextField alloc]initWithFrame:CGRectMake(10, _titleTextView.current_y_h + 10, MainScreenWidth - 20, 30)];
    [self.view addSubview:_textFiled];
    
    _textFiled.placeholder = @"手机号/QQ";
    
    //UITextField左右视图
    UILabel * leftView=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10*horizontalrate, 30*horizontalrate)];
    leftView.contentMode = UIViewContentModeLeft;
    leftView.textAlignment = NSTextAlignmentLeft;
    leftView.font = [UIFont systemFontOfSize:14];
    
    //占位符字体颜色
    _textFiled.font = Font(14);
    _textFiled.leftView=leftView;
    _textFiled.leftViewMode=UITextFieldViewModeAlways;
    [_textFiled.layer setBorderColor:[UIColor colorWithHexString:@"#cdcdcd"].CGColor];
    [_textFiled.layer setBorderWidth:1];
    [_textFiled.layer setMasksToBounds:YES];
    _textFiled.backgroundColor = [UIColor whiteColor];
    
    //UITextField左右视图
    UILabel * lastlab=[[UILabel alloc]initWithFrame:CGRectMake(10, _textFiled.current_y_h,MainScreenWidth - 20, 30*horizontalrate)];
    lastlab.textAlignment = NSTextAlignmentLeft;
    lastlab.font = [UIFont systemFontOfSize:13*MainScreenWidth/375];
    lastlab.text = @"您的联系方式有助于我们沟通和解决问题，仅工作人员可见";
    lastlab.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.view addSubview:lastlab];
    
    UIButton *TJButton = [[UIButton alloc] initWithFrame:CGRectMake(10, lastlab.current_y_h + 5, MainScreenWidth - 20, 40)];
    [TJButton setTitle:@"提交" forState:UIControlStateNormal];
    [TJButton addTarget:self action:@selector(TJButton:) forControlEvents:UIControlEventTouchUpInside];
    TJButton.backgroundColor = [UIColor blueColor];
    [self.view addSubview:TJButton];
}

- (void)titleTextView:(NSNotification *)Not {
    
    if (_titleTextView.text.length > 0 ) {
        _TSLabel.hidden = YES;
    } else {
        _TSLabel.hidden = NO;
    }
    
}


- (void)TJButton:(UIButton *)sender {
    if (_titleTextView.text.length == 0 ) {
        [MBProgressHUD showError:@"请输入内容" toView:self.view];
        return;
    }
    [self requestData];
}

-(void)requestData {
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:_titleTextView.text forKey:@"content"];
    [dic setObject:_textFiled.text forKey:@"way"];
    
    [manager getpublicPort:dic mod:@"Home" act:@"feedback" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            [MBProgressHUD showSuccess:@"提交成功" toView:self.view];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
            });

        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"提交失败" toView:self.view];
    }];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [_titleTextView resignFirstResponder];
}

//键盘消失
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}



@end
