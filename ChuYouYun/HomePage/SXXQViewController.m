//
//  SXXQViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/23.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width


#import "SXXQViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "Passport.h"
#import "UIButton+WebCache.h"
#import "SYG.h"
#import "emotionjiexi.h"
#import "TIXingLable.h"
#import "UIColor+HTMLColors.h"


@interface SXXQViewController ()
{
    CGRect WDrect;
    NSMutableArray * _textArray;
    UIImageView *touserImage;
    BOOL _isChangedKeyBoard;
    BOOL _isSelf;
    NSString *_lastDate;
    NSDate *lastDate;
    NSMutableArray *_dateType;
    CGRect rect;
    CGFloat TabH;
    TIXingLable *_txlab;
    NSString *_timeStr;
    BOOL isSend;
}

@property (strong ,nonatomic)UIView *SYGView;

@property (strong ,nonatomic)NSArray *allArray;

@property (assign ,nonatomic)NSInteger number;//记录是否应该显示列表最底部



@end

@implementation SXXQViewController

-(void)viewWillAppear:(BOOL)animated
{
    WDrect = [UIScreen mainScreen].applicationFrame;
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoradChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    _textArray = [[NSMutableArray alloc]initWithCapacity:0];
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
    _timeStr = @"";
    [self initFace];
    [self addNav];
    [self addBarView];
    TabH = 0;//初始化值
    _number = 0;
    NSLog(@"%@",self.uface);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    rect = [UIScreen mainScreen].applicationFrame;
    self.speaktext.delegate = self;
    self.sendBtn.clipsToBounds = YES;
    self.sendBtn.layer.cornerRadius = 5;
    self.dateArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.fromArr = [[NSMutableArray alloc]initWithCapacity:0];
    _dateType =[[NSMutableArray  alloc]initWithCapacity:0];
    touserImage = [[UIImageView alloc]init];
    [touserImage sd_setImageWithURL:[NSURL URLWithString:self.uface] placeholderImage:nil];
    _tableVIew = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, MainScreenWidth, MainScreenHeight - 64 - 48 + 15) style:UITableViewStyleGrouped];
    _tableVIew.delegate = self;
    _tableVIew.dataSource = self;
    _tableVIew.separatorStyle = UITableViewCellSeparatorStyleNone;
    _txlab = [[TIXingLable alloc]initWithFrame:CGRectMake(0, 200, MainScreenWidth, 30)];
    _txlab.textColor = [UIColor clearColor];
    [_tableVIew insertSubview:_txlab atIndex:0];
    [self.view addSubview:_tableVIew];
    [self.view insertSubview:_barView aboveSubview:_tableVIew];
    [self.view insertSubview:_SYGView aboveSubview:_tableVIew];
    [self.tableVIew addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [self.tableVIew headerBeginRefreshing];
    
    [_tableVIew setContentOffset:CGPointMake(0, _tableVIew.bounds.size.height) animated:YES];
}

- (void)initFace {
    self.view.backgroundColor = [UIColor whiteColor];
    isSend = NO;
}

- (void)addBarView {
    _barView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 48, MainScreenWidth, 48)];
    _barView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_barView];
    
    //添加文本输入框
    _speaktext = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth - 80, 28)];
    _speaktext.layer.borderColor = PartitionColor.CGColor;
    _speaktext.layer.borderWidth = 1;
    _speaktext.layer.cornerRadius = 3;
    _speaktext.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    //设置显示模式为永远显示(默认不显示)
    _speaktext.leftViewMode = UITextFieldViewModeAlways;
    [_barView addSubview:_speaktext];
    
    //添加按钮
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 9, 50, 30)];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    sendBtn.layer.cornerRadius = 3;
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
    [_barView addSubview:sendBtn];
    
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    _SYGView = SYGView;
    [self.view bringSubviewToFront:_SYGView];
    

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"私信详情";
    [WZLabel setTextColor:BasidColor];
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

- (void)headerRerefreshing
{
    [self comRequest];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableVIew headerEndRefreshing];
        if (_dateArr.count == 0) {
            _txlab.textColor = [UIColor colorWithHexString:@"#dedede"];
        }else{
        
            _txlab.textColor = [UIColor clearColor];
        }
    });
    
}
-(void)comRequest
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    NSString *str = self.list_is;
    [dic setObject:str forKey:@"message_id"];
    NSLog(@"%@",str);
    [manager comMessageChat:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"-----%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            NSString *list_id = [dic objectForKey:@"list_id"];
            NSInteger sinceid = [[dic objectForKey:@"since_id"] integerValue];
            NSString *since_id = [NSString stringWithFormat:@"%ld",(long)sinceid];
            [self reloadChatlist_id:list_id since_id:since_id];

        } else {
            
        }
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
    NSString *speak =  self.speaktext.text;
    [dic setObject:speak forKey:@"reply_content"];
    if (self.toUid == nil) {
        [MBProgressHUD showError:@"发送失败" toView:self.view];
        return;
    }
    [dic setObject:self.toUid forKey:@"to"];
    [manager sendChat:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        if (![msg isEqual:@"ok"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"您刚才发送的信息内容为:%@",speak] message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alert repeats:YES];
        } else {
            isSend = YES;
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
    NSLog(@"%@",dic);
    [manager MessageChat:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"----responseObject---%@",responseObject);
        _allArray = responseObject[@"data"];
        NSMutableArray *arr =[NSMutableArray arrayWithArray:[responseObject objectForKey:@"data"]];
        NSMutableArray *msgArr = [[NSMutableArray alloc]initWithCapacity:0];
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[arr objectAtIndex:i]];
            [msgArr addObject:[dic objectForKey:@"content"]];
            NSString *fromStr = [dic objectForKey:@"from_uid"];
//            NSDate *date = [Passport formatterDateNumber:[dic objectForKey:@"mtime"] ];
            NSString *dataStr = [dic objectForKey:@"mtime"];
//            [self.dateArr addObject:date];
            [self.dateArr addObject:dataStr];
            [self.fromArr addObject:fromStr];
            [_dateType addObject:@"0"];
        }
        _textArray = nil;
        _textArray = [NSMutableArray arrayWithArray:msgArr];

        //将数组几个数组里面的数组全部颠倒过来
        [self hhhhhhh];
        TabH = 0;//这个吧之前算出来的高度清空，不然高度会一会累加
        
        [self.tableVIew reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _textArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
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
    
    NSAttributedString *HHHH = [emotionjiexi jiexienmojconent:str font:[UIFont systemFontOfSize:15]];
    CGRect rectHH = [HHHH boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    CGSize sizeH = rectHH.size;

    TabH = TabH + sizeH.height + 40;
    if ([lastStr isEqual:_lastDate]) {
        return sizeH.height + 60;
    }else {
        return sizeH.height + 60;
    }
   
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
        headBtn.layer.cornerRadius = 20;
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
    [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    lbl.numberOfLines=0;
    
    NSString *str = _textArray[indexPath.row];
    
    UIFont * font =[UIFont systemFontOfSize:17];
    NSDictionary * dict =[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil];
    CGSize size = rect.size;
    _lastDate = [self.dateArr objectAtIndex:indexPath.row];
    NSDate *date = [self.dateArr objectAtIndex:indexPath.row];
    NSDate *now =[NSDate date];
    
    if (![fromStr isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"User_id"]])
    {//别人发的
        if (indexPath.row<100) {

            datalbl.frame =  CGRectMake(self.tableVIew.frame.size.width/2-100, 0 , 200, 10);
            if ([_lastDate isEqualToString:_timeStr]) {
                datalbl.text= @"";
            }else{
                datalbl.text= _lastDate;
                _timeStr = _lastDate;
            }
            
        }else
        {
            
             datalbl.frame =  CGRectMake(self.tableVIew.frame.size.width/2-100, 0 , 200, 10);
             datalbl.text= _lastDate;
        }
        
        lbl.attributedText = [emotionjiexi jiexienmojconent:str font:[UIFont systemFontOfSize:15]];
        CGRect rectHH = [lbl.attributedText boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
        CGSize sizeH = rectHH.size;
        
        UIImage * image=[[UIImage imageNamed:@"white.png"]stretchableImageWithLeftCapWidth:22 topCapHeight:15];
        imageView.image=image;
        imageView.frame=CGRectMake(60, 25, sizeH.width+30, sizeH.height+10 + 10);
        
//        lbl.text=str;
//        lbl.attributedText = [emotionjiexi jiexienmojconent:str font:[UIFont systemFontOfSize:15]];
//        NSString *HHHH = lbl.text;
        
//        CGRect rectHH = [lbl.attributedText boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
//        CGSize sizeH = rectHH.size;
        
//        lbl.frame=CGRectMake(75, 25, size.width, size.height);
        lbl.frame=CGRectMake(75, 25, sizeH.width, sizeH.height);
        lbl.center = imageView.center;
        lbl.textColor = [UIColor blackColor];
        NSURL *url = [NSURL URLWithString:self.uface];
//        [btn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
        [btn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:Image(@"站位图")];

        btn.frame=CGRectMake(5, 25, 40, 40);
    }
    else
    {//自己发的
        if (indexPath.row<100) {

              datalbl.frame =  CGRectMake(self.tableVIew.frame.size.width/2-100, 0 , 200, 10);
            if ([_lastDate isEqualToString:_timeStr]) {
                datalbl.text= @"";
            }else{
                datalbl.text= _lastDate;
                _timeStr = _lastDate;
            }
        }else
        {
            datalbl.frame =  CGRectMake(self.tableVIew.frame.size.width/2-100, 0 , 200, 10);
            
            datalbl.text= _lastDate;
            
        }
        
        lbl.attributedText = [emotionjiexi jiexienmojconent:str font:[UIFont systemFontOfSize:15]];
        CGRect rectHH = [lbl.attributedText boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
        CGSize sizeH = rectHH.size;
        
        UIImage * image=[[UIImage imageNamed:@"对话@2x"]stretchableImageWithLeftCapWidth:22 topCapHeight:15];
        imageView.image=image;
        imageView.frame=CGRectMake(WDrect.size.width-(sizeH.width+30)-60, 25, sizeH.width+30, sizeH.height+10 + 10);
        
        lbl.frame=CGRectMake(WDrect.size.width-(sizeH.width+15)-60, 25, sizeH.width, sizeH.height);
        
        lbl.center = imageView.center;
        lbl.textColor = [UIColor whiteColor];
        
//        [btn sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:@"userface" ] ] forState:0 placeholderImage:nil];
        [btn sd_setBackgroundImageWithURL:[[NSUserDefaults standardUserDefaults]objectForKey:@"userface" ] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
        btn.frame=CGRectMake(WDrect.size.width-55, 25, 40, 40);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 20;
    }
    
    NSLog(@"%@",NSStringFromCGRect(cell.frame));

    if (_number < _textArray.count) {//说明是第一次进去这个界面，显示最下面的数据
        //自动滑到底部
        [_tableVIew scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        _number ++;
    }
    
    
    
    if (indexPath.row == _textArray.count - 1) {
        if (isSend == YES) {//说明是刚才了信息
            [_tableVIew scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            isSend = NO;
        }
    }
    

    NSLog(@"NUmber--------%ld",_number);

    return cell;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.speaktext resignFirstResponder];
}


//键盘弹上来
- (void)keyboardWillShow:(NSNotification *)not {
    NSLog(@"%@",not.userInfo);
    CGRect rect = [not.userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    CGFloat HFloat = rect.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        
        //看当前表格的高度
        CGFloat KH = 0 ;
        KH = MainScreenHeight - HFloat - 48 - 64;//这是中间展示表格的高度
        NSLog(@"---KH--%f",KH);
        if (TabH / 2 < KH) {//说明这里表格试图不用动
            
        } else {//表格试图也需要向上移动距离
            
            _tableVIew.frame = CGRectMake(0, 50 - HFloat, MainScreenWidth, MainScreenHeight - 64 - 48 + 15);
            
            CGFloat KJH = MainScreenHeight - 48 - 64 - TabH / 2;
            NSLog(@"--KJH--%f",KJH);
            CGFloat KKK =  fabs(KJH);
            NSLog(@"--KKKK---%f",KKK);
            
            
            CGFloat YDH = HFloat - (MainScreenHeight - 48 - 64 - TabH / 2);
            NSLog(@"---YDH---%f",YDH);
            
//            if (KJH < HFloat) {//说明表格上升的距离不需要HFloat,而是像个的差值YDH
//                
//                _tableVIew.frame = CGRectMake(0, 50 - HFloat, MainScreenWidth, MainScreenHeight - 64 - 48 + 15);
//            } else {//需要向上移动HFloat
//                 _tableVIew.frame = CGRectMake(0, 50 - HFloat, MainScreenWidth, MainScreenHeight - 64 - 48 + 15);
//            }
//            
//            if (TabH / 2 > MainScreenHeight - 64 - 48) {//如果高度很大的直接上移HFlaot
//                 _tableVIew.frame = CGRectMake(0, 50 - HFloat, MainScreenWidth, MainScreenHeight - 64 - 48 + 15);
//            }
//            
           
            _SYGView.frame = CGRectMake(0, 0, MainScreenWidth, 64);
        }

        _barView.frame = CGRectMake(0, MainScreenHeight - 48 - HFloat, MainScreenWidth, 48);
    }];

    
    
}

//键盘弹下去
- (void)keyboardWillHide:(NSNotification *)not {
    NSLog(@"%@",not.userInfo);
    [UIView animateWithDuration:0.25 animations:^{
        _barView.frame = CGRectMake(0, MainScreenHeight - 48, MainScreenWidth, 48);
        _tableVIew.frame = CGRectMake(0, 50, MainScreenWidth, MainScreenHeight - 64 - 48 + 15);
    }];

    
}





-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    self.view.frame =CGRectMake(0, 0, WDrect.size.width, WDrect.size.height);
    _SYGView.frame = CGRectMake(0, 0, MainScreenWidth, 64);
}

- (void)sendClick:(id)sender
{
    //限制输入框中的值为空的时候不能发送
    if ([self.speaktext.text isEqualToString:@""])
    {
        return;
    }
    [self sendToMessageUId:self.toUid];
    NSLog(@"string    %@",self.speaktext.text);
    //    [_textArray addObject:self.speaktext.text];
    //    [self.tableVIew reloadData];
    
    self.speaktext.text=@"";
    
    if (_textArray.count>1)
    {
        NSIndexPath * indexPath =[NSIndexPath indexPathForRow:_textArray.count-1 inSection:0];
        [self.tableVIew scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}



//移除警告框

- (void)removeAlert:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
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
    return html;
}


- (void)hhhhhhh {
    
    NSLog(@"前------%@",_textArray);
    
    // 这个方法是让之前的数组里面的东西全部颠倒过来
    NSArray* reversedArray = [[_textArray reverseObjectEnumerator] allObjects];
    NSLog(@"%@",reversedArray);
    _textArray = reversedArray;
    
    NSLog(@"%@",self.fromArr);
    NSArray* IDArray = [[self.fromArr reverseObjectEnumerator] allObjects];
    NSLog(@"%@",IDArray);
    self.fromArr = IDArray;
    
    NSLog(@"%@",self.dateArr);
    NSArray* DataArray = [[self.dateArr reverseObjectEnumerator] allObjects];
    NSLog(@"%@",DataArray);
    self.dateArr = DataArray;
    
}


@end
