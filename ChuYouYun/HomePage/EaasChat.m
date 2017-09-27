//
//  EaasChat.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/4/15.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "EaasChat.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "ZhiyiHTTPRequest.h"
#import "Passport.h"
#import "UIButton+WebCache.h"
@interface EaasChat ()
{
    CGRect WDrect;
    BOOL _isChangedKeyBoard;
    BOOL _isSelf;
    NSString *_lastDate;
    NSDate *lastDate;
}
@end

@implementation EaasChat
-(void)viewWillAppear:(BOOL)animated
{
    WDrect = [UIScreen mainScreen].applicationFrame;
    //
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoradChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    _textArray = [[NSMutableArray alloc]initWithCapacity:0];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    //    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardDidShowNotification object:nil];
    self.speakText.delegate = self;
    self.send.clipsToBounds = YES;
    self.send.layer.cornerRadius = 5;
    //    self.tableVIew.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //    self.tableVIew.showsVerticalScrollIndicator = NO;
    self.dateArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.fromArr = [[NSMutableArray alloc]initWithCapacity:0];
    _dateType =[[NSMutableArray  alloc]initWithCapacity:0];
    _touserImage = [[UIImageView alloc]init];
    [_touserImage sd_setImageWithURL:[NSURL URLWithString:self.uface] placeholderImage:nil];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [self.tableView headerBeginRefreshing];
}
- (void)headerRerefreshing
{
    [self comRequest];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView headerEndRefreshing];
    });
    
}
-(void)comRequest
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    NSString *str = self.list_is;
    [dic setObject:self.list_is forKey:@"mid"];
    [manager comMessageChat:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [responseObject objectForKey:@"data"];
        NSString *list_id = [dic objectForKey:@"list_id"];
        NSInteger sinceid = [[dic objectForKey:@"since_id"] integerValue];
        NSString *since_id = [NSString stringWithFormat:@"%d",sinceid];
        [self reloadChatlist_id:list_id since_id:since_id];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)sendToMessageUId:(NSString *)uid
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:self.list_is forKey:@"id"];
    NSString *speak =  self.speakText.text;
    [dic setObject:speak forKey:@"reply_content"];
    [dic setObject:self.toUid forKey:@"to"];
    [manager sendChat:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        if (![msg isEqual:@"ok"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"您刚才发送的信息内容为:%@",speak] message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else
        {
            NSDate *now = [NSDate date];
            [self.dateArr addObject:now];
            [_dateType addObject:@"1"];
            [self comRequest];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
-(void)reloadChatlist_id:(NSString *)list_id since_id:(NSString *)since_id
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:list_id forKey:@"list_id"];
    [dic setObject:since_id forKey:@"since_id"];
    [manager MessageChat:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *arr =[NSMutableArray arrayWithArray:[responseObject objectForKey:@"data"]];
        NSMutableArray *msgArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[arr objectAtIndex:i]];
            [msgArr addObject:[dic objectForKey:@"content"]];
            NSString *fromStr = [dic objectForKey:@"from_uid"];
            NSDate *date = [Passport formatterDateNumber:[dic objectForKey:@"mtime"] ];
            [self.dateArr addObject:date];
            [self.fromArr addObject:fromStr];
            [_dateType addObject:@"0"];
        }
        _textArray = nil;
        _textArray = [NSMutableArray arrayWithArray:msgArr];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _textArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        UIButton *headBtn = [UIButton buttonWithType:0];
        headBtn.tag = 2;
        headBtn.clipsToBounds = YES;
        headBtn.layer.cornerRadius = 20.0;
        [cell addSubview:headBtn];
        
        UIImageView * buddleImageView =[[UIImageView alloc]init];
        buddleImageView.tag=5;
        [cell addSubview:buddleImageView];
        
        UILabel * textLbl =[[UILabel alloc]init];
        textLbl.tag=10;
        [cell addSubview:textLbl];
        
        UILabel *dateLbl = [[UILabel alloc]init];
        dateLbl.tag = 7;
        [cell addSubview:dateLbl];
    }
    NSString *fromStr = [self.fromArr objectAtIndex:indexPath.row];
    
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UIImageView * imageView =(UIImageView *)[cell viewWithTag:5];
    UILabel * lbl = (UILabel *)[cell viewWithTag:10];
    UIButton *btn = (UIButton *)[cell viewWithTag:2];
    UILabel *datalbl = (UILabel*)[cell viewWithTag:7];
    datalbl.textColor = [UIColor lightGrayColor];
    datalbl.font = [UIFont systemFontOfSize:13];
    datalbl.textAlignment = NSTextAlignmentCenter;
    
    lbl.numberOfLines=0;
    
    
    NSString * str= _textArray[indexPath.row];
    
    UIFont * font =[UIFont systemFontOfSize:17];
    NSDictionary * dict =[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(200, 5000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil];
    CGSize size = rect.size;
    _lastDate = [self.dateArr objectAtIndex:indexPath.row];
    NSDate *date = [self.dateArr objectAtIndex:indexPath.row];
    NSDate *now =[NSDate date];
    if (![fromStr isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"User_id"]])
    {
        if (indexPath.row<1) {
            NSTimeInterval earlierDate = [now timeIntervalSinceDate:date];
            if (earlierDate >30.0*60.0) {
                NSTimeInterval nowEarlier =[now timeIntervalSinceDate:date];
                if (nowEarlier < 12.0*60.0*60.0) {
                    datalbl.frame =  CGRectMake(self.tableView.frame.size.width/2-100, 5, 200, 10);
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *dateStr=[dateFormatter stringFromDate:date];
                    
                    NSString *chatDate = [dateStr substringFromIndex:11];
                    datalbl.text=chatDate;
                }else{
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *dateStr=[dateFormatter stringFromDate:date];
                    datalbl.frame =  CGRectMake(self.tableView.frame.size.width/2-100, 5, 200, 10);
                    datalbl.text=dateStr;
                }
            }
        }else
        {
            NSDate *lastTime = [self.dateArr objectAtIndex:indexPath.row-1];
            NSTimeInterval earlierDate = [lastTime timeIntervalSinceDate:date];
            if (earlierDate >30.0*60.0) {
                NSTimeInterval nowEarlier =[now timeIntervalSinceDate:lastTime];
                if (nowEarlier < 12.0*60.0*60.0) {
                    datalbl.frame =  CGRectMake(self.tableView.frame.size.width/2-100, 5, 200, 10);
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *dateStr=[dateFormatter stringFromDate:date];
                    
                    NSString *chatDate = [dateStr substringFromIndex:11];
                    datalbl.text=chatDate;
                    
                }else{
                    datalbl.frame =  CGRectMake(self.tableView.frame.size.width/2-100, 5, 200, 10);
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *dateStr=[dateFormatter stringFromDate:date];
                    datalbl.text=dateStr;
                }
            }
        }
        
        UIImage * image=[[UIImage imageNamed:@"white.png"]stretchableImageWithLeftCapWidth:22 topCapHeight:15];
        imageView.image=image;
        imageView.frame=CGRectMake(60, 25, size.width+30, size.height+10);
        
        lbl.text=str;
        lbl.frame=CGRectMake(75, 25, size.width, size.height);
        
        [btn setBackgroundImage:_touserImage.image forState:0];
        btn.frame=CGRectMake(5, 25, 40, 40);
    }
    else
    {
        if (indexPath.row<1) {
            NSTimeInterval earlierDate = [now timeIntervalSinceDate:date];
            if (earlierDate >30.0*60.0) {
                NSTimeInterval nowEarlier =[now timeIntervalSinceDate:date];
                if (nowEarlier < 12.0*60.0*60.0) {
                    datalbl.frame =  CGRectMake(self.tableView.frame.size.width/2-100, 5, 200, 10);
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *dateStr=[dateFormatter stringFromDate:date];
                    
                    NSString *chatDate = [dateStr substringFromIndex:11];
                    datalbl.text=chatDate;
                    
                }else{
                    datalbl.frame =  CGRectMake(self.tableView.frame.size.width/2-100, 5, 200, 10);
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *dateStr=[dateFormatter stringFromDate:date];
                    
                    datalbl.text=dateStr;
                }
            }
        }else
        {
            NSDate *lastTime = [self.dateArr objectAtIndex:indexPath.row-1];
            NSTimeInterval earlierDate = [lastTime timeIntervalSinceDate:date];
            if (earlierDate >30.0*60.0) {
                NSTimeInterval nowEarlier =[now timeIntervalSinceDate:lastTime];
                if (nowEarlier < 12.0*60.0*60.0) {
                    datalbl.frame =  CGRectMake(self.tableView.frame.size.width/2-100, 5, 200, 10);
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *dateStr=[dateFormatter stringFromDate:date];
                    
                    NSString *chatDate = [dateStr substringFromIndex:11];
                    datalbl.text=chatDate;
                }else{
                    datalbl.frame =  CGRectMake(self.tableView.frame.size.width/2-100, 5, 200, 10);
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *dateStr=[dateFormatter stringFromDate:date];
                    
                    datalbl.text=dateStr;
                }
            }
        }
        
        UIImage * image=[[UIImage imageNamed:@"blue.png"]stretchableImageWithLeftCapWidth:22 topCapHeight:15];
        imageView.image=image;
        imageView.frame=CGRectMake(WDrect.size.width-(size.width+30)-60, 25, size.width+30, size.height+10);
        
        lbl.text=str;
        lbl.frame=CGRectMake(WDrect.size.width-(size.width+15)-60, 25, size.width, size.height);
        
        [btn sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:@"userface" ] ] forState:0 placeholderImage:nil];
        btn.frame=CGRectMake(WDrect.size.width-55, 25, 45, 40);
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _lastDate = [self.dateArr objectAtIndex:indexPath.row];
    NSString *lastStr;
    if (indexPath.row > 0) {
        lastStr = [self.dateArr objectAtIndex:indexPath.row-1];
    }
    NSString * str= _textArray[indexPath.row];
    
    UIFont * font =[UIFont systemFontOfSize:17];
    NSDictionary * dict =[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    //限制宽度最大200，高度最大5000
    //CGSize size = [str sizeWithFont:font constrainedToSize:CGSizeMake(200, 5000)];
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(200, 5000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil];
    CGSize size = rect.size;
    
    if ([lastStr isEqual:_lastDate]) {
        return size.height+50;
    }
    
    return size.height+40;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.speakText resignFirstResponder];
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
- (IBAction)sendClick:(id)sender
{
    //限制输入框中的值为空的时候不能发送
    if ([self.speakText.text isEqualToString:@""])
    {
        return;
    }
    [self sendToMessageUId:self.toUid];
    NSLog(@"string    %@",self.speakText.text);
    //    [_textArray addObject:self.speaktext.text];
    //    [self.tableVIew reloadData];
    
    self.speakText.text=@"";
    
    if (_textArray.count>1)
    {
        NSIndexPath * indexPath =[NSIndexPath indexPathForRow:_textArray.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 185 - (WDrect.size.height - 216.0);
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.tableView.frame=CGRectMake(0, 64, 320, 480-64-216-44);
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
    {
        self.view.frame = CGRectMake(0.0f, -offset, WDrect.size.width, WDrect.size.height);
    }else
    {
        self.view.frame = CGRectMake(0.0f, +offset, WDrect.size.width, WDrect.size.height);
    }
    [UIView commitAnimations];
}
//-(void)keyBoradChanged:(NSNotification *)aNotification
//{
//    if (_isChangedKeyBoard)
//    {
//        self.tableVIew.frame=CGRectMake(0, 64, 320, 480-64-216-44-30);
//        self.barView.frame=CGRectMake(0, 480-216-44-30, 320, 44);
//
//    }
//    else
//    {
//
//        self.tableVIew.frame=CGRectMake(0, 64, 320, 480-64-216-44);
//        self.barView.frame=CGRectMake(0, 480-216-44, 320, 44);
//
//    }
//    [self.tableVIew reloadData];
//    _isChangedKeyBoard=!_isChangedKeyBoard;
//
//
//}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    self.view.frame =CGRectMake(0, 20, WDrect.size.width, WDrect.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
