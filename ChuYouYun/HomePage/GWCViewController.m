//
//  GWCViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/2/16.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4 4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕


#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕




#import "GWCViewController.h"
#import "MyShopingCarCell.h"
#import "MyUIButton.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "ZhiyiHTTPRequest.h"
#import "SPBaseClass.h"
#import "SPVideoInfo.h"
#import "myCar.h"
#import "UIColor+HTMLColors.h"
#import "TIXingLable.h"




@interface GWCViewController ()
{
    BOOL isEditing;
    BOOL isEnter;
    NSInteger priceNum;
    CGRect rect;
    BOOL isXZ;
    TIXingLable *_txLab;

}


@property (strong ,nonatomic)MyUIButton *button;

@property (strong ,nonatomic)NSMutableArray *idArray;

@property (strong ,nonatomic)UIButton *JSButton;

@property (strong ,nonatomic)UIView *DHView;

@property (strong ,nonatomic)NSMutableArray *ZTArray;

@property (assign ,nonatomic)NSInteger SYGSum;

@property (strong ,nonatomic)NSArray *HHHArray;

@end

@implementation GWCViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
//    [self rloadUserShoping];
    
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
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"焦点按钮@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加操作按钮
    UIButton *CZButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 25, 50, 30)];
    [CZButton setTitle:@"操作" forState:UIControlStateNormal];
    [CZButton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:CZButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"我的购物车";
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
    [self addDHView];//导航试图
    
    //状态数据的初始化
    _ZTArray = [NSMutableArray array];
    _SYGSum = 0;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    rect = [UIScreen mainScreen].applicationFrame;
    self.muDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"操作" style:UIBarButtonItemStylePlain target:self action:@selector(btnClick)];
    self.muArr = [[NSMutableArray alloc]initWithCapacity:0];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 40, MainScreenWidth, MainScreenHeight - 104 - 60) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _txLab = [[TIXingLable alloc]initWithFrame:CGRectMake(0, 100*MainScreenHeight/667, MainScreenWidth, 30)];
    _txLab.textColor = [UIColor clearColor];
    [_tableView insertSubview:_txLab atIndex:0];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.addDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [self rloadUserShoping];
    isEditing = nil;
    isXZ = NO;
    priceNum = 0;
    
    NSLog(@"****%@",self.muDic);
    _idArray = [[NSMutableArray alloc] init];
    [self addJSView];
    
}

- (void)addDHView {
    UIView *DHView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 40)];
    DHView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:DHView];
    _DHView = DHView;
    
    //添加全选按钮
    UIButton *allButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    [allButton addTarget:self action:@selector(allXZ:) forControlEvents:UIControlEventTouchUpInside];
    [allButton setBackgroundImage:[UIImage imageNamed:@"check 拷贝.png"] forState:UIControlStateNormal];
    
    [DHView addSubview:allButton];
    
    
    UILabel *KCLabel = [[UILabel alloc] init];
    KCLabel.text = @"课程名称";
    KCLabel.font = [UIFont systemFontOfSize:14];
    [DHView addSubview:KCLabel];
    
    UILabel *JGLabel = [[UILabel alloc] init];
    JGLabel.text = @"价格";
    JGLabel.font = [UIFont systemFontOfSize:14];
    [DHView addSubview:JGLabel];
    
    
    if (iPhone4SOriPhone4 || iPhone5o5Co5S) {
        KCLabel.frame = CGRectMake(60, 10, 100, 20);
        JGLabel.frame = CGRectMake(MainScreenWidth - 65, 10, 40, 20);
    }else if (iPhone6) {
        KCLabel.frame = CGRectMake(80, 10, 100, 20);
        JGLabel.frame = CGRectMake(MainScreenWidth - 65, 10, 40, 20);
    }else if (iPhone6Plus) {
        KCLabel.frame = CGRectMake(90, 10, 100, 20);
        JGLabel.frame = CGRectMake(MainScreenWidth - 65, 10, 40, 20);
    }

    
}

- (void)allXZ:(UIButton *)button {
    
    isXZ = !isXZ;
    int HH;
    HH = 0;
    
    for (int i = 0 ; i < _ZTArray.count ; i ++) {
        
        if (isXZ == YES) {
             [_ZTArray replaceObjectAtIndex:i withObject:@"1"];
                [button setBackgroundImage:[UIImage imageNamed:@"check .png"] forState:UIControlStateNormal];
             [_idArray removeAllObjects]; //这里应该清空ID数组
            //将全部放进id数据里面去
            
            
        } else {
               [_ZTArray replaceObjectAtIndex:i withObject:@"0"];
                [button setBackgroundImage:[UIImage imageNamed:@"check 拷贝.png"] forState:UIControlStateNormal];
            //清空ID数据
            [_idArray removeAllObjects];
            NSLog(@"%@",_idArray);
            
            //显示金额
            HH = 0;
            
        }
       
        
    }
    
    if (isXZ == YES) {//应该吧所有的ID加进去，然后算出总共需要多少钱
      
        for (int i = 0; i < self.muArr.count; i ++) {
            
            [_idArray addObject:_shopArray[i][@"video_id"]];
            NSLog(@"-----%@",_idArray);
            //             self.sum.text = [NSString stringWithFormat:@"¥%ld币",(long)priceNum];
            
            
            HH = [_shopArray[i][@"price"] integerValue] + HH;
            NSLog(@"%d",HH);
            _SYGSum = HH;
        }
        
    }

    self.sum.text = [NSString stringWithFormat:@"¥%d币",HH];
    NSLog(@"----%@",_ZTArray);
    [_tableView reloadData];
    
}

//结算试图
- (void)addJSView {
    UIView *JSView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 60, MainScreenWidth, 60)];
    JSView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:JSView];
    
    //添加结算按钮
//    UIButton *KYButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
//    [KYButton setBackgroundImage:[UIImage imageNamed:@"check 拷贝.png"] forState:UIControlStateNormal];
//    [KYButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
//    [KYButton addTarget:self action:@selector(enter:) forControlEvents:UIControlEventTouchUpInside];
//    [JSView addSubview:KYButton];
    
    UIButton *JSButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 80, 10, 60, 40)];
    [JSButton setTitle:@"结算" forState:UIControlStateNormal];
    JSButton.backgroundColor = [UIColor redColor];
    [JSButton addTarget:self action:@selector(account:) forControlEvents:UIControlEventTouchUpInside];
    JSButton.layer.cornerRadius = 5;
    [JSView addSubview:JSButton];
    _JSButton = JSButton;
//    _JSButton.enabled = NO;
//    _JSButton.alpha = 0.4;
    
    //合计
    UILabel *HJLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 15, 70, 30)];
    HJLabel.text = @"合计：";
    [JSView addSubview:HJLabel];
    
    //预算元
    UILabel *sumLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 15, 100, 30)];
    sumLabel.text = @"¥0币";
    [JSView addSubview:sumLabel];
    _sum = sumLabel;
    

}



//获取自己的购物车
-(void)rloadUserShoping
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    NSArray *carArray = [myCar BJWithDic:dic];
    
    [manager UserShopingCar:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"^%@",responseObject);
        _allDic = responseObject;
        _HHHArray = responseObject[@"data"];
        if (carArray.count) {
            
        } else {
            if (![_HHHArray isEqual:[NSNull null]]) {
                //缓存数据
               [myCar saveBJes:responseObject[@"data"]];
                
            }

        }
        
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {
            [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
            self.tableView.alpha = 0;
            
            //隐藏_DHView
//            _DHView.hidden = YES;
            
            //空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 104, MainScreenWidth, MainScreenHeight - 104 - 60)];
            imageView.image = [UIImage imageNamed:@"购物车@2x"];
            [self.view addSubview:imageView];
            
            [_ZTArray addObject:@"0"];
            
            
            
            self.sum.text = @"0元";
        } else {
            _DHView.hidden = NO;//显示DHView
            
            self.muDic = responseObject[@"data"];
            _shopArray = responseObject[@"data"];
            NSLog(@"//%@",self.muDic);
            NSArray  *arr = [responseObject objectForKey:@"data"];
            _editArr = [[NSMutableArray alloc]initWithCapacity:0];
            for (int i = 0; i<arr.count; i++) {
                NSString *isEdit = @"0";
                [_editArr addObject:isEdit];
                SPBaseClass *spb = [[SPBaseClass alloc]initWithDictionary:[arr objectAtIndex:i]];
                [self.muArr addObject:spb];
                
                //将全部为0的数据加入状态数据中
                [_ZTArray addObject:@"0"];
            }
            
            [self.tableView reloadData];
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"err     %@",error);
        self.muArr = carArray;
        [_tableView reloadData];
    }];
}
//结算
-(void)settleUserDate
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    NSString *classIds = nil;
    for (int i = 0 ; i < _idArray.count ; i++) {
        
        if (i == 0) {
            classIds = _idArray[0];
        } else {
            classIds = [NSString stringWithFormat:@"%@,%@",classIds,_idArray[i]];
        }
        
    }
    
    
    NSLog(@"%@",_idArray);
    
    
    NSLog(@"----%@",classIds);
    if ([_allDic[@"data"] isEqual:[NSNull null]]) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"没有订单，不能结算" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alter show];
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alter repeats:YES];

    }else if (classIds == nil){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"没有选择订单，不能结算" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alter show];
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alter repeats:YES];

    }
    else {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
        [dic setObject:classIds forKey:@"vids"];
        NSLog(@"%@",dic);
        
        [manager settleUserShopingCar:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"^^%@",responseObject);
            NSString *msg = [responseObject objectForKey:@"msg"];
            if (![msg isEqual:@"ok"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];

            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"购买成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];

                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    
}
//删除 编辑购物车
-(void)delShopingCar:(NSInteger)indexRow;
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    SPBaseClass *spb = [[SPBaseClass alloc]init];
    spb = [self.muArr objectAtIndex:indexRow];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:spb.videoId forKey:@"videoIds"];
    [manager delUserShopingCar:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"$$$%@",responseObject);
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([msg isEqualToString:@"ok"]) {
            msg = @"删除成功";
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];
        }
       

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.muArr.count==0) {
        _txLab.textColor = [UIColor colorWithHexString:@"#dedede"];
    }else{
        
        _txLab.textColor = [UIColor clearColor];
    }
    NSLog(@"%ld",self.muArr.count);
    return self.muArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Cell";
    MyShopingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        NSArray *cellArr = [[NSBundle mainBundle]loadNibNamed:@"MyShopingCarCell" owner:nil options:nil];
        cell = [cellArr objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSString *edit = [_editArr objectAtIndex:indexPath.row];
    [cell.stateBtn setIsPressed:[edit intValue]];
    if (isEditing == YES ) {
        cell.stateBtn.hidden = YES;
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:cell.bookName attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeLeading multiplier:1.0f constant:43.0f];
        [cell addConstraint:constraint];
    }else
    {
        cell.stateBtn.hidden = NO;
    }
    SPBaseClass *spb= [self.muArr objectAtIndex:indexPath.row];
    
    cell.stateBtn.tag = indexPath.row;
    
    if ([_ZTArray[indexPath.row] intValue]==1) {
        [cell.stateBtn setBackgroundImage:[UIImage imageNamed:@"check .png"] forState:UIControlStateNormal];
    }
    else{
       [cell.stateBtn setBackgroundImage:[UIImage imageNamed:@"check 拷贝.png"] forState:UIControlStateNormal];
    }

    
    [cell.stateBtn addTarget:self action:@selector(btnState:) forControlEvents:UIControlEventTouchUpInside];
    cell.bookName.text = [NSString stringWithFormat:@"%@",spb.videoInfo.videoTitle];
    cell.price.text = [NSString stringWithFormat:@"%@元",spb.price];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
-(void)btnState:(MyUIButton *)btn
{
    
    
    SPBaseClass *spb;
    NSMutableArray *tagArr = [[NSMutableArray alloc]init];
    NSString *btag = [NSString stringWithFormat:@"%ld",(long)btn.tag];

    if (isEditing == NO) {
        btn.isClick = !btn.isClick;
        if (btn.isClick == YES) {
            spb = [self.muArr objectAtIndex:btn.tag];
            NSLog(@"%@",spb.videoId);
            
            [_idArray addObject:spb.videoId];
            
            NSLog(@"%@",_idArray);
            NSString *edit = @"1";
            [_editArr replaceObjectAtIndex:btn.tag withObject:edit];
            priceNum = priceNum +[spb.price intValue];
            [self.addDic setObject:btag forKey:btag];
            [btn setBackgroundImage:[UIImage imageNamed:@"check .png"] forState:0];
            [tagArr addObject:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
            
        }else if(btn.isClick == NO)
        {
            
            spb = [self.muArr objectAtIndex:btn.tag];
            [_idArray removeObject:spb.videoId];
            NSString *edit = @"0";
            [_editArr replaceObjectAtIndex:btn.tag withObject:edit];
            priceNum = priceNum-[spb.price intValue];
            self.sum.text = [NSString stringWithFormat:@"   ¥%ld币",(long)priceNum];
            [self.addDic removeObjectForKey:btag];
            [btn setBackgroundImage:[UIImage imageNamed:@"check 拷贝.png"] forState:0];

        }
        
        self.sum.text = [NSString stringWithFormat:@"¥%ld币",(long)priceNum];
        
        NSLog(@"%@",_idArray);
    }
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"index %ld",(long)indexPath.row);
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self delShopingCar:indexPath.row];
        [self.muArr removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSIndexSet * set =[NSIndexSet indexSetWithIndex:indexPath.section];
        //NSIndexSet－－索引集合
        [tableView reloadSections:set withRowAnimation:UITableViewRowAnimationBottom];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {}
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)btnClick
{
    //没有订单的时候
    if ([_allDic[@"data"] isEqual:[NSNull null]]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"没有订单，并不能随便玩耍" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(timerFireMethod:) userInfo:alert repeats:YES];

    }
    
    isEditing =!isEditing;
    if (isEditing == YES) {
        [self.tableView setEditing:YES];
    }else
    {
        [self.tableView setEditing:NO];
    }
    
    [self.tableView reloadData];
    
}

- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}

- (void)enter:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    isEnter = !isEnter;
    if (isEnter == YES) {
        [btn setBackgroundImage:[UIImage imageNamed:@"check .png"] forState:0];
        self.enterBtn.enabled = YES;
        self.enterBtn.alpha = 1.0;
        _JSButton.enabled = YES;
        _JSButton.alpha = 1;
    }else
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"check 拷贝.png"] forState:0];
        self.enterBtn.enabled = YES;
        self.enterBtn.alpha = 0.4;
        _JSButton.enabled = NO;
        _JSButton.alpha = 0.4;
    }
}
- (void)account:(id)sender
{
    [self settleUserDate];
}


@end
