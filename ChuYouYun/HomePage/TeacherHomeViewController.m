//
//  TeacherHomeViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/5/15.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "TeacherHomeViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"
#import "Passport.h"

#import "classDetailVC.h"
#import "GLClassViewController.h"
#import "LiveDetailsViewController.h"





@interface TeacherHomeViewController ()

@property (strong ,nonatomic)UIScrollView *scrollView;
@property (strong ,nonatomic)UIView       *addressView;
@property (strong ,nonatomic)UIView       *classView;
@property (strong ,nonatomic)UIView       *photoView;
@property (strong ,nonatomic)UIView       *articeView;
@property (strong ,nonatomic)UIView       *detailView;

@property (strong ,nonatomic)NSString *ID;
@property (strong ,nonatomic)NSDictionary *teacherDic;
@property (strong ,nonatomic)NSMutableArray     *classArray;
@property (strong ,nonatomic)NSMutableArray     *photoArray;
@property (strong ,nonatomic)NSMutableArray     *articleArray;


@end

@implementation TeacherHomeViewController

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
    [self NetWorkGetTeacherInfo];
//    [self netWorkGetClass];
//    [self netWorkPhoto];
//    [self netWorkArticle];
}


- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}


- (void)addAddessView {
    
    
    _addressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 80)];
    _addressView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_addressView];
    
    
    NSLog(@"%@",_teacherDic);
    NSArray *arr = @[@"所在地",@"授课方式"];
    NSString *adress;
    if ([_teacherDic[@"ext_info"][@"location"] isKindOfClass:[NSNull class]]) {
        adress = @"";
    }else if (_teacherDic[@"ext_info"][@"location"] == nil){
        adress = @"";
    }else{
        adress = [NSString stringWithFormat:@"%@",_teacherDic[@"ext_info"][@"location"]];
    }
    NSString *skill = [NSString stringWithFormat:@"%@",_teacherDic[@"teach_way"]];
    
    if (_teacherDic == nil) {
        skill = @"";
    } else {
        if ([skill integerValue] == 2) {
            skill = @"线下授课";
        }else if ([skill integerValue] == 3){
            skill = @"线上线下均可";
        } else {
            skill = @"线上授课";
        }
    }
    
    NSArray *placedarr = @[adress,skill,skill,skill];
    for (int i=0; i<2; i++) {
        
        UILabel *firstLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0+40*i, 100, 40)];
        [_addressView addSubview:firstLab];
        firstLab.text = arr[i];
        firstLab.textColor = [UIColor grayColor];
        firstLab.font = Font(15);
        firstLab.textAlignment = NSTextAlignmentLeft;
        
        UILabel *line;
        if (i>=2) {
        }else{
            
            UILabel *secondLab = [[UILabel alloc]initWithFrame:CGRectMake(115, 0+40*i, MainScreenWidth - 130, 40)];
            [self.view addSubview:secondLab];
            secondLab.text = placedarr[i];
            secondLab.textColor = [UIColor blackColor];
            secondLab.font = Font(14);
            secondLab.textAlignment = NSTextAlignmentLeft;
            line = [[UILabel alloc]initWithFrame:CGRectMake(15, 0+40*(i+1), MainScreenWidth - 30, 0.5)];
        }
        [_addressView addSubview:line];
        line.backgroundColor = [UIColor grayColor];
        line.alpha = 0.6;
    }
    

}


//课程轮播图
-(void)addClassView{
    
    
    _classView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_addressView.frame) + 10, MainScreenWidth, 200*MainScreenWidth/320)];
    _classView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_classView];
    
    UILabel *leftColorLab = [[UILabel alloc]initWithFrame:CGRectMake(10,10, 5, 20*MainScreenWidth/320)];
    [_classView addSubview:leftColorLab];
    leftColorLab.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    
    //课程
    //名字
    UILabel *clessLab = [[UILabel alloc]initWithFrame:CGRectMake(22, leftColorLab.current_y, 180, 20*MainScreenWidth/320)];
    [_classView addSubview:clessLab];
    clessLab.textColor = [UIColor colorWithHexString:@"#333333"];
    clessLab.text = @"TA的课程";
    clessLab.font = Font(14*MainScreenWidth/320);
    clessLab.textAlignment = NSTextAlignmentLeft;
    
    UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(MainScreenWidth - 10-60*MainScreenWidth/320, clessLab.current_y , 60*MainScreenWidth/320, 20*MainScreenWidth/320)];
    [_classView addSubview:moreBtn];
    [moreBtn setTitle:@"更多课程" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = Font(13*MainScreenWidth/320);
    [moreBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    moreBtn.tag = 1;
    [moreBtn addTarget:self action:@selector(typeMoreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //添加View
    for (int i = 0 ; i < _classArray.count ; i ++) {
        NSInteger Num = 3;
        CGFloat viewW = (MainScreenWidth - SpaceBaside * (Num + 1)) / Num;
        CGFloat viewH = viewW * 1.2;
        
        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(SpaceBaside + SpaceBaside * i + viewW * i + (i / Num) * SpaceBaside,50, viewW, viewH)];
        if (iPhone5o5Co5S) {
            buttonView.frame = CGRectMake(SpaceBaside + SpaceBaside * i + viewW * i + (i / Num) * SpaceBaside,50, viewW, 120);
        }
        buttonView.layer.cornerRadius = 5;
        buttonView.layer.masksToBounds = YES;
        buttonView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        buttonView.layer.borderWidth = 2;
        buttonView.backgroundColor = [UIColor whiteColor];
        [_classView addSubview:buttonView];
        
        
        //在View 上面添加东西
        UIImageView *buttonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH / 2)];
        NSString *urlStr = [[_classArray objectAtIndex:i] stringValueForKey:@"imageurl"];
        [buttonImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
        [buttonView addSubview:buttonImageView];
        
        //添加介绍
        UILabel *nameButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside,viewW / 2 + SpaceBaside, viewW - 2 * SpaceBaside, 50)];
        nameButtonLabel.text = [[_classArray objectAtIndex:i] stringValueForKey:@"video_title"];
        nameButtonLabel.numberOfLines = 2;
        nameButtonLabel.font = Font(14);
        nameButtonLabel.textColor = BlackNotColor;
        [buttonView addSubview:nameButtonLabel];
        
        //添加价格
        UILabel *priceButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, viewW / 2 + 50, viewW - SpaceBaside * 2, 20)];
        
        if ([[[_classArray objectAtIndex:i] stringValueForKey:@"v_price"] integerValue] == 0) {
            priceButtonLabel.text = @"免费";
            priceButtonLabel.textColor = [UIColor greenColor];
        } else {
            priceButtonLabel.text = [NSString stringWithFormat:@"￥%@",[[_classArray objectAtIndex:i] stringValueForKey:@"t_price"]];
            priceButtonLabel.textColor = [UIColor redColor];
        }
        priceButtonLabel.font = Font(14);
        [buttonView addSubview:priceButtonLabel];
        
        
        //往View 上面添加button
        UIButton *viewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(buttonView.frame), CGRectGetHeight(buttonView.frame))];
        viewButton.backgroundColor = [UIColor clearColor];
        viewButton.tag = i;
        [viewButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:viewButton];
        
    }
    if (_classArray.count == 0) {
        UILabel *noneLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 40, MainScreenWidth - 2 * SpaceBaside, 20)];
        noneLabel.text = @"暂无课程";
        noneLabel.textColor = [UIColor grayColor];
        [_classView addSubview:noneLabel];
        
        _classView.frame = CGRectMake(0,  CGRectGetMaxY(_addressView.frame) + SpaceBaside, MainScreenWidth, 70);
    }
}

- (void)addPhotoView {
    _photoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_classView.frame) + 10, MainScreenWidth, 200)];
    _photoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_photoView];
    
    
    UILabel *leftColorLab = [[UILabel alloc]initWithFrame:CGRectMake(10,10, 5, 20*MainScreenWidth/320)];
    [_photoView addSubview:leftColorLab];
    leftColorLab.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    
    //课程
    //名字
    UILabel *clessLab = [[UILabel alloc]initWithFrame:CGRectMake(22, leftColorLab.current_y, 180, 20*MainScreenWidth/320)];
    [_photoView addSubview:clessLab];
    clessLab.textColor = [UIColor colorWithHexString:@"#333333"];
    clessLab.text = @"TA的相册";
    clessLab.font = Font(14*MainScreenWidth/320);
    clessLab.textAlignment = NSTextAlignmentLeft;
    
    UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(MainScreenWidth - 10-60*MainScreenWidth/320, clessLab.current_y , 60*MainScreenWidth/320, 20*MainScreenWidth/320)];
    [_photoView addSubview:moreBtn];
    [moreBtn setTitle:@"更多相册" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = Font(13*MainScreenWidth/320);
    [moreBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    moreBtn.tag = 2;
    [moreBtn addTarget:self action:@selector(typeMoreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    

    for (int i = 0; i< _photoArray.count; i++) {
        
        NSInteger Num = 3;
        CGFloat viewW = (MainScreenWidth - SpaceBaside * (Num + 1)) / Num;
        CGFloat viewH = viewW * 1.2;
        
        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(SpaceBaside + SpaceBaside * i + viewW * i + (i / Num) * SpaceBaside,40, viewW, viewH)];
        if (iPhone5o5Co5S) {
            buttonView.frame = CGRectMake(SpaceBaside + SpaceBaside * i + viewW * i + (i / Num) * SpaceBaside,40, viewW, 120);
        }
        buttonView.layer.cornerRadius = 5;
        buttonView.layer.masksToBounds = YES;
        buttonView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        buttonView.layer.borderWidth = 2;
        buttonView.backgroundColor = [UIColor whiteColor];
        [_photoView addSubview:buttonView];
        
        
        //在View 上面添加东西
        UIImageView *buttonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH / 2)];
        NSString *urlStr = [[_photoArray objectAtIndex:i] stringValueForKey:@"cover"];
        [buttonImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
        [buttonView addSubview:buttonImageView];
        
        //添加介绍
        UILabel *nameButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside,viewW / 2 + SpaceBaside, viewW - 2 * SpaceBaside, 50)];
        nameButtonLabel.text = [[_photoArray objectAtIndex:i] stringValueForKey:@"title"];
        nameButtonLabel.numberOfLines = 2;
        nameButtonLabel.font = Font(14);
        nameButtonLabel.textColor = BlackNotColor;
        [buttonView addSubview:nameButtonLabel];
        
        //往View 上面添加button
        UIButton *viewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(buttonView.frame), CGRectGetHeight(buttonView.frame))];
        viewButton.backgroundColor = [UIColor clearColor];
        viewButton.tag = i;
        [viewButton addTarget:self action:@selector(photoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:viewButton];

    }

    
    if (_photoArray.count == 0) {
        UILabel *noneLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 40, MainScreenWidth - 2 * SpaceBaside, 20)];
        noneLabel.text = @"暂无相册";
        noneLabel.textColor = [UIColor grayColor];
        [_photoView addSubview:noneLabel];
        _photoView.frame = CGRectMake(0, CGRectGetMaxY(_classView.frame), MainScreenWidth, 80);
    }
    
    
    
    
}


- (void)addArticeView {
    
    _articeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_photoView.frame) + 20, MainScreenWidth, 180)];
    _articeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_articeView];
    
    
    UILabel *leftColorLab = [[UILabel alloc]initWithFrame:CGRectMake(10,10, 5, 20*MainScreenWidth/320)];
    [_articeView addSubview:leftColorLab];
    leftColorLab.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    
    //课程
    //名字
    UILabel *clessLab = [[UILabel alloc]initWithFrame:CGRectMake(22, leftColorLab.current_y, 180, 20*MainScreenWidth/320)];
    [_articeView addSubview:clessLab];
    clessLab.textColor = [UIColor colorWithHexString:@"#333333"];
    clessLab.text = @"TA的文章";
    clessLab.font = Font(14*MainScreenWidth/320);
    clessLab.textAlignment = NSTextAlignmentLeft;
    
    UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(MainScreenWidth - 10-60*MainScreenWidth/320, clessLab.current_y , 60*MainScreenWidth/320, 20*MainScreenWidth/320)];
    [_articeView addSubview:moreBtn];
    [moreBtn setTitle:@"更多文章" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = Font(13*MainScreenWidth/320);
    [moreBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    moreBtn.tag = 3;
    [moreBtn addTarget:self action:@selector(typeMoreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSInteger tempNum = _articleArray.count;
    if (tempNum>2) {
        tempNum = 2;
    }
    for (int i =0; i<tempNum; i++) {
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40 + (60 + 3) * i, 60, 60)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[_articleArray objectAtIndex:i] stringValueForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"站位图"]];
        [_articeView addSubview:imageView];
        
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(80, 40 + 60 * i, MainScreenWidth - 100, 20)];
        title.font = [UIFont systemFontOfSize:17];
        title.textColor = [UIColor blackColor];
        title.text = [NSString stringWithFormat:@"%@",[[_articleArray objectAtIndex:i] stringValueForKey:@"art_title"]];
        title.numberOfLines = 2;
        [_articeView addSubview:title];
        
        
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(80, 70 + 60 * i, MainScreenWidth - 100, 20)];
        time.text = [NSString stringWithFormat:@"%@",[[_articleArray objectAtIndex:i] stringValueForKey:@"art_title"]];
        NSString *starTime = [Passport formatterDate:[[_articleArray objectAtIndex:i] stringValueForKey:@"ctime"]];
        time.text = [NSString stringWithFormat:@"%@",starTime];
        time.textColor = [UIColor grayColor];
        time.font = Font(14);
        [_articeView addSubview:time];
    }
    
    
    if (_articleArray.count == 0) {
        UILabel *noneLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 40, MainScreenWidth - 2 * SpaceBaside, 20)];
        noneLabel.text = @"暂无文章";
        noneLabel.textColor = [UIColor grayColor];
        [_articeView addSubview:noneLabel];
        _articeView.frame = CGRectMake(0, CGRectGetMaxY(_photoView.frame), MainScreenWidth, 80);
    } else if (_articleArray.count == 1) {
        _articeView.frame = CGRectMake(0, CGRectGetMaxY(_photoView.frame), MainScreenWidth, 100);
    }
    
    
    
}

- (void)addDetailView {
    _detailView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_articeView.frame) + 30, MainScreenWidth, 100)];
    _detailView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_detailView];
    
    
    UILabel *leftColorLab = [[UILabel alloc]initWithFrame:CGRectMake(10,10, 5, 20*MainScreenWidth/320)];
    [_detailView addSubview:leftColorLab];
    leftColorLab.backgroundColor = [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1];
    
    //名字
    UILabel *clessLab = [[UILabel alloc]initWithFrame:CGRectMake(22, leftColorLab.current_y, 180, 20*MainScreenWidth/320)];
    [_detailView addSubview:clessLab];
    clessLab.textColor = [UIColor colorWithHexString:@"#333333"];
    clessLab.text = @"更多详情";
    clessLab.font = Font(14*MainScreenWidth/320);
    clessLab.textAlignment = NSTextAlignmentLeft;
    
    
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, MainScreenWidth - 20, 30)];
    infoLabel.backgroundColor = [UIColor whiteColor];
    infoLabel.font = Font(13);

    if (_teacherDic[@"inro"] == nil || [_teacherDic[@"inro"] isEqual:[NSNull null]]) {
        infoLabel.text = @"暂无详情";
        infoLabel.font = Font(17);
        infoLabel.textColor = [UIColor grayColor];
    } else {
        infoLabel.text = _teacherDic[@"inro"];
    }
    infoLabel.numberOfLines = 0;

    CGRect labelSize = [infoLabel.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
    infoLabel.frame = CGRectMake(10, 50,  MainScreenWidth - 20, labelSize.size.height);
    [_detailView addSubview:infoLabel];
    
    _detailView.frame = CGRectMake(0, CGRectGetMaxY(_articeView.frame), MainScreenWidth, labelSize.size.height + 50);
    NSLog(@"%lf",_detailView.frame.size.height);
    
    
    double getHigt = CGRectGetMaxY(_detailView.frame) + 20;
    NSString *higtStr = [NSString stringWithFormat:@"%lf",getHigt];
    
    //这里要传个通知到 主界面去
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TeacherHomeScrollHight" object:higtStr];
}

#pragma mark --- 事件点击

- (void)typeMoreButtonClick:(UIButton *)button {//点击更多
    
    if (button.tag == 1) {//进入更多界面
        GLClassViewController *glVc = [[GLClassViewController alloc]initWithData:_classArray title:[NSString stringWithFormat:@"%@",@""] teacher_id:_ID];
        [self.navigationController pushViewController:glVc animated:YES];
    } else {
        NSString *mainVcSet = [NSString stringWithFormat:@"%ld",button.tag];
        //这里就需要发送通知了
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TeacherHomeMoreButtonCilck" object:mainVcSet];
    }
    
}

- (void)imageButtonClick:(UIButton *)button {//点击课程
    NSInteger buttonTag = button.tag;
    
    NSString *type = _classArray[buttonTag][@"type"];
    if ([type integerValue] == 1) {
        
        NSString *Cid = [[_classArray objectAtIndex:buttonTag] stringValueForKey:@"id"];
        NSString *Price = [[_classArray objectAtIndex:buttonTag] stringValueForKey:@"price"];
        NSString *Title = [[_classArray objectAtIndex:buttonTag] stringValueForKey:@"video_title"];
        NSString *VideoAddress = [[_classArray objectAtIndex:buttonTag] stringValueForKey:@"video_address"];
        NSString *ImageUrl = [[_classArray objectAtIndex:buttonTag] stringValueForKey:@"imageurl"];
        
        
        classDetailVC * classDetailVc = [[classDetailVC alloc]initWithMemberId:Cid andPrice:Price andTitle:Title];
        classDetailVc.videoTitle = Title;
        classDetailVc.img = ImageUrl;
        classDetailVc.video_address = VideoAddress;
        [self.navigationController pushViewController:classDetailVc animated:YES];
        
    } else if ([type integerValue] == 2) {
        
        NSString *address = [[_classArray objectAtIndex:buttonTag] stringValueForKey:@"video_address"];
        NSString *Cid = [NSString stringWithFormat:@"%@",[[_classArray objectAtIndex:buttonTag] stringValueForKey:@"id"]];
        if (address == nil) {
            [MBProgressHUD showError:@"直播为空" toView:self.view];
            return;
        }
        NSString *Price = [[_classArray objectAtIndex:buttonTag] stringValueForKey:@"price"];
        NSString *Title = [[_classArray objectAtIndex:buttonTag] stringValueForKey:@"video_title"];
        NSString *ImageUrl = [[_classArray objectAtIndex:buttonTag] stringValueForKey:@"imageurl"];
        
        LiveDetailsViewController *cvc = [[LiveDetailsViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)buttonTag andprice:Price];
        [self.navigationController pushViewController:cvc animated:YES];
    }

    
}

- (void)photoButtonClick:(UIButton *)button {
    //这里发送通知到主页
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TeacherHomeMoveToPhoto" object:@"1"];
    
}



#pragma mark --- 网络请求

-(void)NetWorkGetTeacherInfo {
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_ID forKey:@"teacher_id"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {
    } else {
        [dic setObject:UserOathToken forKey:@"oauth_token"];
        [dic setObject:UserOathTokenSecret forKey:@"oauth_token_secret"];
    }
    
    NSLog(@"%@",_ID);
    [manager getpublicPort:dic mod:@"Teacher" act:@"getTeacher" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        _teacherDic = [NSMutableDictionary dictionary];
        
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            _teacherDic = responseObject[@"data"];
        }
        [self addAddessView];
//        [self addClassView];
        [self netWorkGetClass];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"请求失败，检查网络" toView:self.view];
        [self addAddessView];
        [self addClassView];
    }];
}


//获取课程的数据
-(void)netWorkGetClass {
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setValue:_ID forKey:@"teacher_id"];
    _classArray = [NSMutableArray array];
    
    [manager getpublicPort:dic mod:@"Teacher" act:@"teacherVideoList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            [_classArray addObjectsFromArray:responseObject[@"data"]];
            [self addClassView];
        } else {
        }
        [self addClassView];
        [self netWorkPhoto];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"请求失败，检查网络" toView:self.view];
        [self addClassView];
    }];
}


//获取相册数据
-(void)netWorkPhoto {
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    //临时的
    [dic setValue:_ID forKey:@"teacher_id"];
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"20" forKey:@"count"];
    _photoArray = [NSMutableArray array];
    [manager getpublicPort:dic mod:@"Teacher" act:@"getTeacherPhotos" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"相册-----%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1) {
            [_photoArray addObjectsFromArray:responseObject[@"data"]];
            NSLog(@"%@",_photoArray);
            
            NSMutableArray *marr = [NSMutableArray array];
            for (int i = 0; i<_photoArray.count; i++) {
                if ([_photoArray[i][@"cover"] length]) {
                    [marr addObject:_photoArray[i][@"cover"]];
                }
            }
        } else {
        }
        [self addPhotoView];
        [self netWorkArticle];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"请求失败，检查网络" toView:self.view];
        [self addPhotoView];
    }];
}


-(void)netWorkArticle {
    QKHTTPManager * manager = [QKHTTPManager manager];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    //临时的
    [dic setValue:_ID forKey:@"teacher_id"];
    [dic setValue:@"1" forKey:@"page"];
    [dic setValue:@"20" forKey:@"count"];
    _articleArray = [NSMutableArray array];
    
    [manager getpublicPort:dic mod:@"Teacher" act:@"getArticleList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1) {
            [_articleArray addObjectsFromArray:responseObject[@"data"]];
        } else {
        }
        [self addArticeView];
        [self addDetailView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"请求失败，检查网络" toView:self.view];
        [self addArticeView];
        [self addDetailView];
    }];
}




@end
