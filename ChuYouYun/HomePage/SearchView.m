//
//  SearchView.m
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/2/26.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define Start_X 20.0f           // 第一个按钮的X坐标
#define Start_Y 60.0f           // 第一个按钮的Y坐标
#define Width_Space 10.0f        // 2个按钮之间的横间距
#define Height_Space 10.0f      // 竖间距
#define Button_Height 35.0f    // 高
#define Button_Width 87.0f      // 宽
#import "searchCourseVC.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "MyHttpRequest.h"
#import "UIImageView+WebCache.h"
#import "classTableViewCell.h"
#import "teacherList.h"
#import "classDetailVC.h"
#import "MJRefresh.h"
#import "UIButton+WebCache.h"
#import "QuizDetailViewController.h"
#import "WDTableViewCell.h"
#import "SYGWDViewController.h"

#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))


#import "SearchView.h"
#import "HotViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "questionsCell.h"
#import "Passport.h"
#import "emotionjiexi.h"
#import "SYG.h"
#import "MBProgressHUD+Add.h"




@interface SearchView ()<UISearchBarDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITextField * searchBar;
    UIButton * cancelButton;
    UIButton *tagBtn;
    UIView * tagView;
    UITableView * _tableView;
}

@property(nonatomic,assign)NSInteger numder;
@end

@implementation SearchView
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    self.navigationController.navigationBar.hidden = YES;
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    self.navigationController.navigationBar.hidden = NO;
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    view.backgroundColor = [UIColor whiteColor];
    view.userInteractionEnabled = YES;
//    view.image = [UIImage imageNamed:@"options.png"];
    [self.view addSubview:view];
    
    searchBar = [[UITextField alloc]initWithFrame:CGRectMake(10, 25, MainScreenWidth-120, 30)];
    searchBar.delegate = self;
    searchBar.placeholder = @" 搜索感兴趣的问答...";
    searchBar.font = [UIFont boldSystemFontOfSize:14];
    searchBar.textAlignment = NSTextAlignmentLeft;
    searchBar.borderStyle = UITextBorderStyleNone;
    searchBar.layer.cornerRadius = 5;
    searchBar.layer.masksToBounds = YES;
    searchBar.textColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1];
    searchBar.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    UIImageView * searchImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    searchImg.image = [UIImage imageNamed:@"Search1.png"];
    searchBar.leftView = searchImg;
    searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchBar.leftViewMode = UITextFieldViewModeAlways;
    [view addSubview:searchBar];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 + 30 + 8) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.rowHeight = 152;
    _tableView.showsVerticalScrollIndicator =
    NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    //添加曲取消按钮
    //添加取消按钮
    UIButton *QXButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50, 32, 40, 17)];
    [QXButton setTitle:@"取消" forState:UIControlStateNormal];
    [QXButton addTarget:self action:@selector(mm) forControlEvents:UIControlEventTouchUpInside];
    [QXButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [view addSubview:QXButton];

    
    //创建搜索、取消按钮
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(MainScreenWidth-110, 32, 40, 17);
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancelButton setTitle:@"搜索" forState:UIControlStateNormal];
    [cancelButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(searchBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelButton];
    
}

- (void)mm {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [textField becomeFirstResponder];
    if ([textField.text isEqualToString:@"\n"]){
        return NO;
    }
    return YES;
}

#pragma mark--请求数据
-(void)requestData
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:searchBar.text forKey:@"str"];
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"30" forKey:@"count"];
    
    [manager searchQuestion:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"--%@",responseObject);
       _array = [responseObject objectForKey:@"data"];
        if([responseObject[@"data"] isEqual:[NSNull null]]) {
            [MBProgressHUD showError:@"没有问答啦" toView:self.view];
            return ;
        } else if (_array.count == 0) {
            [MBProgressHUD showError:@"没有搜索到" toView:self.view];
            return ;
        } else{
            _dataArray = responseObject[@"data"];
            self.muArr = responseObject[@"data"];
            [_tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"请检查网络" toView:self.view];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.muArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height + 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellStr = @"WDTableViewCell";
    WDTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (cell == nil) {
        cell = [[WDTableViewCell alloc] initWithReuseIdentifier:cellStr];
    }

    if ([self.muArr[indexPath.row][@"userface"] isEqual:[NSNull null]]) {
        
    }else {
        [cell.HeadImage sd_setBackgroundImageWithURL:[NSURL URLWithString:self.muArr[indexPath.row][@"userface"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"remen.png"]];
    }
    cell.HeadImage.clipsToBounds = YES;
    cell.HeadImage.layer.cornerRadius = 20.0;
    cell.NameLabel.text = [[self.muArr objectAtIndex:indexPath.row] stringValueForKey:@"uname"];
    cell.TimeLabel.text = [[self.muArr objectAtIndex:indexPath.row] stringValueForKey:@"ctime"];
    
    [cell setIntroductionText:[[self.muArr objectAtIndex:indexPath.row] stringValueForKey:@"wd_description"]];
    //图片
    
    cell.GKLabel.text = [[self.muArr objectAtIndex:indexPath.row] stringValueForKey:@"wd_browse_count"];
    cell.PLLabel.text = [[self.muArr objectAtIndex:indexPath.row] stringValueForKey:@"wd_comment_count"];
    cell.JTLabel.text = [[self.muArr objectAtIndex:indexPath.row] stringValueForKey:@"wd_description"];
    
    NSString *JTStr = [Passport filterHTML:[[self.muArr objectAtIndex:indexPath.row] stringValueForKey:@"wd_description"]];
    cell.JTLabel.text = [NSString stringWithFormat:@"%@",JTStr];
    cell.JTLabel.attributedText = [emotionjiexi jiexienmojconent:JTStr font:[UIFont systemFontOfSize:16]];
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"_________%@  ====  %@",self.muArr,[[self.muArr objectAtIndex:indexPath.row] class]);
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:[self.muArr objectAtIndex:indexPath.row]];
    NSString *userId = [dic stringValueForKey:@"id"];
    NSString *title = [dic stringValueForKey:@"wd_title"];
    NSString *description = [dic stringValueForKey:@"wd_description"];
    NSString *uname = [dic stringValueForKey:@"uname"];
    NSString *userFace = [dic stringValueForKey:@"userface"];
    NSString *ctime = [dic stringValueForKey:@"ctime"];
    
    SYGWDViewController *vc = [[SYGWDViewController alloc] initWithQuizID:userId title:title description:description uname:uname userface:userFace ctime:ctime];
    [self.navigationController pushViewController:vc animated:YES];
    
}
//
#pragma UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [cancelButton setTitle:@"搜索" forState:UIControlStateNormal];
}

#pragma mark------点击搜索按钮
- (void)searchBtn {
    if (searchBar.text.length!=0) {
        [self requestData];
    } else {
        [MBProgressHUD showError:@"请输入关键字" toView:self.view];
        return;
    }
}

#pragma mark --- 滚动视图

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [searchBar resignFirstResponder];
}

//点击屏幕  键盘收回
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [searchBar resignFirstResponder];
//    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.view endEditing:YES];
}

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
    // NSString * regEx = @"<([^>]*)>";
    // html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}





@end
