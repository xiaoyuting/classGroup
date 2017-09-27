//
//  BJXQViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/3/30.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "BJXQViewController.h"
#import "AppDelegate.h"
#import "UIButton+WebCache.h"
#import "ZhiyiHTTPRequest.h"
#import "EJTableViewCell.h"
#import "Passport.h"
#import "emotionjiexi.h"
#import "SYG.h"
#import "UIColor+HTMLColors.h"

@interface BJXQViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    UILabel *lable;
}

@property (strong ,nonatomic)UILabel *contentLabel;

@property (strong ,nonatomic)UIView *topView;

@property (strong ,nonatomic)UIView *downView;

@property (strong ,nonatomic)UITextField *PLTextField;

@property (strong ,nonatomic)UITableView *tableView;

@property (strong ,nonatomic)NSArray *dataArray;

@property (strong ,nonatomic)UIImageView *imageView;

@end

@implementation BJXQViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
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
    [self addTopView];
    [self addTableView];
    [self addDownView];
    [self reloadData];
    
}

- (void)addNav {
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
     SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"笔记评论";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTopView {
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 80)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    _topView = topView;
    
    //添加头像
    UIButton *headImageButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    [headImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_headStr] forState:UIControlStateNormal];
    headImageButton.layer.cornerRadius = 20;
    headImageButton.layer.masksToBounds = YES;
    [topView addSubview:headImageButton];
    
    //添加名字
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 60, 20)];
    nameLabel.text = _nameStr;
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:nameLabel];
    
    //添加不公开
    UILabel *openLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, MainScreenWidth - 210, 20)];
    openLabel.text = _titleStr;
    openLabel.font = [UIFont systemFontOfSize:16];
    [topView addSubview:openLabel];
    
    //添加日期
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 150, 10, 140, 20)];
    timeLabel.text = _timeStr;
    timeLabel.font = [UIFont systemFontOfSize:15];
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [topView addSubview:timeLabel];
    
    //添加内容
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 40, MainScreenWidth - 70, 40)];
    contentLabel.font = [UIFont systemFontOfSize:16];
    contentLabel.textColor = [UIColor lightGrayColor];
    [topView addSubview:contentLabel];
    _contentLabel = contentLabel;
    [self setIntroductionText:_JTStr];
    
    
}


- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.frame), MainScreenWidth, MainScreenHeight - CGRectGetMaxY(_topView.frame) - 15) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 100,MainScreenWidth, 14)];
    [_tableView addSubview:lable];
    [_tableView insertSubview:lable atIndex:0];
    lable.text = @"数据为空，刷新重试";
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor clearColor];

}

-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
//    CGRect frame;
    //文本赋值
    _contentLabel.text = text;
    //设置label的最大行数
    _contentLabel.numberOfLines = 0;

    CGRect labelSize = [self.contentLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil];
    
    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, MainScreenWidth - 60, labelSize.size.height);
    
    
    //计算出自适应的高度
   
    if (_contentLabel.bounds.size.height + 40 > 85) {
         _topView.frame = CGRectMake(0, 64, MainScreenWidth, CGRectGetMaxY(_contentLabel.frame));
    } else {
        _topView.frame = CGRectMake(0, 64, MainScreenWidth, 85);
    }
    
}


- (void)addDownView {
    
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 50, MainScreenWidth, 50)];
    _downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downView];
    
    _PLTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, MainScreenWidth - 80, 40)];
    _PLTextField.placeholder = @"写下你的评论";
    [_downView addSubview:_PLTextField];
    _PLTextField.layer.borderWidth = 1;
    _PLTextField.layer.cornerRadius = 5;
    _PLTextField.layer.borderColor = PartitionColor.CGColor;
    _PLTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    //设置显示模式为永远显示(默认不显示)
    _PLTextField.leftViewMode = UITextFieldViewModeAlways;
    
    //创建通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 70, 5, 60, 40)];
    sendButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    sendButton.layer.cornerRadius = 3;
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendButton) forControlEvents:UIControlEventTouchUpInside];
    [_downView addSubview:sendButton];
    
}

- (void)sendButton {
    [self addBJ];
}

//键盘弹上来
- (void)keyboardWillShow:(NSNotification *)not {
    NSLog(@"-----%@",not.userInfo);
    CGRect rect = [not.userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    CGFloat HFloat = rect.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        _downView.frame = CGRectMake(0, MainScreenHeight - 50 - HFloat, MainScreenWidth, 50);
    }];
    
    
}

//键盘下去
- (void)keyboardWillHide:(NSNotification *)not {
    [UIView animateWithDuration:0.25 animations:^{
        _downView.frame = CGRectMake(0, MainScreenHeight - 50, MainScreenWidth, 50);
    }];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)reloadData
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        
    } else {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [dic setObject:_ID forKey:@"pid"];
    [dic setObject:@"1" forKey:@"ntype"];
    [manager reloadNoteDetail:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {
            
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:_tableView.bounds];
            imageView.image = [UIImage imageNamed:@"我的笔记评论@2x"];
            [_tableView addSubview:imageView];
            _imageView = imageView;
            _imageView.hidden = NO;
            
        } else
        {
            _imageView.hidden = YES;
            _dataArray = responseObject[@"data"];
            
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height + 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellStr = @"WDTableViewCell";
    EJTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (cell == nil) {
        cell = [[EJTableViewCell alloc] initWithReuseIdentifier:cellStr];
    }
    
    [cell.HeadImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_dataArray[indexPath.row][@"userface"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"站位图"]];
    cell.HeadImageButton.clipsToBounds = YES;
    cell.HeadImageButton.layer.cornerRadius = 20.0;
    cell.nameLabel.text = _dataArray[indexPath.row][@"userinfo"][@"uname"];
    cell.timeLabel.text = [Passport formatterDate:_dataArray[indexPath.row][@"ctime"]];
    [cell setIntroductionText:_dataArray[indexPath.row][@"note_description"]];
    cell.JTLabel.attributedText = [emotionjiexi jiexienmojconent:_dataArray[indexPath.row][@"note_description"] font:[UIFont systemFontOfSize:15]];
    
    if (_dataArray.count==0) {
        
        lable.textColor = [UIColor colorWithHexString:@"#dedede"];
        
    }else{
        
        lable.textColor = [UIColor clearColor];
    }

    return cell;

}

//添加评论
-(void)addBJ
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:_ID forKey:@"pid"];
    [dic setObject:@"1" forKey:@"kztype"];
    [dic setObject:_ID forKey:@"kzid"];
    [dic setObject:@"1" forKey:@"is_open"];
    [dic setObject:_PLTextField.text forKey:@"content"];
    
    [manager addNote:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([msg isEqualToString:@"ok"]) {
            [MBProgressHUD showError:@"点评成功" toView:self.view];
            _PLTextField.text = @"";
             [self reloadData];
        } else {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alter show];
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alter repeats:YES];
        }
        
       
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}




@end
