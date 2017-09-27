//
//  ReplyQuizCommandVC.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/3/4.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "ReplyQuizCommandVC.h"
#import "ZhiyiHTTPRequest.h"
#import "Passport.h"
#import "UIButton+WebCache.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "QuizDtailCell.h"
#import "emotionjiexi.h"
#import "EJTableViewCell.h"

@interface ReplyQuizCommandVC ()
{
    CGRect rect;
    UIActivityIndicatorView* activityIndicatorView ;
    UIView *bview;
    UITextField *textf;
    UIButton *btn;
}
@end

@implementation ReplyQuizCommandVC
-(id)initWithReplyDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.reDic = dic;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.muArr= [[NSMutableArray alloc]initWithCapacity:0];
    [self reloadCommandDetail];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    self.navigationController.navigationBar.hidden = NO;
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


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 12, 22)];
    [backButton setImage:[UIImage imageNamed:@"iconfont-FH"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"二级评论";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNav];
    self.navigationItem.title = @"二级评论";
    // Do any additional setup after loading the view from its nib.
    rect = [UIScreen mainScreen].applicationFrame;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardDidShowNotification object:nil];
    bview = [[UIView alloc]initWithFrame:CGRectMake(0, rect.size.height-28, rect.size.width, 48)];
    bview.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    textf= [[UITextField alloc]initWithFrame:CGRectMake(8, 9, rect.size.width-79, 30)];
    textf.delegate = self;
    textf.borderStyle= UITextBorderStyleRoundedRect;
    [bview addSubview:textf];
    
    btn = [UIButton buttonWithType:0];
    btn.frame = CGRectMake(rect.size.width-63, 6, 55, 35);
    [btn setTitle:@"发送" forState:0];
    [btn addTarget:self action:@selector(sendCommand) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1];
    [bview addSubview:btn];
    [self.view addSubview:bview];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.userQuiz.text = [self.reDic objectForKey:@"description"];
    self.userQuiz.attributedText = [emotionjiexi jiexienmojconent:self.reDic[@"description"] font:[UIFont systemFontOfSize:17]];
    self.QuizDate.text = [Passport formatterDate:[self.reDic objectForKey:@"ctime"]];
    NSDictionary *userinfo = [NSDictionary dictionaryWithDictionary:[self.reDic objectForKey:@"userinfo"]];
    self.userName.text = [userinfo objectForKey:@"uname"];
    self.userFace.clipsToBounds = YES;
    self.userFace.layer.cornerRadius = 20.0;
    [self.userFace sd_setBackgroundImageWithURL:[NSURL URLWithString:[userinfo objectForKey:@"avatar_small"]] forState:0 placeholderImage:nil];
    [self addTopView];
    
    
}

- (void)addTopView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 90)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    NSDictionary *userinfo = [NSDictionary dictionaryWithDictionary:[self.reDic objectForKey:@"userinfo"]];
    //添加头像
    UIButton *HeadImageButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    [HeadImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[userinfo objectForKey:@"avatar_small"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"站位图"]];
    HeadImageButton.layer.cornerRadius = 30;
    HeadImageButton.layer.masksToBounds = YES;
    [topView addSubview:HeadImageButton];
    
    //添加名字
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 200, 20)];
    nameLabel.text = [userinfo objectForKey:@"uname"];
//    nameLabel.textColor = [UIColor lightGrayColor];
    [topView addSubview:nameLabel];
    
    //添加日期
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 120, 10, 110, 20)];
    timeLabel.text = [Passport formatterDate:[self.reDic objectForKey:@"ctime"]];
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.font = [UIFont systemFontOfSize:16];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [topView addSubview:timeLabel];
    
    //添加内容
    UILabel *NRLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, MainScreenWidth - 80, 40)];
    NRLabel.text = [self.reDic objectForKey:@"description"];
    [topView addSubview:NRLabel];
    
    
    
}

-(void)reloadCommandDetail
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[self.reDic objectForKey:@"parent_id"] forKey:@"id"];
    [manager reloadQuizComandDetailOfCommand:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.muArr = [[NSMutableArray alloc]initWithArray:[responseObject objectForKey:@"data"]];
        [self.tableView reloadData];
        [activityIndicatorView stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)sendReplyQuiz
{
    activityIndicatorView = [ [ UIActivityIndicatorView  alloc ]initWithFrame:CGRectMake((rect.size.width-30)/2,(rect.size.height-37)/2,37,37)];
    activityIndicatorView.backgroundColor = [UIColor blackColor];
    activityIndicatorView.alpha = 0.7;
    activityIndicatorView.clipsToBounds = YES;
    activityIndicatorView.layer.cornerRadius = 4;
    activityIndicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicatorView.hidesWhenStopped = YES;
    [self.view addSubview:activityIndicatorView ];
    [activityIndicatorView startAnimating];
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:textf.text forKey:@"txt"];
    [dic setObject:[self.reDic objectForKey:@"wid"] forKey:@"wid"];
    [dic setObject:[self.reDic objectForKey:@"parent_id"] forKey:@"id"];
    [manager sendOfQuizComandDetailCommand:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        if (![msg isEqual:@"ok"]) {
            [activityIndicatorView stopAnimating];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }else
        {
            [self reloadCommandDetail];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.muArr.count ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 100;
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height + 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSDictionary *dic =[self.muArr objectAtIndex:indexPath.row ];

    NSDictionary *userinfo = [NSDictionary dictionary];
    userinfo = self.muArr[indexPath.row][@"userinfo"];
//    //解析表情
//    cell.body.attributedText = [emotionjiexi jiexienmojconent:[dic objectForKey:@"description"] font:[UIFont systemFontOfSize:16]];
//    
//    NSLog(@"%@",self.muArr);
//    
//    //出去HTML标签
//    NSString *HH = [NSString stringWithFormat:@"%@",[dic objectForKey:@"description"]];
//    NSString *CC = [self filterHTML:HH];
//    cell.body.attributedText = [emotionjiexi jiexienmojconent:CC font:[UIFont systemFontOfSize:16]];
//
    
    
    static NSString * cellStr = @"WDTableViewCell";
    EJTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (cell == nil) {
        cell = [[EJTableViewCell alloc] initWithReuseIdentifier:cellStr];
    }

    cell.timeLabel.text = [dic objectForKey:@"ctime"];
    
     if ([dic[@"userinfo"] isEqual:[NSNumber numberWithBool:NO]]) {
         cell.nameLabel.text = self.muArr[0][@"userinfo"][@"uname"];
         [cell.HeadImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.muArr[0][@"userinfo"][@"avatar_small"]]] forState:0 placeholderImage:[UIImage imageNamed:@"站位图"]];
        
     } else {
          [cell.HeadImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"avatar_small"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"站位图"]];
         cell.nameLabel.text = [userinfo objectForKey:@"uname"];
     }
    
    cell.HeadImageButton.layer.cornerRadius = 20;
    cell.HeadImageButton.layer.masksToBounds = YES;

    
    //解析表情
//    cell.JTLabel.attributedText = [emotionjiexi jiexienmojconent:[dic objectForKey:@"description"] font:[UIFont systemFontOfSize:16]];

//    NSLog(@"%@",self.muArr);

    //出去HTML标签
    NSString *HH = [NSString stringWithFormat:@"%@",[dic objectForKey:@"description"]];
    NSString *CC = [self filterHTML:HH];
//    cell.JTLabel.attributedText = [emotionjiexi jiexienmojconent:CC font:[UIFont systemFontOfSize:16]];
    [cell setIntroductionText:CC];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)keyboardWillChangeFrame:(NSNotification *)notif
{
    NSLog(@"no   %@",notif);
    CGRect re = [[notif.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    NSLog(@"re   %f",re.origin.y);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    bview.frame = CGRectMake(0.0f, rect.size.height-re.size.height-28, rect.size.width, rect.size.height);
    
    [UIView commitAnimations];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    bview.frame = CGRectMake(0.0f, rect.size.height-38, rect.size.width, 48);
    [UIView commitAnimations];
    
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 185 - (rect.size.height - 216.0);
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
    {
        bview.frame = CGRectMake(0, bview.frame.origin.y-offset+28, rect.size.width, 48);
    }else
    {
        bview.frame = CGRectMake(0, bview.frame.origin.y+offset-20, rect.size.width, 48);
    }
    [UIView commitAnimations];
}
- (void)sendCommand
{
    if ([textf.text isEqualToString:@""])
    {
        return;
    }
    [self sendReplyQuiz];
    
    
    
    textf.text=@"";
    
    if (self.muArr.count>1)
    {
        NSIndexPath * indexPath =[NSIndexPath indexPathForRow:1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    bview.frame = CGRectMake(0.0f, rect.size.height-28, rect.size.width, rect.size.height+20);
    [UIView commitAnimations];
    
    [textf resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//去掉HTML字符
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    // NSString * regEx = @"<([^>]*)>";
    // html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}


@end
