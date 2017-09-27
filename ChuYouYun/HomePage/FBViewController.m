//
//  FBViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/3/24.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width


#import "FBViewController.h"
#import "AppDelegate.h"
#import "ZhiyiHTTPRequest.h"
#import "DLViewController.h"
#import "MBProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "UIColor+HTMLColors.h"

@interface FBViewController ()<UIScrollViewDelegate>
{

    NSMutableArray *_dataArray2;
}
@property (strong ,nonatomic)UIButton *seleButton;

@property (strong ,nonatomic)UITextView *titleTextView;
@property (strong ,nonatomic)UIView     *moveView;

@property (strong ,nonatomic)NSString *typeStr;

@property (strong ,nonatomic)UILabel *TSLabel;

@property (strong ,nonatomic)NSMutableArray *marray;

@property (assign ,nonatomic)BOOL  isSYG;

@property (strong ,nonatomic)UIScrollView *scrollView;

@end

@implementation FBViewController

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
    [self addNav];
    [self interFace];
    [self addScrollView];
    
    _dataArray2 = [[NSMutableArray alloc]init];
    self.marray = [[NSMutableArray alloc]init];
    [self getData];
    [self addButton];
    
}

- (void)addNav {
    self.view.backgroundColor = [UIColor colorWithRed:242.f / 255 green:242.f / 255 blue:242.f / 255 alpha:1];
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"描述问题";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 300, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,286)];
    [backButton setTitle:@" " forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    //设置button上字体的偏移量
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10.0 , 0.0, 0)];
    [SYGView addSubview:backButton];
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
    UIButton *TJButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 20, 50, 40)];
    [TJButton setTitle:@"发布" forState:UIControlStateNormal];
    [TJButton addTarget:self action:@selector(TJButton) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:TJButton];
    [TJButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];

}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)interFace {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardCome:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)addScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64, MainScreenWidth, MainScreenHeight - 64)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
}
-(void)getData{
    //网络请求下自己账户中得金额
    QKHTTPManager * manager = [QKHTTPManager manager];

//http://demo.51eduline.com/index.php?app=api&mod=Wenda&act=getCate

[manager getAskCategory:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //数据加载成功
    NSArray *array = [responseObject objectForKey:@"data"];
    
    NSMutableArray *marr = [[NSMutableArray alloc]init];
    
    for (NSDictionary * dics in array) {
        
        [marr addObject:[NSString stringWithFormat:@"%@",dics[@"title"]]];
        NSLog(@"-----marr==----%@",marr);
    }

    [self.marray addObjectsFromArray:marr];
    //[self.marray addObjectsFromArray:titleArray];
    [self addType];
    [self addTextView];

    
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    //NSArray *titleArray = @[@"技术问答",@"技术分享",@"活动建议"];

   // [self.marray addObjectsFromArray:titleArray];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [MBProgressHUD showError:@"数据加载失败" toView:self.view];
    [self addType];
    [self addTextView];


}];


}

- (void)addType {
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 68 - 64, 70, 30)];
    [_scrollView addSubview:lab];
    lab.text = @"分类:";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor blackColor];
    
    
    CGFloat ButtonS = 30;
    CGFloat ButtonW = (MainScreenWidth - (4 * ButtonS)) / 3;
    CGFloat ButtonH = 30;
    for (int i = 0 ; i < self.marray.count-1; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ButtonS + (ButtonS + ButtonW) * (i%3), 108+44*(i/3) - 64, ButtonW, ButtonH)];
        if (_marray.count) {
            [button setTitle:self.marray[i+1] forState:UIControlStateNormal];
        }
        [button setTitleColor:[UIColor colorWithRed:201.f / 255 green:201.f / 255 blue:201.f / 255 alpha:1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] forState:UIControlStateSelected];
        button.layer.cornerRadius = 3;
        button.layer.borderWidth = 1;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.borderColor = [UIColor colorWithRed:201.f / 255 green:201.f / 255 blue:201.f / 255 alpha:1].CGColor;
        [button addTarget:self action:@selector(titleButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [_scrollView addSubview:button];
        if (i == 0) {
            [self titleButton:button];
        }
    }
    
    
}

- (void)titleButton:(UIButton *)button {
    self.seleButton.selected = NO;
    //让之前选中（现在为没有选中的按钮）变成平常的颜色
    self.seleButton.layer.borderColor = [UIColor colorWithRed:201.f / 255 green:201.f / 255 blue:201.f / 255 alpha:1].CGColor;
    button.selected = YES;
    self.seleButton = button;
    
    if (button.selected == YES) {
        button.layer.borderColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1].CGColor;
    } else {
        button.layer.borderColor = [UIColor colorWithRed:201.f / 255 green:201.f / 255 blue:201.f / 255 alpha:1].CGColor;

    }

    _typeStr = [NSString stringWithFormat:@"%ld",button.tag + 1];
}

- (void)addTextView {
    
    UILabel *linelab = [[UILabel alloc]initWithFrame:CGRectMake(0,150+(self.marray.count/5)*48 - 64,MainScreenWidth,1)];
    [_scrollView addSubview:linelab];
    linelab.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    linelab.alpha = 0.5;
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0,160+(self.marray.count/5)*48 - 64, 70, 30)];
    [_scrollView addSubview:lab];
    lab.text = @"内容:";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor blackColor];
    _titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 200+(self.marray.count/5)*48 - 64, MainScreenWidth-20, 150 )];
    [_scrollView addSubview:_titleTextView];
    
    [_titleTextView.layer setBorderColor:[UIColor colorWithRed:201.f / 255 green:201.f / 255 blue:201.f / 255 alpha:1].CGColor];

    [_titleTextView.layer setBorderWidth:1];
    [_titleTextView.layer setMasksToBounds:YES];
    _titleTextView.layer.cornerRadius = 5;

    
    //添加提示文本
    _TSLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 200+(self.marray.count/5)*48 - 64,MainScreenWidth - 25, 30)];
    _TSLabel.text = @"详细描述问题（内容长度大于3个字符）";
    _TSLabel.textColor = [UIColor lightGrayColor];
    _TSLabel.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:_TSLabel];
    
}

- (void)titleTextView:(NSNotification *)Not {
    
    if (_titleTextView.text.length > 0 ) {
        _TSLabel.hidden = YES;
    } else {
        _TSLabel.hidden = NO;
    }
 
}


- (void)addButton {
    
//    UIButton *TJButton = [[UIButton alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(_titleTextView.frame) + 30, MainScreenWidth - 80, 40)];
//    [TJButton setTitle:@"提交" forState:UIControlStateNormal];
//    TJButton.layer.cornerRadius = 3;
//    [TJButton addTarget:self action:@selector(TJButton) forControlEvents:UIControlEventTouchUpInside];
//    TJButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
//    [self.view addSubview:TJButton];
    
    
}

- (void)TJButton {
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    
    
    if (_titleTextView.text.length == 0 ) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:@"请输入内容" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alert repeats:YES];
        return;
    }
    
    ZhiyiHTTPRequest *manager =[ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:_typeStr forKey:@"typeid"];//问答的类型
    [dic setObject:self.titleTextView.text forKey:@"content"];

    [MBProgressHUD showMessag:@"发表中。。。" toView:self.view];
    
    [manager sendQuizText:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([msg isEqual:@"ok"]) {//成功
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showSuccess:@"发表成功" toView:self.view];
            [self.navigationController popViewControllerAnimated:YES];

        }else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showSuccess:msg toView:self.view];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        [MBProgressHUD showError:@"发表失败" toView:self.view];
    }];

    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _scrollView = scrollView;
}

//键盘弹起
- (void)keyboardCome:(NSNotification *)Not {
    
    //    NSLog(@"%@",isUp);
    NSLog(@"%@",Not.userInfo);
    [_scrollView setContentOffset:CGPointMake(0,100) animated:YES];
    
}

//键盘下去
- (void)keyboardHide:(NSNotification *)Not {
    [_scrollView setContentOffset:CGPointMake(0,0) animated:YES];
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

- (void)removeAlert:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}


@end
