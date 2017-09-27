//
//  SCViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 16/3/9.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//


#define lineWrith 16 * 2
#define lineX (MainScreenWidth / 3 - lineWrith) / 2

#import "SCViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "SYGBlumTableViewCell.h"
#import "SYGClassTableViewCell.h"
#import "ZhiyiHTTPRequest.h"
#import "Passport.h"
#import "SBaseClass.h"
#import "CData.h"
#import "UIButton+WebCache.h"
#import "blumDetailVC.h"
#import "classDetailVC.h"
#import "mySCBlum.h"
#import "mySCClass.h"
#import "UIColor+HTMLColors.h"
#import "TIXingLable.h"
#import "MBProgressHUD+Add.h"
#import "LiveDetailsViewController.h"
#import "ZhiBoMainViewController.h"

#import "TopicXXTableViewCell.h"
#import "BigWindCar.h"
#import "TopicDetailViewController.h"
#import "MyLiveListViewController.h"
#import "GLLiveTableViewCell.h"
#import "ClassRevampCell.h"



@interface SCViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    NSMutableArray *_dataArr;
    NSInteger _number;
    CGRect rect;
    TIXingLable *_txLab;
    //直播的页数
    NSInteger _livenum;

}
@property (strong ,nonatomic)UIButton *seledButton;

@property (strong ,nonatomic)UILabel *HLabel;

@property (strong ,nonatomic)UITableView *blumTableView;
@property (strong ,nonatomic)UITableView *classTableView;
@property (strong ,nonatomic)UITableView *topicTableView;

@property (strong ,nonatomic)NSMutableArray *dataArray;
@property (strong ,nonatomic)NSArray *classArray;
@property (strong ,nonatomic)NSArray *topicArray;

@property (strong ,nonatomic)NSMutableArray *blumListArray;
@property (strong ,nonatomic)NSMutableArray *classListArray;

@property (strong ,nonatomic)NSString *actionStr;
@property (strong ,nonatomic)NSString *typeStr;
@property (strong ,nonatomic)NSDictionary *settingDic;
@property (strong ,nonatomic)NSString *topicID;

@property (strong ,nonatomic)NSString *UID;
@property (strong ,nonatomic)NSString *topicUID;
    
@property (strong ,nonatomic)UIView *commentView;
@property (strong ,nonatomic)UITextField *textField;

@end

@implementation SCViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self reloadDataBlum];
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
    [self interFace];
    [self addNav];
    [self addTitleView];
    [self addTableView];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    _UID = [[NSUserDefaults standardUserDefaults] objectForKey:@"User_id"];
    
}

- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, MainScreenWidth - 60, 24)];
    titleLab.text = @"我的收藏";
    [SYGView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.textColor = [UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 100, 24)];
    [backButton setImage:[UIImage imageNamed:@"GL返回"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,86)];
    [backButton setTitle:@" " forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:32.0/255 green:105.0/255 blue:207.0/255 alpha:1] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    //设置button上字体的偏移量
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10.0 , 0.0, 0)];
    [SYGView addSubview:backButton];
    //添加线
    UILabel *lineLab = [[UILabel  alloc] initWithFrame:CGRectMake(0, 63,MainScreenWidth, 1)];
    lineLab.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    [SYGView addSubview:lineLab];
    
    

}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTitleView {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, 48)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    
    NSArray *titleArray = @[@"直播",@"课程",@"话题"];
    for (int i = 0 ; i < 3 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0 + (i % 3) * MainScreenWidth / 3, 8, MainScreenWidth / 3, 30)];
        button.titleLabel.font = Font(16);
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:BasidColor forState:UIControlStateSelected];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:button];
        if (i == 0) {
            [self button:button];
        }
        
    }
    
    //添加横线
    UILabel *HLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineX, 38, lineWrith , 1)];
    HLabel.backgroundColor = BasidColor;
    [titleView addSubview:HLabel];
    _HLabel = HLabel;
    
}

- (void)button:(UIButton *)button {
    self.seledButton.selected = NO;
    button.selected = YES;
    self.seledButton = button;
    
    if (button.tag == 0) {//专辑
        _classTableView.hidden = YES;
        _blumTableView.hidden = NO;
        _topicTableView.hidden = YES;
        [self reloadDataBlum];
        [UIView animateWithDuration:0.1 animations:^{
            _HLabel.frame = CGRectMake(lineX, 38, lineWrith, 1);
        }];
        
    } else if (button.tag == 1) {//课程
        _blumTableView.hidden = YES;
        _classTableView.hidden = NO;
        _topicTableView.hidden = YES;
        [self reloadDataClass];
        [UIView animateWithDuration:0.1 animations:^{
            _HLabel.frame = CGRectMake(lineX + MainScreenWidth / 3, 38, lineWrith, 1);
        }];
    } else if (button.tag == 2) {
        _blumTableView.hidden = YES;
        _classTableView.hidden = YES;
        _topicTableView.hidden = NO;
        [self netWorkGetcollectTopic];
        [UIView animateWithDuration:0.1 animations:^{
            _HLabel.frame = CGRectMake(lineX + MainScreenWidth / 3 * 2, 38, lineWrith, 1);
        }];

    }
}

- (void)addTableView {
    _blumTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 112, MainScreenWidth, MainScreenHeight - 112 + 35) style:UITableViewStyleGrouped];
    _blumTableView.dataSource = self;
    _blumTableView.delegate = self;
    _blumTableView.rowHeight = 110;
    [self.view addSubview:_blumTableView];
//    _txLab = [[TIXingLable alloc]initWithFrame:CGRectMake(0, 100*MainScreenHeight/667, MainScreenWidth, 30)];
//    _txLab.textColor = [UIColor clearColor];
//    [_blumTableView insertSubview:_txLab atIndex:0];
    _blumTableView.hidden = NO;
    [_blumTableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    //上拉加载
//    [_blumTableView addFooterWithTarget:self action:@selector(footerRefreshing)];
//
//    [_blumTableView headerBeginRefreshing];
//    
//    if ([_blumTableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [_blumTableView setSeparatorInset:UIEdgeInsetsMake(0,5,0,0)];
//    }
//    
//    //设置表格分割线的长度（跟两边的距离）
//    if ([_blumTableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [_blumTableView setLayoutMargins:UIEdgeInsetsMake(0,2,0,0)];
//    }

    //添加课程的列表
    _classTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 112, MainScreenWidth, MainScreenHeight - 112 + 35) style:UITableViewStyleGrouped];
    _classTableView.dataSource = self;
    _classTableView.delegate = self;
    _classTableView.rowHeight = 110;
    [self.view addSubview:_classTableView];
    _classTableView.hidden = YES;
//    [_classTableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
//    [_classTableView headerBeginRefreshing];
    
    //话题表格
    _topicTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 112, MainScreenWidth, MainScreenHeight - 112 + 35) style:UITableViewStyleGrouped];
    _topicTableView.dataSource = self;
    _topicTableView.delegate = self;
    [self.view addSubview:_topicTableView];
//    [_topicTableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
//    [_topicTableView headerBeginRefreshing];
    _topicTableView.hidden = YES;
    _topicTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    if ([_classTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_classTableView setSeparatorInset:UIEdgeInsetsMake(0,5,0,0)];
    }
    
    //设置表格分割线的长度（跟两边的距离）
    if ([_classTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_classTableView setLayoutMargins:UIEdgeInsetsMake(0,2,0,0)];
    }
    
}
- (void)footerRefreshing
{
    //先隐藏
    _livenum++;
    [self reloadDataBlum];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_blumTableView reloadData];
        [_blumTableView footerEndRefreshing];
    });
}
- (void)headerRerefreshing
{
    _livenum = 1;
    [self reloadDataBlum];
    [self reloadDataClass];
    [self netWorkGetcollectTopic];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_classTableView reloadData];
        [_blumTableView reloadData];
        [_topicTableView reloadData];
        [_classTableView headerEndRefreshing];
        [_blumTableView headerEndRefreshing];
        [_topicTableView headerEndRefreshing];
        
        if ([_classArray isEqual:[NSNull null]]) {
        }else{
            if (_classArray.count==0) {
                _txLab.textColor = [UIColor colorWithHexString:@"#dedede"];

            }else{
                
            _txLab.textColor = [UIColor clearColor];
            }
        }
    });
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_classTableView.hidden == YES && _topicTableView.hidden == YES) {//直播
        if ([_dataArray isEqual:[NSNull null]]) {
                return 0;
            }else {
                return _dataArray.count;
            }

    } else if (_blumTableView.hidden == YES && _topicTableView.hidden == YES) {//课程
        if ([_classArray isEqual:[NSNull null]]) {
            return 0;
        }else {
            return _classArray.count;
        }
    } else if (_blumTableView.hidden == YES && _classTableView.hidden == YES) {
        return _topicArray.count;
    }
    return _topicArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_topicTableView.hidden == NO) {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    } else {
        return 110;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (_topicTableView.hidden == YES) {
//        return 10;
//        return 130;
//    } else {
//        return 5;
//        return 120;
//    }
//    return 70;
    
    if (_topicTableView.hidden == YES && _classTableView.hidden == YES) {
        return 0.05;
    } else if (_blumTableView.hidden == YES && _topicTableView.hidden == YES) {
        return 0.05;
    } else if (_blumTableView.hidden == YES && _classTableView.hidden == YES) {
        return 0.05;
    } else {
        return 0.05;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_classTableView.hidden == YES && _topicTableView.hidden == YES) {//直播
        static NSString *CellID = @"GLLiveTableViewCell";
        //自定义cell类
        ClassRevampCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        //自定义cell类
        if (cell == nil) {
            cell = [[ClassRevampCell alloc] initWithReuseIdentifier:CellID];
        }
        NSDictionary *dict = _dataArray[indexPath.row];
        [cell dataWithDict:dict withType:@"2"];

        return cell;

    } else if (_blumTableView.hidden == YES && _topicTableView.hidden == YES){//课程
        
        static NSString *CellID = @"ClassRevampCell";
        //自定义cell类
        ClassRevampCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        //自定义cell类
        if (cell == nil) {
            cell = [[ClassRevampCell alloc] initWithReuseIdentifier:CellID];
        }
        NSDictionary *dict = _classArray[indexPath.row];
        [cell dataWithDict:dict withType:@"1"];

//
        return cell;
    } else if (_blumTableView.hidden == YES && _classTableView.hidden == YES) {//话题
        
        static NSString *CellID = nil;
        CellID = [NSString stringWithFormat:@"cell%ld",indexPath.row];
        //自定义cell类
        TopicXXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        if (cell == nil) {
            cell = [[TopicXXTableViewCell alloc] initWithReuseIdentifier:CellID];
        }
        
        
        NSDictionary *dic = _topicArray[indexPath.row];
        [cell dataSourceWith:dic];

        [cell.setButton addTarget:self action:@selector(setButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
        cell.setButton.titleLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        [cell.PLButton addTarget:self action:@selector(plButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        
//        [cell.PLButton addTarget:self action:@selector(plButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        cell.setButton.hidden = YES;
        
        return cell;
    }
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_classTableView.hidden == YES && _topicTableView.hidden == YES) {
 

        NSString *Cid = _dataArray[indexPath.row][@"id"];
        NSString *Title = _dataArray[indexPath.row][@"video_title"];
        NSString *ImageUrl = _dataArray[indexPath.row][@"imageurl"];
        
        ZhiBoMainViewController *zhiBoMainVc = [[ZhiBoMainViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)indexPath.row andprice:_dataArray[indexPath.row][@"t_price"]];
        [self.navigationController pushViewController:zhiBoMainVc animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        

    } else if (_blumTableView.hidden == YES && _topicTableView.hidden == YES) {
        
        NSString *ID = _classListArray[indexPath.row][@"id"];
        NSString *price = _classListArray[indexPath.row][@"price"];
        NSString *title = _classListArray[indexPath.row][@"video_title"];
        
        classDetailVC *detailVc = [[classDetailVC alloc] initWithMemberId:ID andPrice:price andTitle:title];
        detailVc.videoTitle = title;
        detailVc.navigationItem.title = title;
        detailVc.img = _classListArray[indexPath.row][@"imageurl"];
        detailVc.video_address = _classListArray[indexPath.row][@"videoAddress"];
        [self.navigationController pushViewController:detailVc animated:YES];
        
    } else if (_blumTableView.hidden == YES && _classTableView.hidden == YES) {
        TopicDetailViewController *topDeVc = [[TopicDetailViewController alloc] init];
        [self.navigationController pushViewController:topDeVc animated:YES];
    }
}


#pragma mark --- cell 设置点击

//cell设置按钮事件
- (void)setButtonCilck:(UIButton *)button {
    NSInteger textNum = [button.titleLabel.text integerValue];
    _settingDic = _topicArray[textNum];
    _topicUID = _settingDic[@"uid"];
    _topicID = _settingDic[@"tid"];
    
    if ([_UID isEqualToString:_topicUID]) {//说明是自己的
        NSString *collectStr = @"收藏";
        NSString *topStr = @"置顶";
        NSString *distStr = @"精华";
        NSString *lockStr = @"锁定";
        
        if ([_settingDic[@"is_collect"] integerValue] == 1) {
            collectStr = @"取消收藏";
        }
        if ([_settingDic[@"top"] integerValue] == 1) {
            topStr = @"取消置顶";
        }
        if ([_settingDic[@"dist"] integerValue] == 1) {
            distStr = @"取消精华";
        }
        if ([_settingDic[@"lock"] integerValue] == 1) {
            lockStr = @"取消锁定";
        }
        
        UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:collectStr otherButtonTitles:topStr,distStr,lockStr,@"删除", nil];
        action.delegate = self;
        [action showInView:self.view];

    } else {//别人的
        UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"取消收藏", nil];
        action.delegate = self;
        [action showInView:self.view];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //不是自己的时候
    if (![_UID isEqualToString:_topicUID]) {
        if (buttonIndex == 0) {//取消收藏
            _actionStr = @"2";
            _typeStr = @"collect";
            [self netWorkSettingTopic];
            return;
        } else {
            return;
        }
    }
    
    _actionStr = @"1";

    if (buttonIndex == 0) {//收藏
        _typeStr = @"collect";
        if ([_settingDic[@"is_collect"] integerValue] == 1) {
            _actionStr = @"2";
        }
    }else if (buttonIndex == 1) {//置顶
        _typeStr = @"top";
        if ([_settingDic[@"top"] integerValue] == 1) {
            _actionStr = @"2";
        }
    } else if (buttonIndex == 2) {//精华
        _typeStr = @"dist";
        if ([_settingDic[@"dist"] integerValue] == 1) {
            _actionStr = @"2";
        }
    } else if (buttonIndex == 3) {//锁定
        _typeStr = @"lock";
        if ([_settingDic[@"lock"] integerValue] == 1) {
            _actionStr = @"2";
        }
    } else if (buttonIndex == 4){
        [self netWorkDeleteTopic];
        return;
    } else {
        return;
    }
    [self netWorkSettingTopic];
}

- (void)plButtonClick:(UIButton *)button {
    _topicID = [NSString stringWithFormat:@"%ld",button.tag];
    NSLog(@"%@",_topicID);
    
    [self addCommentView];
}

- (void)addCommentView {
    
    _commentView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight, MainScreenWidth, 50)];
    _commentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_commentView];
    
    //添加输入框
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, MainScreenWidth - 80, 40)];
    _textField.placeholder = @"写下你的评论";
    [_commentView addSubview:_textField];
    _textField.layer.borderWidth = 1;
    _textField.layer.cornerRadius = 5;
    _textField.layer.borderColor = PartitionColor.CGColor;
    _textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    //设置显示模式为永远显示(默认不显示)
    _textField.leftViewMode = UITextFieldViewModeAlways;
    [_textField becomeFirstResponder];
    
    //创建通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 70, 5, 60, 40)];
    sendButton.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    sendButton.layer.cornerRadius = 3;
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendButton) forControlEvents:UIControlEventTouchUpInside];
    [_commentView addSubview:sendButton];
    
    [UIView animateWithDuration:0.25 animations:^{
        _commentView.frame = CGRectMake(0, MainScreenHeight / 2, MainScreenWidth, 50);
    }];
    
}

- (void)sendButton {
    [self netWorkCommentTopic];
}

- (void)netWorkCommentTopic {
    
    
    if (_textField.text.length == 0) {
        [MBProgressHUD showError:@"请输入评论" toView:self.view];
        return;
    }
    
    BigWindCar *manager = [BigWindCar manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    } else {
        [MBProgressHUD showError:@"请先登陆" toView:self.view];
        return;
    }
    [dic setValue:_topicID forKey:@"tid"];
    [dic setValue:_textField.text forKey:@"content"];
    
    [manager BigWinCar_commentTopic:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
            [MBProgressHUD showSuccess:@"评论成功" toView:self.view];
            [self netWorkGetcollectTopic];
            [self.view endEditing:YES];
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"评论失败" toView:self.view];
    }];
    
}

    
    
    //键盘弹上来
- (void)keyboardWillShow:(NSNotification *)not {
    NSLog(@"-----%@",not.userInfo);
    CGRect rect = [not.userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    CGFloat HFloat = rect.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        _commentView.frame = CGRectMake(0, MainScreenHeight - 50 - HFloat, MainScreenWidth, 50);
    }];
    
    
}
    
    //键盘下去
- (void)keyboardWillHide:(NSNotification *)not {
    [UIView animateWithDuration:0.25 animations:^{
        _commentView.frame = CGRectMake(0, MainScreenHeight, MainScreenWidth, 50);
    }];
    
}
    
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
    
#pragma mark --- 滚动试图
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    
}

    
    
-(void)reloadDataBlum
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    [dic setObject:@"2" forKey:@"type"];
    [dic setObject:[NSString stringWithFormat:@"%ld",_livenum] forKey:@"page"];
    [dic setObject:@"50" forKey:@"count"];
    
    [manager getpublicPort:dic mod:@"Video" act:@"getCollectVideoList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        NSLog(@"%@",responseObject);
        
        NSMutableArray * listArr = [[NSMutableArray alloc]initWithCapacity:0];
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            listArr = responseObject[@"data"];
        }
        if(_livenum==1){
            if (listArr.count) {
                _dataArray = [NSMutableArray arrayWithArray:listArr];
                [_blumTableView reloadData];
            }else{
                //添加空白处理
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 - 48)];
                imageView.image = [UIImage imageNamed:@"收藏-专辑@2x"];
                [_blumTableView addSubview:imageView];
            }
        }else{
            if (listArr.count) {
//                [_dataArray addObjectsFromArray:listArr];
            }else{
                [MBProgressHUD showError:@"没有更多数据" toView:self.view];
            }
            _dataArray = responseObject[@"data"];
        }
        NSLog(@"------%@",_dataArray);
        [_blumTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

-(void)reloadDataClass
{
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [dic setObject:@"1"forKey:@"page"];
    [dic setObject:@"50"forKey:@"count"];
    [dic setObject:@"1"forKey:@"type"];

    NSArray *classArray = [mySCClass BJWithDic:dic];
    [manager userAttentionCrouse:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        NSLog(@"%@",responseObject);
        _classArray = responseObject[@"data"];
        NSMutableArray *muArr = [[NSMutableArray alloc]initWithCapacity:0];
        if (classArray.count) {
        } else {
            if (![_classArray isEqual:[NSNull null]]) {
                //缓存数据
                [mySCClass saveBJes:_classArray];
            }
        }
        
        if (![[responseObject objectForKey:@"data"] isEqual:[NSNull null]] ) {
            muArr = [responseObject objectForKey:@"data"];
            _classListArray = responseObject[@"data"];
        }else{
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64 - 48)];
            imageView.image = [UIImage imageNamed:@"收藏-课程@2x"];
            [_classTableView addSubview:imageView];
        }

        [_classTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"加载失败" toView:self.view];
        _classArray = classArray;
        [_classTableView reloadData];
    }];
}

- (void)netWorkGetcollectTopic {
    
    BigWindCar *manager = [BigWindCar manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [manager BigWinCar_getTopicCollectList:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] integerValue] == 1) {
            _topicArray = responseObject[@"data"];
        } else {
           [MBProgressHUD showError:@"没有获取到数据" toView:self.view];
        }
        [_topicTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"没有获取到数据" toView:self.view];
    }];
}

//置顶/精华/收藏/话题
- (void)netWorkSettingTopic {
    
    BigWindCar *manager = [BigWindCar manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    [dic setValue:_topicID forKey:@"tid"];
    [dic setValue:_actionStr forKey:@"action"];
    [dic setValue:_typeStr forKey:@"type"];
    
    [manager BigWinCar_operatTopic:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        if ([responseObject[@"code"] integerValue] == 1) {
            [MBProgressHUD showSuccess:@"操作成功" toView:self.view];
            [self netWorkGetcollectTopic];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"操作失败" toView:self.view];
    }];
}

//删除话题
- (void)netWorkDeleteTopic {
    
    BigWindCar *manager = [BigWindCar manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    [dic setValue:_topicID forKey:@"tid"];
    [dic setValue:_settingDic[@"gid"] forKey:@"group_id"];
    
    [manager BigWinCar_deleteTopic:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1) {
            [MBProgressHUD showSuccess:@"删除成功" toView:self.view];
            [self netWorkGetcollectTopic];
        } else {
            [MBProgressHUD showError:@"删除失败" toView:self.view];
        }
        [_topicTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"删除失败" toView:self.view];
    }];
}

//去掉HTML字符
-(NSString *)filterHTML:(NSString *)html{
    
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO){
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //        //找到标签的起始位置
        //        [scanner scanUpToString:@"<" intoString:nil];
        //        //找到标签的结束位置
        //        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    }
    // NSString * regEx = @"<([^>]*)>";
    // html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

@end
