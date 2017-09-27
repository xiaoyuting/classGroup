//
//  DAViewController.m
//  DAContextMenuTableViewControllerDemo
//
//  Created by Daria Kopaliani on 7/24/13.
//  Copyright (c) 2013 Daria Kopaliani. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width



#import "DAViewController.h"
#import "MJRefresh.h"
#import "DAContextMenuCell.h"
#import "ZhiyiHTTPRequest.h"
#import "QBaseClass.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "QuizDetailViewController.h"
#import "SYGWDViewController.h"
#import "myQuestion.h"
#import "myAnswer.h"


@interface DAViewController ()
{
    CGRect rect;
}
@property (assign, nonatomic) NSInteger rowsCount;
@property (strong ,nonatomic)UILabel  *lbl;
@property (strong ,nonatomic)UIImageView *imageView;
@property (strong ,nonatomic)NSDictionary *myDic;
@property (strong ,nonatomic)NSArray *XXArray;

@property (strong ,nonatomic)NSArray *questionArray;

@property (strong ,nonatomic)NSArray *answerArray;

@end


@implementation DAViewController

- (id)init
{
    if (self=[super init]) {
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    
//    [self.tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
//    [self.tableView headerBeginRefreshing];

}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self information];
    rect = [UIScreen mainScreen].applicationFrame;
    self.navigationController.title = @"问答";
    self.tableView.showsVerticalScrollIndicator = NO;
//    self.tableView.allowsSelection = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView reloadData];

    [self.tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [self.tableView headerBeginRefreshing];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,10,0,0)];
    }
    
    //设置表格分割线的长度（跟两边的距离）
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,10,0,0)];
    }
    
    
}
- (void)headerRerefreshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self requestData:@"me"];
        [self.tableView headerEndRefreshing];
        [self.tableView reloadData];
    });
}
-(void)requestData:(NSString *)type
{
    _type = type;
    NSLog(@"-----%@",type);
    self.muArr = [[NSMutableArray alloc]initWithCapacity:0];
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic =  [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
//    [dic setObject:_type forKey:@"type"];
    NSLog(@"%@",dic);
    NSArray *myQuestionArray = [myQuestion BJWithDic:dic];
    NSArray *myAnswerArray = [myAnswer BJWithDic:dic];
    
    if ([_type isEqualToString:@"me"]) {
        
        [manager MYQestion:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"^^^^^%@",responseObject);
            _XXArray = responseObject[@"data"];
            _questionArray = responseObject[@"data"];
            NSLog(@"%@",responseObject[@"msg"]);
            if (myQuestionArray.count) {
                
            } else {
                [myQuestion saveBJes:_questionArray];
            }
            
            if (_XXArray.count == 0) {//没有内容的时候
                //添加空白处理
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 64)];
                if ([_type isEqualToString:@"me"]) {
                    imageView.image = [UIImage imageNamed:@"问答-问题@2x"];
                }else {
                    imageView.image = [UIImage imageNamed:@"问答-回答@2x"];
                }
                [self.view addSubview:imageView];
                _imageView = imageView;
                _imageView.hidden = NO;
                
                
            } else {
                self.tableView.alpha = 1.0;
                _imageView.hidden = YES;
                NSArray *Arr = [responseObject objectForKey:@"data"];
                for (int i = 0; i<Arr.count; i++) {
                    NSDictionary *dic = [Arr objectAtIndex:i];
                    QBaseClass *qb = [[QBaseClass alloc]initWithDictionary:dic];
                    [self.muArr addObject:qb];
                }
                [self.tableView reloadData];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog ( @"operation1: %@" , operation. responseString);
            _XXArray = _questionArray;
            [self.tableView reloadData];
        }];

        
    }else {
        
        [manager MYAnsder:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"^^^^^%@",responseObject);
            _XXArray = responseObject[@"data"];
            _answerArray = responseObject[@"data"];
            NSLog(@"%@",responseObject[@"msg"]);
            
            if (myAnswerArray.count) {
                
            } else {
                [myAnswer saveBJes:_answerArray];
            }
            
            if (_XXArray.count == 0) {//没有内容的时候
                //添加空白处理
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 64)];
                if ([_type isEqualToString:@"me"]) {
                    imageView.image = [UIImage imageNamed:@"问答-问题@2x"];
                }else {
                    imageView.image = [UIImage imageNamed:@"问答-回答@2x"];
                }
                [self.view addSubview:imageView];
                _imageView = imageView;
                _imageView.hidden = NO;
                
                
            } else {
                self.tableView.alpha = 1.0;
                _imageView.hidden = YES;
                _imageView.alpha = 0;
                [_imageView removeFromSuperview];
                [_imageView removeFromSuperview];
                
                NSArray *Arr = [responseObject objectForKey:@"data"];
                for (int i = 0; i<Arr.count; i++) {
                    NSDictionary *dic = [Arr objectAtIndex:i];
                    QBaseClass *qb = [[QBaseClass alloc]initWithDictionary:dic];
                    [self.muArr addObject:qb];
                }
                [self.tableView reloadData];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog ( @"operation2: %@" , operation. responseString);
            _XXArray = _answerArray;
            [self.tableView reloadData];
        }];

    }
    
}



#pragma mark * Table view data source

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return @"删除";
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.muArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    DAContextMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    QBaseClass *qb = [self.muArr objectAtIndex:indexPath.row];
//    cell.tag = indexPath.row;
//    cell.dateText.text = qb.strtime;
//    cell.questionsText.text = qb.qstTitle;
//    cell.peopleText.text = [NSString stringWithFormat:@"%@人回答",qb.qcount];
//    cell.delegate = self;
    cell.questionsText.text = _XXArray[indexPath.row][@"wd_description"];
    cell.dateText.text = _XXArray[indexPath.row][@"ctime"];
    cell.peopleText.text = [NSString stringWithFormat:@"%@人回答",_XXArray[indexPath.row][@"wd_comment_count"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%ld",indexPath.row);
      QBaseClass *qb = [self.muArr objectAtIndex:indexPath.row];
    
    //这里需要取出自己的头像和名字
    NSString *Name = _myDic[@"data"][@"uname"];
    NSString *Face = _myDic[@"data"][@"avatar_big"];
    NSLog(@"-----%@",qb.qstDescription);
    NSString *qstDescription = _XXArray[indexPath.row][@"wd_description"];
    
    SYGWDViewController *SYGVC = [[SYGWDViewController alloc] initWithQuizID:qb.internalBaseClassIdentifier title:qb.qstTitle description:qstDescription uname:Name userface:Face ctime:qb.ctime];
    [self.navigationController pushViewController:SYGVC animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self delDataAtIndex:indexPath.row];
        [self.muArr removeObjectAtIndex:indexPath.row];
        
        
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSIndexSet * set =[NSIndexSet indexSetWithIndex:indexPath.section];
        //NSIndexSet－－索引集合
        [tableView reloadSections:set withRowAnimation:UITableViewRowAnimationBottom];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}
-(void)delDataAtIndex:(NSInteger)row
{
    __block NSString *deltype;
    NSLog(@"+++++%@",_type);
//    if ([_type isEqual:@"me"]) {
        QBaseClass *qb = [[QBaseClass alloc]init];
        qb = [self.muArr objectAtIndex:row];
        ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];

        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];

        [dic setObject:qb.internalBaseClassIdentifier forKey:@"id"];
        [manager delMyAnswer:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            NSString *msg = [responseObject objectForKey:@"msg"];
            NSLog(@"msg     %@",msg);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
                deltype = msg;

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
//    }
}

#pragma mark * DAContextMenuCell delegate

- (void)contextMenuCellDidSelectDeleteOption:(DAContextMenuCell *)cell
{
        [self delDataAtIndex:cell.tag];
        [super contextMenuCellDidSelectDeleteOption:cell];
        [self.muArr removeObjectAtIndex:cell.tag];
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:cell.tag inSection:0];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView reloadData];
}
- (void)contextMenuCellDidSelectMoreOption:(DAContextMenuCell *)cell
{
    QBaseClass *qb = [self.muArr objectAtIndex:cell.tag];
    QuizDetailViewController *q = [[QuizDetailViewController alloc]initWithQuizID:qb.internalBaseClassIdentifier];
    [self.navigationController pushViewController:q animated:YES];
}



- (void)information {//获取到用户的资料
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"User_id"] forKey:@"user_id"];
    NSLog(@"%@",dic);
    
    
    [manager userShow:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"66^^^^%@",responseObject);
        _myDic = responseObject;
        
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    
    
}





@end
