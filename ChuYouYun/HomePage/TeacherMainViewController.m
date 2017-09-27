//
//  TeacherMainViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/5/15.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "TeacherMainViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"


#import "TeacherHomeViewController.h"
#import "TeacherPhotoViewController.h"
#import "TeacherArticleViewController.h"
#import "TeacherCommentViewController.h"
#import "MessageSendViewController.h"
#import "YYViewController.h"

#import "DLViewController.h"





@interface TeacherMainViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>



@property (strong ,nonatomic)UIView *infoView;
@property (strong ,nonatomic)UIScrollView *allScrollView;
@property (strong ,nonatomic)UIScrollView *controllerSrcollView;
@property (strong ,nonatomic)UIScrollView *classScrollView;
@property (strong ,nonatomic)UIImageView  *imageView;
@property (strong ,nonatomic)UISegmentedControl *mainSegment;
@property (strong ,nonatomic)UIView *segleMentView;
@property (strong ,nonatomic)UILabel *teacherInfo;
@property (strong ,nonatomic)UIView *downView;
@property (strong ,nonatomic)UIButton *attentionButton;


@property (strong ,nonatomic)NSString *ID;
@property (strong ,nonatomic)NSString *myUID;
@property (strong ,nonatomic)NSString *uID;//关注时用到
@property (strong ,nonatomic)NSString *teacherID;
@property (strong ,nonatomic)NSDictionary *teacherDic;
@property (strong ,nonatomic)NSString *following;
@property (strong ,nonatomic)NSString *nameStr;

@property (strong ,nonatomic)NSString *oneHightStr;
@property (strong ,nonatomic)NSString *fourHightStr;
@property (strong ,nonatomic)NSString *homeMoreButtonSet;


@end



@implementation TeacherMainViewController

-(void)viewWillAppear:(BOOL)animated
{
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
    
}

-(instancetype)initWithNumID:(NSString *)ID{
    
    self = [super init];
    if (self) {
        _ID = ID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    

    [self addAllScrollView];
//    [self addInfoView];
//    [self addWZView];
    [self addDownView];
//    [self addControllerSrcollView];
    [self NetWorkGetTeacherInfo];
    
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    currentIndex = 0;
//    _imageArray = @[@"你好",@"我好",@"他好",@"你好",@"大家好"];
//    _titleInfoArray = @[@"简介"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHomeScrollHight:) name:@"TeacherHomeScrollHight" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCommentScrollHight:) name:@"TeacherCommentScrollHight" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHomeMoreButtonCilck:) name:@"TeacherHomeMoreButtonCilck" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHomeMovePhotoCilck:) name:@"TeacherHomeMoveToPhoto" object:nil];
    
}


- (void)addAllScrollView {
    
    _allScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,  MainScreenWidth, MainScreenHeight - 50)];
    //    _allScrollView.pagingEnabled = YES;
    _allScrollView.delegate = self;
    _allScrollView.bounces = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _allScrollView.contentSize = CGSizeMake(0, 1000);
    [self.view addSubview:_allScrollView];
    
}

- (void)addInfoView {
    
    _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 200)];
    _infoView.backgroundColor = [UIColor whiteColor];
    [_allScrollView addSubview:_infoView];
    
    //背景图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_infoView.bounds];
    imageView.image = Image(@"组-2@2x");
    [_infoView addSubview:imageView];
    _imageView = imageView;
    
    
    //机构头像
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 30, 30, 60, 60)];
    headerImageView.image = Image(@"你好");
    headerImageView.layer.cornerRadius = 30;
    headerImageView.layer.masksToBounds = YES;
    NSString *urlStr = [_teacherDic stringValueForKey:@"headimg"];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
    [_infoView addSubview:headerImageView];
    
    //添加名字
    UILabel *Name = [[UILabel alloc] initWithFrame:CGRectMake(50, 100,MainScreenWidth - 100, 20)];
    Name.text = [_teacherDic stringValueForKey:@"name"];
    Name.textAlignment = NSTextAlignmentCenter;
    Name.textColor = [UIColor whiteColor];
    [_infoView addSubview:Name];
    _nameStr = _teacherDic[@"name"];
    
    //添加介绍
    _teacherInfo = [[UILabel alloc] initWithFrame:CGRectMake(50, 130, MainScreenWidth - 100, 40)];
    if ([_teacherDic[@"label"] isEqual:[NSNull null]] || _teacherDic[@"label"] == nil ) {
        _teacherInfo.text = @"";
    } else {
        [self setIntroductionText:_teacherDic[@"label"]];
    }

    _teacherInfo.textAlignment = NSTextAlignmentCenter;

    if ([_teacherInfo.text isEqual:[NSNull null]] || _teacherDic[@"label"] == nil) {
        
    } else {
        _teacherInfo.font = Font(13);
    }

    if ([_teacherInfo.text isEqual:[NSNull null]] || _teacherDic[@"label"] == nil) {
    } else {
         _teacherInfo.textColor = [UIColor whiteColor];
    }
    [_infoView addSubview:_teacherInfo];

    
    //添加粉丝、浏览、评价的界面
    UIView *kinsOfView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_teacherInfo.frame) + 20, MainScreenWidth, 40)];
    kinsOfView.backgroundColor = [UIColor clearColor];
    [_infoView addSubview:kinsOfView];

    
    CGFloat labelW = MainScreenWidth / 3;
    CGFloat labelH = 20;
    NSString *Str0 = [NSString stringWithFormat:@"%@年教龄",_teacherDic[@"teacher_age"]];
    NSString *Str1 = [NSString stringWithFormat:@"%@个课程",_teacherDic[@"video_count"]];
    NSString *Str2 = [NSString stringWithFormat:@"%@人关注",_teacherDic[@"ext_info"][@"count_info"][@"follower_count"]];
    
    NSArray *titleArray = @[Str0,Str1,Str2];

    
    for (int i = 0 ; i < 3 ; i ++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * labelW, 0, labelW, labelH)];
        label.text = titleArray[i];
        label.font = Font(12);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [kinsOfView addSubview:label];
        
        if (i == 0) {
            if ([_teacherDic[@"teacher_age"] isEqual:[NSNull null]] || _teacherDic[@"label"] == nil) {
                label.text = @"教龄";
            }
        } else if (i == 1) {
            if ([_teacherDic[@"video_count"] isEqual:[NSNull null]] || _teacherDic[@"label"] == nil) {
                label.text = @"课程";
            }
        } else if (i == 2) {
            if ([_teacherDic[@"ext_info"][@"count_info"][@"follower_count"] isEqual:[NSNull null]] || _teacherDic[@"label"] == nil) {
                label.text = @"关注";
            }
        }
    }

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"点评返回@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [_infoView addSubview:backButton];
    
    
    //最终确定infoView 的位置
    _infoView.frame = CGRectMake(0, 0, MainScreenWidth, CGRectGetMaxY(kinsOfView.frame));
    //重新添加背景 不然会变形
    _imageView.frame = CGRectStandardize(_infoView.frame);


}




#pragma mark -- 事件监听
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)addControllerSrcollView {
    
    _controllerSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segleMentView.frame) + 10,  MainScreenWidth, MainScreenHeight * 3 + 500)];
    _controllerSrcollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _controllerSrcollView.pagingEnabled = YES;
    _controllerSrcollView.scrollEnabled = YES;
    _controllerSrcollView.delegate = self;
    _controllerSrcollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * 4,0);
    [_allScrollView addSubview:_controllerSrcollView];
    
    TeacherHomeViewController *teacherHomeVc= [[TeacherHomeViewController alloc] initWithNumID:_ID];
    teacherHomeVc.view.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
    [self addChildViewController:teacherHomeVc];
    [_controllerSrcollView addSubview:teacherHomeVc.view];
    
    TeacherPhotoViewController * teacherPhotoVc = [[TeacherPhotoViewController alloc] initWithNumID:_ID];
    teacherPhotoVc.view.frame = CGRectMake(MainScreenWidth, -64, MainScreenWidth, MainScreenHeight * 2 + 500);
    [self addChildViewController:teacherPhotoVc];
    [_controllerSrcollView addSubview:teacherPhotoVc.view];
    
    TeacherArticleViewController * teacherArticleVc = [[TeacherArticleViewController alloc] initWithNumID:_ID];
    teacherArticleVc.view.frame = CGRectMake(MainScreenWidth * 2, -64, MainScreenWidth, MainScreenHeight * 2 + 500);
    [self addChildViewController:teacherArticleVc];
    [_controllerSrcollView addSubview:teacherArticleVc.view];
    
    TeacherCommentViewController * teacherCommentVc = [[TeacherCommentViewController alloc] initWithNumID:_ID];
    teacherCommentVc.view.frame = CGRectMake(MainScreenWidth * 3, -64, MainScreenWidth, MainScreenHeight * 2 + 500);
    [self addChildViewController:teacherCommentVc];
    [_controllerSrcollView addSubview:teacherCommentVc.view];
    
}


- (void)addWZView {
    UIView *WZView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_infoView.frame), MainScreenWidth, 50)];
    WZView.backgroundColor = [UIColor whiteColor];
    [_allScrollView addSubview:WZView];
    _segleMentView = WZView;
    
    
    NSArray *titleArray = @[@"主页",@"相册",@"文章",@"点评"];
    _mainSegment = [[UISegmentedControl alloc] initWithItems:titleArray];
    _mainSegment.frame = CGRectMake(2 * SpaceBaside,SpaceBaside,MainScreenWidth - 4 * SpaceBaside, 30);
    _mainSegment.selectedSegmentIndex = 0;
    [_mainSegment setTintColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1]];
    [_mainSegment addTarget:self action:@selector(mainChange:) forControlEvents:UIControlEventValueChanged];
    [WZView addSubview:_mainSegment];
    
//    basidFrame = CGRectGetMaxY(_mainSegment.frame);
    
}

- (void)addDownView {
    
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 50   , MainScreenWidth, 50)];
    _downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downView];
    
    //添加线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_downView addSubview:lineButton];
    
    
    CGFloat ButtonW = MainScreenWidth / 3;
//    buttonW = ButtonW;
    CGFloat ButtonH = 30;
    
    NSArray *title = @[@"关注",@"私信",@"预约试听"];
    NSArray *image = @[@"机构关注@2x",@"机构信息@2x",@""];
    if ([_teacherDic[@"follow_state"][@"following"] integerValue] == 0) {
        image = @[@"机构未关注@2x",@"机构信息@2x",@""];
        title = @[@"添加关注",@"私信",@"预约试听"];
    } else {
        image = @[@"机构关注@2x",@"机构信息@2x",@""];
        title = @[@"取消关注",@"私信",@"预约试听"];
    }
    
    for (int i = 0 ; i < 3 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * ButtonW, SpaceBaside, ButtonW, ButtonH)];
        [button setTitle:title[i] forState:UIControlStateNormal];
        [button setTitleColor:BlackNotColor forState:UIControlStateNormal];
        [button setImage:Image(image[i]) forState:UIControlStateNormal];
        button.titleLabel.font = Font(13);
        button.tag = i * 1000;
        [button addTarget:self action:@selector(downButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_downView addSubview:button];
        
        if (i == 0) {
            _attentionButton = button;
        } else if (i == 2) {
//            button.backgroundColor = BasidColor;
        }
        
    }
    
}


#pragma mark --- 滚动试图

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat contentCrorX = _controllerSrcollView.contentOffset.x;
    if (contentCrorX < MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 0;
        _allScrollView.contentSize = CGSizeMake(0 , [_oneHightStr floatValue] + CGRectGetMaxY(_infoView.frame) + 50);
    } else if (contentCrorX < 2 * MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 1;
        _allScrollView.contentSize = CGSizeMake(0, MainScreenWidth);
    } else if (contentCrorX < 3 * MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 2;
        _allScrollView.contentSize = CGSizeMake(0, MainScreenHeight);
    }  else if (contentCrorX < 4 * MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 3;
        _allScrollView.contentSize = CGSizeMake(0 , [_fourHightStr floatValue] + 270);
    }
    
}


- (void)mainChange:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            _controllerSrcollView.contentOffset = CGPointMake(0, 0);
            _allScrollView.contentSize = CGSizeMake(0 , 1000);
            _allScrollView.contentSize = CGSizeMake(0 , [_oneHightStr floatValue] + CGRectGetMaxY(_infoView.frame) + 50);
            break;
        case 1:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth, 0);
            //设置滚动的范围
            _allScrollView.contentSize = CGSizeMake(0, MainScreenWidth);
            break;
        case 2:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 2, 0);
            //设置滚动的范围
            _allScrollView.contentSize = CGSizeMake(0, MainScreenHeight);
            break;
        case 3:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 3, 0);
            //设置滚动的范围
            _allScrollView.contentSize = CGSizeMake(0 , [_fourHightStr floatValue] + 270);
            break;
            
        default:
            break;
    }
    
}

-(void)setIntroductionText:(NSString*)text{
    //文本赋值
    _teacherInfo.text = text;
    //设置label的最大行数
    _teacherInfo.numberOfLines = 0;
    if ([_teacherInfo.text isEqual:[NSNull null]]) {
        _teacherInfo.frame = CGRectMake(50,130,MainScreenWidth - 100,30);
        return;
    }
    
    CGRect labelSize = [_teacherInfo.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
    
    _teacherInfo.frame = CGRectMake(50,130,MainScreenWidth - 100,labelSize.size.height);
    
    //重新添加背景 不然会变形
    _imageView.frame = CGRectStandardize(_infoView.frame);

}


#pragma mark --- 通知
- (void)getHomeScrollHight:(NSNotification *)not {
    
    NSString *hightStr = not.object;
    _oneHightStr = hightStr;
    _allScrollView.contentSize = CGSizeMake(0 , [hightStr floatValue] + CGRectGetHeight(_infoView.frame) + 150);
}

- (void)getCommentScrollHight:(NSNotification *)not {
    
    NSString *hightStr = not.object;
    _fourHightStr = hightStr;
    _allScrollView.contentSize = CGSizeMake(0 , [hightStr floatValue] + 270);
    if (_mainSegment.selectedSegmentIndex == 0) {
        _allScrollView.contentSize = CGSizeMake(0 , [hightStr floatValue] + 270);
    }
}

- (void)getHomeMoreButtonCilck:(NSNotification *)not {
    NSLog(@"%@",not.object);
    _homeMoreButtonSet = (NSString *)not.object;
    
    if ([_homeMoreButtonSet integerValue] == 2) {
        _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth, 0);
        _mainSegment.selectedSegmentIndex = 1;
        _allScrollView.contentOffset = CGPointMake(0, 0);
    } else if ([_homeMoreButtonSet integerValue] == 3) {
        _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 2, 0);
        _mainSegment.selectedSegmentIndex = 2;
        _allScrollView.contentOffset = CGPointMake(0, 0);
    }
}

- (void)getHomeMovePhotoCilck:(NSNotification *)not {
    _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth, 0);
    _mainSegment.selectedSegmentIndex = 1;
    _allScrollView.contentOffset = CGPointMake(0, 0);
}

#pragma mark ---- 时间监听

- (void)downButtonClick:(UIButton *)button {
    switch (button.tag) {
        case 0:
            if ([button.titleLabel.text isEqualToString:@"添加关注"]) {
                [self addAttition];
            } else {
                [self cancleAtetion];
            }
            break;
        case 1000:
            [self gotoSendMessage];
            break;
        case 2000:
            [self gotoSubscribe];
            break;
        default:
            break;
    }
    
}

- (void)addAttition {
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_uID forKey:@"user_id"];
    NSLog(@"%@",_ID);
    NSLog(@"%@",_uID);
    
    //判断是否处于登录状态
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        //提示登录
        [MBProgressHUD showError:@"请先登陆" toView:self.view];
        return;
    } else {//已经登录
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
   NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"User_id"];
    NSLog(@"%@ %@",userID,_uID);
    
    if ([userID isEqualToString:_uID]) {//说明是自己
        [MBProgressHUD showError:@"不能关注自己" toView:self.view];
        return;
    }
    
    [manager userAttention:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = responseObject[@"msg"];
        
        if ([responseObject[@"data"][@"following"] integerValue] == 1) {
            [MBProgressHUD showSuccess:@"关注成功" toView:self.view];
            [_attentionButton setTitle:@"取消关注" forState:UIControlStateNormal];
            return ;
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)cancleAtetion {
    
    ZhiyiHTTPRequest *manager = [ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_uID forKey:@"user_id"];
    //判断是否处于登录状态
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        //提示登录
        [MBProgressHUD showError:@"请先登陆" toView:self.view];
        return;
        
    } else {//已经登录
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }
    
    [manager cancelUserAttention:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"---->>%@",responseObject);
        NSString *msg = responseObject[@"msg"];
        if ([responseObject[@"data"][@"following"] integerValue] == 0) {
            [MBProgressHUD showError:@"取消关注成功" toView:self.view];
            [_attentionButton setTitle:@"添加关注" forState:UIControlStateNormal];
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"取消关注失败" toView:self.view];
    }];
}

- (void)gotoSendMessage {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        [MBProgressHUD showError:@"请先登陆" toView:self.view];
        return;
    }
    MessageSendViewController *MSVC = [[MessageSendViewController alloc] init];
    MSVC.TID = _uID;
    MSVC.name = _nameStr;
    NSLog(@"--%@",_nameStr);
    [self.navigationController pushViewController:MSVC animated:YES];
    
}

- (void)gotoSubscribe {
    YYViewController *YY = [[YYViewController alloc]init];
    YY.TID = _ID;
    YY.name = _nameStr;
    YY.lineonPrice = [NSString stringWithFormat:@"%@",[_teacherDic stringValueForKey:@"online_price"]];
    YY.lineoffprice = [NSString stringWithFormat:@"%@",[_teacherDic stringValueForKey:@"offline_price"]];
    [self.navigationController pushViewController:YY animated:YES];
    
}


#pragma mark ---网络请求

//获取头部视图数据
-(void)NetWorkGetTeacherInfo {
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_ID forKey:@"teacher_id"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {
    } else {
        [dic setObject:UserOathToken forKey:@"oauth_token"];
        [dic setObject:UserOathTokenSecret forKey:@"oauth_token_secret"];
    }
//    [MBProgressHUD showError:@"数据加载中..." toView:self.view];
    
    [manager getpublicPort:dic mod:@"Teacher" act:@"getTeacher" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = responseObject[@"msg"];
        
        _teacherDic = [NSMutableDictionary dictionary];
        
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
//            [MBProgressHUD showError:@"加载成功...." toView:self.view];
            _teacherDic = responseObject[@"data"];
            _following = [NSString stringWithFormat:@"%@",_teacherDic[@"follow_state"][@"following"]];
            _uID = responseObject[@"data"][@"uid"];
            
            if ([_following isEqualToString:@"0"]) {
                [_attentionButton setTitle:@"添加关注" forState:UIControlStateNormal];
            }else{
                [_attentionButton setTitle:@"取消关注" forState:UIControlStateNormal];
            }
        } else {
            [MBProgressHUD showError:msg toView:self.view];
            return ;
        }
        [self addInfoView];
        [self addWZView];
        [self addControllerSrcollView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"网路失败");
    }];
}






@end
