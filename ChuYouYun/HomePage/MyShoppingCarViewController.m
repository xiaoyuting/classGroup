//
//  MyShoppingCarViewController.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/29.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "MyShoppingCarViewController.h"
#import "MyShopingCarCell.h"
#import "MyUIButton.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "ZhiyiHTTPRequest.h"
#import "SPBaseClass.h"
#import "SPVideoInfo.h"

@interface MyShoppingCarViewController ()
{
    BOOL isEditing;
    BOOL isEnter;
    NSInteger priceNum;
    CGRect rect;
}


@property (strong ,nonatomic)MyUIButton *button;

@property (strong ,nonatomic)NSMutableArray *idArray;

@property (strong ,nonatomic)UIButton *JSButton;

@end

@implementation MyShoppingCarViewController
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(-5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"点评返回@2x"] forState:UIControlStateNormal];
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
    rect = [UIScreen mainScreen].applicationFrame;
    self.muDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    self.enterBtn.enabled = NO;
    self.enterBtn.alpha = 0.4;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"操作" style:UIBarButtonItemStylePlain target:self action:@selector(btnClick)];
    self.muArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.addDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [self rloadUserShoping];
    isEditing = nil;
    priceNum = 0;
   
    NSLog(@"****%@",self.muDic);
    _idArray = [[NSMutableArray alloc] init];
 
}

//获取自己的购物车
-(void)rloadUserShoping
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];

    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [manager UserShopingCar:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"^%@",responseObject);
        _allDic = responseObject;
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {
            [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
            self.tableView.alpha = 0;
            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake((rect.size.width-200)/2, 70, 200, 21)];
            lbl.font = [UIFont systemFontOfSize:16];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.text = @"还没有宝贝，快去逛逛吧~";
            lbl.textColor = [UIColor colorWithRed:36.0/255.0 green:102.0/255.0 blue:167.0/255.0 alpha:1];
            [self.view addSubview:lbl];
            self.sum.text = @"0元";
        } else {
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
            }
          
            [self.tableView reloadData];

         
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"err     %@",error);
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
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:@"没有订单，不能结算" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alter show];
    } else {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
        [dic setObject:classIds forKey:@"vids"];
        NSLog(@"%@",dic);
        
        [manager settleUserShopingCar:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"^^%@",responseObject);
            NSString *msg = [responseObject objectForKey:@"msg"];
            if (![msg isEqual:@"ok"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"购买成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                
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
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
        cell.stateBtn.hidden = YES;
    }
    SPBaseClass *spb= [self.muArr objectAtIndex:indexPath.row];
    
        SPVideoInfo *spv = spb.videoInfo;
        cell.stateBtn.tag = indexPath.row;
        [cell.stateBtn addTarget:self action:@selector(btnState:) forControlEvents:UIControlEventTouchUpInside];
        cell.bookName.text = spv.videoTitle;
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

        self.sum.text = [NSString stringWithFormat:@"   ¥%ld币",(long)priceNum];

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
    isEditing =!isEditing;
    if (isEditing == YES) {
        [self.tableView setEditing:YES];
    }else
    {
        [self.tableView setEditing:NO];
    }
    
    [self.tableView reloadData];
    
}
- (IBAction)enter:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    isEnter = !isEnter;
    if (isEnter == YES) {
        [btn setBackgroundImage:[UIImage imageNamed:@"check .png"] forState:0];
        self.enterBtn.enabled = YES;
        self.enterBtn.alpha = 1.0;
    }else
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"check 拷贝.png"] forState:0];
        self.enterBtn.enabled = YES;
        self.enterBtn.alpha = 0.4;
    }
}
- (IBAction)account:(id)sender
{
    [self settleUserDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
