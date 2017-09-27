//
//  QuizDetailViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/28.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "QuizDetailViewController.h"
#import "Passport.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "ZhiyiHTTPRequest.h"
#import "UIButton+WebCache.h"
#import "QuizDtailCell.h"
#import "GDataXMLNode.h"
#import "ReplyQuizCommandVC.h"
#import "DLViewController.h"
#import "emotionjiexi.h"
#import "UIColor+HTMLColors.h"

@interface QuizDetailViewController ()
{
    CGRect rect;
    BOOL isEdting;
    BOOL addIMG;
    NSMutableArray *_imageArr;
    NSInteger addCount;
    UIActivityIndicatorView* activityIndicatorView ;
    UIView *bview;
    UITextField *textf;
    UIButton *btn;
    UIButton *addImage;
    UIImageView *imageV;
    UIImage *image;
    float addY;
    BOOL isCurrent;
    NSInteger currentTag;
    

}

@property (strong ,nonatomic)NSArray  *arr;
@property (strong ,nonatomic)UIButton *attentionButton;
@property (strong ,nonatomic)UIView *SYGView;
@end

@implementation QuizDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.muArr= [[NSMutableArray alloc]initWithCapacity:0];
   
    [self reloadQuizComandDetail];
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
    [textf resignFirstResponder];
    bview.frame = CGRectMake(0.0f, rect.size.height-28, rect.size.width, rect.size.height+20);
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(id)initWithQuizID:(NSString *)qid title:(NSString *)title  description:(NSString *)description uname:(NSString *)uname userface:(NSString *)userface ctime:(NSString *)ctime
{
    self = [super init];
    if (self) {
        self.qID = qid;
        self.wd_description = description;
        self.wd_title = title;
        self.uname = uname;
        self.userface = userface;
        self.ctime = ctime;
        
    }
    return self;
}

-(id)initWithDescription:(NSString *)qid
{
    self = [super init];
    if (self) {
        self.qID = qid;
    }
    return self;
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
    WZLabel.text = @"评论";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadXML];
    [self addNav];
    [self reloadQuizDetail];
    [self getAttentions];
    
    self.navigationItem.title = @"评论";
    addCount = 0;
    //添加关注的按钮
    _attentionButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 80, 30, 80, 20)];
    [_attentionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _attentionButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_attentionButton addTarget:self action:@selector(YesOrNo) forControlEvents:UIControlEventTouchUpInside];
    [_SYGView addSubview:_attentionButton];

    //返回按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 25)];
    [backButton setImage:[UIImage imageNamed:@"Arrow000"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bak = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:bak];

    
    
    
    
//    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardDidShowNotification object:nil];

    rect = [UIScreen mainScreen].applicationFrame;
     _imageArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    bview = [[UIView alloc]initWithFrame:CGRectMake(0, rect.size.height-28, rect.size.width, 264)];
    bview.backgroundColor = [UIColor whiteColor];
    
    addY = (rect.size.width-270)/4;
    imageV = [[UIImageView alloc]initWithFrame:CGRectMake(addY, 60, 90, 150)];
    [imageV setImage:[UIImage imageNamed:@"+.png"]];
    [bview addSubview:imageV];
    
    addImage = [UIButton buttonWithType:0];
    addImage.frame = CGRectMake(8, 11, 30, 25);
    [addImage setBackgroundImage:[UIImage imageNamed:@"addImage.png"] forState:0];
    [addImage addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
    [bview addSubview:addImage];
    addImage.hidden = YES;
    
    textf= [[UITextField alloc]initWithFrame:CGRectMake(10, 9, rect.size.width-88, 30)];
    textf.delegate = self;
    textf.borderStyle= UITextBorderStyleRoundedRect;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    [bview addSubview:textf];
    
    btn = [UIButton buttonWithType:0];
    btn.frame = CGRectMake(rect.size.width-63, 6, 55, 35);
    [btn setTitle:@"发送" forState:0];
    [btn addTarget:self action:@selector(sendCommand) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor colorWithRed:32.f/255.0 green:105.f/255.0 blue:207.f/255.0 alpha:1];
    [bview addSubview:btn];
    [self.view addSubview:bview];
    NSLog(@"22%@",self.uname);
    if ([self.uname isEqualToString:@"<null>"]) {
        self.userName.text = @"0000";
    } else {
        self.userName.text = self.uname;
    }
 
    self.userQuiz.text = self.wd_description;
    if ([self.userface isEqualToString:@"<null>"]) {
        [self.userFace setBackgroundImage:[UIImage imageNamed:@"remen.png"] forState:UIControlStateNormal];
        
    } else {
        [self.userFace sd_setBackgroundImageWithURL:[NSURL URLWithString:self.userface] forState:0 placeholderImage:nil];

    }
    self.userFace.clipsToBounds = YES;
    self.userFace.layer.cornerRadius = 20.0;
    self.QuizDate.text = [Passport formatterDate:self.ctime];
    
}


- (void)YesOrNo {
    if ([_attentionButton.titleLabel.text isEqualToString:@"添加关注"]) {
        //关注
        //判断是否登录
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
            //弹出登录界面
            DLViewController *DLVC = [[DLViewController alloc] init];
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
            [self.navigationController presentViewController:Nav animated:YES completion:nil];

            
        }else {//已经登录
            
            [self attentionPressed];
            
        }
        
    }
    
    if ([_attentionButton.titleLabel.text isEqualToString:@"取消关注"]) {
        
        //取消关注
        [self lostAttentionPressed];
    }
    
    
}




//先判断是否已经关注

-(void)getAttentions
{
    //判断是否登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        //没有登录的情况下肯定显示的是关注
         [_attentionButton setTitle:@"添加关注" forState:UIControlStateNormal];
        _attentionButton.backgroundColor = [UIColor redColor];
        
        
    }else {//已经登录
        
        [self SYGAttention];
        
    }
    
}


- (void)SYGAttention {
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [manager userAttentions:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"11%@",responseObject);
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {//用户没有关注的人
            
            [_attentionButton setTitle:@"添加关注" forState:UIControlStateNormal];
     
        } else  //有关注的人
        {
            _arr = [responseObject objectForKey:@"data"];
            //应该判断是否是用户自己

            for (int i = 0 ; i < _arr.count ; i++) {
                
                if ([self.qID integerValue] == [_arr[i][@"uid"] integerValue]) {// 说明已经关注了
                    
                    [_attentionButton setTitle:@"取消关注" forState:UIControlStateNormal];
                    
                    return ;
                    
                    
                } else {//没有关注改用户
                    [_attentionButton setTitle:@"添加关注" forState:UIControlStateNormal];
                    
                }
                
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error   %@",error);
    }];

}

- (void)lostAttentionPressed {//取消关注
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    [dic setObject:self.qID forKey:@"user_id"];
    [manager cancelUserAttention:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"99%@",responseObject);
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([msg isEqual:@"ok"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"取消关注成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alert repeats:YES];
            [_attentionButton setTitle:@"添加关注" forState:UIControlStateNormal];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

    
    
}



//关注的网络请求
- (void)attentionPressed
{//关注
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:self.qID forKey:@"user_id"];
    
    [manager attention:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"666%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        NSString *TXStr = responseObject[@"msg"];
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {//关注失败
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:TXStr delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alert repeats:YES];
            
        } else {//关注成功
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"关注成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alert repeats:YES];
            [_attentionButton setTitle:@"取消关注" forState:UIControlStateNormal];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}
-(void)reloadQuizDetail
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    NSLog(@"%@",self.qID);
    [dic setObject:self.qID forKey:@"wid"];

    [manager reloadQuizDetail:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"33%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);

//        if (!(self.muArr == nil)) {
//            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self.muArr objectAtIndex:0]];
////            self.userName.text = [NSString stringWithFormat:@"%@",dic[@"wd_title"]];
////            self.userQuiz.text = [NSString stringWithFormat:@"%@",dic[@"wd_description"]];
//            self.userName.text = self.wd_title;
//            self.userQuiz.text = self.wd_description;
//            NSLog(@"%@",dic[@"wd_title"]);
//            
//            self.QuizDate.text = [Passport formatterDate:[dic objectForKey:@"ctime"]];
//            if (![[NSDictionary dictionaryWithDictionary:[dic objectForKey:@"userinfo"]] isEqual:[NSNull null]]) {
//                NSDictionary *userinfo = [NSDictionary dictionaryWithDictionary:[dic objectForKey:@"userinfo"]];
//                [self.userFace sd_setBackgroundImageWithURL:[userinfo objectForKey:@"avatar_small"] forState:0 placeholderImage:[UIImage imageNamed:nil]];
//                self.userFace.clipsToBounds = YES;
//                self.userFace.layer.cornerRadius = 20.0;
//                self.userName.text = [userinfo objectForKey:@"uname"];
//            }
//        }
//        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)reloadQuizComandDetail
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
//    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
//    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:self.qID forKey:@"wid"];
    [manager reloadQuizComandDetail:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![[responseObject objectForKey:@"data"]isEqual:[NSNull null]]) {
            self.detailArr = [[NSMutableArray alloc]initWithArray:[responseObject objectForKey:@"data"]];
            [self.tableView reloadData];
            [ activityIndicatorView stopAnimating];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailArr.count;
    /*
     UIFont * font =[UIFont systemFontOfSize:17];
     NSDictionary * dict =[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
     //限制宽度最大200，高度最大5000
     //CGSize size = [str sizeWithFont:font constrainedToSize:CGSizeMake(200, 5000)];
     
     CGRect rect = [str boundingRectWithSize:CGSizeMake(200, 5000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil];
     CGSize size = rect.size;
     */
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    QuizDtailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"QuizDtailCell" owner:nil options:nil];
        cell = [cellArr objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self.detailArr objectAtIndex:indexPath.row]];
    cell.body.text = [dic objectForKey:@"description"];
    cell.time.text = [Passport formatterDate:[dic objectForKey:@"ctime"]];
    NSDictionary *userinfo = [dic objectForKey:@"userinfo"];
    [cell.face sd_setBackgroundImageWithURL:[NSURL URLWithString:[userinfo objectForKey:@"avatar_small"]] forState:0 placeholderImage:nil];
    cell.face.clipsToBounds  =YES;
    cell.face.layer.cornerRadius = 20.0;
    cell.name.text = [userinfo objectForKey:@"uname"];
    
    cell.body.attributedText = [emotionjiexi jiexienmojconent:[dic objectForKey:@"description"] font:[UIFont systemFontOfSize:15]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.detailArr objectAtIndex:indexPath.row];
    ReplyQuizCommandVC *re = [[ReplyQuizCommandVC alloc]initWithReplyDic:dic];
    [self.navigationController pushViewController:re animated:YES];
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
    bview.frame = CGRectMake(0.0f, rect.size.height-28, rect.size.width, rect.size.height+20);
    [UIView commitAnimations];
   
    [textf resignFirstResponder];
    return YES;
}
//-(void)textFieldDidBeginEditing:(UITextField *)textField {
//    CGRect frame = textField.frame;
//    int offset = frame.origin.y + 185 - (rect.size.height - 216.0);
//    
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//
//    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
//    if(offset > 0)
//    {
//        bview.frame = CGRectMake(0, bview.frame.origin.y-offset+28, rect.size.width, 48);
//    }else
//    {
//        bview.frame = CGRectMake(0, bview.frame.origin.y+offset-20, rect.size.width, 48);
//    }
//    [UIView commitAnimations];
//}
-(void)sendReplyQuiz
{
    activityIndicatorView = [ [ UIActivityIndicatorView  alloc ]initWithFrame:CGRectMake((rect.size.width-30)/2,(rect.size.height-37),37,37)];
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
    [dic setObject:self.qID forKey:@"wid"];
    [dic setObject:textf.text forKey:@"count"];
    [manager reloadQuizComand:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        if (![msg isEqual:@"ok"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alert repeats:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)reloadXML
{
    // 创建一个标签元素
    GDataXMLElement *element = [GDataXMLNode elementWithName:@"user" stringValue:@"will"];
    // 创建一个属性
    GDataXMLElement *attribute = [GDataXMLNode attributeWithName:@"a" stringValue:@"b"];
    // 创建一个根标签
    GDataXMLElement *rootElement = [GDataXMLNode elementWithName:@"root"];
    // 把标签与属性添加到根标签中
    [rootElement addChild:element];	[rootElement addAttribute:attribute];
    // 生成xml文件内容
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithRootElement:rootElement];
    NSData *data = [xmlDoc XMLData];
    NSString *xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"-----%@",xmlString);
}
- (void)sendCommand
{
    //限制输入框中的值为空的时候不能发送
    if ([textf.text isEqualToString:@""])
    {
        return;
    }
    [self sendReplyQuiz];
    [self reloadQuizComandDetail];


    textf.text=@"";

    if (self.muArr.count>1)
    {
        NSIndexPath * indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
- (void)addImage:(UIButton *)sender
{
    UIImagePickerController * imagePickerVC =[[UIImagePickerController alloc]init];
    [imagePickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePickerVC setAllowsEditing:YES];
    imagePickerVC.delegate=self;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image = [info valueForKey:@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES completion:nil];
    [textf resignFirstResponder];
    bview.frame=  CGRectMake(0, rect.size.height-264, rect.size.width, 264);
    if (isCurrent == NO) {
        [_imageArr addObject:image];
        
        UIButton *addbtn =[UIButton buttonWithType:0];
        addbtn.tag = _imageArr.count;
        addbtn.frame = CGRectMake((addY*_imageArr.count)+(90*(_imageArr.count-1)), 60, 90, 150);
        [addbtn setBackgroundImage:image forState:0];
        [addbtn addTarget:self action:@selector(selfImage:) forControlEvents:UIControlEventTouchUpInside];
        [bview addSubview:addbtn];
    }else
    {
        UIButton *btn = (UIButton *)[bview viewWithTag:currentTag];
        [btn setBackgroundImage:image forState:0];
    }
    isCurrent= NO;
}
-(void)selfImage:(UIButton *)sender
{
    currentTag = sender.tag;
    UIImagePickerController * imagePickerVC =[[UIImagePickerController alloc]init];
    [imagePickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePickerVC setAllowsEditing:YES];
    imagePickerVC.delegate=self;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
    isCurrent = YES;
    [_imageArr replaceObjectAtIndex:sender.tag-1 withObject:image];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSTimeInterval animationDuration = 0.25f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    bview.frame = CGRectMake(0.0f, rect.size.height-28, rect.size.width, rect.size.height+20);
    [UIView commitAnimations];

    [textf resignFirstResponder];
}




//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//监听键盘的消失

- (void)keyboardWillBeHidden:(NSNotification *)not
{
    NSLog(@"%@",not.userInfo);
    [UIView animateWithDuration:0.25 animations:^{
        bview.transform = CGAffineTransformMakeTranslation(0, 258);
    }];
}




- (void)removeAlert:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}

@end
