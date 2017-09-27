//
//  TeacherDetilViewController.m
//  dafengche
//
//  Created by IOS on 16/11/18.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "TeacherDetilViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "GLTeacherTableViewCell.h"
#import "GLTextView.h"
#import "MJRefresh.h"
#import "MBProgressHUD+Add.h"
#import "UIButton+WebCache.h"

//相册
#import "GLImageVievs.h"
#import "MyHttpRequest.h"
#import "UIImageView+WebCache.h"
#import "DLViewController.h"
#import "GLReachabilityView.h"
#import "TIXingLable.h"
#import "UIColor+HTMLColors.h"
#import "MessageSendViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "GLClassViewController.h"
#import "classDetailVC.h"
#import "XCDetilViewController.h"
#import "WZTableViewCell.h"
#import "Passport.h"
#import "BigWindCar.h"
#import "XCVideoViewController.h"
#import "YYViewController.h"
#import "MyHttpRequest.h"
#import "SYGDPViewController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "XCDetilViewController.h"



@interface TeacherDetilViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UIPopoverPresentationControllerDelegate,UITextViewDelegate>{
    
    //头像按钮
    UIButton *_aconBtn;
    UILabel *_nameLab;
    UILabel *_speakLab;
    //右边按钮
    UIButton *_rightbtn;
    //头部背景图
    UIImageView *headerImageV;
    //下划线lab
    UILabel *_colorLineLable;
    //点评输入框
    UITextField *_DPTF;
    //点评的tableView
    UITableView *_tableView;
    //点评选择优良差
    NSString *_classStr;
    NSString *_shoukeStr;
    NSString *_zhuanyeStr;
    NSString *_taiduStr;
    
    UITextField *_TF;
    UITextField *_TF1;
    UITextField *_TF2;
    UITextField *_TF3;
    UITextField *_TF4;
    
    UIView *_GLview;
    UIView *_view;
    //弹框
    UIView *_popV;
    GLTextView *textV ;
    UIViewController *contentVC;
    //星级评分
    NSString *_XJStr;
    NSArray *_starArr;
    //传过来的ID
    NSString *_ID;
    //关注
    UILabel *_GZlab;
    //私信
    UILabel *_SXlab;
    //name
    NSString *_nameStr;
    
    UILabel *_GLTXlab;
    
    NSArray *_imgUrlArr;
    
    //选择课程的弹窗
    UIView *_GLPV ;
    
    //课程名字
    NSString *_className;
    
    //课程ID
    NSString *_classID;
    
    //授课技巧
    int _num1;
    //授课技巧
    int _num2;
    //授课技巧
    int _num3;
    //描述
    NSString *_description;
    //星星评分
    NSString *_starStr;
    //是否关注
    NSString *_following;
    //关注穿的ID
    NSString *_GZID;
    
    NSString *_moneyString;
    
    UIButton *_button;
    NSString * _type;
    CGRect _frame;
    NSDictionary *dict;
    BOOL isArgree;//同意支付协议
    //price
    NSString *_price;
    
    //主页相册标题lab
    UILabel *_XClab;
    UIButton *_XCbtn;
    UIButton *moreBtn2;
    UIButton *moreBtn3;
    
    //背景lab
    UILabel *_backLab;
    
    //背景lab
    UILabel *_backLab1;
    
    //背景lab
    UILabel *_backLab2;
    
    //按钮view
    UIView *_btnView;
    //返回按钮
    UIButton *backButton;
    
}

@property (strong ,nonatomic)UITableView *tableView;

//文章列表
@property (strong ,nonatomic)UITableView *WZtableView;


@property (strong ,nonatomic)UITableView *classtableView;


@property (strong ,nonatomic)NSArray *lookArray;

@property (strong ,nonatomic)UIScrollView *headScrollow;

///顶部btn集合
@property (strong, nonatomic) NSArray *btns;

//轮播图的scrollow
@property (strong ,nonatomic)UIScrollView *scrollView;

//轮播数据数组
@property (strong , retain)NSMutableArray *LBDataArr;

//简介数组
@property (strong , retain)NSMutableArray *JJDataArr;

//简介数组
@property (strong , retain)NSMutableArray *XCDataArr;

//文章数组
@property (strong , retain)NSMutableArray *WZDataArr;

@property (strong ,nonatomic)UIPageControl *pageControl;

@property (assign ,nonatomic)NSInteger currentIndex;
//最后的scrollow
@property (strong ,nonatomic)UIScrollView *lastScrollow;

@property (strong ,nonatomic)UIPopoverPresentationController *popover;

@property (strong , retain)NSMutableDictionary *dataDic;

@property (strong , retain)NSArray *LabArr;
//ID
@property (strong ,nonatomic)NSString *uID;
//点平数组
@property (strong , retain)NSMutableArray *DPDataArr;

//课程数组
@property (strong , retain)NSMutableArray *KCDataArr;


@property (strong ,nonatomic)NSDictionary *moneyDic;
@property (strong ,nonatomic)UIView *allView;
@property (nonatomic ,strong)UIView *buyView;
@property (strong ,nonatomic)UIButton *allButton;
@property (strong ,nonatomic)UITableView *poptableView;
@property (strong ,nonatomic)NSArray *counpArray;

@end

@implementation TeacherDetilViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //隐藏状态栏
    [UIApplication sharedApplication].statusBarHidden = YES;
    //    [self requestData];
    //刷新数据
    [self requestDPData];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [super viewWillDisappear:animated];
}
//获取头部视图数据
-(void)requestData:(NSString *)teacher_id
{
    _GZlab.text = @"关注";
    
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    //临时的
    [dic setValue:teacher_id forKey:@"teacher_id"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {
        
    } else {
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
        [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    }

    
    [manager getpublicPort:dic mod:@"Teacher" act:@"getTeacher" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        _dataDic = [NSMutableDictionary dictionary];
        
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
//            [_dataDic addEntriesFromDictionary:responseObject[@"data"]];
            _dataDic = responseObject[@"data"];
            _following = [NSString stringWithFormat:@"%@",_dataDic[@"follow_state"][@"following"]];
            _uID = responseObject[@"data"][@"uid"];
            
            NSLog(@"---%@",_following);
            if ([_following isEqualToString:@"0"]) {
                _GZlab.text = @"关注";
            }else{
                _GZlab.text = @"已关注";
            }
        }
        [self refreshHeaderUI];
        [self creatJianJieView];
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//获取轮播视图数据
-(void)requestLBData:(NSString *)teacher_id
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    //临时的
    [dic setValue:teacher_id forKey:@"teacher_id"];
    _LBDataArr = [NSMutableArray array];
    
    [manager getpublicPort:dic mod:@"Teacher" act:@"teacherVideoList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            [_LBDataArr addObjectsFromArray:responseObject[@"data"]];
        }
        NSLog(@"%@",_LBDataArr);
        [self creatClass];
        //添加相册
        [self creatImageViews];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self creatClass];
        //添加相册
        [self creatImageViews];
        
    }];
}

-(instancetype)initWithNumID:(NSString *)ID{
    
    self = [super init];
    if (self) {
        _ID = ID;
        NSLog(@"----ID-----%@",ID);
    }
    return self;
}

//更新头部UI
-(void)refreshHeaderUI{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",_dataDic[@"headimg"]];
    [_aconBtn sd_setImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
    
    _nameLab.text = [NSString stringWithFormat:@"%@",_dataDic[@"name"]];
    _nameStr = _dataDic[@"name"];
    _speakLab.text = [NSString stringWithFormat:@"%@",_dataDic[@"label"]];
    if (_dataDic[@"name"] == nil) {
        _nameLab.text = @"";
    }
    if (_dataDic[@"label"] == nil) {
        _speakLab.text = @"";
    }
    
    for (int i = 0; i<3; i++) {
        UILabel *lab = (UILabel *)_LabArr[i];
        if (i==0) {
            lab.text = [NSString stringWithFormat:@"%@年教龄",_dataDic[@"teacher_age"]];
            if (_dataDic[@"teacher_age"] == nil) {
                lab.text = @"教龄";
            }
        }else if (i==1){
            lab.text = [NSString stringWithFormat:@"%@个课程",_dataDic[@"video_count"]];
            if (_dataDic[@"video_count"] == nil) {
                lab.text = @"课程";
            }
            
        }else if (i==2){
            lab.text = [NSString stringWithFormat:@"%@人关注",_dataDic[@"ext_info"][@"count_info"][@"follower_count"]];
            if (_dataDic[@"ext_info"][@"count_info"][@"follower_count"] == nil) {
                lab.text = @"关注";
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addscrollow];
    [self creatBody];
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 24,24)];
    [backButton setImage:[UIImage imageNamed:@"icon_back_to_home"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    _rightbtn = [[UIButton alloc]initWithFrame:CGRectMake(MainScreenWidth - 65, 20, 50, 50)];
    [_headScrollow addSubview:_rightbtn];
    // [_rightbtn addTarget:self action:@selector(rightMore:) forControlEvents:UIControlEventTouchUpInside];
    //    [_rightbtn setTitle:@"· · ·" forState:UIControlStateNormal];
    [_rightbtn setTitleColor:Color(whiteColor) forState:UIControlStateNormal];
    _rightbtn.titleLabel.font = Font(50);
    _rightbtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //底层背景
    UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(0, MainScreenHeight - 40, MainScreenWidth, 40)];
    [self.view addSubview:backV];
    backV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //添加最下面的关注，私信，预约试听按钮
    NSArray *arr = @[@"关注",@"私信",@"预约试听"];
    NSArray *imgArr = @[@"GLguanzhu",@"icon_pinglun"];
    
    for (int i=0; i<3; i++) {
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i*MainScreenWidth/3, MainScreenHeight - 40, MainScreenWidth/3, 40)];
        button.tag = i;
        if (i==2) {
            _button = button;
        }
        if (i<2) {
            
            UIImageView *imgV;
            if (i==0) {
                imgV = [[UIImageView alloc]initWithFrame:CGRectMake(MainScreenWidth/6 - 17 + i*MainScreenWidth/3,MainScreenHeight - 40 + 13.5, 13, 13)];
            }else{
                imgV = [[UIImageView alloc]initWithFrame:CGRectMake(MainScreenWidth/6 - 17 + i*MainScreenWidth/3,MainScreenHeight - 40 + 14.5, 15, 13)];
            }
            
            imgV.image = Image(imgArr[i]);
            [self.view addSubview:imgV];
            
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(imgV.current_x_w +3,MainScreenHeight - 40 + 13.5, 50, 13)];
            lab.text = arr[i];
            lab.textColor = [UIColor colorWithHexString:@"#333333"];
            lab.textAlignment = NSTextAlignmentLeft;
            [self.view addSubview:lab];
            
            if (i==0) {
                
                _GZlab = lab;
                
            }else{
                
                _SXlab = lab;
            }
            
            lab.font = Font(12);
            
        }else{
            
            [button setTitle:arr[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.backgroundColor = BasidColor;
            [button setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(YYBtn) forControlEvents:UIControlEventTouchUpInside];
        }
        
        _GLview = [[UIView alloc]initWithFrame:CGRectMake(MainScreenWidth, _button.current_y - 70, _button.current_w,0)];
        _GLview.backgroundColor = [UIColor cyanColor];
        [self.view addSubview:_GLview];
        NSArray *arr = @[@"在线",@"线下"];
        for (int k = 0; k<2; k++) {
            UIButton *btttn = [[UIButton alloc]initWithFrame:CGRectMake(0, 3+33*k, _button.current_w, 30)];
            
            [btttn setTitle:arr[k] forState:UIControlStateNormal];
            btttn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btttn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btttn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
            UILabel *LAB = [[UILabel alloc]initWithFrame:CGRectMake(0, btttn.current_y_h*(k+1)+1, MainScreenWidth*2/3, 0.5)];
            LAB.backgroundColor = [UIColor blackColor];
            
            [_GLview addSubview:btttn];
            [_GLview addSubview:LAB];
            
            btttn.tag = i;
        }
        [self.view addSubview:button];
        [button addTarget:self action:@selector(GZLT:) forControlEvents:UIControlEventTouchUpInside];
    }
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(MainScreenWidth/3, MainScreenHeight - 35, 1, 30)];
    [self.view addSubview:line];
    line.backgroundColor = [UIColor grayColor];
    [self LastView];
}
-(void)search:(UIButton *)sender{
    
    _GLview.frame = CGRectMake(MainScreenWidth, 0, 0, 0);
    if (sender.tag ==0) {
        _type = @"online";
        _price = [NSString stringWithFormat:@"%@",_dataDic[@"online_price"]];
        
    }else{
        
        _price = [NSString stringWithFormat:@"%@",_dataDic[@"offline_price"]];
        _type = @"offline";
        
    }
    [self SYGBuy];
    
    
}
//预约试听
-(void)YYBtn{
    
    //        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i*MainScreenWidth/3, MainScreenHeight - 40, MainScreenWidth/3, 40)];
    
    YYViewController *YY = [[YYViewController alloc]init];
    YY.TID = _ID;
    YY.name = _nameStr;
    YY.lineonPrice = [NSString stringWithFormat:@"%@",_dataDic[@"online_price"]];
    YY.lineoffprice = [NSString stringWithFormat:@"%@",_dataDic[@"offline_price"]];
    [self.navigationController pushViewController:YY animated:YES];
    
    //    if (_GLview.current_h == 0) {
    //        _GLview.frame = CGRectMake(MainScreenWidth*2/3, _button.current_y - 70, _button.current_w, 70);
    //
    //    }else{
    //
    //        _GLview.frame = CGRectMake(MainScreenWidth, _button.current_y - 70, _button.current_w, 0);
    //
    //    }
    //    [UIView animateWithDuration:0.2 animations:^{
    //
    //    }];
}
-(void)YYrequestData
{
    
    QKHTTPManager * manager = [QKHTTPManager manager];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *key = [ user objectForKey:@"oauthToken"];
    NSString *passWord = [ user objectForKey:@"oauthTokenSecret"];
    
    NSDictionary *parameter=@{@"oauth_token": [NSString stringWithFormat:@"%@",key],@"oauth_token_secret": [NSString stringWithFormat:@"%@",passWord] ,@"teacher_id": _ID,@"type":_type,@"word":@""};
    [manager getpublicPort:parameter mod:@"Teacher" act:@"bespeak" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"===__===%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        if ([responseObject[@"data"] count] == 0) {
            [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
            return ;
            
        }else{
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"获取数据失败" toView:self.view];
    }];
}

-(void)addscrollow{
    
    _headScrollow = [[UIScrollView alloc]initWithFrame:CGRectMake(0,-20, MainScreenWidth,MainScreenHeight-10)];
    _headScrollow.delegate = self;
    _headScrollow.alwaysBounceVertical = NO;
    _headScrollow.pagingEnabled = NO;
    //同时单方向滚动
    _headScrollow.directionalLockEnabled = YES;
    _headScrollow.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:_headScrollow];
    _headScrollow.showsVerticalScrollIndicator = NO;
    _headScrollow.showsHorizontalScrollIndicator = NO;
    _headScrollow.delegate = self;
    _headScrollow.backgroundColor = [UIColor whiteColor];
    _headScrollow.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight + 220*MainScreenWidth/320 - 45);
    __weak typeof(self) weakSelf = self;
    [_headScrollow addHeaderWithCallback:^{
        NSLog(@"%@",@"1122");
        [weakSelf.headScrollow headerEndRefreshing];
    }];
}

-(void)creatBody{
    
    headerImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 220*MainScreenWidth/320)];
    [_headScrollow addSubview:headerImageV];
    headerImageV.image = Image(@"组-1");
    
    //头像；
    _aconBtn = [[UIButton alloc]initWithFrame:CGRectMake(MainScreenWidth /2 -35*MainScreenWidth/320, 45*MainScreenWidth/320, 70*MainScreenWidth/320, 70*MainScreenWidth/320)];
    [_headScrollow addSubview:_aconBtn];
    _aconBtn.layer.cornerRadius = 35*MainScreenWidth/320;
    [_aconBtn setImage:Image(@"你好") forState:UIControlStateNormal];
    
    //关键语句
    _aconBtn.layer.borderWidth = 2.0f;//设置边框颜色
    [_aconBtn.layer setBorderColor:[UIColor colorWithHexString:@"#cdcdcd"].CGColor];
    [_aconBtn.layer setBorderWidth:4.0f];
    [_aconBtn.layer setMasksToBounds:YES];
    
    //名字
    _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _aconBtn.current_y_h + 15, MainScreenWidth, 20*MainScreenWidth/320)];
    [_headScrollow addSubview:_nameLab];
    _nameLab.textColor = [UIColor whiteColor];
    //    _nameLab.text = @"哈哈奇偶";
    _nameLab.font = Font(14*MainScreenWidth/320);
    _nameLab.textAlignment = NSTextAlignmentCenter;
    //个性签名
    _speakLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _nameLab.current_y_h + 5, MainScreenWidth, 20*MainScreenWidth/320)];
    [_headScrollow addSubview:_speakLab];
    _speakLab.textColor = [UIColor whiteColor];
    //    _speakLab.text = @"个性签名";
    _speakLab.font = Font(13*MainScreenWidth/320);
    _speakLab.textAlignment = NSTextAlignmentCenter;
    [self addDetilLab];
    
    //    UILabel *backLab = [[UILabel alloc]initWithFrame:CGRectMake(0, headerImageV.current_y_h, MainScreenWidth, 6)];
    //    [_headScrollow addSubview:backLab];
    //    backLab.backgroundColor = [UIColor lightGrayColor];
    //    backLab.alpha = 0.5;
    
    //调用接口
    [self requestData:_ID];
    [self requestLBData:_ID];
}

//课程轮播图
-(void)creatClass{
    
    UILabel *leftColorLab = [[UILabel alloc]initWithFrame:CGRectMake(10,120, 5, 20*MainScreenWidth/320)];
    [_lastScrollow addSubview:leftColorLab];
    leftColorLab.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    
    //课程
    //名字
    UILabel *clessLab = [[UILabel alloc]initWithFrame:CGRectMake(22, leftColorLab.current_y, 180, 20*MainScreenWidth/320)];
    [_lastScrollow addSubview:clessLab];
    clessLab.textColor = [UIColor colorWithHexString:@"#333333"];
    clessLab.text = @"TA的课程";
    clessLab.font = Font(14*MainScreenWidth/320);
    clessLab.textAlignment = NSTextAlignmentLeft;
    
    UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(MainScreenWidth - 10-60*MainScreenWidth/320, clessLab.current_y , 60*MainScreenWidth/320, 20*MainScreenWidth/320)];
    [_lastScrollow addSubview:moreBtn];
    [moreBtn setTitle:@"更多课程" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = Font(13*MainScreenWidth/320);
    [moreBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreBtn) forControlEvents:UIControlEventTouchUpInside];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor whiteColor];
    if (_LBDataArr.count) {
        _scrollView.frame = CGRectMake(0, clessLab.current_y_h + 15,MainScreenWidth, (MainScreenWidth/3 - 16)*54/95 + 20 + 60);
        [self addTeacherScrollView];
    }else{
        _scrollView.frame = CGRectMake(0, clessLab.current_y_h + 15,MainScreenWidth, 0.001);
    }
    self.currentIndex = 0;
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(MainScreenWidth/2 - 50,_scrollView.current_y_h + 5, 100, 20)];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    self.pageControl.currentPage = self.currentIndex;
    self.pageControl.numberOfPages = 4;
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    [_lastScrollow addSubview:_scrollView];
    _scrollView.scrollEnabled = NO;
    //    [_headScrollow addSubview:self.pageControl];
    
    _backLab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, _scrollView.current_y_h + 15, MainScreenWidth, 15)];
    _backLab2.backgroundColor = [UIColor clearColor];
    [_lastScrollow addSubview:_backLab2];

}

//主页相册
-(void)creatXCView{
    
    UILabel *leftColorLab = [[UILabel alloc]initWithFrame:CGRectMake(10,_scrollView.current_y_h +15, 5, 20*MainScreenWidth/320)];
    [_lastScrollow addSubview:leftColorLab];
    leftColorLab.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    
    //课程
    //名字
    UILabel *clessLab = [[UILabel alloc]initWithFrame:CGRectMake(22, leftColorLab.current_y, 160, 20*MainScreenWidth/320)];
    [_lastScrollow addSubview:clessLab];
    clessLab.textColor = [UIColor colorWithHexString:@"#333333"];
    clessLab.text = @"TA的相册";
    clessLab.font = Font(14*MainScreenWidth/320);
    clessLab.textAlignment = NSTextAlignmentLeft;
    
    moreBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(MainScreenWidth - 10-60*MainScreenWidth/320, clessLab.current_y , 60*MainScreenWidth/320, 20*MainScreenWidth/320)];
    [_lastScrollow addSubview:moreBtn2];
    [moreBtn2 setTitle:@"更多相册" forState:UIControlStateNormal];
    moreBtn2.titleLabel.font = Font(13*MainScreenWidth/320);
    [moreBtn2 setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [moreBtn2 addTarget:self action:@selector(moreBtn2) forControlEvents:UIControlEventTouchUpInside];
    
    NSInteger tempNum = _XCDataArr.count;
    if (tempNum>3) {
        tempNum = 3;
    }
    NSInteger width = (MainScreenWidth - 30)/3;
    NSInteger height = width*160/277;
    
    for (int i = 0; i<tempNum; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake( 10 +(width + 5)*(i%3), moreBtn2.current_y_h + 15, width, height)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_XCDataArr[i][@"cover"]]] placeholderImage:[UIImage imageNamed:@"站位图"]];
        [_lastScrollow addSubview:imageView];
        
        //添加手势
        
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]];
        
        //相册标题
        _XClab = [[UILabel alloc]initWithFrame:CGRectMake(0, height, width, 15)];
        [imageView addSubview:_XClab];
        UIColor *color = [UIColor grayColor];
        _XClab.backgroundColor = [color colorWithAlphaComponent:0.4];
        _XClab.text = [NSString stringWithFormat:@"%@",_XCDataArr[i][@"title"]];
        _XClab.textColor =  [UIColor whiteColor];
        _XClab.textAlignment = NSTextAlignmentCenter;
        _XClab.font = Font(12);
        [_lastScrollow addSubview:_XCbtn];
        _XCbtn.backgroundColor = [UIColor clearColor];
        if ([_XCDataArr[i][@"video_count"] integerValue]) {
            _XCbtn.selected = YES;
        }
        [_XCbtn addTarget:self action:@selector(XCBtn:) forControlEvents:UIControlEventTouchUpInside];
        _XCbtn.tag = 100 + i;
        
    }
    int num;
    if (tempNum==0) {
        num = 0;
    }else{
        num = 1;
    }
    
    _backLab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, moreBtn2.current_y_h + height*num + 30, MainScreenWidth, 15)];
    _backLab2.backgroundColor = [UIColor clearColor];
    [_lastScrollow addSubview:_backLab2];
}
//主页的文章
-(void)creatZYWZView{
    
    UILabel *leftColorLab = [[UILabel alloc]initWithFrame:CGRectMake(10,_backLab2.current_y_h , 5, 20*MainScreenWidth/320)];
    [_lastScrollow addSubview:leftColorLab];
    leftColorLab.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    //课程
    //名字
    UILabel *clessLab = [[UILabel alloc]initWithFrame:CGRectMake(22, leftColorLab.current_y, 200, 20*MainScreenWidth/320)];
    [_lastScrollow addSubview:clessLab];
    clessLab.textColor = [UIColor colorWithHexString:@"#333333"];
    clessLab.text = @"TA的文章";
    clessLab.font = Font(14*MainScreenWidth/320);
    clessLab.textAlignment = NSTextAlignmentLeft;
    
    moreBtn3 = [[UIButton alloc]initWithFrame:CGRectMake(MainScreenWidth - 10-60*MainScreenWidth/320, clessLab.current_y , 60*MainScreenWidth/320, 20*MainScreenWidth/320)];
    [_lastScrollow addSubview:moreBtn3];
    [moreBtn3 setTitle:@"更多文章" forState:UIControlStateNormal];
    moreBtn3.titleLabel.font = Font(13*MainScreenWidth/320);
    [moreBtn3 setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [moreBtn3 addTarget:self action:@selector(moreBtn3) forControlEvents:UIControlEventTouchUpInside];
    
    NSInteger tempNum = _WZDataArr.count;
    if (tempNum>2) {
        tempNum = 2;
    }
    UILabel *secondlab;
    for (int i =0; i<tempNum; i++) {
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(10, moreBtn3.current_y_h + 15 +i*60,50, 50)];
        [imgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_WZDataArr[i][@"image"]]] placeholderImage:[UIImage imageNamed:@"站位图"]];
        [_lastScrollow addSubview:imgV];
        
        UILabel *firstLab = [[UILabel alloc]initWithFrame:CGRectMake(imgV.current_x_w + 10, imgV.current_y ,MainScreenWidth - 80 + i*60, 30)];
        firstLab.font = [UIFont systemFontOfSize:13];
        firstLab.textColor = [UIColor colorWithHexString:@"#333333"];
        firstLab.numberOfLines = 2;
        [_lastScrollow addSubview:firstLab];
        
        secondlab = [[UILabel alloc]initWithFrame:CGRectMake(imgV.current_x_w + 10,firstLab.current_y_h, MainScreenWidth - 80, 15)];
        secondlab.font = [UIFont systemFontOfSize:12];
        secondlab.textColor = [UIColor grayColor];
        [_lastScrollow addSubview:secondlab];
        
        firstLab.text = [NSString stringWithFormat:@"%@",_WZDataArr[i][@"art_title"]];
        NSString *starTime = [Passport formatterDate:_WZDataArr[i][@"ctime"]];
        secondlab.text = [NSString stringWithFormat:@"%@",starTime];
    }
    _backLab = [[UILabel alloc]initWithFrame:CGRectMake(0, moreBtn3.current_y_h + 15 +tempNum*60, MainScreenWidth, 12)];
    _backLab.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_lastScrollow addSubview:_backLab];
    [self creatZYDetil];
    
}

-(void)creatZYDetil{
    
    UILabel *leftColorLab = [[UILabel alloc]initWithFrame:CGRectMake(10,_backLab.current_y_h +15, 5, 20*MainScreenWidth/320)];
    [_lastScrollow addSubview:leftColorLab];
    leftColorLab.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    //课程
    //名字
    UILabel *clessLab = [[UILabel alloc]initWithFrame:CGRectMake(22, leftColorLab.current_y, 200, 20*MainScreenWidth/320)];
    [_lastScrollow addSubview:clessLab];
    clessLab.textColor = [UIColor colorWithHexString:@"#333333"];
    clessLab.text = @"更多详情";
    clessLab.font = Font(14*MainScreenWidth/320);
    clessLab.textAlignment = NSTextAlignmentLeft;
//    
//    //详情
//    UITextView *texv = [[UITextView alloc]initWithFrame:CGRectMake(15, clessLab.current_y_h + 10, MainScreenWidth - 30,MainScreenHeight - clessLab.current_y_h - 30 )];
//    texv.textColor = [UIColor blackColor];
//    [_lastScrollow addSubview:texv];
//    texv.showsVerticalScrollIndicator = NO;
//    texv.backgroundColor = [UIColor redColor];
//    texv.font = Font(13);
//    texv.text = [NSString stringWithFormat:@"%@",_dataDic[@"inro"]];
//    
//    if (_dataDic[@"inro"] == nil || [_dataDic[@"inro"] isEqual:[NSNull null]]) {
//        texv.text = @"暂无详情";
//    }
    
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,  clessLab.current_y_h + 10, MainScreenWidth - 30, 30)];
    infoLabel.backgroundColor = [UIColor whiteColor];
    [_lastScrollow addSubview:infoLabel];
    infoLabel.font = Font(13);
    infoLabel.text = _dataDic[@"inro"];
    if (_dataDic[@"inro"] == nil || [_dataDic[@"inro"] isEqual:[NSNull null]]) {
        infoLabel.text = @"暂无详情";
    }
    infoLabel.numberOfLines = 0;
    
    CGRect labelSize = [infoLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
    infoLabel.frame = CGRectMake(15,  clessLab.current_y_h + 10,  MainScreenWidth - 30, labelSize.size.height);
    [_lastScrollow addSubview:infoLabel];
    
    
    
    //自适应
    _lastScrollow.contentSize = CGSizeMake(MainScreenWidth, CGRectGetMaxY(infoLabel.frame) + MainScreenHeight);
    
    
}

//-(void)setIntroductionText:(NSString*)text{
//    //获得当前cell高度
//    //    CGRect frame;
//    //文本赋值
//    _contentLabel.text = text;
//    //设置label的最大行数
//    _contentLabel.numberOfLines = 0;
//    
//    CGRect labelSize = [self.contentLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil];
//    
//    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, MainScreenWidth - 60, labelSize.size.height);
//    
//    
//    //计算出自适应的高度
//    
//    if (_contentLabel.bounds.size.height + 40 > 85) {
//        _topView.frame = CGRectMake(0, 64, MainScreenWidth, CGRectGetMaxY(_contentLabel.frame));
//    } else {
//        _topView.frame = CGRectMake(0, 64, MainScreenWidth, 85);
//    }
//    
//}
//

#pragma mark --- 相册 里面 图片的手势

- (void)imageClick:(UITapGestureRecognizer *)tap {
    
    
    NSLog(@"%@",_XCDataArr);
    NSString *phone_id = _XCDataArr[tap.view.tag][@"id"];
    NSLog(@"%@",phone_id);
    NSString *name = _XCDataArr[tap.view.tag][@"title"];
    
    XCDetilViewController *Vc = [[XCDetilViewController alloc] initwithphoto_id:[phone_id integerValue] name:name teacher_id:_ID];
    [self.navigationController pushViewController:Vc animated:YES];
    
    
//    NSString *photo_id = [NSString stringWithFormat:@"%@",_XCDataArr[num][@"id"]];
//    XCDetilViewController *xcdV = [[XCDetilViewController alloc]initwithphoto_id:[photo_id integerValue]name:[NSString stringWithFormat:@"%@",_XCDataArr[num][@"title"]] teacher_id:_ID];
    
    
//    NSMutableArray *imageArray = [NSMutableArray array];
//    for (int i = 0 ; i < _XCDataArr.count; i ++) {
//        NSString *url = _XCDataArr[i][@"cover"];
//        [imageArray addObject:url];
//    }
//    
//    int count = (int)imageArray.count;
//    // 1.封装图片数据
//    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
//    for (int i = 0; i<count; i++) {
//        // 替换为中等尺寸图片
//        NSString *url = [imageArray[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
//        MJPhoto *photo = [[MJPhoto alloc] init];
//        photo.url = [NSURL URLWithString:url]; // 图片路径
//        photo.srcImageView = _lastScrollow.subviews[i]; // 来源于哪个UIImageView
//        [photos addObject:photo];
//    }
//    // 2.显示相册
//    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
//    browser.photos = photos; // 设置所有的图片
//    [browser show];
    
}


//滚动视图的view
-(UIView *)viewWithframe:(CGRect)frame image:(NSURL *)image title:(NSString *)title moneyTitle:(NSString *)moneyTitle{
    
    UIView *view = [[UIView alloc]initWithFrame:frame];
    [view.layer setBorderColor:[UIColor colorWithHexString:@"#cdcdcd"].CGColor];
    [view.layer setBorderWidth:0.5];
    [view.layer setMasksToBounds:YES];
    view.layer.cornerRadius = 5;
    
    UIImageView *glHeaderImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width*54/95)];
    
    [glHeaderImgV sd_setImageWithURL:image placeholderImage:[UIImage imageNamed:@"站位图"]];
    
    [view addSubview:glHeaderImgV];
    glHeaderImgV.layer.cornerRadius = 5;
    
    UILabel *titlelab = [[UILabel alloc]initWithFrame:CGRectMake(5, glHeaderImgV.current_y_h, frame.size.width - 10, 35)];
    titlelab.text = title;
    titlelab.textColor = [UIColor colorWithHexString:@"#333333"];
    [view addSubview:titlelab];
    titlelab.numberOfLines = 2;
    titlelab.font = Font(11);
    
    UILabel *moneylab = [[UILabel alloc]initWithFrame:CGRectMake(5, titlelab.current_y_h, frame.size.width - 10, 20)];
    moneylab.text = moneyTitle;
    moneylab.textColor = [UIColor redColor];
    if ([moneyTitle isEqualToString:@"免费"]) {
        moneylab.textColor = [UIColor greenColor];
    }

    [view addSubview:moneylab];
    moneylab.font = Font(13);
    
    return view;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (![scrollView isEqual:_headScrollow]) {
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"%f",offsetY);
    if (offsetY >= headerImageV.current_y_h - 20) {
        //将redView控件添加到控制器的view中，设置Y值为0
        CGRect redFrame = _btnView.frame;
        redFrame.origin.y = 0;
        _btnView.frame = redFrame;
        [self.view addSubview:_btnView];
        backButton.hidden = YES;
    }else{
        //将redView控件添加到scrollView中，设置Y值为图片的高度
        CGRect redFrame = _btnView.frame;
        redFrame.origin.y = headerImageV.current_y_h;
        _btnView.frame = redFrame;
        [_headScrollow addSubview:_btnView];
        [backButton setHidden:NO];

    }

}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    [textV resignFirstResponder];
}

//获取简介数据
-(void)requestLJJata:(NSString *)teacher_id
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    //临时的
    [dic setValue:teacher_id forKey:@"teacher_id"];
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"20" forKey:@"count"];
    _JJDataArr = [NSMutableArray array];
    
    [manager getpublicPort:dic mod:@"Teacher" act:@"teacherVideoList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            [_JJDataArr addObjectsFromArray:responseObject[@"data"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//获取相册数据
-(void)requestLXCata:(NSString *)teacher_id
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    //临时的
    [dic setValue:teacher_id forKey:@"teacher_id"];
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"20" forKey:@"count"];
    _XCDataArr = [NSMutableArray array];
    [manager getpublicPort:dic mod:@"Teacher" act:@"getTeacherPhotos" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            [_XCDataArr addObjectsFromArray:responseObject[@"data"]];
            NSLog(@"%@",_XCDataArr);
            
            NSMutableArray *marr = [NSMutableArray array];
            for (int i = 0; i<_XCDataArr.count; i++) {
                
                if ([_XCDataArr[i][@"cover"] length]) {
                    [marr addObject:_XCDataArr[i][@"cover"]];
                }
            }
            [self creatXCView];
            
            [self creatXC];
            
            //添加文章
            [self creatWZView];

            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self creatXCView];
        
        //添加文章
        [self creatWZView];
   
    }];
}
//相册
-(void)creatXC{
    
    for (int i = 0; i<_XCDataArr.count; i++) {
        
        NSInteger width = (MainScreenWidth - 30)/3;
        NSInteger height = width*160/277;
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(MainScreenWidth + 10 +(width + 5)*(i%3), 10+(height + 5)*(i/3), width, height)];
        [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_XCDataArr[i][@"cover"]]] placeholderImage:[UIImage imageNamed:@"站位图"]];
        [_lastScrollow addSubview:img];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, height - 15, width, 15)];
        [img addSubview:lab];
        UIColor *color = [UIColor grayColor];
        lab.backgroundColor = [color colorWithAlphaComponent:0.4];
        lab.text = [NSString stringWithFormat:@"%@",_XCDataArr[i][@"title"]];
        lab.textColor =  [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = Font(12);
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(img.current_x, img.current_y, width, height)];
        [_lastScrollow addSubview:btn];
        btn.backgroundColor = [UIColor clearColor];
        if ([_XCDataArr[i][@"video_count"] integerValue]) {
            btn.selected = YES;
        }
        [btn addTarget:self action:@selector(XCBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.tag = 100 + i;
    }
}

//获取文章数据
-(void)requestLWZata:(NSString *)teacher_id
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    //临时的
    [dic setValue:teacher_id forKey:@"teacher_id"];
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"20" forKey:@"count"];
    _WZDataArr = [NSMutableArray array];
    
    [manager getpublicPort:dic mod:@"Teacher" act:@"getArticleList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            [_WZDataArr addObjectsFromArray:responseObject[@"data"]];
            [_WZtableView reloadData];
        }
        [self creatZYWZView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self creatZYWZView];
        
    }];
}

//最后的滚动视图，简介，文章，详情
-(void)LastView{
    
    //    UILabel *backLab = [[UILabel alloc]initWithFrame:CGRectMake(0,headerImageV.current_y +10, MainScreenWidth, 6)];
    //    [_headScrollow addSubview:backLab];
    //    float heights = MainScreenHeight + backLab.current_y - 49 ;
    //    _headScrollow.contentSize = CGSizeMake(MainScreenWidth,heights);
    //    backLab.backgroundColor = [UIColor lightGrayColor];
    //    backLab.alpha = 0.5;
    NSArray *array = @[@"主页",@"相册",@"文章",@"点评"];
    UIButton *GLButton;
    _btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 220*MainScreenWidth/320, MainScreenWidth, 30*MainScreenWidth/320 + 3)];
    [_headScrollow addSubview:_btnView];
    _btnView.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i<4; i++) {
        
        GLButton = [[UIButton alloc]initWithFrame:CGRectMake(i*MainScreenWidth/4, 0, MainScreenWidth/4, 30*MainScreenWidth/320)];
        [GLButton setTitle:array[i] forState:UIControlStateNormal];
        [_btnView addSubview:GLButton];
        [GLButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        GLButton.titleLabel.font = Font(16);
        GLButton.tag = 100 + i;
        [GLButton addTarget:self action:@selector(moveBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //添加下划线
    _colorLineLable = [[UILabel alloc]initWithFrame:CGRectMake(0, GLButton.current_y_h, MainScreenWidth/4, 3)];
    [_btnView addSubview:_colorLineLable];
    _colorLineLable.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0,_colorLineLable.current_y_h - 1, MainScreenWidth, 1)];
    [_btnView addSubview:line];
    line.backgroundColor = [UIColor lightGrayColor];
    
    _lastScrollow = [[UIScrollView alloc] initWithFrame:CGRectMake(0, headerImageV.current_y_h + 30*MainScreenWidth/320 + 3 ,MainScreenWidth, MainScreenHeight)];
    _lastScrollow.bounces = NO;
    _lastScrollow.backgroundColor = [UIColor whiteColor];
    //最下面的滚动视图
    [self creatLastScrollow];
    
    //同时单方向滚动
//    _lastScrollow.directionalLockEnabled = YES;
    
    //添加简介
    [self creatJianJieView];

    
}
//获取相册数据
-(void)requestWZCata:(NSString *)teacher_id
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    //临时的
    [dic setValue:teacher_id forKey:@"teacher_id"];
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"20" forKey:@"count"];
    _XCDataArr = [NSMutableArray array];
    [manager getpublicPort:dic mod:@"Teacher" act:@"getArticleList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            [_WZDataArr addObjectsFromArray:responseObject[@"data"]];
            
            [_WZtableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)creatWZView{
    
    [self requestLWZata:_ID];
    //添加点评
    [self creatDPView];
    _WZtableView = [[UITableView alloc]initWithFrame:CGRectMake(MainScreenWidth * 2, 10, MainScreenWidth,_lastScrollow.frame.size.height - 10) style:UITableViewStyleGrouped];
    _WZtableView.backgroundColor = [UIColor whiteColor];
    _WZtableView.delegate = self;
    _WZtableView.dataSource = self;
    _WZtableView.tag = 11111;
    _WZtableView.rowHeight = 70;
    _WZtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_lastScrollow addSubview:_WZtableView];
}
#pragma mark -----UITextView delegate-----

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"%@",text);
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

//开始编辑
-(void)textViewDidBeginEditing:(UITextView *)textView

{
    [_lastScrollow setContentOffset:CGPointMake(_lastScrollow.contentOffset.x,180)animated:YES];
}

//完成编辑
-(void)textViewDidEndEditing:(UITextView *)textView

{
    [_lastScrollow setContentOffset:CGPointMake(_lastScrollow.contentOffset.x,_lastScrollow.contentOffset.y )animated:YES];
}

//简介
-(void)creatJianJieView{
    
    
    NSLog(@"%@",_dataDic);
    NSArray *arr = @[@"所在地",@"授课方式"];
    NSString *adress;
    if ([_dataDic[@"ext_info"][@"location"] isKindOfClass:[NSNull class]]) {
        adress = @"";
    }else if (_dataDic[@"ext_info"][@"location"] == nil){
        adress = @"";
    }else{
        adress = [NSString stringWithFormat:@"%@",_dataDic[@"ext_info"][@"location"]];
    }
    NSString *skill = [NSString stringWithFormat:@"%@",_dataDic[@"teach_way"]];
    
    if (_dataDic == nil) {
        skill = @"";
    } else {
        if ([skill integerValue] == 0) {
            skill = @"线下授课";
        }else{
            skill = @"线上授课";
        }
    }

    NSArray *placedarr = @[adress,skill,skill,skill];
    for (int i=0; i<2; i++) {
        
        UILabel *firstLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0+40*i, 100, 40)];
        [_lastScrollow addSubview:firstLab];
        firstLab.text = arr[i];
        firstLab.textColor = [UIColor grayColor];
        firstLab.font = Font(15);
        firstLab.textAlignment = NSTextAlignmentLeft;

        UILabel *line;
        if (i>=2) {
            
        line = [[UILabel alloc]initWithFrame:CGRectMake(15, 0+40*(i+2), MainScreenWidth - 30, 0.5)];
            if (i==2) {
                //个人认证
//                secondLab.frame = CGRectMake(115, 0+40*(i+1), MainScreenWidth - 130, 40);
                for (int j=0; j<0;j++) {
                    
                    UILabel *PBQlab = [[UILabel alloc]initWithFrame:CGRectMake(110+100*(j%2), firstLab.current_y+30*(j/2)+10, 100, 30)];
                    [_lastScrollow addSubview:PBQlab];
                    PBQlab.textColor = [UIColor blackColor];
                    PBQlab.font = Font(14);
                    PBQlab.textAlignment = NSTextAlignmentCenter;
                    PBQlab.text = @"身份认证";
                }
            }else if (i==3){
                
                firstLab.frame = CGRectMake(15, 0+40*(i+1), 100, 40);

            //老师特点
                UILabel *TBQlab;
                for (int j=0; j<0;j++) {
                    
                    TBQlab = [[UILabel alloc]initWithFrame:CGRectMake(110+60*j,165, 50, 30)];
                    [_lastScrollow addSubview:TBQlab];
                    TBQlab.textColor = [UIColor blackColor];
                    TBQlab.font = Font(12);
                    TBQlab.textAlignment = NSTextAlignmentCenter;
                    TBQlab.text = @"老师特点";
                    
                    [TBQlab.layer setBorderColor:[UIColor colorWithHexString:@"#deddde"].CGColor];
                    [TBQlab.layer setBorderWidth:0.5];
                    [TBQlab.layer setMasksToBounds:YES];
                }
            }
            
        }else{
            
            UILabel *secondLab = [[UILabel alloc]initWithFrame:CGRectMake(115, 0+40*i, MainScreenWidth - 130, 40)];
            [_lastScrollow addSubview:secondLab];
            secondLab.text = placedarr[i];
            secondLab.textColor = [UIColor blackColor];
            secondLab.font = Font(14);
            secondLab.textAlignment = NSTextAlignmentLeft;
            line = [[UILabel alloc]initWithFrame:CGRectMake(15, 0+40*(i+1), MainScreenWidth - 30, 0.5)];
        }
        [_lastScrollow addSubview:line];
        line.backgroundColor = [UIColor grayColor];
        line.alpha = 0.6;
    }
    
    
    [self creatClass];
    //    //主页相册
    //    [self creatXCView];
    //    //主页文章
    //    [self creatZYWZView];
    //    //更多资料
    //    UILabel *more = [[UILabel alloc]initWithFrame:CGRectMake(15,200, MainScreenWidth - 30, 40)];
    //    [_lastScrollow addSubview:more];
    //    more.textColor = [UIColor grayColor];
    //    more.font = Font(17);
    //    more.textAlignment = NSTextAlignmentCenter;
    //    more.text = @"更多基本资料";
    //    UILabel *backLab = [[UILabel alloc]initWithFrame:CGRectMake(0, more.current_y_h + 10, MainScreenWidth, 6)];
    //    [_lastScrollow addSubview:backLab];
    //    backLab.backgroundColor = [UIColor lightGrayColor];
    //    backLab.alpha = 0.5;
    //
    //    //详情
    //    UITextView *texv = [[UITextView alloc]initWithFrame:CGRectMake(15, backLab.current_y_h + 10, MainScreenWidth - 30,MainScreenHeight - backLab.current_y_h - 30 )];
    //    texv.textColor = [UIColor blackColor];
    //    [_lastScrollow addSubview:texv];
    //    texv.showsVerticalScrollIndicator = NO;
    //    texv.font = Font(13);
    //    texv.text = [NSString stringWithFormat:@"%@",_dataDic[@"inro"]];
}

//相册
-(void)creatImageViews{
    
    [self requestLXCata:_ID];
    NSLog(@"%@",_XCDataArr);
}

-(void)requestDPData
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:_ID forKey:@"teacher_id"];
    
    [dic setValue:[NSNumber numberWithInteger:1] forKey:@"page"];
    [dic setValue:[NSNumber numberWithInteger:50] forKey:@"count"];
    
    [manager getpublicPort:dic mod:@"Teacher" act:@"getCommentList" success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"----%@",_DPDataArr);
        //        NSArray * array = [responseObject objectForKey:@"data"];
        _DPDataArr = [NSMutableArray arrayWithArray:responseObject[@"data"]];
        int tempNum = (int)_DPDataArr.count;
        _GLTXlab.textColor = [UIColor clearColor];
//        _TF3.text = @"";
//        _TF2.text = @"";
//        _TF1.text = @"";
        
        if (tempNum==0) {
            _GLTXlab.text = @"此讲师还没有点评";
            _GLTXlab.font = Font(13);
            _GLTXlab.textColor = [UIColor grayColor];
            _GLTXlab.textAlignment = NSTextAlignmentCenter;
            tempNum=1;
            
        }else if (tempNum>3){
            
            tempNum=3;
        }
        _view.frame = CGRectMake(MainScreenWidth*3, 15, MainScreenWidth, (60*MainScreenWidth/320 + 18)*tempNum);
//        _tableView.frame = CGRectMake(0, 0, MainScreenWidth - 20, (60*MainScreenWidth/320 + 18)*tempNum);
        if (!_TF1) {
//            [self creatDP];

        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [_tableView reloadData];
//        [self creatDP];
    }];
}

-(void)creatDPView{
    
    _view = [[UIView alloc]initWithFrame:CGRectMake(MainScreenWidth*3, 15, MainScreenWidth, MainScreenHeight)];
    [_lastScrollow addSubview:_view];
    _view.backgroundColor = [UIColor whiteColor];
    
    //添加按钮
    UIButton *commentButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 40, 0, 30, 20)];
    [commentButton setBackgroundImage:Image(@"552cc17f5bb87_32@2x.png") forState:UIControlStateNormal];
    [_view addSubview:commentButton];
    [commentButton addTarget:self action:@selector(commentButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 30, MainScreenWidth - 20, MainScreenHeight - 50 - 30) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.rowHeight = 60*MainScreenWidth/320 + 18;
    [_view addSubview:_tableView];
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _GLTXlab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, MainScreenWidth - 20, 40)];
    [_view addSubview:_GLTXlab];
    [self requestDPData];
}

- (void)commentButtonCilck {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
        
    }
    
    SYGDPViewController *SYGDPVC = [[SYGDPViewController alloc] init];
    UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:SYGDPVC];
    SYGDPVC.ID = _ID;
    SYGDPVC.isTeacher = @"teacher";
    [self.navigationController presentViewController:Nav animated:YES completion:nil];
    

}

-(void)creatDP{
    
    //四个textfiled
    NSArray *arr = @[@"  授课技巧",@"  专业知识",@"  授课态度",@"  课程"];
    NSArray *placedarr = @[@"请选择评分",@"请选择评分",@"请选择评分",@"    —— ——"];
    UIButton *tfBtn;
    for (int i = 0; i<3; i++) {
        if (i%2==0) {
            _TF = [[UITextField alloc]initWithFrame:CGRectMake(MainScreenWidth * 3 + 10*MainScreenWidth/320,_view.current_y_h + 20 + (i/2)*(25*MainScreenWidth/320 + 15),140*MainScreenWidth/320,25*MainScreenWidth/320)];
        }else{
            
            _TF = [[UITextField alloc]initWithFrame:CGRectMake( MainScreenWidth * 3 + MainScreenWidth - 10*MainScreenWidth/320 - 140*MainScreenWidth/320,_view.current_y_h + 20 +  (i/2)*(25*MainScreenWidth/320 + 15),140*MainScreenWidth/320,25*MainScreenWidth/320)];
        }
        
        tfBtn = [[UIButton alloc]initWithFrame:_TF.frame];
        _TF.borderStyle = UITextBorderStyleNone;
        _TF.textColor = [UIColor colorWithHexString:@"#999999"];
        _TF.font = [UIFont systemFontOfSize:10*MainScreenWidth/320];
        [_lastScrollow addSubview:_TF];
        [_lastScrollow addSubview:tfBtn];
        [tfBtn addTarget:self action:@selector(touchClick:) forControlEvents:UIControlEventAllEvents];
        tfBtn.tag = i + 1314;
        //设置输入框内容的字体样式和大小
        //_TF.font = [UIFont fontWithName:@"Arial" size:15*horizontalrate];
        //设置字体颜色
        _TF.textColor = [UIColor colorWithHexString:@"#333333"];
        //UITextField左右视图
        UILabel * leftView=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100*horizontalrate, 25*MainScreenWidth/320)];
        leftView.contentMode = UIViewContentModeLeft;
        leftView.textAlignment = NSTextAlignmentLeft;
        leftView.text = arr[i];
        leftView.font = [UIFont systemFontOfSize:10*MainScreenWidth/320];
        leftView.textColor = [UIColor colorWithHexString:@"#333333"] ;
        //占位符字体颜色
        NSDictionary *dic = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"], NSFontAttributeName:[UIFont systemFontOfSize:10*MainScreenWidth/320]};
        _TF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",placedarr[i]]attributes:dic];
        if (i==3) {
            leftView.frame = CGRectMake(0, 0, 50*horizontalrate, 25*MainScreenWidth/320);
        }
        _TF.leftView=leftView;
        _TF.leftViewMode=UITextFieldViewModeAlways;
        [_TF.layer setBorderColor:[UIColor colorWithHexString:@"#cdcdcd"].CGColor];
        [_TF.layer setBorderWidth:0.5];
        [_TF.layer setMasksToBounds:YES];
        
        if (i==0) {
            _TF1 = _TF;
        }
        if (i==1) {
            _TF2 = _TF;
        }
        if (i==2) {
            _TF3 = _TF;
        }
        if (i==3) {
            _TF4 = _TF;
        }
    }
    
    _popV = [self viewWithFrame:CGRectMake(0,0, _TF.current_w, 10+60*MainScreenWidth/320)];
    textV = [[GLTextView alloc]initWithFrame:CGRectMake(_TF3.current_x, _TF3.current_y_h + 15, MainScreenWidth - 20*MainScreenWidth/320, 100)];
    [_lastScrollow addSubview:textV];
    textV.backgroundColor = [UIColor whiteColor];
    [textV setPlaceholder:@"请填写详细评价内容"];
    [textV setFont:[UIFont systemFontOfSize:10*MainScreenWidth/320]];
    [textV.layer setBorderColor:[UIColor colorWithHexString:@"#cdcdcd"].CGColor];
    [textV.layer setBorderWidth:0.5];
    [textV.layer setMasksToBounds:YES];
    textV.delegate = self;
    
    //星星评价
    UILabel *PFLab = [[UILabel alloc]initWithFrame:CGRectMake(MainScreenWidth*3 + 10*MainScreenWidth/320, textV.current_y_h + 10, 31*MainScreenWidth/320, 20*MainScreenWidth/320)];
    [_lastScrollow addSubview:PFLab];
    PFLab.text = @"评分：";
    PFLab.font = Font(10*MainScreenWidth/320);
    PFLab.textColor = [UIColor colorWithHexString:@"#333333"];
    
    //添加星级
    _starArr = [NSArray array];
    NSMutableArray *marr = [NSMutableArray array];
    for (int i = 0 ; i < 5; i ++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(PFLab.current_x_w + 15 * i + 10 * i, PFLab.current_y, 15, 15)];
        CGPoint center = button.center;
        center.y = PFLab.center.y;
        button.center = center;
        [button setBackgroundImage:[UIImage imageNamed:@"未评论"] forState:UIControlStateNormal];
        button.tag = i + 1;
        [button addTarget:self action:@selector(XJPL:) forControlEvents:UIControlEventTouchUpInside];
        [_lastScrollow addSubview:button];
        [marr addObject:button];
    }
    _starArr = [marr copy];
    //发表按钮
    UIButton *FBBtn = [[UIButton alloc]initWithFrame:CGRectMake(MainScreenWidth*4 - 75 -10*MainScreenWidth/320, PFLab.current_y, 75, 25)];
    [FBBtn setTitle:@"发表" forState:UIControlStateNormal];
    [FBBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    FBBtn.backgroundColor = [UIColor colorWithHexString:@"#66ccff"];
    [FBBtn addTarget:self action:@selector(TJBtn) forControlEvents:UIControlEventTouchUpInside];
    [_lastScrollow addSubview:FBBtn];
    FBBtn.titleLabel.font = Font(13);
    FBBtn.layer.cornerRadius = 3;
}

//收回键盘
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

-(UIView *)viewWithFrame:(CGRect)frame{
    
    NSArray *arr = @[@"优",@"良",@"好"];
    UIView *view = [[UIView alloc]initWithFrame:frame];
    [view.layer setBorderColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1].CGColor];
    [view.layer setBorderWidth:0.5];
    [view.layer setMasksToBounds:YES];
    view.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i<3; i++) {
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, i*20*MainScreenWidth/320, frame.size.width - 20*MainScreenWidth/320, 20*MainScreenWidth/320)];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectSource:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = Font(12*MainScreenWidth/320);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10, btn.current_y_h, _TF.current_w, 0.5)];
        [view addSubview:line];
        line.backgroundColor = [UIColor grayColor];
        line.alpha = 0.6;
        btn.tag = 123+ i;
    }
    return view;
}

-(UIView *)classViewWithFrame:(CGRect)frame{
    
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    UIColor *color = [UIColor lightGrayColor];
    color = [color colorWithAlphaComponent:0.7];
    view.backgroundColor = color;
    _classtableView = [[UITableView alloc]initWithFrame:CGRectMake(30, 40 , MainScreenWidth - 60 ,frame.size.height - 80) style:UITableViewStyleGrouped];
    _classtableView.backgroundColor = [UIColor whiteColor];
    _classtableView.delegate = self;
    _classtableView.dataSource = self;
    _classtableView.tag = 10000;
    _classtableView.rowHeight = 30;
    [view addSubview:_classtableView];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15, 25, 20, 20)];
    //    btn.backgroundColor = [UIColor whiteColor];
    [btn setImage:Image(@"GLCancle.jpg") forState:UIControlStateNormal];
    [view addSubview:btn];
    [btn addTarget:self action:@selector(glcancel) forControlEvents:UIControlEventTouchUpInside];
    return view;
    
}

//监听textFiled
-(void)touchClick:(UIButton *)sender{
    
    if (sender.tag == 1317) {
        if (_DPDataArr.count==0) {
            [MBProgressHUD showError:@"此讲师还没有课程" toView:self.view];
            return;
        }
        if (_GLPV) {
            [_GLPV removeFromSuperview];
        }
        _GLPV = [self classViewWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
        [self.view addSubview:_GLPV];
        return;
    }
    
    [self.view endEditing:YES];
    [_popV setHidden:NO];
    UIButton *tft = sender;
    [_lastScrollow addSubview:_popV];
    _popV.tag = sender.tag;
    _popV.frame = CGRectMake(tft.current_x, tft.current_y_h, sender.current_w, 10+60*MainScreenWidth/320);
}

#pragma mark -- UITableViewDatasoure
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 10000) {
        
        return _LBDataArr.count;
    }
    if (tableView.tag == 11111) {
        
        return _WZDataArr.count;
    }
    return _DPDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 10000) {
        
        NSString * identifier= @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,MainScreenWidth - 60, 30)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lab];
        lab.text = [NSString stringWithFormat:@"%@",_LBDataArr[indexPath.row][@"video_title"]];
        cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    if (tableView.tag == 11111) {
        
        NSString * identifier= @"WZTableViewCell";
        WZTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[WZTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        
        [cell.ImagV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_WZDataArr[indexPath.row][@"image"]]] placeholderImage:[UIImage imageNamed:@"站位图"]];
        cell.firstLab.text = [NSString stringWithFormat:@"%@",_WZDataArr[indexPath.row][@"art_title"]];
        NSString *starTime = [Passport formatterDate:_WZDataArr[indexPath.row][@"ctime"]];
        cell.secondlab.text = [NSString stringWithFormat:@"%@",starTime];
        return cell;
    }
    
    static NSString *cellID = @"GLTeacherTableViewCell";
    GLTeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSArray *tempArray = @[@"good",@"优",@"良",@"好"];
    if (!cell) {
        cell = [[GLTeacherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    
    NSLog(@"%@",_DPDataArr);
    
    [cell.ImagV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_DPDataArr[indexPath.row][@"userface"]]] placeholderImage:[UIImage imageNamed:@"站位图"]];
    //        cell.firstLab.text = [NSString stringWithFormat:@"综",_DPDataArr[indexPath.row][@"skill"]];
    cell.secondlab.text = [NSString stringWithFormat:@"%@",_DPDataArr[indexPath.row][@"review_description"]];
    
    int first = [[NSString stringWithFormat:@"%@",_DPDataArr[indexPath.row][@"professional"]] intValue];
    int second = [[NSString stringWithFormat:@"%@",_DPDataArr[indexPath.row][@"attitude"]] intValue];
    int third = [[NSString stringWithFormat:@"%@",_DPDataArr[indexPath.row][@"skill"]] intValue];
    NSLog(@"===----===%@",_DPDataArr);
    cell.secondlab.text = [NSString stringWithFormat:@"授课技巧：%@  专业知识：%@  授课态度：%@",tempArray[third],tempArray[first],tempArray[second]];
    cell.lastLab.text = [NSString stringWithFormat:@"%@",_DPDataArr[indexPath.row][@"review_description"]];
    cell.namelab.text = [NSString stringWithFormat:@"%@",_DPDataArr[indexPath.row][@"username"]];
    cell.timeLab.text = [NSString stringWithFormat:@"%@",_DPDataArr[indexPath.row][@"strtime"]];
    
    int length = [[NSString stringWithFormat:@"%@",_DPDataArr[indexPath.row][@"star"]] intValue];
    if (length == 1) {
        [cell.Starbtn setBackgroundImage:[UIImage imageNamed:@"101@2x"] forState:UIControlStateNormal];
    }
    
    if (length == 2) {
        [cell.Starbtn setBackgroundImage:[UIImage imageNamed:@"102@2x"] forState:UIControlStateNormal];
    } else {
        [cell.Starbtn setBackgroundImage:[UIImage imageNamed:@"100@2x"] forState:UIControlStateNormal];
    }
    if (length == 3) {
        
        [cell.Starbtn setBackgroundImage:[UIImage imageNamed:@"103@2x"] forState:UIControlStateNormal];
    }
    
    if (length == 4) {
        
        [cell.Starbtn setBackgroundImage:[UIImage imageNamed:@"104@2x"] forState:UIControlStateNormal];
    }
    if (length == 5) {
        [cell.Starbtn setBackgroundImage:[UIImage imageNamed:@"105@2x"] forState:UIControlStateNormal];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView.tag == 10000) {
        _className = [NSString stringWithFormat:@"%@",_LBDataArr[indexPath.row][@"video_title"]];
        _classID = [NSString stringWithFormat:@"%@",_LBDataArr[indexPath.row][@"course_id"]];
        _TF4.text = _className;
        _GLPV.hidden = YES;
    }
    
    //classDetailVC *classDVc = [[classDetailVC alloc] initWithMemberId:_lookArray[indexPath.row][@"id"] andPrice:nil andTitle:_lookArray[indexPath.row][@"video_title"]];
    //classDVc.isLoad = @"123";
    // [self.navigationController pushViewController:classDVc animated:YES];
}

-(void)creatLastScrollow{
    
    [_headScrollow addSubview:_lastScrollow];
    _lastScrollow.contentSize = CGSizeMake(MainScreenWidth * 4,MainScreenHeight * 2);
//    _lastScrollow.backgroundColor = [UIColor whiteColor];
    _lastScrollow.showsHorizontalScrollIndicator = NO;
    _lastScrollow.showsVerticalScrollIndicator = NO;
    _lastScrollow.pagingEnabled = YES;
    _lastScrollow.delegate = self;
    _lastScrollow.tag = 1001;
    _lastScrollow.bounces = NO;
}

#pragma mark -- 添加滚动轮播图
- (void)addTeacherScrollView{
    
    _scrollView.contentSize = CGSizeMake(MainScreenWidth * 4, 0);
//    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.tag = 1024;
    
    if (_LBDataArr.count == 0) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, MainScreenWidth, 30)];
        lab.text = @"此讲师还没有课程";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = Font(13);
        lab.textColor = [UIColor colorWithHexString:@"#333333"];
        [_scrollView addSubview:lab];
    }
    
    for (int j = 0; j<_LBDataArr.count; j++) {

        NSString *moneyStr = nil;
        if ([_LBDataArr[j][@"mzprice"][@"price"] integerValue] == 0) {
            moneyStr = @"免费";
        } else {
            moneyStr = [NSString stringWithFormat:@"¥%@",_LBDataArr[j][@"mzprice"][@"price"]];
        }
        UIView *view = [self viewWithframe:CGRectMake((MainScreenWidth/3 - 16)*j + (12*(j+1)),0,  MainScreenWidth/3 - 16, (MainScreenWidth/3 - 16)*54/95 + 65) image:[NSURL URLWithString:_LBDataArr[j][@"imageurl"]] title:[ NSString stringWithFormat:@"%@",_LBDataArr[j][@"video_title"]] moneyTitle:moneyStr];
        [_scrollView addSubview:view];
        
        UIButton *firstBtn = [[UIButton alloc] initWithFrame:CGRectMake((MainScreenWidth/3 - 16)*j + (12*(j+1)),0,  MainScreenWidth/3 - 16,  (MainScreenWidth/3 - 16)*54/95 + 65)];
        firstBtn.tag = 100 +j;
        [firstBtn addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:firstBtn];
            firstBtn.layer.cornerRadius = 5;
    }

    
}

-(void)addDetilLab{
    
    _LabArr = [NSArray array];
    NSArray *arr = @[@"年龄",@"课程",@"关注"];
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 0 ; i < arr.count; i++) {
        
        UILabel *topLab = [[UILabel alloc]initWithFrame:CGRectMake(i*MainScreenWidth/arr.count, _speakLab.current_y_h + 18*MainScreenWidth/320, MainScreenWidth/arr.count, 15*MainScreenWidth/320)];
        topLab.textAlignment = NSTextAlignmentCenter;
        topLab.textColor = [UIColor whiteColor];
        topLab.textAlignment = NSTextAlignmentCenter;
        topLab.font = Font(13*MainScreenWidth/375);
        [_headScrollow addSubview:topLab];
        //        topLab.text = arr[i];
        [tempArr addObject:topLab];
        
        //        UILabel *bomLab = [[UILabel alloc]initWithFrame:CGRectMake(i*MainScreenWidth/arr.count, _speakLab.current_y_h + 33*MainScreenWidth/320, MainScreenWidth/arr.count, 15*MainScreenWidth/320)];
        //        bomLab.textAlignment = NSTextAlignmentCenter;
        //        bomLab.textColor = [UIColor whiteColor];
        //        bomLab.font = Font(13*MainScreenWidth/375);
        //        [_headScrollow addSubview:bomLab];
        //        bomLab.text = arr[i];
        
        //        if (i>0) {
        //            UILabel *centerlineLab = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*MainScreenWidth/arr.count, _speakLab.current_y_h + 18*MainScreenWidth/320, 1, 30*MainScreenWidth/320)];
        //            centerlineLab.backgroundColor = [UIColor whiteColor];
        //            [_headScrollow addSubview:centerlineLab];
        //        }
    }
    _LabArr = [tempArr copy];
}

//scrollow的滚动事件
-(void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView{
    
    if (scrollView.tag == 1001) {
        
        int num = scrollView.contentOffset.x/MainScreenWidth;
        CGRect frame = _colorLineLable.frame;
        frame.origin.x = num*MainScreenWidth/4;
        
        [UIView animateWithDuration:0.2 animations:^{
            _colorLineLable.frame = frame;
            _lastScrollow.contentOffset = CGPointMake(MainScreenWidth*num, 0);
            if (num == 0) {
//                _lastScrollow.contentOffset = CGPointMake(0, MainScreenHeight);
            }
        }];
        
    }else if (scrollView.tag == 1024){
        
        int num = scrollView.contentOffset.x/MainScreenWidth;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.currentIndex = num;
            self.pageControl.currentPage = self.currentIndex;
        }];
    }
}

#define mac ------------------------------ 按钮点击事件----------------

-(void)XCBtn:(UIButton *)sender{
    NSInteger num = sender.tag - 100;
    
    //去视频
    if (sender.selected == YES) {
        NSLog(@"_____%@--%ld",_ID,num);
        
        NSString *video_id = [NSString stringWithFormat:@"%@",_XCDataArr[num][@"id"]];
        XCVideoViewController *xcdV = [[XCVideoViewController alloc]initwithvideo_id:[video_id integerValue]name:[NSString stringWithFormat:@"%@",_XCDataArr[num][@"title"]] teacher_id:_ID];
        [self.navigationController pushViewController:xcdV animated:YES];
        return;
    }
    //去相册
    NSString *photo_id = [NSString stringWithFormat:@"%@",_XCDataArr[num][@"id"]];
    
    NSLog(@"%@",photo_id);
    XCDetilViewController *xcdV = [[XCDetilViewController alloc]initwithphoto_id:[photo_id integerValue]name:[NSString stringWithFormat:@"%@",_XCDataArr[num][@"title"]] teacher_id:_ID];
    [self.navigationController pushViewController:xcdV animated:YES];
}

//取消
-(void)glcancel{
    
    _GLPV.hidden = YES;
}

//更多按钮
-(void)moreBtn{
    
    GLClassViewController *glVc = [[GLClassViewController alloc]initWithData:_LBDataArr title:[NSString stringWithFormat:@"%@",_nameStr] teacher_id:_ID];
    [self.navigationController pushViewController:glVc animated:YES];
    NSLog(@"12");
}

//更多相册按钮
-(void)moreBtn2{
    
    int num = _colorLineLable.current_y;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _lastScrollow.contentOffset = CGPointMake(MainScreenWidth, 0);
        _colorLineLable.frame = CGRectMake(1*MainScreenWidth/4, num, MainScreenWidth/4, 3);
        [_headScrollow setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }];
    
    [self.view endEditing:YES];
    
    NSLog(@"12");
    
}
//更多相册按钮
-(void)moreBtn3{
    
    int num = _colorLineLable.current_y;
    [UIView animateWithDuration:0.5 animations:^{
        
        _lastScrollow.contentOffset = CGPointMake(2*MainScreenWidth, 0);
        _colorLineLable.frame = CGRectMake(2*MainScreenWidth/4, num, MainScreenWidth/4, 3);
        [_headScrollow setContentOffset:CGPointMake(0, 0) animated:YES];
    }];
    
    [self.view endEditing:YES];
}
//添加关注
- (void)GZTJ {
    //
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
    
    [manager userAttention:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = responseObject[@"msg"];
//        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {//添加成功
//            [MBProgressHUD showSuccess:@"关注成功" toView:self.view];
//            _GZlab.text = @"已关注";
//            //            [_GZButton setTitle:@"已关注" forState:UIControlStateNormal];
//            
//        }else {//添加失败
//            [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
//            return ;
//        }
        
        if ([responseObject[@"data"][@"following"] integerValue] == 1) {
            [MBProgressHUD showSuccess:@"关注成功" toView:self.view];
            _GZlab.text = @"已关注";
            return ;
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    promptAlert =NULL;
}

- (void)GZLT:(UIButton *)button {
    
    if (button.tag == 0) {//关注
        NSLog(@"%@",button.titleLabel.text);
        if ([_GZlab.text isEqualToString:@"关注"]) {
            [self GZTJ];
        }else {
            [self GZNO];
        }
    }
    if (button.tag == 1) {//聊天
        //进入私信界面
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
            
            DLViewController *DLVC = [[DLViewController alloc] init];
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
            [self.navigationController presentViewController:Nav animated:YES completion:nil];
            return;
        }
        MessageSendViewController *MSVC = [[MessageSendViewController alloc] init];
        MSVC.TID = _uID;
        MSVC.name = _nameStr;
        NSLog(@"--%@",_nameStr);
        [self.navigationController pushViewController:MSVC animated:YES];
    }
}

//取消关注
- (void)GZNO {
    
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
//        if ([responseObject[@"msg"] isEqualToString:@"ok"]) {//取消成功
//            [MBProgressHUD showSuccess:@"取消关注成功" toView:self.view];
//            _GZlab.text = @"关注";
//        }else {//取消失败
//            [MBProgressHUD showError:@"取消关注失败" toView:self.view];
//        }
        
        if ([responseObject[@"data"][@"following"] integerValue] == 0) {
            [MBProgressHUD showError:@"取消关注成功" toView:self.view];
            _GZlab.text = @"关注";
        } else {
            [MBProgressHUD showError:@"取消关注失败" toView:self.view];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MBProgressHUD showError:@"取消关注失败" toView:self.view];
    }];
}

//点击评分的button
- (void)XJPL:(UIButton *)button {
    
    int num = (int)button.tag;
    _starStr = [NSString stringWithFormat:@"%d",num];
    [UIView animateWithDuration:0.2 animations:^{
        
        for (int j = 0; j<5; j++) {
            
            [_starArr[j] setBackgroundImage:[UIImage imageNamed:@"未评论"] forState:UIControlStateNormal];
        }
        for (int i = 0; i<num; i++) {
            
            [_starArr[i] setBackgroundImage:[UIImage imageNamed:@"GL已评论@2x"] forState:UIControlStateNormal];
        }
    }];
}

-(void)leftMoerBt:(UIButton *)sender{
    [self.view endEditing:YES];
    
    [contentVC dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)rightMore:(UIButton *)sender{
    [self.view endEditing:YES];
    
    contentVC=[[UIViewController alloc]init];
    //初始化内容视图控制器
    //设置大小
    contentVC.preferredContentSize = CGSizeMake(85, 100);
    // 设置弹出效果
    contentVC.modalPresentationStyle = UIModalPresentationPopover;
    //初始化一个popover
    self.popover = contentVC.popoverPresentationController;
    self.popover.delegate = self;
    //设置弹出视图的颜色
    //    self.popover.backgroundColor = [UIColor whiteColor];
    //设置popover的来源按钮（以button谁为参照）
    self.popover.sourceView = sender;
    //设置弹出视图的位置（以button谁为参照）
    self.popover.sourceRect = sender.bounds;
    //箭头的方向 设置成UIPopoverArrowDirectionAny 会自动转换方向
    self.popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    //模态出弹框
    [self presentViewController:contentVC animated:YES completion:nil];
    
    NSArray *dataA = @[@"关注讲师",@"私信",@"分享"];
    for (int j = 0; j<3; j++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10 ,10 + j*31, 65, 20)];
        [button addTarget:self action:@selector(leftMoerBt:) forControlEvents:UIControlEventTouchUpInside];
        [contentVC.view addSubview:button];
        //设置button正常状态下的图片
        [button setImage:[UIImage imageNamed:@"Like"] forState:UIControlStateNormal];
        //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
        button.imageEdgeInsets = UIEdgeInsetsMake(4, 0, 4, 53);
        [button setTitle:dataA[j] forState:UIControlStateNormal];
        //button标题的偏移量，这个偏移量是相对于图片的
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        button.titleLabel.textAlignment = NSTextAlignmentLeft;
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        button.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10,button.current_y_h+2, 60, 0.5)];
        [contentVC.view addSubview:line];
        line.backgroundColor = [UIColor grayColor];
        line.alpha = 0.6;
        button.tag = 110 +j;
    }
}

-(void)TJBtn{
    
    if ([_TF1.text isEqualToString:@"优"]) {
        _num1 = 1;
    }else  if ([_TF1.text isEqualToString:@"良"]) {
        _num1 = 2;
    }else if ([_TF1.text isEqualToString:@"好"]) {
        _num1 = 3;
    }
    
    if ([_TF2.text isEqualToString:@"优"]) {
        _num2 = 1;
    }else  if ([_TF2.text isEqualToString:@"良"]) {
        _num2 = 2;
    }else if ([_TF2.text isEqualToString:@"好"]) {
        _num2 = 3;
    }
    if ([_TF3.text isEqualToString:@"优"]) {
        _num3 = 1;
    }else  if ([_TF3.text isEqualToString:@"良"]) {
        _num3 = 2;
    }else if ([_TF3.text isEqualToString:@"好"]) {
        _num3 = 3;
    }
    _description = [NSString stringWithFormat:@"%@",textV.text];
    
    //判断是否登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        
    }else {//已经登录
        [self sureRequest];
    }
    [self.view endEditing:YES];
}

- (void)SYGBuy1 {
    
    //网络请求下自己账户中得金额
    ZhiyiHTTPRequest *manager =[ZhiyiHTTPRequest manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    [manager reloadUserbalance:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _moneyDic = [[NSMutableDictionary alloc]initWithDictionary:[responseObject objectForKey:@"data"]];
        //添加剩余的钱
        UILabel *SYLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, MainScreenWidth / 2, 20)];
        NSString *SYQString = [NSString stringWithFormat:@"%@",_moneyDic[@"balance"]];
        SYLabel.text = [NSString stringWithFormat:@"目前剩余%@元",SYQString];
        
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:SYLabel.text];
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:59.f / 255 green:140.f / 255 blue:255.f / 255 alpha:1] range:NSMakeRange(4, SYQString.length)];
        [SYLabel setAttributedText:noteStr] ;
        SYLabel.font = [UIFont systemFontOfSize:12];
        SYLabel.textAlignment = NSTextAlignmentCenter;
        [_buyView addSubview:SYLabel];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"获取数据失败" toView:self.view];
        return ;
    }];
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:_allView];
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(MissBuyView) forControlEvents:UIControlEventTouchUpInside];
    [_allView addSubview:_allButton];
    
    //创建个VIew
    _buyView = [[UIView alloc] init];
    _buyView.center = self.view.center;
    _buyView.bounds = CGRectMake(0, 0,MainScreenWidth / 2, 260);
    _buyView.backgroundColor = [UIColor colorWithRed:254.f / 255 green:255.f / 255 blue:255.f / 255 alpha:1];
    _buyView.layer.cornerRadius = 5;
    [_allView addSubview:_buyView];
    //view上面添加空间
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10,MainScreenWidth / 2 , 30)];
    topLabel.text = @"购买提示";
    topLabel.font = [UIFont systemFontOfSize:14];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [_buyView addSubview:topLabel];
    
    UILabel *needMoney = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, MainScreenWidth / 2, 20)];
    needMoney.font = [UIFont systemFontOfSize:12];
    needMoney.textAlignment = NSTextAlignmentCenter;
    needMoney.text = [NSString stringWithFormat:@"需要消耗%@元",_moneyString];
    [_buyView addSubview:needMoney];
    
    //添加几个按钮
    NSArray *titleString = @[@"购买",@"充值",@"取消"];
    for (int i = 0 ; i < 3; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10 , 110 + 35 * i + 10 * i , MainScreenWidth / 2 - 20, 35)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:titleString[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:145.f / 255 green:148.f / 255 blue:155.f / 255 alpha:1] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:232.f / 255 green:235.f / 255 blue:243.f / 255 alpha:1];
        button.layer.cornerRadius = 5;
        button.tag = i;
        [button addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
        [_buyView addSubview:button];
    }
}

- (void)pressed:(UIButton *)button {
    
    NSInteger Num = button.tag;
    if (Num == 1104 ) {//支付宝
        
        if (isArgree == NO) {
            [MBProgressHUD showError:@"请先同意协议" toView:self.view];
            return;
        } else {
            [self YYrequestData];
        }
    } else if (Num == 1105) {//微信
        if (isArgree == NO) {
            [MBProgressHUD showError:@"请先同意协议" toView:self.view];
            return;
        } else {
            //            AlipayViewController *alipayVc = [[AlipayViewController alloc] init];
            //            [self.navigationController pushViewController:alipayVc animated:YES];
        }
        
    } else if (Num == 1106) {//取消
        
    }
    [self MissBuyView];
    
}
- (void)MissBuyView {
    
    [_allView removeFromSuperview];
    [_allButton removeFromSuperview];
    [_buyView removeFromSuperview];
}
-(void)sureRequest
{
    QKHTTPManager * manager = [QKHTTPManager manager];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *key = [ user objectForKey:@"oauthToken"];
    NSString *passWord = [ user objectForKey:@"oauthTokenSecret"];    //临时的
    NSInteger tempNum = [_starStr integerValue];
    
    NSDictionary *parameter=@{@"oauth_token": key,@"oauth_token_secret": passWord , @"teacher_id":_ID,@"skill": [NSString stringWithFormat:@"%d",_num1],@"professional":[NSString stringWithFormat:@"%d",_num2],@"attitude":[NSString stringWithFormat:@"%d",_num3],@"content": _description,@"is_secret":@"",@"score": [NSString stringWithFormat:@"%ld",tempNum]};
    
    [manager getpublicPort:parameter mod:@"Teacher" act:@"addReview" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"===__===%@",responseObject);
        NSLog(@"%@",responseObject[@"msg"]);
        [self requestDPData];
        [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"提交失败" toView:self.view];
    }];
}

- (void)SYGBuy {
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:_allView];
    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(MissBuyView) forControlEvents:UIControlEventTouchUpInside];
    [_allView addSubview:_allButton];
    
    //创建个VIew
    CGFloat BuyViewW = MainScreenWidth / 4 * 3;
    _buyView = [[UIView alloc] init];
    _buyView.center = self.view.center;
    _buyView.bounds = CGRectMake(0, 0,MainScreenWidth / 4 * 3, 250);
    _buyView.backgroundColor = [UIColor colorWithRed:254.f / 255 green:255.f / 255 blue:255.f / 255 alpha:1];
    _buyView.layer.cornerRadius = 5;
    [_allView addSubview:_buyView];
    
    //view上面添加空间
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,BuyViewW , 40)];
    topLabel.text = @"购买提示";
    topLabel.font = Font(18);
    topLabel.backgroundColor = BasidColor;
    topLabel.textColor = [UIColor whiteColor];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [_buyView addSubview:topLabel];
    
    UILabel *needMoney = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 50, MainScreenWidth / 2, 20)];
    needMoney.font = Font(15);
    needMoney.text = [NSString stringWithFormat:@"需支付:  %@ ¥",_price];
    [_buyView addSubview:needMoney];
    
    //使用优惠券
    UILabel *counpLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 80, BuyViewW - 40, 20)];
    counpLabel.text = @"使用优惠券：";
    counpLabel.font = Font(15);
    [_buyView addSubview:counpLabel];
    //选择的按钮
    UIButton *counpButton = [[UIButton alloc] initWithFrame:CGRectMake(BuyViewW - 30, 80, 20, 20)];
    [counpButton setImage:Image(@"灰色乡下") forState:UIControlStateNormal];
    [counpButton addTarget:self action:@selector(counpButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    counpButton.tag = 0;
    [_buyView addSubview:counpButton];
    
    //添加同意按钮
    isArgree = NO;
    UIButton *argreeButton = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside, 110, 20, 20)];
    [argreeButton setBackgroundImage:Image(@"支付未同意") forState:UIControlStateNormal];
    [argreeButton setBackgroundImage:Image(@"支付同意") forState:UIControlStateSelected];
    [argreeButton addTarget:self action:@selector(isArgree:) forControlEvents:UIControlEventTouchUpInside];
    [_buyView addSubview:argreeButton];
    //是否同意协议
    UILabel *argreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 110, BuyViewW, 20)];
    argreeLabel.text = @"我已同意支付方式";
    argreeLabel.font = Font(15);
    argreeLabel.textColor = [UIColor colorWithRed:145.f / 255 green:148.f / 255 blue:155.f / 255 alpha:1];
    [_buyView addSubview:argreeLabel];
    
    //添加几个按钮
    NSArray *titleString = @[@"支付宝",@"微信",@"取消"];
    CGFloat ButtonW = (BuyViewW - 6 * SpaceBaside) / 3;
    
    for (int i = 0 ; i < 3; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SpaceBaside + (2 * SpaceBaside + ButtonW) * i , 150 ,ButtonW, 35)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:titleString[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:145.f / 255 green:148.f / 255 blue:155.f / 255 alpha:1] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:232.f / 255 green:235.f / 255 blue:243.f / 255 alpha:1];
        button.layer.cornerRadius = 5;
        button.tag = 1104 + i;
        
        [button addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
        [_buyView addSubview:button];
        _buyView.frame = CGRectMake(0, 0, BuyViewW, CGRectGetMaxY(button.frame) + SpaceBaside);
        _buyView.center = self.view.center;
    }
    _poptableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    _poptableView.delegate = self;
    _poptableView.dataSource = self;
    _poptableView.rowHeight = 50;
    _poptableView.tag = 1230;
    _poptableView.backgroundColor = [UIColor whiteColor];
    _frame = CGRectMake(counpLabel.current_x, counpLabel.current_y_h, counpLabel.current_w, 300);
    [_buyView addSubview:_poptableView];
    
    //这里获取优惠券的数据
    [self NetWorkGetMyCouponList];
    
}
- (void)counpButtonClick:(UIButton *)sender {
    
    if (!_counpArray.count) {
        [MBProgressHUD showError:@"没有可使用的优惠券" toView:self.view];
        return;
    }
    if (_poptableView) {
        if (_poptableView.frame.origin.x==0) {
            _poptableView.frame = _frame;
        }else{
            _poptableView.frame = CGRectMake(0, 0, 0, 0);
        }
    }
}

#pragma mark --- 支付同意
- (void)isArgree:(UIButton *)button {
    
    if (isArgree == NO) {
        
        isArgree = YES;
        [button setBackgroundImage:Image(@"支付同意") forState:UIControlStateNormal];
    } else if (isArgree == YES) {
        
        isArgree = NO;
        [button setBackgroundImage:Image(@"支付未同意") forState:UIControlStateNormal];
    }
}
#pragma mark --- 获取优惠券的类型

- (void)NetWorkGetMyCouponList {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    QKHTTPManager *manager = [QKHTTPManager manager];
    
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    [dic setValue:_ID forKey:@"teacher"];
    
    [manager getpublicPort:dic mod:@"Live" act:@"getCanUseCouponList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            
            _counpArray = responseObject[@"data"];
            _counpArray = nil;
        } else {
            _counpArray = nil;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

-(void)selectSource:(UIButton *)sender{
    
    [self.view endEditing:YES];
    [_popV setHidden:YES];
    
    NSInteger tempN = sender.tag - 123;
    NSArray *arr = @[@"优",@"良",@"好"];
    
    if (_popV.tag == 1314) {
        
        _TF1.text = arr[tempN];
        _classStr = arr[tempN];
        
    }else if (_popV.tag == 1315){
        
        _TF2.text = arr[tempN];
        _shoukeStr = _TF1.text;
        
    }else if (_popV.tag == 1316){
        
        _TF3.text = arr[tempN];
        _zhuanyeStr = _TF1.text;
        
    }else{
        
        _TF4.text = arr[tempN];
        _taiduStr = _TF1.text;
    }
}

//轮播图的按钮点击事件
-(void)touchBtn:(UIButton *)sender{
    [self.view endEditing:YES];

    NSInteger tempNum = sender.tag - 100;
    
    NSLog(@"%@",_LBDataArr[tempNum]);
    NSString *Title = _LBDataArr[tempNum][@"video_title"];
    classDetailVC *cvc = [[classDetailVC alloc]initWithMemberId:_LBDataArr[tempNum][@"id"] andPrice:_LBDataArr[tempNum][@"v_price"] andTitle:Title];
    cvc.img = _LBDataArr[tempNum][@"imageurl"];
    [self.navigationController pushViewController:cvc animated:YES];
    
}

-(void)moveBtn:(UIButton *)sender{
    
    [self.view endEditing:YES];
    NSInteger tempNum = sender.tag - 100;
    int num = _colorLineLable.current_y;
    [UIView animateWithDuration:0.2 animations:^{
        
        _colorLineLable.frame = CGRectMake(tempNum*MainScreenWidth/4, num, MainScreenWidth/4, 3);
        _lastScrollow.contentOffset = CGPointMake(MainScreenWidth*tempNum, 0);
        
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (_popV) {
        
        [_popV setHidden:YES];
    }
}

//实现代理方法
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController*)controller{
    //返回UIModalPresentationNone为不匹配
    return UIModalPresentationNone;
}

//点击蒙版是否消失，默认为yes；

-(BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    
    return YES;
}

- (void)backPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
