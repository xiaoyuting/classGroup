//
//  searchCourseVC.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/9.
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
#import "SYGClassTableViewCell.h"
#import "UIButton+WebCache.h"
#import "SYG.h"

#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

@interface searchCourseVC ()<UISearchBarDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITextField * searchBar;
    UIButton * cancelButton;
    UIButton *tagBtn;
    UIView * tagView;
    UITableView * _tableView;
}
@property(nonatomic,assign)NSInteger numder;

@property (strong ,nonatomic)UIImageView *imageView;

@end

@implementation searchCourseVC
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    self.navigationController.navigationBar.hidden = YES;
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
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
    searchBar.placeholder = @" 搜索感兴趣的课程...";
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
    
    //添加取消按钮
    UIButton *QXButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50, 32, 40, 17)];
    [QXButton setTitle:@"取消" forState:UIControlStateNormal];
    [QXButton addTarget:self action:@selector(mm) forControlEvents:UIControlEventTouchUpInside];
    [QXButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [view addSubview:QXButton];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 28) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 110;
    _tableView.showsVerticalScrollIndicator =
    NO;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

    
    //创建搜索、取消按钮
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(MainScreenWidth-110, 32, 40, 17);
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancelButton setTitle:@"搜索" forState:UIControlStateNormal];
    [cancelButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(searchBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelButton];
    
    
//    //创建推荐标签View
//     tagView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, MainScreenWidth, 200)];
//    tagView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
//    tagView.userInteractionEnabled = YES;
//    [self.view addSubview:tagView];
//    
//    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, MainScreenWidth-20, 50)];
//    label.text = @"推荐标签";
//    label.textAlignment = UITextAlignmentLeft;
//    label.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
//    [tagView addSubview:label];
//    
//    for (int i = 0 ; i < 6; i++) {
//        NSInteger index = i % 3;
//        NSInteger page = i / 3;
//        
//        // 圆角按钮
//        tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [tagBtn setTitle:@"PHP" forState:UIControlStateNormal];
//        tagBtn.backgroundColor = [UIColor whiteColor];
//        [tagBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        tagBtn.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
//        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        tagBtn.layer.borderColor = [UIColor colorWithRed:208/255 green:208/255 blue:208/255 alpha:1].CGColor;
//        tagBtn.layer.borderWidth = 1;
//        [tagView addSubview:tagBtn];
//    }
}

- (void)mm {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
//    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
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
    [manager searchCourse:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"-----%@",responseObject);
        
        NSMutableArray * array = [responseObject objectForKey:@"data"];
        if(IsNilOrNull(array))
        {
            
            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
            _imageView.image = [UIImage imageNamed:@"搜索课程@2x"];
            [self.view addSubview:_imageView];
            _imageView.hidden = NO;
            _dataArray = nil;

            
        }
        else{
            _imageView.hidden = YES;
//            NSMutableArray * listArr = [[NSMutableArray alloc]initWithCapacity:0];
//            for (int i=0; i<array.count; i++) {
//                teacherList * list = [[teacherList alloc]initWithDictionarys:array[i]];
//                [listArr addObject:list];
//            }
            _dataArray = responseObject[@"data"];
            [_tableView reloadData];
        }
        [_tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellStr = @"SYGClassTableViewCell";
    SYGClassTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[SYGClassTableViewCell alloc] initWithReuseIdentifier:cellStr];
        
    }
    
    
    [cell.imageButton setBackgroundImage:[UIImage imageNamed:@"站位图"] forState:UIControlStateNormal];
    [cell.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_dataArray[indexPath.row][@"imageurl"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"站位图"]];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"video_title"]];
    cell.contentLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"video_intro"]];
    cell.GKLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"video_order_count"]];
    cell.XBLabel.text = [NSString stringWithFormat:@"%@  元",_dataArray[indexPath.row][@"price"]];
    
    
    NSString *MoneyStr = [NSString stringWithFormat:@"%@  元",_dataArray[indexPath.row][@"price"]];
    NSString *XBStr = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"price"]];
    //变颜色
    NSMutableAttributedString *needStr = [[NSMutableAttributedString alloc] initWithString:MoneyStr];
    [needStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1] range:NSMakeRange(0, XBStr.length)];
    //设置字体加错
    [needStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, XBStr.length)];
    [needStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, XBStr.length)];
    
    [cell.XBLabel setAttributedText:needStr] ;
    
    
    NSString * starStr = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"video_score"]];
    float length = [starStr floatValue];
    if (length == 2) {
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"2star"] forState:UIControlStateNormal];
    }else {
        
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"3star"] forState:UIControlStateNormal];
    }
    
    if (length == 3) {
        
        [cell.XJButton setBackgroundImage:[UIImage imageNamed:@"3star"] forState:UIControlStateNormal];
    }
    

    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *Cid = _dataArray[indexPath.row][@"id"];
    NSString *Price = _dataArray[indexPath.row][@"price"];
    NSString *Title = _dataArray[indexPath.row][@"video_title"];
    NSString *VideoAddress = _dataArray[indexPath.row][@"video_address"];
    NSString *ImageUrl = _dataArray[indexPath.row][@"imageurl"];
    
    classDetailVC * cvc = [[classDetailVC alloc]initWithMemberId:Cid andPrice:Price andTitle:Title];
    cvc.videoTitle = Title;
    cvc.img = ImageUrl;
    cvc.video_address = VideoAddress;
    [self.navigationController pushViewController:cvc animated:YES];

    
}

#pragma UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [cancelButton setTitle:@"搜索" forState:UIControlStateNormal];
}

#pragma mark------点击搜索按钮
- (void)searchBtn
{
//    if ([cancelButton.titleLabel.text isEqualToString:@"取消"]) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    else if([cancelButton.titleLabel.text isEqualToString:@"搜索"])
//    {
//        if (searchBar.text.length!=0) {
//            [self requestData];
//        }
//        else
//        {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入关键字" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
//            [alert show];
//            [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alert repeats:YES];
//            
//        }
//    }
    
    
    if (searchBar.text.length!=0) {
        [self requestData];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入关键字" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeAlert:) userInfo:alert repeats:YES];
        
    }

    
}


//点击屏幕  键盘收回
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [searchBar resignFirstResponder];
//    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.view endEditing:YES];
}


//移除警告框

- (void)removeAlert:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert = NULL;
}


@end
