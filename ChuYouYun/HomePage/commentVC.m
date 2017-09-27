//
//  commentVC.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/1/30.
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


#import "commentVC.h"
#import "commtenCell.h"
#import "MyHttpRequest.h"
#import "courseNoteModel.h"
#import "UIImageView+WebCache.h"
#import "ComentViewController.h"
#import "SYGDPViewController.h"
#import "SYGDPTableViewCell.h"
#import "UIButton+WebCache.h"
#import "DLViewController.h"
#import "UIColor+HTMLColors.h"
#import "BigWindCar.h"


#import "BigWindCar_CommentCell.h"


@interface commentVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    NSArray * dataArray;
    NSDictionary *dict;
    UILabel *_lable;
    
}

@property (strong ,nonatomic)UIImageView *imageView;

@end

@implementation commentVC
- (id)initWithId:(NSString *)Id
{
    if (self=[super init]) {
        _course_id = Id;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ViewBackColor;
    if (iPhone4SOriPhone4) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-290+145 - 200 - 3 + 15) style:UITableViewStylePlain];
    }
    if (iPhone5o5Co5S) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-300+145 - 200 - 3 + 15) style:UITableViewStylePlain];
    }
    else if (iPhone6)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-380+145 - 200 - 3 + 6) style:UITableViewStylePlain];
    }
    else if (iPhone6Plus)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-430+145 - 200 - 3 + 8) style:UITableViewStylePlain];
    }else {//ipad 适配
         _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-730+145 - 200 + 50) style:UITableViewStylePlain];
    }


//    //添加点评按钮
//    UIButton *commentButton = [[UIButton alloc] init];
//    commentButton.frame = CGRectMake(MainScreenWidth - 30,0,20,20);
//    [commentButton setBackgroundImage:[UIImage imageNamed:@"Write"] forState:UIControlStateNormal];
//    [commentButton addTarget:self action:@selector(commentbutton) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:commentButton];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    _tableView.bounces = YES;
    _tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    _lable= [[UILabel alloc]initWithFrame:CGRectMake(0,50*MainScreenHeight/667,MainScreenWidth, 12)];
    [_tableView insertSubview:_lable atIndex:0];
    _lable.text = @"数据为空，刷新重试";
    _lable.textAlignment = NSTextAlignmentCenter;
    _lable.textColor = [UIColor colorWithHexString:@"#dedede"];
    _lable.font = [UIFont systemFontOfSize:14];
    [_tableView insertSubview:_lable atIndex:0];

    [self requestData];
}

- (void)requestData
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"100" forKey:@"count"];
    [dic setValue:_course_id forKey:@"kzid"];
    [dic setValue:@"1" forKey:@"kztype"];
    [dic setValue:@"2" forKey:@"type"];
    [manager getClassNoteAndQuestionAndComment:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        if ([responseObject[@"data"] isEqual:[NSNull null]]) {
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 50)];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 200)];
            imageView.image = [UIImage imageNamed:@"点评@2x"];
            [view addSubview:imageView];
            
            _tableView.tableFooterView = view;
            _imageView = imageView;
        } else {
            //移除视图
            [_imageView removeFromSuperview];
            _imageView.hidden = YES;
            dataArray = responseObject[@"data"];
            
        }
        
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton * v_headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    v_headerBtn.frame = CGRectMake(MainScreenWidth-70, 10, 85, 22);
    UIView *v_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 30)];//创建一个视图（v_headerView）
    [v_headerBtn setImage:[UIImage imageNamed:@"552cc17f5bb87_32@2x.png"] forState:UIControlStateNormal];
    [v_headerBtn addTarget:self action:@selector(MakeCommentBtn) forControlEvents:UIControlEventTouchUpInside];
    [v_headerView addSubview:v_headerBtn];
    return v_headerView;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (IsNilOrNull(dataArray)) {
        return 0;
    }
    if (dataArray.count==0) {
        _lable.textColor = [UIColor colorWithHexString:@"#dedede"];
        
    }else{
        _lable.textColor = [UIColor clearColor];
    }
    return dataArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    courseNoteModel * list = dataArray[indexPath.row];
//    NSString * labelstr = list.review_description;
//    
//    CGSize labelSize = {0,0};
//    labelSize = [labelstr sizeWithFont:[UIFont systemFontOfSize:14]
//                 
//                     constrainedToSize:CGSizeMake(225.0, 5000)
//                 
//                         lineBreakMode:NSLineBreakByWordWrapping];
//    return labelSize.height+90;
    
//    UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height + 40;
    return 100;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString * cellStr = @"cellSYG";
   BigWindCar_CommentCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (cell == nil) {
        cell = [[BigWindCar_CommentCell alloc] initWithReuseIdentifier:cellStr];
    }
    
    NSDictionary *dcit = dataArray[indexPath.row];
    [cell dataSourceWith:dcit];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma ------点赞
- (void)DZClicked:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    courseNoteModel * list = dataArray[btn.tag];
    int c=[list.isvote intValue];
    if (c==1) {
        QKHTTPManager * manager = [QKHTTPManager manager];
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:list.review_id forKey:@"kzid"];
        [dic setValue:@"1" forKey:@"type"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
        [manager getClassIsvote:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"********%@",responseObject);
            dict = responseObject[@"data"];
            NSLog(@"**%@",dict);
            [self requestData];
            [_tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"oh");
        }];
    }
    else if (c==0)
    {
        QKHTTPManager * manager = [QKHTTPManager manager];
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:list.review_id forKey:@"kzid"];
        [dic setValue:@"0" forKey:@"type"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
        [manager getClassIsvote:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"----%@",dic);
            NSLog(@"++++++++++++%@",responseObject);
            NSLog(@"%@",responseObject[@"msg"]);
            [self requestData];
            [_tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"ohk");
        }];

    }
}


#pragma mark - 让每个分区headerView一起滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView)
    {
        CGFloat sectionHeaderHeight = 40;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}


- (void)MakeCommentBtn
{

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;

    }
    
    SYGDPViewController *SYGDPVC = [[SYGDPViewController alloc] init];
    UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:SYGDPVC];
    SYGDPVC.ID = _course_id;
    [self.navigationController presentViewController:Nav animated:YES completion:nil];
    
    
}







@end
